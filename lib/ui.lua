-- Various UI stuff

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
	if obj and obj.pta_no_mod_badge then return end
	cmb(obj, badges)
	if SMODS.config.no_mod_badges then return end
	local cred = obj and obj.pta_credit or nil
	if not cred then return end
	local target_badge = 0
	local base_scale = 0.9
	for i = 1, #badges do
		if badges[i].nodes[1].nodes[2].config.object.string == 'Paya Is Terrible' then
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
	local strings = { "Paya Is Terrible" }
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

local function create_credit(_key)
	local text_nodes = {}
	localize { type = 'descriptions', key = _key, set = "PTACredits", nodes = text_nodes }
	local name = localize { type = 'name_text', key = _key, set = "PTACredits" }
	return {
		n = G.UIT.C,
		config = {
			align = "cm",
			padding = 0.05,
			r = 0.12,
			colour = lighten(G.C.JOKER_GREY, 0.5),
			emboss = 0.07,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					align = "cm",
					padding = 0.07,
					r = 0.1,
					colour = G.C.BLACK,
					0.1
				},
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0.05, r = 0.1 },
						nodes = {
							{
								n = G.UIT.O,
								config = {
									object = DynaText {
										string = name,
										bump = true,
										pop_in = 0,
										pop_in_rate = 4,
										silent = true,
										shadow = true,
										scale = (0.55 - 0.004 * #name),
										colours = { G.C.UI.TEXT_LIGHT }
									}
								}
							}
						}
					},
					desc_from_rows(text_nodes),
				}
			}
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

create_dummy("virtue1", { x = 6, y = 5 }, "JOE_Jokers")
create_dummy("haya", { x = 8, y = 5 }, "JOE_Jokers")
create_dummy("phil", { x = 8, y = 4 }, "JOE_Jokers")
create_dummy("vash", { x = 2, y = 5 }, "JOE_Jokers2")

local joker_listing = {
	-- "Friend" Jokers
	{ "dd_payasaka_virtue1_dummy", "j_payasaka_suittaker",    "dd_payasaka_haya_dummy",  "j_payasaka_phil2", "dd_payasaka_vash_dummy" },
	-- Meme Jokers
	{ "j_payasaka_joyousspring",   "j_payasaka_no_retrigger", "j_payasaka_flintnsteel2", "j_payasaka_tentens",     "j_payasaka_deviouslamp" },
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

-- Modify main page
PTASaka.Mod.custom_ui = function(mod_nodes)
	PTASaka.current_mod_page_set = (PTASaka.current_mod_page_set or 0) + 1
	-- I cannot trust #.....
	local len = 0; for _, _ in pairs(joker_listing) do len = len + 1 end
	if PTASaka.current_mod_page_set > len then PTASaka.current_mod_page_set = 1 end
	local set = joker_listing[PTASaka.current_mod_page_set] or {}
	G.pta_main_jokers_list = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
		5.25 * G.CARD_W,
		0.95 * G.CARD_H,
		{ card_limit = #set, type = 'title', highlight_limit = 0, collection = true }
	)
	local silent = false
	for i, center in pairs(set) do
		G.GAME.viewed_back = Back(G.P_CENTERS.b_payasaka_prismatic)
		local card = Card(G.pta_main_jokers_list.T.x + (G.pta_main_jokers_list.T.w / 2), G.pta_main_jokers_list.T.y,
			G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[center] or PTASaka.DescriptionDummies[center],
			{
				bypass_discovery_center = true,
				bypass_discovery_ui = true,
				bypass_lock = true,
				playing_card = i,
				viewing_back = true,
				bypass_back =
					G.P_CENTERS["b_payasaka_prismatic"].pos
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
				n = G.UIT.R,
				config = { align = "cm", padding = 0.5, colour = darken(G.C.BLACK, 0.2), emboss = 0.05, r = 0.1 },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", no_fill = true },
						nodes = {
							{ n = G.UIT.O, config = { object = G.pta_main_jokers_list } },
						}
					},
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
				G.pta_features_area = CardArea(
					G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
					3.25 * G.CARD_W,
					0.95 * G.CARD_H,
					{ card_limit = 3, type = 'title', highlight_limit = 0, collection = true }
				)
				G.pta_features_area_two = CardArea(
					G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
					3.25 * G.CARD_W,
					0.95 * G.CARD_H,
					{ card_limit = 3, type = 'title', highlight_limit = 0, collection = true }
				)
				for k, v in pairs(G.P_CENTER_POOLS.PTASet) do
					local area = k <= 3 and G.pta_features_area or G.pta_features_area_two
					local card = Card(area.T.x + (area.T.w / 2), area.T.y,
						G.CARD_W, G.CARD_H, G.P_CARDS.empty, v)
					area:emplace(card)
					card:hard_set_T(area.T.x + (area.T.w / 2))
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
									config = { align = "cm", padding = 0.5, colour = darken(G.C.BLACK, 0.2), emboss = 0.05, r = 0.1 },
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
										create_credit("credit_haya"),
										create_credit("credit_ari"),
									}
								},
								{
									n = G.UIT.R,
									config = { align = "cm", padding = 0.1 },
									nodes = {
										create_credit("credit_loggers"),
										create_credit("credit_aikoyori"),
										create_credit("credit_airrice"),
										create_credit("credit_kctm"),
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
										create_credit("credit_canichat"),
										create_credit("credit_notmario"),
										create_credit("credit_missingnumber"),
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
