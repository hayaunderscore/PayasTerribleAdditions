-- Silenced
SMODS.Joker {
	key = "silenced",
	rarity = 2,
	atlas = "BaseJokers",
	pos = { x = 3, y = 0 },
	soul_pos = { x = 3, y = 1 },
	pta_front_pos = { x = 4, y = 1 },
	cost = 6,
	blueprint_compat = true,
	config = { extra = { xmult = 1.5, neg_xmult = 9.29 } },
	calculate = function(self, card, context)
		local mult = card.edition and card.edition.negative and card.ability.extra.neg_xmult or card.ability.extra.xmult
		if context.pta_individual_debuffed and not context.end_of_round then
			return {
				x_mult = mult,
				message_card = context.card
			}
		end
		if context.other_joker or context.other_consumeable then
			local target = context.other_joker or context.other_consumeable
			local ret = {
				x_mult = mult,
				message_card = target
			}
			if target.debuff then
				if Overflow and target.ability and target.ability.immutable and target.ability.immutable.overflow_amount then
					for _ = 1, target.ability.immutable.overflow_amount do
						SMODS.calculate_effect(ret, target)
					end
					return
				end
				return ret
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.edition and card.edition.negative and card.ability.extra.neg_xmult or card.ability.extra.xmult }
		}
	end
}
