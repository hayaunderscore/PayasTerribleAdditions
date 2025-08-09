-- Oguri Cap
SMODS.Joker {
	name = "pta-Oguri Cap",
	key = "oguri",
	rarity = 3,
	atlas = "JOE_Jokers2",
	pos = { x = 2, y = 7 },
	cost = 8,
	blueprint_compat = false,
	demicoloncompat = false,
	immutable = true,
	pools = { ["Joker"] = true, ["Friend"] = true },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calc_scaling = function(self, card, other_card, scaling_value, scalar_value, args)
		-- If globalization is enabled, do not use calc_scaling !!!
		if PTASaka.Mod.config["Fatty Mode"] then return nil end
		return {
			scaling_value = scaling_value + (args and (args.operation == "-" or args.operation == "/") and -scalar_value or scalar_value)
		}
	end
}
