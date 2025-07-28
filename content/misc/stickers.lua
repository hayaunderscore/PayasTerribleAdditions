local function get_compat(center, sticker)
	if center[sticker .. "_compat"] then
		return true
	end
	if center[sticker .. "_compat"] == nil and SMODS.Stickers[sticker].default_compat then
		return true
	end
	return false
end

-- Helper function for our sticker application
-- Even handles if were in the sticker deck or not
local function deck_sleeve_combo_apply(self, card, center, area, bypass_reroll)
	-- Always enable this if we can
	if G.GAME.modifiers.payasaka_sticker_deck then
		G.GAME.modifiers['enable_'..self.key] = true
	end
	if G.GAME.modifiers.payasaka_sticker_deck_sleeve and
		(
			center[self.key .. '_compat'] or -- explicit marker
			(
				center[self.key .. '_compat'] == nil and
				((self.default_compat and not self.compat_exceptions[center.key]) or -- default yes with no exception
					(not self.default_compat and self.compat_exceptions[center.key]))
			)                                                             -- default no with exception
		)
	then
		self.last_roll = pseudorandom((area == G.pack_cards and 'packssj' or 'shopssj') ..
			self.key .. G.GAME.round_resets.ante)
		local rate = self.rate or 0
		if self.get_rate and type(self.get_rate) == 'function' then
			rate = self:get_rate(card, center, area, bypass_reroll)
		end
		return (bypass_reroll ~= nil) and bypass_reroll or self.last_roll > (1 - rate)
	end
	self.old_rate = self.old_rate or self.rate
	if self.get_rate and type(self.get_rate) == 'function' then
		self.rate = self:get_rate(card, center, area, bypass_reroll)
	end
	return SMODS.Sticker.should_apply(self, card, center, area, bypass_reroll)
end

SMODS.Sticker {
	key = 'sunset',
	atlas = "JOE_Enhancements",
	pos = { x = 0, y = 2 },
	badge_colour = HEX('e98841'),
	get_rate = function(self, card)
		if G.GAME.modifiers.enable_eternals_in_shop then return 0.3 end
		return 0.1
	end,
	sets = { ["Joker"] = true },
	default_compat = true,
	config = { payasaka_sunset_extra = { odds = 4 } },
	sticker_tier = 1,
	calculate = function(self, card, context)
		if G.GAME.current_round.hands_played > 1 and context.end_of_round and context.main_eval then
			if SMODS.pseudorandom_probability(card, 'sunset_die', 1, (card.ability.payasaka_sunset_extra or self.config.payasaka_sunset_extra).odds) then
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
								card.children.center.pinch.x = false
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
		local num, den = SMODS.get_probability_vars(card, 1,
			(card.ability.payasaka_sunset_extra or self.config.payasaka_sunset_extra).odds)
		return { vars = { num, den } }
	end,
	should_apply = deck_sleeve_combo_apply
}

SMODS.Sticker {
	key = 'delivery',
	atlas = "JOE_Enhancements",
	pos = { x = 5, y = 2 },
	badge_colour = HEX('64bccc'),
	get_rate = function(self, card)
		if G.GAME.modifiers.enable_eternals_in_shop then return 0.3 end
		return 0.1
	end,
	sets = { ["Joker"] = true },
	config = { rounds = 2 },
	default_compat = true,
	payasaka_debuff_calculate = true,
	sticker_tier = 1,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			card.ability[self.key].rounds = (card.ability[self.key].rounds or self.config.rounds) - 1
			if card.ability[self.key].rounds <= 0 then
				SMODS.Sticker.apply(self, card, nil)
				SMODS.Sticker.apply(SMODS.Stickers["payasaka_delivered"], card, true)
				SMODS.debuff_card(card, false, "delivery_debuff")
				return {
					message = "Delivered!",
					colour = G.C.FILTER,
					delay = 0.45
				}
			else
				return {
					message = localize { type = 'variable', key = 'a_remaining', vars = { card.ability[self.key].rounds } },
					colour = G.C.FILTER,
					delay = 0.45
				}
			end
		end
	end,
	apply = function(self, card, val)
		SMODS.Sticker.apply(self, card, val)
		card.ability[self.key] = val and copy_table(self.config) or nil
	end,
	loc_vars = function(self, info_queue, card)
		local cfg = card.ability[self.key] or self.config or {}
		return { vars = { cfg.rounds } }
	end,
	should_apply = deck_sleeve_combo_apply
}

