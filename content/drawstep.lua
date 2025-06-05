-- Custom draw step routines

-- Ghost Trick!!!!!

SMODS.DrawStep {
	key = 'payasaka_ghosttrick_layer',
	order = -999,
	func = function(self)
		if self.pta_trick_sprite then
			local _F = self.pta_trick_sprite_args
			local exptime = math.exp(-(0.8 * ((percent*2) or 1)) * G.real_dt)

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
			self.pta_trick_sprite:hard_set_T(self.T.x - (8 * (self.T.w / 71)), self.T.y - (48 * (self.T.h / 95)), self.T.w/12, self.T.h/12)
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
	func = function(self)
		if self.config.center.pta_front_pos and (self.config.center.discovered or self.bypass_discovery_center) then
			if self:should_draw_base_shader() then
				self.children.pta_front:draw_shader('dissolve', nil, nil, nil, self.children.center)
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
