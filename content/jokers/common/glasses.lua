-- Sunglasses
SMODS.Joker {
	name = "pta-Sunglasses",
	key = "sunglasses",
	config = { extra = { odds = 3 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_sun
		info_queue[#info_queue+1] = G.P_CENTERS.m_glass
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
		return {
			vars = {
				localize { type = 'name_text', set = 'Tarot', key = 'c_sun' },
				num, den
			}
		}
	end,
	rarity = 1,
	atlas = "JOE_Jokers2",
	pos = { x = 6, y = 4 },
	cost = 3,
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
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card and not context.other_card.debuff and not context.end_of_round then
			if SMODS.has_enhancement(context.other_card, "m_glass")
				and SMODS.pseudorandom_probability(card, 'sung_proc', 1, card.ability.extra.odds)
				and #G.consumeables.cards < G.consumeables.config.card_limit
			then
				return {
					message = "Blinding!",
					extrafunc = function()
						SMODS.add_card { area = G.consumeables, key = "c_sun" }
					end
				}
			end
		end
		if context.forcetrigger then
			return {
				message = "Blinding!",
				extrafunc = function()
					SMODS.add_card { area = G.consumeables, key = "c_sun" }
				end
			}
		end
	end,
}
