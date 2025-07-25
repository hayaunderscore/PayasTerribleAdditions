SMODS.ConsumableType {
	key = 'Reward',
	collection_rows = { 6, 6 },
	secondary_colour = HEX('dc86c2'),
	primary_colour = HEX('9dccf2'),
	shop_rate = 0,
	loc_txt = {},
	default = 'c_payasaka_conform'
}

local offs = {
	x = 5, y = 1
}

SMODS.UndiscoveredSprite {
	key = 'Reward',
	atlas = 'JOE_Risk',
	path = 'risk.png',
	pos = { x = 0, y = 7 },
	px = 71, py = 95,
}

G.C.SET.Reward = HEX('7f8481')
G.C.SECONDARY_SET.Reward = HEX('9dccf2')

---@class Reward: SMODS.Consumable
---@field pseudo_legendaries? (Reward|table)[]
---@field pta_hidden_set? string
---@field pta_hidden_pos? table|{x: number, y: number}
---@overload fun(self: Reward): Reward
PTASaka.Reward = SMODS.Consumable:extend {
	set = 'Reward',
	atlas = 'JOE_Risk',
	config = { extra = {} },
	no_doe = true,
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
	pseudo_legendaries = {},
	in_pool = function(self, args)
		return true
	end,
	register = function(self)
		if self.atlas == 'payasaka_JOE_Risk' then
			self.pos.x = self.pos.x + offs.x
			self.pos.y = self.pos.y + offs.y
			if self.pta_hidden_pos then
				self.pta_hidden_pos.x = self.pta_hidden_pos.x + offs.x
				self.pta_hidden_pos.y = self.pta_hidden_pos.y + offs.y
			end
		end
		SMODS.Consumable.register(self)
	end,
	inject = function(self, i)
		if self.pta_hidden_set then
			table.insert(self.pseudo_legendaries, self)
		end
		SMODS.Consumable.inject(self, i)
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
	end,
}

PTASaka.Reward {
	key = 'conform',
	atlas = 'JOE_Risk',
	pos = { x = 0, y = 0 },
	config = { extra = { max_highlighted = 4, min_highlighted = 2 } },
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
			local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip(); play_sound('card1', percent); G.hand.highlighted[i]:juice_up(0.3, 0.3); return true
				end
			}))
		end
		delay(0.2)
		local rightmost = G.hand.highlighted[1]
		for i = 1, #G.hand.highlighted do
			if G.hand.highlighted[i].T.x > rightmost.T.x then
				rightmost = G.hand
					.highlighted[i]
			end
		end
		for i = 1, #G.hand.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					if G.hand.highlighted[i] ~= rightmost then
						---@type Card
						local _c = G.hand.highlighted[i]
						_c:change_suit(rightmost.base.suit)
					end
					return true
				end
			}))
		end
		for i = 1, #G.hand.highlighted do
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip(); play_sound('tarot2', percent, 0.6); G.hand.highlighted[i]:juice_up(0.3,
						0.3); return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all(); return true
			end
		}))
		delay(0.5)
	end,
	can_use = function(self, card)
		return card.ability.extra.max_highlighted >= #G.hand.highlighted and
			#G.hand.highlighted >= (card.ability.extra.min_highlighted or 1)
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.max_highlighted }
		}
	end
}

PTASaka.Reward {
	key = 'chance',
	atlas = 'JOE_Risk',
	pos = { x = 1, y = 0 },
	config = { extra = { mul = 3 } },
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('timpani')
				card:juice_up(0.3, 0.5)
				---@type Card
				local j = pseudorandom_element(G.jokers.cards, pseudoseed('chance_yeayeyayeaed'))
				if j then
					j:juice_up(0.7)
					ease_dollars(j.sell_cost * card.ability.extra.mul, true)
				end
				return true
			end
		}))
		delay(0.6)
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mul }
		}
	end,
	can_use = function()
		return #G.jokers.cards > 0
	end
}

