-- HOOKS --

-- Hook to change card juiced in text notifications
local cest = card_eval_status_text
function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
	if G.STAGE == G.STAGES.RUN and PTASaka.adultcard_cardarea and PTASaka.adultcard_cardarea.cards[1] and card.area == PTASaka.adultcard_cardarea and PTASaka.adultcard_cardarea.pta_owner then
		--PTASaka.adultcard_cardarea.T.x = PTASaka.adultcard_cardarea.pta_owner.VT.x
		card = PTASaka.adultcard_cardarea.pta_owner
	end
	cest(card, eval_type, amt, percent, dir, extra)
end

-- Hook to change general juice up calls to the current owner of le card
local juice = Card.juice_up
function Card:juice_up(m, m2)
	local c = self
	if G.STAGE == G.STAGES.RUN and PTASaka.adultcard_cardarea and PTASaka.adultcard_cardarea.cards[1] and c.area == PTASaka.adultcard_cardarea and PTASaka.adultcard_cardarea.pta_owner and c ~= PTASaka.adultcard_cardarea.pta_owner then
		--PTASaka.adultcard_cardarea.T.x = PTASaka.adultcard_cardarea.pta_owner.VT.x
		c = PTASaka.adultcard_cardarea.pta_owner
	end
	juice(c, m, m2)
end

