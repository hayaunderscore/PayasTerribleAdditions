SMODS.ConsumableType {
	key = 'DOSCard',
	collection_rows = { 5, 6 },
	primary_colour = HEX('4f6368'),
	secondary_colour = HEX('a1c5c4'),
	shop_rate = 0.3,
	loc_txt = {},
}

SMODS.UndiscoveredSprite {
	key = 'DOSCard',
	atlas = "JOE_DOS",
	path = 'dos.png',
	pos = { x = 3, y = 3 },
	px = 71, py = 95,
}

PTASaka.DOSCard = SMODS.Consumable:extend {
	set = 'DOSCard',
	atlas = "JOE_DOS",
	pyroxenes = 5,
	cost = 0,
	ignore_shadow = true,
	required_params = {
		'key',
	},
	update = function(self, card, dt)
		if card.area == G.consumeables then
			local copy = copy_card(card)
			card:remove()
			card:remove_from_area()
			PTASaka.dos_cardarea:emplace(copy)
		end
		card.ambient_tilt = 0
		card.no_shadow = (card.area and card.area == PTASaka.dos_cardarea)
	end,
	can_use = function(self, card)
		return false
	end,
	in_pool = function(self, args)
		return true
	end,
}

PTASaka.DOSCard {
	key = 'dos_wild',
	atlas = "JOE_DOS",
	pos = { x = 0, y = 0 },
	config = { payasaka_dos = true, payasaka_dos_wild = true }
}

