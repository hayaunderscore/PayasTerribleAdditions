SMODS.Back {
	key = 'shittim',
	atlas = "JOE_Decks",
	pos = { x = 0, y = 0 },
	unlocked = true,
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.jokers then
					SMODS.add_card({ key = "j_payasaka_buruakacard" })
					SMODS.add_card({ key = "j_payasaka_arona" })
					SMODS.add_card({ key = "j_payasaka_plana" })
					return true
				end
			end,
		}))
	end
}

SMODS.Back {
	key = 'dark_shittim',
	atlas = "JOE_Decks",
	pos = { x = 1, y = 0 },
	unlocked = true,
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.jokers then
					local shit = SMODS.add_card({ key = "j_payasaka_buruakacard" })
					shit.ability.cry_rigged = true
					SMODS.add_card({ key = "j_payasaka_arona" })
					SMODS.add_card({ key = "j_payasaka_plana" })
				end
				return true
			end,
		}))
	end
}

SMODS.Back {
	key = 'monopoly',
	atlas = "JOE_Decks",
	pos = { x = 2, y = 0 },
	unlocked = true,
	config = {vouchers = {'v_payasaka_monopolizer', 'v_payasaka_meritocracy'}, card_count = 2, consumable_slot = 3},
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.playing_cards then
					local cardtable = {}
					for k, v in ipairs(G.playing_cards) do cardtable[#cardtable+1] = v end
					for i=#cardtable, 1, -1 do
						if cardtable[i].base.id < 11 then
							cardtable[i]:remove()
						end
					end
					local n = #G.playing_cards
					for i = 1, n do
						local _card = copy_card(G.playing_cards[i], nil, nil, G.playing_card)
						_card:add_to_deck()
						G.deck.config.card_limit = G.deck.config.card_limit + 1
						table.insert(G.playing_cards, _card)
						G.deck:emplace(_card)
					end
				end
				if G.consumeables then
					for i = 1, back.effect.config.card_count do
						SMODS.add_card { set = "Property" }
					end
				end
				return true
			end,
		}))
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.card_count, self.config.consumable_slot } }
	end
}