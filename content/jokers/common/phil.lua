-- Phil
SMODS.Joker {
	name = "Phil",
	key = "phil",
	config = { extra = { fuck = 20, odds = 1, chance = 10 } },
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.chance)
		return { vars = { card.ability.extra.fuck, num, den } }
	end,
	rarity = 1,
	atlas = "JOE_Jokers",
	pos = { x = 2, y = 2 },
	cost = 3,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			if SMODS.pseudorandom_probability(card, 'phil', 1, card.ability.extra.chance) then
				return {
					pf_mult = function(mult) return 0 end,
					message = "Aww..."
				}
			end
			return {
				x_mult = card.ability.extra.fuck
			}
		end
	end
}
