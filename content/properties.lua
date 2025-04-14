SMODS.ConsumableType {
	key = 'Property',
	collection_rows = { 4, 4 },
	primary_colour = HEX('AB88C3'),
	secondary_colour = HEX('8967C3'),
	shop_rate = 0.1,
	loc_txt = {},
}

SMODS.UndiscoveredSprite {
	key = 'Property',
	atlas = 'JOE_Properties',
	path = 'properties.png',
	pos = { x = 4, y = 1 },
	px = 71, py = 95,
}

G.C.SET.Property = HEX('AB88C3')
G.C.SECONDARY_SET.Property = HEX('8967C3')

-- Base
PTASaka.Property = SMODS.Consumable:extend {
	set = 'Property',
	atlas = 'JOE_Properties',
	required_params = {
		'key',
		'config'
	},
	can_use = function(self, card)
		return false
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
		-- update soul_parts
		if not card.children.soul_parts then
			card.children.soul_parts = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, card.children.center.atlas, { x = 0, y = 2 })
			card.children.soul_parts.role.draw_major = card
			card.children.soul_parts.states.hover.can = false
			card.children.soul_parts.states.click.can = false
		end
		if card.children.soul_parts then
			-- update position
			card.children.soul_parts.T.y = card.T.y
			card.children.soul_parts.T.x = card.T.x
			card.children.soul_parts.T.r = card.T.r
			card.children.soul_parts:set_sprite_pos({ x = math.min((card.ability.extra.house_status or 0), 5), y = 2 })
			-- draw it
			card.children.soul_parts:draw_shader('dissolve', 0, nil, nil, card.children.center)
			card.children.soul_parts:draw_shader('dissolve', nil, nil, nil, card.children.center)
		end
	end,
	calc_dollar_bonus = function(self, card)
		if card.ability.extra.gain then
			card.ability.extra.money = card.ability.extra.money + card.ability.extra.gain
		end
		return card.ability.extra.money + ((card.ability.extra.house_status or 0) * (card.ability.extra.money/2))
	end
}

SMODS.Consumable {
	set = 'Tarot',
	key = 'greed',
	atlas = 'JOE_Properties',
	pos = { x = 5, y = 1 },
	config = { extra = { max_highlighted = 2 } },
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		local highlighted = {}
		for _, v in ipairs(G.consumeables.highlighted) do
			if v ~= card and v.ability.set == 'Property' then
				table.insert(highlighted, v)
			end
		end
		return #highlighted ~= 0 and #highlighted <= card.ability.extra.max_highlighted
	end,
	use = function(self, card, area, copier)
		local used_tarot = copier or card
		local highlighted = {}
		for _, v in ipairs(G.consumeables.highlighted) do
			if v ~= card and v.ability.set == 'Property' then
				table.insert(highlighted, v)
			end
		end
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
			play_sound('timpani')
            for i = 1, #highlighted do
				highlighted[i].ability.extra.house_status = (highlighted[i].ability.extra.house_status or 0)
				highlighted[i].ability.extra.house_status = highlighted[i].ability.extra.house_status + 1
			end
			used_tarot:juice_up(0.3, 0.5)
			return true end }))
		delay(0.6)
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.max_highlighted }
		}
	end,
}

PTASaka.Property {
	key = 'brownproperty',
	atlas = 'JOE_Properties',
	pos = { x = 0, y = 0 },
	config = { extra = { money = 2 } },
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		return false
	end,
	use = function(self, card, area, copier) end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.money }
		}
	end,
}

PTASaka.Property {
	key = 'blueproperty',
	atlas = 'JOE_Properties',
	pos = { x = 1, y = 0 },
	config = { extra = { money = 4, max_highlighted = 1 } },
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		local highlighted = PTASaka.shallow_copy(G.hand.highlighted) or {}
		for _, v in ipairs(G.jokers.highlighted) do
			table.insert(highlighted, v)
		end
		for _, v in ipairs(G.consumeables.highlighted) do
			if v ~= card then
				table.insert(highlighted, v)
			end
		end
		return #highlighted == card.ability.extra.max_highlighted
	end,
	use = function(self, card, area, copier)
		local used_card = copier or card
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('tarot1')
				used_card:juice_up(0.3, 0.5)
				return true
			end
		}))
		local highlighted = PTASaka.shallow_copy(G.hand.highlighted)
		for _, v in ipairs(G.jokers.highlighted) do
			table.insert(highlighted, v)
		end
		for _, v in ipairs(G.consumeables.highlighted) do
			if v ~= card then
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
		for i = 1, #highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					local edition = poll_edition('payasaka_blueproperty_edition', nil, Cryptid == nil, true)
					highlighted[i]:set_edition(edition)
					return true
				end
			}))
		end
		for i = 1, #highlighted do
			local percent = 0.85 + (i - 0.999) / (#highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
				if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('tarot2', percent, 0.6); highlighted
					[i]:juice_up(0.3, 0.3); return true
			end }))
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		for _, thing in pairs(G.P_CENTER_POOLS["Edition"]) do
			info_queue[#info_queue + 1] = thing
		end
		return {
			vars = { card.ability.extra.money, card.ability.extra.max_highlighted }
		}
	end,
}

