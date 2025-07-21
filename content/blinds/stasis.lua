SMODS.Blind {
	key = "stasis",
	atlas = "JOE_Blinds",
	pos = {x = 0, y = 8},
	dollars = 6,
	mult = 2,
	boss = {min = 0, max = 1999},
	boss_colour = HEX('4b828d'),
	set_blind = function(self)
		G.GAME.payasaka_stasis = true
	end,
	disable = function(self)
		G.GAME.payasaka_stasis = false
	end,
	defeat = function(self)
		G.GAME.payasaka_stasis = false
	end,
	calculate = function(self, blind, context)
		if G.GAME.payasaka_stasis then
			if context.end_of_round and context.main_eval then
				for _, v in pairs(G.playing_cards) do
					PTASaka.freeze_card(v, nil, nil, true)
				end
			end
			if context.before then
				local card = pseudorandom_element(PTASaka.FH.filter(G.play.cards, function(c) return c and c.ability and not c.ability.pta_frozen end), 'stasis')
				if card then
					PTASaka.freeze_card(card, true, true, nil, true)
				end
			end
		end
	end
}