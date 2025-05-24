SMODS.Joker {
	name = "Battery Acid Spaghetti",
	key = 'btryacidspaghet',
	config = { extra = { xblind = 2.5, decrease = 0.25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xblind, card.ability.extra.xblind*2, card.ability.extra.decrease } }
	end,
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 3, y = 4 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
	pools = {["Joker"] = true, ["Meme"] = true, ["Food"] = true},
	calculate = function(self, card, context)
		if context.setting_blind then
			G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.xblind
		end
		if context.joker_main or context.forcetrigger then
			return {
				xmult = card.ability.extra.xblind*2
			}
		end
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint_card then
			card.ability.extra.xblind = card.ability.extra.xblind - card.ability.extra.decrease
			if card.ability.extra.xblind <= 1 then
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
					message = localize('k_payasaka_bas_eaten')
				}
			end
			return {
				message = localize('k_payasaka_bas_degrade')
			}
		end
	end
}