PTASaka.Reward {
	key = 'hone',
	atlas = 'JOE_Risk',
	pos = { x = 2, y = 0 },
	config = { extra = { level = 1 } },
	use = function(self, card, area, copier)
		-- mostly taken from cryptid for this part specifically
		local _hand, _tally = nil, -1
		for k, v in ipairs(G.handlist) do
			if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
				_hand = v
				_tally = G.GAME.hands[v].played
			end
		end
		-- reset, find another hand
		local _last_hand = _hand
		_hand, _tally = nil, -1
		for _, v in ipairs(G.handlist) do
			if v ~= _last_hand then
				if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
					_hand = v
					_tally = G.GAME.hands[v].played
				end
			end
		end
		for _, hand in pairs({ _last_hand, _hand }) do
			SMODS.smart_level_up_hand(card, hand, false, card.ability.extra.level)
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.level }
		}
	end,
	can_use = function(self, card)
		return true
	end
}

PTASaka.Reward {
	key = 'bloom',
	atlas = 'JOE_Risk',
	pos = { x = 3, y = 2 },
	config = { max_highlighted = 1, extra = 2 },
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				for i = 1, #G.hand.highlighted do
					---@type Card
					local c = G.hand.highlighted[i]
					for j = 1, card.ability.extra do
						SMODS.add_card { suit = c.base.suit, rank = c.base.value, set = 'Enhanced', area = G.hand }
					end
				end
				play_sound('timpani')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		delay(0.6)
	end,
	can_use = function(self, card)
		return card.ability.max_highlighted >= #G.hand.highlighted and
			#G.hand.highlighted >= (card.ability.min_highlighted or 1)
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted, card.ability.extra } }
	end,
}

PTASaka.Reward {
	key = 'metalicize',
	atlas = 'JOE_Risk',
	pos = { x = 3, y = 0 },
	use = function(self, card, area, copier)
		local edition = poll_edition('wheel_of_fortune', nil, true, true)
		---@type Card[]
		local jokers = {}
		for _, joker in ipairs(G.jokers.cards) do
			if not joker.edition then
				jokers[#jokers + 1] = joker
			end
		end
		if next(jokers) then
			G.E_MANAGER:add_event(Event {
				trigger = 'after', delay = 0.4,
				func = function()
					---@type Card
					local joker = pseudorandom_element(jokers, pseudoseed('wheel_of_fortune'))
					joker:set_edition(edition, true)
					card:juice_up(0.3, 0.5)
					return true
				end
			})
			delay(0.6)
		end
	end,
	can_use = function()
		local jokers = {}
		for _, joker in ipairs(G.jokers.cards) do
			if not joker.edition then
				jokers[#jokers + 1] = joker
			end
		end
		return #jokers > 0
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
		info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
		info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
	end,
}

PTASaka.Reward {
	key = 'shine',
	atlas = 'JOE_Risk',
	pos = { x = 4, y = 0 },
	config = { extra = { max_highlighted = 4, min_highlighted = 1 } },
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
			local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip(); play_sound('card1', percent); G.hand.highlighted[i]:juice_up(0.3, 0.3); return true
				end
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					---@type Card
					local _c = G.hand.highlighted[i]
					local which = pseudorandom('shine_proc', 1, 3)
					if which == 1 then -- edition
						local edition = poll_edition('wheel_of_fortune', nil, true, true)
						_c:set_edition(edition)
					elseif which == 2 then -- enhancement
						local enhancement = SMODS.poll_enhancement({ key = 'shine_proc', guaranteed = true })
						_c:set_ability(G.P_CENTERS[enhancement])
					else -- seal
						local seal = SMODS.poll_seal({ key = 'shine_proc', guaranteed = true })
						_c:set_seal(seal)
					end
					return true
				end
			}))
		end
		for i = 1, #G.hand.highlighted do
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip(); play_sound('tarot2', percent, 0.6); G.hand.highlighted[i]:juice_up(0.3,
						0.3); return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all(); return true
			end
		}))
		delay(0.5)
	end,
	can_use = function(self, card)
		return card.ability.extra.max_highlighted >= #G.hand.highlighted and
			#G.hand.highlighted >= (card.ability.extra.min_highlighted or 1)
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
		info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
		info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
		return { vars = { card.ability.extra.max_highlighted } }
	end,
}

