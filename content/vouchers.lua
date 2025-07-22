--[[
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.payasaka_monopolizer_mult = 0
	ret.payasaka_monopolizer_x_mult = 0
	return ret
end
]]

SMODS.Voucher {
	key = "monopolizer",
	atlas = 'JOE_Vouchers',
	pos = { x = 0, y = 0 },
	cost = 10,
	config = { mult = 10 },
	redeem = function(self, card)
		G.GAME.payasaka_monopolizer_mult = G.GAME.payasaka_monopolizer_mult or 0
		G.GAME.payasaka_monopolizer_mult = G.GAME.payasaka_monopolizer_mult + card.ability.mult
	end,
	unredeem = function(self, card)
		G.GAME.payasaka_monopolizer_mult = G.GAME.payasaka_monopolizer_mult or 0
		G.GAME.payasaka_monopolizer_mult = G.GAME.payasaka_monopolizer_mult - card.ability.mult
	end,
	-- like The Greed, only appear when we have atleast one property card
	in_pool = function(self, args)
		local properties = {}
		if not (G.consumeables and G.consumeables.cards and G.consumeables.cards[1]) then return false end
		for _, v in ipairs(G.consumeables.cards) do
			if v.ability.set == 'Property' then
				table.insert(properties, v)
			end
		end
		return #properties > 0
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult } }
	end
}

SMODS.Voucher {
	key = "meritocracy",
	atlas = 'JOE_Vouchers',
	pos = { x = 1, y = 0 },
	cost = 10,
	config = { x_mult = 1.5 },
	requires = { "v_payasaka_monopolizer" },
	redeem = function(self, card)
		G.GAME.payasaka_monopolizer_x_mult = G.GAME.payasaka_monopolizer_x_mult or 0
		G.GAME.payasaka_monopolizer_x_mult = G.GAME.payasaka_monopolizer_x_mult + card.ability.x_mult
	end,
	unredeem = function(self, card)
		G.GAME.payasaka_monopolizer_x_mult = G.GAME.payasaka_monopolizer_x_mult or 0
		G.GAME.payasaka_monopolizer_x_mult = G.GAME.payasaka_monopolizer_x_mult - card.ability.x_mult
	end,
	-- like The Greed, only appear when we have atleast one property card
	in_pool = function(self, args)
		local properties = {}
		if not (G.consumeables and G.consumeables.cards and G.consumeables.cards[1]) then return false end
		for _, v in ipairs(G.consumeables.cards) do
			if v.ability.set == 'Property' then
				table.insert(properties, v)
			end
		end
		return #properties > 0
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.x_mult } }
	end
}

local excluded_letters = {
	["A"] = true,
	[" "] = true,
	["0"] = true,
	["1"] = true,
	["2"] = true,
	["3"] = true,
	["4"] = true,
	["5"] = true,
	["6"] = true,
	["7"] = true,
	["8"] = true,
	["9"] = true,
	["+"] = true,
	["-"] = true,
	["$"] = true,
	["^"] = true,
	["{"] = true,
	["}"] = true,
	["#"] = true,
}

function PTASaka.ZZAZZ_string(_str)
	local str = _str:upper()
	local push = ""
	for i = 1, #str do
		local s = string.sub(str, i, i)
		if pseudorandom("payasaka_ZZAZZ_string") > 0.2 and not excluded_letters[s] then
			s = "Z"
		end
		push = push .. s
	end
	return push
end

local TMTRAINER_STRING = {
	"This is a very cool",
	"voucher Please take it"
}

