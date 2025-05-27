SMODS.Joker {
	name = "Live Fast",
	key = 'livefast',
	config = { extra = { mult = 15, risk_count = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.risk_count } }
	end,
	atlas = "JOE_Jokers",
	pos = { x = 9, y = 5 },
	cost = 3,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		if context.payasaka_pre_setting_blind and G.GAME.blind_on_deck == 'Boss' and not context.blueprint_card then
			G.GAME.risk_cards_risks = G.GAME.risk_cards_risks or {}
			card:juice_up()
			local c = {}
			for i = 1, card.ability.extra.risk_count do
				local risk = SMODS.add_card({set = "Risk", area = G.play})
				if risk then
					risk:start_materialize()
					risk:use_consumeable(risk.area, nil)
					SMODS.calculate_context({using_consumeable = true, consumeable = risk, area = G.consumeables})
					table.insert(c, risk)
				end
			end
			G.E_MANAGER:add_event(Event{
				trigger = 'after',
				delay = 0.4,
				func = function()
					for i = 1, #c do
						card:juice_up()
						c[i]:start_dissolve()
						return true
					end
				end
			})
			delay(0.4)
			return {
				override = G.GAME.round_resets.blind_choices.Boss
			}
		end
		if context.joker_main or context.forcetrigger then
			return {
				mult = card.ability.extra.mult
			}
		end
	end
}