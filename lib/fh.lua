
-- Spectrum hands will only be valid if these mods exist
local spectrums_enabled = next(SMODS.find_mod('SixSuits')) or BUNCOMOD or SPECF

-- Mostly taken and mangled from FlushHotkeys
-- https://github.com/Agoraaa/FlushHotkeys/blob/main/FlushHotkeys.lua

PTASaka.FH                      = {}
PTASaka.FH.get_priority_hands   = function()
	local ranked_hands = {}
	local order = 0
	for _, v in pairs(SMODS.PokerHands) do
		local hand = G.GAME.hands[v.key]
		if hand ~= nil then
			local chips = to_big(hand.chips)
			local mult = to_big(hand.mult)
			local value = chips * mult
			ranked_hands[#ranked_hands + 1] = { v.key, value, chips, mult, order }
		end
	end

	table.sort(ranked_hands, function(a, b) return to_big(a[2]) > to_big(b[2]) end)
	for i = 1, #ranked_hands do
		ranked_hands[i][5] = (#ranked_hands + 1) - i
		ranked_hands[i][6] = i
	end

	return ranked_hands
end

PTASaka.FH.ranksuit             = function(card)
	return card.base.id .. card.base.suit
end

PTASaka.FH.calculate_importance = function(card, play, type, hand_list)
	play = play or true
	-- im putting this table for fine tuning. change the numbers if you want
	local importances = {
		play = {
			seal = {
				Gold = 50,
				Blue = -10,
				Red = 50,
				Purple = -10
			},
			edition = {
				e_holo = 70,
				e_foil = 60,
				e_polychrome = 75
			},
			ability = {
				m_steel = -20,
				m_glass = 25,
				m_wild = 15,
				m_bonus = 25,
				m_mult = 25,
				m_stone = 15,
				m_lucky = 25,
				m_gold = -10
			}
		},
		discard = {
			seal = {
				Gold = 50,
				Blue = -10,
				Red = 50,
				Purple = -50
			},
			edition = {
				e_holo = 70,
				e_foil = 60,
				e_polychrome = 75
			},
			ability = {
				m_steel = 30,
				m_glass = 25,
				m_wild = 15,
				m_bonus = 25,
				m_mult = 25,
				m_stone = 15,
				m_lucky = 25,
				m_gold = 15
			}
		}
	}
	-- add base hand type value if applicable
	local res = (hand_list and hand_list[type]) and hand_list[type][2] or 0
	if card.debuff then return -5 end
	if play then
		if card.seal then
			res = res + (importances.play.seal[card.seal] or 0)
		end
		if card.edition and card.edition.key then
			res = res + (importances.play.edition[card.edition.key] or 0)
		end
		if card.config and card.config.center then
			res = res + (importances.play.ability[card.config.center_key] or 0)
		end
	else
		if card.seal then
			res = res + (importances.discard.seal[card.seal] or 0)
		end
		if card.edition and card.edition.key then
			res = res + (importances.discard.edition[card.edition.key] or 0)
		end
		if card.config and card.config.center then
			res = res + (importances.discard.ability[card.config.center_key] or 0)
		end
	end
	res = res + card.base.id
	return res
end

PTASaka.FH.hand_importance      = function(hand, type, hand_list)
	type = type or nil
	local res = 0
	for k, v in pairs(hand) do
		res = res + PTASaka.FH.calculate_importance(v, true, type, hand_list)
	end
	return res
end

PTASaka.FH.is_better_hand       = function(hand1, hand2)
	local hand_list = PTASaka.FH.get_priority_hands()
	--print(hand_list)
	if hand1.hand_type ~= hand2.hand_type then
		local h1 = PTASaka.FH.filter(hand_list, function(v) return v[1] == hand1.hand_type end)[1]
		local h2 = PTASaka.FH.filter(hand_list, function(v) return v[1] == hand2.hand_type end)[1]
		return h1[5] > h2[5] and
		PTASaka.FH.hand_importance(hand1.hand, h1[6], hand_list) >
		PTASaka.FH.hand_importance(hand2.hand, h2[6], hand_list)
	end
	return PTASaka.FH.hand_importance(hand1.hand) > PTASaka.FH.hand_importance(hand2.hand)
end

PTASaka.FH.is_subset            = function(subset, superset, hasher)
	for k, v in pairs(subset) do
		local found = false
		for k2, v2 in pairs(superset) do
			found = found or (hasher(v) == hasher(v2))
		end
		if not found then
			return false
		end
	end
	return true
end

PTASaka.FH.merge                = function(arr1, arr2)
	local res = {}
	for k, v in pairs(arr1) do
		table.insert(res, v)
	end
	for k, v in pairs(arr2) do
		table.insert(res, v)
	end
	return res
end

PTASaka.FH.filter               = function(arr, f)
	local res = {}
	for i, v in pairs(arr) do
		if (f(v)) then
			table.insert(res, v)
		end
	end
	return res
end

PTASaka.FH.indexOf              = function(arr, f)
	for key, value in pairs(arr) do
		if f(value) then return key end
	end
	return -1
end

PTASaka.FH.take                 = function(arr, n)
	local res = {}
	for i = 1, n, 1 do
		if not arr[i] then return res end
		table.insert(res, arr[i])
	end
	return res
end

PTASaka.FH.map_f                = function(arr, f)
	local res = {}
	for k, v in pairs(arr) do
		table.insert(res, f(v))
	end
	return res
end

PTASaka.FH.hands_to_named       = function(hands, name)
	local res = {}
	for k, v in pairs(hands) do
		table.insert(res, {
			hand = v,
			hand_type = name
		})
	end
	return res
end

PTASaka.FH.possible_straights   = function(cards)
	local ranked_cards = PTASaka.FH.filter(cards, function(c) return not SMODS.has_no_suit(c) end)
	local cards_by_rank = {}
	for _, card in pairs(ranked_cards) do
		local rank = tostring(card.base.id)
		if not cards_by_rank[rank] then
			cards_by_rank[rank] = card
		else
			-- only hold the best card in each rank
			if PTASaka.FH.calculate_importance(card) > PTASaka.FH.calculate_importance(cards_by_rank[rank], false) then
				cards_by_rank[rank] = card
			end
		end
	end

	-- Stripped out anything less than 5oak unless Four Fingers exists
	local fives = {}
	local fours = {}
	local current_run = {}
	if cards_by_rank["14"] then table.insert(current_run, cards_by_rank["14"]) end
	for i = 2, 15, 1 do
		local curr_rank = string.format(i)
		if cards_by_rank[curr_rank] then
			table.insert(current_run, cards_by_rank[curr_rank])
		else
			if #current_run >= 5 then
				local hand_to_add = {}
				for j = #current_run, #current_run - 4, -1 do
					table.insert(hand_to_add, current_run[j])
				end
				table.insert(fives, hand_to_add)
				current_run = {}
			elseif #current_run == 4 and next(SMODS.find_card('j_four_fingers')) then
				table.insert(fours, current_run)
				current_run = {}
			else
				current_run = {}
			end
		end
	end
	local str = "Straight"
	local straight_flushes = {}
	local straight_spectrums = {}
	local tbl = next(SMODS.find_card('j_four_fingers')) and fours or fives
	if next(tbl) then
		for _, set in ipairs(tbl) do
			local suit = set[1].base.suit
			local different = true
			local all_suits = {}
			local flush = true
			for _, c in ipairs(set) do
				if not c:is_suit(suit) then
					flush = false
				end
				local spec_suit = SMODS.has_any_suit(c) and "wild" or c.base.suit
				if not all_suits[spec_suit] then
					all_suits[spec_suit] = true
				else
					different = false
				end
			end
			if different then straight_spectrums[#straight_spectrums+1] = set end
			if flush then straight_flushes[#straight_flushes + 1] = set end
		end
	end
	local res = {}
	if next(SMODS.find_card('j_four_fingers')) then
		res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(fours, str))
		res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(fives, str))
	else
		res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(fives, str))
	end
	res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(straight_flushes, "Straight Flush"))
	res = spectrums_enabled and PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(straight_spectrums, "Straight Spectrum")) or res
	return res
