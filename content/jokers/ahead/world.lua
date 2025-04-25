SMODS.Joker {
	key = 'world',
	name = "World is Spades",
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 3, y = 3 },
	atlas = "JOE_Jokers",
	config = { extra = { x_chips = 0.1, odds = 4, f_x_chips = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_chips, not card.ability.cry_rigged and (G.GAME.probabilities.normal or 1) or card.ability.extra.odds, card.ability.extra.odds, card.ability.extra.f_x_chips } }
	end,
	calculate = function(self, card, context)
		if context.before then
			for i = 1, #context.scoring_hand do
				local _c = context.scoring_hand[i]
				local prob = pseudorandom("payasaka_world") < (G.GAME.probabilities.normal or 1)/card.ability.extra.odds
				if (not _c:is_suit('Spades')) and prob then
					card.ability.extra.f_x_chips = card.ability.extra.f_x_chips + card.ability.extra.x_chips
					G.E_MANAGER:add_event(Event{
						func = function()
							_c:change_suit('Spades')
							_c:juice_up()
							card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize("k_upgrade_ex"), instant = true })
							return true
						end
					})
					delay(0.8125)
				end
				print("hi")
			end
		end
		if context.joker_main then
			return {
				xchips = card.ability.extra.f_x_chips
			}
		end
	end
}