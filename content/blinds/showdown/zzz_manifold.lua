-- Finity cross mod
if next(SMODS.find_mod('finity')) then
	FinisherBossBlindStringMap = FinisherBossBlindStringMap or {}
	FinisherBossBlindStringMap["bl_payasaka_showdown_manifold_mayhem"] = {"j_payasaka_manifold_mayhem", "Manifold Mayhem"}
	FinisherBossBlindQuips = FinisherBossBlindQuips or {}
	FinisherBossBlindQuips["bl_payasaka_showdown_manifold_mayhem"] = {"manifold", 4}
end

SMODS.Blind {
	key = 'showdown_manifold_mayhem',
	atlas = "JOE_Blinds",
	pos = { x = 0, y = 3 },
	dollars = 8,
	mult = 4,
	boss_colour = HEX('7b194e'),
	boss = { min = 8, showdown = true },
	set_blind = function(self)
		G.GAME.payasaka_manifold_mayhem = true
		G.GAME.payasaka_old_manifest_chips = G.GAME.blind.chips
		local mult = math.max(((G.GAME.payasaka_small_blind_surplus or 2)*(G.GAME.payasaka_big_blind_surplus or 2)), 4)
		-- Cryptid bros dont get no nerf
		if to_big(mult) > to_big(100) and not PTASaka.is_cryptid then mult = to_big(100) end
		mult = math.floor(mult)
		G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*mult*G.GAME.starting_params.ante_scaling
		self.mult = mult
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
	end,
	disable = function(self)
		G.GAME.payasaka_manifold_mayhem = false
		G.GAME.blind.chips = G.GAME.payasaka_old_manifest_chips
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
	end,
	defeat = function(self)
		G.GAME.payasaka_manifold_mayhem = false
	end,
	get_loc_debuff_text = function(self)
		return "Blind multiplier is Small Blind surplus * Big Blind surplus"
	end
}

local old_end_round = end_round
function end_round()
	old_end_round()
	if G.GAME.blind_on_deck == 'Small' then
		G.GAME.payasaka_small_blind_surplus = to_big(G.GAME.chips)/to_big(G.GAME.blind.chips)
		if (not PTASaka.is_cryptid) and to_big(G.GAME.payasaka_small_blind_surplus) > to_big(50) then G.GAME.payasaka_small_blind_surplus = to_big(50) end
		--print(G.GAME.payasaka_small_blind_surplus)
	end
	if G.GAME.blind_on_deck == 'Big' then
		G.GAME.payasaka_big_blind_surplus = to_big(G.GAME.chips)/to_big(G.GAME.blind.chips)
		if (not PTASaka.is_cryptid) and to_big(G.GAME.payasaka_big_blind_surplus) > to_big(50) then G.GAME.payasaka_big_blind_surplus = to_big(50) end
		--print(G.GAME.payasaka_big_blind_surplus)
	end
end