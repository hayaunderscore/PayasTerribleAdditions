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
		if (context.discard and context.other_card == card) or (context.after and card.area ~= G.hand) or (context.end_of_round) then
			self:apply(card, nil)
		end
	end,
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
}

-- Frozen
PTASaka.Status {
	key = 'frozen',
	atlas = "JOE_Enhancements",
	pos = { x = 7, y = 0 },
	badge_colour = HEX('7adfff'),
	--scale = 0.1,
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
		if (context.discard and context.other_card == card) or (context.end_of_round) then
			PTASaka.freeze_card(card, nil, true, true)
		end
	end,
	draw = function(self, card, layer)
		if (card.ability.pta_frozen or card.ability.pta_force_draw_frozen) and not card.ability.pta_hide_frozen_sprite then
			local old_mode = love.graphics.getBlendMode()
			if card.config.center_key == "m_payasaka_ice" then
				love.graphics.setBlendMode("add")
			end
			PTASaka.Status.draw(self, card, layer)
			if card.config.center_key == "m_payasaka_ice" then
				love.graphics.setBlendMode(old_mode)
			end
		end
	end,
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		art = {
			credit = 'Mr. Logan',
			colour = HEX('c1410e')
		},
	},
}

-- Make sure marked and frozen never persist
function PTASaka.Mod.reset_game_globals(start)
	for k, v in pairs(G.playing_cards or {}) do
		if v.ability.pta_frozen then
			PTASaka.set_status(v, "payasaka_frozen", nil)
		end
		if v.ability.status_payasaka_marked then
			PTASaka.set_status(v, "payasaka_marked", nil)
		end
	end
end

local draw_shader_ref = Sprite.draw_shader
function Sprite:draw_shader(_shader, _shadow_height, _send, ...)
	local _draw_major = self.role.draw_major or self
	if (_shader == 'dissolve' or _shader == 'negative') and _draw_major and _draw_major.ability and _draw_major.ability.status_payasaka_zzazz then
		_shader = _shader == 'negative' and 'payasaka_zzazz_negative' or 'payasaka_zzazz'
		_send = _send or { 0, 0 }
		_send[2] = (G.TIMERS.REAL + (self.ID * 2.432) / (self.ID * 187 / 82)) + (self.ID * .4)
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
			PTASaka.with_deck_effects(card, function(c)
				PTASaka.Misprintize({
					val = c.ability,
					amt = 1,
					func = function(value, amount)
						return value * (pseudorandom('zzazz', 1, 1000) / 100)
					end
				})
			end)
		end
		PTASaka.create_proxy(card)
	end
}

-- Awful Mood
PTASaka.Status {
	key = 'awful',
	atlas = "awfulmark",
	pos = { x = 0, y = 0 },
	badge_colour = HEX('7824c8'),
	--scale = -0.75,
	offset = { y = -6 },
	--size = { w = 2, h = 2 },
	draw = function(self, card, layer)
		--G.shared_stickers[self.key].true_scale = 0.25
		PTASaka.Status.draw(self, card, layer)
	end,
	apply = function(self, card, val)
		if val ~= card.ability[self.key] then
			PTASaka.remove_proxy(card)
			PTASaka.with_deck_effects(card, function(c)
				PTASaka.Misprintize({
					val = c.ability,
					amt = val and 0.75 or 1.5,
				})
			end)
			PTASaka.create_proxy(card)
		end
		card.ability[self.key] = val
	end,
	pta_credit = {
		art = {
			credit = 'AchiiroMako',
			colour = HEX('f4900c')
		},
	},
}

-- This isn't an actual status, so its hidden
-- Playing
SMODS.Atlas { key = "playingmark", path = "status/playing.png", px = 71, py = 95 }
PTASaka.Status {
	key = 'playing',
	atlas = "playingmark",
	pos = { x = 0, y = 0 },
	badge_colour = HEX('7824c8'),
	--scale = -0.75,
	offset = { y = -6 },
	--size = { w = 2, h = 2 },
	no_collection = true,
	in_pool = function()
		return false
	end,
	apply = function(self, card, val)
		card.ability[self.key] = val
	end
}