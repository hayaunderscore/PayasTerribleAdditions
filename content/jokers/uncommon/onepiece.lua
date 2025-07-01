-- Sole Piece
SMODS.Joker {
	name = "pta-SolePiece",
	key = "onepiece",
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 9, y = 7 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
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
	config = { extra = { odds = 2 } },
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
		return { vars = { num, den } }
	end,
	calculate = function(self, card, context)
		if (context.payasaka_level_up_after and context.scoring_name ~= "High Card" and SMODS.pseudorandom_probability(card, 'ONEPIECE', 1, card.ability.extra.odds)) or context.forcetrigger then
			if not context.instant then
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = "One Piece!" })
			end
			SMODS.smart_level_up_hand(card, "High Card", context.instant, context.level_amount or 1)
			if not context.instant then
				return {
					message = "It's real!",
					card = card,
					message_card = card,
				}
			end
			return nil, true
		end
	end
}
