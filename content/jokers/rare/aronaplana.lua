-- Arona
SMODS.Joker {
	name = "Arona",
	key = "arona",
	config = { extra = { divchips = 0.5, givechips = 1.0, incchips = 0.1 } },
	loc_vars = function(self, info_queue, card)
		local plana = G.P_CENTERS.j_payasaka_plana.config
		info_queue[#info_queue+1] = { key = "j_payasaka_plana", set = "Joker", specific_vars = { plana.extra.givemult, plana.extra.incmult, (G.GAME.probabilities.normal or 1), plana.odds } }
		return {
			vars = { card.ability.extra.divchips, card.ability.extra.givechips, card.ability.extra.incchips }
		}
	end,
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 3, y = 2 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
	pta_credit = {
		art = {
			credit = "Aikoyori",
			colour = HEX('65a49e')
		}
	},
	calculate = function(self, card, context)
		if next(SMODS.find_card("j_payasaka_plana")) and context.individual and context.cardarea == G.play and not context.end_of_round then
			-- light suits
			local other = context.other_card
			if other and (not other.debuff) and (other:is_suit('Diamonds') or other:is_suit('Hearts')) then
				card.ability.extra.givechips = card.ability.extra.givechips + card.ability.extra.incchips
				return {
					message = localize("k_upgrade_ex")
				}
			elseif other and other.debuff then
				return {
					message = localize('k_debuffed')
				}
			end
		end
		if context.joker_main then
			local should_return = not (not next(SMODS.find_card("j_payasaka_plana")))
			local my_pos = 0
			for i = 1, #G.jokers.cards do
				---@type Card
				local joker = G.jokers.cards[i]
				if joker == card or joker == PTASaka.adultcard_cardarea.pta_owner then
					my_pos = i
					break
				end
			end
			-- held at gunpoint
			if G.jokers.cards[my_pos-1] and G.jokers.cards[my_pos-1].config.center.key == "j_cry_demicolon" and not should_return then
				return nil, true
			end
			if not should_return then
				return {
					xchips = card.ability.extra.divchips,
					message = localize('k_payasaka_teehee_ex')
				}
			elseif should_return then
				return {
					xchips = card.ability.extra.givechips
				}
			end
		end
		-- no need to waste anything if we are forcetriggered
		if context.forcetrigger then
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
	config = { extra = { givemult = 1.0, incmult = 0.1 }, odds = 5 },
	loc_vars = function(self, info_queue, card)
		local arona = G.P_CENTERS.j_payasaka_arona.config
		info_queue[#info_queue+1] = { key = "j_payasaka_arona", set = "Joker", specific_vars = { arona.extra.divchips, arona.extra.givechips, arona.extra.incchips } }
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		return {
			vars = { card.ability.extra.givemult, card.ability.extra.incmult, card.ability.cry_rigged and card.ability.odds or (G.GAME.probabilities.normal or 1), card.ability.odds }
		}
	end,
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 4, y = 2 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.end_of_round then
			-- dark suits
			local other = context.other_card
			if other and (not other.debuff) and (other:is_suit('Spades') or other:is_suit('Clubs')) then
				card.ability.extra.givemult = card.ability.extra.givemult + card.ability.extra.incmult
				return {
					message = localize("k_upgrade_ex")
				}
			elseif other and other.debuff then
				return {
					message = localize('k_debuffed')
				}
			end
		end
		if context.joker_main or context.forcetrigger then
			-- forcibly create a spectral when forcetriggered
			if context.forcetrigger then
				G.E_MANAGER:add_event(Event{
					func = function()
						local _card = SMODS.add_card({ key = pseudorandom_element(G.P_CENTER_POOLS.Spectral,
							pseudoseed("payasaka_plana")).key })
						_card:set_edition('e_negative', true)
						card:juice_up()
						return true
					end
				})
			end
			if next(SMODS.find_card("j_payasaka_arona")) ~= nil or context.forcetrigger then
				return {
					xmult = card.ability.extra.givemult
				}
			end
		end
		if context.end_of_round and context.cardarea == G.jokers and ((pseudorandom('plana_gift_card') < (G.GAME.probabilities.normal or 1)/card.ability.odds)) then
			local _card = SMODS.add_card({ key = pseudorandom_element(G.P_CENTER_POOLS.Spectral,
				pseudoseed("payasaka_plana")).key })
			_card:set_edition('e_negative', true)
			card:juice_up()
		end
	end
}
