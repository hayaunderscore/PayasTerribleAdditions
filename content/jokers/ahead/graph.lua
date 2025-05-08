SMODS.Joker {
	key = "arrowgraph",
	name = "Arrowgraph",
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	demicoloncompat = true,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 0, y = 4 },
	atlas = "JOE_Jokers",
	config = { extra = { x_chips = 0.2, f_x_chips = 1 } },
	pixel_size = { w = 71, h = 80 },
	pools = {["Joker"] = true, ["Meme"] = true},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_chips, card.ability.extra.f_x_chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_suit('Spades') then
				card.ability.extra.f_x_chips = card.ability.extra.x_chips + card.ability.extra.f_x_chips
				return {
					message = localize("k_upgrade_ex"),
					extra = {
						xchips = card.ability.extra.f_x_chips
					}
				}
			end
		end
		if context.forcetrigger then
			card.ability.extra.f_x_chips = card.ability.extra.x_chips + card.ability.extra.f_x_chips
			return {
				message = localize("k_upgrade_ex"),
				extra = {
					xchips = card.ability.extra.f_x_chips
				}
			}
		end
	end
}