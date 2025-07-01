SMODS.Blind {
	key = "nether",
	atlas = "JOE_Blinds",
	pos = {x = 0, y = 0},
	dollars = 8,
	mult = 2,
	boss = {min = 0, max = 1999},
	boss_colour = HEX('35153F'),
	set_blind = function(self)
		play_sound("payasaka_nether")
		G.GAME.payasaka_nether_destroycards = true
	end,
	disable = function(self)
		G.GAME.payasaka_nether_destroycards = false
	end,
	defeat = function(self)
		G.GAME.payasaka_nether_destroycards = false
	end,
	calculate = function(self, blind, context)
		if G.GAME.payasaka_nether_destroycards then
			if context.destroy_card and (context.cardarea == G.play or context.cardarea == 'unscored') then
				return {
					remove = true,
					func = function()
						if not G.GAME.blind.silent then
							G.E_MANAGER:add_event(Event{
								func = function()
									play_sound("payasaka_flint")
									return true
								end
							})
						end
						G.GAME.blind.silent = true
					end
				}
			end
			if context.after then
				G.GAME.blind.silent = nil
			end
		end
	end
}