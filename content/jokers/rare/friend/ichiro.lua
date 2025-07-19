-- Ichiro Ogami
SMODS.Joker {
	name = "pta-Ichiro Ogami",
	key = "ichiro",
	rarity = 3,
	atlas = "JOE_Jokers2",
	pos = { x = 3, y = 6 },
	cost = 8,
	blueprint_compat = false,
	demicoloncompat = false,
	immutable = true,
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
	add_to_deck = function(self, card, from_debuff)
		if G.shop_vouchers and #G.shop_vouchers.cards > 0 and G.shop_vouchers.cards[1].ability.set == "Voucher" then
			local old = G.shop_vouchers.cards[1].config.center
			G.shop_vouchers.cards[1]:set_ability(G.P_CENTERS["p_payasaka_voucher_normal_1"])
			G.shop_vouchers.cards[1]:set_sprites(old)
			G.shop_vouchers.cards[1].ability.old_voucher = old.key
			G.E_MANAGER:add_event(Event {
				func = function()
					G.shop_vouchers.cards[1]:set_cost()
					G.shop_vouchers.cards[1].T.w = G.shop_vouchers.cards[1].T.w * 1.27
					G.shop_vouchers.cards[1].T.h = G.shop_vouchers.cards[1].T.h * 1.27
					G.shop_vouchers.cards[1]:set_sprites(G.P_CENTERS["p_payasaka_voucher_normal_1"])
					create_shop_card_ui(G.shop_vouchers.cards[1])
					G.shop_vouchers.cards[1]:juice_up(0.7)
					return true
				end
			})
			SMODS.calculate_effect({ message = localize('k_upgrade_ex') }, card)
		end
	end,
	calculate = function(self, card, context)
		if context.starting_shop and not context.blueprint_card then
			if G.shop_vouchers and #G.shop_vouchers.cards > 0 then
				local old = G.shop_vouchers.cards[1].config.center
				G.shop_vouchers.cards[1]:set_ability(G.P_CENTERS["p_payasaka_voucher_normal_1"])
				G.shop_vouchers.cards[1]:set_sprites(old)
				G.shop_vouchers.cards[1].ability.old_voucher = old.key
				G.E_MANAGER:add_event(Event {
					func = function()
						G.shop_vouchers.cards[1]:set_cost()
						G.shop_vouchers.cards[1].T.w = G.shop_vouchers.cards[1].T.w * 1.27
						G.shop_vouchers.cards[1].T.h = G.shop_vouchers.cards[1].T.h * 1.27
						G.shop_vouchers.cards[1]:set_sprites(G.P_CENTERS["p_payasaka_voucher_normal_1"])
						create_shop_card_ui(G.shop_vouchers.cards[1])
						G.shop_vouchers.cards[1]:juice_up(0.7)
						return true
					end
				})
				SMODS.calculate_effect({ message = localize('k_upgrade_ex') }, card)
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["p_payasaka_voucher_normal_1"]
	end
}
