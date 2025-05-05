SMODS.Joker {
	name = "Monster Energy",
	key = 'monster',
	config = { extra = { xmult = 3, decrease = 0.05 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.decrease } }
	end,
	rarity = 1,
	atlas = "JOE_Jokers",
	pos = { x = 5, y = 4 },
	cost = 3,
	blueprint_compat = true,
	demicoloncompat = true,
	pools = {["Joker"] = true, ["Food"] = true},
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not card.payasaka_nonexistent then
			if context.other_card and context.other_card:is_suit("Diamonds") or context.other_card:is_suit("Hearts") then
				card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.decrease
				if card.ability.extra.xmult <= 1 then
					card.payasaka_nonexistent = true
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
									G.jokers:remove_card(card)
									card:remove()
									card = nil
									return true;
								end
							}))
							return true
						end
					}))
					return {
						message = "Drunk!",
						card = card
					}
				end
				return {
					message = "Sip...",
					card = card
				}
			end
		end
		if (context.joker_main or context.forcetrigger) and not card.payasaka_nonexistent then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}