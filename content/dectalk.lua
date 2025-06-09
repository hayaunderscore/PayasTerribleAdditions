local _, https = pcall(require, "SMODS.https")
require "love.audio"
require "love.filesystem"

function p_called_he_wants_his_john_madden_back(code, body, ...)
	if body then
		local bin = love.filesystem.newFileData(body, "aeiou.wav")
		if bin then
			local audio = love.audio.newSource(bin, "static")
			if audio then
				audio:setVolume((G.SETTINGS.SOUND.volume/100)*(G.SETTINGS.SOUND.game_sounds_volume/100)*8)
				love.audio.play(audio)
			end
		end
	end
end

function john_madden(code, body, ...)
	return pcall(p_called_he_wants_his_john_madden_back, code, body, ...)
end

function PTASaka.DECTalk(aeiou)
	if https then
		https.asyncRequest("http://tts.cyzon.us/tts?text="..aeiou, {method="GET"}, john_madden)
	end
end