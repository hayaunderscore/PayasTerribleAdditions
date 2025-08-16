if PTASaka.Mod.config["Risk Cards"] then
SMODS.Joker {
	key = "patrick",
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 7, y = 4 },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = true,
	config = { extra = { x_mult = 1, x_mult_mod = 0.2, risk = 1 } },
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
	pools = { ["Joker"] = true, ["Friend"] = true },
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable and context.consumeable.ability.set == "Risk" and not context.blueprint_card then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "x_mult",
				scalar_value = "x_mult_mod",
			})
		end
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.x_mult
			}
		end
		if (G.GAME.blind_on_deck == 'Boss' and context.end_of_round and context.main_eval and not (context.game_over)) or context.forcetrigger then
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
end
