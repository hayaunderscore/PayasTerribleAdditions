SMODS.Joker {
	name = "pta-doogleaiko",
	key = 'iroyokia',
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers2",
	pos = { x = 4, y = 0 },
	soul_pos = { x = 0, y = 1, draw = function(card, scale_mod, rotate_mod)
		local scale_mod = 0.1
		local rotate_mod = 0.08 * math.cos(1.94236 * G.TIMERS.REAL)
		local xmod = 0
		local ymod = 0.1 * math.sin(2.1654 * G.TIMERS.REAL) - 0.1
		card.children.floating_sprite:draw_shader('dissolve', 0, nil, nil, card.children.center, scale_mod, rotate_mod,
			xmod, ymod, nil, 0.6)
		card.children.floating_sprite:draw_shader('dissolve', nil, nil, nil, card.children.center, scale_mod, rotate_mod,
			xmod, ymod - 0.2)
		if card.edition then
			for k, v in pairs(G.P_CENTER_POOLS.Edition) do
				if v.apply_to_float then
					if card.edition[v.key:sub(3)] then
						card.children.floating_sprite:draw_shader(v.shader, nil, nil, nil, card.children.center,
							scale_mod, rotate_mod, xmod, ymod - 0.2)
					end
				end
			end
		end
	end },
	cost = 25,
	no_doe = true, -- :]
	demicoloncompat = false,
	config = { immutable = { prev_state = 0 } },
	loc_vars = function(self, info_queue, card)
		if AKYRS then
			info_queue[#info_queue + 1] = G.P_CENTERS.j_akyrs_aikoyori
		end
	end,
	update = function(self, card, dt)
		if G.STATE == G.STATES.GAME_OVER then
			G.STATE = card.ability.immutable.prev_state
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Nope!" })
			G.FUNCS.draw_from_discard_to_deck()
			G.STATE = G.STATES.DRAW_TO_HAND
			ease_hands_played(G.GAME.round_resets.hands - G.GAME.current_round.hands_left)
			ease_discard(G.GAME.round_resets.discards - G.GAME.current_round.discards_left)
			G.STATE_COMPLETE = false
		end
		card.ability.immutable.prev_state = G.STATE
	end,
	calculate = function(self, card, context)
		if next(SMODS.find_card('j_akyrs_aikoyori')) then
			local ret = {}
			for _, aiko in ipairs(SMODS.find_card('j_akyrs_aikoyori')) do
				ret[#ret + 1] = SMODS.blueprint_effect(card, aiko, context)
			end
			return PTASaka.recursive_extra(ret, 1)
		end
		return nil, false
	end
}

local u_g_e = Game.update_game_over
function Game:update_game_over(dt)
	if next(SMODS.find_card('j_payasaka_iroyokia')) then return end
	u_g_e(self, dt)
end
