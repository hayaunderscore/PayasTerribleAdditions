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
	config = { odds = 2, extra = { exponential_cnt = 0 } },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	loc_vars = function(self, info_queue, card)
		local str = localize('k_payasaka_' .. (card.ability.extra.exponential_cnt > 0 and "active" or "inactive"))
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.odds)
		return {
			vars = { card.ability.cry_rigged and den or num, den },
			main_end = {
				(G.GAME and card.area and (card.area == G.jokers)) and {
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes = {
						{
							n = G.UIT.C,
							config = { ref_table = card, align = "m", colour = card.ability.extra.exponential_active and G.C.GREEN or G.C.UI.TEXT_INACTIVE, r = 0.05, padding = 0.06 },
							nodes = {
								{ n = G.UIT.T, config = { text = ' ' .. str .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9 } },
							}
						}
					}
				} or nil
			}
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and SMODS.pseudorandom_probability(card, 'payasaka', 1, card.ability.odds) then
			card.ability.extra.exponential_cnt = card.ability.extra.exponential_cnt + 1
			G.E_MANAGER:add_event(Event {
				func = function()
					if Entropy then
						G.GAME.paya_operator = (G.GAME.paya_operator or 0) + 1
						update_operator_display()
					else
						G.GAME.payasaka_exponential_count = G.GAME.payasaka_exponential_count + 1
						local str = G.GAME.payasaka_exponential_count > 2 and
							string.format("{%d}", G.GAME.payasaka_exponential_count) or
							G.GAME.payasaka_exponential_count <= 0 and "X" or ("^"):rep(G.GAME.payasaka_exponential_count)
						PTASaka.recalc_chips_mult_shit(str)
					end
					play_sound('tarot2')
					return true
				end
			})
			return {
				message = card.ability.extra.exponential_cnt == 1 and localize('k_active_ex') or localize('k_payasaka_hyperactive_ex'),
				colour = card.ability.extra.exponential_cnt == 1 and G.C.GOLD or G.C.DARK_EDITION,
				card = context.blueprint_card or card
			}
		end
		while context.end_of_round and card.ability.extra.exponential_cnt > 0 and not context.individual do
			card.ability.extra.exponential_cnt = card.ability.extra.exponential_cnt - 1
			G.E_MANAGER:add_event(Event {
				func = function()
					if Entropy then
						G.GAME.paya_operator = math.max((G.GAME.paya_operator or 0) - 1, 0)
						update_operator_display()
					else
						G.GAME.payasaka_exponential_count = math.max(G.GAME.payasaka_exponential_count - 1, 0)
						local str = G.GAME.payasaka_exponential_count > 2 and
							string.format("{%d}", G.GAME.payasaka_exponential_count) or
							G.GAME.payasaka_exponential_count <= 0 and "X" or ("^"):rep(G.GAME.payasaka_exponential_count)
						PTASaka.recalc_chips_mult_shit(str)
					end
					play_sound('tarot2')
					return true
				end
			})
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_payasaka_inactive_ex') })
		end
	end
}
