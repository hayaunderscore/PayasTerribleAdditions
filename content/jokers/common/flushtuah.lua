SMODS.Joker {
	key = 'flushtuah',
	config = { extra = { xmult = 1.2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	atlas = "JOE_Jokers2",
	pos = { x = 0, y = 6 },
	rarity = "payasaka_dud",
	blueprint_compat = true,
	demicoloncompat = true,
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
	in_pool = function(self, args)
		return false, { allow_duplicates = true }
	end,
	calculate = function(self, card, context)
		if context.joker_main and next(context.poker_hands['Pair']) then
			for k, v in pairs(SMODS.Suits) do
				for _, pair in pairs(context.poker_hands["Pair"]) do
					local count = 0
					for j, c in pairs(pair) do
						if c:is_suit(v.key) then
							count = count+1
						end
					end
					if count >= 2 then
						return {
							x_mult = card.ability.extra.xmult
						}
					end
				end
			end
			
		end
	end
}
