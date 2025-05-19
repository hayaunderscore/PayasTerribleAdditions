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
function PTASaka.MMisprintize(val, amt, reference, key, func, whitelist, blacklist)
	reference = reference or {}
	key = key or "1"
	amt = amt or 1
	func = func or function(v, a)
		return v * a
	end
	blacklist = blacklist or PTASaka.MisprintizeForbidden
	-- Forbidden, skip it
	if blacklist[key] then return val end
	if (whitelist and whitelist[key]) or not whitelist then
		local t = type(val)
		if is_number(val) then
			reference[key] = val
			return func(val, amt)
		elseif t == "table" then
			local k, v = next(val, nil)
			while k ~= nil do
				val[k] = PTASaka.MMisprintize(v, amt, reference[key], k, func, whitelist, blacklist)
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

-- Whitelisted card areas for ahead checking
PTASaka.WhitelistedAheadAreas = {
	'jokers', 'consumeables', 'hand', 'discard', 'play'
}
PTASaka.ahead_count = 0

-- Get ahead count after updating
local old_update = Game.update
function Game:update(dt)
	old_update(self, dt)
	PTASaka.ahead_count = 0
	local violating = SMODS.find_card('j_payasaka_no_retrigger')
	PTASaka.stop_you_are_violating_the_law = next(violating) and violating[1]
	local recuperares = SMODS.find_card('j_payasaka_recuperare')
	PTASaka.recuperares = next(recuperares) and recuperares
	local niveus_terras = next(SMODS.find_card('j_payasaka_niveusterras'))
	for _, s in ipairs(PTASaka.WhitelistedAheadAreas) do
		local area = G[s]
		if not (area and area.cards) then goto continue end
		for _, card in ipairs(area.cards) do
			if card and card.is_ahead and (niveus_terras or card:is_ahead()) then
				PTASaka.ahead_count = PTASaka.ahead_count + 1
			end
		end
		::continue::
	end
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

local cardHoverHook = Card.hover
function Card:hover()
	if self.area == PTASaka.adultcard_cardarea then return end
	PTASaka.current_hover_card = self
	local ret = cardHoverHook(self)
	return ret
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

-- Hooks to localize functions for comments
local init_ref = init_localization
function init_localization()
	init_ref()
	-- This is awfully nested....
	for g_k, group in pairs(G.localization) do
		if g_k == 'descriptions' then
			for _, set in pairs(group) do
				for _, center in pairs(set) do
					center.payasaka_comment_parsed = {}
					if center.payasaka_comment then
						for _, line in ipairs(center.payasaka_comment) do
							center.payasaka_comment_parsed[#center.payasaka_comment_parsed + 1] = loc_parse_string(line)
						end
					end
				end
			end
		end
	end
end

local localize_ref = localize
function localize(args, misc_cat)
	if args and not (type(args) == 'table') then
		return localize_ref(args, misc_cat)
	end

	local loc_target = nil
	if args.type == 'payasaka_comment' then
		loc_target = G.localization.descriptions[(args.set or args.node.config.center.set)]
			[args.key or args.node.config.center.key]

		if loc_target then
			for _, lines in ipairs(loc_target[args.type .. "_parsed"]) do
				local final_line = {}
				for _, part in ipairs(lines) do
					local assembled_string = ''
					for _, subpart in ipairs(part.strings) do
						assembled_string = assembled_string ..
						(type(subpart) == 'string' and subpart or args.vars[tonumber(subpart[1])] or 'ERROR')
					end
					local desc_scale = G.LANG.font.DESCSCALE
					if G.F_MOBILE_UI then desc_scale = desc_scale * 1.5 end
					if args.type == 'name' then
						final_line[#final_line + 1] = {
							n = G.UIT.O,
							config = {
								object = DynaText({
									string = { assembled_string },
									colours = { (part.control.V and args.vars.colours[tonumber(part.control.V)]) or (part.control.C and loc_colour(part.control.C)) or G.C.UI.TEXT_LIGHT },
									bump = true,
									silent = true,
									pop_in = 0,
									pop_in_rate = 4,
									maxw = 5,
									shadow = true,
									y_offset = -0.6,
									spacing = math.max(0, 0.32 * (17 - #assembled_string)),
									scale = (0.55 - 0.004 * #assembled_string) *
									(part.control.s and tonumber(part.control.s) or 1)
								})
							}
						}
					elseif part.control.E then
						local _float, _silent, _pop_in, _bump, _spacing = nil, true, nil, nil, nil
						if part.control.E == '1' then
							_float = true; _silent = true; _pop_in = 0
						elseif part.control.E == '2' then
							_bump = true; _spacing = 1
						end
						final_line[#final_line + 1] = {
							n = G.UIT.O,
							config = {
								object = DynaText({
									string = { assembled_string },
									colours = { part.control.V and args.vars.colours[tonumber(part.control.V)] or loc_colour(part.control.C or nil) },
									float = _float,
									silent = _silent,
									pop_in = _pop_in,
									bump = _bump,
									spacing = _spacing,
									scale = 0.32 * (part.control.s and tonumber(part.control.s) or 1) * desc_scale
								})
							}
						}
					elseif part.control.X then
						final_line[#final_line + 1] = {
							n = G.UIT.C,
							config = { align = "m", colour = loc_colour(part.control.X), r = 0.05, padding = 0.03, res = 0.15 },
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = assembled_string,
										colour = loc_colour(part.control.C or nil),
										scale = 0.32 * (part.control.s and tonumber(part.control.s) or 1) * desc_scale
									}
								},
							}
						}
					else
						final_line[#final_line + 1] = {
							n = G.UIT.T,
							config = {
								detailed_tooltip = part.control.T and
								(G.P_CENTERS[part.control.T] or G.P_TAGS[part.control.T]) or nil,
								text = assembled_string,
								shadow = args.shadow,
								colour = part.control.V and args.vars.colours[tonumber(part.control.V)] or
								loc_colour(part.control.C or nil, args.default_col),
								scale = 0.32 * (part.control.s and tonumber(part.control.s) or 1) * desc_scale
							},
						}
					end
				end
				if args.type == 'name' or args.type == 'text' then return final_line end
				args.nodes[#args.nodes + 1] = final_line
			end
		end
	else
		return localize_ref(args, misc_cat)
	end
end
