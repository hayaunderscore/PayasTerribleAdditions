-- Apple of Universal Gravity
SMODS.Joker {
	name = "pta-sheena",
	key = "sheena",
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 8, y = 7 },
	cost = 6,
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
	blueprint_compat = true,
	demicoloncompat = true,
	config = { extra = { xmult = 1.5 } },
	calculate = function(self, card, context)
		if context.before and next(G.hand.cards) and next(context.poker_hands["Straight"]) then
			local scoring = PTASaka.FH.merge(context.scoring_hand, G.hand.cards)
			local straight = get_straight(scoring, SMODS.four_fingers(), SMODS.shortcut(), SMODS.wrap_around_straight())
			for i = 1, #straight do
				if straight[i] then
					for j = 1, #straight[i] do
						if straight[i][j] and straight[i][j].area and straight[i][j].area == G.hand then
							straight[i][j].ability.sheena_trigger = true
						end
					end
				end
			end
		end
		if context.individual and context.cardarea == G.hand and not context.end_of_round then
			if context.other_card.ability.sheena_trigger then
				return {
					x_mult = card.ability.extra.xmult
				}
			end
		end
		if context.after then
			for i = 1, #G.playing_cards do
				if G.playing_cards[i] then
					G.playing_cards[i].ability.sheena_trigger = nil
				end
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end
}
