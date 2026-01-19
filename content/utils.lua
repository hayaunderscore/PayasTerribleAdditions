-- Various utilities and other stuff that doesnt fall as traditional content

--#region Hooks

-- set_sprite hook for pta_front
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

--#endregion

--#region Functions

--- 'Eats' a food joker.
---@param card table|Card
function PTA.eat_food_joker(card)
	G.E_MANAGER:add_event(Event({
		func = function()
			play_sound('tarot1')
			card.T.r = -0.2
			card:juice_up(0.3, 0.4)
			card.states.drag.is = true
			card.children.center.pinch.x = true
			-- This part destroys the card.
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.3,
				blockable = false,
				func = function()
					card:remove()
					return true
				end
			}))
			return true
		end
	}))
	SMODS.calculate_effect({ message = localize('k_eaten_ex') }, card)
end

--#endregion

--#region Draw Steps

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

--#endregion
