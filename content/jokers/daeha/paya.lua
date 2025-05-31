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
	config = { odds = 2, extra = { exponential_cnt = 0 } },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	loc_vars = function(self, info_queue, card)
		local str = localize('k_payasaka_' .. (card.ability.extra.exponential_cnt > 0 and "active" or "inactive"))
		return {
			vars = { card.ability.cry_rigged and card.ability.odds or (G.GAME.probabilities.normal or 1), card.ability.odds },
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
		if context.setting_blind and ((pseudorandom('paya_hell') < (G.GAME.probabilities.normal or 1) / card.ability.odds) or card.ability.cry_rigged) then
			card.ability.extra.exponential_cnt = card.ability.extra.exponential_cnt + 1
			G.E_MANAGER:add_event(Event {
				func = function()
					G.GAME.payasaka_exponential_count = G.GAME.payasaka_exponential_count + 1
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
					G.GAME.payasaka_exponential_count = math.max(G.GAME.payasaka_exponential_count - 1, 0)
					return true
				end
			})
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_payasaka_inactive_ex') })
		end
	end
}
