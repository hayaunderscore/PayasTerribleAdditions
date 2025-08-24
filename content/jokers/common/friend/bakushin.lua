local old_upd = nil

-- Sakura Bakushin O
SMODS.Joker {
	name = "pta-Bakushin",
	key = "bakushin",
	rarity = 1,
	atlas = "JOE_Jokers2",
	pos = { x = 4, y = 7 },
	cost = 2,
	blueprint_compat = false,
	demicoloncompat = false,
	config = { extra = { speed = 2 } },
	immutable = true,
	pools = { ["Joker"] = true, ["Friend"] = true },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.speed } }
	end,
}
