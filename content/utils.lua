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

-- Loosely based on https://github.com/balt-dev/Inkbleed/blob/trunk/modules/misprintize.lua
-- Specifically for non random values
function PTASaka.MMisprintize(val, amt, reference, key, func, whitelist, blacklist, layer)
	reference = reference or {}
	key = key or "1"
	amt = amt or 1
	func = func or function(v, a)
		return v * a
	end
	layer = layer or 0
	blacklist = blacklist or PTASaka.MisprintizeForbidden
	-- Forbidden, skip it
	if blacklist[key] then return val end
	if (whitelist and whitelist[key]) or not whitelist then
		local t = type(val)
		--if is_number(val) then print("key: "..key.." val: "..val.." layer: "..layer) end
		if is_number(val) and not (val == 1 and (key == "x_mult" or key == "x_chips") and layer == 1) then
			reference[key] = val
			return func(val, amt)
		elseif t == "table" then
			local k, v = next(val, nil)
			while k ~= nil do
				val[k] = PTASaka.MMisprintize(v, amt, reference[key], k, func, whitelist, blacklist, layer + 1)
				k, v = next(val, k)
			end
		end
	end
	return val
end

-- Taken from Cryptid...
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
function Card:is_ahead()
	if next(SMODS.find_card("j_payasaka_niveusterras")) then return true end
	if self.ability.name == "Arrowhead" then return true end
	if self.config and self.config.center and type(self.config.center.rarity) == 'string' and self.config.center.rarity == "payasaka_ahead" then return true end
	if self.config and self.config.center and type(self.config.center.rarity) == 'string' and self.config.center.rarity == "payasaka_daeha" then return true end
	return false
end

function PTASaka.arrow(arrow, val1, val2, og_arrow)
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
