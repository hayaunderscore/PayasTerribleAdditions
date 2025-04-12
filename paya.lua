-- uhhh
PTASaka = {}
PTASaka.Mod = SMODS.current_mod

-- hiii
SMODS.optional_features.retrigger_joker = true

-- Joker atlas
SMODS.Atlas { key = "JOE_Jokers", path = "jokers.png", px = 71, py = 95 }

-- Blind atlas
SMODS.Atlas { key = "JOE_Blinds", path = "blinders.png", px = 34, py = 34, atlas_table = 'ANIMATION_ATLAS', frames = 21 }

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

-- Load all jokers
-- Common
PTASaka.RequireFolder("content/jokers/common/")
-- Uncommon
PTASaka.RequireFolder("content/jokers/uncommon/")
-- Rare
PTASaka.RequireFolder("content/jokers/rare/")
-- Legendary
PTASaka.RequireFolder("content/jokers/legendary/")
