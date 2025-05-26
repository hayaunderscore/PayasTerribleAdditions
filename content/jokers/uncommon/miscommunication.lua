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
	calculate = function(self, card, context)
		if context.setting_blind then
			if pseudorandom('miscommunication') < (G.GAME.probabilities.normal or 1)/card.ability.extra.odds then
				G.GAME.payasaka_old_probability = G.GAME.probabilities.normal or 1
				G.GAME.probabilities.normal = 1e9
				return {
					message = "Woo!"
				}
			end
		end
		if context.end_of_round and G.GAME.payasaka_old_probability then
			G.GAME.probabilities.normal = G.GAME.payasaka_old_probability
			G.GAME.payasaka_old_probability = nil
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds }
		}
	end
}