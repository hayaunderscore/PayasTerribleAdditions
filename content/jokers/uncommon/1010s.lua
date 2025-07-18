-- Ten 10s
SMODS.Joker {
	name = "Ten 10s",
	key = "tentens",
	config = { extra = { odds = 20, chance = 1, repetitions = 20 } },
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
		return { vars = { num, den, card.ability.extra.repetitions } }
	end,
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 0, y = 2 },
	soul_pos = { x = 1, y = 2 },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = false,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			if SMODS.pseudorandom_probability(card, 'payasaka_tentens', 1, card.ability.extra.odds) then
				if not Talisman or not Talisman.config_file.disable_anims then
					G.E_MANAGER:add_event(Event({
						func = function()
							card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
								{ message = localize('k_payasaka_lucky_ex'), colour = G.C.GREEN, instant = true })
							play_sound("payasaka_lucky", 1.0, 0.7)
							return true
						end
					}))
				end
				return {
					remove_default_message = true,
					colour = G.C.GREEN,
					color = G.C.GREEN,
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
			end
		end
	end
}
