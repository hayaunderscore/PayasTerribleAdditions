-- Various UI stuff

--#region TheFamily tabs

PTASaka.dos_card_status = "DOS Cards"

if TheFamily then
	TheFamily.create_tab_group {
		key = 'pta',
		order = 2,
		loc_txt = {
			name = "PTA Tabs",
			description = {
				"Tabs related to the hit mod",
				"Paya's Terrible Additions"
			}
		},
		center = "c_payasaka_mechanic"
		-- TODO: Add disabling support for this
		-- can_be_disabled = true,
	}
	TheFamily.create_tab {
		key = 'pta_dos_cards',
		group_key = 'pta',
		order = 0,
		keep = true,
		type = "switch",
		loc_txt = {
			name = "DOS Cards",
			description = {
				"Toggle between showing",
				"DOS Cards or the deck"
			}
		},
		-- can_be_disabled = true,
		front_label = function(definition, card)
			return {
				text = PTASaka.dos_card_status,
			}
		end,
		center = "c_payasaka_dos_wildtwo",
		popup = function(definition, card)
			PTASaka.dos_card_status_ui = "Toggle " .. PTASaka.dos_card_status
			return {
				name = {
					{
						n = G.UIT.T,
						config = {
							ref_value = "dos_card_status_ui",
							ref_table = PTASaka,
							colour = G.C.WHITE,
							scale = 0.4,
						},
					},
				},
			}
		end,
		update = function(definition, card)
			if PTASaka.dos_card_status_update_tf then
				if PTASaka.dos_card_status == "Deck" then
					card.area:add_to_highlighted(card)
				else
					card.area:remove_from_highlighted(card)
				end
				PTASaka.dos_card_status_update_tf = nil
			end
		end,
		click = function(definition, card)
			if G.CONTROLLER.dos_area_lock or G.CONTROLLER.lock_input or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0) or G.CONTROLLER.locked then
				return true
			end
		end,
		highlight = function(definition, card)
			if G.CONTROLLER.dos_area_lock then return end
			return G.FUNCS.payasaka_open_dos_area_real()
		end,
		unhighlight = function(definition, card)
			if G.CONTROLLER.dos_area_lock then return end
			return G.FUNCS.payasaka_open_deck()
		end,
	}
end

--#endregion

--#region Credit mod badges

