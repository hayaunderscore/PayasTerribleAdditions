SMODS.Joker {
	key = 'no_retrigger',
	atlas = "JOE_Jokers",
	pos = { x = 8, y = 0 },
	rarity = 3,
	cost = 6,
	blueprint_compat = false,
	demicoloncompat = false,
}

-- Insert repetitions in here
table.insert(SMODS.calculation_keys, 1, "fake_repetitions")

-- Oh and account for that, too
local calculate_individual_effect_hook = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
	if key == "fake_repetitions" and PTASaka.stop_you_are_violating_the_law then
		card_eval_status_text(PTASaka.stop_you_are_violating_the_law, 'extra', nil, nil, nil, {
			message = localize('k_nope_ex'),
			colour = G.C.PURPLE,
			extrafunc = function()
				play_sound("payasaka_coolgong", percent, 0.6)
			end
		})
		local rand = pseudorandom('aww_random_effect', 1, 3)
		if rand == 1 then
			if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
			mult = mod_mult(mult * amount)
			update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
			card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'x_mult', amount, percent)
		elseif rand == 2 then
			if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
			hand_chips = mod_chips(hand_chips * amount)
			update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
			card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'x_chips', amount, percent)
		elseif rand == 3 then
			if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
			ease_dollars(amount)
			card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'dollars', amount, percent)
		end
		return true
	end
	return calculate_individual_effect_hook(effect, scored_card, key, amount, from_edition)
end
