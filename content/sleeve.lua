if not CardSleeves then return end

CardSleeves.Sleeve {
	key = 'gambling',
	atlas = "JOE_Sleeves",
	pos = { x = 0, y = 0 },
	apply = function(self, sleeve)
		G.GAME.payasaka_allow_reroll = true
		if self.get_current_deck_key() == "b_payasaka_gacha" then
			G.GAME.payasaka_unweighted_gacha = true
		end
	end,
	loc_vars = function(self)
		local key = self.key
		if self.get_current_deck_key() == "b_payasaka_gacha" then
			key = self.key .. "_alt"
		end
		return { key = key }
	end,
}
