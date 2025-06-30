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
	if ((G.GAME and G.GAME.payasaka_allow_reroll) or (booster_obj and booster_obj.kind == 'Gacha')) and not G.CONTROLLER.locks.use and not G.CONTROLLER.locks.booster_reroll and G.pack_cards and (G.pack_cards.cards[1]) and
		(G.STATE == G.STATES.SMODS_BOOSTER_OPENED or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.STANDARD_PACK or G.STATE == G.STATES.BUFFOON_PACK or (G.hand and (G.hand.cards[1] or (G.hand.config.card_limit <= 0))))
		and booster_obj and booster_obj.cost ~= 0 and not (to_big(G.GAME.dollars - G.GAME.bankrupt_at) - to_big(booster_obj.cost or 0) < to_big(0)) then
		e.config.colour = G.C.GREY
		e.config.button = 'reroll_booster'
		e.states.visible = true
	elseif not ((G.GAME and G.GAME.payasaka_allow_reroll) or (booster_obj and booster_obj.kind == 'Gacha')) then
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
				c:start_dissolve({ G.C.WHITE, G.C.WHITE }, false, 0.75, true)
			end

			if G.payasaka_gacha_pack_extra and G.payasaka_gacha_pack_extra.cards then
				for i = #G.payasaka_gacha_pack_extra.cards, 1, -1 do
					local c = G.payasaka_gacha_pack_extra:remove_card(G.payasaka_gacha_pack_extra.cards[i])
					c:start_dissolve({ G.C.WHITE, G.C.WHITE }, false, 0.75, true)
				end
			end

			--save_run()

			play_sound('coin2')
			play_sound('other1')

			local _size = SMODS.OPENED_BOOSTER.ability.extra
			if SMODS.OPENED_BOOSTER.config.center.kind == 'Gacha' then _size = math.floor(_size / 2) end

			for i = 1, SMODS.OPENED_BOOSTER.ability.extra do
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
					card:start_materialize({ G.C.WHITE, G.C.WHITE }, true)
					if SMODS.OPENED_BOOSTER.config.center.kind == 'Gacha' then
						if i <= _size then G.pack_cards:emplace(card) else G.payasaka_gacha_pack_extra:emplace(card) end
					else
						G.pack_cards:emplace(card)
					end
					if SMODS.OPENED_BOOSTER.config.center.kind == 'Gacha' and (not (SMODS.OPENED_BOOSTER.edition and SMODS.OPENED_BOOSTER.edition.negative)) then
						card:flip()
					end
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
						if cardtable[i]:get_id() < 11 then
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

SMODS.Back {
	key = 'erraticerraticerratic',
	atlas = "JOE_Decks",
	pos = { x = 0, y = 2 },
	unlocked = true,
	apply = function(self, back)
		G.GAME.payasaka_erratic_saved_suits = {}
		G.GAME.payasaka_erratic_saved_ranks = {}
		G.E_MANAGER:add_event(Event{
			func = function()
				-- Only use suits of cards available in the deck, as well as ranks
				for _, v in ipairs(G.playing_cards or {}) do
					if not SMODS.has_no_suit(v) then G.GAME.payasaka_erratic_saved_suits[#G.GAME.payasaka_erratic_saved_suits + 1] = { card_key = string.sub(v.base.suit, 1, 1), key = v.base.suit } end
					if not SMODS.has_no_rank(v) then G.GAME.payasaka_erratic_saved_ranks[#G.GAME.payasaka_erratic_saved_ranks + 1] = { card_key = string.sub(v.base.value, 1, 1), key = v.base.value } end
				end
				-- Ok then.
				if not G.GAME.payasaka_erratic_saved_suits[1] then G.GAME.payasaka_erratic_saved_suits = {SMODS.Suits['Hearts']} end
				if not G.GAME.payasaka_erratic_saved_ranks[1] then G.GAME.payasaka_erratic_saved_ranks = {SMODS.Ranks['Ace']} end
				return true
			end
		})
		G.GAME.payasaka_erratic_ultra = true
	end,
}

SMODS.Back {
	key = 'gacha',
	atlas = "JOE_Decks",
	pos = { x = 1, y = 1 },
	unlocked = true,
	config = { joker_slot = 5 },
	apply = function(self, back)
		G.GAME.payasaka_fucking_hell = true
		G.GAME.joker_rate = 0
		G.GAME.banned_keys['p_buffoon_normal_1'] = true
		G.GAME.banned_keys['p_buffoon_normal_2'] = true
		G.GAME.banned_keys['p_buffoon_jumbo_1'] = true
		G.GAME.banned_keys['p_buffoon_mega_1'] = true
		G.E_MANAGER:add_event(Event{
			func = function()
				if not G.GAME.used_vouchers["v_payasaka_parakmi"] then
					-- Go through all possible modded booster packs
					for k, booster in ipairs(G.P_CENTER_POOLS.Booster) do
						---@type SMODS.Booster
						local booster = booster
						-- Hack to fix redeeming this via Decline
						if booster.create_card and booster.group_key ~= "k_standard_pack" then
							local dummy = booster:create_card({ ability = copy_table(booster.config), fake_card = 1 }, 1)
							if dummy and dummy.config and dummy.config.center and dummy.config.center.set == 'Joker' then
								G.GAME.banned_keys[booster.key] = true
								print('Banned '..booster.key..' from Gacha Deck')
							end
							if dummy and dummy.remove then dummy:remove() end
						end
					end
					if #G.consumeables.cards < G.consumeables.config.card_limit then
						local _c = SMODS.add_card { key = 'c_payasaka_gacha', area = G.consumeables }
						_c:juice_up()
					end
				end
				return true
			end
		})
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { self.config.joker_slot } }
	end
}

if PTASaka.Mod.config["Ahead"] then
-- Start with a random Prismatic joker
SMODS.Back {
	key = 'prismatic',
	atlas = "JOE_Decks",
	pos = { x = 3, y = 0 },
	unlocked = true,
	apply = function(self, back)
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.jokers then
					local c = SMODS.add_card({ rarity = "payasaka_daeha", set = "Joker", area = G.jokers, skip_materialize = true })
					c:start_materialize()
					return true
				end
			end,
		}))
	end
}
end

