local WHICH_DARK = 1
local WHICH_LIGHT = 2

SMODS.Joker {
	name = "Flint and Steel 2",
	key = 'flintnsteel2',
	config = { extra = { mult = 2 }, dark_cards = 0, light_cards = 0 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, math.min(card.ability.dark_cards, card.ability.light_cards) * card.ability.extra.mult } }
	end,
	atlas = "JOE_Jokers",
	pos = { x = 5, y = 2 },
	cost = 3,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		if not context.blueprint_card then
			if context.individual and context.cardarea == G.play and next(context.poker_hands['Pair']) then
				if context.other_card:is_suit('Spades') or context.other_card:is_suit('Clubs') then
					card.ability.dark_cards = card.ability.dark_cards + 1
				end
				if context.other_card:is_suit('Hearts') or context.other_card:is_suit('Diamonds') then
					card.ability.light_cards = card.ability.light_cards + 1
				end
			end
		end
		if context.joker_main or context.forcetrigger then
			return {
				mult = math.min(card.ability.dark_cards, card.ability.light_cards) * card.ability.extra.mult
			}
		end
		if context.final_scoring_step and context.cardarea == G.play then
			card.ability.dark_cards = 0
			card.ability.light_cards = 0
		end
	end
}