SMODS.Voucher {
	key = 'tmtrainer',
	atlas = 'JOE_Vouchers',
	pos = { x = 0, y = 1 },
	cost = 10,
	redeem = function(self, voucher)
		--G.GAME.payasaka_tmtrainer_effects = true
		G.GAME.payasaka_tmtrainer_low_rnd = (G.GAME.payasaka_tmtrainer_low_rnd or 1) / 2
		G.GAME.payasaka_tmtrainer_high_rnd = (G.GAME.payasaka_tmtrainer_high_rnd or 1) * 2
	end,
	unredeem = function(self, voucher)
		--G.GAME.payasaka_tmtrainer_effects = false
		G.GAME.payasaka_tmtrainer_low_rnd = (G.GAME.payasaka_tmtrainer_low_rnd or 1) * 2
		G.GAME.payasaka_tmtrainer_high_rnd = (G.GAME.payasaka_tmtrainer_high_rnd or 1) / 2
	end,
	loc_vars = function(self, info_queue, card)
		local TMTRAINER_STRINGS_ONE = {}
		local TMTRAINER_STRINGS_TWO = {}
		for i = 1, 5 do
			TMTRAINER_STRINGS_ONE[i] = {
				string = PTASaka.ZZAZZ_string(TMTRAINER_STRING[1]),
				colour = G.C.UI.TEXT_DARK,
			}
			TMTRAINER_STRINGS_TWO[i] = {
				string = PTASaka.ZZAZZ_string(TMTRAINER_STRING[2]),
				colour = G.C.UI.TEXT_DARK,
			}
		end
		return {
			main_start = {
				{
					n = G.UIT.C,
					config = {},
					nodes = {
						{
							n = G.UIT.O,
							config = {
								object = DynaText {
									string = TMTRAINER_STRINGS_ONE,
									colours = { G.C.UI.TEXT_DARK },
									pop_in_rate = 9999999,
									silent = true,
									random_element = true,
									pop_delay = 0.2,
									scale = 0.32,
									font = PTASaka.Fonts and PTASaka.Fonts["payasaka_pokemon"] or G.LANG.font,
									min_cycle_time = 0,
								}
							}
						},
					}
				}
			},
			main_end = {
				{
					n = G.UIT.C,
					config = {},
					nodes = {
						{
							n = G.UIT.O,
							config = {
								object = DynaText {
									string = TMTRAINER_STRINGS_TWO,
									colours = { G.C.UI.TEXT_DARK },
									pop_in_rate = 9999999,
									silent = true,
									random_element = true,
									pop_delay = 0.2,
									scale = 0.32,
									font = PTASaka.Fonts and PTASaka.Fonts["payasaka_pokemon"] or G.LANG.font,
									min_cycle_time = 0,
								}
							}
						},
					}
				}
			}
		}
	end
}

local COOLTRAINER_STRING = {
	"REALLY Col move !!!!",
	"mr zzazz wAuld lAve this"
}

SMODS.Voucher {
	key = 'cooltrainer',
	atlas = 'JOE_Vouchers',
	pos = { x = 1, y = 1 },
	cost = 10,
	requires = { "v_payasaka_tmtrainer" },
	redeem = function(self, voucher)
		G.GAME.payasaka_tmtrainer_effects = true
		G.GAME.payasaka_tmtrainer_low_rnd = (G.GAME.payasaka_tmtrainer_low_rnd or 1) / 10
		G.GAME.payasaka_tmtrainer_high_rnd = (G.GAME.payasaka_tmtrainer_high_rnd or 1) * 10
		G.HUD:recalculate()
	end,
	unredeem = function(self, voucher)
		G.GAME.payasaka_tmtrainer_effects = false
		G.GAME.payasaka_tmtrainer_low_rnd = (G.GAME.payasaka_tmtrainer_low_rnd or 1) * 10
		G.GAME.payasaka_tmtrainer_high_rnd = (G.GAME.payasaka_tmtrainer_high_rnd or 1) / 10
		G.HUD:recalculate()
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader('negative', nil, card.ARGS.send_to_shader)
	end,
	loc_vars = function(self, info_queue, card)
		local TMTRAINER_STRINGS_ONE = {}
		local TMTRAINER_STRINGS_TWO = {}
		for i = 1, 5 do
			TMTRAINER_STRINGS_ONE[i] = {
				string = PTASaka.ZZAZZ_string(COOLTRAINER_STRING[1]),
				colour = G.C.UI.TEXT_DARK,
			}
			TMTRAINER_STRINGS_TWO[i] = {
				string = PTASaka.ZZAZZ_string(COOLTRAINER_STRING[2]),
				colour = G.C.UI.TEXT_DARK,
			}
		end
		return {
			main_start = {
				{
					n = G.UIT.C,
					config = {},
					nodes = {
						{
							n = G.UIT.O,
							config = {
								object = DynaText {
									string = TMTRAINER_STRINGS_ONE,
									colours = { G.C.UI.TEXT_DARK },
									pop_in_rate = 9999999,
									silent = true,
									random_element = true,
									pop_delay = 0.2,
									scale = 0.32,
									font = PTASaka.Fonts and PTASaka.Fonts["payasaka_pokemon"] or G.LANG.font,
									min_cycle_time = 0,
								}
							}
						},
					}
				}
			},
			main_end = {
				{
					n = G.UIT.C,
					config = {},
					nodes = {
						{
							n = G.UIT.O,
							config = {
								object = DynaText {
									string = TMTRAINER_STRINGS_TWO,
									colours = { G.C.UI.TEXT_DARK },
									pop_in_rate = 9999999,
									silent = true,
									random_element = true,
									pop_delay = 0.2,
									scale = 0.32,
									font = PTASaka.Fonts and PTASaka.Fonts["payasaka_pokemon"] or G.LANG.font,
									min_cycle_time = 0,
								}
							}
						},
					}
				}
			}
		}
	end
}

