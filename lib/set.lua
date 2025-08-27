-- Set toggles, similar to Cryptid
---@class SetToggle: SMODS.Center
---@overload fun(self: SetToggle): SetToggle
PTASaka.SetToggle = SMODS.Center:extend {
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
	subcategory = nil,
	is_subcategory = nil,
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
		if not self.is_subcategory then
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
									{ n = G.UIT.T, config = { text = ' ' .. text .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
								}
							}
						}
					}
				}
			}
		end
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
		if card.ability.set == "PTASet" and self.unlocked and card.area ~= G.your_collection and not self.is_subcategory then
			card.debuff = not PTASaka.Mod.config[self.pta_associated_config]
		end
	end
}

-- Experimental
PTASaka.SetToggle {
	key = 'experimental',
	atlas = "JOE_Jokers2",
	pos = { x = 4, y = 6 },
	pta_associated_config = "Experimental Features",
	is_subcategory = "experimental",
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
	pta_associated_config = "Jukebox",
	is_subcategory = "music",
}
-- Witty Comments
PTASaka.SetToggle {
	key = 'comments',
	atlas = "JOE_Jokers",
	pos = { x = 0, y = 6 },
	soul_pos = { x = 2, y = 6 },
	pta_associated_config = "Witty Comments"
}
-- New Run+
PTASaka.SetToggle {
	key = 'newrunplus',
	atlas = "JOE_Jokers",
	pos = { x = 4, y = 4 },
	pta_associated_config = "New Run Plus",
	unlocked = false,
	check_for_unlock = function(self, args)
		if args.type == 'win' and G.jokers then
			for k, v in pairs(G.jokers.cards) do
				if v.config.center.mod and v.config.center.mod.id == "pta_saka" then
					return true
				end
			end
		end
		return false
	end
}
-- Oguri Cap globalization
PTASaka.SetToggle {
	key = 'fatty',
	atlas = "JOE_Jokers2",
	pos = { x = 3, y = 7 },
	pta_associated_config = "Fatty Mode",
	subcategory = "experimental",
	loc_vars = function(self, info_queue, card)
		local vars = PTASaka.SetToggle.loc_vars(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_payasaka_oguri
		return vars
	end
}
-- ??? Will be used in place for SOMETHING...
PTASaka.SetToggle {
	key = 'harikitte',
	atlas = "JOE_Jokers2",
	pos = { x = 1, y = 6 },
	soul_pos = { x = 2, y = 8 },
	pta_front_pos = { x = 1, y = 8 },
	pta_associated_config = "Support Card Animations",
	subcategory = "experimental",
}
-- Music: THROWBACK
PTASaka.SetToggle {
	key = 'prismatic_music',
	atlas = "JOE_Jokers2",
	pos = { x = 1, y = 6 },
	soul_pos = { x = 2, y = 8 },
	pta_front_pos = { x = 1, y = 8 },
	shine_front_pos = true,
	pta_associated_config = "Prismatic Music",
	subcategory = "music",
	pta_desired_track = "payasaka_music_prismatic"
}
-- Music: Main Theme (Demo Version)
PTASaka.SetToggle {
	key = 'mechanic_music',
	atlas = "JOE_Tarots",
	pos = { x = 3, y = 0 },
	pta_associated_config = "Mechanic Music",
	subcategory = "music",
	pta_desired_track = "payasaka_music_mechanic",
	draw = function(self, card, layer)
		card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
	end,
}
-- Music: balatro.mid
PTASaka.SetToggle {
	key = 'property_music',
	atlas = 'JOE_Properties',
	pos = { x = 2, y = 1 },
	pta_associated_config = "Property Music",
	subcategory = "music",
	pta_desired_track = "payasaka_music_property",
	draw = function(self, card, layer)
		card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
	end,
}

local start_up_values = PTASaka.deep_copy(PTASaka.Mod.config)

G.FUNCS.payasaka_back_music_subcategory = function(...)
	PTASaka.dummy_collection_menu = nil
	G.FUNCS[G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection']()
end

local create_UIBox_collection_subcategory = function(subcategory, title, rows)
	rows = rows or {}
	-- filter out subcategory items
	local pool = PTASaka.FH.filter(G.P_CENTER_POOLS.PTASet, function(v)
		if v and v.subcategory and v.subcategory == subcategory then
			return true
		end
		return false
	end)
	local current_row = 1
	local count = 0
	for k, v in pairs(pool) do
		if count > 5 then
			current_row = current_row + 1
			count = 0
		end
		count = count + 1
		rows[current_row] = 5
	end
	return SMODS.card_collection_UIBox(pool, rows, {
		no_materialize = true,
		hide_single_page = true,
		h_mod = 1.18,
		modify_card = function(card, center, i, j)
			if PTASaka.override_track and center.pta_desired_track and PTASaka.override_track == center.pta_desired_track then
				PTASaka.set_status(card, "payasaka_playing", true)
			end
		end,
		back_func = 'payasaka_back_music_subcategory',
		title = {
			n = G.UIT.R,
			config = { align = "cm", no_fill = true, colour = G.C.CLEAR },
			nodes = {
				{
					n = G.UIT.O,
					config = {
						object = DynaText {
							string = title,
							float = true,
							pop_in = 0,
							pop_in_rate = 4,
							silent = true,
							shadow = true,
							scale = 0.7,
							colours = { G.C.EDITION }
						}
					}
				},
			}
		},
	})
end

local cardClick = Card.click
function Card:click()
	if self.ability.set == "PTASet" and self.config.center.unlocked then
		if not self.config.center.is_subcategory then
			PTASaka.Mod.config[self.config.center.pta_associated_config] = not PTASaka.Mod.config
				[self.config.center.pta_associated_config]
			self.debuff = not PTASaka.Mod.config[self.config.center.pta_associated_config]
			self:juice_up(0.7)
			play_sound('tarot2')
			if self.config.center.requires_restart and start_up_values[self.config.center.pta_associated_config] ~= PTASaka.Mod.config[self.config.center.pta_associated_config] then
				self.config.center.requires_restart_confirmation = true
			elseif self.config.center.requires_restart then
				self.config.center.requires_restart_confirmation = nil
			end
		else
			play_sound("cardSlide1")
			G.SETTINGS.paused = true
			PTASaka.dummy_collection_menu = true
			G.FUNCS.overlay_menu {
				definition = create_UIBox_collection_subcategory(self.config.center.is_subcategory, self.config.center.pta_associated_config),
			}
		end
	else
		cardClick(self)
	end
end
