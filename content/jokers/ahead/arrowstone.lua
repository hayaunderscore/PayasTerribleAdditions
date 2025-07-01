-- Arrowstone
SMODS.Joker {
	name = "Arrowstone",
	key = "arrowstone",
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	demicoloncompat = false,
	pos = { x = 0, y = 3 },
	atlas = "JOE_Jokers",
	config = { extra = { odds = 2, x_chips = 2 }, },
	pools = {["Joker"] = true, ["Meme"] = true},
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
		return { vars = { num, den, card.ability.extra.x_chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.end_of_round then
			local _c = context.other_card
			if _c and _c:is_suit('Spades') and SMODS.pseudorandom_probability(card, 'arrow_stone', 1, card.ability.extra.odds) then
				return {
					x_chips = card.ability.extra.x_chips
				}
			end
		end
	end
}