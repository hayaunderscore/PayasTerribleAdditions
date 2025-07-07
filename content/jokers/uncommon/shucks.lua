SMODS.Joker {
	name = "Shucks! All 8s",
	key = "sa8s",
	atlas = "JOE_Jokers2",
	pos = { x = 5, y = 6 },
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	demicoloncompat = false,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.mod_probability then
			return {
				denominator = context.denominator / 2
			}
		end
	end,
}