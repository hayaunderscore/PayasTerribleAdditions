local function create_sound(key)
	SMODS.Sound { key = key, path = key .. ".ogg" }
end

-- Multiplier
create_sound("markiplier_helloeverybody")
create_sound("markiplier_ngahh")
-- Ten 10s
create_sound("lucky")

-- The Nether
create_sound("nether")
create_sound("flint")

-- JPEG/YCbCr
create_sound("jpej")

-- Shotgun
create_sound("shotgun")
create_sound("shotgun_added")

-- Winton
create_sound("challenpoints")
create_sound("hithere")

-- Cyan
create_sound("horse")
create_sound("horsebounce")

create_sound("coolgong")

-- Drop Target
create_sound("drop_target")

-- Fanhead
SMODS.Sound { key = 'emult', path = 'exponential_mult' .. ".wav" }
SMODS.Sound { key = 'echips', path = 'exponential_chips' .. ".wav" }
SMODS.Sound { key = 'eemult', path = 'TetrationalMult' .. ".wav" }
SMODS.Sound { key = 'eechips', path = 'TetrationalChips' .. ".wav" }

-- Some boss blinds cannot be disabled!
create_sound("loudbuzzer")

-- Ask Madden
SMODS.Sound { key = 'aeiou', path = 'aeiou' .. ".wav" }

create_sound("snd_icespell")

-- Custom music for prismatic jokers
SMODS.Sound({
	key = "music_prismatic",
	path = "music_prismatic.ogg",
	select_music_track = function()
		if G.jokers then
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] and G.jokers.cards[i].config.center.rarity == "payasaka_daeha" then
					return math.huge
				end
			end
		end
		return false
	end,
})