SMODS.Rarity {
	key = "ahead",
	badge_colour = HEX('C4C1EA'),
	pools = { ["Joker"] = true },
	default_weight = 0.1, -- Just *slightly* more rarer than Uncommon
}

-- Make Ahead cards ALWAYS foil
local old_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	local card = old_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	if card and card.config.center.rarity == "payasaka_ahead" then
		card:set_edition("e_foil", true, nil)
	end
	return card
end
