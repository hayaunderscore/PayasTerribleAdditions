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
	pools = { ["Joker"] = true, ["Meme"] = true },
	loc_vars = function(self, info_queue, card)
		local rets = {}
		local colour = mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
		if (card.area and (card.area == G.jokers or card.area.config.joker_parent)) then
			local ahead_amt = PTASaka.ahead_count or 0
			local real_count = 0
			local my_pos = 0
			for i = 1, #G.jokers.cards do
				local _c = G.jokers.cards[i]
				--if _c:is_ahead() then ahead_amt = ahead_amt+1 end
				if _c == card then my_pos = i end
				if (my_pos > 0 or card.area.config.joker_parent) then real_count = math.min(real_count + 1, ahead_amt) end
			end
			local times, pos = ahead_amt, 1
			while times > 0 do
				-- excludes ahead storm IF times is more than 0
				if G.jokers.cards[my_pos + pos] then
					-- Formatting for the string here....
					-- If only one joker can get copied, state that it is compatible
					-- Otherwise, use [#] or [-] to convey compatibility
					rets[#rets + 1] = G.jokers.cards[my_pos + pos].config.center.blueprint_compat and (real_count <= 3 and "compatible" or "[#]") or (real_count <= 3 and "incompatible" or "[-]")
					if G.jokers.cards[my_pos + pos].config.center.blueprint_compat then
						if colour ~= G.C.DARK_EDITION then
							colour = mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
						end
					end
					if G.jokers.cards[my_pos + pos].config.center.key == "j_payasaka_aheadstorm" then
						rets[#rets] = (real_count <= 3 and "dangerous!" or "[!]")
						if real_count <= 3 then colour = G.C.DARK_EDITION end
					end
					pos = pos + 1
					times = times - 1
				else
					break
				end
			end
		end
		if not next(rets) then
			rets[#rets+1] = "incompatible"
		end
		return {
			vars = { PTASaka.ahead_count or 0 },
			main_end = (card.area and (card.area == G.jokers or card.area.config.joker_parent)) and {
				{
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes = {
						{
							n = G.UIT.C,
							config = { ref_table = card, align = "m", colour = colour, r = 0.05, padding = 0.06 },
							nodes = {
								{ n = G.UIT.T, config = { text = ' '..table.concat(rets, ", ")..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
							}
						}
					}
				}
			} or nil
		}
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
		local pos = 1
		local rets = {}
		while times > 0 do
			-- excludes ahead storm IF times is more than 0
			if G.jokers.cards[my_pos + pos] then
				if G.jokers.cards[my_pos + pos].config.center.key ~= "j_payasaka_aheadstorm" or (G.jokers.cards[my_pos + pos].config.center.key == "j_payasaka_aheadstorm" and times == 0) then
					rets[#rets + 1] = SMODS.blueprint_effect(card, G.jokers.cards[my_pos + pos], context)
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
