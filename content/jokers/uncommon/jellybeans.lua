SMODS.Joker {
	key = 'jellybeans',
	config = { extra = { cards = 20 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.cards } }
	end,
	atlas = "JOE_Jokers2",
	pos = { x = 1, y = 3 },
	rarity = 2,
	blueprint_compat = true,
	demicoloncompat = true,
	pools = {["Joker"] = true, ["Food"] = true},
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			for i = 1, #G.play.cards do
				---@type Card
				local c = G.play.cards[i]
				c:set_edition(poll_edition('jellybeans', nil, true, true))
				G.E_MANAGER:add_event(Event{
					card:juice_up(0.7)
				})
				card.ability.extra.cards = card.ability.extra.cards - 1
				if card.ability.extra.cards <= 0 then
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
						message = localize('k_eaten_ex')
					}
				end
			end
			return nil, true
		end
	end
}
