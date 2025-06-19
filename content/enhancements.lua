SMODS.Enhancement {
	name = "Damp",
	key = 'damp',
	atlas = "JOE_Enhancements",
	pos = { x = 0, y = 0 },
	config = { x_chips = 1.5, x_mult = 1.5, odds = 8 },
	always_scores = true,
	calculate = function(self, card, context)
		if context.final_scoring_step and context.cardarea == G.play then
			if pseudorandom("payasaka_damp_card") < (G.GAME.probabilities.normal or 1) / card.ability.odds and not next(SMODS.find_card('j_payasaka_rainy')) then
				G.E_MANAGER:add_event(Event {
					delay = 0.2,
					func = function()
						card:set_ability(G.P_CENTERS.m_payasaka_wet)
						card:juice_up()
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Wet!", colour = G.C.BLUE })
						return true
					end
				})
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_payasaka_wet
		return {
			vars = { card.ability.x_chips, card.ability.x_mult, (G.GAME.probabilities.normal or 1), card.ability.odds }
		}
	end
}

SMODS.Enhancement {
	name = "Wet",
	key = 'wet',
	atlas = "JOE_Enhancements",
	pos = { x = 1, y = 0 },
	replace_base_card = true,
	no_rank = true,
	any_suit = true,
	config = { bonus = 100 },
	always_scores = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.bonus } }
	end
}

SMODS.Enhancement {
	name = "pta-Volatile",
	key = 'volatile',
	atlas = "JOE_Enhancements",
	pos = { x = 2, y = 0 },
	config = { mult = 0 },
	calculate = function(self, card, context)
		if not context.end_of_round then
			if context.main_scoring and context.cardarea == "unscored" then
				card.ability.mult = card.ability.mult + card:get_chip_bonus()
				return {
					message = localize('k_upgrade_ex')
				}
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult, card:get_chip_bonus() or "??" } }
	end
}

SMODS.Enhancement {
	name = "pta-Laser",
	key = 'laser',
	atlas = "JOE_Enhancements",
	pos = { x = 3, y = 0 },
	config = { laser_balance = 0.05 },
	calculate = function(self, card, context)
		if not context.end_of_round then
			if context.main_scoring and context.cardarea == G.play then
				local balance_chips = mod_chips(hand_chips * card.ability.laser_balance)
				local balance_mult = mod_mult(mult * card.ability.laser_balance)
				local avg = (balance_chips + balance_mult) / 2
				return {
					pf_chips_mult = function(hc, m)
						G.E_MANAGER:add_event(Event {
							func = function()
								ease_colour(G.C.UI_CHIPS, { 0.8, 0.45, 0.85, 1 })
								ease_colour(G.C.UI_MULT, { 0.8, 0.45, 0.85, 1 })
								G.E_MANAGER:add_event(Event({
									trigger = 'after',
									blockable = false,
									blocking = false,
									delay = 0.8,
									func = (function()
										ease_colour(G.C.UI_CHIPS, G.C.BLUE, 0.8)
										ease_colour(G.C.UI_MULT, G.C.RED, 0.8)
										return true
									end)
								}))
								G.E_MANAGER:add_event(Event({
									trigger = 'after',
									blockable = false,
									blocking = false,
									no_delete = true,
									delay = 1.3,
									func = (function()
										G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1],
											G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
										G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1],
											G.C.RED[2], G.C.RED[3], G.C.RED[4]
										return true
									end)
								}))
								return true
							end
						})
						return hc + (avg - balance_chips), m + (avg - balance_mult)
					end,
					colour = { 0.8, 0.45, 0.85, 1 },
					sound = 'gong',
					message = localize('k_balanced'),
				}
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.laser_balance * 100 } }
	end
}

local function get_compat(center, sticker)
	if center[sticker .. "_compat"] then
		return true
	end
	if center[sticker .. "_compat"] == nil and SMODS.Stickers[sticker].default_compat then
		return true
	end
	return false
end

-- This includes stickers as well, capiche.
SMODS.Sticker {
	key = 'sunset',
	atlas = "JOE_Enhancements",
	pos = { x = 0, y = 2 },
	badge_colour = HEX('e98841'),
	rate = 0,
	sets = {
		"Joker"
	},
	default_compat = true,
	config = { payasaka_sunset_extra = { odds = 4 } },
	calculate = function(self, card, context)
		if G.GAME.current_round.hands_played > 1 and context.end_of_round and context.main_eval then
			if pseudorandom('sunset_die') < (G.GAME.probabilities.normal or 1) / (card.ability.payasaka_sunset_extra or self.config.payasaka_sunset_extra).odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						-- This part destroys the card.
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = "Destroyed!"
				}
			end
			return {
				message = localize('k_safe_ex')
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { (G.GAME.probabilities.normal or 1), (card.ability.payasaka_sunset_extra or self.config.payasaka_sunset_extra).odds } }
	end,
	should_apply = function(self, card, center, area, bypass_reroll)
		if card.ability.set == "Joker" or G.GAME.modifiers.payasaka_sticker_deck_sleeve then
			if (not get_compat(card.config.center, "payasaka_sunset")) or (card.ability.eternal or card.ability.perishable) then return false end
			if G.GAME.modifiers.payasaka_sticker_deck and (area == G.pack_cards or area == G.payasaka_gacha_pack_extra or area == G.shop_jokers) then
				if pseudorandom('packsunset') < (G.GAME.modifiers.enable_rentals_in_shop and 0.3 or 0.15) then
					return true
				end
			end
		end
		return false
	end
}

SMODS.Sticker {
	key = 'tired',
	atlas = "JOE_Enhancements",
	pos = { x = 1, y = 2 },
	badge_colour = HEX('7c4bc1'),
	rate = 0,
	sets = {
		"Joker"
	},
	default_compat = true,
	should_apply = function(self, card, center, area, bypass_reroll)
		if card.ability.set == "Joker" or G.GAME.modifiers.payasaka_sticker_deck_sleeve then
			if not get_compat(card.config.center, "payasaka_tired") then return false end
			if G.GAME.modifiers.payasaka_sticker_deck and (area == G.pack_cards or area == G.payasaka_gacha_pack_extra or area == G.shop_jokers) then
				if pseudorandom('packtired') < (G.GAME.modifiers.enable_perishables_in_shop and 0.3 or 0.15) then
					return true
				end
			end
		end
		return false
	end
}
