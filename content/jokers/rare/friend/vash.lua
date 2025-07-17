SMODS.calculation_keys[#SMODS.calculation_keys+1] = 'prevent_remove'

-- Vash the Stampede
SMODS.Joker {
	name = "pta-vash",
	key = "vash",
	rarity = 3,
	atlas = "JOE_Jokers2",
	pos = { x = 2, y = 5 },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = false,
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	config = { extra = { xmult = 1, chips = 0, xmult_mod = 0.25, chip_mod = 15 } },
	pools = { ["Joker"] = true, ["Friend"] = true },
	loc_vars = function (self, info_queue, card)
		return { vars = { card.ability.extra.xmult_mod, card.ability.extra.chip_mod, card.ability.extra.xmult, card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if (context.payasaka_card_removed or context.payasaka_prevent_destroy_card) and not context.blueprint_card then
			local c = context.payasaka_prevent_destroy_card or context.card
			if c then
				if PTASaka.is_food(c) then
					return nil, false
				end
				if c.ability.set == "Joker" then
					card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
				else
					card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
				end
			end
			return {
				message = "Prevented!",
				prevent_remove = true,
				delay = 0.1,
				message_card = context.payasaka_prevent_destroy_card or context.card or card,
				card = card,
				--juice_card = card,
				remove = false,
			}
		end
		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
				x_mult = card.ability.extra.xmult
			}
		end
	end
}
