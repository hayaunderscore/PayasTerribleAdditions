function ease_pyrox(mod, instant)
	if mod == 0 then return end
	local function _mod(mod)
		local dollar_UI = G.HUD:get_UIE_by_ID('pyrox_text_UI')
		mod = mod or 0
		local text = '+' .. localize('$')
		local col = G.C.BLUE
		if to_big(mod) < to_big(0) then
			text = '-' .. localize('$')
			col = G.C.RED
		end
		--Ease from current chips to the new number of chips
		G.GAME.payasaka_pyroxenes = G.GAME.payasaka_pyroxenes + mod
		dollar_UI.config.object:update()
		G.HUD:recalculate()
		--Popup text next to the chips in UI showing number of chips gained/lost
		attention_text({
			text = text .. tostring(math.abs(mod)),
			scale = 0.5,
			hold = 0.7,
			cover = dollar_UI.parent,
			cover_colour = col,
			align = 'cm',
		})
		--Play a chip sound
		play_sound('coin1')
	end
	if instant then
		_mod(mod)
	else
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				_mod(mod)
				return true
			end
		}))
	end
end
