-- Hook to localize >:)
--[[
local lcz = localize
function localize(args, misc_cat)
	if args and G and G.GAME and G.GAME.payasaka_markiplier_multiplied then
		if args.key == "a_mult" then
			args.key = "a_xmult"
		end
		if args.key == "a_mult_minus" then
			args.key = "a_xmult_minus"
		end
		if args.key == "a_chips" then
			args.key = "a_xchips"
		end
		if args.key == "a_chips_minus" then
			args.key = "a_xchips_minus"
		end
		G.GAME.payasaka_markiplier_multiplied = false
	end
	return lcz(args, misc_cat)
end

local cest = card_eval_status_text
function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
	cest(card, eval_type, amt, percent, dir, extra)
end
]]

-- Markiplier :DD
SMODS.Joker {
	name = "Multiplier",
	key = "markiplier_punch_gif",
	config = { extra = { xmult_odds = 1, xmult_chance = 4, xchips_odds = 1, xchips_chance = 4 } },
	loc_vars = function(self, info_queue, card)
		local r = card.ability.cry_rigged
		local oddmult = G.GAME.probabilities.normal or 1
		return { vars = { r and card.ability.extra.xmult_chance or card.ability.extra.xmult_odds*oddmult, card.ability.extra.xmult_chance, r and card.ability.extra.xchips_chance or card.ability.extra.xchips_odds*oddmult, card.ability.extra.xchips_chance } }
	end,
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 4, y = 1 },
	cost = 10,
	blueprint_compat = true,
	update = function (self, card, dt)
		if card.ability.cry_rigged then G.GAME.markiplier_prob_rigged = true end
	end,
	add_to_deck = function (self, card, from_debuff)
		G.GAME.markiplier_prob_xmult_chance = G.GAME.markiplier_prob_xmult_chance + card.ability.extra.xmult_chance
		G.GAME.markiplier_prob_xmult_odds = G.GAME.markiplier_prob_xmult_odds + card.ability.extra.xmult_odds
		G.GAME.markiplier_prob_xchips_chance = G.GAME.markiplier_prob_xchips_chance + card.ability.extra.xchips_chance
		G.GAME.markiplier_prob_xchips_odds = G.GAME.markiplier_prob_xchips_odds + card.ability.extra.xchips_odds
		if not from_debuff then
			play_sound("payasaka_markiplier_helloeverybody")
		end
	end,
	remove_from_deck = function (self, card, from_debuff)
		G.GAME.markiplier_prob_xmult_chance = G.GAME.markiplier_prob_xmult_chance - card.ability.extra.xmult_chance
		G.GAME.markiplier_prob_xmult_odds = G.GAME.markiplier_prob_xmult_odds - card.ability.extra.xmult_odds
		G.GAME.markiplier_prob_xchips_chance = G.GAME.markiplier_prob_xchips_chance - card.ability.extra.xchips_chance
		G.GAME.markiplier_prob_xchips_odds = G.GAME.markiplier_prob_xchips_odds - card.ability.extra.xchips_odds
		G.GAME.markiplier_prob_rigged = false
	end
}

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	-- Init multiplier related odds
	ret.markiplier_prob_xmult_chance = 0
	ret.markiplier_prob_xmult_odds = 0
	ret.markiplier_prob_xchips_chance = 0
	ret.markiplier_prob_xchips_odds = 0
	ret.markiplier_prob_rigged = false
	return ret
end