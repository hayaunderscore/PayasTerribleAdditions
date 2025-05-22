-- Custom draw step routines

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
				self.children.pta_front:draw_shader('negative_shine', nil, self.ARGS.send_to_shader, nil, self.children.center)
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
		if self.config.center.key == 'c_payasaka_gacha' then
			---@type Sprite
			local layer = self.children.gacha_layer
			if self:should_draw_base_shader() then
				layer:draw_shader('dissolve', nil, nil, nil, self.children.center, nil, nil, -0.15)
				layer:draw_shader('booster', nil, nil, nil, self.children.center, nil, nil, -0.15)
			end
			if self.edition then
				for k, v in pairs(G.P_CENTER_POOLS.Edition) do
					if v.shader then
						if self.edition[v.key:sub(3)] then
							layer:draw_shader(v.shader, nil, nil, nil, self.children.center, nil, nil, -0.15)
						end
					end
				end
			end
			if (self.edition and self.edition.negative) then
				layer:draw_shader('negative_shine', nil, self.ARGS.send_to_shader, nil, self.children.center, nil, nil, -0.15)
			end
		end
	end,
	conditions = { vortex = false, facing = 'front' },
}

SMODS.draw_ignore_keys.gacha_layer = true

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