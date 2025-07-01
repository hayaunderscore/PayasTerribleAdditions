SMODS.Joker {
	name = "pta-dooglegarb",
	key = 'EVILgarb',
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers2",
	pos = { x = 5, y = 0 },
	soul_pos = { x = 0, y = 2 },
	cost = 25,
	no_doe = true, -- :]
	demicoloncompat = false,
	pta_credit = {
		art = {
			credit = "garbimida",
			colour = HEX('e49271')
		},
	},
	calculate = function(self, card, context)
		if not context.blueprint_card then
			if context.fix_probability and G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played == 0 then
				return {
					numerator = 0
				}
			end
		end
	end
}