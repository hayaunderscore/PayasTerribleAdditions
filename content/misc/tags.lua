if PTASaka.Mod.config["Property Cards"] then
SMODS.Tag {
	key = 'propertytag',
	atlas = "JOE_Tags",
	pos = { x = 2, y = 0 },
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
				local key = 'p_payasaka_property_mega_1'
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
end

if PTASaka.Mod.config["Ahead"] then
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
end

-- nil
-- Moved here so that nil cards are still available via nil tags
SMODS.Joker {
	name = "payasaka_nil",
	key = 'nil',
	rarity = "payasaka_ahead",
	cost = 0,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	no_collection = true,
	pos = { x = 5, y = 3 },
	atlas = "JOE_Jokers",
	no_doe = true, -- There is no reason for this to be available in DOE/Balanced sleeve
	--[[
	add_to_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + 1
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - 1
	end,
	]]
	in_pool = function(self, args)
		return false
	end,
	set_card_type_badge = function(self, card, badges) end
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

SMODS.Tag {
	key = 'potential',
	atlas = "JOE_Tags",
	pos = { x = 3, y = 0 },
	apply = function(self, tag, context)
		if context.type == "store_joker_create" then
			local card = create_card("Joker", context.area, nil, nil, nil, nil, "j_payasaka_potential", "t_ahead")
			create_shop_card_ui(card, "Joker", context.area)
			card.states.visible = false
			tag:yep("+", G.C.EDITION, function()
				card:start_materialize()
				return true
			end)
			tag.triggered = true
			return card
		end
	end,
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
}

SMODS.Tag {
	key = 'friend',
	atlas = "JOE_Tags",
	pos = { x = 4, y = 0 },
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
				tag:yep('+', SMODS.Gradients["payasaka_friend"], function()
					local card = SMODS.add_card { set = "Friend", skip_materialize = true }
					card.from_tag = true
					card:start_materialize({G.C.RED, G.C.BLUE})
					return true
				end)
			else
				tag:nope()
			end
			tag.triggered = true
			return true
		end
	end,
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
}