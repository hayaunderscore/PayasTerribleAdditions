PTASaka.should_clone = true

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
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.payasaka_pre_setting_blind and G.GAME.blind_on_deck == 'Boss' then
			G.GAME.risk_cards_risks = G.GAME.risk_cards_risks or {}
			-- Prevent Rift-Raft from cloning Risk cards created by Live Fast
			PTASaka.should_clone = false
			local juice_card = context.blueprint_card or card
			local c = {}
			for i = 1, card.ability.extra.risk_count do
				local risk = SMODS.add_card({set = "Risk", area = G.play, skip_materialize = true})
				if risk then
					risk:start_materialize({G.C.SECONDARY_SET.Risk})
					risk:use_consumeable(risk.area, nil)
					juice_card:juice_up()
					SMODS.calculate_context({using_consumeable = true, consumeable = risk, area = G.consumeables})
					G.E_MANAGER:add_event(Event{
						trigger = 'after',
						delay = 0.2,
						func = function()
							risk:start_dissolve()
							juice_card:juice_up()
							return true
						end
					})
					table.insert(c, risk)
				end
			end
			PTASaka.should_clone = true
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

if RIFTRAFT then
	local cvca = RIFTRAFT.check_valid_creation_area
	function RIFTRAFT.check_valid_creation_area(area)
		if not PTASaka.should_clone then return false end
		return cvca(area)
	end
end