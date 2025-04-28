--[[ Removed because THIS SUCKS
-- Charred Joker
SMODS.Joker {
	name = "Charred Joker",
	key = "charred",
	config = { extra = { levels = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.levels } }
	end,
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 5, y = 0 },
	cost = 15,
	blueprint_compat = true,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards + 1
	end,
	calculate = function(self, card, context)
		if context.pre_discard and G.GAME.current_round.discards_used <= 0 and not context.hook then
			G.E_MANAGER:add_event(Event({
				func = function()
					local text, disp_text = G.FUNCS.get_poker_hand_info(context.full_hand)
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
						{ message = localize('k_upgrade_ex') })
					update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
						{ handname = localize(text, 'poker_hands'), chips = G.GAME.hands[text].chips, mult = G.GAME
						.hands[text].mult, level = G.GAME.hands[text].level })
					level_up_hand(context.blueprint_card or card, text, nil, card.ability.extra.levels)
					update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
						{ mult = 0, chips = 0, handname = '', level = '' })
					return true
				end
			}))
		end
	end
}
]]