SMODS.Sticker {
	key = 'delivered',
	atlas = "JOE_Enhancements",
	pos = { x = 6, y = 2 },
	badge_colour = HEX('73a7b1'),
	rate = 0,
	sets = { ["Joker"] = true },
	default_compat = true,
	sticker_tier = 1,
	no_collection = true,
	should_apply = function() return false end,
}

SMODS.Sticker {
	key = 'giant',
	atlas = "JOE_Enhancements",
	pos = { x = 2, y = 2 },
	badge_colour = HEX('48d775'),
	get_rate = function(self, card)
		if G.GAME.modifiers.enable_perishables_in_shop then return 0.25 end
		return 0.08
	end,
	sets = { ["Joker"] = true },
	config = { payasaka_giant_extra = { slot = 1 } },
	default_compat = true,
	sticker_tier = 2,
	should_apply = deck_sleeve_combo_apply,
	apply = function(self, card, val)
		card.ability.payasaka_giant_extra = copy_table(self.config.payasaka_giant_extra)
		card.ability.payasaka_giant = val
		card.ability.payasaka_stickers = card.ability.payasaka_stickers or {}
		card.ability.payasaka_stickers[self.key] = val
		if (card.area == G.jokers) or (card.area == G.consumeables) then
			if card.ability.set == "Joker" and G.jokers then
				G.jokers.config.card_limit = G.jokers.config.card_limit -
					(card.ability.payasaka_giant_extra or SMODS.Stickers["payasaka_giant"].config.payasaka_giant_extra)
					.slot *
					(val and 1 or -1)
			elseif card.ability.set ~= "Joker" and G.consumeables then
				G.consumeables.config.card_limit = G.consumeables.config.card_limit -
					(card.ability.payasaka_giant_extra or SMODS.Stickers["payasaka_giant"].config.payasaka_giant_extra)
					.slot *
					(val and 1 or -1)
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.payasaka_giant_extra and card.ability.payasaka_giant_extra.slot or self.config.payasaka_giant_extra.slot } }
	end
}

SMODS.Sticker {
	key = 'taunt',
	atlas = "JOE_Enhancements",
	pos = { x = 3, y = 2 },
	badge_colour = HEX('ffd767'),
	get_rate = function(self, card)
		if G.GAME.modifiers.enable_rentals_in_shop then return 0.25 end
		return 0.075
	end,
	sets = { ["Joker"] = true },
	default_compat = true,
	sticker_tier = 2,
	config = {
		blind_size = 1.15
	},
	should_apply = deck_sleeve_combo_apply,
	calculate = function(self, card, context)
		if context.setting_blind then
			G.E_MANAGER:add_event(Event{
				func = function()
					G.GAME.blind.chips = G.GAME.blind.chips * card.ability[self.key].blind_size
					G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
					SMODS.juice_up_blind()
					return true
				end
			})
			return {
				message = "Hardened!"
			}
		end
	end,
	apply = function(self, card, val)
		card.ability[self.key] = val and copy_table(self.config) or nil
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability[self.key].blind_size } }
	end
}

SMODS.Sticker {
	key = 'tired',
	atlas = "JOE_Enhancements",
	pos = { x = 1, y = 2 },
	badge_colour = HEX('7c4bc1'),
	get_rate = function(self, card)
		if G.GAME.modifiers.enable_rentals_in_shop then return 0.3 end
		return 0.1
	end,
	sets = { ["Joker"] = true },
	default_compat = true,
	payasaka_debuff_calculate = true,
	sticker_tier = 3,
	should_apply = deck_sleeve_combo_apply,
	calculate = function(self, card, context)
		if context.first_hand_drawn and G.GAME.facing_blind then
			SMODS.debuff_card(card, true, 'tired_debuff')
		elseif ((context.hand_drawn and G.GAME.facing_blind) or context.end_of_round) then
			SMODS.debuff_card(card, false, 'tired_debuff')
		end
	end
}


