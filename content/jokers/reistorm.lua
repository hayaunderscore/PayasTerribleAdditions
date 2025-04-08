-- Rei
SMODS.Joker {
	name = "Reistorm",
	key = "reistorm",
	loc_txt = {
		name = "Reistorm",
		text = {
			"Retriggers all Jokers",
			"an additional {C:attention}#1#{} times",
			"with {C:green}#2# in #3#{} chance of",
			"creating a random",
			"{C:dark_edition}Negative{} {C:red}Rare{C:attention} Joker{}",
			"at end of round",
			"{C:inactive,s:0.8}Technically not a Brainstorm{}",
			"{C:inactive,s:0.8}but whatever{}",
		}
	},
	config = { extra = { repetitions = 2, odds = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 2, y = 0 },
	cost = 25,
	blueprint_compat = true,
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
