SMODS.ConsumableType {
	key = 'Risk',
	collection_rows = { 4, 4 },
	primary_colour = HEX('c42430'),
	secondary_colour = HEX('891e2b'),
	shop_rate = 0,
	loc_txt = {},
}

SMODS.UndiscoveredSprite {
	key = 'Risk',
	atlas = 'JOE_Risk',
	path = 'risk.png',
	pos = { x = 3, y = 1 },
	px = 71, py = 95,
}

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
	use = function(self, card, area, copier)
		G.GAME.risk_cards_risks[#G.GAME.risk_cards_risks + 1] = { key = self.key, ability = PTASaka.deep_copy(card
		.ability.extra) }
		G.E_MANAGER:add_event(Event{
			trigger = 'after',
			delay = 0.4,
			func = function()
				card:juice_up(0.3, 0.5)
				play_sound('card1')
				card_eval_status_text(card, 'extra', nil, nil, 'up', {message = "Risk applied!", colour = G.C.MULT, instant = true})
				return true
			end
		})
		G.E_MANAGER:add_event(Event{
			trigger = 'after',
			delay = 2.3+0.4,
			func = function()
				card:start_dissolve()
				delay(1)
				return true
			end
		})
	end,
	can_use = function(self, card)
		return G.STATE == G.STATES.BLIND_SELECT
	end,
	apply_risk = function(self, ability)
	end,
	apply_reward = function(self, ability)
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
	end
}

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.risk_cards_risks = {}
	ret.risk_cards_rewards = {}
	return ret
end

PTASaka.Risk {
	key = 'doubledown',
	atlas = "JOE_Risk",
	pos = { x = 0, y = 0 },
	config = { extra = { money = 2, } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end,
	apply_risk = function(self, ability)
		G.E_MANAGER.add_event(Event{
			func = function()
				G.GAME.blind.chips = G.GAME.blind.chips * 2
				G.GAME.blind.dollars = G.GAME.blind.dollars * ability.money
				G.GAME.blind:wiggle()
				return true
			end
		})
		delay(0.6)
	end,
	apply_reward = function(self, ability)
	end,
}

local sr = Game.start_run
function Game:start_run(args)
	sr(self, args)
	local merged = G.P_BLINDS['bl_payasaka_question']
	merged.boss.merged_keys = G.GAME.payasaka_merged_boss_keys or {}
	merged.debuff = G.GAME.payasaka_merged_props and G.GAME.payasaka_merged_props[1] or {}
	merged.mult = G.GAME.payasaka_merged_props and math.max(G.GAME.payasaka_merged_props[2], G.GAME.payasaka_merged_props[3]) or 2
	-- cryptid being a piece of shit
	merged.mult_ante = G.GAME.round_resets.ante
end

local reroll = G.FUNCS.reroll_boss
function G.FUNCS.reroll_boss(e)
	if G.GAME.payasaka_cannot_reroll then return end
	reroll(e)
end

PTASaka.Risk {
	set = 'Risk',
	key = 'cast',
	atlas = "JOE_Risk",
	pos = { x = 2, y = 0 },
	use = function(self, card, area, copier)
		G.GAME.round_resets.last_cast_boss = G.GAME.round_resets.blind_choices.Boss
		G.GAME.payasaka_cannot_reroll = true
		G.E_MANAGER:add_event(Event {
			func = function()
				local par = G.blind_select_opts.boss.parent
				G.GAME.round_resets.blind_choices.Boss = 'bl_payasaka_question'

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
				return true
			end
		})
		-- Get a random boss blind to append to the current one
		local boss = get_new_boss()
		local current_boss = G.GAME.round_resets.last_cast_boss
		local merged = G.P_BLINDS['bl_payasaka_question']
		merged.boss.merged_keys = {boss, current_boss}
		G.GAME.payasaka_merged_boss_keys = {boss, current_boss}
		G.GAME.payasaka_merged_props = { PTASaka.FH.merge(G.P_BLINDS[boss].debuff or {}, G.P_BLINDS[current_boss].debuff or {}), G.P_BLINDS[boss].mult > 2 and G.P_BLINDS[boss].mult or 2, G.P_BLINDS[current_boss].mult > 2 and G.P_BLINDS[current_boss].mult or 2 }
		G.P_BLINDS['bl_payasaka_question'].debuff = G.GAME.payasaka_merged_props[1]
		G.P_BLINDS['bl_payasaka_question'].mult = math.max(G.P_BLINDS[boss].mult > 2 and G.P_BLINDS[boss].mult or 2, G.P_BLINDS[current_boss].mult > 2 and G.P_BLINDS[current_boss].mult or 2)
		-- cryptid being a piece of shit
		G.P_BLINDS['bl_payasaka_question'].mult_ante = G.GAME.round_resets.ante
		PTASaka.Risk.use(self, card, area, copier)
	end,
	apply_reward = function(self, ability)
		G.GAME.payasaka_cannot_reroll = nil
		G.GAME.round_resets.last_cast_boss = nil
		add_tag(Tag('tag_charm'))
		add_tag(Tag('tag_meteor'))
		add_tag(Tag('tag_ethereal'))
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'crime',
	atlas = "JOE_Risk",
	pos = { x = 3, y = 0 },
	config = {extra = {hand_neg = 1}},
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
		G.GAME.round_resets.discards = G.GAME.round_resets.discards + ability.hand_neg
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hand_neg } }
	end
}

