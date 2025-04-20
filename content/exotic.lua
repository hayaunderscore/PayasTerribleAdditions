SMODS.Joker {
	name = "Doodle Kosmos",
	key = 'doodlekosmos',
	rarity = "cry_exotic",
	atlas = "JOE_Exotic",
	pos = { x = 0, y = 0 },
	soul_pos = { x = 2, y = 0, draw = function(card, scale_mod, rotate_mod)
		local shader = card.ability.extra.evolved and 'negative' or 'dissolve'
		local send = card.ability.extra.evolved and card.ARGS.send_to_shader or nil
		card.children.floating_sprite:draw_shader(shader,0, send, nil, card.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
		card.children.floating_sprite:draw_shader(shader, nil, send, nil, card.children.center, scale_mod, rotate_mod)
	end, extra = { x = 1, y = 0 } },
	cost = 50,
	config = { extra = { ee_mult = 1.06, ee_mult_add = .06, evolved = false, odds = 16 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.ee_mult, card.ability.extra.ee_mult_add, card.ability.cry_rigged and card.ability.extra.odds or (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		key = "j_payasaka_doodlekosmos"..(card.ability.extra.evolved and "_alt" or "") }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				ee_mult = not card.ability.extra.evolved and card.ability.extra.ee_mult or 1,
				eee_mult = card.ability.extra.evolved and card.ability.extra.ee_mult or 1,
				colour = G.C.DARK_EDITION,
			}
		end
		if context.individual and context.cardarea == G.hand and not context.end_of_round then
			card.ability.extra.ee_mult = card.ability.extra.ee_mult + card.ability.extra.ee_mult_add
			context.other_card:juice_up()
			return {
				message = localize("k_upgrade_ex"),
				colour = G.C.DARK_EDITION,
				card = card
			}
		end
		if context.end_of_round and context.cardarea == G.jokers and not card.ability.extra.evolved then
			local rng = pseudorandom("payasaka_doodlekosmos")
			if rng < (G.GAME.probabilities.normal or 1) / card.ability.extra.odds or card.ability.cry_rigged then
				G.E_MANAGER:add_event(Event{
					func = function()
						card.ability.extra.evolved = true
						card.ability.cry_rigged = false
						play_sound('talisman_eeemult')
						card_eval_status_text(card, 'extra', nil, nil, nil, {
							message = "Evolved!",
							colour = G.C.DARK_EDITION,
						})
						return true
					end
				})
			end
		end
	end
}
