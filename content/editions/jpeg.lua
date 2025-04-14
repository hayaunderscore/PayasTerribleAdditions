SMODS.Shader {
	key = 'jpeg',
	path = 'jpeg.fs'
}

SMODS.Edition {
	key = 'jpeg',
	shader = 'payasaka_jpeg',
	sound = { sound = "payasaka_jpej", per = 1.2, vol = 0.4 },
	config = {
		extra = {
			x_mult = 1.5,
			x_chips = 1.5,
			odds = 8,
		}
	},
	calculate = function (self, card, context)
		if context.main_scoring and (context.cardarea == G.hand or context.cardarea == G.play) then
			if context.cardarea == G.play then
				card.ability.scored = true
			end
			return {
				x_mult = card.edition.extra.x_mult,
				x_chips = card.edition.extra.x_chips,
			}
		end
		if context.pre_joker and (context.cardarea == G.jokers) then
			card.ability.scored = true
			return {
				x_mult = card.edition.extra.x_mult,
				x_chips = card.edition.extra.x_chips,
			}
		end
		if context.end_of_round and not context.game_over then
			local thunk = not card.base or card.ability.scored
			if thunk and pseudorandom('payasaka_jpeg') < ((G.GAME.probabilities.normal or 1) / card.edition.extra.odds) then
				local coin = pseudorandom('payasaka_jpeg') >= 0.5
				if coin or not card.base then
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Editioned!" })
					card:set_edition(poll_edition('payasaka_newspaper', nil, Cryptid == nil, true), true)
				else
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Enhanced!" })
					card:set_ability(pseudorandom_element(G.P_CENTER_POOLS["Enhanced"], pseudorandom('payasaka_jpeg')), nil, true)
				end
			end
			card.ability.scored = false
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.edition.extra.x_chips, card.edition.extra.x_mult, G.GAME.probabilities.normal or 1, card.edition.extra.odds
			}
		}
	end
}