SMODS.Joker {
	name = "Snapgraph",
	key = "snapgraph",
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers",
	pos = { x = 4, y = 3 },
	cost = 25,
	blueprint_compat = false,
	demicoloncompat = false,
	eternal_compat = false,
	perishable_compat = false,
	pools = { ["Joker"] = true, ["Meme"] = true },
	config = { saved_ids = {}, extra = { photographed = false } },
	pta_usable = true,
	loc_vars = function(self, info_queue, card)
		local str = card.ability.extra.photographed and "ready" or "inactive"
		return {
			main_end = {
				{
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes = {
						{
							n = G.UIT.C,
							config = { ref_table = self, align = "m", colour = card.ability.extra.photographed and G.C.GREEN or G.C.JOKER_GREY, r = 0.05, padding = 0.06 },
							nodes = {
								{ n = G.UIT.T, config = { text = ' ' .. str .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9 } },
							}
						}
					}
				}
			}
		}
	end,
	use = function(self, card, copier)
		if not card.ability.extra.photographed then
			card.ability.saved_ids = {}
			for i = 1, #G.hand.cards do
				local _c = G.hand.cards[i]
				card.ability.saved_ids[#card.ability.saved_ids + 1] = _c.sort_id
			end
			G.E_MANAGER:add_event(Event{
				func = function()
					card:juice_up(0.6, 0.1)
					play_sound('tarot1')
					attention_text({
						text = "Saved!",
						scale = 1,
						hold = (0.75 * 1.25) - 0.2,
						backdrop_colour = G.C.DARK_EDITION,
						align = "tm",
						major = card,
						offset = { x = 0, y = -0.05 * G.CARD_H }
					})
					return true
				end
			})
			card.ability.extra.photographed = true
			delay((0.75 * 1.25) - 0.2)
		else
			local hand_count = #G.hand.cards
			local _saved = #card.ability.saved_ids
			for i = 1, hand_count do
				draw_card(G.hand, G.discard, i * 100 / hand_count, 'down', nil, nil, 0.07)
			end
			delay(0.5)
			for _, saved in ipairs(card.ability.saved_ids) do
				for _, area in ipairs({ G.deck, G.discard, G.hand }) do
					for k, _card in ipairs(area.cards) do
						if _card.sort_id == saved then
							draw_card(area == G.hand and G.discard or area, G.hand, k * 100 / _saved, 'up', true, _card)
						end
					end
				end
			end
			G.E_MANAGER:add_event(Event{
				func = function()
					card:juice_up(0.6, 0.1)
					play_sound('tarot2')
					attention_text({
						text = "Loaded!",
						scale = 1,
						hold = (0.75 * 1.25) - 0.2,
						backdrop_colour = G.C.DARK_EDITION,
						align = "tm",
						major = card,
						offset = { x = 0, y = -0.05 * G.CARD_H }
					})
					return true
				end
			})
			card.ability.extra.photographed = false
			delay((0.75 * 1.25) - 0.2)
		end
		delay(0.5)
		draw_card(G.play, card.from_area, nil, 'up', nil, card)
	end,
	can_use = function()
		return G.STATE == G.STATES.SELECTING_HAND
	end
}

function PTASaka.use_joker(card, area, copier)
	stop_use()
	if card.debuff then return nil end
	local used_tarot = copier or card
	if card.ability.rental then
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			blocking = false,
			blockable = false,
			func = (function()
				ease_dollars(-G.GAME.cry_consumeable_rental_rate)
				return true
			end)
		}))
	end

	local obj = card.config.center
	if obj.use and type(obj.use) == 'function' then
		obj:use(card, area, copier)
		return
	end
end

function G.UIDEF.payasaka_joker_use_buttons(card)
	local sell = {
		n = G.UIT.C,
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
	local use = {
		n = G.UIT.C,
		config = { align = "cr" },
		nodes = {

			{
				n = G.UIT.C,
				config = { ref_table = card, align = "cr", maxw = 1.25, padding = 0.1, r = 0.08, minw = 1.25, minh = (card.area and card.area.config.type == 'joker') and 0 or 1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, button = 'use_card', func = 'can_use_consumeable' },
				nodes = {
					{ n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
					{ n = G.UIT.T, config = { text = localize('b_use'), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true } }
				}
			}
		}
	}
	local t = {
		n = G.UIT.ROOT,
		config = { padding = 0, colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.C,
				config = { padding = 0.15, align = 'cl' },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = 'cl' },
						nodes = {
							sell
						}
					},
					{
						n = G.UIT.R,
						config = { align = 'cl' },
						nodes = {
							use
						}
					},
				}
			},
		}
	}
	return t
end

local old_can_use = Card.can_use_consumeable
function Card:can_use_consumeable(any, skip)
	if not skip and ((G.play and #G.play.cards > 0) or
			(G.CONTROLLER.locked) or
			(G.GAME.STOP_USE and G.GAME.STOP_USE > 0))
	then
		return false
	end
	local ret = old_can_use(self, any, skip)
	if self.ability.name == "Snapgraph" then
		ret = self.config.center.can_use(self.config.center, self)
	end
	return ret
end

local old_highlight = Card.highlight
function Card:highlight(ih)
	local exists = self.children.use_button ~= nil
	old_highlight(self, ih)
	if self.ability.name == "Snapgraph" and self.area and self.area ~= G.pack_cards then
		if self.highlighted and self.area and self.area.config.type ~= 'shop' and (self.area == G.jokers or self.area == G.consumeables) then
			if self.children.use_button then
				self.children.use_button:remove()
				self.children.use_button = nil
			end
			self.children.use_button = UIBox {
				definition = G.UIDEF.payasaka_joker_use_buttons(self),
				config = { align =
					((self.area == G.jokers) or (self.area == G.consumeables)) and "cr" or
					"bmi"
				, offset =
					((self.area == G.jokers) or (self.area == G.consumeables)) and { x = -0.5, y = 0 } or
					{ x = 0, y = 0.65 },
					parent = self }
			}
		elseif exists and self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end
	end
end
