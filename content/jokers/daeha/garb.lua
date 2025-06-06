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
		if context.first_hand_drawn and G.GAME.current_round.hands_played == 0 then
			for k, prob in pairs(G.GAME.probabilities) do
				G.GAME.pta_old_prob = G.GAME.pta_old_prob or {}
				G.GAME.pta_old_prob[k] = (G.GAME.pta_old_prob[k] ~= nil and G.GAME.pta_old_prob[k]) or prob
				G.GAME.probabilities[k] = 0
			end
		end
		if context.end_of_round or context.after then
			for k, prob in pairs(G.GAME.probabilities) do
				if G.GAME.pta_old_prob[k] then
					G.GAME.probabilities[k] = G.GAME.pta_old_prob[k]
				end
				G.GAME.pta_old_prob[k] = nil
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if G.GAME.pta_old_prob and next(G.GAME.pta_old_prob) then
			for k, prob in pairs(G.GAME.probabilities) do
				if G.GAME.pta_old_prob[k] then
					G.GAME.probabilities[k] = G.GAME.pta_old_prob[k]
				end
				G.GAME.pta_old_prob[k] = nil
			end
		end
	end
}