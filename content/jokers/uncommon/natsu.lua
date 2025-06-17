SMODS.Joker {
	name = "pta-SweetRock",
	key = "sweetrock",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 3, y = 1 },
	soul_pos = { x = 4, y = 1 },
	pta_front_pos = { x = 5, y = 1 },
	cost = 6,
	blueprint_compat = false,
	demicoloncompat = true,
	config = { extra = { odds = 3 } },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and not context.end_of_round and pseudorandom('na-na-na-natsu') < (G.GAME.probabilities.normal or 1)/card.ability.extra.odds then
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = 'Rock!' })
			local other = context.other_card
			G.E_MANAGER:add_event(Event{
				func = function()
					other:juice_up()
					return true
				end
			})
			context.cardarea = G.play
			SMODS.score_card(context.other_card, context)
			context.cardarea = G.hand
			return nil, true
		end
		if context.forcetrigger then
			local c = pseudorandom_element(G.hand.cards, pseudoseed('na-na-na-natsu'))
			if c then
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = 'Rock!' })
				G.E_MANAGER:add_event(Event{
					func = function()
						c:juice_up()
						return true
					end
				})
				context.cardarea = G.play
				context.main_scoring = true
				local effects = { eval_card(c, context) }
				context.main_scoring = nil
				SMODS.trigger_effects(effects, c)
				context.cardarea = G.hand
				return nil, true
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end
}
