if PTASaka.Mod.config["Property Cards"] then
	-- The Greed
	SMODS.Consumable {
		set = 'Tarot',
		key = 'greed',
		name = 'Avarice',
		atlas = 'JOE_Tarots',
		pos = { x = 0, y = 0 },
		config = { extra = { max_highlighted = 2 } },
		unlocked = true,
		discovered = true,
		cost = 4,
		pta_credit = {
			art = {
				credit = 'ariyi',
				colour = HEX('09d707')
			},
		},
		can_use = function(self, card)
			local properties = {}
			for _, v in ipairs(G.consumeables.cards) do
				if v.ability.set == 'Property' then
					table.insert(properties, v)
				end
			end
			return #properties > 0
		end,
		in_pool = function(self, args)
			local properties = {}
			for _, v in ipairs(G.consumeables.cards) do
				if v.ability.set == 'Property' then
					table.insert(properties, v)
				end
			end
			return #properties > 0
		end,
		use = function(self, card, area, copier)
			local possible_properties = PTASaka.FH.filter(G.consumeables.cards, function(c)
				return (c and c.ability.set == 'Property')
			end)
			local count = math.min(#possible_properties, card.ability.extra.max_highlighted)
			local highlighted = {}
			while count > 0 do
				local c = table.remove(possible_properties, pseudorandom('avarice', 1, #possible_properties))
				if c then highlighted[#highlighted+1] = c end
				count = count - 1
			end
			for i = 1, #highlighted do
				local percent = 1.15 - (i - 0.999) / (#highlighted - 0.998) * 0.3
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.15,
					func = function()
						if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('card1', percent); highlighted
							[i]
							:juice_up(0.3, 0.3); return true
					end
				}))
			end
			delay(0.2)
			--for i = 1, #highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					for i = 1, #highlighted do
						highlighted[i].ability.house_status = (highlighted[i].ability.house_status or 0)
						highlighted[i].ability.house_status = highlighted[i].ability.house_status + 1
					end
					return true
				end
			}))
			--end
			for i = 1, #highlighted do
				local percent = 0.85 + (i - 0.999) / (#highlighted - 0.998) * 0.3
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.15,
					func = function()
						if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('tarot2', percent, 0.6); highlighted
							[i]:juice_up(0.3, 0.3); return true
					end
				}))
			end
			delay(0.6)
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.2,
				func = function()
					G.consumeables:unhighlight_all(); return true
				end
			}))
		end,
		loc_vars = function(self, info_queue, card)
			local dummy = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
			dummy.vars = { "??", "??" }
			info_queue[#info_queue + 1] = dummy
			return {
				vars = { card.ability.extra.max_highlighted }
			}
		end,
	}

	-- Rotarot version of above, for More Fluff
	if next(SMODS.find_mod("MoreFluff")) and PTASaka.Mod.config["Cross Mod Content"] then
		SMODS.Consumable {
			set = "Rotarot",
			name = "rot_Avarice",
			key = "rot_greed",
			pos = { x = 0, y = 0 },
			atlas = 'JOE_Rotarots',
			config = { extra = { count = 2 } },
			unlocked = true,
			discovered = true,
			display_size = { w = 107, h = 107 },
			dependencies = "MoreFluff",
			pta_credit = {
				art = {
					credit = 'ariyi',
					colour = HEX('09d707')
				},
			},
			can_use = function(self, card)
				return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
			end,
			use = function(self, card, area, copier)
				local used_rotarot = copier or card
				for i = 1, math.min(used_rotarot.ability.extra.count, G.consumeables.config.card_limit - #G.consumeables.cards) do
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.4,
						func = function()
							if G.consumeables.config.card_limit > #G.consumeables.cards then
								play_sound('timpani')
								local _card = create_card("Property", G.consumeables, nil, nil, nil, nil, nil, nil)
								_card:add_to_deck()
								G.consumeables:emplace(_card)
								used_rotarot:juice_up(0.3, 0.5)
							end
							return true
						end
					}))
				end
				delay(0.6)
			end,
			loc_vars = function(self, info_queue, card)
				local dummy = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
				dummy.vars = { "??", "??" }
				info_queue[#info_queue + 1] = dummy
				return { vars = { card.ability.extra.count } }
			end,
		}
	end
end

