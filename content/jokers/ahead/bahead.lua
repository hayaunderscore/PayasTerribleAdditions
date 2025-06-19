SMODS.Joker {
	name = "Bahead",
	key = "bahead",
	config = { extra = { x_chips = 1.5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_chips } }
	end,
	rarity = "payasaka_ahead",
	atlas = "JOE_Jokers",
	pos = { x = 2, y = 7 },
	cost = 10,
	blueprint_compat = true,
	demicoloncompat = false,
	eternal_compat = false,
	perishable_compat = false,
	pools = {["Joker"] = true, ["Meme"] = true},
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and not context.after and not context.end_of_round then
			if context.other_card:is_suit('Spades') then
				if context.other_card.debuff then
					return {
						message = localize('k_debuffed'),
						colour = G.C.RED,
						card = card
					}
				else
					return {
						x_chips = card.ability.extra.x_chips,
						card = card
					}
				end
			end
		end
	end
}