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
		local str = localize('k_payasaka_' .. (card.ability.extra.photographed and "ready" or "inactive"))
		return {
			main_end = {
				(G.GAME and card.area and (card.area == G.jokers)) and {
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes = {
						{
							n = G.UIT.C,
							config = { ref_table = card, align = "m", colour = card.ability.extra.photographed and G.C.GREEN or G.C.JOKER_GREY, r = 0.05, padding = 0.06 },
							nodes = {
								{ n = G.UIT.T, config = { text = ' ' .. str .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9 } },
							}
						}
					}
				} or nil
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
		draw_card(G.play, G.jokers, nil, 'up', nil, card)
	end,
	can_use = function()
		return G.STATE == G.STATES.SELECTING_HAND
	end
}
