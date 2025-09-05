SMODS.Joker {
	name = "Rei",
	key = "rei",
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 2, y = 0 },
	soul_pos = { x = 5, y = 0 },
	cost = 25,
	blueprint_compat = false,
	demicoloncompat = false,
}

local showman_ref = SMODS.showman
function SMODS.showman(card_key)
	if next(SMODS.find_card("j_payasaka_rei")) and next(SMODS.find_card(card_key)) then
		return true
	end
	return showman_ref(card_key)
end

function PTASaka.rei(card_key)
	return next(SMODS.find_card(card_key))
end