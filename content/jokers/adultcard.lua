local cest = card_eval_status_text
function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
	if card.area == PTASaka.adultcard_cardarea and PTASaka.adultcard_cardarea.pta_owner then card = PTASaka.adultcard_cardarea.pta_owner end
	cest(card, eval_type, amt, percent, dir, extra)
end

-- Adult Card
SMODS.Joker {
	name = "Adult Card",
	key = "buruakacard",
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 1, y = 1 },
	config = { extra = { next_joker = nil, next_joker_name = nil, rigged_next_joker = 1 } },
	cost = 10,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = PTASaka.DescriptionDummies["dd_payasaka_adultcard_area"]
		return { 
			key = "j_payasaka_buruakacard"..((card.ability and card.ability.cry_rigged) and "_alt" or ""),
			set = "Joker",
		}
	end,
	blueprint_compat = true,
	update = function(self, card, dt)
		-- Sanity checks
		if not G.STAGE == G.STAGES.RUN then return nil end
		
		-- Rigged
		if card.ability.cry_rigged and not PTASaka.adultcard_fucked then
			-- Write a better solution to this that does not put this globally
			card.config.center.rarity = "cry_exotic"
			card.children.center:set_sprite_pos({x = 2, y = 1})
			PTASaka.adultcard_fucked = true
		end
	end,
	calculate = function(self, card, context)
		-- Sanity checks
		if not G.STAGE == G.STAGES.RUN then return nil end
		if not PTASaka.adultcard_cardarea then return nil end
		if not PTASaka.adultcard_cardarea.cards[1] then return nil end
		
		--[[
		if card.ability.cry_rigged then
			PTASaka.adultcard_cardarea.T.x = card.VT.x
			
			-- Go through all cards
			for i = 1, #PTASaka.adultcard_cardarea.cards do
				--G.E_MANAGER:add_event(Event({blocking = false, 
				--function()
					local joker = PTASaka.adultcard_cardarea.cards[i]
					local ret = joker:calculate_joker(context)
					--print("joker mr")
					if ret and type(ret) == "table" then ret.message_card = card; ret.card = card; SMODS.calculate_effect(ret, card) end
				--	return true
				--end
				--}))
			end
			
			return
		end
		]]
		
		-- Randomly use a different joker if we don't have a next one set yet
		local jkr = card.ability.extra.next_joker
		if not jkr then jkr = pseudorandom(pseudoseed('payasaka_adultcard'), 1, #PTASaka.adultcard_cardarea.cards) end
		local joker = PTASaka.adultcard_cardarea.cards[jkr]
		if not joker then return end
		PTASaka.adultcard_cardarea.T.x = card.VT.x
		PTASaka.adultcard_cardarea.pta_owner = card
		--local new_context = PTASaka.deep_copy(context)
		
		local ret = joker:calculate_joker(context)

		if not joker.ptasaka_juice_up then
			joker.ptasaka_juice_up = joker.juice_up
		end
		rawset(joker, "juice_up", function(self, m, m2)
			if (not card) and self.ptasaka_juice_up then return self:ptasaka_juice_up(m,m2) end
			return card:juice_up(m,m2)
		end)
		
		-- Only change when we NEED to
		-- todo: figure that out
	--	if change then
		if ret and type(ret) == "table" then 
			ret.message_card = card 
			ret.card = card
		end
		card.ability.extra.next_joker = pseudorandom(pseudoseed('payasaka_adultcard'), 1, #PTASaka.adultcard_cardarea.cards)
		--end
		return ret
	end,
	remove_from_deck = function(self, card, debuff)
		if card.ability.cry_rigged then
			card.config.center.rarity = 3
			--G.P_CENTERS.j_payasaka_buruakacard.pos.x = 1
			PTASaka.adultcard_fucked = false
		end
	end,
	draw = function(self, card, layer)
		if card.ability.cry_rigged then
			card.children.center:draw_shader('voucher', nil, card.ARGS.send_to_shader)
		end
	end
}

-- Handle Adult Card saving
local go = Game.start_run
function Game:start_run(args)
	G.P_CENTERS.j_payasaka_buruakacard.pos.x = 1
	G.P_CENTERS.j_payasaka_buruakacard.config.rarity = 3
	self.payasaka_adultcard_cardarea = CardArea(0,0,self.CARD_W,self.CARD_H,{card_limit = 1, type = 'joker', highlight_limit = 1})
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
	-- We don have it yet!
	local wehavit = false
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i].ability.name == "Adult Card" then 
			wehavit = true
			break
		end
	end
	if not wehavit then return end
	G.E_MANAGER:add_event(Event({delay = 0.8,func = function()
		local new_joker = PTASaka.deep_copy(self)
		PTASaka.adultcard_cardarea.config.card_limit = PTASaka.adultcard_cardarea.config.card_limit + 1
		--G.jokers:remove_card(self)
		PTASaka.adultcard_cardarea:emplace(new_joker)
		-- Prioritize sold card
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].ability.name == "Adult Card" then 
				G.jokers.cards[i].ability.extra.next_joker = #PTASaka.adultcard_cardarea.cards 
				G.jokers.cards[i].ability.extra.next_joker_name = G.P_CENTERS[PTASaka.adultcard_cardarea.cards[G.jokers.cards[i].ability.extra.next_joker].config.center.key].key
				card_eval_status_text(G.jokers.cards[i], 'extra', nil, nil, nil,
					{ message = "Changed!" })
			end
		end
		return true
	end}))
end
