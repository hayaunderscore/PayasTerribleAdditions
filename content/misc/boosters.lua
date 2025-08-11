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
		weight = 0,
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
			ease_colour(G.C.DYN_UI.MAIN, G.C.BLUE)
			ease_background_colour({ new_colour = G.C.RED, special_colour = G.C.BLUE, contrast = 2 })
		end,
	}, 2
)

PTASaka.make_boosters('voucher',
	{
		{ x = 2, y = 0, cost = 10 },
	},
	{
		{ x = 2, y = 1, cost = 18 }
	},
	{},
	{
		atlas = "JOE_Boosters",
		kind = 'Voucher',
		weight = 0,
		create_card = function(self, card, i)
			return {
				set = "Voucher",
				area = G.pack_cards,
				skip_materialize = true,
				soulable = true,
				key_append = "vouch"
			}
		end,
		update_pack = function(self, dt)
			SMODS.Booster.update_pack(self, dt)
			if SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.ability and SMODS.OPENED_BOOSTER.ability.old_voucher then
				if G.GAME.current_round.voucher and G.GAME.current_round.voucher.spawn then
					G.GAME.current_round.voucher.spawn[SMODS.OPENED_BOOSTER.ability.old_voucher] = false
				end
			end
		end,
		group_key = 'k_voucher_pack',
		ease_background_colour = function(self)
			ease_colour(G.C.DYN_UI.MAIN, G.C.BLUE)
			ease_background_colour({ new_colour = G.C.RED, special_colour = G.C.BLUE, contrast = 2 })
		end,
	}
)

--#endregion

--#region Ultra Booster Packs

PTASaka.UltraPack {
	key = "arcana_ultra",
	pos = { x = 0, y = 0 },
	group_key = "k_arcana_pack",
	kind = "Arcana",
	draw_hand = true,
	atlas = "JOE_UltraBoosters",
	create_card = function(self, card, i)
		local _card
		if G.GAME.used_vouchers.v_omen_globe and pseudorandom('omen_globe') > 0.8 then
			_card = { set = "Spectral", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar2" }
		else
			_card = { set = "Tarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar1" }
		end
		return _card
	end,
	ease_background_colour = function(self) ease_background_colour_blind(G.STATES.TAROT_PACK) end,
	particles = function(self)
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
}

PTASaka.UltraPack {
	key = "celestial_ultra",
	pos = { x = 1, y = 0 },
	kind = "Celestial",
	group_key = "k_celestial_pack",
	atlas = "JOE_UltraBoosters",
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
	ease_background_colour = function(self) ease_background_colour_blind(G.STATES.PLANET_PACK) end,
	particles = function(self)
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
}

PTASaka.UltraPack {
	key = "spectral_ultra",
	pos = { x = 2, y = 0 },
	pack_set = "Spectral",
	kind = "Spectral",
	group_key = "k_spectral_pack",
	draw_hand = true,
	f_size = 6, f_choose = 3,
	atlas = "JOE_UltraBoosters",
	ease_background_colour = function(self) ease_background_colour_blind(G.STATES.SPECTRAL_PACK) end,
	particles = function(self)
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
}

PTASaka.UltraPack {
	key = "standard_ultra",
	pos = { x = 3, y = 0 },
	group_key = "k_standard_pack",
	kind = "Standard",
	atlas = "JOE_UltraBoosters",
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
	end,
	ease_background_colour = function(self) ease_background_colour_blind(G.STATES.STANDARD_PACK) end,
		particles = function(self)
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
}

PTASaka.UltraPack {
	key = "buffoon_ultra",
	pos = { x = 4, y = 0 },
	group_key = "k_buffoon_pack",
	pack_set = "Joker",
	kind = "Buffoon",
	f_size = 6, f_choose = 3,
	atlas = "JOE_UltraBoosters",
	ease_background_colour = function(self) ease_background_colour_blind(G.STATES.BUFFOON_PACK) end
}

if PTASaka.is_cryptid then
	PTASaka.UltraPack {
		key = "code_ultra",
		atlas = "JOE_UltraBoosters",
		pos = { x = 6, y = 0 },
		group_key = "k_cry_program_pack",
		pack_set = "Code",
		kind = "Code",
		f_size = 6, f_choose = 3,
		dependencies = "Cryptid",
		ease_background_colour = function(self)
			ease_colour(G.C.DYN_UI.MAIN, G.C.SET.Code)
			ease_background_colour({ new_colour = G.C.SET.Code, special_colour = G.C.BLACK, contrast = 2 })
		end,
	}
end

--#endregion