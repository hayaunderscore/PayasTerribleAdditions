-- Four Byte Burger
SMODS.Joker {
	name = "Four-Byte Burger",
	key = "4byte",
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 6, y = 9 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
	config = { used_jokers = { ["j_payasaka_4byte"] = true }, extra = { x_mult = 1, x_gain = 0.5 } },
	pools = {["Joker"] = true, ["Food"] = true},
	calculate = function(self, card, context)
		-- Purely visual
		if context.card_added and not context.blueprint_card then
			local c = context.card
			G.GAME.found_food_jokers = G.GAME.found_food_jokers or {}
			if c and c.config.center and c.config.center.pools and c.config.center.pools["Food"] and not G.GAME.found_food_jokers[c.config.center_key] then
				return {
					message = localize('k_upgrade_ex')
				}
			end
		end
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.x_mult + ((G.GAME.found_food_joker_count or 0) * card.ability.extra.x_gain)
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_gain, card.ability.extra.x_mult + ((G.GAME.found_food_joker_count or 0) * card.ability.extra.x_gain) } }
	end,
}
