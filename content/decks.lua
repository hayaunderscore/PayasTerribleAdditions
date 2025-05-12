SMODS.Back {
	key = 'shittim',
	atlas = "JOE_Decks",
	pos = { x = 0, y = 0 },
	unlocked = true,
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.payasaka_allow_reroll = true
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
				G.GAME.payasaka_allow_reroll = true
				if G.jokers then
					local shit = SMODS.add_card({ key = "j_payasaka_buruakacard" })
					shit.ability.cry_rigged = true
					SMODS.add_card({ key = "j_payasaka_arona", area = PTASaka.adultcard_cardarea })
					SMODS.add_card({ key = "j_payasaka_plana", area = PTASaka.adultcard_cardarea })
				end
				return true
			end,
		}))
	end
}

local reroll_butan = {
	{
		n = G.UIT.R,
		config = { align = "cm", maxw = 1.3 },
		nodes = {
			{ n = G.UIT.T, config = { text = localize('k_reroll'), scale = 0.4, colour = G.C.WHITE, shadow = true } },
		}
	},
	{
		n = G.UIT.R,
		config = { align = "cm", maxw = 1.3, minw = 0.6 },
		nodes = {
			{ n = G.UIT.T, config = { text = localize('$'), scale = 0.5, colour = G.C.WHITE, shadow = true } },
			{ n = G.UIT.T, config = { ref_table = booster_obj, ref_value = 'cost', scale = 0.55, colour = G.C.WHITE, shadow = true } },
		}
	}
}

to_big = to_big or function(a) return a end

-- Shittim deck rerolling
G.FUNCS.can_reroll_booster = function(e)
	if G.GAME and G.GAME.payasaka_allow_reroll and not G.CONTROLLER.locks.use and not G.CONTROLLER.locks.booster_reroll and G.pack_cards and (G.pack_cards.cards[1]) and
		(G.STATE == G.STATES.SMODS_BOOSTER_OPENED or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.STANDARD_PACK or G.STATE == G.STATES.BUFFOON_PACK or (G.hand and (G.hand.cards[1] or (G.hand.config.card_limit <= 0))))
		and booster_obj and booster_obj.cost ~= 0 and not (to_big(G.GAME.dollars-G.GAME.bankrupt_at) - to_big(booster_obj.cost or 0) < to_big(0)) then
		e.config.colour = G.C.GREY
		e.config.button = 'reroll_booster'
		e.states.visible = true
	elseif not (G.GAME and G.GAME.payasaka_allow_reroll) then
		e.states.visible = false
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

