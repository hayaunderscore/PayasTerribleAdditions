SMODS.Atlas {
	key = "cyan",
	path = "cyan.png",
	px = 32, py = 32
}

-- 95/71
local vscale = 1.3380281690140845070422535211268
local card_scale = G.TILESCALE/2.3
local center_x = card_scale/2
local center_y = (card_scale*vscale)/2
local sprite_scale = card_scale*(0.45070422535211267605633802816901/2)

-- get a random dir
local function rand_dir()
	local dir = 2*math.pi*(G and G.GAME and pseudorandom('cyan_gfx') or math.random())
	return {x = math.cos(dir), y = math.sin(dir), ang = math.deg(dir) % 360}
end

SMODS.Joker {
	key = "cyan",
	config = {
		extra = { planet_multiplier = 1.0, chip_gain = 0.1, speed = 0.04 },
		immutable = { dir = { x = 1, y = 0, ang = 0 }, x = center_x-(sprite_scale/2), y = center_y-(sprite_scale/2), size = sprite_scale, atlas_dir = 0 },
	},
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 0, y = 9 },
	cost = 25,
	soul_pos = { x = 1, y = 9, draw = function(card, scale_mod, rotate_mod)
		---@type Sprite
		local soul = card.children.floating_sprite
		soul.scale.x = 32*card.T.scale
		soul.scale.y = 32*card.T.scale
		soul.scale_mag = {0.5, 0.5}
		local im = card.ability.immutable
		if soul.atlas ~= G.ASSET_ATLAS["payasaka_cyan"] then
			soul.atlas = G.ASSET_ATLAS["payasaka_cyan"]
		end
		soul:set_sprite_pos({x = im.atlas_dir, y = 0})
		soul:draw_shader('dissolve', 0, nil, nil, card.children.center, nil, nil, im.x*card.T.scale, im.y*card.T.scale + (0.1+0.03*math.sin(1.8*G.TIMERS.REAL)), nil, 0.6)
		soul:draw_shader('dissolve', nil, nil, nil, card.children.center, nil, nil, im.x*card.T.scale, im.y*card.T.scale)
	end },
	update = function(self, card, dt)
		local delta = G.real_dt or dt
		-- update gfx position of card
		local im = card.ability.immutable
		local extra = card.ability.extra
		if not extra.speed then extra.speed = im.speed end
		im.x = im.x + im.dir.x*extra.speed*(delta*60)
		im.y = im.y + im.dir.y*extra.speed*(delta*60)
		local nextx = im.x
		local nexty = im.y
		-- bounce off borders
		local count = 0
		while ((nextx < 0 or (nextx+im.size) > card_scale) or (nexty < 0 or (nexty+im.size) > card_scale*vscale)) do
			if count > 50 then break end
			if count == 0 then play_sound("payasaka_horsebounce", (math.random()+math.random(9,10))/10, 0.2) end
			im.dir = rand_dir()
			nextx = im.x + im.dir.x*extra.speed*(delta*60)
			nexty = im.y + im.dir.y*extra.speed*(delta*60)
			im.atlas_dir = math.floor((im.dir.ang + 22.5) / 45) % 8
			count = count+1
		end
	end,
	calculate = function(self, card, context)
		local im = card.ability.immutable
		if context.individual and context.cardarea == G.play and not context.game_over then
			local other_card = context.other_card
			if other_card and (other_card:is_suit('Spades') or other_card:is_suit('Clubs')) then
				card.ability.extra.planet_multiplier = card.ability.extra.planet_multiplier + card.ability.extra.chip_gain
				return {
					message = localize('k_upgrade_ex'),
					message_card = context.blueprint_card or card,
				}
			end
		end
		if context.joker_main or context.forcetrigger then
			G.E_MANAGER:add_event(Event{
				func = function()
					if not Talisman or not Talisman.config_file.disable_anims then
						play_sound("payasaka_horse")
					end
					return true
				end
			})
			return {
				x_chips = card.ability.extra.planet_multiplier,
			}
		end
		-- Make sure its a Planet card or Planet-like
		if context.payasaka_level_up_before and context.other_card and context.other_card.ability and context.other_card.ability.consumeable then
			if card.ability.extra.planet_multiplier > 1 then
				local c = context.blueprint_card or card
				-- Prevent Black Hole and such from constantly having reactions from Cyan
				if not context.instant then
					card_eval_status_text(context.other_card, 'extra', nil, nil, nil, {
						message = localize('k_upgrade_ex'),
						colour = G.C.DARK_EDITION,
						extrafunc = function()
							c:juice_up()
						end
					})
				end
				context.poker_hand.l_chips = context.poker_hand.l_chips * card.ability.extra.planet_multiplier
				context.poker_hand.l_mult = context.poker_hand.l_mult * card.ability.extra.planet_multiplier
			end
		end
		if context.payasaka_level_up_after and context.other_card and context.other_card.ability and context.other_card.ability.consumeable then
			context.poker_hand.l_chips = context.poker_hand.l_chips / card.ability.extra.planet_multiplier
			context.poker_hand.l_mult = context.poker_hand.l_mult / card.ability.extra.planet_multiplier
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.planet_multiplier, card.ability.extra.chip_gain } }
	end,
	cost = 25,
	blueprint_compat = true,
	demicoloncompat = true,
}