PTASaka.Reward {
	key = 'parlay',
	atlas = 'JOE_Risk',
	pos = { x = 0, y = 1 },
	config = { extra = { amount = 2 } },
	use = function(self, card, area, copier)
		for i = 1, math.min(card.ability.extra.amount, G.consumeables.config.card_limit - #G.consumeables.cards) do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					if G.consumeables.config.card_limit > #G.consumeables.cards then
						play_sound('timpani')
						local _c = create_card('Risk', G.consumeables, nil, nil, nil, nil, nil, 'risklmao')
						_c:add_to_deck()
						G.consumeables:emplace(_c)
						card:juice_up(0.3, 0.5)
					end
					return true
				end
			}))
		end
		delay(0.6)
	end,
	can_use = function(self, card)
		if #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables then return true end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.amount }
		}
	end
}

-- Vanilla version of pseudorandom_element for Remember to use
-- Remember ignores pool checks
local function remember_pseudorandom_element(_t, seed)
	if seed then math.randomseed(seed) end
	local keys = {}
	for k, v in pairs(_t) do
		keys[#keys + 1] = { k = k, v = v }
	end

	if keys[1] and keys[1].v and type(keys[1].v) == 'table' and keys[1].v.sort_id then
		table.sort(keys, function(a, b) return a.v.sort_id < b.v.sort_id end)
	else
		table.sort(keys, function(a, b) return a.k < b.k end)
	end

	local key = keys[math.random(#keys)].k
	return _t[key], key
end

PTASaka.Reward {
	key = 'remember',
	atlas = 'JOE_Risk',
	pos = { x = 1, y = 1 },
	use = function(self, card, area, copier)
		---@type SMODS.Voucher[]
		local eligible_vouchers = {}
		for center, _ in pairs(G.GAME.used_vouchers) do
			---@type SMODS.Voucher
			local voucher = G.P_CENTERS[center]
			-- Find an upgrade to said voucher
			local break_two = false
			if voucher then
				for _, v in ipairs(G.P_CENTER_POOLS["Voucher"]) do
					if v.requires and next(v.requires) then
						for _, required in ipairs(v.requires) do
							if required == center and not G.GAME.used_vouchers[v.key] then
								eligible_vouchers[#eligible_vouchers + 1] = v.key
								break_two = true
								break
							end
						end
					end
					if break_two then break end
				end
			end
		end
		if next(eligible_vouchers) then
			local new_voucher = SMODS.add_card { key = remember_pseudorandom_element(eligible_vouchers, pseudoseed('rember')), area = G.play }
			-- You are not taking my money
			new_voucher.cost = 0
			new_voucher:redeem()
			G.E_MANAGER:add_event(Event {
				trigger = 'after',
				delay = 0.6,
				func = function()
					new_voucher:start_dissolve()
					return true
				end
			})
		end
	end,
	can_use = function(self, card)
		local eligible_vouchers = {}
		for center, _ in pairs(G.GAME.used_vouchers) do
			---@type SMODS.Voucher
			local voucher = G.P_CENTERS[center]
			-- Find an upgrade to said voucher
			local break_two = false
			if voucher then
				for _, v in ipairs(G.P_CENTER_POOLS["Voucher"]) do
					if v.requires and next(v.requires) then
						for _, required in ipairs(v.requires) do
							if required == center and not G.GAME.used_vouchers[v.key] then
								eligible_vouchers[#eligible_vouchers + 1] = v.key
								break_two = true
								break
							end
						end
					end
					if break_two then break end
				end
			end
		end
		return next(eligible_vouchers)
	end,
}

PTASaka.Reward {
	key = 'dream',
	atlas = 'JOE_Risk',
	pos = { x = 2, y = 1 },
	use = function(self, card, area, copier)
		SMODS.add_card { set = "Joker", edition = "e_negative", area = G.jokers }
		play_sound('timpani')
		card:juice_up()
		delay(0.6)
	end,
	can_use = function(self, card)
		return true
	end,
}

PTASaka.Reward {
	key = 'sprint',
	atlas = 'JOE_Risk',
	pos = { x = 3, y = 1 },
	use = function(self, card, area, copier)
		local tag = Tag(pseudorandom_element(G.P_CENTER_POOLS.Tag, pseudoseed('dreamsprint')).key)
		if tag.name == "Orbital Tag" then
			local _poker_hands = {}
			for k, v in pairs(G.GAME.hands) do
				if v.visible then
					_poker_hands[#_poker_hands + 1] = k
				end
			end
			tag.ability.orbital_hand = pseudorandom_element(_poker_hands, "joy_orbital")
		end
		add_tag(tag)
		card:juice_up()
		delay(0.6)
	end,
	can_use = function(self, card)
		return true
	end,
}

PTASaka.Reward {
	key = 'sulfur',
	atlas = 'JOE_Risk',
	pos = { x = 4, y = 1 },
	config = { extra = { max_highlighted = 4, min_highlighted = 1 } },
	use = function(self, card, area, copier)
		local destroyed_cards = {}
		for i = #G.hand.highlighted, 1, -1 do
			destroyed_cards[#destroyed_cards + 1] = G.hand.highlighted[i]
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				for i = #G.hand.highlighted, 1, -1 do
					local _c = G.hand.highlighted[i]
					if SMODS.shatters(_c) then
						_c:shatter()
					else
						_c:start_dissolve(nil, i == #G.hand.highlighted)
					end
				end
				return true
			end
		}))
		delay(0.5)
	end,
	can_use = function(self, card)
		return card.ability.extra.max_highlighted >= #G.hand.highlighted and
			#G.hand.highlighted >= (card.ability.extra.min_highlighted or 1)
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.max_highlighted }
		}
	end
}

PTASaka.Reward {
	key = 'enlighten',
	atlas = 'JOE_Risk',
	pos = { x = 2, y = 2 },
	config = { extra = { amt = 3 } },
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		-- ban these from creation
		for _, v in pairs(G.P_CENTER_POOLS.Reward) do
			G.GAME.banned_keys[v.key] = true
		end
		for _ = 1, card.ability.extra.amt do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.2,
				func = function()
					play_sound('tarot1')
					card:juice_up(0.3, 0.5)
					SMODS.add_card { set = "Consumeables", edition = 'e_negative', area = G.consumeables }
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.5,
			func = function()
				-- unban these
				for _, v in pairs(G.P_CENTER_POOLS.Reward) do
					G.GAME.banned_keys[v.key] = nil
				end
				return true
			end
		}))
	end,
	can_use = function(self, card)
		return true
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.amt }
		}
	end
}

