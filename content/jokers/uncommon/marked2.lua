-- Contract Killer
SMODS.Joker {
	name = "pta-ContractKiller",
	key = "contract",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 6, y = 8 },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = true,
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
	config = { extra = { dollars = 3, active = false } },
	calculate = function(self, card, context)
		if ((context.payasaka_card_removed and G.STATE ~= G.STATES.HAND_PLAYED) or context.payasaka_prevent_destroy_card) then
			local c = context.payasaka_prevent_destroy_card or context.card
			if c and (c.ability.set == "Default" or c.ability.set == "Enhanced") then
				return {
					dollars = card.ability.extra.dollars,
					card = card,
				}
			end
		end
		if context.first_hand_drawn or (context.hand_drawn and card.ability.extra.active) then
			card.ability.extra.active = false
			local c = pseudorandom_element(G.hand.cards, 'nihahaha')
			--print("hi")
			if c then
				PTASaka.set_status(c, "payasaka_marked", true)
				c:juice_up()
			end
		end
		if context.after then
			--print("active")
			card.ability.extra.active = true
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = { key = 'status_payasaka_marked', set = 'Status' }
		return { vars = { card.ability.extra.dollars } }
	end
}
