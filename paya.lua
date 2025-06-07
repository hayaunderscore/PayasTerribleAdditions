-- uhhh
PTASaka = {}
PTASaka.Mod = SMODS.current_mod
local conf = PTASaka.Mod.config

local nil_sane = function(val, def) if val == nil then val = def end return val end

-- Config values
conf["Balanced-ish"] = nil_sane(conf["Balanced-ish"], false) -- currently does nothing :P
conf["Property Cards"] = nil_sane(conf["Property Cards"], true)
conf["Cross Mod Content"] = nil_sane(conf["Cross Mod Content"], true)
conf["Music"] = nil_sane(conf["Music"], true)
conf["Witty Comments"] = nil_sane(conf["Witty Comments"], true)
conf["Ahead"] = nil_sane(conf["Ahead"], true)
conf["Risk Cards"] = nil_sane(conf["Risk Cards"], true)

-- hiii
SMODS.optional_features.retrigger_joker = true
SMODS.optional_features.cardareas.deck = true

-- ATLASES --

-- Joker atlas
SMODS.Atlas { key = "JOE_Jokers", path = "jokers.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_Jokers2", path = "jokers2.png", px = 71, py = 95 }

-- Blind atlas
SMODS.Atlas { key = "JOE_Blinds", path = "blinders.png", px = 34, py = 34, atlas_table = 'ANIMATION_ATLAS', frames = 21 }

-- Tarots and Spectrals
SMODS.Atlas { key = "JOE_Tarots", path = "tarots.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_Tarots_Adjust", path = "tarots.png", px = 85, py = 95 }

-- Property atlas(es)
SMODS.Atlas { key = "JOE_Properties", path = "properties.png", px = 71, py = 95 } -- This also includes the Greed tarot!
SMODS.Atlas { key = "JOE_Boosters", path = "properties_boosters.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_DOS", path = "dos.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_Risk", path = "risk.png", px = 71, py = 95 }

-- Voucher atlas
SMODS.Atlas { key = "JOE_Vouchers", path = "vouchers.png", px = 71, py = 95 }

-- Deck atlas
SMODS.Atlas { key = "JOE_Decks", path = "backs.png", px = 71, py = 95 }

-- Enhancement atlas
SMODS.Atlas { key = "JOE_Enhancements", path = "enhancements.png", px = 71, py = 95 }

-- Tags atlas
SMODS.Atlas { key = "JOE_Tags", path = "tags.png", px = 34, py = 34 }

-- Cross mod content
SMODS.Atlas { key = "JOE_Rotarots", path = "mf/rotarots.png", px = 107, py = 107 }
SMODS.Atlas { key = "JOE_Sleeves", path = "sleeves.png", px = 73, py = 95 }
SMODS.Atlas { key = "REVO_JOE_Printers", path = "revo/printers.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_Exotic", path = "cryptid/exotics.png", px = 71, py = 95 }

-- Icon lmao
SMODS.Atlas { key = "modicon", path = "icon.png", px = 34, py = 34 }

-- Small shortcuts idk
PTASaka.Font = SMODS.Font
PTASaka.Fonts = SMODS.Fonts

-- Fonts
if PTASaka.Font then
	PTASaka.Font {
		key = "pokemon",
		path = "pokemon-font.ttf",
		render_scale = 200,
		TEXT_HEIGHT_SCALE = 0.9, 
		TEXT_OFFSET = {x=12,y=-24}, 
		FONTSCALE = 0.06,
		squish = 1, 
		DESCSCALE = 1.25
	}

	PTASaka.Font {
		key = "reversed",
		path = "11x6m.ttf",
		render_scale = 200,
		TEXT_HEIGHT_SCALE = 0.83, 
		TEXT_OFFSET = {x=10,y=0}, 
		FONTSCALE = 0.1,
		squish = 1,
		DESCSCALE = 1
	}
end

-- MAIN CODE --

-- Utilities
assert(SMODS.load_file("content/utils.lua"))()
assert(SMODS.load_file("content/drawstep.lua"))()

-- Descriptions
assert(SMODS.load_file("content/desc.lua"))()

-- Sounds
assert(SMODS.load_file("content/sounds.lua"))()

-- Blinds
PTASaka.RequireFolder("content/blinds/")

