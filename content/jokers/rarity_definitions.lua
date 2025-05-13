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

-- Exotic but also not exotic but also exotic :grin:
SMODS.Rarity {
	key = "daeha",
	badge_colour = SMODS.Gradients["payasaka_prismatic_gradient"],
	pools = { ["Joker"] = true },
	default_weight = 0, -- Legendary status
}

-- Make Ahead cards ALWAYS foil
local old_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	local card = old_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	if card and card.config.center.rarity == "payasaka_ahead" and card.config.center.key ~= "j_payasaka_nil" then
		card:set_edition("e_foil", true, nil)
	end
	return card
end
