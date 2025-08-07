-- Snowy Day
SMODS.Joker {
	name = "pta-SnowyDay",
	key = "snowyday",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 5, y = 9 },
	cost = 6,
	blueprint_compat = false,
	demicoloncompat = false,
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	config = { extra = { hand_size = 1 } },
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.hand_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.hand_size)
	end,
	calculate = function(self, card, context)
		if context.before and context.scoring_hand and context.scoring_hand[1] and not context.blueprint_card then
			local c = context.scoring_hand[1]
			PTASaka.freeze_card(c, true, true)
			G.E_MANAGER:add_event(Event{
				func = function()
					card_eval_status_text(c, 'extra', nil, nil, nil, { message = "Frozen!", instant = true })
					return true
				end
			})
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hand_size } }
	end
}

-- Blizzard (Entertainment)
SMODS.Joker {
	name = "pta-Blizzard",
	key = "blizzard",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 6, y = 9 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = false,
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	config = { extra = { odds = 4, retriggers = 2 } },
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
		return { vars = { num, den, card.ability.extra.retriggers } }
	end,
	calculate = function(self, card, context)
		if context.before and context.scoring_hand and not context.blueprint_card then
			for _, c in pairs(context.scoring_hand) do
				if SMODS.pseudorandom_probability(card, 'blizzard_proc', 1, card.ability.extra.odds) then
					PTASaka.freeze_card(c, true, true, nil, 0.2)
					G.E_MANAGER:add_event(Event{
						func = function()
							card_eval_status_text(c, 'extra', nil, nil, nil, { message = "Frozen!", instant = true })
							return true
						end
					})
				end
			end
		end
		if context.repetition and context.other_card and context.other_card.ability.pta_frozen then
			return {
				repetitions = card.ability.extra.retriggers
			}
		end
	end
}