if not CardSleeves then return end

CardSleeves.Sleeve {
	key = 'gambling',
	atlas = "JOE_Sleeves",
	pos = { x = 0, y = 0 },
	apply = function(self, sleeve)
		G.GAME.payasaka_allow_reroll = true
	end
}