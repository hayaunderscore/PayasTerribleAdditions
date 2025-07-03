-- General purpose utilities

-- Talisman,,,,
to_big = to_big or function(a) return a end
is_number = is_number or function(a) return type(a) == "number" end

-- Misprintize stuff --

-- Loosely based on Cryptid's misprintize.lua
PTASaka.BaseValues = {}
PTASaka.MisprintizeForbidden = {
	["id"] = true,
	["ID"] = true,
	["sort_id"] = true,
	["perish_tally"] = true,
	["colour"] = true,
	["suit_nominal"] = true,
	["base_nominal"] = true,
	["face_nominal"] = true,
	["qty"] = true,
	["selected_d6_face"] = true,
	["h_x_mult"] = true,
	["h_x_chips"] = true,
	["d_size"] = true,
	["h_size"] = true,
	["immutable"] = true,
	--["x_mult"] = true,
}

--- Sanity checker for tables.
--- @param tbl table|nil Table to set to val if nil.
--- @param val table|nil Table to set `tbl` to if `tbl` is nil.
--- @return table
function PTASaka.sanitycheck(tbl, val)
	if val == nil then val = {} end
	if tbl == nil then tbl = val end
	return tbl
end

--- Standard deep copy function that all of you already know how to use so I'm not providing annotations
function PTASaka.deep_copy(obj, seen)
	if type(obj) ~= "table" then
		return obj
	end
	if seen and seen[obj] then
		return seen[obj]
	end
	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))
	s[obj] = res
	for k, v in pairs(obj) do
		res[PTASaka.deep_copy(k, s)] = PTASaka.deep_copy(v, s)
	end
	return res
end

-- mmm shallow....
function PTASaka.shallow_copy(t)
	local t2 = {}
	for k, v in pairs(t) do
		t2[k] = v
	end
	return t2
end

-- Vash destroy contexts
---@param card Card
---@return boolean
function PTASaka.VashDestroyable(card)
	-- No.
	if G.PAYASAKA_IGNORE_VASH_SENTIMENT then return false end
	-- Sold card, proceed with destruction
	if G.CONTROLLER.locks.selling_card then return false end
	-- Food joker
	if card.config.center.pools and card.config.center.pools["Food"] then return false end
	-- Food joker not in the Food pool, just in case
	if card.children.center.pinch.x then return false end
	-- Otherwise...
	return card.area == G.jokers or card.area == G.consumeables or card.area == G.payasaka_dos_cardarea or
	(card.area == G.hand and (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.PLAY_TAROT)) or
	(card.area == G.play and G.STATE == G.STATES.HAND_PLAYED)
end

-- Check if Vash should destroy a Joker
---@param card Card
---@param no_dissolve? boolean
---@return boolean
function PTASaka.VashDestroy(card, no_dissolve)
	local stop_removal = false
	-- Check for Vash
	if next(SMODS.find_card('j_payasaka_vash')) and card.config.center_key ~= "j_payasaka_vash" and PTASaka.VashDestroyable(card) and not no_dissolve then
		local ret = {}
		SMODS.calculate_context({ payasaka_card_removed = true, card = card }, ret); SMODS.trigger_effects(ret)
		for k, v in ipairs(ret) do
			for _k, _v in pairs(v) do
				stop_removal = _v.prevent_remove or stop_removal
			end
		end
	end
	return stop_removal
end

-- Loosely based on https://github.com/balt-dev/Inkbleed/blob/trunk/modules/misprintize.lua
-- Specifically for non random values
---@param val any Value to be modified. Recursive.
---@param amt? any Value to be used with `value`. See `func`. Defaults to 1.
---@param reference? table Reference table to check previous values edited by this function. Defaults to an empty table.
---@param key? any Key of the current table used, if `val` is a table. Defaults to "1".
---@param func? fun(value: any, amount: any): any Function used to modify `val` with `amt`. Uses multiplication if not specified.
---@param whitelist? table<any, boolean> Whitelisted keys for tables. If not specified, uses `blacklist`.
---@param blacklist? table<any, boolean> Blacklisted keys for tables. If not specified, uses a default blacklist.
---@param layer? number Layer of current table for recursive checking, if `val` is a table. Defaults to 0.
---@param blacklist_key? fun(key: any, value: any, layer: number): boolean Additional blacklist function, taking in the key, value and layer as parameters. Defaults to a function for checking `x_mult` and `x_chips` for the ability table.
---@return any val Value modified.
function PTASaka.MMisprintize(val, amt, reference, key, func, whitelist, blacklist, layer, blacklist_key)
	reference = reference or {}
	key = key or "1"
	amt = amt or 1
	func = func or function(v, a)
		return v * a
	end
	layer = layer or 0
	blacklist_key = blacklist_key or function(k, v, l)
		if v == 1 and l == 1 then
			if k == "x_mult" or k == "x_chips" then
				return false
			end
		end
		return true
	end
	blacklist = blacklist or PTASaka.MisprintizeForbidden
	-- Forbidden, skip it
	if blacklist[key] then return val end
	if (whitelist and whitelist[key]) or not whitelist then
		local t = type(val)
		--if is_number(val) then print("key: "..key.." val: "..val.." layer: "..layer) end
		if is_number(val) and blacklist_key(key, val, layer) then
			reference[key] = val
			return func(val, amt)
		elseif t == "table" then
			local k, v = next(val, nil)
			while k ~= nil do
				val[k] = PTASaka.MMisprintize(v, amt, reference[key], k, func, whitelist, blacklist, layer + 1,
					blacklist_key)
				k, v = next(val, k)
			end
		end
	end
	return val
end

---@class MisprintizeContext
---@field val any Value to be modified. Recursive.
---@field amt? any Value to be used with `value`. See `func`. Defaults to 1.
---@field reference? table Reference table to check previous values edited by this function. Defaults to an empty table.
---@field key? any Key of the current table used, if `val` is a table. Defaults to "1".
---@field func? fun(value: any, amount: any): any Function used to modify `val` with `amt`. Uses multiplication if not specified.
---@field whitelist? table<any, boolean> Whitelisted keys for tables. If not specified, uses `blacklist`.
---@field blacklist? table<any, boolean> Blacklisted keys for tables. If not specified, uses a default blacklist.
---@field layer? number Layer of current table for recursive checking, if `val` is a table. Defaults to 0.
---@field blacklist_key? fun(key: any, value: any, layer: number): boolean Additional blacklist function, taking in the key, value and layer as parameters. Defaults to a function for checking `x_mult` and `x_chips` for the ability table.

