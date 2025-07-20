SMODS.Blind {
	key = "sharp",
	atlas = "JOE_Blinds",
	pos = { x = 0, y = 7 },
	dollars = 5,
	mult = 2,
	boss = { min = 0, max = 1999 },
	boss_colour = HEX('952222'),
	set_blind = function(self)
		G.GAME.payasaka_sharp = true
	end,
	disable = function(self)
		G.GAME.payasaka_sharp = false
	end,
	defeat = function(self)
		G.GAME.payasaka_sharp = false
	end,
	calculate = function(self, blind, context)
		if G.GAME.payasaka_sharp and context.destroy_card and context.cardarea == G.hand then
			if context.destroy_card.ability.the_sharp_marked then
				return {
					remove = true,
				}
			end
		end
		if G.GAME.payasaka_sharp then
			if context.before then
				for k, v in pairs(G.play.cards) do
					if v.ability.the_sharp_marked then
						G.E_MANAGER:add_event(Event{
							delay = 0.05,
							trigger = 'after',
							func = function()
								v.ability.the_sharp_marked = nil
								v:juice_up()
								return true
							end
						})
					end
				end
			end
			if context.after then G.GAME.payasaka_sharp_kill = true end
			if context.end_of_round and context.main_eval then
				G.GAME.payasaka_sharp_kill = nil
				for k, v in pairs(G.playing_cards) do
					v.ability.the_sharp_marked = nil
				end
			end
			if context.first_hand_drawn or (context.hand_drawn and G.GAME.payasaka_sharp_kill) then
				G.GAME.payasaka_sharp_kill = nil
				local cards_to_mark = PTASaka.shallow_copy(G.hand.cards)
				local count = 3
				local current_len = #cards_to_mark
				while count > 0 and current_len > 0 do
					local card = table.remove(cards_to_mark, pseudorandom('california', 1, #cards_to_mark))
					if card then
						card.ability.the_sharp_marked = true
					end
					current_len = #cards_to_mark
					count = count - 1
				end
			end
		end
	end
}