PTASaka.DOSCard {
	key = 'dos_exclam',
	atlas = "JOE_DOS",
	pos = { x = 1, y = 0 },
	config = { extra = { payasaka_dos = true, payasaka_type = 1, } },
	calculate = function(self, card, context)
		if card ~= PTASaka.dos_cardarea.cards[#PTASaka.dos_cardarea.cards] then return end
		if context.setting_blind and not context.blueprint and not context.retrigger and not context.retrigger_joker then
			PTASaka.dos_cardarea.disabled = true
			local pool = {}
			for k, v in pairs(G.P_CENTER_POOLS["Joker"]) do
				if
					v.unlocked == true
					and (not Cryptid or not Cryptid.no(v, "doe", k))
					and not (G.GAME.banned_keys[v.key] or (G.GAME.cry_banished_keys and G.GAME.cry_banished_keys[v.key]))
				then
					pool[#pool + 1] = v.key
				end
			end
			card:set_ability(
				G.P_CENTERS[pseudorandom_element(pool, pseudoseed("doscard_exclamationpoint"))]
			)
			card:juice_up()
			card.ability.payasaka_exclamation_point = true
		end
	end
}

PTASaka.DOSCard {
	key = 'dos_wildtwo',
	atlas = "JOE_DOS",
	pos = { x = 2, y = 0 },
	config = { extra = { payasaka_dos = true, payasaka_type = 2, } },
	update = function(self, card, dt)
		PTASaka.DOSCard.update(self, card, dt)
		if not card.payasaka_wild_two then
			-- PLEASE just die already
			card.children.front = nil
		end
	end,
	calculate = function(self, card, context)
		if card ~= PTASaka.dos_cardarea.cards[#PTASaka.dos_cardarea.cards] then return end
		if context.payasaka_dos_before then
			PTASaka.dos_cardarea:remove_card(card)
			G.play:emplace(card)
			--draw_card(PTASaka.dos_cardarea, G.play, 1, 'up', true, card, nil, true)
			local copy = context.scoring_hand[#context.scoring_hand]
			-- copy any and all card properties :]
			local back = card.children.back
			copy_card(copy, card)
			card.ability.payasaka_dos = true
			card.ability.payasaka_type = 2
			card.children.front = nil
			card.children.card = nil
			--card:set_seal(nil)
			card.payasaka_wild_two = true
			context.scoring_hand[#context.scoring_hand + 1] = card
			card:highlight(true)
			if card.children.front then
				card.children.front.states.visible = true
			end
			card:flip()
			--card.old_children = PTASaka.deep_copy(card.children)
			G.E_MANAGER:add_event(Event {
				func = function()
					--card:set_seal(copy.seal, true, true)
					card:set_sprites(copy.config.center, copy.config.card)
					card:flip()
					G.E_MANAGER:add_event(Event {
						trigger = 'before',
						delay = 0.6,
						func = function()
							card:juice_up()
							return true
						end
					})
					return true
				end
			})
			local text, disp_text, poker_hands = G.FUNCS.get_poker_hand_info(context.scoring_hand)
			delay(0.8125)
			update_hand_text({ delay = 0, modded = true },
				{
					handname = disp_text,
					level = G.GAME.hands[text].level,
					mult = G.GAME.hands[text].mult,
					chips = G.GAME
						.hands[text].chips
				})
			mult = mod_mult(G.GAME.hands[text].mult)
			hand_chips = mod_chips(G.GAME.hands[text].chips)
			delay(0.4)
		end
	end
}

local old_draw_card = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
	-- Override this...
	local old_to = to
	if card and card.payasaka_wild_two and (to == G.discard or to == G.deck) then
		to = PTASaka.dos_cardarea
		stay_flipped = false
	end
	old_draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
	if card and card.payasaka_wild_two and (old_to == G.discard or old_to == G.deck) then
		G.E_MANAGER:add_event(Event {
			func = function()
				card:set_ability(G.P_CENTERS["c_payasaka_dos_wildtwo"])
				card:set_sprites(G.P_CENTERS["c_payasaka_dos_wildtwo"], nil)
				card:flip()
				card:set_base(nil)
				card:set_seal(nil)
				card.suit = nil
				card.rank = nil
				card.children.front = nil
				card.children.card = nil
				card.payasaka_wild_two = nil
				card:set_debuff(false)
				return true
			end
		})
	end
end

--[[
PTASaka.DOSCard {
	key = 'dos_three',
	atlas = "JOE_DOS",
	pos = { x = 3, y = 0 },
	config = { extra = { payasaka_dos = true, payasaka_type = 3, } },
}

PTASaka.DOSCard {
	key = 'dos_four',
	atlas = "JOE_DOS",
	pos = { x = 0, y = 1 },
	config = { extra = { payasaka_dos = true, payasaka_type = 4, } },
}

PTASaka.DOSCard {
	key = 'dos_five',
	atlas = "JOE_DOS",
	pos = { x = 1, y = 1 },
	config = { extra = { payasaka_dos = true, payasaka_type = 5, } },
}

PTASaka.DOSCard {
	key = 'dos_six',
	atlas = "JOE_DOS",
	pos = { x = 2, y = 1 },
	config = { extra = { payasaka_dos = true, payasaka_type = 6, } },
}

PTASaka.DOSCard {
	key = 'dos_seven',
	atlas = "JOE_DOS",
	pos = { x = 3, y = 1 },
	config = { extra = { payasaka_dos = true, payasaka_type = 7, } },
}

PTASaka.DOSCard {
	key = 'dos_eight',
	atlas = "JOE_DOS",
	pos = { x = 0, y = 2 },
	config = { extra = { payasaka_dos = true, payasaka_type = 8, } },
}

PTASaka.DOSCard {
	key = 'dos_nine',
	atlas = "JOE_DOS",
	pos = { x = 1, y = 2 },
	config = { extra = { payasaka_dos = true, payasaka_type = 9, } },
}

PTASaka.DOSCard {
	key = 'dos_ten',
	atlas = "JOE_DOS",
	pos = { x = 2, y = 2 },
	config = { extra = { payasaka_dos = true, payasaka_type = 10, } },
}
]]

G.FUNCS.payasaka_open_dos_cardarea = function(e)
	if not G.deck.states.visible then
		G.FUNCS.payasaka_open_deck(e)
		return
	end
	G.CONTROLLER.dos_area_lock = true
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function()
			play_sound('other1')
			--G.deck:set_role({ xy_bond = 'Weak' })
			G.deck.T.y = G.deck.T.y + 5
			return true
		end
	}))
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.3,
		func = (function()
			--PTASaka.dos_cardarea:set_role({ xy_bond = 'Weak' })
			PTASaka.dos_cardarea.T.y = PTASaka.dos_cardarea.T.y - 5
			G.payasaka_dos_cardarea_switch.role.major = PTASaka.dos_cardarea
			G.deck.states.visible = false
			G.CONTROLLER.dos_area_lock = false
			local text = G.payasaka_dos_cardarea_switch:get_UIE_by_ID("payasaka_dos_text")
			text.config.text = "Deck"
			G.payasaka_dos_cardarea_switch:recalculate()
			return true
		end)
	}))
