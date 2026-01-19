-- Nostalgic Phil
SMODS.Joker {
	key = "nostalgic_phil",
	rarity = 1,
	atlas = "BaseJokers",
	pos = { x = 1, y = 0 },
	cost = 3,
	blueprint_compat = true,
	config = { extra = { xmult = 10 } },
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.xmult)
		return { vars = { num, den } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if SMODS.pseudorandom_probability(card, 'phil', 1, card.ability.extra.xmult) then
				return {
					x_mult = card.ability.extra.xmult
				}
			end
			return {
				message = localize('k_nope_ex')
			}
		end
	end
}
