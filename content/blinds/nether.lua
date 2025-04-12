SMODS.Blind {
	key = "nether",
	atlas = "JOE_Blinds",
	pos = {x = 0, y = 0},
	dollars = 8,
	mult = 2,
	boss = {min = 0, max = 1999},
	boss_colour = HEX('35153F'),
	set_blind = function (self)
		play_sound("payasaka_nether")
		G.GAME.payasaka_nether_destroycards = true
	end,
	disable = function (self)
		G.GAME.payasaka_nether_destroycards = false
	end,
	defeat = function (self)
		G.GAME.payasaka_nether_destroycards = false
	end,
}

local calc_context = SMODS.calculate_context
function SMODS.calculate_context(context, return_table)
	if G.GAME and G.GAME.payasaka_nether_destroycards and context.after then
		local destroy = {}
		for _, v in ipairs(G.play.cards) do
			destroy[#destroy+1] = v
		end
		G.E_MANAGER:add_event(Event({
			func = function()
				for _, v in ipairs(destroy) do
					if SMODS.shatters(v) then
						v:shatter()
					else
						v:start_dissolve()
					end
				end

				play_sound("payasaka_flint")

				G.E_MANAGER:add_event(Event({
					func = function()
						calc_context({
							remove_playing_cards = true,
							removed = destroy
						})
						return true
					end,
				}))

				return true
			end,
		}))

		for _, v in ipairs(destroy) do
			if SMODS.shatters(v) then
				v.shattered = true
			else
				v.destroyed = true
			end
		end
	end
	return calc_context(context, return_table)
end