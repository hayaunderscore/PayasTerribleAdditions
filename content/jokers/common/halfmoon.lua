SMODS.Joker {
	key = 'halfmoon',
	config = { extra = { hands = 3, amount = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.amount, card.ability.extra.hands } }
	end,
	atlas = "JOE_Jokers2",
	pos = { x = 2, y = 4 },
	rarity = 1,
	blueprint_compat = true,
	demicoloncompat = true,
	pools = {["Joker"] = true, ["Food"] = true},
	calculate = function(self, card, context)
		if context.before then
			SMODS.smart_level_up_hand(card, context.scoring_name, false, card.ability.extra.amount)
			card.ability.extra.hands = card.ability.extra.hands - 1
		end
		if card.ability.extra.hands <= 0 and context.after then
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
							card:remove()
							card = nil
							return true;
						end
					}))
					return true
				end
			}))
			return {
				message = localize('k_eaten_ex')
			}
		end
	end
}
