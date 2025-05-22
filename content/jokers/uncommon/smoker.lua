SMODS.Joker {
	key = 'smoker',
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 3, y = 9 },
	cost = 6,
	blueprint_compat = false,
	demicoloncompat = false,
	config = { extra = { amount = 2, count = 5, should_trigger = false } },
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.pre_discard and #context.full_hand == card.ability.extra.count then
			card.ability.extra.should_trigger = true
		end
		if card.ability.extra.should_trigger and context.payasaka_draw_to_deck then
			card.ability.extra.should_trigger = false
			return {
				draw_amount = card.ability.extra.amount,
				message = "Smokin!"
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.count, card.ability.extra.amount }
		}
	end
}