---@class RiskObject: Node
PTASaka.RiskObject = Node:extend()
function PTASaka.RiskObject:init(key)
	---@type Risk
	self.center = key and G.P_CENTERS[key] or {}
	self.ability = next(self.center) and copy_table(self.center.config) or {}
end

function PTASaka.RiskObject:calculate(context)
	if self.center.risk_calculate and type(self.center.risk_calculate) == 'function' then
		return self.center:risk_calculate(self, context)
	end
end

function PTASaka.RiskObject:save()
	local tbl = {
		ability = self.ability
	}
	for _, v in ipairs(G.P_CENTER_POOLS.Risk) do
		if v and v.key == self.center.key then
			tbl.config_name = v.key
		end
	end

	return tbl
end

function PTASaka.RiskObject:load(tbl)
	self.center = G.P_CENTERS[tbl.config_name]
	self.ability = tbl.ability
end

SMODS.ConsumableType {
	key = 'Risk',
	collection_rows = { 8, 6, 4 },
	primary_colour = HEX('c42430'),
	secondary_colour = HEX('891e2b'),
	shop_rate = 0,
	loc_txt = {},
	default = 'c_payasaka_crime'
}

SMODS.UndiscoveredSprite {
	key = 'Risk',
	atlas = 'JOE_Risk',
	path = 'risk.png',
	pos = { x = 9, y = 5 },
	px = 71, py = 95,
}

G.C.SET.Risk = HEX('c42430')
G.C.SECONDARY_SET.Risk = HEX('891e2b')

