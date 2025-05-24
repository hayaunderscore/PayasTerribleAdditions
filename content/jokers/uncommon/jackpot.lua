SMODS.Joker {
	key = 'jackpot',
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 9, y = 4 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
	config = { extra = { econ_mult = 0.5, econ_max = 20 } },
	pta_credit = {
		idea = {
			credit = 'Mr. Logan',
			colour = HEX('c1410e')
		},
		art = {
			credit = 'Mr. Logan',
			colour = HEX('c1410e')
		},
	},
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.end_of_round then
			local c = context.other_card or {base={id=0}}
			if c.base.id == 14 or c.base.id == 7 or c.base.id == 5 or c.base.id == 3 or c.base.id == 2 then
				return {
					dollars = math.min(math.floor(c:get_chip_bonus() * card.ability.extra.econ_mult), card.ability.extra.econ_max)
				}
			end
		end
		if context.forcetrigger then
			return {
				dollars = card.ability.extra.econ_max
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.econ_mult, card.ability.extra.econ_max }
		}
	end
}