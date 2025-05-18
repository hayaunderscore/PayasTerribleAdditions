SMODS.Joker {
	name = "joker.lua",
	key = "joker_lua",
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 7, y = 1 },
	config = { extra = 0.1 },
	cost = 25,
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			return {
				xmult = (card.ability.extra * (pta_amount_of_lua_files_loaded_please_dont_override or 0))
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra, (card.ability.extra * (pta_amount_of_lua_files_loaded_please_dont_override or 0)) } }
	end
}