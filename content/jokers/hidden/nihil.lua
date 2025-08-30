-- nihil
-- Obtainable via invoking 10 risk cards while Irisu is available
-- Compared to other thunderstruck jokers, this is irreversible!

local scrambled = {
	"]n*#@lhI[!i",
	"#[@h*n]i!Il",
	"nI*]hli!#@[",
	"i]n[Ihl@!#*",
	"lih*!][#@In",
	"ih#[!@nlI*]",
	"*!Inh#li]@[",
	"!nlIi][#h*@"
}

local ease_background_colour_ref = ease_background_colour
function ease_background_colour(args)
	if next(SMODS.find_card("j_payasaka_nihil")) then
		args = args or {}
		args.new_colour = G.C.BLACK
		args.special_colour = G.C.L_BLACK
		args.tertiary_colour = G.C.UI.BACKGROUND_DARK
		args.contrast = 4
	end
	return ease_background_colour_ref(args)
end

SMODS.Joker {
	name = "%n",
	key = "nihil",
	rarity = "payasaka_thunderstruck",
	atlas = "JOE_Jokers2",
	pos = { x = 8, y = 2 },
	soul_pos = { x = 8, y = 3 },
	cost = 25,
	blueprint_compat = true,
	demicoloncompat = false,
	no_doe = true,
	no_collection = true,
	discovered = true,
	unlocked = true,
	immutable = true,
	config = { skip_sound_timer = 4, skip_sound = 0, initial_anim = 1, cool_pos = { x = 8, y = 3 } },
	pta_custom_use = function(card)
		return {
			n = G.UIT.C,
			config = { align = "cr" },
			nodes = {
				{
					n = G.UIT.C,
					config = { ref_table = card, align = "cr", maxw = 1.4, padding = 0.1, r = 0.08, minw = 1.4, minh = 0.1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, button = 'use_card', func = 'payasaka_can_open_irisu_deck' },
					nodes = {
						{ n = G.UIT.B, config = { h = 0.1 } },
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.C,
									config = { align = "cl" },
									nodes = {
										{
											n = G.UIT.R,
											config = { align = "cm" },
											nodes = {
												{ n = G.UIT.T, config = { text = "LOOK", colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true } },
											}
										},
										{
											n = G.UIT.R,
											config = { align = "cl" },
											nodes = {
												{ n = G.UIT.T, config = { text = "INSIDE", colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true } },
											}
										},
									}
								}
							}
						}
					}
				}
			}
		}
	end,
	-- These guys are unobtainable normally!
	in_pool = function(self, args)
		return false
	end,
	calculate = function(self, card, context)
		return G.P_CENTERS["j_payasaka_irisu"]:calculate(card, context)
	end,
	loc_vars = function(self, info_queue, card)
		return {
			main_end = {
				{
					n = G.UIT.C,
					config = {},
					nodes = {
						{
							n = G.UIT.O,
							config = {
								object = DynaText {
									string = scrambled,
									colours = { G.C.UI.TEXT_DARK },
									pop_in_rate = 9999999,
									silent = true,
									random_element = true,
									pop_delay = 0.07,
									scale = 0.32,
									min_cycle_time = 0,
								}
							}
						},
					}
				}
			}
		}
	end,
	set_sprites = function(self, card, front)
		if card.ability and card.ability.did_anim and card.children.floating_sprite then
			card.children.floating_sprite:set_sprite_pos({ x = card.ability.cool_pos.x, y = 7 })
		end
	end,
	update = function(self, card, dt)
		card.ability.skip_sound_timer = card.ability.skip_sound_timer - G.real_dt
		card.ability.skip_sound = math.max(0, card.ability.skip_sound - G.real_dt)
		card.ability.initial_anim = math.max(0, card.ability.initial_anim - G.real_dt)
		if card.ability.skip_sound_timer <= 0 and G.STAGE == G.STAGES.RUN then
			card.ability.skip_sound = 1.5
			card.ability.skip_sound_timer = 4
			play_sound("payasaka_sfx_n")
		end
		--print(card.ability.initial_anim)
		if card.ability.initial_anim <= 0 and not card.ability.did_anim then
			card.ability.did_anim = true
			G.E_MANAGER:add_event(Event{
				trigger = 'ease',
				ease = 'lerp',
				delay = 0.2 * G.SPEEDFACTOR,
				ref_table = card.ability.cool_pos,
				ref_value = "y",
				ease_to = 7,
				func = function(n)
					card.children.floating_sprite:set_sprite_pos({ x = card.ability.cool_pos.x, y = math.floor(n) })
					return math.floor(n)
				end
			}, "other")
		end
	end
}

SMODS.Sound {
	key = 'music_n',
	path = "mus_n.ogg",
	select_music_track = function(self)
		if G.jokers and G.jokers.cards then
			for k, v in pairs(G.jokers.cards) do
				if v.config.center_key == "j_payasaka_nihil" then
					return math.huge
				end
			end
		end
		return false
	end,
	pitch = 1
}

SMODS.Sound {
	key = "sfx_n",
	path = "sfx_n.ogg"
}