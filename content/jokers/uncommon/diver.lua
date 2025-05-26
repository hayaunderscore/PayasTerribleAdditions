SMODS.Joker {
	name = "Deep Deck Diver",
	key = "diver",
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 5, y = 8 },
	cost = 6,
	blueprint_compat = false,
	demicoloncompat = false,
	config = { extra = { cost = 2 } },
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
		if context.blueprint_card then return nil, false end
		if context.pre_discard
			and to_big(G.GAME.current_round.discards_left) <= to_big(0)
			and not (to_big(G.GAME.dollars - G.GAME.bankrupt_at) - to_big(card.ability.extra.cost or 0) < to_big(0))
		then
			ease_dollars(-card.ability.extra.cost)
			ease_discard(1)
			card.ability.extra.cost = card.ability.extra.cost * 2
			return {
				message = "Splash!"
			}
		end
		if context.end_of_round and G.GAME.blind.boss and not context.individual and context.cardarea == G.jokers then
			card.ability.extra.cost = 2
			return {
				message = localize('k_reset').."!"
			}
		end
	end,
	loc_vars = function (self, info_queue, card)
		return {
			vars = { card.ability.extra.cost }
		}
	end
}
