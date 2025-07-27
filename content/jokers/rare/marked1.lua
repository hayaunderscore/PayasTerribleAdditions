-- Gung-ho Gun
SMODS.Joker {
	name = "pta-Gungho",
	key = "gungho",
	rarity = 3,
	atlas = "JOE_Jokers2",
	pos = { x = 7, y = 8 },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = true,
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
	config = { extra = { xmult = 4, odds = 4 } },
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			return {
				xmult = card.ability.extra.xmult
			}
		end
		if context.hand_drawn and not context.blueprint_card then
			for i = 1, #context.hand_drawn do
				local c = context.hand_drawn[i]
				if SMODS.pseudorandom_probability(card, 'marked_chance', 1, card.ability.extra.odds) then
					PTASaka.set_status(c, "payasaka_marked", true)
				end
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
		info_queue[#info_queue+1] = { key = 'status_payasaka_marked', set = 'Status' }
		return { vars = { card.ability.extra.xmult, num, den } }
	end
}
