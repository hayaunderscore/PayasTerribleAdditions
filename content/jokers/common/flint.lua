local WHICH_DARK = 1
local WHICH_LIGHT = 2

SMODS.Joker {
	name = "Flint and Steel 2",
	key = 'flintnsteel2',
	config = { extra = { mult = 10 }, which_next = 0, current_mult = 0 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	atlas = "JOE_Jokers",
	pos = { x = 5, y = 2 },
	cost = 3,
	blueprint_compat = true,
	--[[
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			--G.E_MANAGER:add_event(Event({
			--	func = function()
					if card.ability.which_next == 0 then
						if context.other_card:is_suit('Spades') or context.other_card:is_suit('Clubs') then
							card.ability.which_next = WHICH_LIGHT
						end
						if context.other_card:is_suit('Hearts') or context.other_card:is_suit('Diamonds') then
							card.ability.which_next = WHICH_DARK
						end
					else
						if ((context.other_card:is_suit('Spades') or context.other_card:is_suit('Clubs')) and card.ability.which_next == WHICH_DARK)
							or (context.other_card:is_suit('Hearts') or context.other_card:is_suit('Diamonds') and card.ability.which_next == WHICH_LIGHT) then
							card.ability.current_mult = card.ability.current_mult + card.ability.extra.mult
						end
						card.ability.which_next = 0
					end
			--	end
			--}))
		end
		if context.joker_main then
			return {
				mult = card.ability.current_mult
			}
		end
		if context.end_of_round then
			card.ability.current_mult = 0
		end
	end
	]]
}