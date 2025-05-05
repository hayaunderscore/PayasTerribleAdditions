local signed = function(a) return a >= 0 and "+" .. tostring(a) or tostring(a) end

-- Good 'n Evil
SMODS.Joker {
	name = "Good 'n Evil",
	key = "goodnevil",
	config = { extra = { current_increment = -2, mult = -1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { signed(card.ability.extra.current_increment), signed(card.ability.extra.mult) } }
	end,
	rarity = 1,
	atlas = "JOE_Jokers",
	pos = { x = 3, y = 1 },
	cost = 5,
	blueprint_compat = true,
	demicoloncompat = false,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			local lastsign = card.ability.extra.current_increment >= 0 and 1 or -1
			card.ability.extra.current_increment = (math.abs(card.ability.extra.current_increment) + 1) * -lastsign
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.current_increment
			return {
				mult_mod = card.ability.extra.mult,
				message = "& " .. signed(card.ability.extra.mult),
				message_card = context.blueprint_card or card
			}
		end
	end
}
