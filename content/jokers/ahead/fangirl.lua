SMODS.Joker {
	key = 'fanhead',
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	demicoloncompat = true,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 10, y = 6 },
	atlas = "JOE_Jokers",
	pools = { ["Joker"] = true, ["Meme"] = true },
	config = { extra = { e_chips = 0.04 } },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.other_joker then
			if (context.other_joker:is_ahead() or context.other_joker.ability.payasaka_chip_joker) and context.other_joker ~= card then
				if Talisman then
					return {
						e_chips = ((card.ability.extra.e_chips) * PTASaka.ahead_count) + 1
					}
				else
					-- For now, this'll do...
					return {
						xchips = hand_chips ^ (((card.ability.extra.e_chips) * PTASaka.ahead_count)),
						xchip_message = {
							message = "^" .. ((card.ability.extra.e_chips) * PTASaka.ahead_count) + 1 .. " Chips",
							colour = G.C.DARK_EDITION,
							sound = "payasaka_echips",
							delay = 0.65,
						},
					}
				end
			end
		end
		if context.forcetrigger then
			if Talisman then
				return {
					e_chips = ((card.ability.extra.e_chips) * PTASaka.ahead_count) + 1
				}
			else
				-- For now, this'll do...
				return {
					xchips = hand_chips ^ (((card.ability.extra.e_chips) * PTASaka.ahead_count)),
					xchip_message = {
						message = "^" .. ((card.ability.extra.e_chips) * PTASaka.ahead_count) + 1 .. " Chips",
						colour = G.C.DARK_EDITION,
						sound = "payasaka_echips",
						delay = 0.65,
					},
				}
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.e_chips, PTASaka.ahead_count, card.ability.extra.e_chips * PTASaka.ahead_count }
		}
	end
}
