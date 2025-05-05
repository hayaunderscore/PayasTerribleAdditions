SMODS.Joker {
	name = "pta-Shotgun",
	key = "shotgun",
	config = {
		extra = { add_xmult = 1, xmult = 1 }
	},
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 1, y = 5 },
	soul_pos = { x = 2, y = 5 },
	cost = 25,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		if context.setting_blind then
			local my_pos = 0
			for i = 1, #G.jokers.cards do
				local _card = G.jokers.cards[i]
				if _card == card then
					my_pos = i
					break
				end
			end
			if G.jokers.cards[my_pos+1] then
				card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.add_xmult
				local _card = G.jokers.cards[my_pos+1]
				card.T.r = -0.2
				card.children.floating_sprite.pinch.x = true
				card:juice_up(0.3, 0.4)
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('payasaka_shotgun', 1, 0.6)
						_card.T.r = -0.2
						_card:juice_up(0.3, 0.4)
						_card.states.drag.is = true
						_card.children.center.pinch.x = true
						-- This part destroys the card.
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(_card)
								_card:remove()
								_card = nil
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = localize('k_upgrade_ex')
				}
			end
		end
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.xmult
			}
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		play_sound('payasaka_shotgun_added', 1, 0.4)
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.add_xmult, card.ability.extra.xmult } }
	end
}