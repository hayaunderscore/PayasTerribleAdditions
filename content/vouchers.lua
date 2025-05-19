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
	redeem = function (self, card)
		G.GAME.payasaka_monopolizer_mult = G.GAME.payasaka_monopolizer_mult or 0
		G.GAME.payasaka_monopolizer_mult = G.GAME.payasaka_monopolizer_mult + card.ability.mult
	end,
	unredeem = function (self, card)
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
	redeem = function (self, card)
		G.GAME.payasaka_monopolizer_x_mult = G.GAME.payasaka_monopolizer_x_mult or 0
		G.GAME.payasaka_monopolizer_x_mult = G.GAME.payasaka_monopolizer_x_mult + card.ability.x_mult
	end,
	unredeem = function (self, card)
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
		push = push..s
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
								object = DynaText{
									string = TMTRAINER_STRINGS_ONE,
									colours = { G.C.UI.TEXT_DARK },
									pop_in_rate = 9999999,
									silent = true,
									random_element = true,
									pop_delay = 0.2,
									scale = 0.32,
									font = AKYRS and AKYRS.Fonts["payasaka_pokemon"] or G.LANG.font,
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
								object = DynaText{
									string = TMTRAINER_STRINGS_TWO,
									colours = { G.C.UI.TEXT_DARK },
									pop_in_rate = 9999999,
									silent = true,
									random_element = true,
									pop_delay = 0.2,
									scale = 0.32,
									font = AKYRS and AKYRS.Fonts["payasaka_pokemon"] or G.LANG.font,
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
								object = DynaText{
									string = TMTRAINER_STRINGS_ONE,
									colours = { G.C.UI.TEXT_DARK },
									pop_in_rate = 9999999,
									silent = true,
									random_element = true,
									pop_delay = 0.2,
									scale = 0.32,
									font = AKYRS and AKYRS.Fonts["payasaka_pokemon"] or G.LANG.font,
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
								object = DynaText{
									string = TMTRAINER_STRINGS_TWO,
									colours = { G.C.UI.TEXT_DARK },
									pop_in_rate = 9999999,
									silent = true,
									random_element = true,
									pop_delay = 0.2,
									scale = 0.32,
									font = AKYRS and AKYRS.Fonts["payasaka_pokemon"] or G.LANG.font,
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
