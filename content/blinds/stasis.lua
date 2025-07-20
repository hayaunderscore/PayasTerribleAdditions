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
			if context.after then G.GAME.payasaka_stasis_kill = true end
			if context.end_of_round and context.main_eval then
				G.GAME.payasaka_stasis_kill = nil
			end
			if (context.hand_drawn and G.GAME.payasaka_stasis_kill) or context.first_hand_drawn then
				G.GAME.payasaka_stasis_kill = nil
				local card = pseudorandom_element(G.hand.cards, 'stasis')
				card.ability.pta_frozen = true
			end
		end
	end
}