SMODS.Joker {
	name = "Rei",
	key = "rei",
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 2, y = 0 },
	soul_pos = { x = 5, y = 0 },
	cost = 25,
	blueprint_compat = false,
	demicoloncompat = false,
	pta_usable = true,
	use = function(self, card, copier)
		delay(0.5)
		local hands = {}
		local cards = G.hand.cards
		hands = PTASaka.FH.merge(hands, PTASaka.FH.possible_straights(cards))
		hands = PTASaka.FH.merge(hands, PTASaka.FH.possible_flushes(cards))
		hands = PTASaka.FH.merge(hands, PTASaka.FH.best_ofakinds(cards))
		table.sort(hands, PTASaka.FH.is_better_hand)
		G.E_MANAGER:add_event(Event {
			func = function()
				PTASaka.FH.select_hand(PTASaka.FH.next_best_hand(hands, G.hand.cards, PTASaka.FH.ranksuit))
				return true
			end
		})
		delay(0.5)
		draw_card(G.play, G.jokers, nil, 'up', nil, card)
	end,
	can_use = function(self, card)
		return G.STATE == G.STATES.SELECTING_HAND
	end
}