-- Colours
G.C.PAYA_PURPLE = HEX('4A3570')
G.C.BADGE_TEMP_BG = SMODS.Gradient {
	key = 'badge_temp_bg',
	colours = { G.C.PAYA_PURPLE, G.C.PAYA_PURPLE },
	cycle = 1,
	created_time = 0,
	update = function(self, dt)
		if #self.colours < 2 then return end
		local timer = (G.TIMERS.REAL - self.created_time) % self.cycle
		local start_index = math.ceil(timer * #self.colours / self.cycle)
		local end_index = start_index == #self.colours and 1 or start_index + 1
		local start_colour, end_colour = self.colours[start_index], self.colours[end_index]
		local partial_timer = (timer % (self.cycle / #self.colours)) * #self.colours / self.cycle
		for i = 1, 4 do
			if self.interpolation == 'linear' then
				self[i] = start_colour[i] + partial_timer * (end_colour[i] - start_colour[i])
			elseif self.interpolation == 'trig' then
				self[i] = start_colour[i] + 0.5 * (1 - math.cos(partial_timer * math.pi)) *
					(end_colour[i] - start_colour[i])
			end
		end
	end,
}

local cmb = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
	-- Sneakily sneak this in here...
	if obj and obj.pools and obj.pools["Friend"] then
		badges[#badges + 1] = create_badge('Friend', SMODS.Gradients['payasaka_friend'])
	end
	if obj and obj.pta_no_mod_badge then return end
	cmb(obj, badges)
	if SMODS.config.no_mod_badges then return end
	local cred = obj and obj.pta_credit or nil
	if not cred then return end
	local target_badge = 0
	local base_scale = 0.9
	for i = 1, #badges do
		if badges[i].nodes[1].nodes[2].config.object.string == 'TerrAddt' then
			target_badge = i
			base_scale = badges[i].nodes[1].nodes[2].config.object.scale * 3.03
			--print("Badge found!")
			break
		end
	end
	-- Taken from Cryptid
	local function calc_scale_fac(text)
		local size = base_scale
		local font = G.LANG.font
		local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
		local calced_text_width = 0
		-- Math reproduced from DynaText:update_text
		for _, c in utf8.chars(text) do
			local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE
				+ 2.7 * 1 * G.TILESCALE * font.FONTSCALE
			calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
		end
		local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
		return scale_fac
	end
	local scales = {}
	local min_scale = 1
	local strings = { "TerrAddt" }
	local dtxt = {}
	local colours = { G.C.PAYA_PURPLE }
	for k, v in pairs(cred) do
		strings[#strings + 1] = localize { type = 'variable', key = 'pta_' .. k .. '_credit', vars = { v.credit } }[1]
		colours[#colours + 1] = v.colour or G.C.PAYA_PURPLE
		G.C.BADGE_TEMP_BG.cycle = 1.5 * (1.75 * #strings)
		--print("Localizing ... "..k)
	end
	for i = 1, #strings do
		scales[i] = calc_scale_fac(strings[i])
		min_scale = math.min(min_scale, scales[i])
		dtxt[i] = { string = strings[i] }
		--print("Calculating string length for string ... "..strings[i])
	end
	G.C.BADGE_TEMP_BG.colours = colours
	G.C.BADGE_TEMP_BG.created_time = G.TIMERS.REAL
	local badge = {
		n = G.UIT.R,
		config = { align = "cm" },
		nodes = {
			{
				n = G.UIT.R,
				config = {
					align = "cm",
					colour = G.C.BADGE_TEMP_BG,
					r = 0.1,
					minw = 2,
					minh = 0.36,
					emboss = 0.05,
					padding = 0.03 * base_scale,
				},
				nodes = {
					{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
					{
						n = G.UIT.O,
						config = {
							object = DynaText {
								string = dtxt,
								colours = { G.C.WHITE },
								silent = true,
								float = true,
								shadow = true,
								offset_y = -0.03,
								spacing = 1,
								scale = 0.33 * base_scale,
							}
						}
					},
					{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
				}
			}
		}
	}
	badges[target_badge].nodes[1].nodes[2].config.object:remove()
	badges[target_badge] = badge
end

--#endregion

--#region Credit boxes

local function create_UIBox_credit_popup(key, colour, vars)
	local blind_text = {}

	local loc_name = localize { type = 'name_text', key = key, set = "PTACredits" }
	local ability_text = {}
	localize { type = 'descriptions', key = key, set = "PTACredits", nodes = ability_text }
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", padding = 0.05, colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, emboss = 0.05 },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", emboss = 0.05, r = 0.1, minw = 2.5, padding = 0.1, colour = colour or G.C.GREY },
				nodes = {
					{ n = G.UIT.O, config = { object = DynaText({ string = loc_name, colours = { G.C.UI.TEXT_LIGHT }, shadow = true, rotate = false, spacing = 2, bump = true, scale = 0.4 }) } },
				}
			},
			{ n = G.UIT.R, config = { align = "cm" }, nodes = { desc_from_rows(ability_text) } },
		}
	}
end

local function create_credit(_key, colour, idx)
	local temp_blind = AnimatedSprite(0, 0, 1.3, 1.3, G.ANIMATION_ATLAS['payasaka_JOE_CreditChips'],
		{ x = 0, y = idx or 0 })
	temp_blind:define_draw_steps({
		{ shader = 'dissolve', shadow_height = 0.05 },
		{ shader = 'dissolve' }
	})
	temp_blind.float = true
	temp_blind.states.hover.can = true
	temp_blind.states.drag.can = true
	temp_blind.states.collide.can = true
	temp_blind.config = { force_focus = true }
	temp_blind:set_role({ major = temp_blind, role_type = 'Major', draw_major = temp_blind, xy_bond = 'Weak' })
	temp_blind.hover = function()
		if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
			if not temp_blind.hovering and temp_blind.states.visible then
				temp_blind.hovering = true
				temp_blind.hover_tilt = 3
				temp_blind:juice_up(0.05, 0.02)
				play_sound('chips1', math.random() * 0.1 + 0.55, 0.12)
				temp_blind.config.h_popup = create_UIBox_credit_popup(_key, colour, {})
				temp_blind.config.h_popup_config = { align = 'cl', offset = { x = -0.1, y = 0 }, parent = temp_blind }
				Node.hover(temp_blind)
				temp_blind.children.h_popup:set_role({ major = temp_blind.children.h_popup, role_type = 'Major', draw_major =
				temp_blind.children.h_popup, xy_bond = 'Strong' })
			end
		end
		if not temp_blind.start_T then
			temp_blind.start_T = copy_table(temp_blind.T)
		end
	end
	temp_blind.stop_drag = function()
		Node.stop_drag(temp_blind);
		temp_blind.T.x, temp_blind.T.y = temp_blind.start_T.x or temp_blind.T.x, temp_blind.start_T.y or temp_blind.T.y
	end
	temp_blind.stop_hover = function()
		temp_blind.hovering = false; Node.stop_hover(temp_blind); temp_blind.hover_tilt = 0
	end
	return {
		n = G.UIT.C,
		config = {
			align = "cm",
			padding = 0.1,
		},
		nodes = {
			{ n = G.UIT.O, config = { object = temp_blind, focus_with_object = true, role = { major = temp_blind, role_type = 'Major', draw_major = temp_blind, xy_bond = 'Weak' } } },
		}
	}
end

--#endregion

--#region Mod tabs

-- Dummy generator
local function create_dummy(name, pos, atlas)
	PTASaka.DescriptionDummy {
		key = name .. "_dummy",
		config = {},
		atlas = atlas,
		pos = pos,
		no_doe = true,
		no_collection = false,
		unlocked = true,
		discovered = true,
		pta_no_mod_badge = true,
		generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
			specific_vars = specific_vars or {}
			specific_vars.debuffed = nil
			SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		end,
		in_pool = function(self, args)
			return false
		end,
		set_card_type_badge = function(self)

		end,
		loc_vars = function(self, info_queue, card)
			return { key = "dd_payasaka_dummy", set = "DescriptionDummy" }
		end
	}
end

local joker_listing = {
	-- "Friend" Jokers
	{ "j_payasaka_azusa",        "j_payasaka_suittaker",    "j_payasaka_paya_friend",  "j_payasaka_phil2",   "j_payasaka_vash" },
	-- Meme Jokers
	{ "j_payasaka_joyousspring", "j_payasaka_no_retrigger", "j_payasaka_flintnsteel2", "j_payasaka_tentens", "j_payasaka_deviouslamp" },
	-- Ahead (if available)
	PTASaka.Mod.config["Ahead"] and
	{ "j_payasaka_printhead", "j_payasaka_arrowgraph", "j_payasaka_canichat", "j_payasaka_fanhead",
		"j_payasaka_aheadstorm" } or nil,
	-- Blue Archive Jokers
	{ "j_payasaka_arona",    "j_payasaka_silenced",   "j_payasaka_dud",         "j_payasaka_sweetrock", "j_payasaka_plana" },
	-- Food Jokers
	{ "j_payasaka_halfmoon", "j_payasaka_jellybeans", "j_payasaka_4byte",       "j_payasaka_dango",     "j_payasaka_btryacidspaghet" },
	-- Ari Jokers (that is, Jokers suggested by Ari)
	{ "j_payasaka_smoker",   "j_payasaka_idk",        "j_payasaka_maxheadroom", "j_payasaka_sheena",    "j_payasaka_upgraded" },
	-- Kart/RR Related Jokers (+ winton)
	{ "j_payasaka_winton",   "j_payasaka_droptarget", "j_payasaka_catcher",     "j_payasaka_jackpot",   "j_payasaka_raceasaring" },
	-- Prismatic Jokers (if available)
	PTASaka.Mod.config["Ahead"] and
	{ "j_payasaka_shinku", "j_payasaka_iroyokia", "j_payasaka_paya", "j_payasaka_EVILgarb",
		"j_payasaka_irisu" } or nil,
}

local set_names = {
	"Friends of Paya",
	"MMMM... THE MEMES...",
	PTASaka.Mod.config["Ahead"] and "Full speed ahead!" or nil,
	"The Archive of Blue",
	"How hungry?",
	"Ari Tax Takeover",
	"Race as a Ring!",
	PTASaka.Mod.config["Ahead"] and "Exotics but not really" or nil,
}

-- Modify main page
PTASaka.Mod.custom_ui = function(mod_nodes)
	PTASaka.current_mod_page_set = (PTASaka.current_mod_page_set or 0) + 1
	-- I cannot trust #.....
	local len = 0; for _, _ in pairs(joker_listing) do len = len + 1 end
	if PTASaka.current_mod_page_set > len then PTASaka.current_mod_page_set = 1 end
	local set = joker_listing[PTASaka.current_mod_page_set] or {}
	local set_name = set_names[PTASaka.current_mod_page_set] or nil
	G.pta_main_jokers_list = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
		5.25 * G.CARD_W,
		0.95 * G.CARD_H,
		{ card_limit = #set, type = 'title', highlight_limit = 0, collection = true }
	)
	local silent = false
	for i, center in pairs(set) do
		G.GAME.viewed_back = Back(G.P_CENTERS.b_payasaka_dummy)
		local card = Card(G.pta_main_jokers_list.T.x + (G.pta_main_jokers_list.T.w / 2), G.pta_main_jokers_list.T.y,
			G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[center] or PTASaka.DescriptionDummies[center],
			{
				bypass_discovery_center = true,
				bypass_discovery_ui = true,
				bypass_lock = true,
				playing_card = i,
				viewing_back = true,
				bypass_back =
					G.P_CENTERS["b_payasaka_dummy"].pos
			})
		G.pta_main_jokers_list:emplace(card)
		card:hard_set_T(G.pta_main_jokers_list.T.x + (G.pta_main_jokers_list.T.w / 2))
		card.sprite_facing = 'back'
		card.facing = 'back'
		card:start_materialize({ G.C.RED }, silent)
		G.E_MANAGER:add_event(Event {
			delay = 0.075 * i,
			trigger = 'after',
			blocking = false,
			func = function()
				card:flip()
				card.T.r = -0.2
				card:juice_up(0.3, 0.4)
				card.states.drag.is = true
				play_sound('tarot2', (1 - 0.15) + (i - 0.999) / (#set - 0.998) * 0.3, 0.6)
				G.E_MANAGER:add_event(Event {
					delay = 0.1,
					trigger = 'after',
					blocking = false,
					func = function()
						card.states.drag.is = false
						return true
					end
				})
				return true
			end
		})
		silent = true
	end
	mod_nodes[#mod_nodes + 1] = {
		n = G.UIT.R,
		config = { minh = 0.2, padding = 0.2 }
	}
	mod_nodes[#mod_nodes + 1] = {
		n = G.UIT.R,
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm", padding = 0.5, colour = darken(G.C.BLACK, 0.2), emboss = 0.05, r = 0.1 },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", no_fill = true },
						nodes = {
							{ n = G.UIT.O, config = { object = G.pta_main_jokers_list } },
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = -0.25 },
						nodes = {
							{
								n = G.UIT.C,
								nodes = {
									{
										n = G.UIT.O,
										config = {
											object = DynaText {
												string = set_name or "???",
												float = true,
												pop_in = 1,
												pop_in_rate = 4,
												--silent = true,
												shadow = true,
												scale = 0.4,
												colours = { G.C.EDITION }
											}
										}
									}
								}
							}
						}
					}
				}
			},
		}
	}
	return mod_nodes
end

local tabs = function()
	return
	{
		{
			label = "Features",
			chosen = true,
			tab_definition_function = function()
				local len = #G.P_CENTER_POOLS.PTASet / 2
				G.pta_features_area = CardArea(
					G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
					(math.ceil(len) + 0.25) * G.CARD_W,
					0.875 * G.CARD_H,
					{ card_limit = math.ceil(len), type = 'title', highlight_limit = 0, collection = true }
				)
				G.pta_features_area_two = CardArea(
					G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
					(math.ceil(len) + 0.25) * G.CARD_W,
					0.875 * G.CARD_H,
					{ card_limit = math.ceil(len), type = 'title', highlight_limit = 0, collection = true }
				)
				for k, v in pairs(G.P_CENTER_POOLS.PTASet) do
					local area = k <= math.ceil(#G.P_CENTER_POOLS.PTASet / 2) and G.pta_features_area or
						G.pta_features_area_two
					local card = Card(area.T.x + (area.T.w / 2.5), area.T.y,
						G.CARD_W, G.CARD_H, G.P_CARDS.empty, v)
					area:emplace(card)
					G.E_MANAGER:add_event(Event {
						blockable = false,
						blocking = false,
						func = function()
							card:hard_set_T(area.T.x + (area.T.w / 2.5))
							return true
						end
					})
				end
				return {
					n = G.UIT.ROOT,
					config = {
						emboss = 0.05,
						minh = 6,
						r = 0.1,
						minw = 6,
						align = "cm",
						-- padding = 0.2,
						colour = G.C.BLACK,
					},
					nodes = {
						{
							n = G.UIT.C,
							config = { align = "cm", padding = 0.2 },
							nodes = {
								{
									n = G.UIT.R,
									config = { align = "cm", padding = 0.4, no_fill = true },
									nodes = {
										{
											n = G.UIT.R,
											config = { align = "cm", no_fill = true },
											nodes = {
												{ n = G.UIT.O, config = { object = G.pta_features_area } },
											}
										},
										{
											n = G.UIT.R,
											config = { align = "cm", no_fill = true },
											nodes = {
												{ n = G.UIT.O, config = { object = G.pta_features_area_two } },
											}
										},
									}
								},
								{
									n = G.UIT.R,
									config = { align = "cm" },
									nodes = {
										{
											n = G.UIT.C,
											nodes = {
												{
													n = G.UIT.O,
													config = {
														object = DynaText {
															string = "Specific options might require a restart",
															float = true,
															pop_in = 0,
															pop_in_rate = 99999,
															silent = true,
															shadow = true,
															scale = 0.4,
															colours = { G.C.EDITION }
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			end
		},
		{
			label = "Credits",
			chosen = true,
			tab_definition_function = function()
				return {
					n = G.UIT.ROOT,
					config = {
						emboss = 0.05,
						minh = 6,
						r = 0.1,
						minw = 10,
						align = "cm",
						--padding = 0.2,
						colour = G.C.BLACK,
					},
					nodes = {
						{
							n = G.UIT.C,
							config = { align = "tm" },
							nodes = {
								{
									n = G.UIT.R,
									config = { align = "cm", padding = 0.2 },
									nodes = {
										{
											n = G.UIT.O,
											config = {
												object = DynaText {
													string = "Credits",
													float = true,
													pop_in = 0,
													pop_in_rate = 4,
													silent = true,
													shadow = true,
													scale = 1,
													colours = { G.C.EDITION }
												}
											}
										}
									}
								},
								{
									n = G.UIT.R,
									config = { align = "cm", padding = 0.1 },
									nodes = {
										create_credit("credit_haya", HEX('644c86'), 0),
										create_credit("credit_ari", HEX('469274'), 1),
									}
								},
								{
									n = G.UIT.R,
									config = { align = "cm", padding = 0.1 },
									nodes = {
										create_credit("credit_loggers", HEX('864b1b'), 2),
										create_credit("credit_aikoyori", HEX('85a468'), 3),
										create_credit("credit_airrice", HEX('a1c5c4'), 4),
										create_credit("credit_kctm", HEX('58c8b1'), 5),
									}
								},
								{
									n = G.UIT.R,
									config = { align = "cm", padding = 0.2 },
									nodes = {
										{
											n = G.UIT.O,
											config = {
												object = DynaText {
													string = "Many thanks to",
													float = true,
													pop_in = 0,
													pop_in_rate = 4,
													silent = true,
													shadow = true,
													scale = 0.5,
													colours = { SMODS.Gradients["payasaka_prismatic_gradient"] }
												}
											}
										}
									}
								},
								{
									n = G.UIT.R,
									config = { align = "cm", padding = 0.1 },
									nodes = {
										create_credit("credit_canichat", HEX('ab8ed3'), 6),
										create_credit("credit_notmario", HEX('c2413a'), 7),
										create_credit("credit_missingnumber", HEX('9489a7'), 8),
									}
								},
							}
						}
					}
				}
			end
		}
	}
end
PTASaka.Mod.extra_tabs = tabs

--#endregion