PTASaka.Reward {
	key = 'legacy',
	atlas = 'JOE_Risk',
	pos = { x = 1, y = 2 },
	config = { extra = { amt = 1 } },
	use = function(self, card, area, copier)
		local eligibleJokers = {}
		for _, c in pairs(G.jokers.cards) do
			if not SMODS.is_eternal(c, card) then eligibleJokers[#eligibleJokers+1] = c end
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				G.hand:change_size(card.ability.extra.amt)
				if next(eligibleJokers) then
					---@type Card
					local joker = pseudorandom_element(eligibleJokers, 'legacy_proc')
					joker:start_dissolve(G.C.RED)
				end
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		delay(0.5)
	end,
	can_use = function(self, card)
		return G.jokers and #G.jokers.cards > 0
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.amt }
		}
	end
}

local rarities = {
	[1] = "Common",
	[2] = "Uncommon",
	[3] = "Rare",
	[4] = "Legendary"
}

---@type table<string, string|table|nil>
PTASaka.rarity_upgrades = {
	["akyrs_supercommon"] = "Common",
	["Common"] = "Uncommon",
	["Uncommon"] = "Rare",
	["Rare"] = {
		-- Epic rarity
		Cryptid and SMODS.Rarities['cry_epic'] and 'cry_epic' or nil,
		"Legendary"
	},
	["Legendary"] = {
		-- Only if Cryptid is installed, and the rarity exists
		Cryptid and SMODS.Rarities['cry_exotic'] and 'cry_exotic' or nil,
		-- Reverse legendaries
		Entropy and 'entr_reverse_legendary' or nil,
		-- Showdown Jokers
		next(SMODS.find_mod('finity')) and 'finity_showdown' or nil
	},
	-- Reverse legendaries upgrade to exotics
	['entr_reverse_legendary'] = Cryptid and SMODS.Rarities['cry_exotic'] and 'cry_exotic' or nil,
	["payasaka_ahead"] = "payasaka_daeha"
}

