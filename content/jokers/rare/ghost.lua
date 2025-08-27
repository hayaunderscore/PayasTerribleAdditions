SMODS.Joker {
	name = "pta-sissel",
	key = "sissel",
	rarity = 3,
	atlas = "JOE_Jokers2",
	pos = { x = 0, y = 0 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = false,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.before then
			G.E_MANAGER:add_event(Event{
				func = function()
					PTASaka.create_soul_aura_for_card(card)
					card.pta_tricked = true
					return true
				end
			})
		end
		if context.individual and not context.end_of_round and not context.payasaka_tricking and context.cardarea == G.play then
			local old_other_card = context.other_card
			local c = pseudorandom_element(context.scoring_hand, pseudoseed('ghost_trick'))
			context.other_card = c
			context.payasaka_tricking = true
			card_eval_status_text(card, 'extra', nil, nil, nil, {
				message = 'Trick!',
				extrafunc = function()
					c:juice_up()
					c.pta_tricked = true
					PTASaka.create_soul_aura_for_card(c)
					return true
				end
			})
			SMODS.score_card(c, context)
			G.E_MANAGER:add_event(Event {
				func = function()
					c.pta_tricked = false
					return true
				end
			})
			context.payasaka_tricking = false
			context.other_card = old_other_card
			return nil, true
		end
		if context.pre_joker then
			G.E_MANAGER:add_event(Event{
				func = function()
					card.pta_tricked = false
					return true
				end
			})
		end
	end
}
