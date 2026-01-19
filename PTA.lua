-- Global mod namespace
PTA = {
	mod = SMODS.current_mod
}

-- Enable needed optional stuff
SMODS.optional_features.retrigger_joker = true
SMODS.optional_features.post_trigger = true
SMODS.optional_features.cardareas.deck = true
SMODS.optional_features.cardareas.discard = true

-- Loads lua files recursively
function PTA.load_folder(path)
	if path:sub(-1) ~= "/" then path = path .. "/" end
	local files = NFS.getDirectoryItemsInfo(PTA.mod.path .. "/" .. path)
	for i = 1, #files do
		local file_name = files[i].name
		if file_name:sub(-4) == ".lua" then
			assert(SMODS.load_file(path .. file_name))()
		end
		if files[i].type == "directory" then
			PTA.load_folder(path .. file_name .. "/")
		end
	end
end

-- Load base asset content like atlases
assert(SMODS.load_file("content/atlas.lua"))()
assert(SMODS.load_file("content/utils.lua"))()

-- Load actual content
-- Jokers (ordered by rarity)
PTA.load_folder("content/jokers/common/")
PTA.load_folder("content/jokers/uncommon/")
PTA.load_folder("content/jokers/rare/")
PTA.load_folder("content/jokers/legendary/")
