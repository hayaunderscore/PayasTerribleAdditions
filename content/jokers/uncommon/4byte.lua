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
	config = { used_jokers = { ["j_payasaka_4byte"] = true }, extra = { x_mult = 1, x_gain = 0.25 } },
	pools = {["Joker"] = true, ["Food"] = true},
	calculate = function(self, card, context)
		if context.card_added and not context.blueprint_card then
			local c = context.card
			if c and PTASaka.food_jokers[c.config.center_key] and not card.ability.used_jokers[c.config.center_key] then
				card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_gain
				card.ability.used_jokers[c.config.center_key] = true
				return {
					message = localize('k_upgrade_ex')
				}
			end
		end
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.x_mult
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_gain, card.ability.extra.x_mult } }
	end,
}