-- The Stamp
SMODS.Consumable {
	set = 'Tarot',
	key = 'stamp',
	name = 'The Inscribe',
	atlas = 'JOE_Tarots',
	pos = { x = 1, y = 0 },
	config = { extra = { max_highlighted = 2 } },
	unlocked = true,
	discovered = true,
	cost = 4,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	can_use = function(self, card)
		local highlighted = {}
		for _, v in ipairs(G.jokers.highlighted) do
			if v.config.center.key == "j_payasaka_nil" then
				table.insert(highlighted, v)
			end
		end
		return #highlighted ~= 0 and #highlighted <= card.ability.extra.max_highlighted
	end,
	in_pool = function(self, args)
		return next(find_joker("payasaka_nil")) ~= nil
	end,
	use = function(self, card, area, copier)
		local used_tarot = copier or card
		local highlighted = {}
		for _, v in ipairs(G.jokers.highlighted) do
			if v.config.center.key == "j_payasaka_nil" then
				table.insert(highlighted, v)
			end
		end
		for i = 1, math.min(#highlighted, card.ability.extra.max_highlighted) do
			local percent = 1.15 - (i - 0.999) / (#highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('card1', percent); highlighted[i]
						:juice_up(0.3, 0.3); return true
				end
			}))
		end
		delay(0.2)
		--for i = 1, #highlighted do
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.1,
			func = function()
				for i = 1, #highlighted do
					highlighted[i]:remove_from_deck()
					local pool = {}
					for k, v in pairs(G.P_CENTER_POOLS["Joker"]) do
						if
							v.unlocked == true
							and v.rarity
							and (not Cryptid or not Cryptid.no(v, "doe", k))
							and not (G.GAME.banned_keys[v.key] or (G.GAME.cry_banished_keys and G.GAME.cry_banished_keys[v.key]))
						then
							pool[#pool + 1] = v.key
						end
					end
					highlighted[i]:set_ability(pseudorandom_element(pool,
						pseudoseed('payasaka_stamp')))
					highlighted[i]:add_to_deck()
				end
				return true
			end
		}))
		--end
		for i = 1, #highlighted do
			local percent = 0.85 + (i - 0.999) / (#highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('tarot2', percent, 0.6); highlighted
						[i]:juice_up(0.3, 0.3); return true
				end
			}))
		end
		delay(0.6)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.jokers:unhighlight_all(); return true
			end
		}))
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_payasaka_nil
		return {
			vars = { card.ability.extra.max_highlighted }
		}
	end,
}

-- Rotarot version of above, for More Fluff
if next(SMODS.find_mod("MoreFluff")) and PTASaka.Mod.config["Cross Mod Content"] then
	SMODS.Consumable {
		set = "Rotarot",
		name = "rot_Stamp",
		key = "rot_stamp",
		pos = { x = 1, y = 0 },
		atlas = 'JOE_Rotarots',
		config = { extra = { count = 2 } },
		unlocked = true,
		discovered = true,
		display_size = { w = 107, h = 107 },
		dependencies = "MoreFluff",
		pta_credit = {
			art = {
				credit = 'ariyi',
				colour = HEX('09d707')
			},
		},
		can_use = function(self, card)
			return #G.jokers.cards < G.jokers.config.card_limit
		end,
		use = function(self, card, area, copier)
			local used_rotarot = copier or card
			for i = 1, math.min(used_rotarot.ability.extra.count, G.jokers.config.card_limit - #G.jokers.cards) do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						if G.jokers.config.card_limit > #G.jokers.cards then
							play_sound('timpani')
							local _card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_payasaka_nil", nil)
							_card:add_to_deck()
							G.jokers:emplace(_card)
							used_rotarot:juice_up(0.3, 0.5)
						end
						return true
					end
				}))
			end
			delay(0.6)
		end,
		loc_vars = function(self, info_queue, card)
			info_queue[#info_queue + 1] = G.P_CENTERS.j_payasaka_nil
			return { vars = { card.ability.extra.count } }
		end,
	}
end

-- Crack
SMODS.Consumable {
	set = 'Spectral',
	key = 'crack',
	atlas = "JOE_Tarots",
	pos = { x = 2, y = 0 },
	cost = 5,
	config = { max_highlighted = 1, extra = 'payasaka_random', edition = 'e_payasaka_jpeg' },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS[(card.ability or self.config).extra]
		info_queue[#info_queue + 1] = G.P_CENTERS[(card.ability or self.config).edition]
		return { vars = { (card.ability or self.config).max_highlighted } }
	end,
	use = function(self, card, area, copier)
		for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound('tarot1')
					card:juice_up(0.3, 0.5)
					return true
				end
			}))

			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					if pseudorandom('payasaka_random') <= 0.5 and G.hand.highlighted[i].seal ~= 'payasaka_random' then
						G.hand.highlighted[i]:set_seal(card.ability.extra, nil, true)
					else
						G.hand.highlighted[i]:set_edition('e_payasaka_jpeg')
					end
					return true
				end
			}))

			delay(0.5)
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all(); return true
			end
		}))
	end
}

