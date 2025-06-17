-- John Madden! John Madden! John Madden! Football!
SMODS.Joker {
	name = "AskJohnMadden",
	key = "johnmadden",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 1, y = 2 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = false,
	config = { extra = { chips = 30, mult = 5 } },
	calculate = function(self, card, context)
		if context.hand_drawn and not context.blueprint_card then
			G.E_MANAGER:add_event(Event{
				func = function()
					---@type Card
					local other = pseudorandom_element(G.hand.cards, pseudoseed('john'))
					if other then
						card:juice_up(0.7)
						other:juice_up()
						other.ability.john_madden_marked = true
						local name = localize { type = 'name_text', key = other.config.center.key, set = 'Enhanced' }
						if name == "ERROR" then name = "card" end
						PTASaka.DECTalk(
							"John Madden thinks this "..other.base.value
							.." of "..other.base.suit
							.." "..name
							.." is the best to play!"
						)
					end
					save_run()
					return true
				end
			})
			return {
				message = "Selected!"
			}
		end
		if context.individual and context.cardarea == G.play and not context.end_of_round then
			if context.other_card.ability.john_madden_marked then
				return {
					chips = card.ability.extra.chips,
					mult = card.ability.extra.mult,
					message = "aeiou",
					sound = "payasaka_aeiou"
				}
			end
		end
		if context.end_of_round and not context.individual then
			for _, c in ipairs(G.playing_cards) do
				if c and c.ability.john_madden_marked then
					c.ability.john_madden_marked = nil
				end
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
	end
}
