local jackpots = {
	[14] = true,
	[7] = true,
	[5] = true,
	[3] = true,
	[2] = true
}

SMODS.Joker {
	key = 'jackpot',
	rarity = 2,
	atlas = "BaseJokers",
	pos = { x = 2, y = 0 },
	cost = 5,
	blueprint_compat = true,
	config = { extra = { econ_mult = 0.5, econ_max = 20 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.econ_mult, card.ability.extra.econ_max } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.end_of_round then
			local c = context.other_card
			if not c then return end
			if not jackpots[c:get_id()] then return end
			return {
				dollars = math.min(math.floor(c:get_chip_bonus() * card.ability.extra.econ_mult),
					card.ability.extra.econ_max)
			}
		end
	end
}
