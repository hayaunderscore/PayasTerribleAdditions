-- Odd how perma_mult isn't a thing...
local get_chip_mult = Card.get_chip_mult
function Card:get_chip_mult()
	local mult = get_chip_mult(self)
	return mult + ((not self.ability.extra_enhancement and self.ability.perma_mult) or 0)
end

-- Non-Talisman adjacent exponentials
function Card:get_pta_e_chips()
	return SMODS.multiplicative_stacking((self.ability.e_chips or 1), (not self.ability.extra_enhancement and self.ability.perma_e_chips) or 0)
end
function Card:get_pta_e_mult()
	return SMODS.multiplicative_stacking((self.ability.e_mult or 1), (not self.ability.extra_enhancement and self.ability.perma_e_mult) or 0)
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
	'perma_x_chips', 'perma_x_mult',
	'perma_e_chips', 'perma_e_mult'
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
	config = { extra = { perma_bonus = 5, perma_mult = 5, perma_x_chips = 0.1, perma_x_mult = 0.1, perma_e_chips = 0.01, perma_e_mult = 0.01 } },
	pools = { ["Joker"] = true, ["Friend"] = true },
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.end_of_round then
			local bonus = pseudorandom_element(perma_bonuses, 'paya')
			if context.other_card and card.ability.extra[bonus] then
				--print(bonus)
				context.other_card.ability[bonus] = (context.other_card.ability[bonus] or 0) + card.ability.extra[bonus]
			end
			return {
				message = localize('k_upgrade_ex')
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		local vars = {}
		for k, v in pairs(perma_bonuses) do
			vars[#vars+1] = card.ability.extra[v]
		end
		local desc = PTASaka.DescriptionDummies["dd_payasaka_paya_variables"]
		desc.vars = vars
		info_queue[#info_queue+1] = desc
		return { vars = { } }
	end
}