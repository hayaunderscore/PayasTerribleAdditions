if not Ortalab then return end

-- Monster Energy -> Baja Blast
SMODS.Joker {
	key = 'bajablast',
	config = { extra = { xchips = 3, decrease = 0.05 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xchips, card.ability.extra.decrease } }
	end,
	rarity = 1,
	atlas = "JOE_Jokers",
	pos = { x = 8, y = 3 },
	cost = 3,
	blueprint_compat = true,
	demicoloncompat = true,
	dependencies = 'ortalab',
	pools = {["Joker"] = true, ["Food"] = true},
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not card.payasaka_nonexistent then
			if context.other_card and context.other_card:is_suit("Spades") or context.other_card:is_suit("Clubs") then
				card.ability.extra.xchips = card.ability.extra.xchips - card.ability.extra.decrease
				if card.ability.extra.xchips <= 1 then
					card.payasaka_nonexistent = true
					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound('tarot1')
							card.T.r = -0.2
							card:juice_up(0.3, 0.4)
							card.states.drag.is = true
							card.children.center.pinch.x = true
							-- This part destroys the card.
							G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.3,
								blockable = false,
								func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
									return true;
								end
							}))
							return true
						end
					}))
					return {
						message = localize('k_drank_ex'),
						card = card
					}
				end
				return {
					message = localize('k_payasaka_monster_sip'),
					card = card
				}
			end
		end
		if (context.joker_main or context.forcetrigger) and not card.payasaka_nonexistent then
			return {
				xchips = card.ability.extra.xchips
			}
		end
	end
}

local function find_joker_by_sort_id(id)
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i].sort_id == id then
			return G.jokers.cards[i]
		end
	end
	return nil
end

-- Silenced -> Scrapped
SMODS.Joker {
	key = 'scrapped',
	config = { extra = { x_chips = 1.5 } },
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 9, y = 0 },
	soul_pos = { x = 10, y = 0 },
	pta_front_pos = { x = 10, y = 1 },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = true,
	dependencies = 'ortalab',
	calculate = function(self, card, context)
		local extra = card.ability.extra
		if (context.individual and not context.end_of_round) then
			if context.cardarea == G.hand then
				if not context.other_card.ability.scrapped_trigger then
					context.other_card.ability.scrapped_trigger = true
				end
			end
			if context.cardarea == G.play then
				if context.other_card.ability.scrapped_trigger then
					return {
						x_chips = card.edition and card.edition.negative and extra.neg_x_chips or extra.x_chips
					}
				end
			end
		end
		if context.forcetrigger then
			return {
				x_chips = extra.x_chips
			}
		end
		if context.end_of_round and context.individual then
			if context.other_card.ability.scrapped_trigger then
				context.other_card.ability.scrapped_trigger = nil
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		local extra = card.ability.extra
		return {
			vars = { extra.x_chips }
		}
	end
}

-- Photocopier -> Photobinder
SMODS.Joker {
	key = "photobinder",
	config = { extra = { coolmult = 2 }, immutable = { old_ids = {}, payasaka_photocopied = {}, old_mult = 2 } },
	loc_vars = function(self, info_queue, card)
		local mult = card.ability.extra.coolmult >= 1e300 and "a lot" or card.ability.extra.coolmult
		return { vars = { mult } }
	end,
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 9, y = 3 },
	cost = 15,
	blueprint_compat = false,
	demicoloncompat = false,
	dependencies = 'ortalab',
	update = function(self, card2, dt)
		if G.STAGE == G.STAGES.RUN and card2.added_to_deck then
			-- Get cards from left and right
			local cards = { G.jokers.cards[1], G.jokers.cards[#G.jokers.cards] }

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

			-- Do not affect other Photocopiers....
			if cards[1] and cards[1].config.center.key == card2.config.center.key then cards[1] = nil end
			if cards[2] and cards[2].config.center.key == card2.config.center.key then cards[2] = nil end

			local mult = card2.ability.extra.coolmult
			-- Switched jokers, halve the old one
			if cards[1] and (card2.ability.immutable.old_ids[1] and card2.ability.immutable.old_ids[1] ~= cards[1].sort_id) then
				local jkr = find_joker_by_sort_id(card2.ability.immutable.old_ids[1])
				if jkr and jkr.config and not Card.no(jkr, "immutable", true) then
					PTASaka.Photocopy(jkr, mult, true, card2.sort_id)
				end
			end
			if cards[2] and card2.ability.immutable.old_ids[2] and card2.ability.immutable.old_ids[2] ~= cards[2].sort_id then
				local jkr = find_joker_by_sort_id(card2.ability.immutable.old_ids[2])
				if jkr and jkr.config and not Card.no(jkr, "immutable", true) then
					PTASaka.Photocopy(jkr, mult, true, card2.sort_id)
				end
			end

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
		local cards = { G.jokers.cards[1], G.jokers.cards[#G.jokers.cards] }

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

-- Arrowstone -> Club Cleaver
SMODS.Joker {
	key = "clubcleaver",
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	demicoloncompat = false,
	pos = { x = 10, y = 3 },
	atlas = "JOE_Jokers",
	config = { extra = { odds = 2, x_chips = 2 }, },
	pools = {["Joker"] = true, ["Meme"] = true},
	dependencies = 'ortalab',
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.x_chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and not context.end_of_round then
			local _c = context.other_card
			if _c and _c:is_suit('Clubs') and pseudorandom('payasaka_clubcleaver') < (G.GAME.probabilities.normal or 1)/card.ability.extra.odds then
				return {
					x_chips = card.ability.extra.x_chips
				}
			end
		end
	end
}

local finity_exists = next(SMODS.find_mod('finity'))
local f_dependency = {'ortalab'}
if finity_exists then f_dependency[#f_dependency+1] = 'finity' end

-- Joyous Spring -> MissingNo.
SMODS.Joker {
	key = 'missingno',
	config = { extra = { finity_count = 113, finity_mult = 1, finity_odds = 8 } },
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 6, y = 3 },
	soul_pos = { x = 7, y = 3 },
	cost = 24,
	blueprint_compat = true,
	demicoloncompat = true,
	dependencies = f_dependency,
	pta_credit = {
		art = {
			-- :]
			credit = 'missingnumber',
			colour = HEX('9489a7')
		},
	},
	calculate = function(self, card, context)
		local extra = card.ability.extra
		if context.forcetrigger or context.joker_main then
			return {
				x_mult = extra.finity_mult * extra.finity_count
			}
		end
		if (not context.blueprint) and finity_exists and context.end_of_round and (not context.individual) and context.cardarea == G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
			if (pseudorandom('finity_funny') < (G.GAME.probabilities.normal or 1)/extra.finity_odds) or card.ability.cry_rigged then
				G.E_MANAGER:add_event(Event{
					func = function()
						-- create a random finity joker
						local _card = SMODS.create_card({set = "Joker", rarity = "finity_showdown"})
						-- Cannot spawn more!
						if _card.ability.name == 'Joker' then
							_card:remove()
							_card = nil
							card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Failed!"})
							return true
						end
						-- We good
						_card:add_to_deck()
						play_sound('timpani')
						card:juice_up()
						G.jokers:emplace(_card)
						return true
					end
				})
			else
				return {
					message = localize('k_nope_ex')
				}
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		local extra = card.ability.extra
		info_queue[#info_queue+1] = { key = 'dd_payasaka_missingno_finity', set = 'DescriptionDummy', vars = { card.ability.cry_rigged and extra.finity_odds or (G.GAME.probabilities.normal or 1), extra.finity_odds } }
		return {
			vars = { extra.finity_mult, extra.finity_count }
		}
	end
}
