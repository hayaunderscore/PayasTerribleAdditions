-- print(#table)
SMODS.Joker {
	name = "pta-tablecount",
	key = "tablecount",
	config = { extra = { xmult = 2, chips = 2.5, should_trigger = false, current_table = {}, current_mode = "pairs" } },
	loc_vars = function(self, info_queue, card)
		local table_str = card.ability.extra.current_mode.."({"
		for i = 1, 5 do
			if i == 5 then
				table_str = table_str..(card.ability.extra.current_table[i] or "nil").."})"
			else
				table_str = table_str..(card.ability.extra.current_table[i] or "nil")..", "
			end
		end
		return { vars = { card.ability.extra.xmult, card.ability.extra.chips, table_str } }
	end,
	rarity = 1,
	atlas = "JOE_Jokers2",
	pos = { x = 1, y = 1 },
	cost = 3,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		if context.before then
			local count = 0
			-- Emulating this shit, but normally this acts like this
			for _, v in _G[card.ability.extra.current_mode](card.ability.extra.current_table) do
				if v then
					count = count + 1
				end
				if not v and card.ability.extra.current_mode == "ipairs" then break end
			end
			card.ability.extra.should_trigger = #G.play.cards == count
			if card.ability.extra.should_trigger then
				return {
					message = "Matched!"
				}
			end
		end
		if (context.joker_main and card.ability.extra.should_trigger) or context.forcetrigger then
			return {
				x_chips = card.ability.extra.chips,
				x_mult = card.ability.extra.xmult,
			}
		end
		if context.end_of_round and context.main_eval then
			card.ability.extra.should_trigger = false
			card.ability.extra.current_mode = pseudorandom_element({"pairs", "ipairs"}, pseudoseed('funnuvalue'))
			for i = 1, 5 do
				card.ability.extra.current_table[i] = i == 1 and pseudorandom('dummyval!!!!', 1, 20) or (pseudorandom('nilcheck') > 0.55 and pseudorandom('dummyval!!!!', 1, 20))
			end
			return {
				message = "Randomized!"
			}
		end
	end,
	set_ability = function(self, card, initial, delay_sprites)
		--SMODS.Joker.set_ability(self, card, initial, delay_sprites)
		for i = 1, 5 do
			card.ability.extra.current_table[i] = i == 1 and pseudorandom('dummyval!!!!', 1, 20) or (pseudorandom('nilcheck') > 0.55 and pseudorandom('dummyval!!!!', 1, 20))
		end
	end,
}