PTASaka.Reward {
	key = 'rebirth',
	atlas = 'JOE_Risk',
	pos = { x = 4, y = 2 },
	config = { extra = { max_highlighted = 1, min_highlighted = 1 } },
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		delay(0.2)
		for i = 1, #G.jokers.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					---@type Card
					local _c = G.jokers.highlighted[i]
					---@class Joker: SMODS.Joker
					---@field rarity string|number
					local center = _c.config.center
					local rarity = center.rarity
					if type(rarity) == 'number' then
						rarity = rarities[rarity]
					end
					if PTASaka.rarity_upgrades[rarity] then
						local selected_rarity = PTASaka.rarity_upgrades[rarity]
						if type(selected_rarity) == 'table' then
							if next(selected_rarity) then
								selected_rarity = pseudorandom_element(selected_rarity, 'rare')
							else
								card_eval_status_text(_c, 'extra', nil, nil, nil,
									{ message = localize('k_nope_ex'), instant = true, sound = 'tarot2' }); return true
							end                                                                                                                       -- Aww!
						end
						if not SMODS.is_eternal(_c) then _c:start_dissolve() end
						SMODS.add_card { set = "Joker", rarity = selected_rarity }
					else
						card_eval_status_text(_c, 'extra', nil, nil, nil,
							{ message = localize('k_nope_ex'), instant = true, sound = 'tarot2' });
					end
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.jokers:unhighlight_all(); return true
			end
		}))
		delay(0.5)
	end,
	can_use = function(self, card)
		return card.ability.extra.max_highlighted >= #G.jokers.highlighted and
			#G.jokers.highlighted >= (card.ability.extra.min_highlighted or 1)
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.max_highlighted }
		}
	end
}

PTASaka.Reward {
	key = 'recall',
	atlas = 'JOE_Risk',
	pos = { x = 0, y = 3 },
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				if not G.GAME.payasaka_last_sold_joker then
					attention_text({
						text = localize('k_nope_ex'),
						scale = 1.3,
						hold = 1.4,
						major = card,
						backdrop_colour = G.C.SECONDARY_SET.Tarot,
						align = (G.STATE ~= G.STATES.PLAY_TAROT) and 'tm' or 'cm',
						offset = { x = 0, y = (G.STATE ~= G.STATES.PLAY_TAROT) and -0.2 or 0 },
						silent = true
					})
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.06 * G.SETTINGS.GAMESPEED,
						blockable = false,
						blocking = false,
						func = function()
							play_sound('tarot2', 0.76, 0.4); return true
						end
					}))
					play_sound('tarot2', 1, 0.4)
					card:juice_up(0.3, 0.5)
				else
					SMODS.add_card { key = G.GAME.payasaka_last_sold_joker }
					play_sound('tarot1')
					card:juice_up(0.3, 0.5)
				end
				return true
			end
		}))
		delay(0.5)
	end,
	can_use = function(self, card)
		return true
	end,
}