-- Editions
PTASaka.RequireFolder("content/editions/")

-- Challenges
assert(SMODS.load_file("content/challenges.lua"))()

-- Tags
assert(SMODS.load_file("content/tags.lua"))()

-- Property cards
if conf["Property Cards"] then
	assert(SMODS.load_file("content/properties.lua"))()
end

-- Load all jokers

-- Rarity definitions
assert(SMODS.load_file("content/jokers/rarity_definitions.lua"))()
-- Common
PTASaka.RequireFolder("content/jokers/common/")
-- Uncommon
PTASaka.RequireFolder("content/jokers/uncommon/")
-- Rare
PTASaka.RequireFolder("content/jokers/rare/")
-- Legendary
PTASaka.RequireFolder("content/jokers/legendary/")
if conf["Ahead"] then
	-- Ahead
	PTASaka.RequireFolder("content/jokers/ahead/")
	-- daehA
	PTASaka.RequireFolder("content/jokers/daeha/")
end

-- Tarots, spectrals and seals
assert(SMODS.load_file("content/tarots.lua"))()

assert(SMODS.load_file("content/dos.lua"))()
if conf["Risk Cards"] then
	assert(SMODS.load_file("content/risk.lua"))()
	assert(SMODS.load_file("content/rewards.lua"))()
end
assert(SMODS.load_file("content/gachapack.lua"))()

-- Vouchers
assert(SMODS.load_file("content/vouchers.lua"))()

-- Decks
assert(SMODS.load_file("content/decks.lua"))()

-- Enhancements
assert(SMODS.load_file("content/enhancements.lua"))()

-- Cross mod content: CardSleeves
assert(SMODS.load_file("content/sleeve.lua"))()

-- Cross mod content: Revo's Vault
if RevosVault and conf["Cross Mod Content"] then
assert(SMODS.load_file("content/jokers/printers.lua"))()
end

-- Cross mod content: Cryptid
if Cryptid and conf["Cross Mod Content"] then
assert(SMODS.load_file("content/jokers/exotic.lua"))()
end

-- Cross mod content: Ortalab
if Ortalab and conf["Cross Mod Content"] then
assert(SMODS.load_file("content/jokers/ortalab.lua"))()
end

-- Cross mod content: Finity
if next(SMODS.find_mod('finity')) and conf["Cross Mod Content"] then
assert(SMODS.load_file("content/jokers/finity.lua"))()
end

-- Pyroxenes
assert(SMODS.load_file("content/pyrox.lua"))()

-- Any and all hooks
assert(SMODS.load_file("content/hooks.lua"))()

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

-- This is different from the info argument in the usual create_toggle
local function create_toggle_with_description(toggle, desc)
	local text_nodes = {}
	localize { type = 'descriptions', key = desc, set = "PTAOptions", default_col = G.C.UI.TEXT_LIGHT, nodes = text_nodes }
	local final_nodes = {}
	for _, v in ipairs(text_nodes) do
		final_nodes[#final_nodes+1] = {
			n = G.UIT.R,
			config = {
				align = "cm",
				padding = 0,
			},
			nodes = v,
		}
	end
	return {
		n = G.UIT.C,
		config = {
			align = "cm",
			padding = 0.1,
		},
		nodes = {
			create_toggle(toggle),
			{
				n = G.UIT.R,
				config = {
					colour = { 0, 0, 0, 0.1 },
					r = 0.2,
					minw = 3,
					minh = 1.5,
					maxw = 3,
					maxh = 1.5,
					align = "cm",
					padding = 0.03,
				},
				nodes = final_nodes
			}
		}
	}
end

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
	update = function(self, card, dt)
		if card.ability.set == "PTASet" then
			card.debuff = not conf[self.pta_associated_config]
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
		conf[self.config.center.pta_associated_config] = not conf[self.config.center.pta_associated_config]
		self.debuff = not conf[self.config.center.pta_associated_config]
		self:juice_up()
		play_sound('tarot2')
	end
end

-- TODO: probably separate these into a different file
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
								}
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0.1 },
								nodes = {
									create_credit("credit_ari"),
									create_credit("credit_loggers"),
									create_credit("credit_aikoyori"),
									create_credit("credit_airrice"),
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