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
	demicoloncompat = false,
	calculate = function(self, card, context)
		if context.payasaka_before and context.scoring_hand then
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

			-- update hand text
			local text,disp_text = G.FUNCS.get_poker_hand_info(context.scoring_hand)
			update_hand_text({delay = 0, modded = true}, {handname=disp_text, level=G.GAME.hands[text].level, mult = G.GAME.hands[text].mult, chips = G.GAME.hands[text].chips})
			mult = mod_mult(G.GAME.hands[text].mult)
			hand_chips = mod_chips(G.GAME.hands[text].chips)
		end
		if context.before then
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
		return { vars = { card.ability.extra.copy } }
	end
}

local ac = CardArea.align_cards
function CardArea:align_cards()
	if self.payasaka_disable_alignment then
		if self.config.type == 'play' or self.config.type == 'shop' then
			local cnt = 0
			local n_cnt = 0
			for k, card in ipairs(self.cards) do
				if not card.payasaka_winton_spawned_aligned then
					cnt = cnt + 1
				else
					n_cnt = n_cnt + 1
				end
			end
			for k, card in ipairs(self.cards) do
				if not card.states.drag.is then
					card.T.r = 0
					-- stupid hack
					local max_cards = 5
					if cnt >= 5 then
						max_cards = cnt
					end
					card.T.x = self.T.x +
					(self.T.w - self.card_w) *
					((k - 1) / math.max(max_cards - 1, 1) - 0.5 * (cnt - max_cards) / math.max(max_cards - 1, 1)) +
					0.5 * (self.card_w - card.T.w) + (self.config.card_limit == 1 and 0.5 * (self.T.w - card.T.w) or 0)
					local highlight_height = G.HIGHLIGHT_H
					if not card.highlighted then highlight_height = 0 end
					card.T.y = self.T.y + self.T.h / 2 - card.T.h / 2 - highlight_height
					card.T.x = card.T.x + card.shadow_parrallax.x / 30
				end
			end
			--table.sort(self.cards, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
		end
		return
	end
	ac(self)
end
