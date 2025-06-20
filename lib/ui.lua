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
		local timer = (G.TIMERS.REAL-self.created_time)%self.cycle
		local start_index = math.ceil(timer*#self.colours/self.cycle)
		local end_index = start_index == #self.colours and 1 or start_index+1
		local start_colour, end_colour = self.colours[start_index], self.colours[end_index]
		local partial_timer = (timer%(self.cycle/#self.colours))*#self.colours/self.cycle
		for i = 1, 4 do
			if self.interpolation == 'linear' then

				self[i] = start_colour[i] + partial_timer*(end_colour[i]-start_colour[i])
			elseif self.interpolation == 'trig' then
				self[i] = start_colour[i] + 0.5*(1-math.cos(partial_timer*math.pi))*(end_colour[i]-start_colour[i])
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
		strings[#strings+1] = localize{ type = 'variable', key = 'pta_'..k..'_credit', vars = { v.credit } }[1]
		colours[#colours+1] = v.colour or G.C.PAYA_PURPLE
		G.C.BADGE_TEMP_BG.cycle = 1.5*(1.75*#strings)
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
		config = {align = "cm"},
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
			r = 0.12, colour = lighten(G.C.JOKER_GREY, 0.5), emboss = 0.07,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					align = "cm", padding = 0.07, r = 0.1,
					colour = G.C.BLACK, 0.1
				},
				nodes = {
					{
						n = G.UIT.R,
						config = {align = "cm", padding = 0.05, r = 0.1},
						nodes = {
							{
								n = G.UIT.O,
								config = {
									object = DynaText{
										string = name,
										bump = true,
										pop_in = 0,
										pop_in_rate = 4,
										silent = true,
										shadow = true,
										scale = (0.55 - 0.004*#name),
										colours = {G.C.UI.TEXT_LIGHT}
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

local tabs = function() return
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
													object = DynaText{
														string = "Specific options might require a restart",
														float = true,
														pop_in = 0,
														pop_in_rate = 99999,
														silent = true,
														shadow = true,
														scale = 0.4,
														colours = {G.C.EDITION}
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
											object = DynaText{
												string = "Credits",
												float = true,
												pop_in = 0,
												pop_in_rate = 4,
												silent = true,
												shadow = true,
												scale = 1,
												colours = {G.C.EDITION}
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
											object = DynaText{
												string = "Many thanks to",
												float = true,
												pop_in = 0,
												pop_in_rate = 4,
												silent = true,
												shadow = true,
												scale = 0.5,
												colours = {SMODS.Gradients["payasaka_prismatic_gradient"]}
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