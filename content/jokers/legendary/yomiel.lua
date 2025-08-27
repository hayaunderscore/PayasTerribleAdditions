SMODS.Joker {
	name = "pta-yomiel",
	key = "yomiel",
	rarity = 4,
	atlas = "JOE_Jokers2",
	pos = { x = 3, y = 0 },
	cost = 25,
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
			G.E_MANAGER:add_event(Event {
				func = function()
					PTASaka.create_soul_aura_for_card(card)
					card.pta_tricked = true
					return true
				end
			})
		end
		if context.individual and not context.end_of_round and context.cardarea == G.play then
			local valid_jokers = {}
			for _, car in ipairs(G.jokers.cards) do
				if car.ability.set == "Joker" and PTASaka.check_forcetrigger(car) and car ~= card then valid_jokers[#valid_jokers + 1] = car end
			end
			if not next(valid_jokers) then return nil, false end
			local c = pseudorandom_element(valid_jokers, pseudoseed('ghost_trick'))
			card_eval_status_text(card, 'extra', nil, nil, nil, {
				message = 'Trick!',
				extrafunc = function()
					c:juice_up()
					c.pta_tricked = true
					PTASaka.create_soul_aura_for_card(c)
					return true
				end
			})
			local effects = {}
			local joker_eval, post = PTASaka.forcetrigger(c, context)
			if next(joker_eval) then
                if joker_eval.edition then joker_eval.edition = {} end
                table.insert(effects, joker_eval)
                for _, v in ipairs(post) do effects[#effects+1] = v end
                if joker_eval.retriggers then
                    for rt = 1, #joker_eval.retriggers do
                        local rt_eval, rt_post = eval_card(c, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = context.scoring_hand, scoring_name = context.scoring_name, poker_hands = context.poker_hands, joker_main = true, retrigger_joker = true})
                        table.insert(effects, {retriggers = joker_eval.retriggers[rt]})
                        table.insert(effects, rt_eval)
                        for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                    end
                end
            end
			SMODS.trigger_effects(effects, c)
			G.E_MANAGER:add_event(Event {
				func = function()
					c.pta_tricked = false
					return true
				end
			})
			return nil, true
		end
		if context.pre_joker then
			G.E_MANAGER:add_event(Event {
				func = function()
					card.pta_tricked = false
					return true
				end
			})
		end
	end
}
