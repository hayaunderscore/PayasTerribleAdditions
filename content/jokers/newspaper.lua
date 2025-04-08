-- Newspaper
SMODS.Joker {
	name = "Daily Newspaper",
	key = "newspaper",
	loc_txt = {
		name = "Daily Newspaper",
		text = {
			"When {C:attention}Blind{} is selected,",
			"add a card with a random",
			"{C:attention}edition{} to your deck",
			"{C:inactive,s:0.8}Random card takes suit from",
			"{C:inactive,s:0.8}available suits in the deck",
		}
	},
	config = { extra = { xmult = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 0, y = 1 },
	cost = 10,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.setting_blind and not card.getting_sliced and not (context.blueprint_card or card).getting_sliced then
			-- mangled from More Fluff
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.7,
				func = function() 
					-- Only use suits of cards available in the deck
					local valid = {}
					for _, v in ipairs(G.playing_cards) do
						if not SMODS.has_no_suit(v) then valid[#valid + 1] = {card_key = string.sub(v.base.suit, 1, 1)} end
					end
					-- Ok then.
					if not valid[1] then valid = SMODS.Suits end
					local suit = pseudorandom_element(valid, pseudoseed('payasaka_newspaper')).card_key
					local rank = pseudorandom_element(SMODS.Ranks, pseudoseed('payasaka_newspaper')).card_key
					local edition = poll_edition('payasaka_newspaper', nil, Cryptid == nil, true)
					local _card = create_playing_card(
						{front = G.P_CARDS[suit..'_'..rank]}, 
						G.hand, nil, false, {G.C.SECONDARY_SET.Spectral}
					)
					_card:set_edition(edition, true)
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
						{ message = "Reading..." })
					playing_card_joker_effects({true})
					return true 
				end 
			}))
			return true
		end
	end
}