-- Haru Urara
SMODS.Joker {
	name = "pta-Haru Urara",
	key = "haru",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 2, y = 7 },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = true,
	pools = { ["Joker"] = true, ["Friend"] = true },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	config = { extra = { chips = 0, chip_mod = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == "unscored" then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "chips",
				scalar_value = "chip_mod",
				no_message = true,
			})
			return {
				message = localize('k_upgrade_ex'),
				message_card = card,
				card = context.other_card
			}
		end
		if context.joker_main then
			return {
				chips = card.ability.extra.chips
			}
		end
		--[[ Might get reused for another Joker someday
		if context.individual and context.cardarea == G.hand then
			context.payasaka_haru_urara_old_area = G.hand
			context.cardarea = "unscored"
			SMODS.score_card(context.other_card, context)
			context.cardarea = G.hand
			context.payasaka_haru_urara_old_area = nil
		end
		]]
	end,
}
