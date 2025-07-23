-- King Halo
SMODS.Joker {
	name = "pta-King Halo",
	key = "kinghalo",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 1, y = 7 },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = true,
	config = { extra = { repetitions = 2 } },
	pools = { ["Joker"] = true, ["Friend"] = true },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == "unscored" then
			return {
				repetitions = card.ability.extra.repetitions
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions } }
	end
}
