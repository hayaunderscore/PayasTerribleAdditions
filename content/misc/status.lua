-- Marked
PTASaka.Status {
	key = 'marked',
	atlas = 'sharpmark',
	pos = { x = 0, y = 0 },
	badge_colour = HEX('ff5757'),
	size = { w = 97, h = 97 },
	offset = { x = -14, y = -1 },
	calculate = function(self, card, context)
		if context.destroy_card and context.cardarea == G.hand and context.destroy_card == card then
			return {
				remove = true
			}
		end
		if (context.discard and context.other_card == card) or (context.after and card.area ~= G.hand) then
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
		if (context.discard and context.other_card == card) or (context.end_of_round and context.main_eval) then
			PTASaka.freeze_card(card, nil, true, true)
		end
	end,
}

local draw_shader_ref = Sprite.draw_shader
function Sprite:draw_shader(_shader, _shadow_height, _send, ...)
	local _draw_major = self.role.draw_major or self
	if (_shader == 'dissolve' or _shader == 'negative') and _draw_major and _draw_major.ability and _draw_major.ability.status_payasaka_zzazz then
		_shader = _shader == 'negative' and 'payasaka_zzazz_negative' or 'payasaka_zzazz'
		_send = _send or {0, 0}
		_send[2] = (G.TIMERS.REAL+(self.ID*2.432)/(self.ID*187/82))+(self.ID*.4)
	end
	draw_shader_ref(self, _shader, _shadow_height, _send, ...)
end

-- ZZAZZ'd
PTASaka.Status {
	key = 'zzazz',
	atlas = "JOE_Enhancements",
	pos = { x = 7, y = 0 },
	badge_colour = HEX('7adfff'),
	draw = function(self, card, layer) end,
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