-- Random seal
-- Kinda like portable Rosen in a way
SMODS.Seal {
	key = 'random',
	atlas = "JOE_Enhancements",
	pos = { x = 0, y = 1 },
	config = { x_mult = 2, x_chips = 2, dollars = 8, e_mult = 2, e_chips = 2, extra = { odds = 5 } },
	badge_colour = HEX('f73876'),
	calculate = function(self, card, context)
		local s = card.ability.seal
		local odds = card.ability.cry_rigged and 0.9 or s.extra.odds
		if context.main_scoring and context.cardarea == G.play then
			--print("please")
			return {
				x_mult = SMODS.pseudorandom_probability(card, 'payasaka_random', 1, odds) and s.x_mult or nil,
				xmult_message = {
					message = localize { type = "variable", key = "a_xmult", vars = { s.x_mult } },
					colour =
						G.C.MULT,
					sound = "multhit2"
				} or nil,
				x_chips = SMODS.pseudorandom_probability(card, 'payasaka_random', 1, odds) and s.x_chips or nil,
				xchips_message = {
					message = localize { type = "variable", key = "a_xchips", vars = { s.x_chips } },
					colour =
						G.C.CHIPS,
					sound = "xchips"
				} or nil,
				e_mult = (Talisman and SMODS.pseudorandom_probability(card, 'payasaka_random', 1, odds)) and s
				.e_mult or nil,
				emult_message = Talisman and
					{ message = ("^%d Mult"):format(s.e_mult), colour = G.C.DARK_EDITION, sound = "talisman_emult" } or
					nil,
				e_chips = (Talisman and SMODS.pseudorandom_probability(card, 'payasaka_random', 1, odds)) and
				s.e_chips or nil,
				echip_message = Talisman and
					{ message = ("^%d Chips"):format(s.e_chips), colour = G.C.DARK_EDITION, sound = "talisman_echip" } or
					nil,
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		local s = card.ability.seal
		local num, odds = SMODS.get_probability_vars(card, 1, s.extra.odds)
		info_queue[#info_queue + 1] = {
			key = Talisman and "payasaka_randomeffects_talisman" or "payasaka_randomeffects",
			set =
			"Other",
			vars = { s.dollars, s.x_chips, s.x_mult, s.e_chips, s.e_mult }
		}
		return { vars = { num, odds } }
	end,
	get_p_dollars = function(self, card)
		local s = card.ability.seal
		if SMODS.pseudorandom_probability(card, 'payasaka_random', 1, s.extra.odds) then
			return s.dollars
		end
		return 0
	end
}

-- Mechanic
SMODS.Consumable {
	set = 'Spectral',
	key = 'mechanic',
	atlas = "JOE_Tarots",
	pos = { x = 3, y = 0 },
	cost = 5,
	config = { max_highlighted = 1 },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_payasaka_nil
		return { vars = { (card.ability or self.config).max_highlighted } }
	end,
	can_use = function(self, card)
		local highlighted = {}
		for _, v in ipairs(G.jokers.highlighted) do
			if v.config.center.key == "j_payasaka_nil" then
				table.insert(highlighted, v)
			end
		end
		return #highlighted ~= 0 and #highlighted <= card.ability.max_highlighted
	end,
	in_pool = function(self, args)
		return next(find_joker("payasaka_nil")) ~= nil
	end,
	use = function(self, card, area, copier)
		local highlighted = {}
		for _, v in ipairs(G.jokers.highlighted) do
			if v.config.center.key == "j_payasaka_nil" then
				table.insert(highlighted, v)
			end
		end
		for i = 1, math.min(#highlighted, card.ability.max_highlighted) do
			local percent = 1.15 - (i - 0.999) / (#highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('card1', percent); highlighted[i]
						:juice_up(0.3, 0.3); return true
				end
			}))
		end

		delay(1.2 + (#highlighted * 0.2))

		-- Trigger the Joker collection menu
		G.E_MANAGER:add_event(Event({
			func = function()
				G.SETTINGS.paused = true
				PTASaka.mechanic_menu = true
				G.FUNCS.overlay_menu {
					definition = SMODS.card_collection_UIBox(G.P_CENTER_POOLS.Joker, { 5, 5, 5 }, {
						no_materialize = true,
						h_mod = 0.95,
						back_func = 'exit_overlay_menu',
					})
				}
				PTASaka.mechanic_got_selected = false
				return true
			end
		}))

		-- Exit out when selecting a card
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.OVERLAY_MENU and not PTASaka.mechanic_selected_card then
					return false
				end
				G.SETTINGS.paused = false
				PTASaka.mechanic_menu = false
				return true
			end
		}))

		delay(0.2)
		--for i = 1, #highlighted do
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.1,
			func = function()
				for i = 1, #highlighted do
					if PTASaka.mechanic_got_selected then
						highlighted[i]:remove_from_deck()
						highlighted[i]:set_ability(G.P_CENTERS[PTASaka.mechanic_selected_card])
						highlighted[i]:add_to_deck()
						highlighted[i]:set_eternal(true)
					end
				end
				PTASaka.mechanic_selected_card = nil
				return true
			end
		}))
		--end
		for i = 1, #highlighted do
			local percent = 0.85 + (i - 0.999) / (#highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('tarot2', percent, 0.6); highlighted
						[i]:juice_up(0.3, 0.3); return true
				end
			}))
		end
		delay(0.6)

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.jokers:unhighlight_all(); return true
			end
		}))
	end
}

