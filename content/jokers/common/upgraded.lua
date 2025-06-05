SMODS.Joker {
	name = "pta-UpgradedJoker",
	key = 'upgraded',
	config = { extra = { xmult = 1.5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	atlas = "JOE_Jokers",
	pos = { x = 9, y = 8 },
	cost = 3,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.xmult
			}
		end
	end
}