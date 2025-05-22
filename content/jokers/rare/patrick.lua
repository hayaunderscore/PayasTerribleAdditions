SMODS.Joker {
	key = "patrick",
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 8, y = 4 },
	cost = 8,
	blueprint_compat = false,
	demicoloncompat = false,
	config = { extra = { x_mult = 1, x_mult_mod = 0.2, risk = 1 } },
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.blueprint then return nil, true end
		if context.using_consumeable and context.consumeable and context.consumeable.ability.set == "Risk" then
			card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
			return {
				message = localize('k_upgrade_ex')
			}
		end
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.x_mult
			}
		end
		if (G.GAME.blind_on_deck == 'Boss' and context.end_of_round and context.cardarea == G.jokers and not (context.game_over and context.individual and context.repetition)) or context.forcetrigger then
			for i = 1, math.min(card.ability.extra.risk, G.consumeables.config.card_limit-#G.consumeables.cards) do
				G.E_MANAGER:add_event(Event{
					trigger = 'after',
					delay = 0.2,
					func = function()
						local c = SMODS.add_card { set = "Risk", area = G.consumeables }
						card:juice_up()
						c:juice_up()
						play_sound('timpani')
						return true
					end
				})
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult_mod, card.ability.extra.risk, card.ability.extra.x_mult
			}
		}
	end
}