---@class Risk: SMODS.Consumable
---@field risk_calculate? fun(self: Risk|table, risk: RiskObject|table, context: CalcContext|table): table?, boolean?  Calculates effects based on parameters in `context`. See [SMODS calculation](https://github.com/Steamodded/smods/wiki/calculate_functions) docs for details. 
---@overload fun(self: Risk): Risk
PTASaka.Risk = SMODS.Consumable:extend {
	set = 'Risk',
	config = { extra = {} },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	tier = 1,
	use = function(self, card, area, copier)
		G.GAME.risk_cards_risks[#G.GAME.risk_cards_risks + 1] = {
			key = self.key,
			ability = PTASaka.deep_copy(card
				.ability.extra)
		}
		local top_dynatext = nil
		local bot_dynatext = nil

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				top_dynatext = DynaText({ string = localize { type = 'name_text', set = self.set, key = self.key }, colours = { G.C.WHITE }, rotate = 1, shadow = true, bump = true, float = true, scale = 0.9, pop_in = 0.6 /
				G.SPEEDFACTOR, pop_in_rate = 1.5 * G.SPEEDFACTOR })
				bot_dynatext = DynaText({ string = "Applied!", colours = { G.C.WHITE }, rotate = 2, shadow = true, bump = true, float = true, scale = 0.9, pop_in = 1.4 /
				G.SPEEDFACTOR, pop_in_rate = 1.5 * G.SPEEDFACTOR, pitch_shift = 0.25 })
				card:juice_up(0.3, 0.5)
				play_sound('card1')
				play_sound('coin1')
				card.children.top_disp = UIBox {
					definition = { n = G.UIT.ROOT, config = { align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15 }, nodes = {
						{ n = G.UIT.O, config = { object = top_dynatext } }
					} },
					config = { align = "tm", offset = { x = 0, y = 0 }, parent = card }
				}
				card.children.bot_disp = UIBox {
					definition = { n = G.UIT.ROOT, config = { align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15 }, nodes = {
						{ n = G.UIT.O, config = { object = bot_dynatext } }
					} },
					config = { align = "bm", offset = { x = 0, y = 0 }, parent = card }
				}
				return true
			end
		}))
		delay(0.6)

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 2.6,
			func = function()
				top_dynatext:pop_out(4)
				bot_dynatext:pop_out(4)
				card:start_dissolve()
				return true
			end
		}))

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.5,
			func = function()
				card.children.top_disp:remove()
				card.children.top_disp = nil
				card.children.bot_disp:remove()
				card.children.bot_disp = nil
				return true
			end
		}))
	end,
	generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_risk"]
	end,
	can_use = function(self, card)
		return G.STATE == G.STATES.BLIND_SELECT or booster_obj or G.STATE == G.STATES.SHOP
	end,
	apply_risk = function(self, ability)
	end,
	apply_reward = function(self, ability)
	end,
	---@param self Risk
	---@param risk RiskObject
	---@param context CalcContext
	risk_calculate = function(self, risk, context)
		
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
	end,
	in_pool = function(self, args)
		return true, { allow_duplicates = G.GAME.payasaka_only_risk or false }
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'hinder',
	atlas = "JOE_Risk",
	pos = { x = 0, y = 1 },
	config = { extra = { debuff = 10 } },
	tier = 1,
	apply_risk = function(self, ability)
		G.GAME.payasaka_hinder_cards = G.GAME.payasaka_hinder_cards or PTASaka.shallow_copy(G.deck.cards)
		G.GAME.payasaka_already_hindered = G.GAME.payasaka_already_hindered or {}
		local count = math.min(ability.debuff, #G.GAME.payasaka_hinder_cards)
		while count > 0 do
			---@type Card
			local c = table.remove(G.GAME.payasaka_hinder_cards, pseudorandom('fuck', 1, #G.GAME.payasaka_hinder_cards))
			if c then
				G.GAME.payasaka_already_hindered[#G.GAME.payasaka_already_hindered + 1] = c
			end
			count = count - 1
		end
	end,
	risk_calculate = function(self, risk, context)
		if context.setting_blind then
			if G.GAME.payasaka_already_hindered and next(G.GAME.payasaka_already_hindered) then
				for i = 1, #G.GAME.payasaka_already_hindered do
					draw_card(G.deck,G.hand, i*100/#G.GAME.payasaka_already_hindered,'up', false, G.GAME.payasaka_already_hindered[i], nil, nil)
				end
				delay(0.4)
				for i = 1, #G.GAME.payasaka_already_hindered do
					local c = G.GAME.payasaka_already_hindered[i]
					G.E_MANAGER:add_event(Event{
						trigger = 'after',
						delay = 0.15,
						func = function()
							c:juice_up()
							play_sound('timpani')
							SMODS.debuff_card(c, true, 'payasaka_risk_hinder')
							return true
						end
					})
				end
				delay(0.4)
				for i = 1, #G.GAME.payasaka_already_hindered do
					draw_card(G.hand,G.deck, i*100/#G.GAME.payasaka_already_hindered,'down', true, G.GAME.payasaka_already_hindered[i], nil, nil)
				end
			end
			G.GAME.payasaka_already_hindered = {}
		end
	end,
	apply_reward = function(self, ability)
		for _, area in ipairs({ G.hand, G.discard, G.deck }) do
			for _, card in ipairs(area.cards) do
				SMODS.debuff_card(card, false, 'payasaka_risk_hinder')
			end
		end
		G.GAME.payasaka_hinder_cards = nil
		G.GAME.payasaka_already_hindered = nil
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.debuff } }
	end
}

PTASaka.Risk {
	set = 'Risk',
	key = 'hollow',
	atlas = "JOE_Risk",
	pos = { x = 2, y = 1 },
	tier = 1,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	apply_risk = function(self, ability)
		for i = 1, #G.consumeables.cards do
			local c = G.consumeables.cards[i]
			SMODS.debuff_card(c, true, "risk_hollow")
		end
	end,
	apply_reward = function(self, ability)
		for i = 1, #G.consumeables.cards do
			local c = G.consumeables.cards[i]
			SMODS.debuff_card(c, false, "risk_hollow")
		end
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'leak',
	atlas = "JOE_Risk",
	pos = { x = 3, y = 1 },
	config = { extra = { money = 1 } },
	tier = 1,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	risk_calculate = function(self, risk, context)
		if context.payasaka_dos_before then
			for i = 1, #context.scoring_hand do
				local c = context.scoring_hand[i]
				G.E_MANAGER:add_event(Event{
					trigger = 'after',
					delay = 0.15,
					func = function()
						c:juice_up()
						ease_dollars(-risk.ability.extra.money)
					end
				})
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end
}

PTASaka.Risk {
	set = 'Risk',
	key = 'shrink',
	atlas = "JOE_Risk",
	pos = { x = 3, y = 2 },
	tier = 1,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	apply_risk = function(self, ability)
		G.GAME.payasaka_shrink_active = true
	end,
	apply_reward = function(self, ability)
		G.GAME.payasaka_shrink_active = nil
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'genesis',
	atlas = "JOE_Risk",
	pos = { x = 4, y = 2 },
	config = { extra = { cards = 7 } },
	tier = 1,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	apply_risk = function(self, ability)
		for _ = 1, ability.cards do
			create_playing_card(nil, G.deck, true, true)
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end
}

PTASaka.Risk {
	set = 'Risk',
	key = 'burden',
	atlas = "JOE_Risk",
	pos = { x = 0, y = 3 },
	tier = 1,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	apply_risk = function(self, ability)
		---@type Card|nil
		local joker = pseudorandom_element(G.jokers.cards, pseudoseed('burden'))
		if joker then
			joker:set_eternal(true)
			joker:juice_up()
		end
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'ethereal',
	atlas = "JOE_Risk",
	pos = { x = 1, y = 3 },
	tier = 1,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	apply_risk = function(self, ability)
		---@type Card|nil
		local joker = pseudorandom_element(G.jokers.cards, pseudoseed('burden'))
		if joker then
			joker:set_perishable(true)
			joker:juice_up()
		end
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'cyclone',
	atlas = "JOE_Risk",
	pos = { x = 2, y = 3 },
	tier = 1,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	risk_calculate = function(self, risk, context)
		if context.after then
			G.E_MANAGER:add_event(Event{
				func = function()
					G.FUNCS.draw_from_hand_to_deck(nil)
					return true
				end
			})
		end
	end
}

PTASaka.Risk {
	set = 'Risk',
	key = 'crime',
	atlas = "JOE_Risk",
	pos = { x = 3, y = 0 },
	config = { extra = { hand_neg = 1 } },
	tier = 2,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi and Aikoyori',
			colour = HEX('09d707')
		},
	},
	apply_risk = function(self, ability)
		G.hand:change_size(-ability.hand_neg)
	end,
	apply_reward = function(self, ability)
		G.hand:change_size(ability.hand_neg)
		--G.GAME.round_resets.discards = G.GAME.round_resets.discards + ability.hand_neg
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hand_neg } }
	end
}

