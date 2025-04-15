-- uhhh
PTASaka = {}
PTASaka.Mod = SMODS.current_mod

-- hiii
SMODS.optional_features.retrigger_joker = true

-- ATLASES --

-- Joker atlas
SMODS.Atlas { key = "JOE_Jokers", path = "jokers.png", px = 71, py = 95 }

-- Blind atlas
SMODS.Atlas { key = "JOE_Blinds", path = "blinders.png", px = 34, py = 34, atlas_table = 'ANIMATION_ATLAS', frames = 21 }

-- Property atlas(es)
SMODS.Atlas { key = "JOE_Properties", path = "properties.png", px = 71, py = 95 } -- This also includes the Greed tarot!
SMODS.Atlas { key = "JOE_Properties_Boosters", path = "properties_boosters.png", px = 71, py = 95 }

-- Cross mod content
SMODS.Atlas { key = "JOE_Rotarots", path = "mf/rotarots.png", px = 107, py = 107 }

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
