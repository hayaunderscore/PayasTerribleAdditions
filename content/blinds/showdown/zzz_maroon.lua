-- Finity cross mod
if next(SMODS.find_mod('finity')) then
	FinisherBossBlindStringMap = FinisherBossBlindStringMap or {}
	FinisherBossBlindStringMap["bl_payasaka_showdown_maroon_rose"] = {"j_joker", "Maroon Rose"}
	--FinisherBossBlindQuips = FinisherBossBlindQuips or {}
	--FinisherBossBlindQuips["bl_payasaka_showdown_maroon_rose"] = {"manifold", 4}
end

SMODS.Blind {
	key = 'showdown_maroon_rose',
	atlas = "JOE_Blinds",
	pos = { x = 0, y = 9 },
	dollars = 8,
	mult = 2,
	boss_colour = HEX('7c0000'),
	boss = { min = 8, showdown = true },
	calculate = function(self, blind, context)
		if not blind.disabled then
			if context.before and #context.scoring_hand > 0 then
				for _, card in pairs({context.scoring_hand[1], context.scoring_hand[#context.scoring_hand]}) do
					SMODS.debuff_card(card, true, "maroon_rose")
					card.pta_no_show_debuff = true
					card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = localize('k_debuffed'),
						extrafunc = function()
							card.pta_no_show_debuff = nil
						end
					})
				end
			end
			if context.end_of_round and context.main_eval then
				for _, card in pairs(G.playing_cards) do
					SMODS.debuff_card(card, false, "maroon_rose")
				end
			end
		end
	end
}

local old_end_round = end_round
function end_round()
	old_end_round()
	if G.GAME.blind_on_deck == 'Small' then
		G.GAME.payasaka_small_blind_surplus = to_big(G.GAME.chips)/to_big(G.GAME.blind.chips)
		if (not Cryptid) and to_big(G.GAME.payasaka_small_blind_surplus) > to_big(50) then G.GAME.payasaka_small_blind_surplus = to_big(50) end
		--print(G.GAME.payasaka_small_blind_surplus)
	end
	if G.GAME.blind_on_deck == 'Big' then
		G.GAME.payasaka_big_blind_surplus = to_big(G.GAME.chips)/to_big(G.GAME.blind.chips)
		if (not Cryptid) and to_big(G.GAME.payasaka_big_blind_surplus) > to_big(50) then G.GAME.payasaka_big_blind_surplus = to_big(50) end
		--print(G.GAME.payasaka_big_blind_surplus)
	end
end