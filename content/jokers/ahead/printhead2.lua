SMODS.Joker {
	key = "aheadstorm",
	name = "Aheadstorm",
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	demicoloncompat = true,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 3, y = 7 },
	atlas = "JOE_Jokers",
	pools = {["Joker"] = true, ["Meme"] = true},
	loc_vars = function(self, info_queue, card)
        return {vars = {PTASaka.ahead_count or 0}}
    end,
	calculate = function(self, card, context)
		local ahead_amt = PTASaka.ahead_count or 0
		local my_pos = 0
		for i = 1, #G.jokers.cards do
			local _c = G.jokers.cards[i]
			--if _c:is_ahead() then ahead_amt = ahead_amt+1 end
			if _c == card then my_pos = i end
		end
		local times = ahead_amt
		local GET_OUT = 50
		local rets = {}
		while times > 0 do
			if G.jokers.cards[1] and G.jokers.cards[1] ~= card then
				rets[#rets+1] = SMODS.blueprint_effect(card, G.jokers.cards[1], context)
				times = times - 1
			else
				break
			end
			if times > GET_OUT then break end
		end
		if #rets > 0 then
			return PTASaka.recursive_extra(rets, 1)
		end
	end
}