SMODS.Joker {
	name = "MFKAA Joker",
	key = 's16',
	config = { extra = { mult = 4 } },
	rarity = 1,
	atlas = "JOE_Jokers",
	pos = { x = 1, y = 9 },
	cost = 3,
	blueprint_compat = true,
	demicoloncompat = true,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			return {
				mult = card.ability.extra.mult
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.mult }
		}
	end
}