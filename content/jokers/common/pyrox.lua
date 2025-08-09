SMODS.Joker {
	name = "Pyroxene Card",
	key = 'pyroxene',
	config = { extra = { pyrox = 1, increase = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.pyrox, card.ability.extra.increase } }
	end,
	rarity = 1,
	atlas = "JOE_Jokers",
	pos = { x = 4, y = 4 },
	cost = 3,
	blueprint_compat = true,
	demicoloncompat = true,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint_card then
			if context.other_card and context.other_card:is_suit("Spades") or context.other_card:is_suit("Clubs") then
				card.ability.extra.pyrox = card.ability.extra.pyrox + card.ability.extra.increase
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "pyrox",
					scalar_value = "increase",
				})
				return {
					message = localize('k_upgrade_ex'),
					card = card
				}
			end
		end
		if (context.end_of_round and context.game_over == false and not context.repetition) or context.forcetrigger then
			G.E_MANAGER:add_event(Event{
				trigger = 'after',
				delay = 0.2,
				func = function ()
					ease_pyrox(card.ability.extra.pyrox)
					return true
				end
			})
		end
	end
}