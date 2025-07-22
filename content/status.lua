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
		card.ARGS.send_to_shader[2] = G.TIMERS.REAL+(card.sort_id*2.432)
		local shader = 'payasaka_zzazz'
		if card.edition and card.edition.negative then
			shader = 'payasaka_zzazz_negative'
		end
		card.children.center:draw_shader(shader, nil, card.ARGS.send_to_shader)
		if card.children.pta_front then
			card.children.pta_front:draw_shader(shader, nil, card.ARGS.send_to_shader)
		end
		card.ARGS.send_to_shader[2] = G.TIMERS.REAL
		for _, v in pairs({'center', 'front', 'card_type_shader', 'edition', 'seal', 'stickers', 'payasaka_pta_front'}) do
			SMODS.DrawSteps[v].func(card, layer)
		end
	end,
	apply = function(self, card, val)
		PTASaka.remove_proxy(card)
		if card.ability[self.key] and not val then
			card.ability = card.ability[self.key]
		end
		card.ability[self.key] = val and PTASaka.deep_copy(card.ability) or nil
		if val then
			PTASaka.with_deck_effects(card, function (c)
				PTASaka.Misprintize({ val = c.ability, amt = 1, func = function (value, amount)
					return value * (pseudorandom('zzazz', 1, 1000)/100)
				end })
			end)
		end
		PTASaka.create_proxy(card)
	end
}