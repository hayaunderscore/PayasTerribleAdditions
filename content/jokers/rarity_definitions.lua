SMODS.Rarity {
	key = "ahead",
	badge_colour = HEX('C4C1EA'),
	pools = { ["Joker"] = true },
	default_weight = 0.01, -- Now rarer than rare hopefully
}

SMODS.Gradient {
	key = "prismatic_gradient",
	colours = { G.C.RED, G.C.JOKER_GREY, G.C.PALE_GREEN, G.C.PURPLE },
	cycle = 10,
	interpolation = 'linear'
}

SMODS.Gradient {
	key = "friend",
	colours = { lighten(G.C.RED, 0.3), lighten(G.C.BLUE, 0.3) },
	cycle = 5,
	interpolation = 'linear'
}

SMODS.Rarity {
	key = "thunderstruck",
	badge_colour = HEX('344245'),
	pools = { ["Joker"] = true },
	default_weight = 0,
}

-- Exotic but also not exotic but also exotic :grin:
SMODS.Rarity {
	key = "daeha",
	badge_colour = SMODS.Gradients["payasaka_prismatic_gradient"],
	pools = { ["Joker"] = true },
	default_weight = 0, -- Legendary status
}

SMODS.Rarity {
	key = "dud",
	badge_colour = HEX('469274'),
	--pools = { ["Joker"] = true },
	default_weight = 0, -- Only available via Gacha Cards
}
