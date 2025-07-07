-- Finity cross mod
if next(SMODS.find_mod('finity')) then
	FinisherBossBlindStringMap = FinisherBossBlindStringMap or {}
	FinisherBossBlindStringMap["bl_payasaka_showdown_sweet_sleep"] = {"j_payasaka_sweet_sleep", "Sweet Sleep"}
	FinisherBossBlindQuips = FinisherBossBlindQuips or {}
	FinisherBossBlindQuips["bl_payasaka_showdown_sweet_sleep"] = {"perfectheart", 4}
end

-- Yes, this is an OMORI reference.
SMODS.Blind {
	key = 'showdown_sweet_sleep',
	atlas = "JOE_Blinds",
	pos = { x = 0, y = 4 },
	dollars = 8,
	mult = 4,
	boss_colour = HEX('ff63ac'),
	boss = { min = 39, showdown = true },
	config = { funny = { mult = -0.25 } },
	set_blind = function(self)
		if G.GAME.round_resets.ante == 39 then
			G.GAME.blind.chip_text = "TREE(3)"
			-- Set blind chips to NaN
			if Talisman then
				G.GAME.blind.chips = to_big("nan")
			else
				G.GAME.blind.chips = math.huge/math.huge
			end
			G.GAME.payasaka_scored_naneinfs = 0
		end
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
			offset = { x = 0, y = 0.1 }
		})
	end,
	calculate = function(self, blind, context)
		if context.after then
			if G.GAME.round_resets.ante ~= 39 then
				local chips = to_big(PTASaka.arrow(G.GAME.payasaka_exponential_count or 0, hand_chips, mult))
				if chips < to_big(G.GAME.blind.chips) then
					G.E_MANAGER:add_event(Event({
						trigger = 'ease',
						blocking = false,
						ref_table = G.GAME,
						ref_value = 'chips',
						ease_to = chips * self.config.funny.mult,
						delay = 0.5,
						func = (function(t) return math.floor(t) end)
					}))
				end
			else
				if to_big(PTASaka.arrow(G.GAME.payasaka_exponential_count or 0, hand_chips, mult)) == to_big(Talisman and "Infinity" or math.huge) or to_big(PTASaka.arrow(G.GAME.payasaka_exponential_count or 0, hand_chips, mult)) == to_big(Talisman and "NaN" or -(math.huge/math.huge)) then
					G.GAME.payasaka_scored_naneinfs = G.GAME.payasaka_scored_naneinfs + 1
				end
			end
		end
	end,
	loc_vars = function(self)
		return {
			vars = { self.config.funny.mult },
			key = (G and G.GAME and G.GAME.round_resets and (G.GAME.round_resets.ante or 0) and G.STAGE == G.STAGES.RUN) == 39 and
			"bl_payasaka_showdown_sweet_sleep" or "bl_payasaka_showdown_sweet_sleep_alt"
		}
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
