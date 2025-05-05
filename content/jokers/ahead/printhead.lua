SMODS.Joker {
	key = "printhead",
	name = "Printhead",
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	demicoloncompat = true,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 1, y = 7 },
	atlas = "JOE_Jokers",
	pools = {["Joker"] = true, ["Meme"] = true},
	calculate = function(self, card, context)
		local ahead_amt = 0
		local my_pos = 0
		for i = 1, #G.jokers.cards do
			local _c = G.jokers.cards[i]
			if _c.config.center.rarity == "payasaka_ahead" then ahead_amt = ahead_amt+1 end
			if _c == card then my_pos = i end
		end
		local times = ahead_amt
		local GET_OUT = 50
		local pos = 1
		local rets = {}
		while times > 0 do
			-- excludes ahead storm IF times is more than 0
			if G.jokers.cards[my_pos+pos] then
				if G.jokers.cards[my_pos+pos].config.center.key ~= "j_payasaka_aheadstorm" or (G.jokers.cards[my_pos+pos].config.center.key == "j_payasaka_aheadstorm" and times == 0) then
					rets[#rets+1] = SMODS.blueprint_effect(card, G.jokers.cards[my_pos+pos], context)
				end
				pos = pos + 1
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