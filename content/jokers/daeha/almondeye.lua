local function pseudoreroll_blind(blind_type)
	local opt = string.lower(blind_type)
	G.GAME.payasaka_rerolling_anim = G.GAME.payasaka_rerolling_anim or {}
	if G.blind_select_opts and G.blind_select_opts[opt] then
		G.GAME.payasaka_rerolling_anim[opt] = true
		local reroll_anim = not G.GAME.payasaka_rerolling_anim[opt]
		if reroll_anim then
			G.E_MANAGER:add_event(Event({
				trigger = 'immediate',
				func = function()
					play_sound('other1')
					G.blind_select_opts[opt]:set_role({ xy_bond = 'Weak' })
					G.blind_select_opts[opt].alignment.offset.y = 20
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event {
			trigger = reroll_anim and 'after' or 'immediate',
			delay = reroll_anim and 0.3 or 0,
			func = function()
				local par = G.blind_select_opts[opt].parent

				G.blind_select_opts[opt]:remove()
				G.blind_select_opts[opt] = UIBox {
					T = { par.T.x, 0, 0, 0, },
					definition =
					{ n = G.UIT.ROOT, config = { align = "cm", colour = G.C.CLEAR }, nodes = {
						UIBox_dyn_container({ create_UIBox_blind_choice(blind_type) }, false, get_blind_main_colour(blind_type), mix_colours(G.C.BLACK, get_blind_main_colour(blind_type), 0.8))
					} },
					config = { align = "bmi",
						offset = { x = 0, y = G.ROOM.T.y + 9 },
						major = par,
						xy_bond = 'Weak'
					}
				}
				par.config.object = G.blind_select_opts[opt]
				par.config.object:recalculate()
				G.blind_select_opts[opt].parent = par
				G.blind_select_opts[opt].alignment.offset.y = 0
				G.GAME.payasaka_rerolling_anim[opt] = false
				return true
			end
		})
	end
end

-- Almond Eye
SMODS.Joker {
	name = "pta-AlmondEye",
	key = "almondeye",
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers2",
	pos = { x = 7, y = 3 },
	cost = 25,
	blueprint_compat = true,
	demicoloncompat = false,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	config = { extra = { xscore = 1.25 } },
	calculate = function(self, card, context)
		if context.after then
			G.E_MANAGER:add_event(Event {
				func = function()
					G.GAME.chips = math.floor(G.GAME.chips ^ card.ability.extra.xscore)
					G.GAME.chips_text = number_format(G.GAME.chips)
					G.HUD:get_UIE_by_ID('chip_UI_count'):juice_up(0.5, 0.5)
					return true
				end
			})
			card_eval_status_text(card, 'extra', nil, nil, nil,
				{ message = ("^%s Score"):format(number_format(card.ability.extra.xscore)), sound = "payasaka_coolgong", colour = G.C.PURPLE })
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.round_resets.blind_choices.Big = get_new_boss()
		G.GAME.round_resets.blind_choices.Small = get_new_boss()
		pseudoreroll_blind("Big")
		pseudoreroll_blind("Small")
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.round_resets.blind_choices.Big = "bl_big"
		G.GAME.round_resets.blind_choices.Small = "bl_small"
		pseudoreroll_blind("Big")
		pseudoreroll_blind("Small")
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xscore } }
	end
}

local get_type_ref = Blind.get_type
function Blind:get_type()
	if next(SMODS.find_card("j_payasaka_almondeye")) and not G.GAME.blind.in_blind then
		return G.GAME.blind_on_deck
	end
	return get_type_ref(self)
end