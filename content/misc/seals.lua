-- Random Stamp
-- Kinda like portable Rosen in a way
SMODS.Seal {
	key = 'random',
	atlas = "JOE_Enhancements",
	pos = { x = 0, y = 1 },
	config = { x_mult = 2, x_chips = 2, dollars = 8, e_mult = 2, e_chips = 2, extra = { odds = 5 } },
	badge_colour = HEX('f73876'),
	calculate = function(self, card, context)
		local s = card.ability.seal
		local odds = card.ability.cry_rigged and 0.9 or s.extra.odds
		if context.main_scoring and context.cardarea == G.play then
			--print("please")
			return {
				x_mult = SMODS.pseudorandom_probability(card, 'payasaka_random', 1, odds) and s.x_mult or nil,
				xmult_message = {
					message = localize { type = "variable", key = "a_xmult", vars = { s.x_mult } },
					colour =
						G.C.MULT,
					sound = "multhit2"
				} or nil,
				x_chips = SMODS.pseudorandom_probability(card, 'payasaka_random', 1, odds) and s.x_chips or nil,
				xchips_message = {
					message = localize { type = "variable", key = "a_xchips", vars = { s.x_chips } },
					colour =
						G.C.CHIPS,
					sound = "xchips"
				} or nil,
				e_mult = (Talisman and SMODS.pseudorandom_probability(card, 'payasaka_random', 1, odds)) and s
					.e_mult or nil,
				emult_message = Talisman and
					{ message = ("^%d Mult"):format(s.e_mult), colour = G.C.DARK_EDITION, sound = "talisman_emult" } or
					nil,
				e_chips = (Talisman and SMODS.pseudorandom_probability(card, 'payasaka_random', 1, odds)) and
					s.e_chips or nil,
				echip_message = Talisman and
					{ message = ("^%d Chips"):format(s.e_chips), colour = G.C.DARK_EDITION, sound = "talisman_echip" } or
					nil,
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		local s = card.ability.seal
		local num, odds = SMODS.get_probability_vars(card, 1, s.extra.odds)
		info_queue[#info_queue + 1] = {
			key = Talisman and "payasaka_randomeffects_talisman" or "payasaka_randomeffects",
			set =
			"Other",
			vars = { s.dollars, s.x_chips, s.x_mult, s.e_chips, s.e_mult }
		}
		return { vars = { num, odds } }
	end,
	get_p_dollars = function(self, card)
		local s = card.ability.seal
		if SMODS.pseudorandom_probability(card, 'payasaka_random', 1, s.extra.odds) then
			return s.dollars
		end
		return 0
	end
}

-- Thunder Stamp
if PTASaka.Mod.config["Risk Cards"] then
	SMODS.Seal {
		key = 'thunder',
		atlas = "JOE_Enhancements",
		pos = { x = 1, y = 1 },
		badge_colour = HEX('fcc077'),
		calculate = function(self, card, context)
			if context.main_scoring and context.cardarea == "unscored" then
				G.E_MANAGER:add_event(Event {
					func = function()
						if #G.consumeables.cards < G.consumeables.config.card_limit then
							local c = SMODS.add_card { set = 'Risk', skip_materialize = true }
							c:start_materialize()
							c:juice_up()
						end
						return true
					end
				})
			end
		end
	}
end

-- Ghost Stamp
SMODS.Seal {
	key = 'ghost',
	atlas = "JOE_Enhancements",
	pos = { x = 2, y = 1 },
	badge_colour = HEX('7aa4f2'),
	calculate = function(self, card, context)
		if context.remove_playing_cards and context.removed then
			for k, v in pairs(context.removed) do
				if v == card then
					G.E_MANAGER:add_event(Event {
						func = function()
							G.playing_card = (G.playing_card or 0) + 1
							local c = copy_card(card, nil, nil, G.playing_card)
							c:add_to_deck()
							c:set_seal(nil)
							G.deck.config.card_limit = G.deck.config.card_limit + 1
							table.insert(G.playing_cards, c)
							G.hand:emplace(c)
							c:start_materialize()
							if #G.consumeables.cards < G.consumeables.config.card_limit then
								local s = SMODS.add_card { set = 'Spectral', skip_materialize = true }
								s:start_materialize()
							end
							return true
						end
					})
				end
			end
		end
	end
}