PTASaka.Reward {
	key = 'meld',
	atlas = 'JOE_Risk',
	pos = { x = 1, y = 3 },
	config = { extra = { max_highlighted = 4, min_highlighted = 2 } },
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
			local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip(); play_sound('card1', percent); G.hand.highlighted[i]:juice_up(0.3, 0.3); return true
				end
			}))
		end
		delay(0.2)
		local rightmost = G.hand.highlighted[1]
		for i = 1, #G.hand.highlighted do
			if G.hand.highlighted[i].T.x > rightmost.T.x then
				rightmost = G.hand
					.highlighted[i]
			end
		end
		for i = 1, #G.hand.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					if G.hand.highlighted[i] ~= rightmost then
						---@type Card
						local _c = G.hand.highlighted[i]
						assert(SMODS.change_base(_c, nil, rightmost.base.value))
					end
					return true
				end
			}))
		end
		for i = 1, #G.hand.highlighted do
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip(); play_sound('tarot2', percent, 0.6); G.hand.highlighted[i]:juice_up(0.3,
						0.3); return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all(); return true
			end
		}))
		delay(0.5)
	end,
	can_use = function(self, card)
		return card.ability.extra.max_highlighted >= #G.hand.highlighted and
			#G.hand.highlighted >= (card.ability.extra.min_highlighted or 1)
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.max_highlighted }
		}
	end
}

PTASaka.Reward {
	key = 'harmony',
	atlas = 'JOE_Risk',
	pos = { x = 2, y = 3 },
	use = function(self, card, area, copier)
		local enhancement = SMODS.poll_enhancement({ key = 'harmony_proc', guaranteed = true })
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.cards do
			local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.cards[i]:flip(); play_sound('card1', percent); G.hand.cards[i]:juice_up(0.3, 0.3); return true
				end
			}))
		end
		for i = 1, #G.hand.cards do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					---@type Card
					local _c = G.hand.cards[i]
					_c:set_ability(G.P_CENTERS[enhancement])
					return true
				end
			}))
		end
		for i = 1, #G.hand.cards do
			local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.cards[i]:flip(); play_sound('tarot2', percent, 0.6); G.hand.cards[i]:juice_up(0.3,
						0.3); return true
				end
			}))
		end
		delay(0.5)
	end,
	can_use = function(self, card)
		return G.hand and #G.hand.cards > 0
	end,
}

PTASaka.Reward {
	key = 'companion',
	atlas = 'JOE_Risk',
	pos = { x = 3, y = 3 },
	use = function(self, card, area, copier)
		SMODS.add_card { set = "Friend", area = G.jokers }
		play_sound('timpani')
		card:juice_up()
		delay(0.6)
	end,
	can_use = function(self, card)
		return #G.jokers.cards < G.jokers.config.card_limit
	end,
}

G.FUNCS.pta_can_select_consumable = function(e)
	local card = e.config.ref_table
	local card_limit = card.edition and card.edition.card_limit or 0
	if #G.consumeables.cards < G.consumeables.config.card_limit + card_limit then
		e.config.colour = G.C.GREEN
		e.config.button = 'use_card'
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