-- Food pool
-- Already used by Cryptid, only here if Cryptid is not available....
if not G.P_CENTER_POOLS["Food"] then
	SMODS.ObjectType {
		key = "Food",
		default = "j_gros_michel",
		cards = {},
		inject = function(self)
			SMODS.ObjectType.inject(self)
			-- insert base game food jokers
			self:inject_card(G.P_CENTERS.j_gros_michel)
			self:inject_card(G.P_CENTERS.j_egg)
			self:inject_card(G.P_CENTERS.j_ice_cream)
			self:inject_card(G.P_CENTERS.j_cavendish)
			self:inject_card(G.P_CENTERS.j_turtle_bean)
			self:inject_card(G.P_CENTERS.j_diet_cola)
			self:inject_card(G.P_CENTERS.j_popcorn)
			self:inject_card(G.P_CENTERS.j_ramen)
			self:inject_card(G.P_CENTERS.j_selzer)
		end,
	}
end

PTASaka.Property {
	key = 'pinkproperty',
	atlas = 'JOE_Properties',
	pos = { x = 2, y = 0 },
	config = { extra = { money = 6 } },
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		-- myeah
		SMODS.add_card { set = "Food" }
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.money }
		}
	end,
}

PTASaka.Property {
	key = 'orangeproperty',
	atlas = 'JOE_Properties',
	pos = { x = 3, y = 0 },
	config = { extra = { money = 8, gain = 1 } },
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		-- myeah
		SMODS.add_card { set = "Tarot" }
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.money, card.ability.extra.gain }
		}
	end,
}

PTASaka.Property {
	key = 'redproperty',
	atlas = 'JOE_Properties',
	pos = { x = 4, y = 0 },
	config = { extra = { money = 10, gain = 2 } },
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local card = create_card("Joker", G.jokers, false, 3, nil, nil, nil)
		card:add_to_deck()
		G.jokers:emplace(card)
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.money, card.ability.extra.gain }
		}
	end,
}

PTASaka.Property {
	key = 'yellowproperty',
	atlas = 'JOE_Properties',
	pos = { x = 5, y = 0 },
	config = { extra = { money = 12, gain = 2, levels = 5 } },
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		-- mostly taken from cryptid for this part specifically
		local _hand, _tally = nil, -1
		for k, v in ipairs(G.handlist) do
			if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
				_hand = v
				_tally = G.GAME.hands[v].played
			end
		end
		level_up_hand(copier or card, _hand, false, card.ability.extra.levels)
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.money, card.ability.extra.gain, card.ability.extra.levels }
		}
	end,
}

PTASaka.Property {
	set = 'Property',
	key = 'greenproperty',
	atlas = 'JOE_Properties',
	pos = { x = 0, y = 1 },
	config = { extra = { money = 12, gain = 4 } },
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		-- myeah
		local card = create_card("Joker", G.jokers, true, 4, nil, nil, nil)
		card:add_to_deck()
		G.jokers:emplace(card)
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.money, card.ability.extra.gain }
		}
	end,
}

PTASaka.Property {
	set = 'Property',
	key = 'darkblueproperty',
	atlas = 'JOE_Properties',
	pos = { x = 1, y = 1 },
	config = { extra = { money = 20, gain = 10 } },
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_set = 'Property',
	soul_rate = 0.01,
	can_use = function(self, card)
		return false
	end,
	use = function(self, card, area, copier)
		
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.money, card.ability.extra.gain }
		}
	end,
}

PTASaka.Property {
	set = 'Property',
	key = 'niyaniya',
	atlas = 'JOE_Properties',
	pos = { x = 2, y = 1 },
	soul_pos = { x = 3, y = 1 },
	config = { extra = { money = 50, gain = 50 } },
	unlocked = false,
	discovered = false,
	hidden = true,
	soul_set = 'Property',
	soul_rate = 0.003,
	can_use = function(self, card)
		return false
	end,
	use = function(self, card, area, copier) end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.money, card.ability.extra.gain }
		}
	end,
}

if not IncantationAddons then
	IncantationAddons = {
		Stacking = {},
		Dividing = {},
		BulkUse = {},
		StackingIndividual = {},
		DividingIndividual = {},
		BulkUseIndividual = {},
		MassUse = {},
		MassUseIndividual = {}
	}
end

IncantationAddons.Stacking[#IncantationAddons.Stacking + 1] = 'Property'
IncantationAddons.Dividing[#IncantationAddons.Stacking + 1] = 'Property'

-- Booster packs....
StrangeLib.make_boosters('property',
	{
		{ x = 0, y = 0 },
		{ x = 1, y = 0 },
	},
	{
		{ x = 0, y = 2 },
		{ x = 1, y = 2 },
	},
	{
		{ x = 0, y = 1 },
		{ x = 1, y = 1 },
	},
	{
		atlas = 'JOE_Properties_Boosters',
		kind = 'Property',
		weight = 0.7,
		select_card = 'consumeables',
		create_card = function(self, card, i)
			return create_card("Property", G.pack_cards, nil, nil, true, true, nil)
		end,
		group_key = 'k_property_pack',
		ease_background_colour = function(self)
			ease_colour(G.C.DYN_UI.MAIN, G.C.SECONDARY_SET.Property)
			ease_background_colour({ new_colour = G.C.SECONDARY_SET.Property, special_colour = G.C.SET.Property, contrast = 2 })
		end,
	}
)

SMODS.Sound({
	key = "music_property",
	path = "music_property.ogg",
	select_music_track = function()
		return (
				(
					G.pack_cards
					and G.pack_cards.cards
					and G.pack_cards.cards[1]
					and G.pack_cards.cards[1].ability.set == "Property"
				)
			)
	end,
})