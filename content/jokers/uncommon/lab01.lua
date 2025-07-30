local rarities = {
	[1] = "Common",
	[2] = "Uncommon",
	[3] = "Rare",
	[4] = "Legendary"
}

SMODS.Joker {
	name = "LAB=01",
	key = "lab01",
	atlas = "JOE_Jokers",
	pos = { x = 10, y = 5 },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		local rets = {}
		if context.setting_blind then
			if not G["payasaka_lab_jokers_"..tostring(card.sort_id)] then
				PTASaka.create_storage_area("payasaka_lab_jokers_"..tostring(card.sort_id), 2, card.sort_id)
				G.GAME.payasaka_lab_joker_ids[card.sort_id] = true
			end
			local jokers = {}
			for k, center in pairs(G.P_CENTER_POOLS["Joker"]) do
				local rarity = type(center.rarity) == "number" and rarities[center.rarity] or center.rarity
				if center.unlocked == true and center.discovered
					and center.key ~= self.key
					and (rarity ~= nil and rarity == "Common" or rarity == "Uncommon")
					and (not Cryptid or not Cryptid.no(center, "doe", k))
					and not (G.GAME.banned_keys[center.key] or (G.GAME.cry_banished_keys and G.GAME.cry_banished_keys[center.key])) then
					jokers[#jokers+1] = center
				end
			end
			---@type CardArea
			local area = G["payasaka_lab_jokers_"..tostring(card.sort_id)]
			for i = 1, 2 do
				local joker = table.remove(jokers, pseudorandom('lab01', 1, #jokers))
				SMODS.add_card { area = area, key = joker.key }
			end
			rets[#rets+1] = {
				message = 'Set!'
			}
		end
		if context.end_of_round and not context.game_over and context.main_eval then
			rets[#rets+1] = {
				message = localize('k_reset').."!"
			}
			if G["payasaka_lab_jokers_"..tostring(card.sort_id)] and G["payasaka_lab_jokers_"..tostring(card.sort_id)].cards then
				---@type CardArea
				local area = G["payasaka_lab_jokers_"..tostring(card.sort_id)]
				for i = #area.cards, 1, -1 do
					local c = area:remove_card(area.cards[i])
					if c then c:remove() end
				end
			end
		end
		if G["payasaka_lab_jokers_"..tostring(card.sort_id)] and G["payasaka_lab_jokers_"..tostring(card.sort_id)].cards then
			---@type CardArea
			local area = G["payasaka_lab_jokers_"..tostring(card.sort_id)]
			for i = 1, #area.cards do
				---@type Card
				local joker = area.cards[i]
				local ret = joker:calculate_joker(context)
				if ret and type(ret) == "table" then
					--ret.message_card = card
					--ret.card = card
					rets[#rets+1] = ret
				end
			end
		end
		if next(rets) then
			return PTASaka.recursive_extra(rets, 1)
		end
		return nil, false
	end,
	loc_vars = function(self, info_queue, card)
		---@type CardArea|nil
		local area = G["payasaka_lab_jokers_"..tostring(card.sort_id)] or nil
		local joker_one = area and area.cards and area.cards[1] and localize{ type = 'name_text', set = 'Joker', key = area.cards[1].config.center.key } or "None!"
		local joker_two = area and area.cards and area.cards[2] and localize{ type = 'name_text', set = 'Joker', key = area.cards[2].config.center.key } or "None!"
		if area and area.cards and area.cards[1] then
			local loc = area.cards[1].config.center.loc_vars and area.cards[1].config.center:loc_vars(info_queue, area.cards[1]) or {}
			info_queue[#info_queue+1] = {
				set = 'Joker',
				key = area.cards[1].config.center.key,
				specific_vars = loc.vars or {},
				generate_ui = function(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
					PTASaka.generate_ui_for_info_queue(_c.key, 'Joker', desc_nodes, loc.vars or {})
				end
			}
		end
		if area and area.cards and area.cards[2] then
			local loc = area.cards[2].config.center.loc_vars and area.cards[2].config.center:loc_vars(info_queue, area.cards[2]) or {}
			info_queue[#info_queue+1] = {
				set = 'Joker',
				key = area.cards[2].config.center.key,
				specific_vars = loc.vars or {},
				generate_ui = function(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
					PTASaka.generate_ui_for_info_queue(_c.key, 'Joker', desc_nodes, loc.vars or {})
				end
			}
		end
		return {
			vars = { joker_one, joker_two }
		}
	end,
	remove_from_deck = function(self, card, from_debuff)
		if not from_debuff then
			---@type CardArea|nil
			local area = G["payasaka_lab_jokers_"..tostring(card.sort_id)] or nil
			if area then area:remove() end
			-- There is no need to save this anymore
			G.GAME.payasaka_lab_joker_ids[card.sort_id] = nil
		end
	end
}
