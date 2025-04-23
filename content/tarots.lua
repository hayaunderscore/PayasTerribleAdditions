if PTASaka.Mod.config["Property Cards"] then
-- The Greed
SMODS.Consumable {
	set = 'Tarot',
	key = 'greed',
	atlas = 'JOE_Tarots',
	pos = { x = 0, y = 0 },
	config = { extra = { max_highlighted = 2 } },
	unlocked = true,
	discovered = true,
	cost = 4,
	can_use = function(self, card)
		local highlighted = {}
		for _, v in ipairs(G.consumeables.highlighted) do
			if v ~= card and v.ability.set == 'Property' then
				table.insert(highlighted, v)
			end
		end
		return #highlighted ~= 0 and #highlighted <= card.ability.extra.max_highlighted
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
		local used_tarot = copier or card
		local highlighted = {}
		for _, v in ipairs(G.consumeables.highlighted) do
			if v ~= card and v.ability.set == 'Property' then
				table.insert(highlighted, v)
			end
		end
		for i = 1, #highlighted do
			local percent = 1.15 - (i - 0.999) / (#highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
				if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('card1', percent); highlighted[i]
					:juice_up(0.3, 0.3); return true
			end }))
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
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
				if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('tarot2', percent, 0.6); highlighted
					[i]:juice_up(0.3, 0.3); return true
			end }))
		end
		delay(0.6)
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.consumeables:unhighlight_all(); return true end }))
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.max_highlighted }
		}
	end,
}

-- Rotarot version of above, for More Fluff
if next(SMODS.find_mod("MoreFluff")) and PTASaka.Mod.config["Cross Mod Content"] then
	SMODS.Consumable {
		set = "Rotarot",
		name = "rot_Greed",
		key = "rot_greed",
		pos = { x = 0, y = 0 },
		atlas = 'JOE_Rotarots',
		config = { extra = { count = 2 } },
		unlocked = true,
		discovered = true,
		display_size = { w = 107, h = 107 },
		dependencies = "MoreFluff",
		can_use = function(self, card)
			return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
		end,
		use = function(self, card, area, copier)
			local used_rotarot = copier or card
			for i = 1, math.min(used_rotarot.ability.extra.count, G.consumeables.config.card_limit - #G.consumeables.cards) do
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
					if G.consumeables.config.card_limit > #G.consumeables.cards then
						play_sound('timpani')
						local _card = create_card("Property", G.consumeables, nil, nil, nil, nil, nil, nil)
						_card:add_to_deck()
						G.consumeables:emplace(_card)
						used_rotarot:juice_up(0.3, 0.5)
					end
				return true end }))
			end
			delay(0.6)
		end,
		loc_vars = function(self, info_queue, card)
			info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
			return { vars = { card.ability.extra.count } }
		end,
	}
	end
end

