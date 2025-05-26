-- Butcher Vanity
SMODS.Joker {
	name = "Butcher Vanity",
	key = "butcher",
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 6, y = 7 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
	config = { extra = { x_mult_gain = 0.5, x_mult = 1 } },
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			local food_jokers = {}
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] ~= card
					and not G.jokers.cards[i].getting_sliced
					and PTASaka.food_jokers[G.jokers.cards[i].config.center.key]
				then
					food_jokers[#food_jokers + 1] = G.jokers.cards[i]
				end
			end
			if not next(food_jokers) then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						-- This part destroys the card.
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								card.area:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = "Nothing..."
				}
			end
			card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
			local destructable_jokers = PTASaka.FH.filter(food_jokers, function(v)
				return not v.ability.eternal
			end)
			local joker_to_destroy = pseudorandom_element(destructable_jokers, pseudoseed('butcher_vanity'))

			if joker_to_destroy then
				joker_to_destroy.getting_sliced = true
				G.E_MANAGER:add_event(Event({
					func = function()
						(context.blueprint_card or card):juice_up(0.8, 0.8)
						joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
						return true
					end
				}))
			end
			return { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } } }
		end
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.x_mult
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult }
		}
	end
}
