PTASaka.headroom_whitelist = { ["max_highlighted"] = true, ["amount"] = true, ["count"] = true, ["1"] = true,
	["consumeable"] = true, ["choose"] = true, ["extra"] = true }

-- Max Headroom
SMODS.Joker {
	name = "Max Headroom",
	key = "maxheadroom",
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 2, y = 8 },
	soul_pos = { x = 3, y = 8 },
	cost = 8,
	blueprint_compat = false,
	demicoloncompat = false,
	config = { extra = { money = 1, amt = 1 } },
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
	calculate = function(self, card, context)
		if context.blueprint then return nil, true end
		if context.forcetrigger then return nil, true end
		if context.using_consumeable then
			ease_dollars(-card.ability.extra.money)
			return {
				message = localize('k_payasaka_hehe_ex')
			}
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		-- Find valid consumables
		for i = 1, #G.consumeables.cards do
			---@type Card
			local consumable = G.consumeables.cards[i]
			if not consumable.ability.consumable then goto continue end
			PTASaka.remove_proxy(consumable)
			-- Prevent the original from being misprinted TWICE
			if type(consumable.ability.consumeable) == "table" then
				consumable.ability.consumeable = copy_table(consumable.config.center.config)
			end
			-- check for values
			consumable.ability = PTASaka.MMisprintize(consumable.ability, card.ability.extra.amt, nil, nil,
				function(v, a)
					return v + a
				end, PTASaka.headroom_whitelist)
			PTASaka.create_proxy(consumable)
			::continue::
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		-- Find valid consumables
		for i = 1, #G.consumeables.cards do
			---@type Card
			local consumable = G.consumeables.cards[i]
			if not consumable.ability.consumable then goto continue end
			-- check for values
			PTASaka.remove_proxy(consumable)
			consumable.ability = PTASaka.MMisprintize(consumable.ability, card.ability.extra.amt, nil, nil,
				function(v, a)
					return v - a
				end, PTASaka.headroom_whitelist)
			PTASaka.create_proxy(consumable)
			::continue::
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.money, card.ability.extra.amt }
		}
	end
}
