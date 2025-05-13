-- ITS MEEEE
SMODS.Joker {
	name = "Paya",
	key = 'paya',
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers",
	pos = { x = 0, y = 6 },
	soul_pos = { x = 2, y = 6, extra = { x = 1, y = 6 } },
	cost = 25,
	no_doe = true, -- :]
	demicoloncompat = false,
	config = { odds = 2, extra = { exponential_active = false } },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	loc_vars = function(self, info_queue, card)
		local str = localize('k_payasaka_' .. (card.ability.extra.exponential_active and "active" or "inactive"))
		return {
			vars = { card.ability.cry_rigged and card.ability.odds or (G.GAME.probabilities.normal or 1), card.ability.odds },
			main_end = {
				(G.GAME and card.area and (card.area == G.jokers)) and {
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes = {
						{
							n = G.UIT.C,
							config = { ref_table = card, align = "m", colour = card.ability.extra.exponential_active and G.C.GREEN or G.C.UI.TEXT_INACTIVE, r = 0.05, padding = 0.06 },
							nodes = {
								{ n = G.UIT.T, config = { text = ' ' .. str .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9 } },
							}
						}
					}
				} or nil
			}
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and ((pseudorandom('paya_hell') < (G.GAME.probabilities.normal or 1) / card.ability.odds) or card.ability.cry_rigged) then
			card.ability.extra.exponential_active = true
			G.E_MANAGER:add_event(Event {
				func = function()
					G.GAME.payasaka_exponential_count = G.GAME.payasaka_exponential_count + 1
					return true
				end
			})
			return {
				message = "Active!"
			}
		end
		if context.end_of_round and card.ability.extra.exponential_active then
			card.ability.extra.exponential_active = false
			G.E_MANAGER:add_event(Event {
				func = function()
					G.GAME.payasaka_exponential_count = G.GAME.payasaka_exponential_count - 1
					return true
				end
			})
			return {
				message = "Inactive!"
			}
		end
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
				local str = G.GAME.payasaka_exponential_count > 2 and
					string.format("{%d}", G.GAME.payasaka_exponential_count) or
					G.GAME.payasaka_exponential_count <= 0 and "X" or ("^"):rep(G.GAME.payasaka_exponential_count)
				text_size = #str - 1
				PTASaka.payasaka_text_size = text_size
				x_marks_the_spot.config.object.config.string = { str }
				x_marks_the_spot.config.object:update_text(true)
				x_marks_the_spot.config.object.colours = { G.GAME.payasaka_exponential_count <= 0 and G.C.MULT or
				G.C.DARK_EDITION }
				G.FUNCS.text_super_juice(x_marks_the_spot, 0.8)
				play_sound('tarot2')
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
