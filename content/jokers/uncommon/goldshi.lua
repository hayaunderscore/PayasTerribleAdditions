SMODS.Joker {
	name = "pta-GoldShip",
	key = "goldship",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 5, y = 5 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = false,
	--[[
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	]]
	pools = { ["Joker"] = true, ["Friend"] = true },
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			local last_card = nil
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i] == context.other_card then
					last_card = context.scoring_hand[i-1]
				end
			end
			if last_card and ids_op(last_card, "<", context.other_card:get_id()) then
				return {
					repetitions = 1,
					message = localize('k_again_ex')
				}
			end
		end
	end
}
