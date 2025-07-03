if not CardSleeves then return end

CardSleeves.Sleeve {
	key = 'gambling',
	atlas = "JOE_Sleeves",
	pos = { x = 0, y = 0 },
	apply = function(self, sleeve)
		G.GAME.payasaka_allow_reroll = true
		if self.get_current_deck_key() == "b_payasaka_gacha" or (G.STAGE == G.STAGES.RUN and G.GAME and G.GAME.payasaka_used_decks and G.GAME.payasaka_used_decks["b_payasaka_gacha"]) then
			G.GAME.payasaka_unweighted_gacha = true
		end
	end,
	loc_vars = function(self)
		local key = self.key
		if self.get_current_deck_key() == "b_payasaka_gacha" or (G.STAGE == G.STAGES.RUN and G.GAME and G.GAME.payasaka_used_decks and G.GAME.payasaka_used_decks["b_payasaka_gacha"]) then
			key = self.key .. "_alt"
		end
		return { key = key }
	end,
}

CardSleeves.Sleeve {
	key = 'sticker',
	atlas = "JOE_Sleeves",
	pos = { x = 1, y = 0 },
	apply = function(self, sleeve)
		local voucher = "v_overstock_norm"
		G.GAME.modifiers.payasaka_sticker_deck = true
		if self.get_current_deck_key() == "b_payasaka_sticker" or (G.STAGE == G.STAGES.RUN and G.GAME and G.GAME.payasaka_used_decks and G.GAME.payasaka_used_decks["b_payasaka_sticker"]) then
			G.GAME.modifiers.payasaka_sticker_deck_sleeve = true
			voucher = "v_overstock_plus"
		end
		G.GAME.used_vouchers[voucher] = true
		G.E_MANAGER:add_event(Event{
			func = function()
				G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 1
				Card.apply_to_run(nil, G.P_CENTERS[voucher])
				return true
			end
		})
	end,
	loc_vars = function(self)
		local key = self.key
		local voucher = "v_overstock_norm"
		if self.get_current_deck_key() == "b_payasaka_sticker" or (G.STAGE == G.STAGES.RUN and G.GAME and G.GAME.payasaka_used_decks and G.GAME.payasaka_used_decks["b_payasaka_sticker"]) then
			key = self.key .. "_alt"
			voucher = "v_overstock_plus"
		end
		return { key = key, vars = { localize { type = 'name_text', key = voucher, set = "Voucher" } } }
	end,
}

CardSleeves.Sleeve {
	key = 'back',
	atlas = "JOE_Sleeves",
	pos = { x = 2, y = 0 },
	apply = function(self, sleeve)
		G.GAME.payasaka_sleeve_rate = 1.75
	end,
}