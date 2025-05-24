SMODS.Joker {
	key = 'suittaker',
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 6, y = 4 },
	cost = 7,
	blueprint_compat = true,
	demicoloncompat = true,
	config = { extra = { suit = 'Hearts', x_mult = 1.5 } },
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	update = function(self, card, dt)
	end,
	calculate = function(self, card, context)
		if context.hand_drawn and not context.blueprint then
			local count = 0
			for i = 1, #G.hand.cards do
				local c = G.hand.cards[i]
				if c:is_suit(card.ability.extra.suit) then
					SMODS.debuff_card(c, true, 'payasaka_lady')
					count = count + 1
					c:juice_up(0.2, 0.3)
				end
			end
			if count > 0 then
				card:juice_up()
				play_sound('timpani')
			end
		end
		if context.individual and context.cardarea == G.hand and not context.end_of_round then
			if context.other_card and context.other_card.debuff then
				return {
					xmult = card.ability.extra.x_mult
				}
			end
		end
		if context.forcetrigger then
			return {
				xmult = card.ability.extra.x_mult
			}
		end
		if context.end_of_round and not context.game_over and not context.individual and not context.blueprint then
			-- Reset debuffs
			for _, area in ipairs({G.hand, G.discard, G.play}) do
				for i = 1, #area.cards do
					local c = area.cards[i]
					SMODS.debuff_card(c, false, 'payasaka_lady')
				end
			end
			-- Only use suits of cards available in the deck
			local valid = {}
			for _, v in ipairs(G.playing_cards or {}) do
				if not SMODS.has_no_suit(v) then valid[#valid + 1] = { card_key = string.sub(v.base.suit, 1, 1), key = v.base.suit } end
			end
			-- Ok then.
			if not valid[1] then valid = {SMODS.Suits['Hearts']} end
			card.ability.extra.suit = pseudorandom_element(valid, pseudoseed('payasaka_suittaker')).key
		end
	end,
	set_ability = function(self, card, initial, delay_sprites)
		-- Only use suits of cards available in the deck
		local valid = {}
		for _, v in ipairs(G.playing_cards or {}) do
			if not SMODS.has_no_suit(v) then valid[#valid + 1] = { card_key = string.sub(v.base.suit, 1, 1), key = v.base.suit } end
		end
		-- Ok then.
		if not valid[1] then valid = {SMODS.Suits['Hearts']} end
		card.ability.extra.suit = pseudorandom_element(valid, pseudoseed('payasaka_suittaker')).key
	end,
	loc_vars = function(self, info_queue, card)
		local backup_suit = card.ability.extra.suit or 'Hearts'
		return {
			vars = { card.ability.extra.x_mult, localize(backup_suit, "suits_singular"), colours = { G.C.SUITS[backup_suit] or G.C.UI.TEXT_DARK } }
		}
	end
}