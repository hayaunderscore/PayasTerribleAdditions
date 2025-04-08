function PTASaka.calculate_adult_card_area(_type, context, args)
	local flags = {}
	
	for _, area in ipairs(SMODS.get_card_areas("adult_card")) do
		if args and args.joker_area and not args.has_area then context.cardarea = area end
		for _, _card in ipairs(area.cards) do
			--calculate the joker effects
			local eval, post = eval_card(_card, context)
			if args and args.main_scoring and eval.jokers then
				eval.jokers.juice_card = eval.jokers.juice_card or eval.jokers.card or _card
				eval.jokers.message_card = eval.jokers.message_card or eval.jokers.card or context.other_card
			end

			local effects = {eval}
			for _,v in ipairs(post) do effects[#effects+1] = v end
	
			if context.other_joker then
				for k, v in pairs(effects[1]) do
					v.other_card = _card
				end
			end

			if eval.retriggers then
				context.retrigger_joker = true
				for rt = 1, #eval.retriggers do
					context.retrigger_joker = eval.retriggers[rt].retrigger_card
					local rt_eval, rt_post = eval_card(_card, context)
					if args and args.main_scoring and rt_eval.jokers then
						rt_eval.jokers.juice_card = rt_eval.jokers.juice_card or rt_eval.jokers.card or _card
						rt_eval.jokers.message_card = rt_eval.jokers.message_card or rt_eval.jokers.card or context.other_card
					end
					table.insert(effects, {eval.retriggers[rt]})
					table.insert(effects, rt_eval)
					for _,v in ipairs(rt_post) do effects[#effects+1] = v end
				end
				context.retrigger_joker = nil
			end

			local f = SMODS.trigger_effects(effects, _card)
			for k,v in pairs(f) do flags[k] = v end
		end
	end
end

-- Adult Card
SMODS.Joker {
	name = "Adult Card",
	key = "buruakacard",
	loc_txt = {
		name = "Adult Card",
		text = {
			"Sold {C:attention}Jokers{}' effects",
			"can be mimicked by this Joker",
			"Joker mimicked changes every time",
			"a Joker could be triggered",
			"{C:inactive,s:0.8}Does not count other Adult Cards",
			"{C:inactive,s:0.8}A Blue Archive reference in my Balatro?",
			"{C:inactive,s:0.8}How absurd.",
		}
	},
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 1, y = 1 },
	config = { extra = { next_joker = nil, next_joker_name = nil, rigged_next_joker = 1 } },
	cost = 10,
	blueprint_compat = true,
	calculate = function(self, card, context)
		-- Sanity checks
		if not G.STAGE == G.STAGES.RUN then return nil end
		if not PTASaka.adultcard_cardarea then return nil end
		if not PTASaka.adultcard_cardarea.cards[1] then return nil end
		
		-- Rigged
		if card.ability.cry_rigged and not PTASaka.adultcard_fucked then
			-- Write a better solution to this that does not put this globally
			card.config.center.rarity = "cry_exotic"
			G.P_CENTERS.j_payasaka_buruakacard.pos.x = 2
			PTASaka.adultcard_fucked = true
		end
		
		-- Randomly use a different joker if we don't have a next one set yet
		local jkr = card.ability.extra.next_joker
		if not jkr then jkr = pseudorandom(pseudoseed('payasaka_adultcard'), 1, #PTASaka.adultcard_cardarea.cards) end
		local joker = PTASaka.adultcard_cardarea.cards[jkr]
		if not joker then return end
		PTASaka.adultcard_cardarea.T.x = card.VT.x
		--local new_context = PTASaka.deep_copy(context)
			
		local ret = joker:calculate_joker(context)
		--[[ This causes a crash when going back to the main menu for some reason
		if not joker.ptasaka_juice_up then
			joker.ptasaka_juice_up = joker.juice_up
		end
		rawset(joker, "juice_up", function(self, m, m2)
			if not card then return self:ptasaka_juice_up(m,m2) end
			return card:juice_up(m,m2)
		end)
		]]
		-- Only change when we NEED to
		-- todo: figure that out
	--	if change then
		card.ability.extra.next_joker = pseudorandom(pseudoseed('payasaka_adultcard'), 1, #PTASaka.adultcard_cardarea.cards)
		--end
		return ret
	end,
	remove_from_deck = function(self, card, debuff)
		card.config.center.rarity = 3
		G.P_CENTERS.j_payasaka_buruakacard.pos.x = 1
		PTASaka.adultcard_fucked = false
	end,
}

-- Handle Adult Card saving
local go = Game.start_run
function Game:start_run(args)
	G.P_CENTERS.j_payasaka_buruakacard.pos.x = 1
	G.P_CENTERS.j_payasaka_buruakacard.config.rarity = 3
	self.payasaka_adultcard_cardarea = CardArea(0,0,self.CARD_W,self.CARD_H,{card_limit = 1, type = 'joker', highlight_limit = 1})
	PTASaka.adultcard_cardarea = self.payasaka_adultcard_cardarea
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
