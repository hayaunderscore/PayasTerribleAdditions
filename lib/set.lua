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
		SMODS.Center.inject(self, i)
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
	pta_associated_config = "Ahead"
}
-- Property Cards
PTASaka.SetToggle {
	key = 'property',
	atlas = 'JOE_Properties',
	pos = { x = 1, y = 1 },
	pta_associated_config = "Property Cards"
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
}
-- Cross Mod Content
PTASaka.SetToggle {
	key = 'crossmod',
	atlas = "JOE_Jokers",
	pos = { x = 9, y = 0 },
	soul_pos = { x = 10, y = 0 },
	pta_front_pos = { x = 10, y = 1 },
	pta_associated_config = "Cross Mod Content",
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

local cardClick = Card.click
function Card:click()
	cardClick(self)
	if self.ability.set == "PTASet" then
		PTASaka.Mod.config[self.config.center.pta_associated_config] = not PTASaka.Mod.config[self.config.center.pta_associated_config]
		self.debuff = not PTASaka.Mod.config[self.config.center.pta_associated_config]
		self:juice_up()
		play_sound('tarot2')
	end
end