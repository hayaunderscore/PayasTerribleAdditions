SMODS.ConsumableType {
	key = 'Property',
	collection_rows = {4, 2},
	primary_colour = HEX('AB88C3'),
	secondary_colour = HEX('8967C3'),
	shop_rate = 2,
	loc_txt = {},
	default = "Hiker",
}

SMODS.UndiscoveredSprite {
	key = 'Property',
	atlas = 'JOE_Properties',
	path = 'properties.png',
	pos = { x = 4, y = 1 },
	px = 71, py = 95,
}

G.C.SECONDARY_SET.Property = HEX('8967C3')

SMODS.Consumable {
	set = 'Property',
	key = 'brownproperty',
	atlas = 'JOE_Properties',
	pos = { x = 0, y = 0 },
	config = { extra = { money = 2 } },
	unlocked = true,
	discovered = true,
	can_use = function (self, card)
		return false
	end,
	use = function(self, card, area, copier) end,
	loc_vars = function (self, info_queue, card)
		return {
			vars = { card.ability.extra.money }
		}
	end,
	calc_dollar_bonus = function(self, card)
		return card.ability.extra.money
	end
}

SMODS.Consumable {
	set = 'Property',
	key = 'blueproperty',
	atlas = 'JOE_Properties',
	pos = { x = 1, y = 0 },
	config = { extra = { money = 4, max_highlighted = 1 } },
	unlocked = true,
	discovered = true,
	can_use = function (self, card)
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
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
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
			table.insert(highlighted, v)
		end
		for i=1, #highlighted do
			local percent = 1.15 - (i-0.999)/(#highlighted-0.998)*0.3
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('card1', percent);highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
		delay(0.2)
		for i=1, #highlighted do
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
				local edition = poll_edition('payasaka_blueproperty_edition', nil, Cryptid == nil, true)
				highlighted[i]:set_edition(edition)
				return true
			end}))
		end
		for i=1, #highlighted do
 			local percent = 0.85 + (i-0.999)/(#highlighted-0.998)*0.3
			G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() if highlighted[i].flip then highlighted[i]:flip(); end; play_sound('tarot2', percent, 0.6);highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
	end,
	loc_vars = function (self, info_queue, card)
		for _, thing in pairs(G.P_CENTER_POOLS["Edition"]) do
			info_queue[#info_queue + 1] = thing
		end
		return {
			vars = { card.ability.extra.money, card.ability.max_highlighted }
		}
	end,
	calc_dollar_bonus = function(self, card)
		return card.ability.extra.money
	end
}