local function get_compat(center, sticker)
	if center[sticker.."_compat"] then
		return true
	end
	if center[sticker.."_compat"] == nil and SMODS.Stickers[sticker].default_compat then
		return true
	end
	return false
end

local function sticker_deck_nerf(rate, rate_2)
	return G.GAME.modifiers.payasaka_sticker_deck and rate or rate_2
end

-- take_ownership sucks
SMODS.Stickers["eternal"].should_apply = function(self, card, center, area, bypass_reroll)
	local ret = true
	if (card.ability.set == "Joker" and not get_compat(card.config.center, "eternal")) then ret = false end
	if (card.ability.set == "Joker" or G.GAME.modifiers.payasaka_sticker_deck_sleeve) and ((area == G.pack_cards or area == G.payasaka_gacha_pack_extra or area == G.shop_jokers)) then
		G.GAME.payasaka_eternal_perishable_poll = pseudorandom((area == G.pack_cards and 'packetper' or 'etperpoll')..G.GAME.round_resets.ante)
		G.GAME.payasaka_eternal_target_rate = G.GAME.modifiers.payasaka_sticker_deck and 0.8 or 1.3
		if G.GAME.modifiers.enable_eternals_in_shop then G.GAME.payasaka_eternal_target_rate = G.GAME.payasaka_eternal_target_rate - sticker_deck_nerf(0.3, 0.6) end
		if G.GAME.payasaka_eternal_perishable_poll > G.GAME.payasaka_eternal_target_rate then
			return ret
		end
	end
	return false
end

SMODS.Stickers["perishable"].should_apply = function(self, card, center, area, bypass_reroll)
	local ret = true
	if (card.ability.set == "Joker" and not get_compat(card.config.center, "perishable")) then ret = false end
	if (card.ability.set == "Joker" or G.GAME.modifiers.payasaka_sticker_deck_sleeve) and ((area == G.pack_cards or area == G.payasaka_gacha_pack_extra or area == G.shop_jokers)) then
		G.GAME.payasaka_eternal_perishable_poll = G.GAME.payasaka_eternal_perishable_poll or pseudorandom((area == G.pack_cards and 'packetper' or 'etperpoll')..G.GAME.round_resets.ante)
		local etr = (G.GAME.payasaka_eternal_target_rate or (G.GAME.modifiers.payasaka_sticker_deck and 0.8 or 1.3))
		if (not G.GAME.payasaka_eternal_target_rate) and G.GAME.modifiers.enable_eternals_in_shop then etr = etr - sticker_deck_nerf(0.3, 0.6) end
		local minimum_target_rate = G.GAME.modifiers.payasaka_sticker_deck and 1 or 1.3
		if G.GAME.modifiers.enable_perishables_in_shop then minimum_target_rate = minimum_target_rate - 0.9 end
		if ((G.GAME.payasaka_eternal_perishable_poll > minimum_target_rate) and (G.GAME.payasaka_eternal_perishable_poll <= etr)) then
			return ret
		end
	end
	return false
end

SMODS.Stickers["rental"].should_apply = function(self, card, center, area, bypass_reroll)
	local ret = true
	if (card.ability.set == "Joker" and not get_compat(card.config.center, "rental")) then ret = false end
	if (card.ability.set == "Joker" or G.GAME.modifiers.payasaka_sticker_deck_sleeve) and ((area == G.pack_cards or area == G.payasaka_gacha_pack_extra or area == G.shop_jokers)) then
		local roll = pseudorandom((area == G.pack_cards and 'packssjr' or 'ssjr')..G.GAME.round_resets.ante)
		local minimum_target_rate = (G.GAME.modifiers.payasaka_sticker_deck and 0.8 or 1.3)
		if G.GAME.modifiers.enable_rentals_in_shop then minimum_target_rate = minimum_target_rate - sticker_deck_nerf(0.3, 0.6) end
		if roll > minimum_target_rate then
			return ret
		end
	end
	return false
end

SMODS.Back {
	key = 'sticker',
	atlas = "JOE_Decks",
	pos = { x = 3, y = 1 },
	unlocked = true,
	config = { vouchers = { "v_overstock_norm" } },
	apply = function(self, back)
		G.GAME.modifiers.payasaka_sticker_deck = true
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { localize { type = 'name_text', key = self.config.vouchers[1], set = "Voucher" } } }
	end
}

SMODS.Back {
	key = 'back',
	atlas = "JOE_Decks",
	pos = { x = 3, y = 2 },
	unlocked = true,
	apply = function(self, back)
		G.GAME.payasaka_deck_rate = 0.75
	end
}

-- Fix for Bunco
local create_blind_card = Card.create_blind_card
function Card:create_blind_card()
	if create_blind_card then return create_blind_card(self) end
	return self
end
