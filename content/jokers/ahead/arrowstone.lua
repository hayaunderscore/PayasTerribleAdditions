-- Arrowstone
SMODS.Joker {
	name = "Arrowstone",
	key = "arrowstone",
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 0, y = 3 },
	atlas = "JOE_Jokers",
	config = { extra = { odds = 2, x_chips = 2 }, },
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.x_chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			local _c = context.other_card
			if _c and _c:is_suit('Spades') and pseudorandom('payasaka_arrowstone') < (G.GAME.probabilities.normal or 1)/card.ability.extra.odds then
				return {
					x_chips = card.ability.extra.x_chips
				}
			end
		end
	end
}