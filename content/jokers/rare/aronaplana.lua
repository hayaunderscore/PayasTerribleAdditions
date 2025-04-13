-- Arona
SMODS.Joker {
	name = "Arona",
	key = "arona",
	config = { extra = { divchips = 0.5, givechips = 1.0, incchips = 0.1 } },
	loc_vars = function(self, info_queue, card)
		--info_queue[#info_queue+1] = G.P_CENTERS.j_payasaka_plana
		return {
			vars = { card.ability.extra.divchips, card.ability.extra.givechips, card.ability.extra.incchips }
		}
	end,
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 3, y = 2 },
	cost = 6,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.joker_main then
			if next(SMODS.find_card("j_payasaka_plana")) == nil then
				return {
					xchips = card.ability.extra.divchips,
					colour = G.C.NEGATIVE_EDITION,
					remove_default_message = true,
					message = "Teehee!"
				}
			end
			card.ability.extra.givechips = card.ability.extra.givechips + card.ability.extra.incchips
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
				message = localize("k_upgrade_ex")
			})
			return {
				xchips = card.ability.extra.givechips
			}
		end
	end
}

-- Plana
SMODS.Joker {
	name = "Plana",
	key = "plana",
	config = { extra = { givemult = 1.0, incmult = 0.05 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		return {
			vars = { card.ability.extra.givemult, card.ability.extra.incmult }
		}
	end,
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 4, y = 2 },
	cost = 6,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.joker_main then
			if next(SMODS.find_card("j_payasaka_arona")) ~= nil then
				card.ability.extra.givemult = card.ability.extra.givemult + card.ability.extra.incmult
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
					message = localize("k_upgrade_ex")
				})
				return {
					xmult = card.ability.extra.givemult
				}
			end
		end
		if context.end_of_round and context.cardarea == G.jokers then
			local _card = SMODS.add_card({ key = pseudorandom_element(G.P_CENTER_POOLS.Spectral,
				pseudoseed("payasaka_plana")).key })
			_card:set_edition('e_negative', true)
			card:juice_up()
		end
	end
}
