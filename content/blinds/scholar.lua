SMODS.Blind {
	key = "scholar",
	atlas = "JOE_Blinds",
	pos = {x = 0, y = 6},
	dollars = 5,
	mult = 2,
	boss = {min = 0, max = 1999},
	boss_colour = HEX('344362'),
	set_blind = function(self)
		local ranks = {}
		for k, v in pairs(G.playing_cards) do
			ranks[v.base.id] = v.base.value
		end
		local s = {}
		for k, v in pairs(ranks) do
			s[#s+1] = {id = k, value = v}
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
			G.GAME.blind.loc_debuff_text = ("All %ss are debuffed"):format(localize(G.GAME.payasaka_scholar[G.GAME.payasaka_scholar_rank].value, 'ranks'))
			G.GAME.blind:alert_debuff(true)
			G.GAME.blind.block_play = nil
		end
		if G.GAME.payasaka_scholar and context.hand_drawn then
			G.E_MANAGER:add_event(Event{
				func = function()
					for k, v in pairs(G.playing_cards) do
						SMODS.recalc_debuff(v)
					end
					return true
				end
			})
		end
	end,
	get_loc_debuff_text = function(self)
		return ("All %ss are debuffed"):format(localize(G.GAME.payasaka_scholar[G.GAME.payasaka_scholar_rank].value, 'ranks'))
	end,
	recalc_debuff = function(self, card, from_blind)
		local id = G.GAME.payasaka_scholar[G.GAME.payasaka_scholar_rank].id or 1
		if card:get_id() == id then
			return true
		end
		return false
	end
}