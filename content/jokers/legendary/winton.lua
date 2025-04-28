SMODS.Joker {
	name = "Winton",
	key = "winton",
	config = {
		extra = { copy = 1 }
	},
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 1, y = 4 },
	soul_pos = { x = 2, y = 4 },
	cost = 25,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.before and context.scoring_hand then
			local copy = context.scoring_hand[1]
			for i = 1, card.ability.extra.copy do
				G.playing_card = (G.playing_card and G.playing_card + 1) or 1
				local copied_card = copy_card(copy, nil)
				copied_card:add_to_deck()
				G.deck.config.card_limit = G.deck.config.card_limit + 1
				table.insert(G.playing_cards, copied_card)
				G.play:emplace(copied_card)
				context.scoring_hand[#context.scoring_hand+1] = copied_card
				copied_card.states.visible = nil
				copied_card:highlight(true)
				copied_card.VT.scale = card.VT.scale
				G.E_MANAGER:add_event(Event{
					func = function()
						copied_card:start_materialize()
						return true
					end
				})
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.copy } }
	end
}