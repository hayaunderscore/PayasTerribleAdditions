-- Custom draw step routines

-- Ghost Trick!!!!!

SMODS.DrawStep {
	key = 'payasaka_ghosttrick_layer',
	order = -999,
	func = function(self)
		if self.pta_trick_sprite then
			local _F = self.pta_trick_sprite_args
			local exptime = math.exp(-(0.8 * (((percent or 1) * 2) or 1)) * G.real_dt)

			if self.pta_tricked then
				_F.intensity = 8
			else
				_F.intensity = -8
			end

			_F.timer = _F.timer + G.real_dt * (1 + _F.intensity * 0.2)
			if _F.intensity_vel < 0 then _F.intensity_vel = _F.intensity_vel * (1 - 10 * G.real_dt) end
			_F.intensity_vel = (1 - exptime) * (_F.intensity - _F.real_intensity) * G.real_dt * 25 +
				exptime * _F.intensity_vel
			_F.real_intensity = math.max(0, _F.real_intensity + _F.intensity_vel)
			_F.change = (_F.change or 0) * (1 - 4. * G.real_dt) +
				(4. * G.real_dt) * (_F.real_intensity < _F.intensity - 0.0 and 1 or 0) * _F.real_intensity
			if _F.real_intensity < 0 then
				self.pta_trick_sprite:remove()
				self.pta_trick_sprite = nil
				return
			end
			self.pta_trick_sprite:hard_set_T(self.T.x - (8 * (self.T.w / 71)), self.T.y - (48 * (self.T.h / 95)),
				self.T.w / 12, self.T.h / 12)
			self.pta_trick_sprite.VT.scale = self.VT.scale
			self.pta_trick_sprite:draw(nil)
		end
	end,
	conditions = { vortex = false, facing = 'front' },
}

-- Front sprite, for Arona, Plana and Silenced
SMODS.DrawStep {
	key = 'pta_front',
	order = 61,
	func = function(self, layer)
		if self.config.center.pta_front_pos and (self.config.center.discovered or self.bypass_discovery_center) then
			if self:should_draw_base_shader() then
				self.children.pta_front:draw_shader('dissolve', nil, nil, nil, self.children.center)
				if self.config.center.shine_front_pos then
					self.children.pta_front:draw_shader('booster', nil, self.ARGS.send_to_shader, nil,
						self.children.center)
				end
			end
			if self.edition then
				for k, v in pairs(G.P_CENTER_POOLS.Edition) do
					if v.shader then
						if self.edition[v.key:sub(3)] then
							self.children.pta_front:draw_shader(v.shader, nil, nil, nil, self.children.center)
						end
					end
				end
			end
			if (self.edition and self.edition.negative) then
				self.children.pta_front:draw_shader('negative_shine', nil, self.ARGS.send_to_shader, nil,
					self.children.center)
			end
			if SMODS.DrawSteps['stickers'] then
				SMODS.DrawSteps['stickers'].func(self, layer)
			end
		end
	end,
	conditions = { vortex = false, facing = 'front' },
}

SMODS.draw_ignore_keys.pta_front = true

-- Additional layer for Gacha spectral
SMODS.DrawStep {
	key = 'gacha_layer',
	order = 62,
	func = function(self)
		if self.config.center.key == 'c_payasaka_gacha' and (self.config.center.discovered or self.bypass_discovery_center) then
			---@type Sprite
			local layer = self.children.gacha_layer
			if self:should_draw_base_shader() then
				layer:draw_shader('dissolve', nil, nil, nil, self.children.center, nil, nil, (-6) * (self.T.w / 71))
				layer:draw_shader('booster', nil, nil, nil, self.children.center, nil, nil, (-6) * (self.T.w / 71))
			end
			if self.edition then
				for k, v in pairs(G.P_CENTER_POOLS.Edition) do
					if v.shader then
						if self.edition[v.key:sub(3)] then
							layer:draw_shader(v.shader, nil, nil, nil, self.children.center, nil, nil, (-6) *
								(self.T.w / 71))
						end
					end
				end
			end
			if (self.edition and self.edition.negative) then
				layer:draw_shader('negative_shine', nil, self.ARGS.send_to_shader, nil, self.children.center, nil, nil,
					(-6) * (self.T.w / 71))
			end
		end
	end,
	conditions = { vortex = false, facing = 'front' },
}

SMODS.draw_ignore_keys.gacha_layer = true

