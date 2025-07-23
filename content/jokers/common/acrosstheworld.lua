-- Across the World
SMODS.Joker {
	name = "pta-RRReferenceNo2",
	key = "across_the_world",
	rarity = 1,
	atlas = "JOE_Jokers2",
	pos = { x = 0, y = 8 },
	cost = 8,
	blueprint_compat = false,
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
	config = { extra = { odds = 3 } },
	calculate = function(self, card, context)
		if context.starting_shop and not context.blueprint_card then
			for i = 1, #G.shop_booster.cards do
				---@type Card
				local booster = G.shop_booster.cards[i]
				---@type SMODS.Booster
				local center = booster.config.center
				if center.key:find('p_buffoon') and center.kind == 'Buffoon' and SMODS.pseudorandom_probability(card, 'rr', 1, card.ability.extra.odds) then
					local new_key = center.key:gsub('p_buffoon', 'p_payasaka_friend')
					if G.P_CENTERS[new_key] then
						booster:set_ability(G.P_CENTERS[new_key])
						booster:set_sprites(G.P_CENTERS[center.key])
						G.E_MANAGER:add_event(Event {
							func = function()
								booster:set_cost()
								booster:set_sprites(G.P_CENTERS[new_key])
								create_shop_card_ui(booster)
								booster:juice_up(0.7)
								return true
							end
						})
						SMODS.calculate_effect({ message = localize('k_upgrade_ex') }, card)
					end
				end
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
		info_queue[#info_queue+1] = G.P_CENTERS.p_buffoon_normal_1
		info_queue[#info_queue+1] = G.P_CENTERS.p_payasaka_friend_normal_1
		return { vars = { num, den } }
	end
}