PTASaka.Risk {
	set = 'Risk',
	key = 'hinder',
	atlas = "JOE_Risk",
	pos = { x = 0, y = 1 },
	config = {extra = {debuff = 10}},
	apply_risk = function(self, ability)
		for i = 1, math.min(ability.debuff, #G.deck.cards) do
			local c = G.deck.cards[pseudorandom('fuck', 1, #G.deck.cards)]
			while c.ability.debuffed_by_risk do c = G.deck.cards[pseudorandom('fuck', 1, #G.deck.cards)] end
			c.debuff = true
			c.ability.debuffed_by_risk = true
		end
	end,
	apply_reward = function(self, ability)
		for _, area in ipairs({G.hand, G.discard, G.deck}) do
			for _, card in ipairs(area.cards) do
				if card.ability.debuffed_by_risk then
					local rnd = pseudorandom('fuck')
					if rnd < 1/3 then
						card_eval_status_text(card, 'extra', 1, nil, nil, {message = localize('k_upgrade_ex'), extrafunc = function()
							card:set_ability(G.P_CENTERS[SMODS.poll_enhancement{type_key = 'fuck_final', mod = 1, guaranteed = true}])
						end})
					elseif rnd < 2/3 then
						card_eval_status_text(card, 'extra', 1, nil, nil, {message = localize('k_upgrade_ex'), extrafunc = function()
							local edition = poll_edition('fuck_final', 1, Cryptid == nil, true)
							card:set_edition(edition)
						end})
					else
						card_eval_status_text(card, 'extra', 1, nil, nil, {message = localize('k_upgrade_ex'), extrafunc = function()
							card:set_seal(SMODS.poll_seal{type_key = 'fuck_final', mod = 1, guaranteed = true})
						end})
					end
					card.ability.debuffed_by_risk = nil
					card.debuff = false
				end
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.debuff } }
	end
}

PTASaka.Risk {
	set = 'Risk',
	key = 'elysium',
	atlas = "JOE_Risk",
	pos = { x = 1, y = 1 },
	discovered = false, unlocked = false,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'deface',
	atlas = "JOE_Risk",
	pos = { x = 2, y = 1 },
	discovered = false, unlocked = false,
}

PTASaka.Risk {
	set = 'Spectral',
	key = 'showdown',
	atlas = "JOE_Risk",
	pos = { x = 1, y = 0 },
	config = { extra = {} },
	hidden = true,
	soul_set = 'Risk',
	use = function(self, card, area, copier)
		local showdown = {}
		for k, v in pairs(G.P_BLINDS) do
			if v.boss and v.boss.showdown then showdown[k] = true end
		end
		G.E_MANAGER:add_event(Event {
			func = function()
				local par = G.blind_select_opts.boss.parent
				if G.GAME.round_resets.last_cast_boss then
					_, G.GAME.round_resets.last_cast_boss = pseudorandom_element(showdown, pseudoseed('aikoyori'))
					G.GAME.payasaka_merged_boss_keys[2] = G.GAME.round_resets.last_cast_boss
				else
					_, G.GAME.round_resets.blind_choices.Boss = pseudorandom_element(showdown, pseudoseed('aikoyori'))
				end

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
				return true
			end
		})
		G.GAME.payasaka_cannot_reroll = true
		PTASaka.Risk.use(self, card, area, copier)
	end,
	can_use = function(self, card)
		return (G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATE.SMODS_BOOSTER_OPENED) and
			not (G.P_BLINDS[G.GAME.round_resets.blind_choices.Boss].boss and G.P_BLINDS[G.GAME.round_resets.blind_choices.Boss].boss.showdown)
	end,
	apply_risk = function(self, ability)
	end,
	apply_reward = function(self, ability)
		SMODS.add_card {
			key = 'c_soul',
			edition = 'e_negative'
		}
		G.GAME.payasaka_cannot_reroll = nil
	end
}
