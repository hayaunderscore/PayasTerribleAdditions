-- uhhh
PTASaka = {}
PTASaka.Mod = SMODS.current_mod

-- hiii
SMODS.optional_features.retrigger_joker = true

-- Joker atlas
SMODS.Atlas { key = "JOE_Jokers", path = "jokers.png", px = 71, py = 95 }

-- Utilities
assert(SMODS.load_file("content/utils.lua"))()

-- Descriptions
assert(SMODS.load_file("content/desc.lua"))()

-- Load all jokers
local path = PTASaka.Mod.path .. "/content/jokers/"
local files = NFS.getDirectoryItemsInfo(path)
for i = 1, #files do
	local file_name = files[i].name
	if file_name:sub(-4) == ".lua" then
		assert(SMODS.load_file("content/jokers/" .. file_name))()
	end
end
