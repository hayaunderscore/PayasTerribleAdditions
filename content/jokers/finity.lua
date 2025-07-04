local rarities = {
	[1] = "Common",
	[2] = "Uncommon",
	[3] = "Rare",
	[4] = "Legendary"
}

if not FinisherBossBlinddecksprites then FinisherBossBlinddecksprites = {} end
FinisherBossBlinddecksprites["bl_payasaka_question"] = {"payasaka_JOE_Decks", {x = 2, y = 1}}
FinisherBossBlinddecksprites["bl_payasaka_showdown_manifold_mayhem"] = {"payasaka_JOE_Decks", {x = 1, y = 2}}
FinisherBossBlinddecksprites["bl_payasaka_showdown_sweet_sleep"] = {"payasaka_JOE_Decks", {x = 2, y = 2}}

-- The Cast
SMODS.Joker {
	key = 'cast',
	atlas = "JOE_Jokers",
	pos = { x = 10, y = 9 },
	soul_pos = { x = 10, y = 8 },
	rarity = "finity_showdown",
	cost = 10,
	blueprint_compat = true,
	demicoloncompat = true,
	dependencies = 'finity',
	config = { cast_kept_values = { } },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		local rets = {}
		if context.setting_blind then
			if not G["payasaka_cast_jokers_"..tostring(card.sort_id)] then
				PTASaka.create_storage_area("payasaka_cast_jokers_"..tostring(card.sort_id), 2, card.sort_id)
				-- Save this sort_id to the save
				G.GAME.payasaka_cast_joker_ids[card.sort_id] = true
			end
			local jokers = {}
			for k, center in pairs(G.P_CENTER_POOLS["Joker"]) do
				local rarity = type(center.rarity) == "number" and rarities[center.rarity] or center.rarity
				if center.unlocked == true and center.discovered
					and center.key ~= self.key
					and (rarity ~= nil and rarity == "finity_showdown")
					and (not Cryptid or not Cryptid.no(center, "doe", k))
					and not (G.GAME.banned_keys[center.key] or (G.GAME.cry_banished_keys and G.GAME.cry_banished_keys[center.key])) then
					jokers[#jokers+1] = center
				end
			end
			---@type CardArea
			local area = G["payasaka_cast_jokers_"..tostring(card.sort_id)]
			for i = 1, 2 do
				local joker = table.remove(jokers, pseudorandom('lab01', 1, #jokers))
				local jokeur = SMODS.add_card { area = area, key = joker.key }
				if card.ability.cast_kept_values[joker.key] then
					jokeur.ability = copy_table(card.ability.cast_kept_values[joker.key])
					jokeur.ability.cast_id = card.sort_id
					card.ability.cast_kept_values[joker.key] = nil
				end
			end
			rets[#rets+1] = {
				message = 'Set!'
			}
		end
		if context.ending_shop then
			rets[#rets+1] = {
				message = localize('k_reset').."!"
			}
			if G["payasaka_cast_jokers_"..tostring(card.sort_id)] then
				---@type CardArea
				local area = G["payasaka_cast_jokers_"..tostring(card.sort_id)]
				for i = #area.cards, 1, -1 do
					local c = area:remove_card(area.cards[i])
					if c then
						card.ability.cast_kept_values[c.config.center.key] = copy_table(c.ability)
					end
					if c then c:remove() end
				end
			end
		end
		if G["payasaka_cast_jokers_"..tostring(card.sort_id)] then
			---@type CardArea
			local area = G["payasaka_cast_jokers_"..tostring(card.sort_id)]
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
		local area = G["payasaka_cast_jokers_"..tostring(card.sort_id)] or nil
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
			local area = G["payasaka_cast_jokers_"..tostring(card.sort_id)] or nil
			if area then area:remove() end
			-- There is no need to save this anymore
			G.GAME.payasaka_cast_joker_ids[card.sort_id] = nil
		end
	end
}

-- Manifold Mayhem
SMODS.Joker {
	key = 'manifold_mayhem',
	atlas = "JOE_Jokers2",
	pos = { x = 3, y = 2 },
	soul_pos = { x = 3, y = 3 },
	rarity = "finity_showdown",
	cost = 10,
	blueprint_compat = true,
	demicoloncompat = true,
	dependencies = 'finity',
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	config = { extra = { max = 50 } },
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			local mult = G and G.GAME and math.floor(((G.GAME.payasaka_small_blind_surplus or 2) * (G.GAME.payasaka_big_blind_surplus or 2))) or 4
			if not Cryptid and mult > 50 then mult = 50 end
			return {
				x_mult = mult
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		if not Cryptid then
			local dd = PTASaka.DescriptionDummies["dd_payasaka_manifold_limiter"]
			dd.vars = { card.ability.extra.max }
			info_queue[#info_queue+1] = dd
		end
		local mult = G and G.GAME and math.floor(((G.GAME.payasaka_small_blind_surplus or 2) * (G.GAME.payasaka_big_blind_surplus or 2))) or 4
		if not Cryptid and mult > 50 then mult = 50 end
		return {
			vars = { mult }
		}
	end
}

-- Sweet Sleep
SMODS.Joker {
	key = 'sweet_sleep',
	atlas = "JOE_Jokers2",
	pos = { x = 4, y = 2 },
	soul_pos = { x = 4, y = 3 },
	rarity = "finity_showdown",
	cost = 10,
	blueprint_compat = true,
	demicoloncompat = true,
	dependencies = 'finity',
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	config = { extra = { xchips = 2, xchip_mod = 0.1 }},
	calculate = function(self, card, context)
		if (G.GAME.current_round.hands_played == 0 and context.individual and not context.end_of_round and context.cardarea == G.play) or context.forcetrigger then
			return {
				x_chips = card.ability.extra.xchips
			}
		end
		if context.discard and not context.blueprint then
			G.E_MANAGER:add_event(Event{
				func = function()
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Upgrade!", instant = true })
					return true
				end
			})
			card.ability.extra.xchips = card.ability.extra.xchips + card.ability.extra.xchip_mod
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xchips, card.ability.extra.xchip_mod }
		}
	end
}