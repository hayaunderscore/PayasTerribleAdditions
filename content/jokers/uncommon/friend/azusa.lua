-- idk
SMODS.Joker {
	name = "Azusa Miura",
	key = "azusa",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 5, y = 3 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
	config = { extra = { xmult = 1, xmult_gain = 0.25 } },
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
	pools = { ["Joker"] = true, ["Friend"] = true },
	calculate = function(self, card, context)
		if context.before and not context.blueprint_card then
			local seven, six, five = nil, nil, nil
			for i = 1, #context.scoring_hand do
				---@type Card
				local c = context.scoring_hand[i]
				if c:get_id() == 7 then
					seven = c
				end
				if c:get_id() == 6 then
					six = c
				end
				if c:get_id() == 5 then
					five = c
				end
			end
			if seven and six and five then
				card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "xmult",
					scalar_value = "xmult_gain",
				})
				return {
					message = localize('k_upgrade_ex')
				}
			end
		end
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.xmult
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
	end
}
