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
  if (e.config.ref_table.cost > G.GAME.dollars - G.GAME.bankrupt_at) and (e.config.ref_table.area and e.config.ref_table.area.config.type == 'shop') then
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

		self.states.hover.can = false
		G.GAME.used_jokers[self.config.center_key] = true
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
		ease_dollars(-self.cost)
		inc_career_stat('c_shop_dollars_spent', self.cost)
		inc_career_stat('c_vouchers_bought', 1)
		set_voucher_usage(self)
		check_for_unlock({ type = 'run_redeem' })

		if self.ability.set == "Back" then
			local copy = PTASaka.deep_copy(G.P_CENTERS[self.config.center_key])
			copy.center = G.P_CENTERS[self.config.center_key]
			local fake = { name = G.P_CENTERS[self.config.center_key].name, effect = copy }
			Back.apply_to_run(fake)
			-- hiiii
		end
		if self.ability.set == "Sleeve" then
			if G.P_CENTERS[self.config.center_key].apply then
				--CardSleeves.Sleeve.apply(G.P_CENTERS[card.ability.set_deck])
				G.P_CENTERS[self.config.center_key]:apply(G.P_CENTERS[self.config.center_key])
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
