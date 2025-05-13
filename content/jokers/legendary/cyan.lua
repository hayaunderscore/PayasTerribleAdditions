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
		extra = { add_amt = 0.2, dec_amt = 0.2, current_mult = 1 },
		immutable = { speed = 0.35, dir = rand_dir(), x = 0, y = 0, size = 16, atlas_dir = 0 },
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
		-- update gfx position of card
		local im = card.ability.immutable
		im.x = im.x + im.dir.x*im.speed*(dt*60)
		im.y = im.y + im.dir.y*im.speed*(dt*60)
		local nextx = im.x
		local nexty = im.y
		-- bounce off borders
		-- extremely arbritary numbers over here lmao
		while ((nextx < 0 or (nextx+im.size) > 71*1.3) or (nexty < 0 or (nexty+im.size) > 95*1.9)) do
			im.dir = rand_dir()
			nextx = im.x + im.dir.x*im.speed*(dt*60)
			nexty = im.y + im.dir.y*im.speed*(dt*60)
			im.atlas_dir = math.floor((im.dir.ang + 22.5) / 45) % 8
		end
	end,
	cost = 25,
	blueprint_compat = true,
	demicoloncompat = true,
}