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

-- hiii
SMODS.optional_features.retrigger_joker = true
SMODS.optional_features.cardareas.deck = true

-- ATLASES --

-- Joker atlas
SMODS.Atlas { key = "JOE_Jokers", path = "jokers.png", px = 71, py = 95 }

-- Blind atlas
SMODS.Atlas { key = "JOE_Blinds", path = "blinders.png", px = 34, py = 34, atlas_table = 'ANIMATION_ATLAS', frames = 21 }

-- Tarots and Spectrals
SMODS.Atlas { key = "JOE_Tarots", path = "tarots.png", px = 71, py = 95 }

-- Property atlas(es)
SMODS.Atlas { key = "JOE_Properties", path = "properties.png", px = 71, py = 95 } -- This also includes the Greed tarot!
SMODS.Atlas { key = "JOE_Properties_Boosters", path = "properties_boosters.png", px = 71, py = 95 }

-- Voucher atlas
SMODS.Atlas { key = "JOE_Vouchers", path = "vouchers.png", px = 71, py = 95 }

-- Deck atlas
SMODS.Atlas { key = "JOE_Decks", path = "backs.png", px = 71, py = 95 }

-- Enhancement atlas
SMODS.Atlas { key = "JOE_Enhancements", path = "enhancements.png", px = 71, py = 95 }

-- Cross mod content
SMODS.Atlas { key = "JOE_Rotarots", path = "mf/rotarots.png", px = 107, py = 107 }
SMODS.Atlas { key = "JOE_Sleeves", path = "sleeves.png", px = 73, py = 95 }
SMODS.Atlas { key = "REVO_JOE_Printers", path = "revo/printers.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_Exotic", path = "cryptid/exotics.png", px = 71, py = 95 }

-- Icon lmao
SMODS.Atlas { key = "modicon", path = "icon.png", px = 34, py = 34 }

-- MAIN CODE --

-- Utilities
assert(SMODS.load_file("content/utils.lua"))()

-- Descriptions
assert(SMODS.load_file("content/desc.lua"))()

-- Sounds
assert(SMODS.load_file("content/sounds.lua"))()

-- Load all files in a folder
function PTASaka.RequireFolder(path)
	local files = NFS.getDirectoryItemsInfo(PTASaka.Mod.path .. "/" .. path)
	for i = 1, #files do
		local file_name = files[i].name
		if file_name:sub(-4) == ".lua" then
			assert(SMODS.load_file(path .. file_name))()
		end
	end
end

-- Blinds
PTASaka.RequireFolder("content/blinds/")

-- Editions
PTASaka.RequireFolder("content/editions/")

-- Challenges
assert(SMODS.load_file("content/challenges.lua"))()

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
-- Ahead
PTASaka.RequireFolder("content/jokers/ahead/")

-- Tarots, spectrals and seals
assert(SMODS.load_file("content/tarots.lua"))()

-- Property cards
if conf["Property Cards"] then
	assert(SMODS.load_file("content/properties.lua"))()
end

-- Vouchers
assert(SMODS.load_file("content/vouchers.lua"))()

-- Decks
assert(SMODS.load_file("content/decks.lua"))()

-- Enhancements
assert(SMODS.load_file("content/enhancements.lua"))()

-- Cross mod content: JokerDisplay
if JokerDisplay then
assert(SMODS.load_file("content/jokerdisplay.lua"))()
end

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

-- TODO: probably separate these into a different file
local tabs = function() return
{
	{
		label = "Features",
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
					-- padding = 0.2,
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
									create_toggle_with_description({label = "Balanced-ish", ref_table = conf, ref_value = "Balanced-ish"}, "option_balanced"),
									--{n = G.UIT.R, config = {padding = 0.2}},
									create_toggle_with_description({label = "Property Cards", ref_table = conf, ref_value = "Property Cards"}, "option_property_cards"),
									create_toggle_with_description({label = "Cross Mod Content", ref_table = conf, ref_value = "Cross Mod Content"}, "option_crossmod"),
								}
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0.2 },
								nodes = {
									create_toggle_with_description({label = "Music", ref_table = conf, ref_value = "Music"}, "option_music"),
									create_toggle_with_description({label = "Witty Comments", ref_table = conf, ref_value = "Witty Comments"}, "option_wittycomments"),
								}
							},
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
									create_credit("credit_aikoyori"),
									create_credit("credit_airrice"),
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