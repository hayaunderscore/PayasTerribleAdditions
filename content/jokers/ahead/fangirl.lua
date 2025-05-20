SMODS.Joker {
	key = 'fanhead',
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	demicoloncompat = true,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 9, y = 1 },
	atlas = "JOE_Jokers",
	pools = {["Joker"] = true, ["Meme"] = true},
	config = { extra = { e_chips = 1.5 } },
	calculate = function(self, card, context)
		if context.other_joker then
			if context.other_joker:is_ahead() then
				return {
					e_chips = card.ability.extra.e_chips * PTASaka.ahead_count
				}
			end
		end
		if context.forcetrigger then
			return {
				e_chips = card.ability.extra.e_chips * PTASaka.ahead_count
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.e_chips, PTASaka.ahead_count, card.ability.extra.e_chips * PTASaka.ahead_count }
		}
	end
}