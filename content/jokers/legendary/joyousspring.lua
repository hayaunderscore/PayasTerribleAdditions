SMODS.Joker {
	name = "Joyous Spring",
	key = "joyousspring",
	config = {
		extra = {
			-- amount of times the words 'joyousspring' or 'joyous spring'
			-- has been uttered in the Balatro discord
			joyous_amt = 334,
			joyous_mult = 1, -- Will change the more people utter it
		}
	},
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	cost = 25,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				x_mult = card.ability.extra.joyous_amt * card.ability.extra.joyous_mult
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.joyous_mult, card.ability.extra.joyous_amt * card.ability.extra.joyous_mult } }
	end
}