-- The Stamp
SMODS.Consumable {
	set = 'Tarot',
	key = 'stamp',
	atlas = 'JOE_Tarots',
	pos = { x = 1, y = 0 },
	config = { extra = { max_highlighted = 2 } },
	unlocked = true,
	discovered = true,
	cost = 4,
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
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
				if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('card1', percent); highlighted[i]
					:juice_up(0.3, 0.3); return true
			end }))
		end
		delay(0.2)
		--for i = 1, #highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					for i = 1, #highlighted do
						highlighted[i]:remove_from_deck()
						highlighted[i]:set_ability(pseudorandom_element(G.P_CENTER_POOLS["Joker"], pseudoseed('payasaka_stamp')))
						highlighted[i]:add_to_deck()
					end
					return true
				end
			}))
		--end
		for i = 1, #highlighted do
			local percent = 0.85 + (i - 0.999) / (#highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
				if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('tarot2', percent, 0.6); highlighted
					[i]:juice_up(0.3, 0.3); return true
			end }))
		end
		delay(0.6)
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.jokers:unhighlight_all(); return true end }))
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.j_payasaka_nil
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
		can_use = function(self, card)
			return #G.jokers.cards < G.jokers.config.card_limit
		end,
		use = function(self, card, area, copier)
			local used_rotarot = copier or card
			for i = 1, math.min(used_rotarot.ability.extra.count, G.jokers.config.card_limit - #G.jokers.cards) do
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
					if G.jokers.config.card_limit > #G.jokers.cards then
						play_sound('timpani')
						local _card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_payasaka_nil", nil)
						_card:add_to_deck()
						G.jokers:emplace(_card)
						used_rotarot:juice_up(0.3, 0.5)
					end
				return true end }))
			end
			delay(0.6)
		end,
		loc_vars = function(self, info_queue, card)
			info_queue[#info_queue+1] = G.P_CENTERS.j_payasaka_nil
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
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_SEALS[(card.ability or self.config).extra]
		info_queue[#info_queue+1] = G.P_CENTERS[(card.ability or self.config).edition]
		return {vars = {(card.ability or self.config).max_highlighted}}
	end,
	use = function(self, card, area, copier)
		for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
			G.E_MANAGER:add_event(Event({func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true end }))
			
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
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
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
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
				x_mult = pseudorandom("payasaka_random") < G.GAME.probabilities.normal/odds and s.x_mult or nil,
				xmult_message = {message = localize{ type = "variable", key = "a_xmult", vars = { s.x_mult } }, colour = G.C.MULT, sound = "multhit2"} or nil,
				x_chips = pseudorandom("payasaka_random") < G.GAME.probabilities.normal/odds and s.x_chips or nil,
				xchips_message = {message = localize{ type = "variable", key = "a_xchips", vars = { s.x_chips } }, colour = G.C.CHIPS, sound = "xchips"} or nil,
				e_mult = pseudorandom("payasaka_random") < G.GAME.probabilities.normal/odds and s.e_mult or nil,
				emult_message = Talisman and {message = ("^%d Mult"):format(s.e_mult), colour = G.C.DARK_EDITION, sound = "talisman_emult"} or nil,
				e_chips = pseudorandom("payasaka_random") < G.GAME.probabilities.normal/odds and s.e_chips or nil,
				echip_message = Talisman and {message = ("^%d Chips"):format(s.e_chips), colour = G.C.DARK_EDITION, sound = "talisman_echip"} or nil,
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		local s = card.ability.seal
		local odds = card.ability.cry_rigged and 0.9 or s.extra.odds
		info_queue[#info_queue+1] = { key = Talisman and "payasaka_randomeffects_talisman" or "payasaka_randomeffects", set = "Other", vars = { s.dollars, s.x_chips, s.x_mult, s.e_chips, s.e_mult } }
		return { vars = { G.GAME.probabilities.normal, odds } }
	end,
	get_p_dollars = function(self, card)
		local s = card.ability.seal
		local odds = card.ability.cry_rigged and 0.9 or s.extra.odds
		if pseudorandom("payasaka_random") < G.GAME.probabilities.normal/odds then
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
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.j_payasaka_nil
		return {vars = {(card.ability or self.config).max_highlighted}}
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
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
				if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('card1', percent); highlighted[i]
					:juice_up(0.3, 0.3); return true
			end }))
		end

		-- Trigger the Joker collection menu
		G.E_MANAGER:add_event(Event({
			func = function()
				G.FUNCS.your_collection_jokers(nil)
				G.SETTINGS.paused = true
				PTASaka.mechanic_menu = true
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
						highlighted[i]:remove_from_deck()
						highlighted[i]:set_ability(G.P_CENTERS[PTASaka.mechanic_selected_card])
						highlighted[i]:add_to_deck()
					end
					PTASaka.mechanic_selected_card = nil
					return true
				end
			}))
		--end
		for i = 1, #highlighted do
			local percent = 0.85 + (i - 0.999) / (#highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
				if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('tarot2', percent, 0.6); highlighted
					[i]:juice_up(0.3, 0.3); return true
			end }))
		end
		delay(0.6)

		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.jokers:unhighlight_all(); return true end }))
	end
}

-- Hook onto Card:click for mechanic menu
local old_click = Card.click
function Card:click()
	old_click(self)
	if self.area and PTASaka.mechanic_menu then
		PTASaka.mechanic_selected_card = self.config.center.key
		PTASaka.mechanic_got_selected = true
		G.FUNCS.exit_overlay_menu()
	end
end

-- Mechanic doesn't disintegrate when used without selecting a joker
local old_start_dissolve = Card.start_dissolve
function Card:start_dissolve(c, s, t, j)
	if not PTASaka.mechanic_got_selected and self.config.center.key == "c_payasaka_mechanic" then
		draw_card(G.play, G.consumeables, 1, 'up', true, self, nil, true)
		return
	end
	return old_start_dissolve(self, c, s, t, j)
end