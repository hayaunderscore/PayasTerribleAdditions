SMODS.Joker {
	name = "Mr. Seal",
	key = "mrseal",
	atlas = "JOE_Jokers",
	pos = { x = 3, y = 0 },
	rarity = 3,
	cost = 6,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.repetition then
			if context.other_card.seal then
				return {
					repetitions = 1,
					message = localize("k_again_ex"),
					card = card,
				}
			end
		end
	end
}