end

PTASaka.FH.possible_flushes     = function(cards)
	local dictionary = {}
	local wilds = {}

	for i, v in pairs(cards) do
		local suit = SMODS.has_any_suit(v) and "wild" or v.base.suit
		if suit == "wild" then
			table.insert(wilds, v)
		else
			if not dictionary[suit] then
				dictionary[suit] = {}
			end
			table.insert(dictionary[suit], v)
		end
	end

	if next(find_joker("Smeared Joker")) then
		dictionary = {
			black = PTASaka.FH.merge(dictionary.Spades or {}, dictionary.Clubs or {}),
			red = PTASaka.FH.merge(dictionary.Hearts or {}, dictionary.Diamonds or {})
		}
	end
	table.sort(wilds,
		function(x, y) return PTASaka.FH.calculate_importance(x, true) > PTASaka.FH.calculate_importance(y, true) end)

	local res = {}
	for k, v in pairs(dictionary) do
		table.sort(v,
			function(x, y) return PTASaka.FH.calculate_importance(x, true) > PTASaka.FH.calculate_importance(y, true) end)
		local flush_hand = PTASaka.FH.take(v, 5)
		if #flush_hand < 5 and #wilds > 0 then
			flush_hand = PTASaka.FH.merge(flush_hand, PTASaka.FH.take(wilds, 5 - #flush_hand))
		end
		if #flush_hand == 5 or (next(SMODS.find_card('j_four_fingers')) and #flush_hand == 4) then
			table.insert(res, {
				hand = flush_hand,
				hand_type = "Flush"
			})
		end
	end
	return res
end

PTASaka.FH.next_best_hand       = function(possible_hands, curr_hand, hasher)
	if #possible_hands == 1 then return possible_hands[1].hand end
	if #possible_hands == 0 then return {} end
	if #curr_hand == 0 then return possible_hands[1].hand end

	-- if curr_hand is found in possible hands, select the next one
	-- otherwise, if only 1 card is selected, select best hand containing it
	-- otherwise, select best hand containing it (but is slower)
	local best_superset = false
	for i = 1, #possible_hands do
		if PTASaka.FH.is_subset(curr_hand, possible_hands[i].hand, hasher) then
			if #curr_hand == #possible_hands[i].hand then
				if i == #possible_hands then
					return possible_hands[1].hand
				else
					return possible_hands[i + 1].hand
				end
			elseif #curr_hand == 1 then
				return possible_hands[i].hand
			else
				if not best_superset then
					best_superset = possible_hands[i].hand
				end
			end
		end
	end
	if best_superset then
		return best_superset
	end
	return possible_hands[1].hand
end

PTASaka.FH.best_ofakinds        = function(cards)
	local fives, fours, trips, twos, ones = {}, {}, {}, {}, {}
	local rank_counts = {}
	for i, card in pairs(cards) do
		local rank = tostring(SMODS.has_no_suit(card) and "stone" or card.base.id)
		if not (rank == "stone") then
			if not rank_counts[rank] then
				rank_counts[rank] = {}
			end
			table.insert(rank_counts[rank], card)
		end
	end
	for k, v in pairs(rank_counts) do
		table.sort(v,
			function(x, y) return PTASaka.FH.calculate_importance(x, true) > PTASaka.FH.calculate_importance(y, true) end)
		if #v >= 5 then
			table.insert(fives, PTASaka.FH.take(v, 5))
		elseif #v == 4 then
			table.insert(fours, v)
		elseif #v == 3 then
			table.insert(trips, v)
		elseif #v == 2 then
			table.insert(twos, v)
		end
		table.insert(ones, v)
	end
	local union = {}
	local full_houses = {}
	local two_pairs = {}
	union = PTASaka.FH.merge(union, fives)
	union = PTASaka.FH.merge(union, fours)
	union = PTASaka.FH.merge(union, trips)

	for i = 1, (#union - 1) do
		for j = i + 1, #union do
			table.insert(full_houses, PTASaka.FH.merge(
				PTASaka.FH.take(union[i], 3),
				PTASaka.FH.take(union[j], 2)
			))
			table.insert(full_houses, PTASaka.FH.merge(
				PTASaka.FH.take(union[i], 2),
				PTASaka.FH.take(union[j], 3)
			))
		end
	end
	for i = 1, #union do
		for k, v in pairs(twos) do
			table.insert(full_houses, PTASaka.FH.merge(v, PTASaka.FH.take(union[i], 3)))
		end
	end
	for i = 1, (#twos - 1) do
		for j = i + 1, #twos do
			table.insert(two_pairs, PTASaka.FH.merge(twos[i], twos[j]))
		end
	end
	local flush_houses = {}
	local spectrum_houses = {}
	local flush_fives = {}
	local spectrum_fives = {}
	if next(full_houses) then
		for _, set in ipairs(full_houses) do
			local suit = set[1].base.suit
			local different = true
			local all_suits = {}
			local flush = true
			for _, c in ipairs(set) do
				if not c:is_suit(suit) then
					flush = false
				end
				local spec_suit = SMODS.has_any_suit(c) and "wild" or c.base.suit
				if not all_suits[spec_suit] then
					all_suits[spec_suit] = true
				else
					different = false
				end
			end
			if flush then flush_houses[#flush_houses + 1] = set end
			if different then spectrum_houses[#spectrum_houses+1] = set; print("found spectrum haus") end
		end
	end
	-- Handle Flush Five v. Five of a Kind v. Spectrum Five
	if next(fives) then
		for _, set in ipairs(fives) do
			local suit = set[1].base.suit
			local different = true
			local all_suits = {}
			local flush = true
			for _, c in ipairs(set) do
				if not c:is_suit(suit) then
					flush = false
				end
				local spec_suit = SMODS.has_any_suit(c) and "wild" or c.base.suit
				if not all_suits[spec_suit] then
					all_suits[spec_suit] = true
				else
					different = false
				end
			end
			if flush then flush_fives[#flush_fives + 1] = set end
			if different then spectrum_fives[#spectrum_fives+1] = set; print("found spectrum fives") end
		end
	end
	local res = {}
	res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(fives, "Five of a Kind"))
	res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(flush_fives, "Flush Five"))
	res = spectrums_enabled and PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(spectrum_fives, "Spectrum Five")) or res
	res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(fours, "Four of a Kind"))
	res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(full_houses, "Full House"))
	res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(flush_houses, "Flush House"))
	res = spectrums_enabled and PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(spectrum_houses, "Spectrum House")) or res
	res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(trips, "Three of a Kind"))
	res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(two_pairs, "Two Pair"))
	res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(twos, "Pair"))
	res = PTASaka.FH.merge(res, PTASaka.FH.hands_to_named(ones, "High Card"))
	return res
end

PTASaka.FH.select_hand          = function(cards)
	G.hand:unhighlight_all()
	for k, v in pairs(cards) do
		if PTASaka.FH.indexOf(G.hand.highlighted, function(x) return x == v end) == -1 then
			G.hand:add_to_highlighted(v, true)
		end
	end
	-- absolutely nothing
	if #G.hand.highlighted == 0 then
		local highest_id = 0
		local c = nil
		for k, v in ipairs(G.hand.cards) do
			if highest_id ~= math.max(highest_id, v.base.id) then
				c = v
			end
			highest_id = math.max(highest_id, v.base.id)
		end
		G.hand:add_to_highlighted(c, true)
	end
	local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
	update_hand_text({
		sound = nil,
		volume = 0.4,
		immediate = true,
		nopulse = nil,
		delay = 0
	},
		{ handname = disp_text, level = G.GAME.hands[text].level, mult = G.GAME.hands[text].mult, chips = G.GAME.hands
		[text].chips })
	play_sound("cardSlide1")
end
