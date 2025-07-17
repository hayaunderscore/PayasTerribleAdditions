-- Catchan
SMODS.Joker {
	name = "pta-Catchan",
	key = "catchan",
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 5, y = 4 },
	cost = 8,
	blueprint_compat = false,
	demicoloncompat = false,
	immutable = true,
	pools = { ["Joker"] = true, ["Friend"] = true },
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
	config = { extra = { hand_size = 1, size_mod = 1 } },
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.hand_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.hand_size)
	end,
	calculate = function(self, card, context)
		if context.end_of_round and G.GAME.blind_on_deck == 'Boss' and context.main_eval then
			local old = card.ability.extra.hand_size
			card.ability.extra.hand_size = card.ability.extra.hand_size + card.ability.extra.size_mod
			G.hand:change_size(card.ability.extra.hand_size - old)
			SMODS.calculate_effect({ message = "+"..number_format(card.ability.extra.hand_size - old).." Hand Size" }, card)
			return nil, true
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.size_mod, card.ability.extra.hand_size }
		}
	end
}
