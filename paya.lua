-- uhhh
PTASaka = {}
PTASaka.Mod = SMODS.current_mod

-- hiii
SMODS.optional_features.retrigger_joker = true
SMODS.optional_features.cardareas.deck = true

-- ATLASES --

-- Joker atlas
SMODS.Atlas { key = "JOE_Jokers", path = "jokers.png", px = 71, py = 95 }

-- Blind atlas
SMODS.Atlas { key = "JOE_Blinds", path = "blinders.png", px = 34, py = 34, atlas_table = 'ANIMATION_ATLAS', frames = 21 }

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

-- Load all jokers
-- Common
PTASaka.RequireFolder("content/jokers/common/")
-- Uncommon
PTASaka.RequireFolder("content/jokers/uncommon/")
-- Rare
PTASaka.RequireFolder("content/jokers/rare/")
-- Legendary
PTASaka.RequireFolder("content/jokers/legendary/")

-- Property cards
assert(SMODS.load_file("content/properties.lua"))()

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
if RevosVault then
assert(SMODS.load_file("content/printers.lua"))()
end

-- Cross mod content: Cryptid
if Cryptid then
assert(SMODS.load_file("content/exotic.lua"))()
end
