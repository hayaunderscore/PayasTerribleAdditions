-- Documentation
SMODS.Joker {
	name = "pta-Documentation",
	key = "documentation",
	config = { extra = { xmult = 1.75 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	rarity = 1,
	atlas = "JOE_Jokers2",
	pos = { x = 2, y = 1 },
	cost = 3,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.xmult
			}
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.payasaka_documentation_effects = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.payasaka_documentation_effects = nil
	end
}
