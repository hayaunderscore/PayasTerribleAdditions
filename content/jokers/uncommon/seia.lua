SMODS.Joker {
	key = 'silenced',
	-- 9.29 is in reference to Seia's birthday :)
	config = { extra = { x_mult = 1.5, neg_x_mult = 9.29 } },
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 6, y = 0 },
	soul_pos = { x = 6, y = 1 },
	pta_front_pos = { x = 10, y = 2 },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = true,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		local extra = card.ability.extra
		if (context.payasaka_debuff_individual) or (context.other_joker or context.other_consumeable) then
			if context.payasaka_debuff_individual then
				return {
					x_mult = card.edition and card.edition.negative and extra.neg_x_mult or extra.x_mult,
					message_card = context.card
				}
			end
			if (context.other_joker or context.other_consumeable) then
				local ret = {
					x_mult = card.edition and card.edition.negative and extra.neg_x_mult or extra.x_mult,
				}
				if context.other_joker then
					if not context.other_joker.debuff then return nil, false end
					return ret
				end
				if context.other_consumeable then
					if not context.other_consumeable.debuff then return nil, false end
					ret.message_card = context.other_consumeable
					ret.card = context.blueprint_card or card
					if Incantation and context.other_consumeable.ability and context.other_consumeable.ability.qty then
						for i = 1, context.other_consumeable.ability.qty do
							SMODS.calculate_individual_effect(ret, context.other_consumeable, 'x_mult', ret.x_mult,
								false)
						end
					elseif Overflow and context.other_consumeable.ability and context.other_consumeable.ability.immutable and context.other_consumeable.ability.immutable.overflow_amount then
						for i = 1, context.other_consumeable.ability.immutable.overflow_amount do
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
