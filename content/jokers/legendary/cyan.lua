SMODS.Atlas {
	key = "cyan",
	path = "cyan.png",
	px = 32, py = 32
}

-- get a random dir
local function rand_dir()
	local dir = 2*math.pi*(G and G.GAME and pseudorandom('cyan_gfx') or math.random())
	return {x = math.cos(dir), y = math.sin(dir), ang = math.deg(dir) % 360}
end

SMODS.Joker {
	key = "cyan",
	config = {
		extra = { planet_multiplier = 1.0, chip_gain = 0.1 },
		immutable = { speed = 0.9, dir = rand_dir(), x = 0, y = 0, size = 16, atlas_dir = 0 },
	},
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 0, y = 9 },
	soul_pos = { x = 1, y = 9, draw = function(card, scale_mod, rotate_mod)
		---@type Sprite
		local soul = card.children.floating_sprite
		soul.scale.x = 32
		soul.scale.y = 32
		soul.scale_mag = {0.5, 0.5}
		local im = card.ability.immutable
		if soul.atlas ~= G.ASSET_ATLAS["payasaka_cyan"] then
			soul.atlas = G.ASSET_ATLAS["payasaka_cyan"]
		end
		soul:set_sprite_pos({x = im.atlas_dir, y = 0})
		soul:draw_shader('dissolve', 0, nil, nil, card.children.center, nil, nil, (im.x/71), (im.y/95) + (0.1+0.03*math.sin(1.8*G.TIMERS.REAL)), nil, 0.6)
		soul:draw_shader('dissolve', nil, nil, nil, card.children.center, nil, nil, (im.x/71), (im.y/95))
	end },
	update = function(self, card, dt)
		local delta = G.real_dt or dt
		-- update gfx position of card
		local im = card.ability.immutable
		im.x = im.x + im.dir.x*im.speed*(delta*60)
		im.y = im.y + im.dir.y*im.speed*(delta*60)
		local nextx = im.x
		local nexty = im.y
		-- bounce off borders
		-- extremely arbritary numbers over here lmao
		while ((nextx < 0 or (nextx+im.size) > 71*1.3) or (nexty < 0 or (nexty+im.size) > 95*2)) do
			im.dir = rand_dir()
			nextx = im.x + im.dir.x*im.speed*(delta*60)
			nexty = im.y + im.dir.y*im.speed*(delta*60)
			im.atlas_dir = math.floor((im.dir.ang + 22.5) / 45) % 8
		end
	end,
	calculate = function(self, card, context)
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
			return {
				x_chips = card.ability.extra.planet_multiplier
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.planet_multiplier, card.ability.extra.chip_gain } }
	end,
	cost = 25,
	blueprint_compat = true,
	demicoloncompat = true,
}

-- Handle Cyan planet card effects
local oldluh = level_up_hand
---@param card Card|nil
---@param hand string
---@param instant boolean|nil
---@param amount number
function level_up_hand(card, hand, instant, amount, ...)
	local cyans = SMODS.find_card('j_payasaka_cyan')
	local old_l_chips = G.GAME.hands[hand].l_chips
	local old_l_mult = G.GAME.hands[hand].l_mult
	-- Make sure its a Planet card or Planet-like
	if card and card.ability and card.ability.consumeable then
		---@type Card
		for _, cyan in ipairs(cyans) do
			if cyan.ability.extra.planet_multiplier > 1 then
				-- Prevent Black Hole and such from constantly having reactions from Cyan
				if not instant then
					card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = 'Upgraded!',
						colour = G.C.DARK_EDITION,
						extrafunc = function()
							cyan:juice_up()
						end
					})
				end
				G.GAME.hands[hand].l_chips = G.GAME.hands[hand].l_chips * cyan.ability.extra.planet_multiplier
				G.GAME.hands[hand].l_mult = G.GAME.hands[hand].l_mult * cyan.ability.extra.planet_multiplier
			end
		end
	end
	oldluh(card, hand, instant, amount, ...)
	G.GAME.hands[hand].l_chips = old_l_chips
	G.GAME.hands[hand].l_mult = old_l_mult
end