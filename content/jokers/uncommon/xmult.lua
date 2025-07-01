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
	config = { extra = { xmult_odds = 4, xchips_odds = 4 } },
	loc_vars = function(self, info_queue, card)
		local r = card.ability.cry_rigged
		local m_num, m_den = SMODS.get_probability_vars(card, 1, card.ability.extra.xmult_odds)
		local c_num, c_den = SMODS.get_probability_vars(card, 1, card.ability.extra.xchips_odds)
		return { vars = { r and m_den or m_num, m_den, r and c_den or c_num, c_den } }
	end,
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 4, y = 1 },
	cost = 10,
	blueprint_compat = false,
	demicoloncompat = false,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			play_sound("payasaka_markiplier_helloeverybody")
		end
	end,
}
