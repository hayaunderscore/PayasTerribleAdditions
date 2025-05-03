SMODS.Joker {
	key = "envelope",
	name = "Envelope",
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 5, y = 7 },
	atlas = "JOE_Jokers",
	pools = {["Joker"] = true, ["Meme"] = true},
	config = {odds = 4, x_chips = 1, x_chips_add = 0.5},
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers and not (context.game_over and context.individual and context.repetition) then
			if pseudorandom('payasaka_envelope') < (G.GAME.probabilities.normal or 1)/card.ability.odds then
				G.E_MANAGER:add_event(Event{
					func = function()
						-- Create a completely random consumable
						local pool = {}
						for k, center in pairs(G.P_CENTER_POOLS.Consumeables) do
							if not (center.hidden and center.no_doe) then
								pool[#pool + 1] = center
							end
						end
						local center = pseudorandom_element(pool, pseudoseed('envelope'))
						local area = center.set == 'DOSCard' and PTASaka.dos_cardarea or G.consumeables
						SMODS.add_card { key = center.key, area = area, edition = "e_negative" }
						return true
					end
				})
				card.ability.x_chips = card.ability.x_chips + card.ability.x_chips_add
				return {
					message = localize('k_upgrade_ex'),
					card = card
				}
			end
		end
		if context.joker_main then
			return {
				x_chips = card.ability.x_chips
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.cry_rigged and card.ability.odds or G.GAME.probabilities.normal or 1,
				card.ability.odds,
				card.ability.x_chips_add,
				card.ability.x_chips
			}
		}
	end
}