-- Draping Tablet
SMODS.Joker {
	name = "Draping Tablet",
	key = "drapingtablet",
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 1, y = 3 },
	atlas = "JOE_Jokers",
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
			local amt = 0
			for i = 1, #G.hand.cards do
				if G.hand.cards[i]:is_suit('Spades') then
					amt = amt + 1
				end
			end
			return {
				message = localize('k_again_ex'),
				repetitions = amt,
				card = card
			}
		end
	end
}