--[[
local old_start_up = Game.start_run
function Game:start_run(args)
	local ret = old_start_up(self, args)
	cached_sound_list = PTASaka.deep_copy(basegamesounds)
	for k, v in pairs(SMODS.Sounds) do
		cached_sound_list[#cached_sound_list+1] = k
	end
	return ret
end
]]

SMODS.Voucher {
	key = "friends",
	atlas = 'JOE_Vouchers',
	pos = { x = 2, y = 0 },
	cost = 10,
	config = { modded_rate = 0.35 },
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
	redeem = function(self, card)
		G.GAME.payasaka_modded_rate = G.GAME.payasaka_modded_rate + card.ability.modded_rate
	end,
	unredeem = function(self, card)
		G.GAME.payasaka_modded_rate = math.max(G.GAME.payasaka_modded_rate - card.ability.modded_rate, 0)
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.modded_rate * 100 } }
	end
}

SMODS.Rarities["Rare"].get_weight = function(self, weight, object_type)
	return weight + (G.GAME.payasaka_rare_weight or 0)
end

SMODS.Rarities["Legendary"].get_weight = function(self, weight, object_type)
	return weight + (G.GAME.payasaka_legendary_weight or 0)
end

SMODS.Voucher {
	key = "crash",
	atlas = 'JOE_Vouchers',
	pos = { x = 3, y = 0 },
	cost = 10,
	config = { rare_rate = 0.1, legendary_rate = 0.05 },
	requires = { "v_payasaka_friends" },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	redeem = function(self, card)
		G.GAME.payasaka_rare_weight = G.GAME.payasaka_rare_weight or 0
		G.GAME.payasaka_legendary_weight = G.GAME.payasaka_legendary_weight or 0
		G.GAME.payasaka_rare_weight = G.GAME.payasaka_rare_weight + card.ability.rare_rate
		G.GAME.payasaka_legendary_weight = G.GAME.payasaka_legendary_weight + card.ability.legendary_rate
	end,
	unredeem = function(self, card)
		G.GAME.payasaka_rare_weight = G.GAME.payasaka_rare_weight or 0
		G.GAME.payasaka_legendary_weight = G.GAME.payasaka_legendary_weight or 0
		G.GAME.payasaka_rare_weight = G.GAME.payasaka_rare_weight - card.ability.rare_rate
		G.GAME.payasaka_legendary_weight = G.GAME.payasaka_legendary_weight - card.ability.legendary_rate
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.rare_rate * 100, card.ability.legendary_rate * 100 } }
	end,
}

SMODS.Voucher {
	key = "equilibrium",
	atlas = 'JOE_Vouchers',
	pos = { x = 4, y = 0 },
	cost = 10,
	pyroxenes = 15,
	requires = { "v_payasaka_crash" },
	no_collection = true,
	redeem = function(self, voucher)
		G.E_MANAGER:add_event(Event {
			func = function()
				play_sound("payasaka_coolgong", 1, 0.6)
				return true
			end
		})
	end,
	-- Cannot be in the normal pool ever, and can only appear via Remember
	in_pool = function(self, args)
		return false
	end
}

SMODS.Voucher {
	key = "parakmi",
	atlas = 'JOE_Vouchers',
	pos = { x = 5, y = 0 },
	soul_pos = { x = 5, y = 1 },
	cost = 10,
	pyroxenes = 100,
	requires = { "v_payasaka_equilibrium" },
	no_collection = true,
	redeem = function(self, voucher)
		G.E_MANAGER:add_event(Event {
			func = function()
				play_sound("payasaka_coolgong", 1, 0.6)
				return true
			end
		})
	end,
	-- Cannot be in the normal pool ever, and can only appear via Remember
	in_pool = function(self, args)
		return false
	end
}

