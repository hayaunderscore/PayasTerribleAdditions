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
	demicoloncompat = true,
	calculate = function(self, card, context)
		card.ability.extra.limit = card.ability.extra.copy * 10
		if context.payasaka_before then
			card.ability.extra.limit_count = 0
		end
		if (context.payasaka_before or context.forcetrigger and card.ability.extra.limit_count < card.ability.extra.limit) and context.scoring_hand then
			local copy = context.scoring_hand[1]
			for i = 1, card.ability.extra.copy do
				-- create the playing card
				G.playing_card = (G.playing_card and G.playing_card + 1) or 1
				local copied_card = copy_card(copy, nil, nil, G.playing_card)
				copied_card:add_to_deck()
				G.deck.config.card_limit = G.deck.config.card_limit + 1
				table.insert(G.playing_cards, copied_card)
				G.play:emplace(copied_card)
				copied_card:highlight(true)
				context.scoring_hand[#context.scoring_hand + 1] = copied_card

				-- alignment and visibility tricks
				G.play.payasaka_disable_alignment = true
				copied_card.states.visible = nil
				copied_card.payasaka_winton_spawned_aligned = true
				-- for the 'hi there!' later
				copied_card.payasaka_assigned_winton = card.ID
				
				-- materialize the copy when winton would be called visually
				card_eval_status_text(card, 'extra', nil, nil, nil,
				{
					message = localize('k_duplicated_ex'),
					extrafunc = function()
						copied_card:start_materialize()
						copied_card.VT.scale = copy.VT.scale
						copied_card.VT.w = copy.VT.w
						copied_card.VT.h = copy.VT.h
						copied_card.payasaka_winton_spawned_aligned = nil
						play_sound("payasaka_challenpoints")
						G.play:align_cards()
					end
				})
			end

			card.ability.extra.limit_count = card.ability.extra.limit_count + card.ability.extra.copy

			-- update hand text
			local text,disp_text = G.FUNCS.get_poker_hand_info(context.scoring_hand)
			update_hand_text({delay = 0, modded = true}, {handname=disp_text, level=G.GAME.hands[text].level, mult = G.GAME.hands[text].mult + mult, chips = G.GAME.hands[text].chips + hand_chips})
			mult = mod_mult(G.GAME.hands[text].mult + mult)
			hand_chips = mod_chips(G.GAME.hands[text].chips + hand_chips)
		elseif context.forcetrigger and card.ability.extra.limit_count >= card.ability.extra.limit then
			return {
				message = "Max of "..number_format(card.ability.extra.limit).."!"
			}
		end
		if context.after then
			G.E_MANAGER:add_event(Event{
				trigger = 'after',
				delay = 0.4,
				func = function()
					-- restore normal alignment rules
					G.play.payasaka_disable_alignment = nil
					return true
				end
			})
		end
		-- hi there
		if context.individual and context.other_card then
			if context.other_card.payasaka_assigned_winton == card.ID then
				context.other_card.payasaka_assigned_winton = nil
				local _c = context.other_card
				G.E_MANAGER:add_event(Event {
					func = function()
						card:juice_up()
						play_sound("payasaka_hithere")
						return true
					end
				})
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.copy, card.ability.extra.copy * 10 } }
	end
}
