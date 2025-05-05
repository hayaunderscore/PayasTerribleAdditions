--[[ Will probably come back as a daehA joker....
-- Rei
SMODS.Joker {
	name = "Reistorm",
	key = "reistorm",
	config = { extra = { repetitions = 2, odds = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 2, y = 0 },
	cost = 25,
	blueprint_compat = true,
	demicoloncompat = false,
	calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker then
			return {
				message = localize("k_again_ex"),
				repetitions = card.ability.extra.repetitions,
				card = context.blueprint_card or card,
			}
		end
		if context.end_of_round and context.game_over == false then
			if pseudorandom("payasaka_reistorm") < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						local card = create_card("Joker", G.jokers, false, 3, false, nil, nil, "")
						card:set_edition('e_negative', true)
						card:add_to_deck()
						G.jokers:emplace(card)
						return true
					end
				}))
			end
		end
	end
}
]]