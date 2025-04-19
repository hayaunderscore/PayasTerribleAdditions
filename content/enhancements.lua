SMODS.Enhancement {
	name = "Damp",
	key = 'damp',
	atlas = "JOE_Enhancements",
	pos = { x = 0, y = 0 },
	config = { x_chips = 1.5, x_mult = 1.5, odds = 8 },
	always_scores = true,
	calculate = function(self, card, context)
		if context.final_scoring_step and context.cardarea == G.play then
			if pseudorandom("payasaka_damp_card") < (G.GAME.probabilities.normal or 1) / card.ability.odds and not next(SMODS.find_card('j_payasaka_rainy')) then
				G.E_MANAGER:add_event(Event{
					delay = 0.2,
					func = function()
						card:set_ability(G.P_CENTERS.m_payasaka_wet)
						card:juice_up()
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Wet!", colour = G.C.BLUE })
						return true
					end
				})
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_payasaka_wet
		return {
			vars = { card.ability.x_chips, card.ability.x_mult, (G.GAME.probabilities.normal or 1), card.ability.odds }
		}
	end
}

SMODS.Enhancement {
	name = "Wet",
	key = 'wet',
	atlas = "JOE_Enhancements",
	pos = { x = 1, y = 0 },
	replace_base_card = true,
	no_rank = true,
	any_suit = true,
	config = { bonus = 100 },
	always_scores = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.bonus } }
	end
}