function PTASaka.create_reward_tarot(key, pos, center, hidden_set, hidden_pos, max)
	return PTASaka.Reward {
		key = key,
		atlas = 'JOE_Risk',
		pos = pos,
		config = { extra = { max_highlighted = max or 2, min_highlighted = 1, ability = center } },
		pta_hidden_set = hidden_set or "Tarot",
		pta_hidden_pos = hidden_pos or pos,
		use = function(self, card, area, copier)
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					play_sound('tarot1')
					card:juice_up(0.3, 0.5)
					return true
				end
			}))
			for i = 1, #G.hand.highlighted do
				local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.15,
					func = function()
						G.hand.highlighted[i]:flip(); play_sound('card1', percent); G.hand.highlighted[i]:juice_up(0.3,
							0.3); return true
					end
				}))
			end
			delay(0.2)
			for i = 1, #G.hand.highlighted do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.1,
					func = function()
						---@type Card
						local _c = G.hand.highlighted[i]
						_c:set_ability(card.ability.extra.ability)
						if center == "m_payasaka_mimic" then _c.ability.mimic_card = true end
						return true
					end
				}))
			end
			for i = 1, #G.hand.highlighted do
				local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.15,
					func = function()
						G.hand.highlighted[i]:flip(); play_sound('tarot2', percent, 0.6); G.hand.highlighted[i]:juice_up(
							0.3,
							0.3); return true
					end
				}))
			end
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all(); return true
				end
			}))
			delay(0.5)
		end,
		can_use = function(self, card)
			return card.ability.extra.max_highlighted >= #G.hand.highlighted and
				#G.hand.highlighted >= (card.ability.extra.min_highlighted or 1)
		end,
		loc_vars = function(self, info_queue, card)
			info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.ability]
			return {
				vars = { card.ability.extra.max_highlighted, localize { type = 'name_text', key = card.ability.extra.ability, set = "Enhanced" } }
			}
		end,
		draw = function(self, card, layer)
			if not card.ability.pta_hidden_spawned then
				PTASaka.Reward.draw(self, card, layer)
			end
		end,
		set_card_type_badge = function(self, card, badges)
			badges[#badges + 1] = create_badge(
				card.ability.pta_hidden_spawned and localize('k_tarot') .. "?" or localize('k_reward'),
				G.C.SECONDARY_SET[card.ability.pta_hidden_spawned and "Tarot" or card.ability.set], nil, 1.2
			)
		end
	}
end

-- These are tarots technically
PTASaka.create_reward_tarot('spirit', { x = 5, y = -1 }, "m_payasaka_volatile", "Tarot", { x = 4, y = 4 })
PTASaka.create_reward_tarot('truth', { x = 6, y = 0 }, "m_payasaka_true", "Tarot", { x = 0, y = 4 })
PTASaka.create_reward_tarot('righteousmind', { x = 7, y = -1 }, "m_payasaka_mimic", "Tarot", { x = 1, y = 4 }, 1)
PTASaka.create_reward_tarot('health', { x = 5, y = 0 }, "m_payasaka_laser", "Tarot", { x = 2, y = 4 })

