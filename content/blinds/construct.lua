SMODS.Blind {
	key = "construct",
	atlas = "JOE_Blinds",
	pos = {x = 0, y = 5},
	dollars = 8,
	mult = 2,
	boss = {min = 0, max = 1999},
	boss_colour = HEX('a58445'),
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
			local chips = G.GAME.chips + to_big(PTASaka.arrow(G.GAME.payasaka_exponential_count or 0, hand_chips, mult))
			G.E_MANAGER:add_event(Event{
				func = function()
					SMODS.juice_up_blind()
				end
			})
			G.E_MANAGER:add_event(Event({
				trigger = 'ease',
				blocking = false,
				ref_table = G.GAME,
				ref_value = 'chips',
				ease_to = chips - (G.GAME.blind.chips/10),
				delay = 0.5,
				func = (function(t) return math.floor(t) end)
			}))
		end
	end
}