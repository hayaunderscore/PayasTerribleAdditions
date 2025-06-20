SMODS.Joker {
	name = "pta-shinku",
	key = 'shinku',
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers2",
	pos = { x = 6, y = 1 },
	soul_pos = { x = 6, y = 2 },
	cost = 25,
	no_doe = true, -- :]
	config = { extra = { card_count = 0 } },
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.payasaka_play_to_discard then
			local c = context.other_card
			local juice = context.blueprint_card or card
			--card.ability.extra.card_count = card.ability.extra.card_count + 1
			G.E_MANAGER:add_event(Event {
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.playing_card = (G.playing_card and G.playing_card + 1) or 1
					c:juice_up(0.7)
					---@type Card
					local copy = copy_card(c, nil, nil, G.playing_card)
					copy:add_to_deck()
					copy.ability.shinku_temporary = true
					G.deck.config.card_limit = G.deck.config.card_limit + 1
					table.insert(G.playing_cards, copy)
					G.hand:emplace(copy)
					copy:start_materialize()
					playing_card_joker_effects({ copy })
					card_eval_status_text(juice, 'extra', nil, nil, nil,
						{ message = localize('k_duplicated_ex'), instant = true })
					return true
				end
			})
		end
		--[[
		if context.setting_blind then
			card.ability.extra.card_count = 0
		end
		if context.payasaka_draw_to_deck then
			local count = card.ability.extra.card_count
			card.ability.extra.card_count = 0
			if count > 0 then
				return {
					draw_amount = count
				}
			end
		end
		]]
		if context.end_of_round and context.individual and context.cardarea == G.hand and not context.blueprint_card then
			-- Remove only the cards in hand for visual flair
			if context.other_card.ability.shinku_temporary and not context.other_card.ability.shinku_destroyed then
				context.other_card.ability.shinku_destroyed = true
				context.other_card:start_dissolve(nil, card.ability.dissolve_silent)
				card.ability.dissolve_silent = true
			end
		end
		if context.blind_defeated then
			local queue = {}
			for k, v in pairs(G.playing_cards) do
				if v and v.ability.shinku_temporary and not v.ability.shinku_destroyed then
					queue[#queue + 1] = v
					v.ability.shinku_destroyed = true
					G.playing_card = (G.playing_card and G.playing_card - 1) or 1
				end
			end
			for i = #queue, 1, -1 do
				queue[i]:remove()
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		local queue = {}
		for k, v in pairs(G.playing_cards) do
			if v and v.ability.shinku_temporary and not v.ability.shinku_destroyed then
				queue[#queue + 1] = v
				v.ability.shinku_destroyed = true
				G.playing_card = (G.playing_card and G.playing_card - 1) or 1
			end
		end
		for i = #queue, 1, -1 do
			queue[i]:remove()
		end
	end
}
