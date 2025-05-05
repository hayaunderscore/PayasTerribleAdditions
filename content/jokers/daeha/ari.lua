--[[ Ari will undergo a rework soon....
-- Ari
SMODS.Joker {
	name = "Ari",
	key = 'ari',
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers",
	pos = { x = 3, y = 6 },
	soul_pos = { x = 5, y = 6, extra = { x = 4, y = 6 } },
	cost = 25,
	no_doe = true, -- :]
	config = { extra = { xmult = 1.2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			-- Create a completely random consumable
			local pool = {}
			for k, center in pairs(G.P_CENTER_POOLS.Consumeables) do
				if not (center.hidden and center.no_doe) then
					pool[#pool + 1] = center
				end
			end
			local center = pseudorandom_element(pool, pseudoseed('ari'))
			local area = center.set == 'DOSCard' and PTASaka.dos_cardarea or G.consumeables
			SMODS.add_card { key = center.key, area = area, edition = "e_negative" }
		end
		if context.other_consumeable then
			local ret = {
				xmult = card.ability.extra.xmult
			}
			if Incantation and context.other_consumeable and context.other_consumeable.ability and context.other_consumeable.ability.qty then
				for i = 1, context.other_consumeable.ability.qty do
					SMODS.calculate_individual_effect(ret, context.other_consumeable, 'xmult', ret.xmult, false)
				end
			else
				return ret
			end
		end
	end
}
]]