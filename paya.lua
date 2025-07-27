-- uhhh
PTASaka = {}
PTASaka.Mod = SMODS.current_mod
local conf = PTASaka.Mod.config

local nil_sane = function(val, def)
	if val == nil then val = def end
	return val
end

-- Config values
conf["Balanced-ish"] = nil_sane(conf["Balanced-ish"], false) -- currently does nothing :P
conf["Property Cards"] = nil_sane(conf["Property Cards"], true)
conf["Cross Mod Content"] = nil_sane(conf["Cross Mod Content"], true)
conf["Music"] = nil_sane(conf["Music"], true)
conf["Witty Comments"] = nil_sane(conf["Witty Comments"], true)
conf["Ahead"] = nil_sane(conf["Ahead"], true)
conf["Risk Cards"] = nil_sane(conf["Risk Cards"], true)
conf["Experimental"] = nil_sane(conf["Experimental"], true)
conf["New Run Plus"] = nil_sane(conf["New Run Plus"], false)

-- hiii
SMODS.optional_features.retrigger_joker = true
SMODS.optional_features.cardareas.deck = true
SMODS.optional_features.cardareas.discard = true

-- ATLASES --

-- Joker atlas
SMODS.Atlas { key = "JOE_Jokers", path = "jokers.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_Jokers2", path = "jokers2.png", px = 71, py = 95 }

-- Blind atlas
SMODS.Atlas { key = "JOE_Blinds", path = "blinders.png", px = 34, py = 34, atlas_table = 'ANIMATION_ATLAS', frames = 21 }
SMODS.Atlas { key = "JOE_CreditChips", path = "creditchips.png", px = 34, py = 34, atlas_table = 'ANIMATION_ATLAS', frames = 21 }

-- Tarots and Spectrals
SMODS.Atlas { key = "JOE_Tarots", path = "tarots.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_Tarots_Adjust", path = "tarots.png", px = 85, py = 95 }

-- Property atlas(es)
SMODS.Atlas { key = "JOE_Properties", path = "properties.png", px = 71, py = 95 } -- This also includes the Greed tarot!
SMODS.Atlas { key = "JOE_Boosters", path = "properties_boosters.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_UltraBoosters", path = "ultra.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_DOS", path = "dos.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_Risk", path = "risk.png", px = 71, py = 95 }

-- Voucher atlas
SMODS.Atlas { key = "JOE_Vouchers", path = "vouchers.png", px = 71, py = 95 }

-- Deck atlas
SMODS.Atlas { key = "JOE_Decks", path = "backs.png", px = 71, py = 95 }

-- Enhancement atlas
SMODS.Atlas { key = "JOE_Enhancements", path = "enhancements.png", px = 71, py = 95 }
SMODS.Atlas { key = "sharpmark", path = "sharpmark.png", px = 97, py = 97 }

-- Tags atlas
SMODS.Atlas { key = "JOE_Tags", path = "tags.png", px = 34, py = 34 }

-- Cross mod content
SMODS.Atlas { key = "JOE_Rotarots", path = "mf/rotarots.png", px = 107, py = 107 }
SMODS.Atlas { key = "JOE_Colours", path = "mf/colours.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_Sleeves", path = "sleeves.png", px = 73, py = 95 }
SMODS.Atlas { key = "REVO_JOE_Printers", path = "revo/printers.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_Exotic", path = "cryptid/exotics.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_TOGA", path = "toga.png", px = 71, py = 95 }
SMODS.Atlas { key = "JOE_TOGA_warrior_soul", path = "toga.png", px = 90, py = 95 }

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
		TEXT_OFFSET = { x = 12, y = -24 },
		FONTSCALE = 0.06,
		squish = 1,
		DESCSCALE = 1.25
	}

	PTASaka.Font {
		key = "reversed",
		path = "11x6m.ttf",
		render_scale = 200,
		TEXT_HEIGHT_SCALE = 0.83,
		TEXT_OFFSET = { x = 10, y = 0 },
		FONTSCALE = 0.1,
		squish = 1,
		DESCSCALE = 1
	}

	SMODS.Font {
		key = "NotoEmoji",
		path = "NotoEmoji-Bold.ttf",
		render_scale = 140,
		TEXT_HEIGHT_SCALE = 0.65,
		TEXT_OFFSET = { x = 0, y = 0 },
		FONTSCALE = 0.12,
		squish = 1,
		DESCSCALE = 1
	}

	SMODS.Font {
		key = "FiraCode",
		path = "FiraCode-Medium.ttf",
		render_scale = 140,
		TEXT_HEIGHT_SCALE = 0.65,
		TEXT_OFFSET = { x = 0, y = -24 },
		FONTSCALE = 0.12,
		squish = 1,
		DESCSCALE = 1
	}
