-- Locomotive Getaway
SMODS.Joker {
	name = "Locomotive Getaway",
	key = 'locomotive',
	rarity = "payasaka_ahead",
	cost = 10,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	demicoloncompat = true,
	--eternal_compat = false, -- Needed for Stuck challenge
	perishable_compat = false,
	pos = { x = 2, y = 3 },
	atlas = "JOE_Jokers",
	config = { extra = { give_x_chip = 0.5, x_chips = 1 } },
	pools = {["Joker"] = true, ["Meme"] = true},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.give_x_chip, card.ability.extra.x_chips }
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint_card then
			local start_here = false
			local played_sound = false
			for j = 1, #G.jokers.cards do
				if start_here and not G.jokers.cards[j].ability.eternal and G.jokers.cards[j].config.center.key ~= "j_payasaka_locomotive" and G.jokers.cards[j].config.center.key ~= "j_payasaka_nil" then
					if G.jokers.cards[j].ability.name ~= "cry-altgoogol" then
						G.jokers.cards[j]:remove_from_deck()
					end
					G.jokers.cards[j]:set_ability(G.P_CENTERS.j_payasaka_nil)
					G.jokers.cards[j]:add_to_deck()
					G.jokers.cards[j]:juice_up()
					if not played_sound then
						play_sound('slice1', 0.96 + math.random() * 0.08)
						card:juice_up()
						played_sound = true
					end
					card.ability.extra.x_chips = card.ability.extra.x_chips + card.ability.extra.give_x_chip
					--card.states.drag.is = false
					card_eval_status_text(G.jokers.cards[j], 'extra', nil, nil, nil, { message = localize('k_payasaka_nil_ex'), instant = true })
				end
				if G.jokers.cards[j] == (card.area == PTASaka.adultcard_cardarea and PTASaka.adultcard_cardarea.pta_owner or card) then
					start_here = true
					-- pin it to the far right
					G.E_MANAGER:add_event(Event {
						func = function()
							card.old_pinned = card.pinned
							card.ability.pinned = true
							card.pinned = true
							card.old_sort_id = card.sort_id
							card.sort_id = -9999999
							return true
						end
					})
				end
			end
			-- unpin it
			G.E_MANAGER:add_event(Event {
				trigger = "after",
				func = function()
					card.ability.pinned = card.old_pinned
					card.pinned = card.old_pinned
					card.sort_id = card.old_sort_id
					return true
				end
			})
		end
		if context.joker_main or context.forcetrigger then
			return {
				x_chips = card.ability.extra.x_chips,
			}
		end
	end
}
