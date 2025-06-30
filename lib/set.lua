-- Set toggles, similar to Cryptid
PTASaka.SetToggle = SMODS.Center:extend{
	set = "PTASet",
	pos = { x = 0, y = 0 },
	config = {},
	class_prefix = "ptaset",
	pta_associated_config = "Balanced-ish",
	discovered = true,
	unlocked = true,
	required_params = {
		"key",
	},
	no_doe = true, -- Chaos/Parakmi please don't choose this LMAO
	inject = function(self, i)
		if not G.P_CENTER_POOLS[self.set] then
			G.P_CENTER_POOLS[self.set] = {}
		end
		--self.default_value = PTASaka.Mod.config[self.pta_associated_config]
		SMODS.Center.inject(self, i)
	end,
	requires_restart = false,
	loc_vars = function(self, info_queue, card)
		local colour = card.debuff and G.C.JOKER_GREY or mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
		local text = card.debuff and "currently disabled" or "currently enabled"
		if self.requires_restart_confirmation then
			colour = G.C.DARK_EDITION
			text = "requires restart"
		end
		return {
			main_end = {
				{
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes = {
						{
							n = G.UIT.C,
							config = { ref_table = card, align = "m", colour = colour, r = 0.05, padding = 0.06 },
							nodes = {
								{ n = G.UIT.T, config = { text = ' '..text..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
							}
						}
					}
				}
			}
		}
	end,
	set_card_type_badge = function(self, card, badges) end,
	pta_no_mod_badge = true,
	generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		specific_vars = specific_vars or {}
		specific_vars.debuffed = nil
		SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	end,
	in_pool = function(self, args)
		return false
	end,
	update = function(self, card, dt)
		if card.ability.set == "PTASet" then
			card.debuff = not PTASaka.Mod.config[self.pta_associated_config]
		end
	end
}

-- Ahead Jokers
PTASaka.SetToggle {
	key = 'ahead',
	atlas = "JOE_Jokers",
	pos = { x = 1, y = 7 },
	pta_associated_config = "Ahead",
	requires_restart = true,
}
-- Property Cards
PTASaka.SetToggle {
	key = 'property',
	atlas = 'JOE_Properties',
	pos = { x = 1, y = 1 },
	pta_associated_config = "Property Cards",
	requires_restart = true,
}
-- Risk Cards
PTASaka.SetToggle {
	key = 'risk',
	atlas = "JOE_Risk",
	pos = { x = 2, y = 2 },
	pta_associated_config = "Risk Cards",
	draw = function(self, card, layer)
		card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
	end,
	requires_restart = true,
}
-- Cross Mod Content
PTASaka.SetToggle {
	key = 'crossmod',
	atlas = "JOE_Jokers",
	pos = { x = 9, y = 0 },
	soul_pos = { x = 10, y = 0 },
	pta_front_pos = { x = 10, y = 1 },
	pta_associated_config = "Cross Mod Content",
	requires_restart = true,
}
-- Music
PTASaka.SetToggle {
	key = 'music',
	atlas = "JOE_Jokers",
	pos = { x = 10, y = 6 },
	pta_associated_config = "Music"
}
-- Witty Comments
PTASaka.SetToggle {
	key = 'comments',
	atlas = "JOE_Jokers",
	pos = { x = 0, y = 6 },
	soul_pos = { x = 2, y = 6 },
	pta_associated_config = "Witty Comments"
}

local start_up_values = PTASaka.deep_copy(PTASaka.Mod.config)

local cardClick = Card.click
function Card:click()
	if self.ability.set == "PTASet" then
		PTASaka.Mod.config[self.config.center.pta_associated_config] = not PTASaka.Mod.config[self.config.center.pta_associated_config]
		self.debuff = not PTASaka.Mod.config[self.config.center.pta_associated_config]
		self:juice_up(0.7)
		play_sound('tarot2')
		if self.config.center.requires_restart and start_up_values[self.config.center.pta_associated_config] ~= PTASaka.Mod.config[self.config.center.pta_associated_config] then
			self.config.center.requires_restart_confirmation = true
		elseif self.config.center.requires_restart then
			self.config.center.requires_restart_confirmation = nil
		end
	else
		cardClick(self)
	end
end