end

-- MAIN CODE --

-- Utilities
-- Note: Probably move this to be appended on main.lua????
assert(SMODS.load_file("lib/utils.lua"))()
assert(SMODS.load_file("lib/fh.lua"))()
assert(SMODS.load_file("lib/dectalk.lua"))() -- DECTalk module

-- Descriptions
assert(SMODS.load_file("lib/desc.lua"))()

-- Blinds
PTASaka.RequireFolder("content/blinds/")
PTASaka.RequireFolder("content/blinds/showdown/")

-- Editions
PTASaka.RequireFolder("content/editions/")

-- Other stuff
PTASaka.RequireFolder("content/misc/")

-- Load all jokers

-- Rarity definitions
assert(SMODS.load_file("content/jokers/rarity_definitions.lua"))()
-- Common
PTASaka.RequireFolder("content/jokers/common/")
PTASaka.RequireFolder("content/jokers/common/friend/")
-- Uncommon
PTASaka.RequireFolder("content/jokers/uncommon/")
PTASaka.RequireFolder("content/jokers/uncommon/friend/")
-- Rare
PTASaka.RequireFolder("content/jokers/rare/")
PTASaka.RequireFolder("content/jokers/rare/friend/")
-- Legendary
PTASaka.RequireFolder("content/jokers/legendary/")
if conf["Ahead"] then
	-- Ahead
	PTASaka.RequireFolder("content/jokers/ahead/")
	-- daehA
	PTASaka.RequireFolder("content/jokers/daeha/")
end
-- Thunderstruck
PTASaka.RequireFolder("content/jokers/hidden/")

-- CONSUMABLES --

-- Tarots, spectrals and seals
assert(SMODS.load_file("content/consumables/tarots.lua"))()

-- Property cards
if conf["Property Cards"] then
	assert(SMODS.load_file("content/consumables/properties.lua"))()
end

-- DOS Cards
assert(SMODS.load_file("content/consumables/dos.lua"))()

-- Risk cards
if conf["Risk Cards"] then
	assert(SMODS.load_file("content/consumables/risk.lua"))()
	assert(SMODS.load_file("content/consumables/rewards.lua"))()
end

-- Gacha spectral specifically
assert(SMODS.load_file("content/consumables/gachapack.lua"))()

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

-- Cross mod content: MoreFluff
if next(SMODS.find_mod('MoreFluff')) and conf["Cross Mod Content"] then
	assert(SMODS.load_file("content/consumables/colour.lua"))()
end

-- Cross mod content: TOGA's Stuff
if togabalatro and conf["Cross Mod Content"] then
	assert(SMODS.load_file("content/jokers/toga.lua"))()
end

-- Internal
PTASaka.RequireFolder("content/internal/")

-- Sets for toggling various features
assert(SMODS.load_file("lib/set.lua"))()

-- UI stuff not related to gameplay
assert(SMODS.load_file("lib/ui.lua"))()

-- Scale library
assert(SMODS.load_file("lib/scale.lua"))()