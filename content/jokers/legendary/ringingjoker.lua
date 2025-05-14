SMODS.Joker {
	name = "Ringing Joker",
	key = "raceasaring",
	config = {
		extra = { add_amt = 0.2, dec_amt = 0.2, current_mult = 1 }
	},
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 3, y = 5 },
	soul_pos = { x = 4, y = 5 },
	cost = 25,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		if context.setting_blind or context.selling_card or context.buying_card or context.using_consumeable or context.open_booster or context.ending_booster then
			card.ability.extra.current_mult = card.ability.extra.current_mult + card.ability.extra.add_amt
			return {
				message = localize('k_upgrade_ex')
			}
		end
		if context.skip_blind or context.skipping_booster then
			card.ability.extra.current_mult = card.ability.extra.current_mult - card.ability.extra.dec_amt
			return {
				message = localize('k_payasaka_phil_fail')
			}
		end
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.current_mult
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.add_amt, card.ability.extra.dec_amt, card.ability.extra.current_mult } }
	end
}