-- The above, but with the parameters as a table instead.
-- In short, misprintizes values by multiplication or a specified `func` function.
---@param t MisprintizeContext Misprintize parameters.
---@return any val Return value.
function PTASaka.Misprintize(t)
	t = t or {}
	assert(t.val, "PTASaka.Misprintize: Value not provided!")
	assert(t.amt, "PTASaka.Misprintize: Amount not provided!")
	return PTASaka.MMisprintize(t.val, t.amt, t.reference, t.key, t.func, t.whitelist, t.blacklist, t.layer,
		t.blacklist_key)
end

-- Taken from Cryptid...
---@param card Card
---@param func fun(card: Card): any
---@return any
function PTASaka.with_deck_effects(card, func)
	if not card.added_to_deck then
		return func(card)
	else
		card:remove_from_deck(true)
		local ret = func(card)
		card:add_to_deck(true)
		return ret
	end
end

---Photocopy util function.
---@param jkr Card
---@param mult number
---@param unphotocopy boolean
---@param id number
function PTASaka.Photocopy(jkr, mult, unphotocopy, id)
	local mul = mult
	if unphotocopy == true then mul = 1 / mult end
	-- Otherwise, use ours
	PTASaka.with_deck_effects(jkr, function(jkr)
		local key = jkr.config.center_key
		PTASaka.BaseValues[key] = PTASaka.BaseValues[key] or {}
		jkr.ability = PTASaka.MMisprintize(jkr.ability, mul, PTASaka.BaseValues, key)
		--jkr.ability.extra = PTASaka.MisprintizeTable(jkr.config.center_key, jkr.ability.extra, nil, mul, true)
		jkr.ability.immutable.payasaka_photocopied[id] = not unphotocopy
	end)
end

-- Load all files in a folder
---@param path string Path to a folder.
function PTASaka.RequireFolder(path)
	local files = NFS.getDirectoryItemsInfo(PTASaka.Mod.path .. "/" .. path)
	for i = 1, #files do
		local file_name = files[i].name
		if file_name:sub(-4) == ".lua" then
			assert(SMODS.load_file(path .. file_name))()
		end
	end
end

-- Additional property for cards to be considered as 'Ahead'
---@return boolean
function Card:is_ahead()
	if next(SMODS.find_card("j_payasaka_niveusterras")) then return true end
	if self.ability.name == "Arrowhead" then return true end
	if self.config and self.config.center and type(self.config.center.rarity) == 'string' and self.config.center.rarity == "payasaka_ahead" then return true end
	if self.config and self.config.center and type(self.config.center.rarity) == 'string' and self.config.center.rarity == "payasaka_daeha" then return true end
	return false
end

-- Food pool
-- Already used by Cryptid, only here if Cryptid is not available....
if not G.P_CENTER_POOLS["Food"] then
	SMODS.ObjectType {
		key = "Food",
		default = "j_gros_michel",
		cards = {},
		inject = function(self)
			SMODS.ObjectType.inject(self)
			-- insert base game food jokers
			self:inject_card(G.P_CENTERS.j_gros_michel)
			self:inject_card(G.P_CENTERS.j_egg)
			self:inject_card(G.P_CENTERS.j_ice_cream)
			self:inject_card(G.P_CENTERS.j_cavendish)
			self:inject_card(G.P_CENTERS.j_turtle_bean)
			self:inject_card(G.P_CENTERS.j_diet_cola)
			self:inject_card(G.P_CENTERS.j_popcorn)
			self:inject_card(G.P_CENTERS.j_ramen)
			self:inject_card(G.P_CENTERS.j_selzer)
		end,
	}
end

-- Friend pool
SMODS.ObjectType {
	key = "Friend",
	default = "j_payasaka_suittaker",
	cards = {},
}

-- Creates a dummy card area for card storage<br>
-- Used by LAB=01, Mr. Cast and Irisu....
---@param id string String key to represent the card area, stored in G.
---@param limit? number Max number of cards. Defaults to 1e300.
---@param joker_id? number Joker sort id to represent card juice ups and messages. Defaults to -1.
---@return CardArea
function PTASaka.create_storage_area(id, limit, joker_id)
	assert(id, "PTASaka.create_storage_area: id needs to be specified!")
	limit = limit or 1e300

	G[id] = CardArea(0, 0, G.CARD_W * math.min(limit, 100), G.CARD_H,
		{ card_limit = limit, type = 'joker', highlight_limit = 0 })
	local dummy_area = G[id]
	-- dont display you fuck
	dummy_area.states.visible = false
	dummy_area.states.collide.can = false
	dummy_area.states.focus.can = false
	dummy_area.states.click.can = false
	dummy_area.config.joker_parent = joker_id or -1
	return dummy_area
end

--- Multipurpose arrow function for exponential stuff.
---@param arrow number Number of arrows. 0 is Multiplication.
---@param val1 number Value no. 1
---@param val2 number Value no. 2
---@param og_arrow? number Original `arrow` during recursive calls.
---@return number
function PTASaka.arrow(arrow, val1, val2, og_arrow)
	-- Small compat with Entropy
	if Entropy and G.GAME.hand_operator then
		G.GAME.hand_operator = (G.GAME.hand_operator or 0)
		return Entropy.get_chipmult_score(val1, val2)
	end
	og_arrow = og_arrow or 1
	local val = val1
	if arrow == 1 then
		-- Talisman calculates tetrations like this
		val = val ^ (og_arrow > 1 and (val2 - 1) or val2)
	elseif arrow == 0 then
		val = val * val2
	else
		val = val ^ PTASaka.arrow(arrow - 1, val, val2, arrow)
	end
	return val
end

-- Recursively create an extra table for each returned effect table
---@param table_return_table table
---@param index number
---@return table
function PTASaka.recursive_extra(table_return_table, index)
	index = index or 1
	local ret = table_return_table[index]
	if index <= #table_return_table then
		local function getDeepest(tbl)
			while tbl.extra do
				tbl = tbl.extra
			end
			return tbl
		end
		local prev = getDeepest(ret)
		prev.extra = PTASaka.recursive_extra(table_return_table, index + 1)
	end
	--if ret ~= nil and index == 1 then print(ret) end
	return ret
end

