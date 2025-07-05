SMODS.Blind {
	key = "scholar",
	atlas = "JOE_Blinds",
	pos = {x = 0, y = 6},
	dollars = 8,
	mult = 2,
	boss = {min = 0, max = 1999},
	boss_colour = HEX('344362'),
	set_blind = function(self)
		local ranks = {}
		for k, v in pairs(G.playing_cards) do
			ranks[v.base.id] = true
		end
		local s = {}
		for k, v in pairs(ranks) do
			s[#s+1] = k
		end
		G.GAME.payasaka_scholar = {}
		for i = #s, 1, -1 do
			G.GAME.payasaka_scholar[#G.GAME.payasaka_scholar+1] = s[i]
		end
		G.GAME.payasaka_scholar_rank = 1
	end,
	disable = function(self)
		G.GAME.payasaka_scholar = nil
	end,
	defeat = function(self)
		G.GAME.payasaka_scholar = nil
	end,
	calculate = function(self, blind, context)
		if G.GAME.payasaka_scholar and context.after then
			G.GAME.payasaka_scholar_rank = G.GAME.payasaka_scholar_rank + 1
			if G.GAME.payasaka_scholar_rank > #G.GAME.payasaka_scholar then
				G.GAME.payasaka_scholar_rank = 1
			end
		end
	end,
	recalc_debuff = function(self, card, from_blind)
		local id = G.GAME.payasaka_scholar[G.GAME.payasaka_scholar_rank] or 1
		if card:get_id() == id then
			return true
		end
		return false
	end
}