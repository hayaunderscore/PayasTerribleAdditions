SMODS.Joker {
	name = "Rainy Apartments",
	key = 'rainy',
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 5, y = 1 },
	cost = 6,
	blueprint_compat = false,
	demicoloncompat = false,
	pta_credit = {
		art = {
			credit = 'qxy',
			colour = HEX('6fbfed')
		},
	},
	calculate = function(self, card, context)
		if context.before and not context.blueprint_card then
			for i = 1, #G.play.cards do
				local _c = G.play.cards[i]
				--print("uh hi")
				if _c.ability.set == 'Default' then
					_c:set_ability(G.P_CENTERS.m_payasaka_damp)
					_c:juice_up()
				end
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_payasaka_damp
		--info_queue[#info_queue+1] = G.P_CENTERS.m_payasaka_wet
	end
}
