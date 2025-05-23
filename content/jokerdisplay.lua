local jd_def = JokerDisplay.Definitions

local cached_adultcard_names = {}

jd_def["j_payasaka_buruakacard"] = {
	text = {
		{ ref_table = "card.joker_display_values", ref_value = "adultcard_current", colour = G.C.GREEN, scale = 0.4 }
	},
	calc_function = function(card)
		card.joker_display_values = card.joker_display_values or {}
		if card.ability.cry_rigged then
			card.joker_display_values.adultcard_current = "ALL"
			return
		end
		if not (PTASaka.adultcard_cardarea and PTASaka.adultcard_cardarea.cards and PTASaka.adultcard_cardarea.cards[1] and PTASaka.adultcard_cardarea.cards[card.ability.extra.next_joker]) then
			card.joker_display_values.adultcard_current = "???"
			return
		end
		local jkrkey = PTASaka.adultcard_cardarea.cards[card.ability.extra.next_joker].config.center.key
		-- Strip possible styling, we can't render it, and we don't need it
		cached_adultcard_names[jkrkey] = cached_adultcard_names[jkrkey] or
			string.gsub(G.localization.descriptions.Joker[jkrkey].name, "{.-}", "")
		card.joker_display_values.adultcard_current = cached_adultcard_names[jkrkey]
	end
}

jd_def["j_payasaka_phil"] = {
	text = {
		{
			border_nodes = {
				{ text = "X" },
				{ ref_table = "card.ability.extra", ref_value = "fuck", retrigger_type = "mult" }
			}
		}
	},
	extra = {
		{
			{ text = "(" },
			{ ref_table = "card.joker_display_values", ref_value = "odds" },
			{ text = " of " },
			{
				border_nodes = {
					{ text = "X0", colour = G.C.WHITE },
				},
			},
			{ text = ")" },
		}
	},
	extra_config = { colour = G.C.GREEN, scale = 0.3 },
	calc_function = function(card)
		card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { card.ability.extra.odds * (G.GAME.probabilities.normal or 1), card.ability.extra.chance } }
	end
}

jd_def["j_payasaka_arona"] = {
	text = {
		{
			border_nodes = {
				{ text = "X" },
				{ ref_table = "card.joker_display_values", ref_value = "lmao", retrigger_type = "mult" }
			},
			border_colour = G.C.CHIPS
		},
	},
	calc_function = function(card)
		if next(SMODS.find_card("j_payasaka_plana")) == nil then
			card.joker_display_values.lmao = card.ability.extra.divchips
		else
			card.joker_display_values.lmao = card.ability.extra.givechips
		end
	end
}

local signed = function(a) return a >= 0 and "+" .. tostring(a) or tostring(a) end

jd_def["j_payasaka_plana"] = {
	text = {
		{
			border_nodes = {
				{ text = "X" },
				{ ref_table = "card.ability.extra", ref_value = "givemult", retrigger_type = "mult" }
			},
			border_color = G.C.MULT
		}
	},
}

jd_def["j_payasaka_goodnevil"] = {
	text = {
		{ ref_table = "card.joker_display_values", ref_value = "goodnevil", retrigger_type = "add" },
		{ ref_table = "card.joker_display_values", ref_value = "increment", retrigger_type = "add" }
	},
	reminder_text = {
		{ text = "(Every scored card)" }
	},
	calc_function = function(card)
		card.joker_display_values.goodnevil = signed(card.ability.extra.mult)
		card.joker_display_values.increment = signed(card.ability.extra.increment)
	end
}

jd_def["j_payasaka_charred"] = {
	reminder_text = {
		{ text = "(" },
		{ ref_table = "card.joker_display_values", ref_value = "active" },
		{ text = ")" },
	},
	calc_function = function(card)
		card.joker_display_values.active = (G.GAME and G.GAME.current_round.discards_used <= 0 and G.GAME.current_round.discards_left > 0 and localize("jdis_active") or localize("jdis_inactive"))
	end
}

-- todo this dont work !!!
jd_def["j_payasaka_photocopier"] = {
	extra = {
		{
			border_nodes = {
				{ text = "X" },
				{ ref_table = "card.ability.extra", ref_value = "coolmult" }
			},
			border_color = G.C.ATTENTION
		},
		{ ref_table = "card.joker_display_values", ref_value = "compatible_left",  colour = G.C.GREEN },
		{ ref_table = "card.joker_display_values", ref_value = "compatible_right", colour = G.C.GREEN },
	},
	extra_config = { scale = 0.3 },
	calc_function = function(card)
		card.joker_display_values.compatible_left = card.ability.extra.old_jkrs[1] ~= nil and "Compatible!" or
			"Incompatible..."
		card.joker_display_values.compatible_right = card.ability.extra.old_jkrs[2] ~= nil and "Compatible!" or
			"Incompatible..."
	end,
	style_function = function(card, text, reminder_text, extra)
		if extra and extra.children[1] then
			extra.children[1].config.colour = card.ability.extra.old_jkrs[1] ~= nil and G.C.GREEN or G.C.GREY
			extra.children[2].config.colour = card.ability.extra.old_jkrs[2] ~= nil and G.C.GREEN or G.C.GREY
		end
	end
}

