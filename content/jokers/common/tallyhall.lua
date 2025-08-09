local signed = function(a) return a >= 0 and "+" .. tostring(a) or tostring(a) end

-- Good 'n Evil
SMODS.Joker {
	name = "Good 'n Evil",
	key = "goodnevil",
	config = { extra = { current_increment = 0, mult = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { math.abs(card.ability.extra.current_increment)+1, signed(card.ability.extra.mult) } }
	end,
	rarity = 1,
	atlas = "JOE_Jokers",
	pos = { x = 3, y = 1 },
	cost = 5,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		if (context.individual and context.cardarea == G.play) or context.forcetrigger then
			if not context.blueprint_card and not context.forcetrigger then
				local lastsign = card.ability.extra.current_increment >= 0 and 1 or -1
				card.ability.extra.current_increment = (math.abs(card.ability.extra.current_increment) + 1) * -lastsign
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.current_increment
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "mult",
					scalar_value = "current_increment",
				})
			end
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_tallymult', vars = { card.ability.extra.mult } },
				message_card = context.blueprint_card or card
			}
		end
	end
}
