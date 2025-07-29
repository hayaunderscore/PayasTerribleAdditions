SMODS.Atlas {
	key = "triahead", path = "ahead_separate/triahead.png", px = 71, py = 95
}

SMODS.Joker {
	name = "Triahead",
	key = "triahead",
	rarity = "payasaka_daeha",
	atlas = "triahead",
	pos = { x = 0, y = 0 },
	soul_pos = { x = 0, y = 1 },
	cost = 25,
	blueprint_compat = true,
	demicoloncompat = true,
	eternal_compat = false,
	perishable_compat = false,
	pools = { ["Joker"] = true },
	dependencies = MoreFluff and "MoreFluff" or nil,
	config = {
		extra = {
			chips = 333,
		}
	},
	pta_credit = {
		idea = {
			credit = "notmario",
			colour = HEX('4f0704')
		},
		art = {
			credit = "notmario",
			colour = HEX('4f0704')
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.scoring_name == 'Three of a Kind' or context.forcetrigger then
			if (context.individual and (context.cardarea == G.play or context.cardarea == G.hand) and not context.end_of_round) or context.forcetrigger then
				return {
					x_chips = card.ability.extra.chips,
				}
			end
		end
	end
}