PTASaka.Risk {
	key = 'doubledown',
	atlas = "JOE_Risk",
	pos = { x = 0, y = 0 },
	tier = 2,
	apply_risk = function(self, ability)
		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.4,
			func = function()
				G.GAME.blind.chips = G.GAME.blind.chips * 2
				G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
				--G.GAME.blind.dollars = G.GAME.blind.dollars * ability.money
				G.GAME.blind:wiggle()
				return true
			end
		})
		delay(0.6)
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'decay',
	atlas = "JOE_Risk",
	pos = { x = 0, y = 2 },
	tier = 2,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	config = { extra = { level = 2 } },
	risk_calculate = function(self, risk, context)
		if context.payasaka_dos_before then
			local mto_big = to_big or function(a) return a end
			risk.ability.last_hand_name = nil
			if mto_big(G.GAME.hands[context.scoring_name].level) > mto_big(1) then
				risk.ability.last_hand_name = context.scoring_name
				risk.ability.last_hand_level = G.GAME.hands[context.scoring_name].level
				level_up_hand(nil, context.scoring_name, nil, -math.max(1, G.GAME.hands[context.scoring_name].level - (G.GAME.hands[context.scoring_name].level/risk.ability.extra.level)))
			end
		end
		if context.after and risk.ability.last_hand_name then
			G.E_MANAGER:add_event(Event{
				func = function()
					local hand = G.GAME.hands[risk.ability.last_hand_name]
					hand.level = risk.ability.last_hand_level
					hand.mult = math.max(hand.s_mult + hand.l_mult*(hand.level - 1), 1)
					hand.chips = math.max(hand.s_chips + hand.l_chips*(hand.level - 1), 0)
					return true
				end
			})
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.level } }
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'stunted',
	atlas = "JOE_Risk",
	pos = { x = 4, y = 1 },
	config = { extra = { chance = 2 } },
	tier = 2,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	apply_risk = function(self, ability)
		G.GAME.payasaka_stunted_active = true
		G.GAME.payasaka_stunted_chance = ability.chance
	end,
	apply_reward = function(self, ability)
		G.GAME.payasaka_stunted_active = false
		G.GAME.payasaka_stunted_chance = nil
	end,
	risk_calculate = function(self, risk, context)
		if context.payasaka_dos_before then
			for i = 1, #G.play.cards do
				local card = G.play.cards[i]
				if pseudorandom('ham_slice') < (G.GAME.probabilities.normal or 1)/risk.ability.extra.chance and card.ability.set == 'Enhanced' then
					card.ability.set = 'Default'
					card.ability.payasaka_old_effect = card.ability.effect
					card.ability.payasaka_old_ee = card.ability.extra_enhancement
					card.ability.effect = nil
					card.ability.extra_enhancement = false
					card.ability.payasaka_stunted = true
					card_eval_status_text(card, 'extra', nil, nil, nil,
								{ message = "Stunted!" })
				end
			end
		end
		if context.after then
			for i = 1, #G.play.cards do
				local card = G.play.cards[i]
				if card.ability.payasaka_stunted then
					card.ability.set = 'Enhanced'
					card.ability.effect = card.ability.effect
					card.ability.extra_enhancement = card.ability.payasaka_old_ee
					card.ability.payasaka_stunted = nil
					card.ability.payasaka_old_effect = nil
					card.ability.payasaka_old_ee = nil
					card_eval_status_text(card, 'extra', nil, nil, nil,
								{ message = "Reverted!" })
				end
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal or 1, card.ability.extra.chance } }
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'perpetuate',
	atlas = "JOE_Risk",
	pos = { x = 4, y = 3 },
	tier = 2,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	apply_risk = function(self, ability)
		G.GAME.payasaka_perpetuate_active = true
	end,
	apply_reward = function(self, ability)
		G.GAME.payasaka_perpetuate_active = nil
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'backfire',
	atlas = "JOE_Risk",
	pos = { x = 3, y = 3 },
	config = { extra = { chance = 2 } },
	tier = 2,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	apply_risk = function(self, ability)
		G.GAME.payasaka_backfire_active = ability.chance or 2
	end,
	apply_reward = function(self, ability)
		G.GAME.payasaka_backfire_active = nil
	end,
	risk_calculate = function(self, risk, context)
		if context.press_play and pseudorandom('backfire_shit') < (G.GAME.probabilities.normal or 1)/risk.ability.extra.chance then
			table.sort(G.jokers.cards, function(x, y) return x.sort_id > y.sort_id end)
			G.jokers:set_ranks()
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal or 1, card.ability.extra.chance } }
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'elusive',
	atlas = "JOE_Risk",
	pos = { x = 1, y = 2 },
	tier = 3,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	apply_risk = function(self, ability)
		G.GAME.payasaka_elusive_cards = (G.GAME.payasaka_elusive_cards or 0) + 1
	end,
	risk_calculate = function(self, risk, context)
		if context.press_play then
			for i = 1, #G.hand.cards do
				---@type Card
				local c = G.hand.cards[i]
				if not c.highlighted then
					c:flip()
				end
			end
		end
	end,
	apply_reward = function(self, ability)
		G.GAME.payasaka_elusive_cards = nil
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'cast',
	atlas = "JOE_Risk",
	pos = { x = 2, y = 0 },
	tier = 3,
	use = function(self, card, area, copier)
		-- no need to save it if the damn thing is already the question
		-- im the motherfucking question bitch
		if G.GAME.payasaka_prelude_next_blind == nil then
			if G.GAME.round_resets.blind_choices.Boss ~= "bl_payasaka_question" then
				G.GAME.round_resets.last_cast_boss = G.GAME.round_resets.blind_choices.Boss
				G.GAME.round_resets.blind_choices.Boss = 'bl_payasaka_question'
			end
		else
			if G.GAME.payasaka_prelude_next_blind ~= "bl_payasaka_question" then
				G.GAME.round_resets.last_cast_boss = G.GAME.payasaka_prelude_next_blind
				G.GAME.payasaka_prelude_next_blind = 'bl_payasaka_question'
			end
		end
		G.GAME.payasaka_cannot_reroll = true
		local old_name = G.GAME.selected_back.name
		G.GAME.selected_back.name = "b_red"
		G.GAME.banned_keys['bl_payasaka_question'] = true
		local current_boss = G.GAME.round_resets.last_cast_boss or get_new_boss()
		G.GAME.payasaka_merged_boss_keys = G.GAME.payasaka_merged_boss_keys or {}
		if next(G.GAME.payasaka_merged_boss_keys) == nil then
			-- first entry is the current boss
			G.GAME.payasaka_merged_boss_keys[#G.GAME.payasaka_merged_boss_keys + 1] = current_boss
		end
		-- Get a random boss blind to append to the current one
		G.GAME.payasaka_merged_boss_keys[#G.GAME.payasaka_merged_boss_keys + 1] = get_new_boss()
		G.GAME.selected_back.name = old_name
		G.GAME.banned_keys['bl_payasaka_question'] = nil

		-- what have you done
		if (G.GAME.round_resets.ante) % G.GAME.win_ante == 0 and G.GAME.round_resets.ante >= 2 then
			G.GAME.payasaka_natural_cast = true
			G.GAME.payasaka_hard_mode_cast = true
		end

		-- get biggest chips multiplier
		for i = 1, #G.GAME.payasaka_merged_boss_keys do
			local blind = G.P_BLINDS[G.GAME.payasaka_merged_boss_keys[i]]
			G.P_BLINDS['bl_payasaka_question'].mult = math.max(G.P_BLINDS['bl_payasaka_question'].mult, blind.mult)
		end
		-- cryptid being a piece of shit
		G.P_BLINDS['bl_payasaka_question'].mult_ante = G.GAME.round_resets.ante
		-- shitty hack
		local old_state = G.GAME.round_resets.blind_states[G.GAME.blind_on_deck]
		G.E_MANAGER:add_event(Event {
			func = function()
				G.E_MANAGER:add_event(Event {
					trigger = 'after',
					delay = 0.2,
					func = function()
						G.GAME.round_resets.blind_states[G.GAME.blind_on_deck] = old_state
						return true
					end
				})
				if G.blind_select_opts and G.blind_select_opts.boss then
					local par = G.blind_select_opts.boss.parent

					G.blind_select_opts.boss:remove()
					G.blind_select_opts.boss = UIBox {
						T = { par.T.x, 0, 0, 0, },
						definition =
						{ n = G.UIT.ROOT, config = { align = "cm", colour = G.C.CLEAR }, nodes = {
							UIBox_dyn_container({ create_UIBox_blind_choice('Boss') }, false, get_blind_main_colour('Boss'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))
						} },
						config = { align = "bmi",
							offset = { x = 0, y = G.ROOM.T.y + 9 },
							major = par,
							xy_bond = 'Weak'
						}
					}
					par.config.object = G.blind_select_opts.boss
					par.config.object:recalculate()
					G.blind_select_opts.boss.parent = par
					G.blind_select_opts.boss.alignment.offset.y = 0
				end
				return true
			end
		})
		PTASaka.Risk.use(self, card, area, copier)
	end,
	apply_reward = function(self, ability)
		G.GAME.payasaka_cannot_reroll = nil
		G.GAME.round_resets.last_cast_boss = nil
		G.GAME.payasaka_merged_boss_keys = {}
		--[[
		add_tag(Tag('tag_charm'))
		add_tag(Tag('tag_meteor'))
		add_tag(Tag('tag_ethereal'))
		]]
		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.5,
			blocking = false,
			func = function()
				G.GAME.payasaka_hard_mode_cast = nil
				return true
			end
		})
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'elysium',
	atlas = "JOE_Risk",
	pos = { x = 1, y = 1 },
	tier = 3,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	apply_risk = function(self, ability)
		if next(G.jokers.cards) then
			SMODS.debuff_card(G.jokers.cards[1], true, "risk_elysium")
			SMODS.debuff_card(G.jokers.cards[#G.jokers.cards], true, "risk_elysium")
		end
	end,
	apply_reward = function(self, ability)
		for i = 1, #G.jokers.cards do
			local joker = G.jokers.cards[i]
			SMODS.debuff_card(joker, false, "risk_elysium")
		end
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'prelude',
	atlas = "JOE_Risk",
	pos = { x = 2, y = 2 },
	tier = 3,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	use = function(self, card, area, copier)
		if G.GAME.payasaka_prelude_next_blind then card:start_dissolve(); return end
		G.GAME.payasaka_prelude_next_blind = G.GAME.round_resets.blind_choices.Boss
		G.GAME.round_resets.blind_choices.Boss = 'bl_payasaka_prelude'
		local old_state = G.GAME.round_resets.blind_states[G.GAME.blind_on_deck]
		G.E_MANAGER:add_event(Event {
			func = function()
				G.E_MANAGER:add_event(Event {
					trigger = 'after',
					delay = 0.2,
					func = function()
						G.GAME.round_resets.blind_states[G.GAME.blind_on_deck] = old_state
						return true
					end
				})
				if G.blind_select_opts and G.blind_select_opts.boss then
					local par = G.blind_select_opts.boss.parent

					G.blind_select_opts.boss:remove()
					G.blind_select_opts.boss = UIBox {
						T = { par.T.x, 0, 0, 0, },
						definition =
						{ n = G.UIT.ROOT, config = { align = "cm", colour = G.C.CLEAR }, nodes = {
							UIBox_dyn_container({ create_UIBox_blind_choice('Boss') }, false, get_blind_main_colour('Boss'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))
						} },
						config = { align = "bmi",
							offset = { x = 0, y = G.ROOM.T.y + 9 },
							major = par,
							xy_bond = 'Weak'
						}
					}
					par.config.object = G.blind_select_opts.boss
					par.config.object:recalculate()
					G.blind_select_opts.boss.parent = par
					G.blind_select_opts.boss.alignment.offset.y = 0
				end
				return true
			end
		})
		G.GAME.payasaka_cannot_reroll = true
		PTASaka.Risk.use(self, card, area, copier)
	end,
	can_use = function()
		return not G.GAME.payasaka_prelude_next_blind
	end,
	apply_reward = function(self, ability)
		G.GAME.payasaka_prelude_next_blind = nil
		G.GAME.payasaka_cannot_reroll = nil
		for _, area in ipairs({ G.play, G.hand, G.deck, G.discard }) do
			for i = 1, #area.cards do
				---@type Card
				local c = area.cards[i]
				SMODS.debuff_card(c, false, 'payasaka_prelude')
			end
		end
	end,
}

PTASaka.Risk {
	set = 'Spectral',
	key = 'showdown',
	atlas = "JOE_Risk",
	pos = { x = 1, y = 0 },
	config = { extra = {} },
	hidden = true,
	soul_set = 'Risk',
	tier = 0,
	use = function(self, card, area, copier)
		local showdown = {}
		for k, v in pairs(G.P_BLINDS) do
			if v.boss and v.boss.showdown then showdown[k] = true end
		end
		-- for some reason the game restores the state of the last boss blind to current
		local old_state = G.GAME.round_resets.blind_states[G.GAME.blind_on_deck]
		G.E_MANAGER:add_event(Event {
			func = function()
				G.E_MANAGER:add_event(Event {
					trigger = 'after',
					delay = 0.2,
					func = function()
						G.GAME.round_resets.blind_states[G.GAME.blind_on_deck] = old_state
						return true
					end
				})
				if G.GAME.round_resets.last_cast_boss then
					_, G.GAME.round_resets.last_cast_boss = pseudorandom_element(showdown, pseudoseed('aikoyori'))
					G.GAME.payasaka_merged_boss_keys[2] = G.GAME.round_resets.last_cast_boss
				elseif G.GAME.payasaka_prelude_next_blind then
					_, G.GAME.payasaka_prelude_next_blind = pseudorandom_element(showdown, pseudoseed('aikoyori'))
				else
					_, G.GAME.round_resets.blind_choices.Boss = pseudorandom_element(showdown, pseudoseed('aikoyori'))
				end

				if G.blind_select_opts and G.blind_select_opts.boss then
					local par = G.blind_select_opts.boss.parent

					G.blind_select_opts.boss:remove()
					G.blind_select_opts.boss = UIBox {
						T = { par.T.x, 0, 0, 0, },
						definition =
						{ n = G.UIT.ROOT, config = { align = "cm", colour = G.C.CLEAR }, nodes = {
							UIBox_dyn_container({ create_UIBox_blind_choice('Boss') }, false, get_blind_main_colour('Boss'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))
						} },
						config = { align = "bmi",
							offset = { x = 0, y = G.ROOM.T.y + 9 },
							major = par,
							xy_bond = 'Weak'
						}
					}
					par.config.object = G.blind_select_opts.boss
					par.config.object:recalculate()
					G.blind_select_opts.boss.parent = par
					G.blind_select_opts.boss.alignment.offset.y = 0
				end
				return true
			end
		})
		G.GAME.payasaka_cannot_reroll = true
		PTASaka.Risk.use(self, card, area, copier)
	end,
	can_use = function(self, card)
		return (G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATES.SMODS_BOOSTER_OPENED or G.STATE == G.STATES.SHOP) and
			not (G.P_BLINDS[G.GAME.round_resets.blind_choices.Boss].boss and G.P_BLINDS[G.GAME.round_resets.blind_choices.Boss].boss.showdown)
	end,
	apply_risk = function(self, ability)
	end,
	apply_reward = function(self, ability)
		--[[
		SMODS.add_card {
			key = 'c_soul',
			edition = 'e_negative'
		}
		]]
		SMODS.add_card {
			key = 'c_payasaka_mind',
			edition = 'e_negative'
		}
		G.GAME.payasaka_cannot_reroll = nil
	end
}

-- edit of StrangeLib.make_boosters to use pyrox instead
function PTASaka.make_pyrox_boosters(base_key, normal_poses, jumbo_poses, mega_poses, common_values, pack_size)
	pack_size = pack_size or 3
	for index, pos in ipairs(normal_poses) do
		local t = copy_table(common_values)
		t.key = base_key .. "_normal_" .. index
		t.pos = pos
		t.config = { extra = pos.size or pack_size, choose = pos.choose or 1 }
		--t.cost = 4
		t.pyroxenes = 4
		SMODS.Booster(t)
	end
	for index, pos in ipairs(jumbo_poses) do
		local t = copy_table(common_values)
		t.key = base_key .. "_jumbo_" .. index
		t.pos = pos
		t.config = { extra = pos.size or (pack_size + 1), choose = pos.choose or 1 }
		--t.cost = 6
		t.pyroxenes = 6
		SMODS.Booster(t)
	end
	for index, pos in ipairs(mega_poses) do
		local t = copy_table(common_values)
		t.key = base_key .. "_mega_" .. index
		t.pos = pos
		t.config = { extra = pos.size or (pack_size + 1), choose = pos.choose or 2 }
		--t.cost = 8
		t.pyroxenes = 8
		SMODS.Booster(t)
	end
end

-- Booster packs....
--[[
PTASaka.make_pyrox_boosters('moji',
	{
		{ x = 0, y = 3 },
		{ x = 1, y = 3 },
	},
	{
		{ x = 0, y = 4 },
	},
	{
		{ x = 1, y = 4 },
	},
	{
		atlas = 'JOE_Boosters',
		kind = 'Risk',
		weight = 0.4,
		cost = 0,
		allow_duplicates = true,
		create_card = function(self, card, i)
			return create_card("Risk", G.pack_cards, nil, nil, true, true, nil)
		end,
		in_pool = function(self, args)
			return true, { allow_duplicates = true }
		end,
		group_key = 'k_moji_pack',
		ease_background_colour = function(self)
			ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Risk)
			ease_background_colour({ new_colour = G.C.SECONDARY_SET.Risk, special_colour = G.C.SET.Risk, contrast = 4 })
		end,
	}, 2
)
]]
local rpox = 5
PTASaka.make_boosters('risk',
	{
		{ x = rpox,   y = 0 },
		{ x = rpox + 1, y = 0 },
	},
	{
		{ x = rpox + 2, y = 0 },
	},
	{
		{ x = rpox + 3, y = 0 },
	},
	{
		atlas = 'JOE_Risk',
		kind = 'Risk',
		weight = 0.6,
		create_card = function(self, card, i)
			return create_card("Risk", G.pack_cards, nil, nil, true, true, nil)
		end,
		in_pool = function(self, args)
			return true, { allow_duplicates = true }
		end,
		group_key = 'k_risk_pack',
		ease_background_colour = function(self)
			ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Risk)
			ease_background_colour({ new_colour = G.C.SECONDARY_SET.Risk, special_colour = G.C.SET.Risk, contrast = 4 })
		end,
	}
)

