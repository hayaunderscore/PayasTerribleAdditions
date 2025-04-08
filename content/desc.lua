PTASaka.DescriptionDummies = {}

-- ui stuff Taken from Aikoyori thanks aikoyori
PTASaka.DescriptionDummy = SMODS.Center:extend{
	set = 'DescriptionDummy',
	obj_buffer = {},
	obj_table = PTASaka.DescriptionDummies,
	class_prefix = 'dd',
	required_params = {
		'key',
	},
	pre_inject_class = function(self)
		G.P_CENTER_POOLS[self.set] = {}
	end,
	inject = function(self)
		SMODS.Center.inject(self)
	end,
	get_obj = function(self, key)
		if key == nil then
			return nil
		end
		return self.obj_table[key]
	end
}

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
			{card_limit = card_limit, type = type, highlight_limit = highlight_limit, collection = true,temporary = true}
		)
		for i, card in ipairs(cards) do
			card.T.w = card.T.w * scale
			card.T.h = card.T.h * scale
			card.VT.h = card.T.h
			card.VT.h = card.T.h
			local area = cardArea
			if(card.config.center and card.set_sprites) then
				-- this properly sets the sprite size <3
				card:set_sprites(card.config.center)
			end
			area:emplace(card)
		end
	end
	local uiEX = {
		n = G.UIT.R,
		config = { align = alignment , padding = padding, no_fill = true, minh = box_height },
		nodes = {
			{n = G.UIT.O, config = { object = cardArea }}
		}
	}
	if cardArea then
		if desc_nodes then
			desc_nodes[#desc_nodes+1] = {
				uiEX
			}
		end
	end
	if func_after or func_list then 
		G.E_MANAGER:clear_queue("pta_desc")
	end
	if func_after then 
		G.E_MANAGER:add_event(Event{
			delay = init_delay * speed_mul,
			blockable = false,
			trigger = "after",
			func = function ()
				func_after(cardArea)
				return true
			end
		},"pta_desc")
	end
	
	if func_list then 
		for i, k in ipairs(func_list) do
			G.E_MANAGER:add_event(Event{
				delay = func_delay * i * speed_mul,
				blockable = false,
				trigger = "after",
				func = function ()
					k(cardArea)
					return true
				end
			},"pta_desc")
		end
	end
	return uiEX
end

function PTASaka.shallow_copy(t)
	local t2 = {}
	for k,v in pairs(t) do
		t2[k] = v
	end
	return t2
end

local cardarea_desccache = {}

-- Adult card card list
local dummy = PTASaka.DescriptionDummy{
	key = "adultcard_area",
	generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		if not PTASaka.adultcard_cardarea then return end
		local cards = {}
		for k, v in pairs(PTASaka.adultcard_cardarea.cards) do
			--if not cardarea_desccache[v.config.center.key] then
			--	cardarea_desccache[v.config.center.key] = PTASaka.deep_copy(v)
			--end
			table.insert(cards, SMODS.create_card{key=v.config.center.key,no_edition=true})
		end
		
		if desc_nodes ~= full_UI_table.main then
			PTASaka.card_area_preview(PTASaka.adultcard_cardarea_ui, desc_nodes, {
				cards = cards,
				override = true,
				w = 3.5,
				h = 0.6,
				--mt = -1,
				ml = 0,
				box_height = 2,
				alignment = "bm",
				scale = 0.5,
			})
		end
	end
}

PTASaka.DescriptionDummies["dd_adultcard_area"] = dummy