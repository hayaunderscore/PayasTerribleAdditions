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

local basegamesounds = {
	"button",
	"cancel",
	"card1",
	"card3",
	"cardFan2",
	"cardSlide1",
	"cardSlide2",
	"chips1",
	"chips2",
	"coin1",
	"coin2",
	"coin3",
	"coin4",
	"coin5",
	"coin6",
	"coin7",
	"crumple1",
	"crumple2",
	"crumple3",
	"crumple4",
	"crumple5",
	"crumpleLong1",
	"crumpleLong2",
	"crumpleLong2",
	"foil1",
	"foil2",
	"generic1",
	"glass1",
	"glass2",
	"glass3",
	"glass4",
	"glass5",
	"glass6",
	"gold_seal",
	"gong",
	"highlight1",
	"highlight2",
	"holo1",
	"magic_crumple",
	"magic_crumple2",
	"magic_crumple3",
	"multhit1",
	"multhit2",
	"negative",
	"other1",
	"paper1",
	"polychrome1",
	"slice1",
	"tarot1",
	"tarot2",
	"timpani",
	"whoosh",
	"whoosh1",
	"whoosh2",
}

local cached_sound_list = basegamesounds

local old_play_sound = play_sound
function play_sound(sound, per, vol)
	if cached_sound_list and not SMODS.Sounds[sound] and G.GAME.payasaka_tmtrainer_effects and string.sub(sound, 1, 7) ~= "ambient" and string.sub(sound, 1, 3) ~= "mus" and string.sub(sound, 1, 3) ~= "win" and string.sub(sound, 1, 9) ~= "explosion" and string.sub(sound, 1, 5) ~= "voice" and string.sub(sound, 1, 5) ~= "intro" and string.sub(sound, 1, 6) ~= "splash" then
		sound = cached_sound_list[math.random(1, #cached_sound_list)]
		return old_play_sound(sound, per, vol)
	end
	return old_play_sound(sound, per, vol)
end

local old_mod_chips = mod_chips
function mod_chips(_chips)
	_chips = _chips * pseudorandom("payasaka_tmtrainer_randomness", G.GAME.payasaka_tmtrainer_low_rnd or 1, G.GAME.payasaka_tmtrainer_high_rnd or 1)
	return old_mod_chips(_chips)
end

local old_mod_mult = mod_mult
function mod_mult(_mult)
	_mult = _mult * pseudorandom("payasaka_tmtrainer_randomness", G.GAME.payasaka_tmtrainer_low_rnd or 1, G.GAME.payasaka_tmtrainer_high_rnd or 1)
	return old_mod_mult(_mult)
end

local old_localize = localize
function localize(args, misc_cat)
	local ret = old_localize(args, misc_cat)
	if type(ret) == "string" and G and G.GAME and G.GAME.payasaka_tmtrainer_effects then
		return PTASaka.ZZAZZ_string(ret)
	end
	return ret
end

local old_juice_up = Moveable.juice_up
function Moveable:juice_up(amt, rot)
	old_juice_up(self, amt, rot)
	self.juice.r_amt = self.juice.r_amt * pseudorandom("payasaka_tmtrainer_vrandomness", G.GAME.payasaka_tmtrainer_low_rnd or 1, G.GAME.payasaka_tmtrainer_high_rnd or 1)
	self.juice.scale_amt = self.juice.scale_amt * pseudorandom("payasaka_tmtrainer_vrandomness", G.GAME.payasaka_tmtrainer_low_rnd or 1, G.GAME.payasaka_tmtrainer_high_rnd or 1)
	self.VT.scale = self.VT.scale * pseudorandom("payasaka_tmtrainer_vrandomness", G.GAME.payasaka_tmtrainer_low_rnd or 1, G.GAME.payasaka_tmtrainer_high_rnd or 1)
end

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