function G.UIDEF.current_risks()
	local silent = false
	local keys_used = {}
	local area_count = 0
	local voucher_areas = {}
	local voucher_tables = {}
	local voucher_table_rows = {}
	for k, v in ipairs(G.GAME.risk_cards_risks or {}) do
		keys_used[#keys_used + 1] = G.P_CENTERS[v.key]
	end
	for k, v in ipairs(keys_used) do
		if next(v) then
			area_count = area_count + 1
		end
	end
	for k, v in ipairs(keys_used) do
		if next(v) then
			if #voucher_areas == 5 or #voucher_areas == 10 then
				table.insert(voucher_table_rows,
					{ n = G.UIT.R, config = { align = "cm", padding = 0, no_fill = true }, nodes = voucher_tables }
				)
				voucher_tables = {}
			end

			voucher_areas[#voucher_areas + 1] = CardArea(
				G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
				(#v == 1 and 1 or 1.33) * G.CARD_W,
				(area_count >= 10 and 0.75 or 1.07) * G.CARD_H,
				{ card_limit = 2, type = 'voucher', highlight_limit = 0 })

			local center = v
			local card = Card(voucher_areas[#voucher_areas].T.x + voucher_areas[#voucher_areas].T.w / 2,
				voucher_areas[#voucher_areas].T.y, G.CARD_W, G.CARD_H, nil, center,
				{ bypass_discovery_center = true, bypass_discovery_ui = true, bypass_lock = true })
			card.ability.order = v.order
			card:start_materialize(nil, silent)
			silent = true
			voucher_areas[#voucher_areas]:emplace(card)
			table.insert(voucher_tables,
				{
					n = G.UIT.C,
					config = { align = "cm", padding = 0, no_fill = true },
					nodes = {
						{ n = G.UIT.O, config = { object = voucher_areas[#voucher_areas] } }
					}
				}
			)
		end
	end
	table.insert(voucher_table_rows,
		{ n = G.UIT.R, config = { align = "cm", padding = 0, no_fill = true }, nodes = voucher_tables }
	)


	local t = silent and {
			n = G.UIT.ROOT,
			config = { align = "cm", colour = G.C.CLEAR },
			nodes = {
				{
					n = G.UIT.R,
					config = { align = "cm" },
					nodes = {
						{ n = G.UIT.O, config = { object = DynaText({ string = { localize('ph_bought_risks') }, colours = { G.C.UI.TEXT_LIGHT }, bump = true, scale = 0.6 }) } }
					}
				},
				{
					n = G.UIT.R,
					config = { align = "cm", minh = 0.5 },
					nodes = {
					}
				},
				{
					n = G.UIT.R,
					config = { align = "cm", colour = G.C.BLACK, r = 1, padding = 0.15, emboss = 0.05 },
					nodes = {
						{ n = G.UIT.R, config = { align = "cm" }, nodes = voucher_table_rows },
					}
				}
			}
		} or
		{
			n = G.UIT.ROOT,
			config = { align = "cm", colour = G.C.CLEAR },
			nodes = {
				{ n = G.UIT.O, config = { object = DynaText({ string = { localize('ph_no_risk') }, colours = { G.C.UI.TEXT_LIGHT }, bump = true, scale = 0.6 }) } }
			}
		}
	return t
end
