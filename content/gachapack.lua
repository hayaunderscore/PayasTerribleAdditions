-- Arona's Domain

-- The multiples is for the random function to pick that more likely
-- Now with weights!
PTASaka.gacha_rarity_table = {
	{"Common", 200},
	{"Uncommon", 160},
	{"Rare", 50},
	{"Legendary", 15},
}

if PTASaka.Mod.config["Ahead"] then
	PTASaka.gacha_rarity_table[#PTASaka.gacha_rarity_table + 1] = {'payasaka_ahead', 20}
	PTASaka.gacha_rarity_table[#PTASaka.gacha_rarity_table + 1] = {'payasaka_daeha', 1}
end

if next(SMODS.find_mod('finity')) then
	-- This would be really funny
	PTASaka.gacha_rarity_table[#PTASaka.gacha_rarity_table + 1] = {'finity_showdown', 10}
end

if Cryptid then
	-- hahaha!
	PTASaka.gacha_rarity_table[#PTASaka.gacha_rarity_table + 1] = {'cry_epic', 25}
	PTASaka.gacha_rarity_table[#PTASaka.gacha_rarity_table + 1] = {'cry_exotic', 6}
end

SMODS.Consumable {
	name = "pta-Gacha",
	key = 'gacha',
	set = 'Spectral',
	atlas = "JOE_Tarots",
	pos = { x = 3, y = 1 },
	config = { extra = 10, choose = 5 },
	update_pack = function(self, dt)
		if G.buttons then
			G.buttons:remove(); G.buttons = nil
		end
		if G.shop then G.shop.alignment.offset.y = G.ROOM.T.y + 11 end

		if not G.STATE_COMPLETE then
			G.STATE_COMPLETE = true
			G.CONTROLLER.interrupt.focus = true
			G.E_MANAGER:add_event(Event({
				trigger = 'immediate',
				func = function()
					if self.particles and type(self.particles) == "function" then self:particles() end
					G.booster_pack = UIBox {
						definition = self:create_UIBox(),
						config = { align = "tmi", offset = { x = 0, y = G.ROOM.T.y + 9 }, major = G.hand, bond = 'Weak' }
					}
					G.booster_pack.alignment.offset.y = -2.2
					G.ROOM.jiggle = G.ROOM.jiggle + 3
					self:ease_background_colour()
					G.E_MANAGER:add_event(Event({
						trigger = 'immediate',
						func = function()
							if self.draw_hand == true then G.FUNCS.draw_from_deck_to_hand() end

							G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.5,
								func = function()
									G.CONTROLLER:recall_cardarea_focus(G.payasaka_gacha_pack_extra)
									return true
								end
							}))
							return true
						end
					}))
					return true
				end
			}))
		end
	end,
	create_UIBox = function(self)
		if SMODS.OPENED_BOOSTER.config.center.kind ~= 'Gacha' then return SMODS.Booster.create_UIBox(self) end
		if booster_obj.kind == 'Gacha' then
			local _size = math.floor(SMODS.OPENED_BOOSTER.ability.extra / 2)
			G.payasaka_gacha_pack_extra = CardArea(
				G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y - G.CARD_W,
				_size * G.CARD_W * 1.1,
				1.05 * G.CARD_H,
				{ card_limit = _size * 2, type = 'consumeable', highlight_limit = 1 })
			G.pack_cards = CardArea(
				G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
				math.max(1, math.min(_size, 5)) * G.CARD_W * 1.1,
				1.05 * G.CARD_H,
				{ card_limit = _size, type = 'consumeable', highlight_limit = 1 })
		end

		local t = {
			n = G.UIT.ROOT,
			config = { align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = -2.55 },
			nodes = {
				{
					n = G.UIT.C,
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.C,
									config = { align = "cm", padding = 0.1 },
									nodes = {
										{
											n = G.UIT.C,
											config = { align = "cm", r = 0.2, colour = G.C.CLEAR, shadow = true },
											nodes = {
												{
													n = G.UIT.R,
													nodes = { {
														n = G.UIT.O, config = { object = G.pack_cards }
													} }
												},
												{
													n = G.UIT.R,
													nodes = { {
														n = G.UIT.O, config = { object = G.payasaka_gacha_pack_extra }
													} }
												},
											}
										} }
								} }
						},
						{ n = G.UIT.B, config = { align = "tm", padding = 0.05, h = 2.40 }, nodes = {} },
						{
							n = G.UIT.R,
							config = { align = "cl", colour = G.C.CLEAR, r = 0.15, padding = 0.1, minh = 2, shadow = true },
							nodes = {
								{ n = G.UIT.C, config = { align = "tm", padding = 0.05, minw = 0.9 }, nodes = {} },
								{
									n = G.UIT.C,
									config = { align = "tm", padding = 0.05, minw = 2.4 },
									nodes = {
										{ n = G.UIT.R, config = { minh = 0.2 }, nodes = {} },
										{
											n = G.UIT.R,
											config = { align = "cm", minw = 1.8, minh = 1.2, r = 0.15, colour = G.C.GREY, button = 'reroll_booster', func = 'can_reroll_booster', hover = true, shadow = true },
											nodes = {
												{
													n = G.UIT.R,
													config = { align = "cm", padding = 0.07, focus_args = { button = 'c', orientation = 'cr' }, func = 'set_button_pip' },
													nodes = {
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
												}
											}
										},
									}
								},
								{
									n = G.UIT.R,
									config = { align = "tm" },
									nodes = {
										{
											n = G.UIT.C,
											config = { align = "tm", padding = 0.05 },
											nodes = {
												UIBox_dyn_container({
													{
														n = G.UIT.C,
														config = { align = "cm", padding = 0.05, minw = 4 },
														nodes = {
															{
																n = G.UIT.R,
																config = { align = "bm", padding = 0.05 },
																nodes = {
																	{ n = G.UIT.O, config = { object = DynaText({ string = localize(self.group_key or ('k_booster_group_' .. self.key)), colours = { G.C.WHITE }, shadow = true, rotate = true, bump = true, spacing = 2, scale = 0.7, maxw = 4, pop_in = 0.5 }) } } }
															},
															{
																n = G.UIT.R,
																config = { align = "bm", padding = 0.05 },
																nodes = {
																	{ n = G.UIT.O, config = { object = DynaText({ string = { localize('k_choose') .. ' ' }, colours = { G.C.WHITE }, shadow = true, rotate = true, bump = true, spacing = 2, scale = 0.5, pop_in = 0.7 }) } },
																	{ n = G.UIT.O, config = { object = DynaText({ string = { { ref_table = G.GAME, ref_value = 'pack_choices' } }, colours = { G.C.WHITE }, shadow = true, rotate = true, bump = true, spacing = 2, scale = 0.5, pop_in = 0.7 }) } } }
															}, }
													}
												}), }
										},
										{
											n = G.UIT.C,
											config = { align = "tm", padding = 0.05, minw = 2.4 },
											nodes = {
												{ n = G.UIT.R, config = { minh = 0.2 }, nodes = {} },
												{
													n = G.UIT.R,
													config = { align = "tm", padding = 0.2, minh = 1.2, minw = 1.8, r = 0.15, colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true, shadow = true, func = 'can_skip_gacha' },
													nodes = {
														{ n = G.UIT.T, config = { text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = { button = 'y', orientation = 'bm' }, func = 'set_button_pip' } } }
												} }
										} }
								} }
						}
					}
				},
			}
		}
		return t
	end,
	fake_booster = true,
	pta_selectable = true,
	group_key = 'k_gacha_pack',
	select_card = 'jokers',
	pyroxenes = 100,
	cost = 100,
	kind = 'Gacha',
	create_card = function(self, card, i)
		if next(SMODS.find_card('j_payasaka_freetoplay')) and pseudorandom('saya_chance') < 1/2.5 then
			local c = SMODS.create_card( { key = 'j_payasaka_dud', area = i > math.floor(card.ability.extra / 2) and G.payasaka_gacha_pack_extra or
			G.pack_cards } )
			return c
		end
		local c = create_card("Joker",
			i > math.floor(card.ability.extra / 2) and G.payasaka_gacha_pack_extra or
			G.pack_cards, nil,
			G.GAME.payasaka_unweighted_gacha and pseudorandom_element(PTASaka.gacha_rarity_table, pseudoseed('haha'))[1] or PTASaka.pseudorandom_alias_element(
				G.GAME.payasaka_aliased_gacha_table, 'haha'), true, true, nil)
		return c
	end,
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, G.C.BLUE)
		ease_background_colour({ new_colour = G.C.BLUE, special_colour = G.C.PURPLE, contrast = 2 })
	end,
	use = function(self, card, area, copier)
		delay(0.2)

		-- yeah
		G.GAME.PACK_INTERRUPT = G.TAROT_INTERRUPT
		G.STATE_COMPLETE = false
		card.opening = true

		booster_obj = card.config.center
		if booster_obj and SMODS.Centers[booster_obj.key] then
			G.STATE = G.STATES.SMODS_BOOSTER_OPENED
			SMODS.OPENED_BOOSTER = card
		end
		G.GAME.pack_choices = card.ability.choose
		if G.GAME.cry_oboe then
			card.ability.extra = card.ability.extra + G.GAME.cry_oboe
			G.GAME.pack_choices = G.GAME.pack_choices + G.GAME.cry_oboe
			G.GAME.cry_oboe = nil
		end
		G.GAME.pack_size = card.ability.extra

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				card:explode()
				local pack_cards = {}

				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 1.3 * math.sqrt(G.SETTINGS.GAMESPEED),
					blockable = false,
					blocking = false,
					func = function()
						local _size = G.GAME.pack_size

						for i = 1, _size do
							local _c = self:create_card(card, i)
							_c.T.x = card.T.x
							_c.T.y = card.T.y
							_c:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 1.5 * G.SETTINGS.GAMESPEED)
							pack_cards[i] = _c
						end
						return true
					end
				}))

				if G.payasaka_gacha_pack_extra then
					G.payasaka_gacha_pack_extra:remove()
					G.payasaka_gacha_pack_extra = nil
					if G.pack_cards then
						G.pack_cards:remove()
						G.pack_cards = nil
					end
				end
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 1.3 * math.sqrt(G.SETTINGS.GAMESPEED),
					blockable = false,
					blocking = false,
					func = function()
						if self.kind == 'Gacha' then
							if G.payasaka_gacha_pack_extra and G.payasaka_gacha_pack_extra.VT.y < G.ROOM.T.h then
								for k, v in ipairs(pack_cards) do
									if k > math.floor(card.ability.extra / 2) then
										G.payasaka_gacha_pack_extra:emplace(v)
									else
										G.pack_cards:emplace(v)
									end
									if not (card.edition and card.edition.negative) then
										v:flip()
									end
								end
							end
						end
						return true
					end
				}))

				if G.GAME.modifiers.inflation then
					G.GAME.inflation = G.GAME.inflation + 1
					G.E_MANAGER:add_event(Event({
						func = function()
							for k, v in pairs(G.I.CARD) do
								if v.set_cost then v:set_cost() end
							end
							return true
						end
					}))
				end

				return true
			end
		}))
	end,
	can_use = function(self, card)
		return G.STATE == G.STATES.SHOP or G.STATE == G.STATES.BLIND_SELECT
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.choose, card.ability.extra }
		}
	end
}