SMODS.Sound({
	key = "music_mechanic",
	path = "music_mechanic.ogg",
	select_music_track = function()
		return (
			(
				PTASaka.Mod.config["Music"]
				and (PTASaka.mechanic_menu or PTASaka.dos_menu)
				and G.OVERLAY_MENU
			)
		)
	end,
})

local rarities = {
	[1] = "Common",
	[2] = "Uncommon",
	[3] = "Rare",
	[4] = "Legendary"
}

if PTASaka.Mod.config["Ahead"] then
-- Center
SMODS.Consumable {
	set = 'Spectral',
	key = 'center',
	atlas = "JOE_Tarots",
	pos = { x = 0, y = 1 },
	soul_pos = {
		x = 1, y = 1,
		draw = function(self, scale_mod, rotate_mod)
			local scale_mod = 0.05 + 0.05 * math.sin(1.8 * G.TIMERS.REAL) +
				0.07 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) * math.pi * 14) *
				(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
			local rotate_mod = 0.1 * math.sin(1.219 * G.TIMERS.REAL) +
				0.07 * math.sin((G.TIMERS.REAL) * math.pi * 5) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2
			self.children.floating_sprite:draw_shader('dissolve', 0, nil, nil, self.children.center, scale_mod,
				rotate_mod, nil, 0.1 + 0.03 * math.sin(1.8 * G.TIMERS.REAL), nil, 0.6)
			self.children.floating_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod,
				rotate_mod)
		end,
		extra = { x = 2, y = 1 },
	},
	cost = 5,
	config = { max_highlighted = 1 },
	can_use = function(self, card)
		return #G.jokers.highlighted ~= 0 and #G.jokers.highlighted <= card.ability.max_highlighted
	end,
	hidden = true,
	soul_rate = 0.010,
	use = function(self, card, area, copier)
		local highlighted = {}
		for _, v in ipairs(G.jokers.highlighted) do
			table.insert(highlighted, v)
		end
		for i = 1, math.min(#highlighted, card.ability.max_highlighted) do
			local percent = 1.15 - (i - 0.999) / (#highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('card1', percent); highlighted[i]
						:juice_up(0.3, 0.3); return true
				end
			}))
		end
		local valid_daeha = {}
		for k, v in ipairs(G.P_CENTER_POOLS["Joker"]) do
			if type(v.rarity) == "string" and v.rarity == "payasaka_daeha" then
				valid_daeha[#valid_daeha + 1] = v
			end
		end

		delay(0.2)

		--for i = 1, #highlighted do
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.1,
			func = function()
				for i = 1, #highlighted do
					for k, v in pairs(highlighted[i].children) do
						if k == 'center' or k == 'back' then goto continue end
						highlighted[i].children[k]:remove()
						highlighted[i].children[k] = nil
						::continue::
					end
					highlighted[i]:remove_from_deck(true)
					highlighted[i].debuff = false
					highlighted[i]:set_ability(pseudorandom_element(valid_daeha, pseudoseed('center_shit')))
					highlighted[i]:add_to_deck(true)
				end
				return true
			end
		}))
		--end
		for i = 1, #highlighted do
			local percent = 0.85 + (i - 0.999) / (#highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('tarot2', percent, 0.6); highlighted
						[i]:juice_up(0.3, 0.3); return true
				end
			}))
		end
		delay(0.6)

		for i = 1, #G.jokers.cards do
			local joker = G.jokers.cards[i]
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					if not joker.highlighted then
						local fake = SMODS.create_card {
							set = "Joker",
							rarity = type(joker.config.center.rarity) == "number" and rarities[joker.config.center.rarity] or joker.config.center.rarity,
							legendary = joker.config.center.rarity == 4
						}
						for k, v in pairs(joker.children) do
							if k == 'center' or k == 'back' then goto continue end
							joker.children[k]:remove()
							joker.children[k] = nil
							::continue::
						end
						joker:remove_from_deck(true)
						joker:set_ability(G.P_CENTERS[fake.config.center.key])
						joker:add_to_deck(true)
						fake:remove()
						joker:juice_up()
						play_sound('timpani')
					end
					return true
				end
			}))
		end

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.jokers:unhighlight_all(); return true
			end
		}))
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.max_highlighted } }
	end
}
end
