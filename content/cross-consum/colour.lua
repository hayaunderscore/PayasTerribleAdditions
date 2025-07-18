-- for the funny progress bar.
function progressbar(val, max)
	if max > 10 then
		return val, "/" .. max
	end
	return string.rep("#", val), string.rep("#", max - val)
end

-- Maroon
SMODS.Consumable {
	set = "Colour",
	name = "col_Maroon",
	key = "mfc_maroon",
	atlas = "JOE_Colours",
	pos = { x = 0, y = 0 },
	unlocked = true,
	discovered = true,
	config = {
		val = 0,
		partial_rounds = 0,
		upgrade_rounds = 1,
	},
	cost = 4,
	display_size = { w = 71, h = 87 },
	pixel_size = { w = 71, h = 87 },
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		art = {
			credit = 'Multi',
			colour = HEX('98acb1')
		}
	},
	dependencies = "MoreFluff",
	can_use = function(self, card)
		return (card.ability.val > 0) and (G.STATE == G.STATES.BLIND_SELECT or booster_obj or G.STATE == G.STATES.SHOP or G.STATE == G.STATES.ROUND_EVAL)
	end,
	use = function(self, card, area, copier)
		local risks = {}
		for i = 1, card.ability.val do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					-- Prevent Rift-Raft from cloning Risk cards created by this
					PTASaka.should_clone = false
					play_sound('timpani')
					local risk = SMODS.add_card({ set = "Risk", area = G.play, skip_materialize = true })
					card:juice_up(0.3, 0.5)
					risk:start_materialize({G.C.SECONDARY_SET.Risk})
					risk:juice_up(0.3, 0.5)
					PTASaka.should_clone = false
					risks[#risks+1] = risk
					return true
				end
			}))
		end
		for i = 1, card.ability.val do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					local risk = risks[i]
					if risk then
						risk:use_consumeable(risk.area, nil)
						SMODS.calculate_context({ using_consumeable = true, consumeable = risk, area = G.consumeables })
						G.E_MANAGER:add_event(Event {
							trigger = 'after',
							delay = 0.2,
							func = function()
								risk:start_dissolve()
								return true
							end
						})
					end
					return true
				end
			}))
		end
		delay(0.6)
	end,
	loc_vars = function(self, info_queue, card)
		local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
		return { vars = { card.ability.val, val, max, card.ability.upgrade_rounds } }
	end
}

-- Light Blue
SMODS.Consumable {
	set = "Colour",
	name = "col_Light_Blue",
	key = "mfc_lightblue",
	atlas = "JOE_Colours",
	pos = { x = 1, y = 0 },
	unlocked = true,
	discovered = true,
	config = {
		val = 0,
		partial_rounds = 0,
		upgrade_rounds = 2,
		blind_size_multiplier = 1.2,
	},
	cost = 4,
	display_size = { w = 71, h = 87 },
	pixel_size = { w = 71, h = 87 },
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		art = {
			credit = 'Multi',
			colour = HEX('98acb1')
		}
	},
	dependencies = "MoreFluff",
	can_use = function(self, card)
		return card.ability.val > 0
	end,
	use = function(self, card, area, copier)
		local card_type = "Reward"
		local rng_seed = "lightblue"
		for i = 1, card.ability.val do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					play_sound('timpani')
					local n_card = create_card(card_type, G.consumeables, nil, nil, nil, nil, nil, rng_seed)
					n_card:add_to_deck()
					n_card:set_edition({ negative = true }, true)
					G.consumeables:emplace(n_card)
					card:juice_up(0.3, 0.5)
					return true
				end
			}))
		end
		delay(0.6)
	end,
	loc_vars = function(self, info_queue, card)
		local val, max = progressbar(card.ability.partial_rounds, card.ability.upgrade_rounds)
		return { vars = { card.ability.val, val, max, card.ability.upgrade_rounds, card.ability.blind_size_multiplier } }
	end
}