G.FUNCS.can_skip_gacha = function(e)
	if G.payasaka_gacha_pack_extra and (not (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)) and
		(G.STATE == G.STATES.SMODS_BOOSTER_OPENED or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.STANDARD_PACK or G.STATE == G.STATES.BUFFOON_PACK or (G.hand)) then
		e.config.colour = G.C.GREY
		e.config.button = 'skip_booster'
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.can_select_from_gacha = function(e)
	local card = e.config.ref_table
	local area = card.ability.set == "Joker" and "jokers" or "consumeables"
	local edition_card_limit = card.edition and card.edition.card_limit or 0
	if area and #G[area].cards < G[area].config.card_limit + edition_card_limit then
		e.config.colour = G.C.GREEN
		e.config.button = 'gacha_select_card'
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

local function PityShow()
	local cards = PTASaka.FH.merge(G.pack_cards.cards, G.payasaka_gacha_pack_extra.cards)
	attention_text({
		text = "Now let's see what you didn't get...",
		hold = (0.2 * #cards) + 1.2 * (G.SETTINGS.GAMESPEED),
		scale = 0.5,
		major = G.pack_cards,
		align = "tm",
		offset = { x = 0, y = -0.5 },
		noisy = true
	})
	for i = 1, #cards do
		---@type Card
		local c = cards[i]
		if c.highlighted then c:highlight(false) end
		c.states.click.can = false
	end
	delay(0.2*G.SETTINGS.GAMESPEED)
	for i = 1, #cards do
		local percent = 1.2 - (i - 0.999) / (#cards - 0.998) * 0.4
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				cards[i]:flip(); play_sound('card1', percent); cards[i]
					:juice_up(0.3, 0.3); return true
			end
		}))
	end
