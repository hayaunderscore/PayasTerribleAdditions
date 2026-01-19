-- Half Moon Cookie
SMODS.Joker {
	key = 'halfmoon',
	rarity = 1,
	atlas = "BaseJokers",
	pos = { x = 0, y = 0 },
	cost = 3,
	blueprint_compat = true,
	config = { extra = { hands = 3, amount = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.amount, card.ability.extra.hands } }
	end,
	calculate = function(self, card, context)
		if context.before then
			SMODS.smart_level_up_hand(context.blueprint_card or card, context.scoring_name, false,
				card.ability.extra.amount)
			if not context.blueprint_card then
				card.ability.extra.hands = card.ability.extra.hands - 1
			end
		end
		if card.ability.extra.hands <= 0 and context.after and not context.blueprint_card then
			PTA.eat_food_joker(card)
		end
	end
}
