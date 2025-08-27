SMODS.Joker {
	name = "pta-KitasanBlack",
	key = 'kitasan',
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers2",
	pos = { x = 1, y = 6 },
	soul_pos = { x = 2, y = 8 },
	pta_front_pos = { x = 1, y = 8 },
	cost = 25,
	no_doe = true, -- :]
	demicoloncompat = true,
	blueprint_compat = true,
	config = { immutable = { timer_till_upgrade_attempt = 2 }, extra = { xmult_gain = 1, xmult = 1 } },
	update = function(self, card, dt)
		if card.debuff then return end
		if G.STAGE == G.STAGES.RUN
			and card.area == G.jokers
			and G.STATE ~= G.STATES.HAND_PLAYED then
			card.ability.immutable.timer_till_upgrade_attempt = card.ability.immutable.timer_till_upgrade_attempt - dt
		end
		if card.ability.immutable.timer_till_upgrade_attempt <= 0 then
			-- reset
			card.ability.immutable.timer_till_upgrade_attempt = 2
			-- roll and see if we should upgrade. atleast 1 in 6 chance
			if pseudorandom('kitasan') < 1/6 then
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "xmult",
					scalar_table = {gain = (card.ability.extra.xmult_gain * (2 ^ (#SMODS.find_card('j_payasaka_kitasan') - 1)))},
					scalar_value = "gain",
					no_message = true,
				})
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex'), instant = true })
			end
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			create_support_card_animation(self, "payasaka_sfx_kitasan")
			return {
				x_mult = card.ability.extra.xmult,
				message = "Success!",
				sound = "payasaka_sfx_success",
				remove_default_message = true,
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult }
		}
	end,
	--shine_front_pos = true,
}

function create_support_card_animation(center, sound)
	if not PTASaka.Mod.config["Support Card Animations"] then return end
	G.E_MANAGER:add_event(Event{
		func = function()
			G.SUPPORT_CARD_RADIAL_SIZE = 0
			G.SUPPORT_CARD_FADE = 0
			G.SUPPORT_CARD_ANIM_ACTIVE = true
			G.SUPPORT_CARD_DARKEN = nil
			return true
		end
	})
	G.E_MANAGER:add_event(Event{
		trigger = 'ease',
		ease = 'lerp',
		delay = 1 * G.SPEEDFACTOR,
		ref_table = G,
		ref_value = "SUPPORT_CARD_RADIAL_SIZE",
		ease_to = love.graphics.getWidth()/64,
		func = function(n)
			return n
		end
	})
	-- harikitte ikou!
	G.E_MANAGER:add_event(Event{
		func = function()
			G.SUPPORT_CARD_FADE = 1
			G.SUPPORT_CARD_RADIAL_SIZE = 0
			local w, h = love.window.getMode()
			local x = (w/2) / (G.TILESCALE * G.TILESIZE)
			local y = (h/2) / (G.TILESCALE * G.TILESIZE)
			-- create really big card
			G.SUPPORT_CARD = Card(G.ROOM.T.w/2 - (G.CARD_W*3)/2, G.ROOM.T.h/2 - (G.CARD_H*3)/2, G.CARD_W*3, G.CARD_H*3, G.P_CARDS.empty, center)
			--G.SUPPORT_CARD.VT.r = 0.2
			--G.SUPPORT_CARD.T.r = 0.2
			G.SUPPORT_CARD.states.click.can = false
			G.SUPPORT_CARD.states.hover.can = false
			G.SUPPORT_CARD.states.collide.can = false
			G.SUPPORT_CARD.states.drag.can = false
			G.SUPPORT_CARD.states.focus.can = false
			G.SUPPORT_CARD.ambient_tilt = 0
			G.SUPPORT_CARD_DARKEN = true
			play_sound(sound)
			return true
		end
	})
	G.E_MANAGER:add_event(Event{
		trigger = 'ease',
		ease = 'lerp',
		delay = 1 * G.SPEEDFACTOR,
		ref_table = G,
		ref_value = "SUPPORT_CARD_FADE",
		ease_to = 0,
		func = function(n)
			return n
		end
	})
	G.E_MANAGER:add_event(Event{
		trigger = 'after',
		delay = 0.75 * G.SPEEDFACTOR,
		func = function()
			G.SUPPORT_CARD_ANIM_ACTIVE = false
			G.SUPPORT_CARD_DARKEN = nil
			G.SUPPORT_CARD:remove()
			return true
		end
	})
end

-- Draw radial gradient and funny fade
local draw_ref = Game.draw
function Game:draw()
	draw_ref(self)
	if not G.SUPPORT_CARD_ANIM_ACTIVE then return end
	local w, h = love.window.getMode()

	-- the radial gradient
	love.graphics.push()
	--love.graphics.scale(G.SUPPORT_CARD_RADIAL_SIZE)
	--love.graphics.translate((w/2)-256, (h/2)-256)
	love.graphics.draw(G.ASSET_ATLAS["payasaka_radial"].image, w/2, h/2, 0, G.SUPPORT_CARD_RADIAL_SIZE, G.SUPPORT_CARD_RADIAL_SIZE, 256, 256)
	love.graphics.pop()

	-- darken background a bit
	if G.SUPPORT_CARD_DARKEN then
		--love.graphics.setColor(0, 0, 0, 0.2)
		--love.graphics.rectangle("fill", 0, 0, w, h)
		if G.SUPPORT_CARD then
			--G.SUPPORT_CARD:draw('card')
			--G.SUPPORT_CARD.children.center:draw_shader('dissolve')
		end
	end
	-- the final fade
	love.graphics.push()
	love.graphics.setColor(1, 1, 1, G.SUPPORT_CARD_FADE)
	love.graphics.rectangle("fill", 0, 0, w, h)
	love.graphics.pop()
end

-- Radial gradient
SMODS.Atlas {
	key = 'radial',
	path = "radial.png",
	px = 512, py = 512
}
