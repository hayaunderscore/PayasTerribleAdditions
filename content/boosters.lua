-- Miscellaneous Boosters

--#region Friend Packs

PTASaka.make_boosters('friend',
	{
		{ x = 1, y = 5 },
		{ x = 2, y = 5 },
	},
	{
		{ x = 3, y = 5 }
	},
	{
		{ x = 4, y = 5 }
	},
	{
		atlas = "JOE_Risk",
		kind = 'Friend',
		weight = 0.4,
		select_card = 'jokers',
		create_card = function(self, card, i)
			return {
				set = "Friend",
				area = G.pack_cards,
				skip_materialize = true,
				soulable = true,
				key_append = "fren"
			}
		end,
		group_key = 'k_friend_pack',
		ease_background_colour = function(self)
			ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Property)
			ease_background_colour({ new_colour = G.C.SECONDARY_SET.Property, special_colour = G.C.SET.Property, contrast = 2 })
		end,
	}
)

--#endregion

--#region Ultra Booster Packs

---@class UltraParams
---@field key string Key of the booster pack.
---@field atlas? string Atlas key for the booster pack. Defaults to the default Ultra Booster Pack atlas.
---@field pos? table|{x: number, y: number} Position for the atlas. Defaults to 0, 0.
---@field set? string Set for the booster pack. Not used when `create_card` is specified.
---@field colours? table
---@field draw_hand? boolean Whether to draw cards for the booster pack.
---@field kind? string The kind of the booster pack. Defaults to "Ultra".
---@field cost? number Cost of the boost pack on the shop. Defaults to 12.
---@field group_key? string Group key for the booster pack.
---@field key_append? string Seed append for random card.
---@field f_size? number Set size for the booster pack.
---@field f_choose? number Set selection for the booster pack.
---@field additional_size? number Additional size for the booster pack.
---@field additional_choose? number Set selection for the booster pack.
---@field select_card? string String of card area in G, if cards are meant to be saved to an area.
---@field create_card? fun(self: SMODS.Booster|table, card: Card|table, i: number): Card|table Creates the cards inside the booster pack. Returning a table will create a Card through `SMODS.create_card`.

-- Helper for creating Ultra Booster Packs
---@param t UltraParams
---@return SMODS.Booster
function PTASaka.UltraPack(t)
	assert(t, "You have not provided a table!")
	assert(t.key, "You have not provided a key!")
	return SMODS.Booster {
		key = t.key,
		atlas = t.atlas or "JOE_UltraBoosters",
		config = { extra = t.f_size or (7 + (t.additional_size or 0)), choose = t.f_choose or (3 + (t.additional_choose or 0)) },
		pos = t.pos or { x = 0, y = 0 },
		group_key = t.group_key or "",
		weight = 0,
		draw_hand = t.draw_hand or false,
		kind = t.kind or "Ultra",
		cost = t.cost or 12,
		select_card = t.select_card or nil,
		create_card = t.create_card or function(self, card, i)
			return {
				set = t.set,
				area = G.pack_cards,
				skip_materialize = true,
				soulable = true,
				key_append = t
					.key_append or "packut"
			}
		end,
		loc_vars = function(self, info_queue, card)
			local cfg = card.ability or self.config or {}
			return { vars = { cfg.choose, cfg.extra } }
		end,
		ease_background_colour = function(self)
			ease_colour(G.C.DYN_UI.MAIN, t.colours[1] or G.C.BLACK)
			ease_background_colour({ new_colour = t.colours[1] or G.C.BLACK, t.colours[2] or G.C.UI.BACKGROUND_DARK, t
			.colours[3] or 4 })
		end
	}
end

local arcana = PTASaka.UltraPack {
	key = "arcana_ultra",
	pos = { x = 0, y = 0 },
	set = "Tarot",
	group_key = "k_arcana_pack",
	kind = "Arcana",
	draw_hand = true,
	create_card = function(self, card, i)
		local _card
		if G.GAME.used_vouchers.v_omen_globe and pseudorandom('omen_globe') > 0.8 then
			_card = { set = "Spectral", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar2" }
		else
			_card = { set = "Tarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar1" }
		end
		return _card
	end,
}
arcana.ease_background_colour = function(self) ease_background_colour_blind(G.STATES.TAROT_PACK) end
arcana.particles = function(self)
	G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
		timer = 0.015,
		scale = 0.2,
		initialize = true,
		lifespan = 1,
		speed = 1.1,
		padding = -1,
		attach = G.ROOM_ATTACH,
		colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
		fill = true
	})
	G.booster_pack_sparkles.fade_alpha = 1
	G.booster_pack_sparkles:fade(1, 0)
