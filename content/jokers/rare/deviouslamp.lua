-- Devious Lamp
SMODS.Joker {
	name = "Devious Lamp",
	key = "deviouslamp",
	rarity = 3,
	atlas = "JOE_Jokers2",
	pos = { x = 2, y = 3 },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = false,
	config = { extra = { xvalue = 1.5 } },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.after and (G.GAME.chips + PTASaka.arrow(G.GAME.payasaka_exponential_count, hand_chips, mult)) >= G.GAME.blind.chips then
			local juice = context.blueprint_card or card
			for i = 1, #context.scoring_hand do
				---@type Card
				local c = context.scoring_hand[i]
				if not c.shattered then
					PTASaka.Misprintize({
						val = c.ability,
						amt = card.ability.extra.xvalue,
						blacklist_key = function(k, v, l)
							if l == 1 and v == 1 then
								if string.find(k, "x_") or string.find(k, "e_") or string.find(k, "ee_") or string.find(k, "eee_") or string.find(k, "hyper_") then
									return false
								end
							end
							return true
						end
					})
					G.E_MANAGER:add_event(Event{
						trigger = 'after',
						delay = 0.15,
						func = function()
							juice:juice_up(0.7)
							card_eval_status_text(c, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex'), instant = true })
							return true
						end
					})
				end
			end
			delay(0.15)
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xvalue } }
	end
}