end

local old_skip = G.FUNCS.skip_booster
G.FUNCS.skip_booster = function(e)
	if SMODS.OPENED_BOOSTER.config.center.kind == 'Gacha' and not (SMODS.OPENED_BOOSTER.edition and SMODS.OPENED_BOOSTER.edition.negative) then
		PityShow()
		G.E_MANAGER:add_event(Event {
			delay = 1 * (G.SETTINGS.GAMESPEED),
			trigger = 'after',
			func = function()
				old_skip(e)
				return true
			end
		})
		return
	end
	old_skip(e)
end

G.FUNCS.gacha_select_card = function(e)
	local c1 = e.config.ref_table
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.1,
		func = function()
			c1.area:remove_card(c1)
			c1:add_to_deck()
			discover_card(c1)
			if SMODS.OPENED_BOOSTER.config.center.kind == 'Gacha' and (not (SMODS.OPENED_BOOSTER.edition and SMODS.OPENED_BOOSTER.edition.negative)) then
				c1:flip()
			end
			G[c1.ability.set == "Joker" and "jokers" or "consumeables"]:emplace(c1)
			if c1.config.center.key ~= "j_payasaka_dud" then
				SMODS.calculate_context({payasaka_taking_gacha = true, card = c1, area = G[c1.ability.set == "Joker" and "jokers" or "consumeables"]})
			end
			G.GAME.pack_choices = G.GAME.pack_choices - 1
			if G.GAME.pack_choices <= 0 and not (SMODS.OPENED_BOOSTER.edition and SMODS.OPENED_BOOSTER.edition.negative) then
				PityShow()
				G.E_MANAGER:add_event(Event {
					delay = 1 * (G.SETTINGS.GAMESPEED),
					trigger = 'after',
					func = function()
						G.FUNCS.end_consumeable(nil, delay_fac)
						return true
					end
				})
			elseif G.GAME.pack_choices <= 0 then
				G.FUNCS.end_consumeable(nil, delay_fac)
			end
			return true
		end
	}))
end
