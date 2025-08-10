SMODS.Blind {
	key = 'showdown_the_nameless',
	atlas = "JOE_Blinds",
	pos = { x = 0, y = 11 },
	dollars = 8,
	mult = 2,
	boss_colour = HEX('d68ac1'),
	boss = { min = 0, showdown = true, odds = 3 },
	calculate = function(self, blind, context)
		if context.hand_drawn then
			for k, v in pairs(context.hand_drawn) do
				if SMODS.pseudorandom_probability(G.deck.cards[1], 'nameless', 1, self.boss.odds) and not v.ability.payasaka_old_suit then
					-- change it lmao
					assert(SMODS.change_base(v, "payasaka_washed", nil))
					v:juice_up(0.1, 0.1)
				end
			end
		end
	end,
	loc_vars = function(self)
		local num, den = SMODS.get_probability_vars(G.deck.cards[1], 1, self.boss.odds)
		return { vars = { num, den } }
	end,
	collection_loc_vars = function (self)
		return { vars = { 1, self.boss.odds } }
	end,
	get_loc_debuff_text = function(self)
		return "Washed out cards cannot be used in Flushes!"
	end
}

SMODS.Atlas {
	key = 'washed',
	path = "washed.png",
	px = 71, py = 95
}
SMODS.Atlas {
	key = 'washed_hc',
	path = "washed_hc.png",
	px = 71, py = 95
}
SMODS.Atlas {
	key = 'washed_ui',
	path = "washed.png",
	px = 18, py = 18
}
SMODS.Atlas {
	key = 'washed_ui_hc',
	path = "washed_hc.png",
	px = 18, py = 18
}

SMODS.Suit {
	key = 'washed',
	card_key = 'PTA_W',
	pos = { y = 1 },
	ui_pos = { x = 0, y = 0 },
	lc_atlas = 'washed',
	hc_atlas = 'washed_hc',
	lc_ui_atlas = 'washed_ui',
	hc_ui_atlas = 'washed_ui_hc',
	-- Not gonna bother doing *proper* localization for this for now
	loc_txt = {
		singular = "Nothing",
		plural = "Nothings"
	},
	in_pool = function(self, args)
		return false
	end,
}

local is_suit_ref = Card.is_suit
function Card:is_suit(suit, ...)
	if self.base.suit == "payasaka_washed" then return false end
	return is_suit_ref(self, suit, ...)
end