SMODS.ConsumableType {
	key = 'Property',
	collection_rows = { 4, 4 },
	primary_colour = HEX('AB88C3'),
	secondary_colour = HEX('8967C3'),
	shop_rate = 0.1,
	default = "c_payasaka_brownproperty",
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
	calculate = function(self, card, context)
		if context.before and card.config.center.key ~= "c_payasaka_niyaniya" then
			if (next(context.poker_hands[card.ability.extra.poker_hand]) and card.config.center.key ~= "c_payasaka_brownproperty")
				or (context.scoring_hand == card.ability.extra.poker_hand and card.config.center.key == "c_payasaka_brownproperty") then
				card.ability.extra.money = card.ability.extra.money + card.ability.extra.gain
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.MONEY
				}
			end
		end
		if context.joker_main then
			return {
				mult = G.GAME.payasaka_monopolizer_mult,
				x_mult = G.GAME.payasaka_monopolizer_x_mult
			}
		end
	end,
	can_use = function(self, card)
		return false
	end,
	in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end,
	calc_dollar_bonus = function(self, card)
		return card.ability.extra.money + ((card.ability.house_status or 0) * (card.ability.extra.money/2))
	end
}

PTASaka.Property {
	key = 'brownproperty',
	atlas = 'JOE_Properties',
	pos = { x = 0, y = 0 },
	config = { extra = { money = 2, gain = 2, poker_hand = "High Card" } },
	unlocked = true,
	discovered = true,
	can_use = function(self, card)
		return false
	end,
	cost = 4,
	use = function(self, card, area, copier) end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.money, card.ability.extra.gain, card.ability.extra.poker_hand }
		}
	end,
}

PTASaka.Property {
	key = 'blueproperty',
	atlas = 'JOE_Properties',
	pos = { x = 1, y = 0 },
	config = { extra = { money = 4, gain = 2, poker_hand = "Pair", max_highlighted = 1 } },
	unlocked = true,
	discovered = true,
	cost = 8,
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
			vars = { card.ability.extra.money, card.ability.extra.gain, card.ability.extra.poker_hand, card.ability.extra.max_highlighted }
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
	config = { extra = { money = 6, gain = 4, poker_hand = "Two Pair", food = 1 } },
	unlocked = true,
	discovered = true,
	cost = 12,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		-- myeah
		for i = 1, card.ability.extra.food do
			SMODS.add_card { set = "Food" }
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.money, card.ability.extra.gain, card.ability.extra.poker_hand, card.ability.extra.food }
		}
	end,
}

PTASaka.Property {
	key = 'orangeproperty',
	atlas = 'JOE_Properties',
	pos = { x = 3, y = 0 },
	config = { extra = { money = 8, gain = 8, poker_hand = "Three of a Kind", tarots = 1 } },
	unlocked = true,
	discovered = true,
	cost = 16,
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
			vars = { card.ability.extra.money, card.ability.extra.gain, card.ability.extra.poker_hand, card.ability.extra.tarots }
		}
	end,
}

PTASaka.Property {
	key = 'redproperty',
	atlas = 'JOE_Properties',
	pos = { x = 4, y = 0 },
	config = { extra = { money = 10, gain = 10, poker_hand = "Straight" } },
	unlocked = true,
	discovered = true,
	cost = 20,
	hidden = true,
	soul_set = 'Property',
	soul_rate = 0.1,
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
			vars = { card.ability.extra.money, card.ability.extra.gain, card.ability.extra.poker_hand }
		}
	end,
}

PTASaka.Property {
	key = 'yellowproperty',
	atlas = 'JOE_Properties',
	pos = { x = 5, y = 0 },
	config = { extra = { money = 12, gain = 12, poker_hand = "Flush", levels = 2 } },
	unlocked = true,
	discovered = true,
	cost = 24,
	hidden = true,
	soul_set = 'Property',
	soul_rate = 0.1,
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
		update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(_hand, 'poker_hands'),chips = G.GAME.hands[_hand].chips, mult = G.GAME.hands[_hand].mult, level=G.GAME.hands[_hand].level})
		level_up_hand(copier or card, _hand, false, card.ability.extra.levels)
		update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.money, card.ability.extra.gain, card.ability.extra.poker_hand, card.ability.extra.levels }
		}
	end,
}

PTASaka.Property {
	key = 'greenproperty',
	atlas = 'JOE_Properties',
	pos = { x = 0, y = 1 },
	config = { extra = { money = 12, gain = 16, poker_hand = "Four of a Kind" } },
	unlocked = true,
	discovered = true,
	cost = 24,
	hidden = true,
	soul_set = 'Property',
	soul_rate = 0.01,
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
			vars = { card.ability.extra.money, card.ability.extra.gain, card.ability.extra.poker_hand }
		}
	end,
}

PTASaka.Property {
	key = 'darkblueproperty',
	atlas = 'JOE_Properties',
	pos = { x = 1, y = 1 },
	config = { extra = { money = 20, gain = 20, poker_hand = "Full House" } },
	unlocked = true,
	discovered = true,
	hidden = true,
	soul_set = 'Property',
	soul_rate = 0.01,
	cost = 40,
	can_use = function(self, card)
		return false
	end,
	use = function(self, card, area, copier)
		
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_property_card"]
		return {
			vars = { card.ability.extra.money, card.ability.extra.gain, card.ability.extra.poker_hand }
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
	calculate = function (self, card, context)
		if context.end_of_round and not context.game_over and context.cardarea == G.jokers then
			card.ability.extra.money = card.ability.extra.money + card.ability.extra.gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MONEY
			}
		end
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
PTASaka.make_boosters('property',
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
		atlas = 'JOE_Boosters',
		kind = 'Property',
		weight = 0.7,
		select_card = 'consumeables',
		allow_duplicates = true,
		create_card = function(self, card, i)
			return create_card("Property", G.pack_cards, nil, nil, true, true, nil)
		end,
		in_pool = function(self, args)
			return true, { allow_duplicates = true }
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
					PTASaka.Mod.config["Music"]
					and booster_obj
					and booster_obj.group_key
					and booster_obj.group_key == 'k_property_pack'
				)
			)
	end,
})