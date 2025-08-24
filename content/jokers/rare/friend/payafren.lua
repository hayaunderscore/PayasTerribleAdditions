-- Non-Talisman adjacent exponentials
function Card:get_pta_e_chips()
	return SMODS.multiplicative_stacking((self.ability.e_chips or 1), (not self.ability.extra_enhancement and self.ability.perma_e_chips) or 0)
end
function Card:get_pta_e_mult()
	return SMODS.multiplicative_stacking((self.ability.e_mult or 1), (not self.ability.extra_enhancement and self.ability.perma_e_mult) or 0)
end
function Card:get_pta_balance()
	return self.ability.perma_balance or 0
end

-- Only available if Talisman is present
local get_chip_e_bonus = Card.get_chip_e_bonus
if get_chip_e_bonus then
	function Card:get_chip_e_bonus()
		local ret = get_chip_e_bonus(self)
		return SMODS.multiplicative_stacking(ret, (not self.ability.extra_enhancement and self.ability.perma_e_chips) or 0)
	end
end
local get_chip_e_mult = Card.get_chip_e_mult
if get_chip_e_mult then
	function Card:get_chip_e_mult()
		local ret = get_chip_e_mult(self)
		return SMODS.multiplicative_stacking(ret, (not self.ability.extra_enhancement and self.ability.perma_e_mult) or 0)
	end
end

local perma_bonuses = {
	'perma_bonus', 'perma_mult',
	'perma_x_mult', 'perma_e_mult',
	'perma_p_dollars', 'perma_balance'
}

SMODS.Joker {
	name = "pta-PayaFriend",
	key = "paya_friend",
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 8, y = 5 },
	cost = 8,
	blueprint_compat = true,
	demicolon_compat = true,
	config = { extra = { perma_bonus = 5, perma_mult = 2, perma_x_mult = 0.1, perma_e_mult = 0.01, perma_p_dollars = 1, perma_balance = 0.02 } },
	pools = { ["Joker"] = true, ["Friend"] = true },
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
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.end_of_round then
			local bonus = pseudorandom_element(perma_bonuses, 'paya')
			if context.other_card and card.ability.extra[bonus] then
				--print(bonus)
				SMODS.scale_card(context.other_card, {
					ref_table = context.other_card.ability,
					ref_value = bonus,
					scalar_table = card.ability.extra,
					scalar_value = bonus,
				})
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		local vars = {}
		for k, v in pairs(perma_bonuses) do
			vars[#vars+1] = v == 'perma_balance' and card.ability.extra[v]*100 or card.ability.extra[v]
		end
		local desc = { key = "dd_payasaka_paya_variables", set = "DescriptionDummy" }
		desc.vars = vars
		info_queue[#info_queue+1] = desc
		return { vars = { } }
	end
}