G.FUNCS.can_redeem_deck_or_sleeve = function(e)
	if (to_big(e.config.ref_table.cost) > to_big(G.GAME.dollars) - to_big(G.GAME.bankrupt_at)) and (e.config.ref_table.area and e.config.ref_table.area.config.type == 'shop') then
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else
		e.config.colour = G.C.GREEN
		e.config.button = 'use_card'
	end
end

function PTASaka.deck_sleeve_redeem(self)
	if (self.ability.set == "Back" or self.ability.set == "Sleeve") then
		stop_use()
		--print("hi")

		self.states.hover.can = false
		G.GAME.used_jokers[self.config.center_key] = true
		G.GAME.used_vouchers[self.config.center_key] = true
		G.GAME.payasaka_redeemed_deck_or_sleeve = true
		local top_dynatext = nil
		local bot_dynatext = nil

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				top_dynatext = DynaText({
					string = localize { type = 'name_text', set = self.config.center.set, key = self.config.center.key },
					colours = { G.C.WHITE },
					rotate = 1,
					shadow = true,
					bump = true,
					float = true,
					scale = 0.9,
					pop_in = 0.6 /
						G.SPEEDFACTOR,
					pop_in_rate = 1.5 * G.SPEEDFACTOR
				})
				bot_dynatext = DynaText({
					string = localize('k_redeemed_ex'),
					colours = { G.C.WHITE },
					rotate = 2,
					shadow = true,
					bump = true,
					float = true,
					scale = 0.9,
					pop_in = 1.4 /
						G.SPEEDFACTOR,
					pop_in_rate = 1.5 * G.SPEEDFACTOR,
					pitch_shift = 0.25
				})
				self:juice_up(0.3, 0.5)
				play_sound('card1')
				play_sound('coin1')
				self.children.top_disp = UIBox {
					definition = { n = G.UIT.ROOT, config = { align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15 }, nodes = {
						{ n = G.UIT.O, config = { object = top_dynatext } }
					} },
					config = { align = "tm", offset = { x = 0, y = 0 }, parent = self }
				}
				self.children.bot_disp = UIBox {
					definition = { n = G.UIT.ROOT, config = { align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15 }, nodes = {
						{ n = G.UIT.O, config = { object = bot_dynatext } }
					} },
					config = { align = "bm", offset = { x = 0, y = 0 }, parent = self }
				}
				return true
			end
		}))
		if self.cost and self.cost > 0 then
			ease_dollars(-self.cost)
		end
		inc_career_stat('c_shop_dollars_spent', self.cost)
		--inc_career_stat('c_vouchers_bought', 1)
		--set_voucher_usage(self)
		check_for_unlock({ type = 'run_redeem' })

		local conf = G.P_CENTERS[self.config.center_key].config
		if self.ability.set == "Back" then
			local copy = PTASaka.deep_copy(G.P_CENTERS[self.config.center_key])
			copy.center = G.P_CENTERS[self.config.center_key]
			local fake = { name = G.P_CENTERS[self.config.center_key].name, effect = copy }
			G.is_redeeming_deck = true
			Back.apply_to_run(fake)
			if not G.GAME.payasaka_used_decks then G.GAME.payasaka_used_decks = {} end
			G.GAME.payasaka_used_decks[self.config.center_key] = true
			-- hiiii
		end
		if self.ability.set == "Sleeve" then
			if G.P_CENTERS[self.config.center_key].apply then
				--CardSleeves.Sleeve.apply(G.P_CENTERS[card.ability.set_deck])
				G.P_CENTERS[self.config.center_key]:apply(G.P_CENTERS[self.config.center_key])
				if not G.GAME.payasaka_used_sleeves then G.GAME.payasaka_used_sleeves = {} end
				G.GAME.payasaka_used_sleeves[self.config.center_key] = true
			end
		end

		-- Entropy compat
		if Entropy then
			G.GAME.entr_bought_decks = G.GAME.entr_bought_decks or {}
			G.GAME.entr_bought_decks[#G.GAME.entr_bought_decks+1] = self.config.center_key
		end

		-- Apply effects that would only apply at the start of a run
		G.GAME.round_resets.hands = G.GAME.round_resets.hands + (conf.hands or 0)
		if conf.hands then ease_hands_played(conf.hands or 0) end
		G.GAME.round_resets.discards = G.GAME.round_resets.discards + (conf.discards or 0)
		if conf.discards then ease_discard(conf.discards or 0) end
		G.GAME.base_reroll_cost = math.max(0, G.GAME.base_reroll_cost - (conf.reroll_discount or 0))
		if conf.dollars then ease_dollars(conf.dollars or 0) end
		if conf.remove_faces then
			G.E_MANAGER:add_event(Event({
				func = function()
					if G.playing_cards then
						local cardtable = {}
						for k, v in ipairs(G.playing_cards) do cardtable[#cardtable + 1] = v end
						for i = #cardtable, 1, -1 do
							if (cardtable[i]:get_id() == 11 or cardtable[i]:get_id() == 12 or cardtable[i]:get_id() == 13) then
								cardtable[i]:remove()
								--G.playing_cards[i] = nil
							end
						end
					end
					return true
				end,
			}))
		end
		if conf.randomize_rank_suit then
			G.E_MANAGER:add_event(Event({
				func = function()
					-- Only use suits of cards available in the deck
					local valid = {}
					for _, v in ipairs(G.playing_cards or {}) do
						if not SMODS.has_no_suit(v) then
							valid[#valid + 1] = {
								card_key = string.sub(v.base.suit, 1, 1),
								key =
									v.base.suit
							}
						end
					end
					-- Ok then.
					if not valid[1] then valid = { SMODS.Suits['Hearts'] } end
					if G.playing_cards then
						for i = 1, #G.playing_cards do
							---@type Card
							local c = G.playing_cards[i]
							if c then
								local suit = pseudorandom_element(valid, pseudoseed('erratic')).key
								local rank = pseudorandom_element(SMODS.Ranks, pseudoseed('erratic')).key
								_ = SMODS.change_base(c, suit, rank)
							end
						end
					end
					return true
				end,
			}))
		end
		G.jokers.config.card_limit = G.jokers.config.card_limit + (conf.joker_slot or 0)
		G.hand.config.card_limit = G.hand.config.card_limit + (conf.hand_size or 0)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + (conf.consumable_slot or 0)
		-- Nostalgic Deck fix, mostly taken from Entropy
		-- hi ruby
		if conf.cry_beta then
			local cnt = G.consumeables.config.card_limit
			local cards = {}
			for _, v in ipairs(G.jokers.cards) do
				cards[#cards + 1] = v
				v:remove_from_deck()
				G.jokers:remove_card(v)
			end
			for _, v in ipairs(G.consumeables.cards) do
				cards[#cards + 1] = v
				v:remove_from_deck()
				G.consumeables:remove_card(v)
			end
			G.consumeables:remove()
			cnt = cnt + G.jokers.config.card_limit
			G.jokers:remove()
			G.consumeables = nil
			local CAI = {
				discard_W = G.CARD_W,
				discard_H = G.CARD_H,
				deck_W = G.CARD_W * 1.1,
				deck_H = 0.95 * G.CARD_H,
				hand_W = 6 * G.CARD_W,
				hand_H = 0.95 * G.CARD_H,
				play_W = 5.3 * G.CARD_W,
				play_H = 0.95 * G.CARD_H,
				joker_W = 4.9 * G.CARD_W,
				joker_H = 0.95 * G.CARD_H,
				consumeable_W = 2.3 * G.CARD_W,
				consumeable_H = 0.95 * G.CARD_H
			}
			G.jokers = CardArea(
				CAI.consumeable_W, 0,
				CAI.joker_W + CAI.consumeable_W,
				CAI.joker_H,
				{ card_limit = cnt, type = 'joker', highlight_limit = 1e100 }
			)
			G.consumeables = G.jokers
			for i, v in pairs(cards) do
				v:add_to_deck()
				G.jokers:emplace(v)
			end
		end

		delay(0.6)
		SMODS.calculate_context({ buying_card = true, card = self })
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
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 2.6,
			func = function()
				top_dynatext:pop_out(4)
				bot_dynatext:pop_out(4)
				return true
			end
		}))

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.5,
			func = function()
				self.children.top_disp:remove()
				self.children.top_disp = nil
				self.children.bot_disp:remove()
				self.children.bot_disp = nil
				return true
			end
		}))
	end
end
