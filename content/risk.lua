SMODS.ConsumableType {
	key = 'Risk',
	collection_rows = { 4, 4, 3 },
	primary_colour = HEX('c42430'),
	secondary_colour = HEX('891e2b'),
	shop_rate = 0,
	loc_txt = {},
}

SMODS.UndiscoveredSprite {
	key = 'Risk',
	atlas = 'JOE_Risk',
	path = 'risk.png',
	pos = { x = 3, y = 2 },
	px = 71, py = 95,
}

G.C.SET.Risk = HEX('c42430')
G.C.SECONDARY_SET.Risk = HEX('891e2b')

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
		G.GAME.risk_cards_risks[#G.GAME.risk_cards_risks + 1] = {
			key = self.key,
			ability = PTASaka.deep_copy(card
				.ability.extra)
		}
		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.4,
			func = function()
				card:juice_up(0.3, 0.5)
				play_sound('card1')
				card_eval_status_text(card, 'extra', nil, nil, 'up',
					{ message = "Risk applied!", colour = G.C.MULT, instant = true })
				return true
			end
		})
		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 2.3 + 0.4,
			func = function()
				card:start_dissolve()
				delay(1)
				return true
			end
		})
	end,
	can_use = function(self, card)
		return G.STATE == G.STATES.BLIND_SELECT or booster_obj or G.STATE == G.STATES.SHOP
	end,
	apply_risk = function(self, ability)
	end,
	apply_reward = function(self, ability)
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
	end,
	in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end,
}

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.risk_cards_risks = {}
	ret.risk_cards_rewards = {}
	return ret
end

