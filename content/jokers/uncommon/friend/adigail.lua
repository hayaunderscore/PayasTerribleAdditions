-- Adigail
SMODS.Joker {
	name = "pta-Adigail",
	key = "adigail",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 6, y = 5 },
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
	pools = { ["Joker"] = true, ["Friend"] = true },
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			local chip_tally, mult_tally = 0, 0
			for _, v in ipairs(G.handlist) do
				if G.GAME.hands[v].visible then
					chip_tally, mult_tally = chip_tally + G.GAME.hands[v].chips, mult_tally + G.GAME.hands[v].mult
				end
			end
			return {
				chips = chip_tally / 4.5,
				mult = mult_tally / 4.5
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		local chip_tally, mult_tally = 0, 0
		for _, v in ipairs(G.handlist) do
			if G.GAME and G.GAME.hands and G.GAME.hands[v].visible then
				chip_tally, mult_tally = chip_tally + G.GAME.hands[v].chips, mult_tally + G.GAME.hands[v].mult
			end
		end
		return { vars = { number_format(chip_tally / 4.5), number_format(mult_tally / 4.5) } }
	end
}
