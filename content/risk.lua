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
		G.GAME.blind.chips = G.GAME.blind.chips * 2
		G.GAME.blind.dollars = G.GAME.blind.dollars * ability.money
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
	merged.mult = G.GAME.payasaka_merged_props and G.GAME.payasaka_merged_props[2] or 2
end

PTASaka.Risk {
	set = 'Risk',
	key = 'cast',
	atlas = "JOE_Risk",
	pos = { x = 2, y = 0 },
	use = function(self, card, area, copier)
		G.GAME.risk_cards_risks[#G.GAME.risk_cards_risks + 1] = { key = self.key, ability = PTASaka.deep_copy(card
		.ability.extra) }
		G.GAME.round_resets.last_cast_boss = G.GAME.round_resets.blind_choices.Boss
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
		G.GAME.payasaka_merged_props = { PTASaka.FH.merge(G.P_BLINDS[boss].debuff or {}, G.P_BLINDS[current_boss].debuff or {}), G.P_BLINDS[boss].mult * G.P_BLINDS[current_boss].mult }
		merged.debuff = G.GAME.payasaka_merged_props[1]
		merged.mult = G.GAME.payasaka_merged_props[2]
	end,
	apply_risk = function(self, ability)
		local boss, current_boss = unpack(G.GAME.payasaka_merged_boss_keys)
		G.GAME.blind:set_blind(G.P_BLINDS['bl_payasaka_question'])
		local name1 = localize { type = 'name_text', key = boss, set = 'Blind' }
		local name2 = localize { type = 'name_text', key = current_boss, set = 'Blind' }
		local loc_target = localize { type = 'raw_descriptions', key = 'bl_payasaka_question', set = 'Blind', vars = { name1, name2 } }
		if loc_target then
			G.GAME.blind.loc_debuff_text = ''
			EMPTY(G.GAME.blind.loc_debuff_lines)
			for k, v in ipairs(loc_target) do
				G.GAME.blind.loc_debuff_text = G.GAME.blind.loc_debuff_text .. v .. (k <= #loc_target and ' ' or '')
				G.GAME.blind.loc_debuff_lines[k] = v
			end
		end
		G.HUD_blind:recalculate(false)
	end,
	apply_reward = function(self, ability)
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'crime',
	atlas = "JOE_Risk",
	pos = { x = 3, y = 0 },
	discovered = false, unlocked = false,
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
}

PTASaka.Risk {
	set = 'Risk',
	key = 'hinder',
	atlas = "JOE_Risk",
	pos = { x = 0, y = 1 },
	discovered = false, unlocked = false,
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
				_, G.GAME.round_resets.blind_choices.Boss = pseudorandom_element(showdown, pseudoseed('aikoyori'))

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
