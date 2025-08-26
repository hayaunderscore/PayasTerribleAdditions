SMODS.Joker {
	key = "windysummer",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 5, y = 9 },
	cost = 8,
	blueprint_compat = false,
	demicoloncompat = false,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.press_play and #G.discard.cards > 1 and not context.blueprint_card and not context.retrigger_joker then
			draw_card(G.discard, G.play, nil, nil, nil, G.discard.cards[#G.discard.cards-1])
			return {
				message = "Drawn!"
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		local rank = "?"
		local suit = "?"
		local colours = { G.C.BLACK }
		if G.discard and #G.discard.cards > 1 then
			local c = G.discard.cards[#G.discard.cards-1]
			rank = localize(c.base.value, "ranks")
			suit = localize(c.base.suit, "suits_plural")
			colours[1] = G.C.SUITS[c.base.suit] or G.C.BLACK
		end
		return { vars = { rank, suit, colours = colours }}
	end
}
