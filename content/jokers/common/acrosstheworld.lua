-- Across the World
SMODS.Joker {
	name = "pta-RRReferenceNo2",
	key = "across_the_world",
	rarity = 1,
	atlas = "JOE_Jokers2",
	pos = { x = 0, y = 8 },
	cost = 8,
	blueprint_compat = false,
	demicoloncompat = false,
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	config = { extra = { odds = 2 } },
	calculate = function(self, card, context)
		if context.starting_shop and not context.blueprint_card then
			local friend = not not SMODS.pseudorandom_probability(card, 'rr', 1, card.ability.extra.odds)
			G.E_MANAGER:add_event(Event{
				func = function()
					local size = pseudorandom_element({ "normal", "jumbo", "mega" },
						'rr_size_' .. G.GAME.round_resets.ante)
					local skin = pseudorandom('rr_skin_' .. G.GAME.round_resets.ante, 1, size == "normal" and 2 or 1)
					SMODS.add_booster_to_shop((friend and 'p_payasaka_friend_' or "p_buffoon_") .. size .. "_" .. skin)
					return true
				end
			})
			return {
				message = "+1 Booster Pack"
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
		info_queue[#info_queue+1] = G.P_CENTERS.p_buffoon_normal_1
		info_queue[#info_queue+1] = G.P_CENTERS.p_payasaka_friend_normal_1
		return { vars = { num, den } }
	end
}