end

G.FUNCS.payasaka_open_deck = function(e)
	G.CONTROLLER.dos_area_lock = true
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function()
			play_sound('other1')
			--PTASaka.dos_cardarea:set_role({ xy_bond = 'Weak' })
			PTASaka.dos_cardarea.T.y = PTASaka.dos_cardarea.T.y + 5
			return true
		end
	}))
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.1,
		func = (function()
			--G.deck:set_role({ xy_bond = 'Weak' })
			G.deck.T.y = G.deck.T.y - 5
			G.payasaka_dos_cardarea_switch.role.major = G.deck
			G.deck.states.visible = true
			G.CONTROLLER.dos_area_lock = false
			local text = G.payasaka_dos_cardarea_switch:get_UIE_by_ID("payasaka_dos_text")
			text.config.text = "DOS Cards"
			G.payasaka_dos_cardarea_switch:recalculate()
			return true
		end)
	}))
end

G.FUNCS.payasaka_can_open_dos_cardarea = function(e)
	if G.CONTROLLER.dos_area_lock then
		e.states.button = nil
	else
		e.states.button = "payasaka_open_dos_cardarea"
	end
end

G.FUNCS.payasaka_dos_wild_card_set = function(e)
	local card = e.config.ref_table

	card:highlight(false)

	-- Trigger the Joker collection menu
	G.E_MANAGER:add_event(Event({
		func = function()
			G.SETTINGS.paused = true
			PTASaka.dos_menu = true
			G.FUNCS.overlay_menu {
				definition = SMODS.card_collection_UIBox(G.P_CENTER_POOLS.DOSCard, { 5, 6 }, {
					no_materialize = true,
					back_func = 'exit_overlay_menu',
				})
			}
			PTASaka.dos_got_selected = false
			return true
		end
	}))

	-- Exit out when selecting a card
	G.E_MANAGER:add_event(Event({
		func = function()
			if G.OVERLAY_MENU and not PTASaka.dos_selected_card then
				return false
			end
			G.SETTINGS.paused = false
			PTASaka.dos_menu = false
			return true
		end
	}))

	delay(0.2)

	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.1,
		func = function()
			if PTASaka.dos_selected_card then
				card:remove_from_deck()
				card:set_ability(G.P_CENTERS[PTASaka.dos_selected_card])
				card.ability.payasaka_dos_wild = true
				card:add_to_deck()
				PTASaka.dos_selected_card = nil
				play_sound('tarot2', 1, 0.6)
				card:juice_up(0.3, 0.3)
			end
			return true
		end
	}))
end

SMODS.draw_ignore_keys.wild_use_button = true

function PTASaka.dos_card_hover_ui(card)
	local sell = {
		n = G.UIT.ROOT,
		config = { align = "cr" },
		nodes = {
			{
				n = G.UIT.C,
				config = { ref_table = card, align = "cr", padding = 0.1, r = 0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'sell_card', func = 'can_sell_card' },
				nodes = {
					{ n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
					{
						n = G.UIT.C,
						config = { align = "tm" },
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm", maxw = 1.25 },
								nodes = {
									{ n = G.UIT.T, config = { text = localize('b_sell'), colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true } }
								}
							},
							{
								n = G.UIT.R,
								config = { align = "cm" },
								nodes = {
									{ n = G.UIT.T, config = { text = localize('$'), colour = G.C.WHITE, scale = 0.4, shadow = true } },
									{ n = G.UIT.T, config = { ref_table = card, ref_value = 'sell_cost_label', colour = G.C.WHITE, scale = 0.55, shadow = true } }
								}
							}
						}
					}
				}
			},
		}
	}
	if card.area and card.area == PTASaka.dos_cardarea then
		return sell
	end
	return {}
end

function PTASaka.dos_wild_card_ui(card)
	local colour = G.C.GREEN
	local text_colour = G.C.UI.TEXT_LIGHT
	local text = localize('b_payasaka_dos_switch')
	if card.area and card.area == PTASaka.dos_cardarea then
		return {
			n = G.UIT.ROOT,
			config = { ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = colour, shadow = true, r = 0.08, minh = 0.94, button = 'payasaka_dos_wild_card_set', hover = true },
			nodes = {
				{ n = G.UIT.T, config = { text = text, colour = text_colour, scale = 0.4 } }
			}
		}
	end
	return {}
end
