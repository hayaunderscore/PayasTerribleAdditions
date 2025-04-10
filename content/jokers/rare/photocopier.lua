-- Photocopier
SMODS.Joker {
	name = "Photocopier",
	key = "photocopier",
	-- Note: old_jkrs isn't saved
	config = { extra = { coolmult = 2, old_jkrs = { nil, nil } } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.coolmult } }
	end,
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 4, y = 0 },
	cost = 15,
	blueprint_compat = false,
	update = function(self, card2, dt)
		if G.STAGE == G.STAGES.RUN then
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

			-- Do not affect other Photocopiers....
			if cards[1] and cards[1].config.center.key == card2.config.center.key then cards[1] = nil end
			if cards[2] and cards[2].config.center.key == card2.config.center.key then cards[2] = nil end

			local mult = card2.ability.extra.coolmult
			-- Switched jokers, halve the old one
			if card2.ability.extra.old_jkrs[1] and card2.ability.extra.old_jkrs[1] ~= cards[1] then
				local jkr = card2.ability.extra.old_jkrs[1]
				if jkr.config and not Card.no(jkr, "immutable", true) then
					PTASaka.Photocopy(jkr, mult, true, card2.ID)
				end
			end
			if card2.ability.extra.old_jkrs[2] and card2.ability.extra.old_jkrs[2] ~= cards[2] then
				local jkr = card2.ability.extra.old_jkrs[2]
				if jkr.config and not Card.no(jkr, "immutable", true) then
					PTASaka.Photocopy(jkr, mult, true, card2.ID)
				end
			end

			-- Switched jokers, double the new one
			if cards[1] and not cards[1].ability.payasaka_photocopied[card2.ID] and not Card.no(cards[1], "immutable", true) then
				PTASaka.Photocopy(cards[1], mult, false, card2.ID)
			end
			if cards[2] and not cards[2].ability.payasaka_photocopied[card2.ID] and not Card.no(cards[2], "immutable", true) then
				PTASaka.Photocopy(cards[2], mult, false, card2.ID)
			end

			card2.ability.extra.old_jkrs = cards
		end
	end,
}
