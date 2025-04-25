SMODS.Tag {
	key = 'propertytag',
	atlas = "JOE_Tags",
	pos = { x = 2, y = 0 },
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
				local key = 'p_payasaka_property_mega_2'
				local card = Card(G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
					G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2, G.CARD_W * 1.27, G.CARD_H * 1.27, G.P_CARDS.empty,
					G.P_CENTERS[key], { bypass_discovery_center = true, bypass_discovery_ui = true })
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = card } })
				card:start_materialize()
				return true
			end)
			tag.triggered = true
			return true
		end
	end,
}

SMODS.Tag {
	key = 'ahead',
	atlas = "JOE_Tags",
	pos = { x = 0, y = 0 },
	apply = function(self, tag, context)
		if context.type == "store_joker_create" then
			local card = create_card("Joker", context.area, nil, "payasaka_ahead", nil, nil, nil, "t_ahead")
			create_shop_card_ui(card, "Joker", context.area)
			card.states.visible = false
			tag:yep("+", G.C.EDITION, function()
				card:start_materialize()
				card.ability.couponed = true
				card:set_cost()
				return true
			end)
			tag.triggered = true
			return card
		end
	end,
}

SMODS.Tag {
	key = 'nil',
	atlas = "JOE_Tags",
	pos = { x = 1, y = 0 },
	apply = function(self, tag, context)
		if context.type == "store_joker_create" then
			local card = create_card("Joker", context.area, nil, nil, nil, nil, "j_payasaka_nil", "t_nil")
			create_shop_card_ui(card, "Joker", context.area)
			card.states.visible = false
			tag:yep("+", G.C.EDITION, function()
				card:start_materialize()
				card.ability.couponed = true
				card:set_cost()
				return true
			end)
			tag.triggered = true
			return card
		end
	end,
}
