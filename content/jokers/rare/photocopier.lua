if not Card.no then
	function Card:no(m, no_no)
		if self.config and self.config.center and self.config.center[m] and self.config.center[m] == no_no then
			return true
		end
		return false
	end
end

local function find_joker_by_sort_id(id)
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i].sort_id == id then
			return G.jokers.cards[i]
		end
	end
	return nil
end

-- Photocopier
SMODS.Joker {
	name = "Photocopier",
	key = "photocopier",
	config = { extra = { coolmult = 2, is_rightmost = false }, immutable = { old_ids = {}, payasaka_photocopied = {}, current_position = -1 } },
	loc_vars = function(self, info_queue, card)
		local mult = card.ability.extra.coolmult >= 1e300 and "a lot" or card.ability.extra.coolmult
		return { vars = { mult } }
	end,
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 4, y = 0 },
	cost = 15,
	blueprint_compat = false,
	demicoloncompat = false,
	add_to_deck = function(self, card, from_debuff)
		card.ability.immutable.old_ids = {}
		card.ability.immutable.payasaka_photocopied = {}
	end,
	update = function(self, card2, dt)
		if G.STAGE == G.STAGES.RUN and card2.added_to_deck then
			-- Get cards from left and right
			local cards = { nil, nil }
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card2 then
					cards[1] = G.jokers.cards[i + 1]
					if i > 1 then
						cards[2] = G.jokers.cards[i - 1]
					end
				end
			end

			local pos = -1
			local area = card2.area
			for i,v in ipairs(area and area.cards or {}) do
				if v == card2 then pos = i break end
			end
			card2.ability.immutable.current_position = pos
			card2.ability.extra.is_rightmost = not not (pos >= #G.jokers.cards)

			-- do NOT exceed coolmult
			card2.ability.extra.coolmult = math.min(card2.ability.extra.coolmult, 1e300)

			-- erm...
			if cards[1] and cards[1].ability then 
				cards[1].ability.immutable = cards[1].ability.immutable or {}
				cards[1].ability.immutable.payasaka_photocopied = cards[1].ability.immutable.payasaka_photocopied or {}
			end
			if cards[2] and cards[2].ability then 
				cards[2].ability.immutable = cards[2].ability.immutable or {}
				cards[2].ability.immutable.payasaka_photocopied = cards[2].ability.immutable.payasaka_photocopied or {}
			end

			local mult = card2.ability.extra.coolmult
			-- Switched jokers, halve the old one
			if (not cards[1] and card2.ability.immutable.old_ids[1]) or (cards[1] and card2.ability.immutable.old_ids[1] and card2.ability.immutable.old_ids[1] ~= cards[1].sort_id) then
				local jkr = find_joker_by_sort_id(card2.ability.immutable.old_ids[1])
				if jkr and jkr.config and not Card.no(jkr, "immutable", true) then
					PTASaka.Photocopy(jkr, mult, true, card2.sort_id)
				end
			end

			if (not cards[2] and card2.ability.immutable.old_ids[2]) or (cards[2] and card2.ability.immutable.old_ids[2] and card2.ability.immutable.old_ids[2] ~= cards[2].sort_id) then
				local jkr = find_joker_by_sort_id(card2.ability.immutable.old_ids[2])
				if jkr and jkr.config and not Card.no(jkr, "immutable", true) then
					PTASaka.Photocopy(jkr, mult, true, card2.sort_id)
				end
			end

			-- Do not affect other Photocopiers....
			if cards[1] and cards[1].config.center.key == card2.config.center.key then cards[1] = nil end
			if cards[2] and cards[2].config.center.key == card2.config.center.key then cards[2] = nil end

			-- Switched jokers, double the new one
			if cards[1] and not cards[1].ability.immutable.payasaka_photocopied[card2.sort_id] and not Card.no(cards[1], "immutable", true) then
				PTASaka.Photocopy(cards[1], mult, false, card2.sort_id)
			end
			if cards[2] and not cards[2].ability.immutable.payasaka_photocopied[card2.sort_id] and not Card.no(cards[2], "immutable", true) then
				PTASaka.Photocopy(cards[2], mult, false, card2.sort_id)
			end

			card2.ability.immutable.old_ids = {
				cards[1] and cards[1].sort_id or -1,
				cards[2] and cards[2].sort_id or -1
			}
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if G.STAGE ~= G.STAGES.RUN then return end
		-- Get cards from left and right
		local cards = { nil, nil }
		
		if card.ability.immutable.current_position > 0 then
			local first_pos = card.ability.immutable.current_position
			if card.ability.extra.is_rightmost then
				cards[2] = G.jokers.cards[#G.jokers.cards]
			else
				cards[1] = G.jokers.cards[first_pos]
				if first_pos >= 2 then
					cards[2] = G.jokers.cards[first_pos-1]
				end
			end
		end

		-- erm...
		if cards[1] and cards[1].ability then 
			cards[1].ability.immutable = cards[1].ability.immutable or {}
			cards[1].ability.immutable.payasaka_photocopied = cards[1].ability.immutable.payasaka_photocopied or {}
		end
		if cards[2] and cards[2].ability then 
			cards[2].ability.immutable = cards[2].ability.immutable or {}
			cards[2].ability.immutable.payasaka_photocopied = cards[2].ability.immutable.payasaka_photocopied or {}
		end

		-- Do not affect other Photocopiers....
		if cards[1] and cards[1].config.center.key == card.config.center.key then cards[1] = nil end
		if cards[2] and cards[2].config.center.key == card.config.center.key then cards[2] = nil end

		local mult = card.ability.extra.coolmult
		if cards[1] then
			local jkr = cards[1]
			if jkr.config and not Card.no(jkr, "immutable", true) then
				PTASaka.Photocopy(jkr, mult, true, card.sort_id)
			end
		end
		if cards[2] then
			local jkr = cards[2]
			if jkr.config and not Card.no(jkr, "immutable", true) then
				PTASaka.Photocopy(jkr, mult, true, card.sort_id)
			end
		end
	end
}