-- Additional layer for Gacha spectral
SMODS.DrawStep {
	key = 'property_houses',
	order = 63,
	func = function(self)
		if self.ability.set == "Property" and (self.config.center.discovered or self.bypass_discovery_center) then
			--self.children.center:draw_shader('booster', nil, self.ARGS.send_to_shader)
			---@type Sprite
			local layer = self.children.property_houses
			layer:set_sprite_pos({ x = math.min((self.ability.house_status or 0), 5), y = 2 })
			layer:draw_shader('dissolve', 0, nil, nil, self.children.center, nil, nil, nil, nil, nil, 0.6)
			layer:draw_shader('dissolve', nil, nil, nil, self.children.center)
			layer:draw_shader('booster', nil, self.ARGS.send_to_shader, nil, self.children.center)
			if self.edition then
				for k, v in pairs(G.P_CENTER_POOLS.Edition) do
					if v.shader then
						if self.edition[v.key:sub(3)] then
							layer:draw_shader(v.shader, nil, nil, nil, self.children.center)
						end
					end
				end
			end
			if (self.edition and self.edition.negative) then
				layer:draw_shader('negative_shine', nil, self.ARGS.send_to_shader, nil, self.children.center)
			end
		end
	end,
	conditions = { vortex = false, facing = 'front' },
}

SMODS.draw_ignore_keys.property_houses = true

-- Draw wild card use butan
SMODS.DrawStep {
	key = 'wild_use_button',
	order = -11,
	func = function(self)
		if self.children.wild_use_button and self.highlighted then
			self.children.wild_use_button:draw()
		end
	end,
	conditions = { vortex = false },
}

-- Highlighted play
SMODS.DrawStep {
	key = 'john_mark',
	order = 1000,
	func = function(self)
		if self.ability.john_madden_marked then
			---@type Sprite
			local layer = self.children.john_mark
			if not layer then
				layer = Sprite(
					self.T.x,
					self.T.y,
					self.T.w,
					self.T.h,
					G.ASSET_ATLAS["payasaka_JOE_Jokers2"],
					{ x = 2, y = 2 }
				)
				layer.role.draw_major = self
				layer.states.hover.can = false
				layer.states.click.can = false
				self.children.john_mark = layer
			end
			layer:draw_shader("dissolve", 0, nil, nil, self.children.center, nil, nil, nil, nil, nil, 0.6)
			layer:draw_shader("dissolve", nil, nil, nil, self.children.center, nil)
		end
	end,
	conditions = { vortex = false, facing = 'front' },
}

-- The Sharp's mark
SMODS.DrawStep {
	key = 'today_is_friday_in_california',
	order = 1001,
	func = function(self)
		if self.ability.the_sharp_marked then
			---@type Sprite
			local layer = self.children.today_is_friday_in_california
			if not layer then
				layer = Sprite(
					self.T.x,
					self.T.y,
					self.T.w,
					self.T.h,
					G.ASSET_ATLAS["payasaka_sharpmark"],
					{ x = 0, y = 0 }
				)
				layer.scale.x = layer.scale.x * (97/71)
				layer.scale.y = layer.scale.y * (97/95)
				layer.role.draw_major = self
				layer.states.hover.can = false
				layer.states.click.can = false
				self.children.today_is_friday_in_california = layer
			end
			local scale_mod = -0.05 + 0.05 * math.sin(1.8 * G.TIMERS.REAL)
			local rotate_mod = 0.03 * math.sin(1.219 * G.TIMERS.REAL)
			layer:draw_shader("dissolve", 0, nil, nil, self.children.center, scale_mod, rotate_mod, (-14) * (self.T.w / 71), -(self.T.h / 95), nil, 0.6)
			layer:draw_shader("dissolve", nil, nil, nil, self.children.center, scale_mod, rotate_mod, (-14) * (self.T.w / 71), -(self.T.h / 95))
		end
	end,
	conditions = { vortex = false, facing = 'front' },
}

SMODS.draw_ignore_keys.today_is_friday_in_california = true

-- Frozen
SMODS.DrawStep {
	key = 'olaf_goals',
	order = 1002,
	func = function(self)
		if self.ability.pta_frozen then
			---@type Sprite
			local layer = self.children.olaf_goals
			if not layer then
				layer = Sprite(
					self.T.x,
					self.T.y,
					self.T.w,
					self.T.h,
					G.ASSET_ATLAS["payasaka_JOE_Enhancements"],
					{ x = 7, y = 0 }
				)
				layer.role.draw_major = self
				layer.states.hover.can = false
				layer.states.click.can = false
				self.children.olaf_goals = layer
			end
			layer:draw_shader("dissolve", nil, nil, nil, self.children.center, 0.1)
		end
	end,
	conditions = { vortex = false, facing = 'front' },
}

SMODS.draw_ignore_keys.olaf_goals = true