-- Copy of StrangeLib.make_boosters to get rid of StrangeLib requirement
function PTASaka.make_boosters(base_key, normal_poses, jumbo_poses, mega_poses, common_values, pack_size)
	pack_size = pack_size or 3
	for index, pos in ipairs(normal_poses) do
		local t = copy_table(common_values)
		t.key = base_key .. "_normal_" .. index
		t.pos = pos
		t.config = { extra = pack_size, choose = 1 }
		t.cost = 4
		SMODS.Booster(t)
	end
	for index, pos in ipairs(jumbo_poses) do
		local t = copy_table(common_values)
		t.key = base_key .. "_jumbo_" .. index
		t.pos = pos
		t.config = { extra = pack_size + 2, choose = 1 }
		t.cost = 6
		SMODS.Booster(t)
	end
	for index, pos in ipairs(mega_poses) do
		local t = copy_table(common_values)
		t.key = base_key .. "_mega_" .. index
		t.pos = pos
		t.config = { extra = pack_size + 2, choose = 2 }
		t.cost = 8
		SMODS.Booster(t)
	end
end

-- Funny soul aura >:)))
---@param c Card
function PTASaka.create_soul_aura_for_card(c)
	if not c.pta_trick_sprite then
		c.pta_trick_sprite_args = c.pta_trick_sprite_args or {
			intensity = 0,
			real_intensity = 0,
			intensity_vel = 0,
			colour_1 = G.C.UI_CHIPS,
			colour_2 = G.C.UI_CHIPLICK,
			timer = G.TIMERS.REAL
		}
		---@type Sprite
		c.pta_trick_sprite = Sprite(0, 0, c.T.w, c.T.h, G.ASSET_ATLAS["ui_1"],
			{ x = 2, y = 0 })
		c.pta_trick_sprite.states.hover.can = false
		c.pta_trick_sprite.states.click.can = false
		c.pta_trick_sprite.scale = { x = 1.2, y = 1.2 }
		c.pta_trick_sprite.role.offset = { x = -0.1, y = -0.2 }
		c.pta_trick_sprite:define_draw_steps({ {
			shader = 'flame',
			send = {
				{ name = 'time',            ref_table = c.pta_trick_sprite_args, ref_value = 'timer' },
				{ name = 'amount',          ref_table = c.pta_trick_sprite_args, ref_value = 'real_intensity' },
				{ name = 'image_details',   ref_table = c.pta_trick_sprite,      ref_value = 'image_dims' },
				{ name = 'texture_details', ref_table = c.pta_trick_sprite.RETS, ref_value = 'get_pos_pixel' },
				{ name = 'colour_1',        ref_table = c.pta_trick_sprite_args, ref_value = 'colour_1' },
				{ name = 'colour_2',        ref_table = c.pta_trick_sprite_args, ref_value = 'colour_2' },
				{ name = 'id',              val = c.pta_trick_sprite.ID },
			}
		} })
		c.pta_trick_sprite:get_pos_pixel()
	end
end

