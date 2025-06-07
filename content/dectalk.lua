local _, https = pcall(require, "SMODS.https")
require "love.audio"
require "love.filesystem"

function john_madden(code, body, ...)
	if body then
		local audio = love.audio.newSource(love.filesystem.newFileData(body, "aeiou.wav"), "static")
		audio:setVolume((G.SETTINGS.SOUND.volume/100)*(G.SETTINGS.SOUND.game_sounds_volume/100)*4)
		love.audio.play(audio)
	end
end

function PTASaka.DECTalk(aeiou)
	if https then
		https.asyncRequest("http://tts.cyzon.us/tts?text="..aeiou, {method="GET"}, john_madden)
	end
end