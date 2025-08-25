SMODS.Blind {
	key = "construct",
	atlas = "JOE_Blinds",
	pos = {x = 0, y = 5},
	dollars = 5,
	mult = 2,
	boss = {min = 0, max = 1999},
	boss_colour = HEX('60a1cc'),
	set_blind = function(self)
		G.GAME.payasaka_construct = true
	end,
	disable = function(self)
		G.GAME.payasaka_construct = false
	end,
	defeat = function(self)
		G.GAME.payasaka_construct = false
	end,
	calculate = function(self, blind, context)
		if G.GAME.payasaka_construct and context.after then
			G.E_MANAGER:add_event(Event{
				func = function()
					G.E_MANAGER:add_event(Event{
						func = function()
							SMODS.juice_up_blind()
							return true
						end
					})
					G.E_MANAGER:add_event(Event({
						trigger = 'ease',
						blocking = false,
						ref_table = G.GAME,
						ref_value = 'chips',
						ease_to = G.GAME.chips - (G.GAME.blind.chips/10),
						delay = 0.5,
						func = (function(t) return math.floor(t) end)
					}))
					PTASaka.logged_chips = G.GAME.chips - (G.GAME.blind.chips/10)
					return true
				end
			})
		end
	end
}