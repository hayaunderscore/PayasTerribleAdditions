SMODS.Joker {
	key = 'ari',
	name = 'Ari',
	config = { extra = 2 },
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 3, y = 6 },
	soul_pos = { x = 5, y = 6, extra = { x = 4, y = 6 } },
	cost = 25,
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
	calculate = function(self, card, context)
		if context.other_card and context.individual and context.cardarea == G.play and not context.end_of_round then
			local other_card = context.other_card
			if other_card and (other_card:get_id() == 14 or other_card:get_id() == 2 or other_card:get_id() == 3) then
				return {
					x_mult = card.ability.extra
				}
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra } }
	end
}