SMODS.Joker {
	key = "catcher",
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 9, y = 4 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
	config = {extra = 1},
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
		if (context.end_of_round and context.main_eval and not (context.game_over)) or context.forcetrigger then
			if #G.consumeables.cards < G.consumeables.config.card_limit then
				G.E_MANAGER:add_event(Event{
					func = function()
						local c = SMODS.add_card { set = "Consumeables", area = G.consumeables }
						card:juice_up()
						c:juice_up()
						play_sound('timpani')
						return true
					end
				})
			end
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra }
		}
	end
}
