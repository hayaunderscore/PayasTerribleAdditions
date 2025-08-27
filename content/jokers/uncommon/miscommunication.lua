SMODS.Joker {
	name = "Miscommunication",
	key = "miscommunication",
	atlas = "JOE_Jokers",
	pos = { x = 8, y = 1 },
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	demicoloncompat = false,
	config = { extra = { odds = 5 } },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint_card then
			if SMODS.pseudorandom_probability(card, 'miscom', 1, card.ability.extra.odds) then
				card.ability.extra.triggered = true
				return {
					message = "Woo!"
				}
			end
		end
		if context.end_of_round and card.ability.extra.triggered then
			card.ability.extra.triggered = nil
		end
		if context.fix_probability and card.ability.extra.triggered then
			return {
				numerator = context.denominator or 1e9
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
		return {
			vars = { num, den }
		}
	end
}