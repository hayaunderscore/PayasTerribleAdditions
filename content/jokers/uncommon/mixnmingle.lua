local function determine_distance(item, i, arr2)
	-- find this item forwards
	for j = 1, #arr2 do
		if arr2[j] == item then
			return math.abs(j-i)
		end
	end
	-- find this item backwards
	for j = #arr2, 1, -1 do
		if arr2[j] == item then
			return math.abs(j-i)
		end
	end
end

SMODS.Joker {
	name = "pta-MixAndMingle",
	key = "mixnmingle",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 4, y = 5 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = false,
	config = { extra = { xmult_gain = 0.02, xmult = 1 } },
	--[[
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	]]
	loc_vars = function (self, info_queue, card)
		return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.press_play then
			G.E_MANAGER:add_event(Event{
				func = function()
					-- get shuffled cards first
					local cards = PTASaka.shallow_copy(G.play.cards)
					pseudoshuffle(cards, pseudoseed('mix.mingle.'))
					-- for each card, determine distance from its original position
					for i = 1, #cards do
						local gain = (determine_distance(cards[i], i, G.play.cards)*card.ability.extra.xmult_gain)
						SMODS.scale_card(card, {
							ref_table = card.ability.extra,
							ref_value = "xmult",
							scalar_table = {gain = gain},
							scalar_value = "gain",
							no_message = true,
						})
					end
					G.play.cards = cards
					G.play:set_ranks()
					return true
				end
			})
			return {
				message = pseudorandom('messagelmao') < 0.5 and "Mixed!" or "Mingled!",
			}
		end
		if context.joker_main then
			return {
				x_mult = card.ability.extra.xmult
			}
		end
	end
}
