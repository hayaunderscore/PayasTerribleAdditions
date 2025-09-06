SMODS.Joker {
	name = "Ringing Joker",
	key = "raceasaring",
	config = {
		extra = { x_mult = 1.75 }
	},
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 3, y = 5 },
	soul_pos = { x = 4, y = 5 },
	cost = 25,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		if context.post_trigger and G.STATE == G.STATES.HAND_PLAYED then
			return {
				x_mult = card.ability.extra.x_mult
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end
}