SMODS.Joker {
	key = 'toga_warrior',
	config = { extra = { chips = 200 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	unlocked = true,
	discovered = true,
	rarity = 3,
	atlas = "JOE_TOGA",
	pos = { x = 1, y = 0 },
	soul_pos = { x = 0, y = 1, draw = function(card, scale_mod, rotate_mod)
		---@type Sprite
		local soul = card.children.floating_sprite
		soul.atlas = G.ASSET_ATLAS["payasaka_JOE_TOGA_warrior_soul"]
		soul.scale = { x = 90, y = 95 }
		soul.scale_mag = math.min(soul.scale.x/soul.T.w, soul.scale.y/soul.T.h)
		soul:set_sprite_pos(card.config.center.soul_pos)
		soul:draw_shader('dissolve',0, nil, nil, card.children.center,scale_mod, rotate_mod, 16 * (card.T.w/71), 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
		soul:draw_shader('dissolve', nil, nil, nil, card.children.center, scale_mod, rotate_mod, 16 * (card.T.w/71))
	end },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
	dependencies = "TOGAPack",
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			return {
				chips = card.ability.extra.chips
			}
		end
	end
}

SMODS.Joker {
	key = 'toga_soundtracker',
	config = { extra = { stored_xmult = 1, multiplier = 0.25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.multiplier, SMODS.displaying_scoring and card.ability.extra.stored_xmult or (G.GAME.current_round.current_hand and math.max(1, G.GAME.current_round.current_hand.mult*card.ability.extra.multiplier) or 1) } }
	end,
	unlocked = true,
	discovered = true,
	rarity = 2,
	atlas = "JOE_TOGA",
	pos = { x = 0, y = 0 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
	dependencies = "TOGAPack",
	calculate = function(self, card, context)
		if context.before and not context.blueprint_card then
			card.ability.extra.stored_xmult = math.max(1, G.GAME.hands[context.scoring_name].mult * card.ability.extra.multiplier)
		end
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.stored_xmult
			}
		end
	end
}