PTASaka.Risk {
	set = 'Risk',
	key = 'hinder',
	atlas = "JOE_Risk",
	pos = { x = 0, y = 1 },
	config = { extra = { debuff = 10 } },
	apply_risk = function(self, ability)
		for i = 1, math.min(ability.debuff, #G.deck.cards) do
			local c = G.deck.cards[pseudorandom('fuck', 1, #G.deck.cards)]
			while c.ability.debuffed_by_risk do c = G.deck.cards[pseudorandom('fuck', 1, #G.deck.cards)] end
			c.debuff = true
			c.ability.debuffed_by_risk = true
		end
	end,
	apply_reward = function(self, ability)
		for _, area in ipairs({ G.hand, G.discard, G.deck }) do
			for _, card in ipairs(area.cards) do
				if card.ability.debuffed_by_risk then
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
	key = 'crime',
	atlas = "JOE_Risk",
	pos = { x = 3, y = 0 },
	config = { extra = { hand_neg = 1 } },
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
	set = 'Risk',
	key = 'hollow',
	atlas = "JOE_Risk",
	pos = { x = 2, y = 1 },
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
			c.debuff = true
			c.ability.debuffed_by_risk = true
		end
	end,
	apply_reward = function(self, ability)
		for i = 1, #G.consumeables.cards do
			local c = G.consumeables.cards[i]
			if c.ability.debuffed_by_risk then
				c.ability.debuffed_by_risk = nil
				c.debuff = false
			end
		end
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'leak',
	atlas = "JOE_Risk",
	pos = { x = 3, y = 1 },
	config = { extra = { money = 1 } },
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
		G.GAME.payasaka_leak_active = (G.GAME.payasaka_leak_active or 0) + ability.money
	end,
	apply_reward = function(self, ability)
		G.GAME.payasaka_leak_active = nil
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end
}

PTASaka.Risk {
	key = 'doubledown',
	atlas = "JOE_Risk",
	pos = { x = 0, y = 0 },
	apply_risk = function(self, ability)
		G.E_MANAGER:add_event(Event {
			func = function()
				G.GAME.blind.chips = G.GAME.blind.chips * 2
				--G.GAME.blind.dollars = G.GAME.blind.dollars * ability.money
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
	if G.GAME.payasaka_merged_boss_keys and next(G.GAME.payasaka_merged_boss_keys) then
		-- get biggest chips multiplier
		for i = 1, #G.GAME.payasaka_merged_boss_keys do
			local blind = G.P_BLINDS[G.GAME.payasaka_merged_boss_keys[i]]
			merged.mult = math.max(merged.mult, blind.mult)
		end
	end
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
		-- no need to save it if the damn thing is already the question
		-- im the motherfucking question bitch
		if G.GAME.round_resets.blind_choices.Boss ~= "bl_payasaka_question" then
			G.GAME.round_resets.last_cast_boss = G.GAME.round_resets.blind_choices.Boss
			G.GAME.round_resets.blind_choices.Boss = 'bl_payasaka_question'
		end
		G.GAME.payasaka_cannot_reroll = true
		local current_boss = G.GAME.round_resets.last_cast_boss
		G.GAME.payasaka_merged_boss_keys = G.GAME.payasaka_merged_boss_keys or {}
		if next(G.GAME.payasaka_merged_boss_keys) == nil then
			-- first entry is the current boss
			G.GAME.payasaka_merged_boss_keys[#G.GAME.payasaka_merged_boss_keys + 1] = current_boss
		end
		-- Get a random boss blind to append to the current one
		G.GAME.payasaka_merged_boss_keys[#G.GAME.payasaka_merged_boss_keys + 1] = get_new_boss()

		-- get biggest chips multiplier
		for i = 1, #G.GAME.payasaka_merged_boss_keys do
			local blind = G.P_BLINDS[G.GAME.payasaka_merged_boss_keys[i]]
			G.P_BLINDS['bl_payasaka_question'].mult = math.max(G.P_BLINDS['bl_payasaka_question'].mult, blind.mult)
		end
		-- cryptid being a piece of shit
		G.P_BLINDS['bl_payasaka_question'].mult_ante = G.GAME.round_resets.ante
		G.E_MANAGER:add_event(Event {
			func = function()
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
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'decay',
	atlas = "JOE_Risk",
	pos = { x = 0, y = 2 },
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
	apply_risk = function(self, ability)
		G.GAME.payasaka_decay_active = (G.GAME.payasaka_decay_active or 0) + ability.level
	end,
	apply_reward = function(self, ability)
		G.GAME.payasaka_decay_active = nil
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
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal or 1, card.ability.extra.chance } }
	end,
}

-- Nuh uh
local oldce = Card.calculate_enhancement
function Card:calculate_enhancement(context)
	if self.ability.payasaka_stunted then return nil end
	return oldce(self, context)
end

local oldcb = Card.get_chip_bonus
function Card:get_chip_bonus()
	if self.ability.payasaka_stunted then return self.base.nominal + (self.ability.perma_bonus or 0) end
	return oldcb(self)
end

local oldcm = Card.get_chip_mult
function Card:get_chip_mult()
	if self.ability.payasaka_stunted then return (self.ability.perma_mult or 0) end
	return oldcm(self)
end

local oldcxm = Card.get_chip_x_mult
function Card:get_chip_x_mult(context)
	if self.ability.payasaka_stunted then return (self.ability.perma_x_mult or 0) end
	return oldcxm(self, context)
end

local oldchm = Card.get_chip_h_mult
function Card:get_chip_h_mult()
	if self.ability.payasaka_stunted then return (self.ability.perma_h_mult or 0) end
	return oldchm(self)
end

local oldchxm = Card.get_chip_h_x_mult
function Card:get_chip_h_x_mult()
	if self.ability.payasaka_stunted then return (self.ability.perma_h_x_mult or 0) end
	return oldchxm(self)
end

local oldcxb = Card.get_chip_x_bonus
function Card:get_chip_x_bonus(context)
	if self.ability.payasaka_stunted then return (self.ability.perma_x_chips or 0) end
	return oldcxb(self, context)
end

local oldchb = Card.get_chip_h_bonus
function Card:get_chip_h_bonus()
	if self.ability.payasaka_stunted then return (self.ability.perma_h_chips or 0) end
	return oldchb(self)
end

local oldchxb = Card.get_chip_h_x_bonus
function Card:get_chip_h_x_bonus()
	if self.ability.payasaka_stunted then return (self.ability.perma_h_x_chips or 0) end
	return oldchxb(self)
end

local oldhd = Card.get_h_dollars
function Card:get_h_dollars()
	if self.ability.payasaka_stunted then return (self.ability.perma_h_dollars or 0) end
	return oldhd(self)
end

PTASaka.Risk {
	set = 'Risk',
	key = 'elysium',
	atlas = "JOE_Risk",
	pos = { x = 1, y = 1 },
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
		G.jokers.cards[#G.jokers.cards].debuff = true
		G.jokers.cards[#G.jokers.cards].ability.debuffed_by_risk = true
	end,
	apply_reward = function(self, ability)
		for i = 1, #G.jokers.cards do
			local joker = G.jokers.cards[i]
			if joker.ability.debuffed_by_risk then
				joker.debuff = false
				joker.ability.debuffed_by_risk = nil
			end
		end
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'elusive',
	atlas = "JOE_Risk",
	pos = { x = 1, y = 2 },
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
	apply_reward = function(self, ability)
		G.GAME.payasaka_elusive_cards = nil
	end,
}

PTASaka.Risk {
	set = 'Risk',
	key = 'prelude',
	atlas = "JOE_Risk",
	pos = { x = 2, y = 2 },
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
	in_pool = function(self, args)
		return false
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
	use = function(self, card, area, copier)
		local showdown = {}
		for k, v in pairs(G.P_BLINDS) do
			if v.boss and v.boss.showdown then showdown[k] = true end
		end
		G.E_MANAGER:add_event(Event {
			func = function()
				if G.GAME.round_resets.last_cast_boss then
					_, G.GAME.round_resets.last_cast_boss = pseudorandom_element(showdown, pseudoseed('aikoyori'))
					G.GAME.payasaka_merged_boss_keys[2] = G.GAME.round_resets.last_cast_boss
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
		G.GAME.payasaka_cannot_reroll = nil
	end
}

-- edit of StrangeLib.make_boosters to use pyrox instead
function PTASaka.make_boosters(base_key, normal_poses, jumbo_poses, mega_poses, common_values, pack_size)
	pack_size = pack_size or 3
	for index, pos in ipairs(normal_poses) do
		local t = copy_table(common_values)
		t.key = base_key .. "_normal_" .. index
		t.pos = pos
		t.config = { extra = pack_size, choose = 1 }
		--t.cost = 4
		t.pyroxenes = 4
		SMODS.Booster(t)
	end
	for index, pos in ipairs(jumbo_poses) do
		local t = copy_table(common_values)
		t.key = base_key .. "_jumbo_" .. index
		t.pos = pos
		t.config = { extra = pack_size + 1, choose = 1 }
		--t.cost = 6
		t.pyroxenes = 6
		SMODS.Booster(t)
	end
	for index, pos in ipairs(mega_poses) do
		local t = copy_table(common_values)
		t.key = base_key .. "_mega_" .. index
		t.pos = pos
		t.config = { extra = pack_size + 1, choose = 2 }
		--t.cost = 8
		t.pyroxenes = 8
		SMODS.Booster(t)
	end
end

-- Booster packs....
PTASaka.make_boosters('moji',
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

function G.UIDEF.current_risks()
	local silent = false
	local keys_used = {}
	local area_count = 0
	local voucher_areas = {}
	local voucher_tables = {}
	local voucher_table_rows = {}
	for k, v in ipairs(G.GAME.risk_cards_risks or {}) do
		keys_used[#keys_used+1] = G.P_CENTERS[v.key]
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
