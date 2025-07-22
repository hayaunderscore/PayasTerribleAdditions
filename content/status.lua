-- Marked
PTASaka.Status {
	key = 'marked',
	atlas = 'sharpmark',
	pos = { x = 0, y = 0 },
	badge_colour = HEX('ff5757'),
	size = { w = 97, h = 97 },
	offset = { x = -14, y = -1 },
	calculate = function(self, card, context)
		if context.destroy_card and context.cardarea == G.hand then
			return {
				remove = true
			}
		end
		if context.discard or (context.end_of_round and context.main_eval) then
			self:apply(card, nil)
		end
	end,
}

-- Frozen
PTASaka.Status {
	key = 'frozen',
	atlas = "JOE_Enhancements",
	pos = { x = 7, y = 0 },
	badge_colour = HEX('7adfff'),
	scale = 0.1,
	calculate = function(self, card, context)
		if context.payasaka_play_to_discard and context.other_card == card then
			if card.ability.pta_unfreeze then
				PTASaka.freeze_card(card, nil, true, true)
				return nil, false
			end
			card.ability.pta_unfreeze = true
			return {
				target = G.hand
			}
		end
		if context.discard or (context.end_of_round and context.main_eval) then
			PTASaka.freeze_card(card, nil, true, true)
		end
	end,
}

-- ZZAZZ'd
PTASaka.Status {
	key = 'zzazz',
	atlas = "JOE_Enhancements",
	pos = { x = 7, y = 0 },
	badge_colour = HEX('7adfff'),
	calculate = function(self, card, context)
		if context.payasaka_play_to_discard and context.other_card == card then
			if card.ability.pta_unfreeze then
				PTASaka.freeze_card(card, nil, true, true)
				return nil, false
			end
			card.ability.pta_unfreeze = true
			return {
				target = G.hand
			}
		end
		if context.discard or (context.end_of_round and context.main_eval) then
			PTASaka.freeze_card(card, nil, true, true)
		end
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader('payasaka_zzazz', nil, card.ARGS.send_to_shader)
		for _, v in pairs({'center', 'front', 'card_type_shader', 'edition', 'seal', 'stickers', 'payasaka_pta_front'}) do
			SMODS.DrawSteps[v].func(card, layer)
		end
	end
}