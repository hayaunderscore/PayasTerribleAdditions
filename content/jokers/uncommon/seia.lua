SMODS.Joker {
	key = 'silenced',
	-- 9.29 is in reference to Seia's birthday :)
	config = { extra = { x_mult = 1.5, neg_x_mult = 9.29 } },
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 6, y = 0 },
	cost = 8,
	demicoloncompat = true,
	calculate = function(self, card, context)
		local extra = card.ability.extra
		if (context.individual and not context.end_of_round) or (context.other_joker or context.other_consumeable) then
			if context.cardarea == G.play or context.cardarea == G.hand then
				if context.other_card.debuff then
					return {
						x_mult = card.edition and card.edition.negative and extra.neg_x_mult or extra.x_mult
					}
				end
			end
			if (context.other_joker or context.other_consumeable) then
				local ret = {
					x_mult = card.edition and card.edition.negative and extra.neg_x_mult or extra.x_mult
				}
				if context.other_joker then
					if not context.other_joker.debuff then return nil, true end
					return ret
				end
				if context.other_consumeable then
					if not context.other_consumeable.debuff then return nil, true end
					if Incantation and context.other_consumeable.ability and context.other_consumeable.ability.qty then
						for i = 1, context.other_consumeable.ability.qty do
							SMODS.calculate_individual_effect(ret, context.other_consumeable, 'x_mult', ret.x_mult,
								false)
						end
					else
						return ret
					end
				end
			end
		end
		if context.forcetrigger then
			return {
				x_mult = card.edition and card.edition.negative and extra.neg_x_mult or extra.x_mult
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		local extra = card.ability.extra
		return {
			vars = { card.edition and card.edition.negative and extra.neg_x_mult or extra.x_mult }
		}
	end
}
