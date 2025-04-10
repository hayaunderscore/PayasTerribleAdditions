--[[ WIP
-- Baronness
SMODS.Joker {
	name = "Baronness",
	key = "baronness",
	loc_txt = {
		name = "Baronness",
		text = {
			"Each {C:attention}Queen{}",
			"held in hand",
			"gives {X:mult,C:white} X#1# {} Mult",
			"Sell this card to",
			"create a random",
			"{X:inactive,C:white}Princess{} Joker",
		}
	},
	config = { extra = { x_mult = 1.5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 3, y = 0 },
	cost = 15,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and not context.after and not context.end_of_round then
			if context.other_card:get_id() == 12 then
				if context.other_card.debuff then
					return {
						message = localize('k_debuffed'),
						colour = G.C.RED,
						card = card
					}
				else
					return {
						x_mult = card.ability.extra.x_mult,
						card = card
					}
				end
			end
		end
	end
}
]]