jd_def["j_payasaka_tentens"] = {
	extra = {
		{
			{ text = "(" },
			{ ref_table = "card.joker_display_values", ref_value = "odds" },
			{ text = ")" },
		}
	},
	extra_config = { colour = G.C.GREEN, scale = 0.3 },
	calc_function = function(card)
		local chancemult = G.GAME.probabilities.normal or 1
		card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { card.ability.extra.chance * chancemult, card.ability.extra.odds } }
	end
}

jd_def["j_payasaka_markiplier_punch_gif"] = {
	extra = {
		{
			{ text = "(" },
			{ ref_table = "card.joker_display_values", ref_value = "mult_odds" },
			{ text = " of " },
			{
				border_nodes = {
					{ text = "XMult", colour = G.C.WHITE },
				},
				border_colour = G.C.MULT
			},
			{ text = ")" },
		},
		{
			{ text = "(" },
			{ ref_table = "card.joker_display_values", ref_value = "chips_odds" },
			{ text = " of " },
			{
				border_nodes = {
					{ text = "XChips", colour = G.C.WHITE },
				},
				border_colour = G.C.CHIPS
			},
			{ text = ")" },
		},
	},
	extra_config = { colour = G.C.GREEN, scale = 0.3 },
	calc_function = function(card)
		local chancemult = G.GAME.probabilities.normal or 1
		local r = card.ability.cry_rigged
		card.joker_display_values.mult_odds = localize { type = 'variable', key = "jdis_odds", vars = {
			r and card.ability.extra.xmult_chance or card.ability.extra.xmult_odds * chancemult,
			card.ability.extra.xmult_chance
		} }
		card.joker_display_values.chips_odds = localize { type = 'variable', key = "jdis_odds", vars = {
			r and card.ability.extra.xchips_chance or card.ability.extra.xchips_odds * chancemult,
			card.ability.extra.xchips_chance
		} }
	end
}

jd_def["j_payasaka_flintnsteel2"] = {
	text = {
		{ text = "+" },
		{ ref_table = "card.joker_display_values", ref_value = "current_mult", retrigger_type = "add" }
	},
	text_config = { colour = G.C.MULT },
	reminder_text = {
		{ text = "(" },
		{ ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
		{ text = ")" },
	},
	calc_function = function(card)
		card.joker_display_values.current_mult = math.min(card.ability.dark_cards, card.ability.light_cards) *
			card.ability.extra.mult
		card.joker_display_values.localized_text = localize('Pair', 'poker_hands')
	end
}

jd_def["j_payasaka_arrowstone"] = {
	text = {
		{ ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
		{ text = "x",                              scale = 0.35 },
		{
			border_nodes = {
				{ text = "X" },
				{ ref_table = "card.ability.extra", ref_value = "x_chips" }
			},
			border_colour = G.C.CHIPS
		}
	},
	reminder_text = {
		{ text = "(" },
		{ ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.SUITS["Spades"], 0.35) },
		{ text = ")" }
	},
	extra = {
		{
			{ text = "(" },
			{ ref_table = "card.joker_display_values", ref_value = "odds" },
			{ text = ")" },
		}
	},
	extra_config = { colour = G.C.GREEN, scale = 0.3 },
	calc_function = function(card)
		local count = 0
		if G.play then
			local text, _, scoring_hand = JokerDisplay.evaluate_hand()
			if text ~= 'Unknown' then
				for _, scoring_card in pairs(scoring_hand) do
					if scoring_card:is_suit("Spades") then
						count = count +
							JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
					end
				end
			end
		else
			count = 3
		end
		card.joker_display_values.count = count
		card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
		card.joker_display_values.localized_text = localize("Spades", 'suits_plural')
	end
}

-- Quite laggy currently!
--[[
jd_def["j_payasaka_drapingtablet"] = {
	retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
		if held_in_hand then return 0 end
		local first_card = scoring_hand and JokerDisplay.calculate_leftmost_card(scoring_hand)
		return first_card and playing_card == first_card and
			PTASaka.payasaka_hand_spades_amount * JokerDisplay.calculate_joker_triggers(joker_card) or 0
	end
}

local old_update = Game.update
function Game:update(dt)
	old_update(self, dt)
	if G.GAME and G.hand and G.hand.cards then
		local amt, amt_sub = 0, 0
		for i = 1, #G.hand.cards do
			if G.hand.cards[i]:is_suit("Spades") then
				for j = 1, #G.hand.highlighted do
					if G.hand.highlighted[j] == G.hand.cards[i] then
						amt_sub = amt_sub + 1
					end
				end
				amt = amt + 1
			end
		end
		PTASaka.payasaka_hand_spades_amount = amt - amt_sub
	end
end
]]