-- Amalgamation of Card:open and G.FUNCS.reroll_shop
G.FUNCS.reroll_booster = function(e)
	for i = 1, #G.jokers.cards do
		G.jokers.cards[i]:calculate_joker({ rerolling_booster = true })
	end
	stop_use()
	G.CONTROLLER.locks.booster_reroll = true
	if G.CONTROLLER:save_cardarea_focus('pack_cards') then G.CONTROLLER.interrupt.focus = true end
	--[[
	if G.GAME.current_round.reroll_cost > 0 then
		inc_career_stat('c_shop_dollars_spent', G.GAME.current_round.reroll_cost)
		inc_career_stat('c_shop_rerolls', 1)
		ease_dollars(-G.GAME.current_round.reroll_cost)
	end
	]]
	ease_dollars(-booster_obj.cost)
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function()
			local final_free = G.GAME.current_round.free_rerolls > 0
			G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls - 1, 0)
			G.GAME.round_scores.times_rerolled.amt = G.GAME.round_scores.times_rerolled.amt + 1

			for i = #G.pack_cards.cards, 1, -1 do
				local c = G.pack_cards:remove_card(G.pack_cards.cards[i])
				c:start_dissolve({G.C.WHITE, G.C.WHITE}, false, 0.75, true)
			end

			--save_run()

			play_sound('coin2')
			play_sound('other1')

			for i = 1, G.GAME.pack_size do
				local card = nil
				if G.STATE == G.STATES.TAROT_PACK then
					if G.GAME.used_vouchers.v_omen_globe and pseudorandom('omen_globe') > 0.8 then
						card = create_card("Spectral", G.pack_cards, nil, nil, true, true, nil, 'ar2')
					else
						card = create_card("Tarot", G.pack_cards, nil, nil, true, true, nil, 'ar1')
					end
				elseif G.STATE == G.STATES.PLANET_PACK then
					if G.GAME.used_vouchers.v_telescope and i == 1 then
						local _planet, _hand, _tally = nil, nil, 0
						for k, v in ipairs(G.handlist) do
							if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
								_hand = v
								_tally = G.GAME.hands[v].played
							end
						end
						if _hand then
							for k, v in pairs(G.P_CENTER_POOLS.Planet) do
								if v.config.hand_type == _hand then
									_planet = v.key
								end
							end
						end
						card = create_card("Planet", G.pack_cards, nil, nil, true, true, _planet, 'pl1')
					else
						card = create_card("Planet", G.pack_cards, nil, nil, true, true, nil, 'pl1')
					end
				elseif G.STATE == G.STATES.SPECTRAL_PACK then
					card = create_card("Spectral", G.pack_cards, nil, nil, true, true, nil, 'spe')
				elseif G.STATE == G.STATES.STANDARD_PACK then
					card = create_card(
						(pseudorandom(pseudoseed('stdset' .. G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base",
						G.pack_cards, nil, nil, nil, true, nil, 'sta')
					local edition_rate = 2
					local edition = poll_edition('standard_edition' .. G.GAME.round_resets.ante, edition_rate, true)
					card:set_edition(edition)
					local seal_rate = 10
					local seal_poll = pseudorandom(pseudoseed('stdseal' .. G.GAME.round_resets.ante))
					if seal_poll > 1 - 0.02 * seal_rate then
						local seal_type = pseudorandom(pseudoseed('stdsealtype' .. G.GAME.round_resets.ante))
						if seal_type > 0.75 then
							card:set_seal('Red')
						elseif seal_type > 0.5 then
							card:set_seal('Blue')
						elseif seal_type > 0.25 then
							card:set_seal('Gold')
						else
							card:set_seal('Purple')
						end
					end
				elseif G.STATE == G.STATES.BUFFOON_PACK then
					card = create_card("Joker", G.pack_cards, nil, nil, true, true, nil, 'buf')
				elseif G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
					if booster_obj.create_card and type(booster_obj.create_card) == "function" then
						local _card_to_spawn = booster_obj:create_card(SMODS.OPENED_BOOSTER, i)
						if type((_card_to_spawn or {}).is) == 'function' and _card_to_spawn:is(Card) then
							card = _card_to_spawn
						else
							card = SMODS.create_card(_card_to_spawn)
						end
					end
				end
				if card then
					card:start_materialize({G.C.WHITE, G.C.WHITE}, true)
					G.pack_cards:emplace(card)
				end
			end
			return true
		end
	}))
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.1,
		func = function()
			G.E_MANAGER:add_event(Event({
				func = function()
					G.CONTROLLER.interrupt.focus = false
					G.CONTROLLER.locks.booster_reroll = false
					G.CONTROLLER:recall_cardarea_focus('pack_cards')
					for i = 1, #G.jokers.cards do
						G.jokers.cards[i]:calculate_joker({ reroll_booster = true })
					end
					return true
				end
			}))
			return true
		end
	}))
end

SMODS.Back {
	key = 'monopoly',
	atlas = "JOE_Decks",
	pos = { x = 2, y = 0 },
	unlocked = true,
	config = { vouchers = { 'v_payasaka_monopolizer', 'v_payasaka_meritocracy' }, card_count = 2, consumable_slot = 3 },
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.playing_cards then
					local cardtable = {}
					for k, v in ipairs(G.playing_cards) do cardtable[#cardtable + 1] = v end
					for i = #cardtable, 1, -1 do
						if cardtable[i].base.id < 11 then
							cardtable[i]:remove()
							--G.playing_cards[i] = nil
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
				G.GAME.starting_deck_size = #G.deck.cards
				return true
			end,
		}))
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.card_count, self.config.consumable_slot } }
	end
}

SMODS.Back {
	key = 'purgatory',
	atlas = "JOE_Decks",
	pos = { x = 0, y = 1 },
	unlocked = true,
	apply = function(self, back)
		G.GAME.payasaka_only_risk = true
	end
}
