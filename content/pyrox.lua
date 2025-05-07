local old_igo = Game.init_game_object
function Game:init_game_object()
	local ret = old_igo(self)
	ret.payasaka_pyroxenes = 0
	return ret
end

function ease_pyrox(mod, instant)
	if mod == 0 then return end
	local function _mod(mod)
		local dollar_UI = G.HUD:get_UIE_by_ID('pyrox_text_UI')
		mod = mod or 0
		local text = '+' .. localize('$')
		local col = G.C.BLUE
		if mod < 0 then
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

local old_can_buy = G.FUNCS.can_buy
function G.FUNCS.can_buy(e)
	old_can_buy(e)
	if (e.config.ref_table.config and e.config.ref_table.config.center and e.config.ref_table.config.center.pyroxenes and e.config.ref_table.config.center.pyroxenes > G.GAME.payasaka_pyroxenes) and (e.config.ref_table.config.center.pyroxenes > 0) then
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

local old_can_buy_and_use = G.FUNCS.can_buy_and_use
function G.FUNCS.can_buy_and_use(e)
	if (e.config.ref_table.config and e.config.ref_table.config.center and e.config.ref_table.config.center.pyroxenes and e.config.ref_table.config.center.pyroxenes > G.GAME.payasaka_pyroxenes) and (e.config.ref_table.config.center.pyroxenes > 0) then
		e.UIBox.states.visible = false
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else
		old_can_buy_and_use(e)
	end
end

local can_open = G.FUNCS.can_open
G.FUNCS.can_open = function(e)
	can_open(e)
	if (e.config.ref_table.config and e.config.ref_table.config.center and e.config.ref_table.config.center.pyroxenes and e.config.ref_table.config.center.pyroxenes > G.GAME.payasaka_pyroxenes) and (e.config.ref_table.config.center.pyroxenes > 0) then
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end
