-- Custom draw step routines

SMODS.DrawStep {
	key = 'pta_front',
	order = 61,
	func = function(self)
		if self.config.center.pta_front_pos and (self.config.center.discovered or self.bypass_discovery_center) then
			self.children.pta_front:draw_shader('dissolve', nil, nil, nil, self.children.center)
			if self.edition then
				for k, v in pairs(G.P_CENTER_POOLS.Edition) do
					if v.shader then
						if self.edition[v.key:sub(3)] then
							self.children.pta_front:draw_shader(v.shader, nil, nil, nil, self.children.center)
						end
					end
				end
			end
		end
	end,
	conditions = { vortex = false, facing = 'front' },
}

SMODS.draw_ignore_keys.pta_front = true

-- Doing this the hook way since using smods' native set_sprites BREAKS soul sprites for some reason
local set_spritesref = Card.set_sprites
function Card:set_sprites(center, front)
	set_spritesref(self, center, front)
	if center and center.pta_front_pos then
		self.children.pta_front = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[center.atlas or center.set],
			center.pta_front_pos
		)
		self.children.pta_front.role.draw_major = self
		self.children.pta_front.states.hover.can = false
		self.children.pta_front.states.click.can = false
	end
end
