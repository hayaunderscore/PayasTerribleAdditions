-- Haru Urara
SMODS.Joker {
	name = "pta-Haru Urara",
	key = "haru",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 2, y = 7 },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = true,
	pools = { ["Joker"] = true, ["Friend"] = true },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand then
			context.payasaka_haru_urara_old_area = G.hand
			context.cardarea = "unscored"
			SMODS.score_card(context.other_card, context)
			context.cardarea = G.hand
			context.payasaka_haru_urara_old_area = nil
		end
	end,
}