end

local celestial = PTASaka.UltraPack {
	key = "celestial_ultra",
	pos = { x = 1, y = 0 },
	set = "Planet",
	kind = "Celestial",
	group_key = "k_celestial_pack",
	create_card = function(self, card, i)
		local _card
		if G.GAME.used_vouchers.v_telescope and i == 1 then
			local _planet, _hand, _tally = nil, nil, 0
			for k, v in ipairs(G.handlist) do
				if SMODS.is_poker_hand_visible(v) and G.GAME.hands[v].played > _tally then
					_hand = v
					_tally = G.GAME.hands[v].played
				end
			end
			if _hand then
				for k, v in pairs(G.P_CENTER_POOLS.Planet) do
					if v.config.hand_type == _hand then
						_planet = v.key
					end
				end
			end
			_card = {
				set = "Planet",
				area = G.pack_cards,
				skip_materialize = true,
				soulable = true,
				key = _planet,
				key_append =
				"pl1"
			}
		else
			_card = { set = "Planet", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "pl1" }
		end
		return _card
	end,
}
celestial.ease_background_colour = function(self) ease_background_colour_blind(G.STATES.PLANET_PACK) end
celestial.particles = function(self)
	G.booster_pack_stars = Particles(1, 1, 0, 0, {
		timer = 0.07,
		scale = 0.1,
		initialize = true,
		lifespan = 15,
		speed = 0.1,
		padding = -4,
		attach = G.ROOM_ATTACH,
		colours = { G.C.WHITE, HEX('a7d6e0'), HEX('fddca0') },
		fill = true
	})
	G.booster_pack_meteors = Particles(1, 1, 0, 0, {
		timer = 2,
		scale = 0.05,
		lifespan = 1.5,
		speed = 4,
		attach = G.ROOM_ATTACH,
		colours = { G.C.WHITE },
		fill = true
	})
end

local spectral = PTASaka.UltraPack {
	key = "spectral_ultra",
	pos = { x = 2, y = 0 },
	set = "Spectral",
	kind = "Spectral",
	group_key = "k_spectral_pack",
	draw_hand = true,
	f_size = 6, f_choose = 3,
}
spectral.ease_background_colour = function(self) ease_background_colour_blind(G.STATES.SPECTRAL_PACK) end
spectral.particles = function(self)
	G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
		timer = 0.015,
		scale = 0.1,
		initialize = true,
		lifespan = 3,
		speed = 0.2,
		padding = -1,
		attach = G.ROOM_ATTACH,
		colours = { G.C.WHITE, lighten(G.C.GOLD, 0.2) },
		fill = true
	})
	G.booster_pack_sparkles.fade_alpha = 1
	G.booster_pack_sparkles:fade(1, 0)
end

local standard = PTASaka.UltraPack {
	key = "standard_ultra",
	pos = { x = 3, y = 0 },
	group_key = "k_standard_pack",
	kind = "Standard",
	create_card = function(self, card, i)
		local _edition = poll_edition('standard_edition' .. G.GAME.round_resets.ante, 2, true)
		local _seal = SMODS.poll_seal({ mod = 10 })
		return {
			set = (pseudorandom(pseudoseed('stdset' .. G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base",
			edition =
				_edition,
			seal = _seal,
			area = G.pack_cards,
			skip_materialize = true,
			soulable = true,
			key_append = "sta"
		}
	end
}
standard.ease_background_colour = function(self) ease_background_colour_blind(G.STATES.STANDARD_PACK) end
standard.particles = function(self)
	G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
		timer = 0.015,
		scale = 0.3,
		initialize = true,
		lifespan = 3,
		speed = 0.2,
		padding = -1,
		attach = G.ROOM_ATTACH,
		colours = { G.C.BLACK, G.C.RED },
		fill = true
	})
	G.booster_pack_sparkles.fade_alpha = 1
	G.booster_pack_sparkles:fade(1, 0)
end

local buffoon = PTASaka.UltraPack {
	key = "buffoon_ultra",
	pos = { x = 4, y = 0 },
	group_key = "k_buffoon_pack",
	set = "Joker",
	kind = "Buffoon",
	f_size = 6, f_choose = 3,
}
buffoon.ease_background_colour = function(self) ease_background_colour_blind(G.STATES.BUFFOON_PACK) end

--#endregion