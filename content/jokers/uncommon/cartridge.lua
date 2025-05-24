SMODS.Joker {
	key = 'cartridge',
	config = { extra = { x_mult = 5, odds = 3 } },
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 7, y = 0 },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = true,
	pixel_size = { w = 71, h = 83 },
	calculate = function(self, card, context)
		local extra = card.ability.extra
		if not context.blueprint_card and context.before and pseudorandom('cartridge_debuff') < (G.GAME.probabilities.normal or 1)/extra.odds then
			card.pta_no_show_debuff = true
			card:set_debuff(true)
			card_eval_status_text(card, 'extra', nil, nil, nil, {
				message = "Dusty!",
				extrafunc = function()
					card.pta_no_show_debuff = nil
				end
			})
		end
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = extra.x_mult
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		local extra = card.ability.extra
		return {
			vars = { extra.x_mult, (G.GAME.probabilities.normal or 1), extra.odds }
		}
	end
}
