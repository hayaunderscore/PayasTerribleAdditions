-- ITS MEEEE
SMODS.Joker {
	name = "Paya",
	key = 'paya',
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers",
	pos = { x = 0, y = 6 },
	soul_pos = { x = 2, y = 6, extra = { x = 1, y = 6 } },
	cost = 25,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.payasaka_exponential_count = G.GAME.payasaka_exponential_count + 1
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.payasaka_exponential_count = G.GAME.payasaka_exponential_count - 1
	end
}

local old_igo = Game.init_game_object
function Game:init_game_object()
	local ret = old_igo(self)
	ret.payasaka_exponential_count = 0
	return ret
end

local old_sr = Game.start_run
function Game:start_run(args)
	PTASaka.payasaka_exponential_count = 0
	return old_sr(self, args)
end

local old_update = Game.update
function Game:update(dt)
	old_update(self, dt)
	if G.GAME and G.HUD then
		if G.GAME.payasaka_exponential_count ~= nil and PTASaka.payasaka_exponential_count ~= G.GAME.payasaka_exponential_count then
			PTASaka.payasaka_exponential_count = G.GAME.payasaka_exponential_count
			local x_marks_the_spot = G.HUD:get_UIE_by_ID('chips_what_mult')
			local text_size = 0
			if x_marks_the_spot then
				x_marks_the_spot.config.text = G.GAME.payasaka_exponential_count > 2 and
				string.format("{%d}", G.GAME.payasaka_exponential_count) or
				G.GAME.payasaka_exponential_count <= 0 and "X" or ("^"):rep(G.GAME.payasaka_exponential_count)
				text_size = #x_marks_the_spot.config.text - 1
				PTASaka.payasaka_text_size = text_size
				x_marks_the_spot.config.colour = G.GAME.payasaka_exponential_count <= 0 and G.C.MULT or G.C.DARK_EDITION
			end
			local chips_box = G.HUD:get_UIE_by_ID('hand_chip_area')
			if chips_box then
				chips_box.config.minw = 2 - (math.max(text_size, 0) * 0.14)
			end
			local mult_box = G.HUD:get_UIE_by_ID('hand_mult_area')
			if mult_box then
				mult_box.config.minw = 2 - (math.max(text_size, 0) * 0.14)
			end
			local chips_text, mult_text = G.HUD:get_UIE_by_ID('hand_chips'), G.HUD:get_UIE_by_ID('hand_mult')
			--x_marks_the_spot.config.scale = 0.8-(math.max(0, #x_marks_the_spot.config.text)*0.2)
			G.HUD:recalculate()
		end
	end
end

function PTASaka.arrow(arrow, val1, val2)
	local val = val1
	if arrow == 1 then
		val = val ^ val2
	elseif arrow == 0 then
		val = val * val2
	else
		val = val ^ PTASaka.arrow(arrow - 1, val, val2)
	end
	return val
end