--- Creates an alias table for a table.
---@param val table<number, any>[]
---@return table
function PTASaka.create_alias_table(val)
	local total = 0
	for k, v in ipairs(val) do
		assert(v[2] >= 0, "Weight must not be negative")
		total = total + v[2]
	end
	assert(total > 0, "Total weights must be positive")
	local normalized = #val / total
	local norm = {}
	local small_stack = {}
	local big_stack = {}
	for i, w in ipairs(val) do
		norm[i] = w[2] * normalized
		if norm[i] < 1 then
			table.insert(small_stack, i)
		else
			table.insert(big_stack, i)
		end
	end

	local prob = {}
	local alias = {}
	while small_stack[1] and big_stack[1] do -- both non-empty
		small = table.remove(small_stack)
		large = table.remove(big_stack)
		prob[small] = norm[small]
		alias[small] = large
		norm[large] = norm[large] + norm[small] - 1
		if norm[large] < 1 then
			table.insert(small_stack, large)
		else
			table.insert(big_stack, large)
		end
	end

	for _, v in ipairs(big_stack) do prob[v] = 1 end
	for _, v in ipairs(small_stack) do prob[v] = 1 end

	local values = {}
	for k, v in ipairs(val) do
		values[k] = v[1]
	end

	return { alias = alias, prob = prob, n = #val, values = values }
end

function PTASaka.pseudorandom_alias_element(t, seed)
	local index = pseudorandom(seed, 1, t.n)
	index = pseudorandom(seed) < t.prob[index] and index or t.alias[index]
	return t.values[index]
end

-- Force triggering with Yomiel
PTASaka.VanillaJokerWhitelist = {
	["Joker"] = true,
	["Greedy Joker"] = true,
	["Lusty Joker"] = true,
	["Wrathful Joker"] = true,
	["Gluttonous Joker"] = true,
	["Jolly Joker"] = true,
	["Zany Joker"] = true,
	["Mad Joker"] = true,
	["Crazy Joker"] = true,
	["Droll Joker"] = true,
	["Sly Joker"] = true,
	["Wily Joker"] = true,
	["Clever Joker"] = true,
	["Devious Joker"] = true,
	["Crafty Joker"] = true,
	["Half Joker"] = true,
	["Joker Stencil"] = true,
	["Ceremonial Dagger"] = true,
	["Banner"] = true,
	["Mystic Summit"] = true,
	["Marble Joker"] = true,
	["Loyalty Card"] = true,
	["8 Ball"] = true,
	["Misprint"] = true,
	["Raised Fist"] = true,
	["Fibonacci"] = true,
	["Steel Joker"] = true,
	["Scary Face"] = true,
	["Abstract Joker"] = true,
	["Delayed Gratification"] = true,
	["Gros Michel"] = true,
	["Even Steven"] = true,
	["Odd Todd"] = true,
	["Scholar"] = true,
	["Business Card"] = true,
	["Supernova"] = true,
	["Ride the Bus"] = true,
	["Space Joker"] = true,
	["Egg"] = true,
	["Burglar"] = true,
	["Blackboard"] = true,
	["Runner"] = true,
	["Ice Cream"] = true,
	["DNA"] = true,
	["Blue Joker"] = true,
	["Sixth Sense"] = true,
	["Constellation"] = true,
	["Hiker"] = true,
	["Faceless Joker"] = true,
	["Green Joker"] = true,
	["Superposition"] = true,
	["To Do List"] = true,
	["Cavendish"] = true,
	["Card Sharp"] = true,
	["Red Card"] = true,
	["Madness"] = true,
	["Square Joker"] = true,
	["Seance"] = true,
	["Riff-Raff"] = true,
	["Vampire"] = true,
	["Hologram"] = true,
	["Vagabond"] = true,
	["Baron"] = true,
	["Cloud 9"] = true,
	["Rocket"] = true,
	["Obelisk"] = true,
	["Midas Mask"] = true,
	["Luchador"] = true,
	["Photograph"] = true,
	["Gift Card"] = true,
	["Turtle Bean"] = true,
	["Erosion"] = true,
	["Reserved Parking"] = true,
	["Mail-In Rebate"] = true,
	["Hallucination"] = true,
	["Fortune Teller"] = true,
	["Juggler"] = true,
	["Drunkard"] = true,
	["Stone Joker"] = true,
	["Golden Joker"] = true,
	["Lucky Cat"] = true,
	["Baseball Card"] = true,
	["Bull"] = true,
	["Diet Cola"] = true,
	["Trading Card"] = true,
	["Flash Card"] = true,
	["Popcorn"] = true,
	["Spare Trousers"] = true,
	["Ancient Joker"] = true,
	["Ramen"] = true,
	["Walkie Talkie"] = true,
	["Castle"] = true,
	["Smiley Face"] = true,
	["Campfire"] = true,
	["Golden Ticket"] = true,
	["Acrobat"] = true,
	["Swashbuckler"] = true,
	["Troubadour"] = true,
	["Certificate"] = true,
	["Throwback"] = true,
	["Rough Gem"] = true,
	["Bloodstone"] = true,
	["Arrowhead"] = true,
	["Onyx Agate"] = true,
	["Glass Joker"] = true,
	["Flower Pot"] = true,
	["Wee Joker"] = true,
	["Merry Andy"] = true,
	["The Idol"] = true,
	["Seeing Double"] = true,
	["Matador"] = true,
	["Hit the Road"] = true,
	["The Duo"] = true,
	["The Trio"] = true,
	["The Family"] = true,
	["The Order"] = true,
	["The Tribe"] = true,
	["Stuntman"] = true,
	["Invisible Joker"] = true,
	["Satellite"] = true,
	["Shoot the Moon"] = true,
	["Driver's License"] = true,
	["Cartomancer"] = true,
	["Burnt Joker"] = true,
	["Bootstraps"] = true,
	["Caino"] = true,
	["Triboulet"] = true,
	["Yorick"] = true,
	["Chicot"] = true,
	["Perkeo"] = true,
}

function PTASaka.check_forcetrigger(card)
	return card.config.center.demicoloncompat or PTASaka.VanillaJokerWhitelist[card.ability.name or ""]
end

-- Most of this is mostly taken from Cryptid
-- https://github.com/SpectralPack/Cryptid/blob/main/lib/forcetrigger.lua
-- Returns a result table usable by SMODS.trigger_effects
---@param card Card
---@param context CalcContext
---@return table
function PTASaka.forcetrigger(card, context)
	if card.ability.set ~= "Joker" then return {}, {} end
	local results, post = {}, {}
	if not PTASaka.VanillaJokerWhitelist[card.ability.name or ""] then
		-- just joker_main but also not joker_main
		results, post = eval_card(card,
			{
				full_hand = G.play.cards,
				scoring_hand = context.scoring_hand,
				scoring_name = context.scoring_name,
				poker_hands = context.poker_hands,
				forcetrigger = true,
				cardarea = G.jokers
			})
	else
		post = {}
		results.jokers = {}
		-- page 1
		if card.ability.name == "Joker" then
			results = { jokers = { mult_mod = card.ability.mult, card = card } }
		end
		if card.ability.name == "Greedy Joker" then
			results = { jokers = { mult_mod = card.ability.extra.s_mult, card = card } }
		end
		if card.ability.name == "Lusty Joker" then
			results = { jokers = { mult_mod = card.ability.extra.s_mult, card = card } }
		end
		if card.ability.name == "Wrathful Joker" then
			results = { jokers = { mult_mod = card.ability.extra.s_mult, card = card } }
		end
		if card.ability.name == "Gluttonous Joker" then
			results = { jokers = { mult_mod = card.ability.extra.s_mult, card = card } }
		end
		if card.ability.name == "Jolly Joker" then
			results = { jokers = { mult_mod = card.ability.t_mult, card = card } }
		end
		if card.ability.name == "Zany Joker" then
			results = { jokers = { mult_mod = card.ability.t_mult, card = card } }
		end
		if card.ability.name == "Mad Joker" then
			results = { jokers = { mult_mod = card.ability.t_mult, card = card } }
		end
		if card.ability.name == "Crazy Joker" then
			results = { jokers = { mult_mod = card.ability.t_mult, card = card } }
		end
		if card.ability.name == "Droll Joker" then
			results = { jokers = { mult_mod = card.ability.t_mult, card = card } }
		end
		if card.ability.name == "Sly Joker" then
			results = { jokers = { chips = card.ability.t_chips, card = card } }
		end
		if card.ability.name == "Wily Joker" then
			results = { jokers = { chips = card.ability.t_chips, card = card } }
		end
		if card.ability.name == "Clever Joker" then
			results = { jokers = { chips = card.ability.t_chips, card = card } }
		end
		if card.ability.name == "Devious Joker" then
			results = { jokers = { chips = card.ability.t_chips, card = card } }
		end
		if card.ability.name == "Crafty Joker" then
			results = { jokers = { chips = card.ability.t_chips, card = card } }
		end
		-- page 2
		if card.ability.name == "Half Joker" then
			results = { jokers = { mult_mod = card.ability.extra.mult, card = card } }
		end
		if card.ability.name == "Joker Stencil" then
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "Ceremonial Dagger" then
			local my_pos = 0
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					my_pos = i
					break
				end
			end
			if
				my_pos
				and G.jokers.cards[my_pos + 1]
				and not card.getting_sliced
				and not G.jokers.cards[my_pos + 1].ability.eternal
				and not G.jokers.cards[my_pos + 1].getting_sliced
			then
				local sliced_card = G.jokers.cards[my_pos + 1]
				sliced_card.getting_sliced = true
				G.GAME.joker_buffer = G.GAME.joker_buffer - 1
				G.E_MANAGER:add_event(Event({
					func = function()
						G.GAME.joker_buffer = 0
						card.ability.mult = card.ability.mult + sliced_card.sell_cost * 2
						card:juice_up(0.8, 0.8)
						sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
						play_sound("slice1", 0.96 + math.random() * 0.08)
						return true
					end,
				}))
			end
			results = { jokers = { mult_mod = card.ability.mult, card = card } }
		end
		if card.ability.name == "Banner" then
			results = { jokers = { chips = card.ability.extra, card = card } }
		end
		if card.ability.name == "Mystic Summit" then
			results = { jokers = { mult_mod = card.ability.extra.mult, card = card } }
		end
		if card.ability.name == "Marble Joker" then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					local front = pseudorandom_element(G.P_CARDS, pseudoseed("marb_fr"))
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					local card = Card(
						G.play.T.x + G.play.T.w / 2,
						G.play.T.y,
						G.CARD_W,
						G.CARD_H,
						front,
						G.P_CENTERS.m_stone,
						{ playing_card = G.playing_card }
					)
					card:start_materialize({ G.C.SECONDARY_SET.Enhanced })
					G.deck:emplace(card)
					table.insert(G.playing_cards, card)
					return true
				end,
			}))
		end
		if card.ability.name == "Loyalty Card" then
			results = { jokers = { Xmult_mod = card.ability.extra.Xmult, card = card } }
		end
		if card.ability.name == "8 Ball" then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "8ba")
					card:add_to_deck()
					G.consumeables:emplace(card)
					G.GAME.consumeable_buffer = 0
					return true
				end,
			}))
		end
		if card.ability.name == "Misprint" then
			results = { jokers = { mult_mod = card.ability.extra.max, card = card } }
		end
		-- if card.ability.name == "Dusk" then results = { jokers = { }, } end
		if card.ability.name == "Raised Fist" then
			results = { jokers = { mult_mod = 22, card = card } }
		end
		-- if card.ability.name == "Chaos the Clown" then results = { jokers = { }, } end
		-- page 3
		if card.ability.name == "Fibonacci" then
			results = { jokers = { mult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Steel Joker" then
			results = { jokers = { Xmult_mod = (card.ability.extra + 1), card = card } }
		end
		if card.ability.name == "Scary Face" then
			results = { jokers = { chips = card.ability.extra, card = card } }
		end
		if card.ability.name == "Abstract Joker" then
			results = { jokers = { mult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Delayed Gratification" then
			ease_dollars(card.ability.extra)
		end
		if card.ability.name == "Gros Michel" then
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card.T.r = -0.2
					card:juice_up(0.3, 0.4)
					card.states.drag.is = true
					card.children.center.pinch.x = true
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.3,
						blockable = false,
						func = function()
							G.jokers:remove_card(card)
							card:remove()
							card = nil
							return true
						end,
					}))
					return true
				end,
			}))
			G.GAME.pool_flags.gros_michel_extinct = true
			results = { jokers = { mult_mod = card.ability.extra.mult, card = card } }
		end
		if card.ability.name == "Even Steven" then
			results = { jokers = { mult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Odd Todd" then
			results = { jokers = { chips = card.ability.extra, card = card } }
		end
		if card.ability.name == "Scholar" then
			results = { jokers = { chips = card.ability.extra.chips, mult_mod = card.ability.extra.mult, card = card } }
		end
		if card.ability.name == "Business Card" then
			ease_dollars(2)
		end
		if card.ability.name == "Supernova" then
			results = { jokers = { mult_mod = G.GAME.hands[context.scoring_name].played, card = card } }
		end
		if card.ability.name == "Ride The Bus" then
			card.ability.mult = card.ability.mult + card.ability.extra
			results = { jokers = { mult_mod = card.ability.mult, card = card } }
		end
		if card.ability.name == "Space Joker" then
			if #G.hand.highlighted > 0 then
				local text, disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
				update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
					handname = localize(text, "poker_hands"),
					chips = G.GAME.hands[text].chips,
					mult = G.GAME.hands[text].mult,
					level = G.GAME.hands[text].level,
				})
				level_up_hand(card, text, nil, 1)
				update_hand_text(
					{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
					{ mult = 0, chips = 0, handname = "", level = "" }
				)
			elseif context.scoring_name then
				level_up_hand(card, context.scoring_name)
			end
		end
		-- page 4
		if card.ability.name == "Egg" then
			card.ability.extra_value = card.ability.extra_value + card.ability.extra
			card:set_cost()
		end
		if card.ability.name == "Burglar" then
			G.E_MANAGER:add_event(Event({
				func = function()
					ease_discard(-G.GAME.current_round.discards_left, nil, true)
					ease_hands_played(card.ability.extra)
					return true
				end,
			}))
		end
		if card.ability.name == "Blackboard" then
			results = { jokers = { Xmult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Runner" then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
			results = { jokers = { chips = card.ability.extra.chips, card = card } }
		end
		if card.ability.name == "Ice Cream" then
			card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
			results = { jokers = { chips = card.ability.extra.chips, card = card } }
			if card.ability.extra.chips - card.ability.extra.chip_mod <= 0 then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.4,
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
			end
		end
		if card.ability.name == "DNA" and context.full_hand then
			G.playing_card = (G.playing_card and G.playing_card + 1) or 1
			local _card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
			_card:add_to_deck()
			G.deck.config.card_limit = G.deck.config.card_limit + 1
			table.insert(G.playing_cards, _card)
			G.hand:emplace(_card)
			_card.states.visible = nil

			G.E_MANAGER:add_event(Event({
				func = function()
					_card:start_materialize()
					return true
				end,
			}))
		end
		if card.ability.name == "Blue Joker" then
			results = { jokers = { chips = card.ability.extra, card = card } }
		end
		if card.ability.name == "Sixth Sense" then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					local card = create_card("Spectral", G.consumeables, nil, nil, nil, nil, nil, "sixth")
					card:add_to_deck()
					G.consumeables:emplace(card)
					G.GAME.consumeable_buffer = 0
					return true
				end,
			}))
		end
		if card.ability.name == "Constellation" then
			card.ability.x_mult = card.ability.x_mult + card.ability.extra
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "Faceless Joker" then
			ease_dollars(card.ability.extra.dollars)
		end
		if card.ability.name == "Green Joker" then
			results = { jokers = { mult_mod = card.ability.mult, card = card } }
		end
		if card.ability.name == "Superposition" then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "sup")
					card:add_to_deck()
					G.consumeables:emplace(card)
					G.GAME.consumeable_buffer = 0
					return true
				end,
			}))
		end
		if card.ability.name == "To Do List" then
			ease_dollars(card.ability.extra.dollars)
		end
		-- page 5
		if card.ability.name == "Cavendish" then
			results = { jokers = { Xmult_mod = card.ability.extra.Xmult, card = card } }
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					play_sound("tarot1")
					card.T.r = -0.2
					card:juice_up(0.3, 0.4)
					card.states.drag.is = true
					card.children.center.pinch.x = true
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.3,
						blockable = false,
						func = function()
							G.jokers:remove_card(card)
							card:remove()
							card = nil
							return true
						end,
					}))
					return true
				end,
			}))
		end
		if card.ability.name == "Card Sharp" then
			results = { jokers = { Xmult_mod = card.ability.extra.Xmult, card = card } }
		end
		if card.ability.name == "Red Card" then
			card.ability.mult = card.ability.mult + card.ability.extra
			results = { jokers = { mult_mod = card.ability.mult, card = card } }
		end
		if card.ability.name == "Madness" then
			card.ability.x_mult = card.ability.x_mult + card.ability.extra
			local destructable_jokers = {}
			for i = 1, #G.jokers.cards do
				if
					G.jokers.cards[i] ~= card
					and not G.jokers.cards[i].ability.eternal
					and not G.jokers.cards[i].getting_sliced
				then
					destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
				end
			end
			local joker_to_destroy = #destructable_jokers > 0
				and pseudorandom_element(destructable_jokers, pseudoseed("madness"))
				or nil

			if joker_to_destroy and not card.getting_sliced then
				joker_to_destroy.getting_sliced = true
				G.E_MANAGER:add_event(Event({
					func = function()
						card:juice_up(0.8, 0.8)
						joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
						return true
					end,
				}))
			end
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "Square Joker" then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
			results = { jokers = { chips = card.ability.extra.chips, card = card } }
		end
		if card.ability.name == "Seance" then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					local card = create_card("Spectral", G.consumeables, nil, nil, nil, nil, nil, "sea")
					card:add_to_deck()
					G.consumeables:emplace(card)
					G.GAME.consumeable_buffer = 0
					return true
				end,
			}))
		end
		if card.ability.name == "Riff-raff" then
			local jokers_to_create = math.min(2, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
			G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
			G.E_MANAGER:add_event(Event({
				func = function()
					for i = 1, jokers_to_create do
						local card = create_card("Joker", G.jokers, nil, 0, nil, nil, nil, "rif")
						card:add_to_deck()
						G.jokers:emplace(card)
						card:start_materialize()
						G.GAME.joker_buffer = 0
					end
					return true
				end,
			}))
		end
		if card.ability.name == "Vampire" then
			local check = nil
			local enhanced = {}
			if context.scoring_hand and #context.scoring_hand > 0 then
				for k, v in ipairs(context.scoring_hand) do
					if v.config.center ~= G.P_CENTERS.c_base and not v.debuff and not v.vampired then
						enhanced[#enhanced + 1] = v
						v.vampired = true
						v:set_ability(G.P_CENTERS.c_base, nil, true)
					end
					v.vampired = nil
				end
				check = true
			end
			if not check and G and G.hand and #G.hand.highlighted > 0 then
				for k, v in ipairs(G.hand.highlighted) do
					if v.config.center ~= G.P_CENTERS.c_base and not v.debuff and not v.vampired then
						enhanced[#enhanced + 1] = v
						v.vampired = true
						v:set_ability(G.P_CENTERS.c_base, nil, true)
					end
					v.vampired = nil
				end
				check = true
			end
			card.ability.x_mult = card.ability.x_mult + (card.ability.extra * #enhanced or 1)
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		-- if card.ability.name == "Shortcut" then results = { jokers = { } } end
		if card.ability.name == "Hologram" then
			card.ability.x_mult = card.ability.x_mult + card.ability.extra
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "Vagabond" then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "vag")
					card:add_to_deck()
					G.consumeables:emplace(card)
					G.GAME.consumeable_buffer = 0
					return true
				end,
			}))
		end
		if card.ability.name == "Baron" then
			results = { jokers = { Xmult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Cloud 9" then
			if card.ability.nine_tally then
				ease_dollars(card.ability.extra * card.ability.nine_tally)
			else
				ease_dollars(card.ability.extra)
			end
		end
		if card.ability.name == "Rocket" then
			card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.increase
			ease_dollars(card.ability.extra.dollars)
		end
		if card.ability.name == "Obelisk" then -- Sobelisk
			card.ability.x_mult = card.ability.x_mult + card.ability.extra
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		-- page 6
		if card.ability.name == "Midas Mask" then
			local check = nil
			if context.scoring_hand then
				for k, v in ipairs(context.scoring_hand) do
					if v:is_face() then
						v:set_ability(G.P_CENTERS.m_gold, nil, true)
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.4,
							func = function()
								v:juice_up()
								return true
							end,
						}))
					end
				end
				check = true
			end
			if not check and G and G.hand and #G.hand.highlighted > 0 then
				for k, v in ipairs(context.scoring_hand) do
					if v:is_face() then
						v:set_ability(G.P_CENTERS.m_gold, nil, true)
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.4,
							func = function()
								v:juice_up()
								return true
							end,
						}))
					end
				end
				check = true
			end
		end
		if card.ability.name == "Luchador" then
			G.E_MANAGER:add_event(Event {
				func = function()
					if G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == "Boss")) then
						G.GAME.blind:disable()
					end
					return true
				end
			})
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('ph_boss_disabled') })
		end
		if card.ability.name == "Photograph" then
			results = { jokers = { Xmult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Gift Card" then
			for k, v in ipairs(G.jokers.cards) do
				if v.set_cost then
					v.ability.extra_value = (v.ability.extra_value or 0) + card.ability.extra
					v:set_cost()
				end
			end
			for k, v in ipairs(G.consumeables.cards) do
				if v.set_cost then
					v.ability.extra_value = (v.ability.extra_value or 0) + card.ability.extra
					v:set_cost()
				end
			end
		end
		if card.ability.name == "Turtle Bean" then
			G.hand:change_size(-card.ability.extra.h_size)
			card.ability.extra.h_size = card.ability.extra.h_size - card.ability.extra.h_mod
			G.hand:change_size(card.ability.extra.h_size)
		end
		if card.ability.name == "Erosion" then
			results = {
				jokers = { mult_mod = card.ability.extra * (G.GAME.starting_deck_size - #G.playing_cards), card = card },
			}
		end
		if card.ability.name == "Reserved Parking" then
			ease_dollars(card.ability.extra.dollars)
		end
		if card.ability.name == "Mail-In Rebate" then
			ease_dollars(card.ability.extra)
		end
		if card.ability.name == "Hallucination" then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "hal")
					card:add_to_deck()
					G.consumeables:emplace(card)
					G.GAME.consumeable_buffer = 0
					return true
				end,
			}))
		end
		if card.ability.name == "Fortune Teller" then
			results = { jokers = { mult_mod = G.GAME.consumeable_usage_total.tarot or 1, card = card } }
		end
		if card.ability.name == "Juggler" then
			G.hand:change_size(card.ability.h_size)
		end
		if card.ability.name == "Drunkard" then
			ease_discard(card.ability.d_size)
		end
		if card.ability.name == "Stone Joker" then
			results = { jokers = { chips = card.ability.extra * card.ability.stone_tally, card = card } }
		end
		if card.ability.name == "Golden Joker" then
			ease_dollars(card.ability.extra)
		end
		-- page 7
		if card.ability.name == "Lucky Cat" then
			card.ability.x_mult = card.ability.x_mult + card.ability.extra
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "Baseball Card" then
			results = { jokers = { Xmult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Bull" then
			results = {
				jokers = {
					chips = card.ability.extra * math.max(0, (G.GAME.dollars + (G.GAME.dollar_buffer or 0))),
					card = card,
				},
			}
		end
		if card.ability.name == "Diet Cola" then
			G.E_MANAGER:add_event(Event({
				func = function()
					add_tag(Tag("tag_double"))
					play_sound("generic1", 0.9 + math.random() * 0.1, 0.8)
					play_sound("holo1", 1.2 + math.random() * 0.1, 0.4)
					return true
				end,
			}))
		end
		if card.ability.name == "Trading Card" then
			ease_dollars(card.ability.extra)
		end
		if card.ability.name == "Flash Card" then
			card.ability.mult = card.ability.mult + card.ability.extra
			results = { jokers = { mult_mod = card.ability.mult, card = card } }
		end
		if card.ability.name == "Popcorn" then
			card.ability.mult = card.ability.mult - card.ability.extra
			results = { jokers = { mult_mod = card.ability.mult, card = card } }
		end
		if card.ability.name == "Spare Trousers" then
			card.ability.mult = card.ability.mult + card.ability.extra
			results = { jokers = { mult_mod = card.ability.mult, card = card } }
		end
		if card.ability.name == "Ancient Joker" then
			results = { jokers = { Xmult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Ramen" then
			card.ability.x_mult = card.ability.x_mult - card.ability.extra
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "Walkie Talkie" then
			results = { jokers = { mult_mod = card.ability.extra.mult, chips = card.ability.extra.chips, card = card } }
		end
		if card.ability.name == "Castle" then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
			results = { jokers = { chips = card.ability.extra.chips, card = card } }
		end
		if card.ability.name == "Smiley Face" then
			results = { jokers = { mult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Campfire" then
			card.ability.x_mult = card.ability.x_mult + card.ability.extra
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		-- page 8
		if card.ability.name == "Golden Ticket" then
			ease_dollars(card.ability.extra)
		end
		if card.ability.name == "Acrobat" then
			results = { jokers = { Xmult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Swashbuckler" then
			results = { jokers = { mult_mod = card.ability.mult, card = card } }
		end
		if card.ability.name == "Troubadour" then
			G.hand:change_size(card.ability.extra.h_size)
			G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.h_plays
		end
		if card.ability.name == "Certificate" then
			local _card = create_playing_card({
				front = pseudorandom_element(G.P_CARDS, pseudoseed("cert_fr")),
				center = G.P_CENTERS.c_base,
			}, G.discard, true, nil, { G.C.SECONDARY_SET.Enhanced }, true)
			_card:set_seal(SMODS.poll_seal({ guaranteed = true, type_key = "certsl" }))
			G.E_MANAGER:add_event(Event({
				func = function()
					G.hand:emplace(_card)
					_card:start_materialize()
					G.GAME.blind:debuff_card(_card)
					G.hand:sort()
					return true
				end,
			}))
		end
		if card.ability.name == "Throwback" then
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "Rough Gem" then
			ease_dollars(card.ability.extra)
		end
		if card.ability.name == "Bloodstone" then
			results = { jokers = { Xmult_mod = card.ability.extra.Xmult, card = card } }
		end
		if card.ability.name == "Arrowhead" then
			results = { jokers = { chips = card.ability.extra, card = card } }
		end
		if card.ability.name == "Onyx Agate" then
			results = { jokers = { mult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Glass Joker" then
			card.ability.x_mult = card.ability.x_mult + card.ability.extra
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		-- page 9
		if card.ability.name == "Flower Pot" then
			results = { jokers = { Xmult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Wee Joker" then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
			results = { jokers = { chips = card.ability.extra.chips, card = card } }
		end
		if card.ability.name == "Merry Andy" then
			ease_discard(card.ability.d_size)
			G.hand:change_size(card.ability.h_size)
		end
		if card.ability.name == "The Idol" then
			results = { jokers = { Xmult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Seeing Double" then
			results = { jokers = { Xmult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Matador" then
			ease_dollars(card.ability.extra)
		end
		if card.ability.name == "Hit The Road" then
			card.ability.x_mult = card.ability.x_mult + card.ability.extra
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "The Duo" then
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "The Trio" then
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "The Family" then
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "The Order" then
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "The Tribe" then
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		-- page 10
		if card.ability.name == "Stuntman" then
			G.hand:change_size(-card.ability.extra.h_size)
			results = { jokers = { chips = card.ability.extra.chip_mod, card = card } }
		end
		if card.ability.name == "Invisible Joker" then
			card.ability.invis_rounds = card.ability.invis_rounds + 1
			local jokers = {}
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] ~= card then
					jokers[#jokers + 1] = G.jokers.cards[i]
				end
			end
			if #jokers > 0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						local chosen_joker = pseudorandom_element(jokers, pseudoseed("invisible"))
						local card = copy_card(
							chosen_joker,
							nil,
							nil,
							nil,
							chosen_joker.edition and chosen_joker.edition.negative
						)
						if card.ability.invis_rounds then
							card.ability.invis_rounds = 0
						end
						card:add_to_deck()
						G.jokers:emplace(card)
						return true
					end,
				}))
			end
		end
		-- if card.ability.name == "Brainstorm" then results = { jokers = { } } end
		if card.ability.name == "Satellite" then
			local planets_used = 0
			for k, v in pairs(G.GAME.consumeable_usage) do
				if v.set == "Planet" then
					planets_used = planets_used + 1
				end
			end
			ease_dollars(card.ability.extra * planets_used or 1)
		end
		if card.ability.name == "Shoot The Moon" then
			results = { jokers = { mult_mod = 13, card = card } }
		end
		if card.ability.name == "Driver's License" then
			results = { jokers = { Xmult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Cartomancer" then
			G.E_MANAGER:add_event(Event({
				func = function()
					local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "car")
					card:add_to_deck()
					G.consumeables:emplace(card)
					G.GAME.consumeable_buffer = 0
					return true
				end,
			}))
		end
		-- if card.ability.name == "Astronomer" then results = { jokers = { } } end
		if card.ability.name == "Burnt Joker" then
			if #G.hand.highlighted > 0 then
				local text, disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
				update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
					handname = localize(text, "poker_hands"),
					chips = G.GAME.hands[text].chips,
					mult = G.GAME.hands[text].mult,
					level = G.GAME.hands[text].level,
				})
				level_up_hand(card, text, nil, 1)
				update_hand_text(
					{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
					{ mult = 0, chips = 0, handname = "", level = "" }
				)
			elseif context.scoring_name then
				level_up_hand(card, context.scoring_name)
			end
		end
		if card.ability.name == "Bootstraps" then
			results = {
				jokers = {
					mult_mod = card.ability.mult
						* math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / card.ability.extra.dollars),
					card = card,
				},
			}
		end
		if card.ability.name == "Caino" then
			card.ability.caino_xmult = card.ability.caino_xmult + card.ability.extra
			results = { jokers = { Xmult_mod = card.ability.caino_xmult, card = card } }
		end
		if card.ability.name == "Triboulet" then
			results = { jokers = { Xmult_mod = card.ability.extra, card = card } }
		end
		if card.ability.name == "Yorick" then
			card.ability.x_mult = card.ability.x_mult + card.ability.extra.xmult
			results = { jokers = { Xmult_mod = card.ability.x_mult, card = card } }
		end
		if card.ability.name == "Chicot" then
			G.E_MANAGER:add_event(Event {
				func = function()
					if G.GAME.blind and G.GAME.blind.boss then
						G.GAME.blind:disable()
					end
					return true
				end
			})
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('ph_boss_disabled') })
		end
		if card.ability.name == "Perkeo" then
			local eligibleJokers = {}
			for i = 1, #G.consumeables.cards do
				if G.consumeables.cards[i].ability.consumeable then
					eligibleJokers[#eligibleJokers + 1] = G.consumeables.cards[i]
				end
			end
			if #eligibleJokers > 0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						local card = copy_card(pseudorandom_element(eligibleJokers, pseudoseed("perkeo")), nil)
						card:set_edition({ negative = true }, true)
						card:add_to_deck()
						G.consumeables:emplace(card)
						return true
					end,
				}))
			end
		end
	end
	return results, post
end

-- ui stuff Taken from Aikoyori thanks aikoyori

PTASaka.get_speed_mult = function(card)
	return ((card and (card.area == G.jokers or
		card.area == G.consumeables or
		card.area == G.hand or
		card.area == G.play or
		card.area == G.shop_jokers or
		card.area == G.shop_booster or
		card.area == G.load_shop_vouchers
	)) and G.SETTINGS.GAMESPEED) or 1
end

-- credit to nh6574 for helping with this bit
PTASaka.card_area_preview = function(cardArea, desc_nodes, config)
	if not config then config = {} end
	local height = config.h or 1.25
	local width = config.w or 1
	local original_card = nil
	local speed_mul = config.speed or PTASaka.get_speed_mult(original_card)
	local card_limit = config.card_limit or #config.cards or 1
	local override = config.override or false
	local cards = config.cards or {}
	local padding = config.padding or 0.07
	local func_after = config.func_after or nil
	local init_delay = config.init_delay or 1
	local func_list = config.func_list or nil
	local func_delay = config.func_delay or 0.2
	local margin_left = config.ml or 0.2
	local margin_top = config.mt or 0
	local alignment = config.alignment or "cm"
	local scale = config.scale or 1
	local type = config.type or "title"
	local box_height = config.box_height or 0
	local highlight_limit = config.highlight_limit or 0
	if override or not cardArea then
		cardArea = CardArea(
			G.ROOM.T.x + margin_left * G.ROOM.T.w, G.ROOM.T.h + margin_top
			, width * G.CARD_W, height * G.CARD_H,
			{ card_limit = card_limit, type = type, highlight_limit = highlight_limit, collection = true, temporary = true }
		)
		for i = 1, #cards do
			local card = cards[i]
			card.T.w = card.T.w * scale
			card.T.h = card.T.h * scale
			card.VT.h = card.T.h
			card.VT.h = card.T.h
			local area = cardArea
			if (card.config.center and card.set_sprites) then
				-- this properly sets the sprite size <3
				card:set_sprites(card.config.center)
			end
			area:emplace(card)
		end
	end
	local uiEX = {
		n = G.UIT.R,
		config = { align = alignment, padding = padding, no_fill = true, minh = box_height },
		nodes = {
			{ n = G.UIT.O, config = { object = cardArea } }
		}
	}
	if cardArea then
		if desc_nodes then
			desc_nodes[#desc_nodes + 1] = {
				uiEX
			}
		end
	end
	if func_after or func_list then
		G.E_MANAGER:clear_queue("pta_desc")
	end
	if func_after then
		G.E_MANAGER:add_event(Event {
			delay = init_delay * speed_mul,
			blockable = false,
			trigger = "after",
			func = function()
				func_after(cardArea)
				return true
			end
		}, "pta_desc")
	end

	if func_list then
		for i, k in ipairs(func_list) do
			G.E_MANAGER:add_event(Event {
				delay = func_delay * i * speed_mul,
				blockable = false,
				trigger = "after",
				func = function()
					k(cardArea)
					return true
				end
			}, "pta_desc")
		end
	end
	return uiEX
end
