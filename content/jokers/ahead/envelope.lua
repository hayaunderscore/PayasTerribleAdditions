SMODS.Joker {
	key = "envelope",
	name = "Envelope",
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	demicoloncompat = true,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 5, y = 7 },
	atlas = "JOE_Jokers",
	pools = {["Joker"] = true, ["Meme"] = true},
	config = {odds = 4, x_chips = 1, x_chips_add = 0.5},
	calculate = function(self, card, context)
		if (context.end_of_round and context.main_eval and not (context.game_over)) or context.forcetrigger then
			if SMODS.pseudorandom_probability(card, '2starpull', 1, card.ability.odds) then
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
				SMODS.scale_card(card, {
					ref_table = card.ability,
					ref_value = "x_chips",
					scalar_value = "x_chips_add",
				})
			end
		end
		if context.joker_main then
			return {
				x_chips = card.ability.x_chips
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.odds)
		return {
			vars = {
				card.ability.cry_rigged and den or num,
				den,
				card.ability.x_chips_add,
				card.ability.x_chips
			}
		}
	end
}