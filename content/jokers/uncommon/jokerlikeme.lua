SMODS.Joker {
	key = "jlm",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 3, y = 11 },
	cost = 6,
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
	config = { extra = { xmult = 2, odds = 6, odds_mod = 1, reset = 6 } },
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if SMODS.pseudorandom_probability(card, 'jlm_proc'..G.GAME.round_resets.ante, 1, card.ability.extra.odds) then
				card.ability.extra.odds = card.ability.extra.reset
				return {
					xmult = card.ability.extra.xmult,
					extra = {
						message = localize('k_reset').."!",
						message_card = card,
					}
				}
			else
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "odds",
					scalar_value = "odds_mod",
					operation = "-",
					message_key = 'a_jlm_odds'
				})
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "jlm")
		return { vars = { num, den, card.ability.extra.xmult, card.ability.extra.odds_mod } }
	end
}
