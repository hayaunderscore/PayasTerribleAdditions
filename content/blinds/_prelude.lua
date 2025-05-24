SMODS.Blind {
	key = 'prelude',
	atlas = "JOE_Blinds",
	pos = { x = 0, y = 2 },
	dollars = 6,
	mult = 2,
	boss_colour = HEX('7b194e'),
	boss = { min = 0 },
	set_blind = function(self)
		G.GAME.payasaka_prelude = true
	end,
	disable = function(self)
		G.GAME.payasaka_prelude = false
	end,
	defeat = function(self)
		G.GAME.payasaka_prelude = false
	end,
	calculate = function(self, blind, context)
		if G.GAME.payasaka_prelude and context.after then
			for k, v in ipairs(G.play.cards) do
				G.E_MANAGER:add_event(Event{
					trigger = 'after',
					delay = 0.15,
					func = function()
						SMODS.debuff_card(v, true, 'payasaka_prelude')
						play_sound('timpani')
						v:juice_up(0.2, 0.3)
						return true
					end
				})
			end
			delay(0.4)
		end
	end,
	in_pool = function(self)
		return false
	end,
	get_loc_debuff_text = function(self)
		return "Played cards are debuffed and drawn back to the deck"
	end,
}

-- Mostly taken from blindexpander by mysthaps
-- https://github.com/Mysthaps/blindexpander/blob/master/blindexpander.lua
-- Left here over hooks.lua for now...
local update_new_roundref = Game.update_new_round
function Game.update_new_round(self, dt)
	if self.buttons then
		self.buttons:remove(); self.buttons = nil
	end
	if self.shop then
		self.shop:remove(); self.shop = nil
	end

	if not G.STATE_COMPLETE and G.GAME.blind.config.blind.key == 'bl_payasaka_prelude' then
		local valueToPutInIf = (Talisman and to_big and to_big(G.GAME.chips):lt(to_big(G.GAME.blind.chips))) or
			to_big(G.GAME.chips) < to_big(G.GAME.blind.chips)
		if G.GAME.current_round.hands_left <= 0 and valueToPutInIf then
			G.STATE_COMPLETE = true
			end_round()
			return
		end

		local obj = G.GAME.blind.config.blind
		G.P_BLINDS[obj.key].discovered = true
		if obj.defeat and type(obj.defeat) == 'function' then
			obj:defeat()
		end

		G.GAME.blind:set_blind(G.P_BLINDS[G.GAME.payasaka_prelude_next_blind])

		G.STATE = G.STATES.DRAW_TO_HAND
		G.E_MANAGER:add_event(Event({
			trigger = 'ease',
			blocking = false,
			ref_table = G.GAME,
			ref_value = 'chips',
			ease_to = 0,
			delay = 0.3 * G.SETTINGS.GAMESPEED,
			func = (function(t) return math.floor(t) end)
		}))
	end

	if G.STATE ~= G.STATES.DRAW_TO_HAND then
		update_new_roundref(self, dt)
	end
end