PTASaka.Reward {
	key = 'mind',
	atlas = 'JOE_Risk',
	pos = { x = 0, y = 2 },
	hidden = true,
	soul_set = 'Reward',
	config = { extra = 2, choose = 1 },
	group_key = 'k_legendary_pack',
	update_pack = SMODS.Booster.update_pack,
	kind = 'Joker',
	create_UIBox = SMODS.Booster.create_UIBox,
	fake_booster = true,
	pta_selectable = true,
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Reward)
		ease_background_colour({ new_colour = G.C.SECONDARY_SET.Reward, special_colour = G.C.SET.Reward, contrast = 4 })
	end,
	create_card = function(self, card, i)
		return create_card("Joker", G.pack_cards, true, nil, true, true, nil, 'buf')
	end,
	use = function(self, card, area, copier)
		delay(0.2)

		-- yeah
		G.GAME.PACK_INTERRUPT = G.TAROT_INTERRUPT
		G.STATE_COMPLETE = false
		card.opening = true

		booster_obj = card.config.center
		if booster_obj and SMODS.Centers[booster_obj.key] then
			G.STATE = G.STATES.SMODS_BOOSTER_OPENED
			SMODS.OPENED_BOOSTER = card
		end
		G.GAME.pack_choices = card.ability.choose
		if G.GAME.cry_oboe then
			card.ability.extra = card.ability.extra + G.GAME.cry_oboe
			G.GAME.pack_choices = G.GAME.pack_choices + G.GAME.cry_oboe
			G.GAME.cry_oboe = nil
		end
		G.GAME.pack_size = card.ability.extra

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				card:explode()
				local pack_cards = {}

				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 1.3 * math.sqrt(G.SETTINGS.GAMESPEED),
					blockable = false,
					blocking = false,
					func = function()
						local _size = G.GAME.pack_size

						for i = 1, _size do
							local _c = create_card("Joker", G.pack_cards, true, nil, true, true, nil, 'buf')
							_c.T.x = card.T.x
							_c.T.y = card.T.y
							_c:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 1.5 * G.SETTINGS.GAMESPEED)
							pack_cards[i] = _c
						end
						return true
					end
				}))

				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 1.3 * math.sqrt(G.SETTINGS.GAMESPEED),
					blockable = false,
					blocking = false,
					func = function()
						if G.pack_cards then
							if G.pack_cards and G.pack_cards.VT.y < G.ROOM.T.h then
								for k, v in ipairs(pack_cards) do
									G.pack_cards:emplace(v)
								end
								return true
							end
						end
					end
				}))

				if G.GAME.modifiers.inflation then
					G.GAME.inflation = G.GAME.inflation + 1
					G.E_MANAGER:add_event(Event({
						func = function()
							for k, v in pairs(G.I.CARD) do
								if v.set_cost then v:set_cost() end
							end
							return true
						end
					}))
				end

				return true
			end
		}))
	end,
	can_use = function(self, card)
		return G.STATE == G.STATES.SHOP or G.STATE == G.STATES.BLIND_SELECT
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.choose, card.ability.extra }
		}
	end
}

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
		kind = 'Reward',
		weight = 0,
		no_doe = true,
		cost = 0,
		draw_hand = true,
		create_card = function(self, card, i)
			return create_card("Reward", G.pack_cards, nil, nil, true, true, nil)
		end,
		in_pool = function()
			return false
		end,
		group_key = 'k_moji_pack',
		ease_background_colour = function(self)
			ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Reward)
			ease_background_colour({ new_colour = G.C.SECONDARY_SET.Reward, special_colour = G.C.SET.Reward, contrast = 4 })
		end,
		particles = function(self)
			G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
				timer = 0.015,
				scale = 0.2,
				initialize = true,
				lifespan = 1,
				speed = 1.1,
				padding = -1,
				attach = G.ROOM_ATTACH,
				colours = { G.C.WHITE, HEX('ff9ee3'), HEX('57d5ff'), HEX('6689a4') },
				fill = true
			})
			G.booster_pack_sparkles.fade_alpha = 1
			G.booster_pack_sparkles:fade(1, 0)
		end
	}, 2
)

SMODS.Tag {
	key = 'tier1reward',
	atlas = "JOE_Tags",
	pos = { x = 1, y = 1 },
	in_pool = function(self, args)
		return false
	end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
				local key = 'p_payasaka_moji_normal_1'
				local card = Card(G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
					G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2, G.CARD_W * 1.27, G.CARD_H * 1.27, G.P_CARDS.empty,
					G.P_CENTERS[key], { bypass_discovery_center = true, bypass_discovery_ui = true })
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = card } })
				card:start_materialize()
				return true
			end)
			tag.triggered = true
			return true
		end
	end,
}

SMODS.Tag {
	key = 'tier2reward',
	atlas = "JOE_Tags",
	pos = { x = 2, y = 1 },
	in_pool = function(self, args)
		return false
	end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
				local key = 'p_payasaka_moji_jumbo_1'
				local card = Card(G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
					G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2, G.CARD_W * 1.27, G.CARD_H * 1.27, G.P_CARDS.empty,
					G.P_CENTERS[key], { bypass_discovery_center = true, bypass_discovery_ui = true })
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = card } })
				card:start_materialize()
				return true
			end)
			tag.triggered = true
			return true
		end
	end,
}

SMODS.Tag {
	key = 'tier3reward',
	atlas = "JOE_Tags",
	pos = { x = 3, y = 1 },
	in_pool = function(self, args)
		return false
	end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			tag:yep('+', G.C.SECONDARY_SET.Spectral, function()
				local key = 'p_payasaka_moji_mega_1'
				local card = Card(G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
					G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2, G.CARD_W * 1.27, G.CARD_H * 1.27, G.P_CARDS.empty,
					G.P_CENTERS[key], { bypass_discovery_center = true, bypass_discovery_ui = true })
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = card } })
				card:start_materialize()
				return true
			end)
			tag.triggered = true
			return true
		end
	end,
}