-- Hook to find cards in PTASaka.adultcard_cardarea
local find_old = SMODS.find_card
function SMODS.find_card(key, count_debuffed)
	local ret = find_old(key, count_debuffed)
	if not PTASaka.adultcard_cardarea then return ret end
	if not PTASaka.adultcard_cardarea.cards then return ret end
	if not PTASaka.adultcard_cardarea.cards[1] then return ret end

	for _, v in ipairs(PTASaka.adultcard_cardarea.cards) do
		if v and type(v) == 'table' and v.config.center.key == key and (count_debuffed or not v.debuff) then
			ret[#ret + 1] = v
		end
	end

	return ret
end

-- Adult Card
SMODS.Joker {
	name = "Adult Card",
	key = "buruakacard",
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 1, y = 1 },
	config = { extra = { next_joker = nil } },
	cost = 10,
	loc_vars = function(self, info_queue, card)
		-- Only show up when we actually have something in it
		if PTASaka.adultcard_cardarea and PTASaka.adultcard_cardarea.cards[1] then
			info_queue[#info_queue + 1] = PTASaka.DescriptionDummies["dd_payasaka_adultcard_area"]
		end
		return {
			key = "j_payasaka_buruakacard" .. ((card.ability and card.ability.cry_rigged) and "_alt" or ""),
			set = "Joker",
		}
	end,
	blueprint_compat = true,
	demicoloncompat = true,
	update = function(self, card, dt)
		-- Sanity checks
		if not G.STAGE == G.STAGES.RUN then return end

		-- Rigged, special conditions
		if card.ability.cry_rigged then
			-- Write a better solution to changing the rarity that does not put this globally
			if Cryptid then
				card.config.center.rarity = "cry_exotic"
			end
			card.children.center:set_sprite_pos({ x = 2, y = 1 })
			for i = 1, #PTASaka.adultcard_cardarea.cards do
				-- fix me
				local joker = PTASaka.adultcard_cardarea.cards[i]
				joker:update(dt)
			end
		end
	end,
	calc_dollar_bonus = function(self, card)
		if not G.STAGE == G.STAGES.RUN then return nil end

		-- Rigged, special conditions
		if card.ability.cry_rigged then
			local bonus = 0

			for i = 1, #PTASaka.adultcard_cardarea.cards do
				local joker = PTASaka.adultcard_cardarea.cards[i]
				if joker.calculate_dollar_bonus then
					bonus = bonus + (joker:calculate_dollar_bonus() or 0)
				end
			end
			if bonus == 0 then return nil end
			return bonus
		end

		-- Randomly use a different joker if we don't have a next one set yet
		local jkr = card.ability.extra.next_joker
		if not jkr then jkr = pseudorandom(pseudoseed('payasaka_adultcard'), 1, #PTASaka.adultcard_cardarea.cards) end
		local joker = PTASaka.adultcard_cardarea.cards[jkr]
		if not joker then return end

		card.ability.extra.next_joker = pseudorandom(pseudoseed('payasaka_adultcard'), 1,
			#PTASaka.adultcard_cardarea.cards)
		if joker.calculate_dollar_bonus then
			local ret = (joker:calculate_dollar_bonus() or 0)
			if ret == 0 then return nil end
			return ret
		end
	end,
	calculate = function(self, card, context)
		-- Sanity checks
		if not G.STAGE == G.STAGES.RUN then return nil end
		if not PTASaka.adultcard_cardarea then return nil end
		if not PTASaka.adultcard_cardarea.cards[1] then return nil end

		-- Set the current owner of the card area to this card.
		-- Used in card_eval_status_text to change the card that gets the juice up
		PTASaka.adultcard_cardarea.pta_owner = context.blueprint_card or card

		-- Rigged >:))
		if card.ability.cry_rigged then
			local rets = {}

			-- Go through all cards
			for i = 1, #PTASaka.adultcard_cardarea.cards do
				local joker = PTASaka.adultcard_cardarea.cards[i]
				local ret = joker:calculate_joker(context)

				-- Add to final rets table if applicable
				if ret and type(ret) == "table" then
					ret.message_card = card; ret.card = card; rets[#rets + 1] = ret
				end
			end

			-- Recursively add to extra table for each calculated effect table
			-- FIXME: What if said effect table already has an extra table?
			return PTASaka.recursive_extra(rets, 1)
		end

		-- Randomly use a different joker if we don't have a next one set yet
		local jkr = card.ability.extra.next_joker
		if not jkr then jkr = pseudorandom(pseudoseed('payasaka_adultcard'), 1, #PTASaka.adultcard_cardarea.cards) end
		local joker = PTASaka.adultcard_cardarea.cards[jkr]
		if not joker then return end

		local ret = joker:calculate_joker(context)
		if ret and type(ret) == "table" then
			ret.message_card = card
			ret.card = card
		end
		card.ability.extra.next_joker = pseudorandom(pseudoseed('payasaka_adultcard'), 1,
			#PTASaka.adultcard_cardarea.cards)
		return ret
	end,
	--[[
	add_to_deck = function(self, card, debuff)
		if card.ability.cry_rigged then
			card.config.center.rarity = "cry_rigged"
			for i = 1, #PTASaka.adultcard_cardarea.cards do
				local joker = PTASaka.adultcard_cardarea.cards[i]
				joker:add_to_deck(debuff)
			end
		end
	end,
	remove_from_deck = function(self, card, debuff)
		if card.ability.cry_rigged then
			card.config.center.rarity = 3
			for i = 1, #PTASaka.adultcard_cardarea.cards do
				local joker = PTASaka.adultcard_cardarea.cards[i]
				joker:remove_from_deck(debuff)
			end
		end
	end,
	]]
	draw = function(self, card, layer)
		if card.ability.cry_rigged then
			card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
		end
	end
}

-- Handle Adult Card saving
local go = Game.start_run
function Game:start_run(args)
	G.P_CENTERS.j_payasaka_buruakacard.config.rarity = 3
	self.payasaka_adultcard_cardarea = CardArea(0, 0, self.CARD_W * 6, self.CARD_H,
		{ card_limit = 1, type = 'joker', highlight_limit = 0 })
	PTASaka.adultcard_cardarea = self.payasaka_adultcard_cardarea
	PTASaka.adultcard_fucked = false
	-- Do not draw the current card area
	-- We don't need to anyway
	PTASaka.adultcard_cardarea.draw = function() end
	go(self, args)
end

local sell = Card.sell_card
function Card:sell_card()
	sell(self)
	-- Not a joker....
	if self.ability.set ~= "Joker" then return end
	if self.ability.name == "Adult Card" then return end -- No.
	if self.ability.name == "payasaka_nil" then return end -- No!
	-- We don have it yet!
	local wehavit = false
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i].ability.name == "Adult Card" then
			wehavit = true
			break
		end
	end
	if not wehavit then return end
	G.E_MANAGER:add_event(Event({
		delay = 0.8,
		func = function()
			local new_joker = PTASaka.deep_copy(self)
			PTASaka.adultcard_cardarea.config.card_limit = PTASaka.adultcard_cardarea.config.card_limit + 1
			--G.jokers:remove_card(self)
			PTASaka.adultcard_cardarea:emplace(new_joker)
			new_joker:add_to_deck()
			-- Prioritize sold card
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].ability.name == "Adult Card" then
					G.jokers.cards[i].ability.extra.next_joker = #PTASaka.adultcard_cardarea.cards
					card_eval_status_text(G.jokers.cards[i], 'extra', nil, nil, nil,
						{ message = localize('k_payasaka_added_ex') })
				end
			end
			return true
		end
	}))
end
