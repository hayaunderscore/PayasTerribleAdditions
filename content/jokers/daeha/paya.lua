SMODS.Scoring_Parameter {
	key = 'misc',
	default_value = 0,
	colour = G.C.PAYA_PURPLE,
	calculation_keys = {},
	flame_handler = function(self)
		return {
			id = 'flame_' .. self.key,
			arg_tab = self.key .. '_flames',
			colour = G.C.PAYA_PURPLE,
			accent = self.lick
		}
	end,
}

-- ITS MEEEE
SMODS.Joker {
	name = "Paya",
	key = 'paya',
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers",
	pos = { x = 0, y = 6 },
	soul_pos = { x = 2, y = 6, extra = { x = 1, y = 6 } },
	cost = 25,
	no_doe = true, -- :]
	demicoloncompat = false,
	blueprint_compat = true,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	add_to_deck = function(self, card, from_debuff)
		G.GAME.payasaka_misc_enabled = true
		G.E_MANAGER:add_event(Event {
			func = function()
				SMODS.set_scoring_calculation(G.GAME.current_scoring_calculation.key)
				G.HUD:remove()
				G.HUD = UIBox {
					definition = create_UIBox_HUD(),
					config = { align = ('cli'), offset = { x = -0.7, y = 0 }, major = G.ROOM_ATTACH }
				}
				G.HUD_blind.config.major = G.HUD:get_UIE_by_ID('row_blind_bottom')
				G.hand_text_area = {
					chips = G.HUD:get_UIE_by_ID('hand_chips'),
					mult = G.HUD:get_UIE_by_ID('hand_mult'),
					ante = G.HUD:get_UIE_by_ID('ante_UI_count'),
					round = G.HUD:get_UIE_by_ID('round_UI_count'),
					chip_total = G.HUD:get_UIE_by_ID('hand_chip_total'),
					handname = G.HUD:get_UIE_by_ID('hand_name'),
					hand_level = G.HUD:get_UIE_by_ID('hand_level'),
					game_chips = G.HUD:get_UIE_by_ID('chip_UI_count'),
					blind_chips = G.HUD_blind:get_UIE_by_ID('HUD_blind_count'),
					blind_spacer = G.HUD:get_UIE_by_ID('blind_spacer')
				}
				attention_text({
					text = "???",
					scale = 1.2,
					hold = 0.7,
					cover = G.HUD:get_UIE_by_ID('hand_text_area'),
					cover_colour = G.C.PAYA_PURPLE,
					align = 'cm',
				})
				return true
			end
		})
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.payasaka_misc_enabled = not not next(SMODS.find_card('j_payasaka_paya'))
		SMODS.set_scoring_calculation(G.GAME.current_scoring_calculation.key)
	end
}
