SMODS.Blind {
	key = 'showdown_sweet_sleep',
	atlas = "JOE_Blinds",
	pos = { x = 0, y = 4 },
	dollars = 6,
	mult = -math.huge,
	boss_colour = HEX('7b194e'),
	boss = { min = 39, showdown = true },
	set_blind = function(self)
		G.GAME.blind.chip_text = "TREE(3)"
		G.GAME.payasaka_scored_naneinfs = 0
	end,
	disable = function(self)
		G.GAME.blind.disabled = false
		play_sound("payasaka_loudbuzzer", 1, 0.2)
		attention_text({
			text = localize("k_nope_ex"),
			scale = 1, 
			hold = 1.0,
			rotate = math.pi / 8,
			backdrop_colour = G.GAME.blind.boss_colour,
			align = "cm",
			major = G.GAME.blind,
			offset = {x = 0, y = 0.1}
		})
	end,
	calculate = function(self, blind, context)
		if context.after then
			if to_big(hand_chips*mult) == to_big(math.huge) then
				G.GAME.payasaka_scored_naneinfs = G.GAME.payasaka_scored_naneinfs + 1
			end
		end
	end,
	in_pool = function(self)
		return false
	end
}

local old_get_new_boss = get_new_boss
function get_new_boss()
	-- Are you up 2 it?
	if G.GAME.round_resets.ante == 39 and not Cryptid then
		return "bl_payasaka_showdown_sweet_sleep"
	end
	return old_get_new_boss()
end