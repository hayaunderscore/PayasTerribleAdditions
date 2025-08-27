function juice_card_endless(card, delay, id, remove, bypass)
	local queue_name = "payasaka_potential_juice_"..tostring(id)
	G.E_MANAGER.queues[queue_name] = G.E_MANAGER.queues[queue_name] or {}
	if (not bypass) or (not card) then G.E_MANAGER:clear_queue(queue_name) end
	if remove or (not card) then return end
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = delay or 0.1,
		blocking = false,
		blockable = false,
		timer = 'REAL',
		func = (function()
			card:juice_up(0.1, 0.1)
			juice_card_endless(card, 0.8, id, nil, true)
			return true
		end)
	}), queue_name)
end

local p_h_ref = CardArea.parse_highlighted
function CardArea:parse_highlighted()
	p_h_ref(self)
	local text = G.FUNCS.get_poker_hand_info(self.highlighted)
	if self == G.hand and G.STATE == G.STATES.SELECTING_HAND then
		for _, joker in ipairs(G.jokers.cards) do
			if joker.ability.name == "pta-Potential Energy" then
				juice_card_endless(joker, nil, joker.sort_id, joker.ability.extra.unique_hands[text or ""])
			end
		end
	end
end

-- Potential Energy
SMODS.Joker {
	name = "pta-Potential Energy",
	key = "potential",
	rarity = 3,
	atlas = "JOE_Jokers2",
	pos = { x = 5, y = 7 },
	soul_pos = { x = 5, y = 8 },
	cost = 8,
	blueprint_compat = false,
	demicoloncompat = true,
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
	config = { extra = { num = 1, den = 10, unique_hands = { NULL = true } } },
	calculate = function(self, card, context)
		if context.before and not card.ability.extra.unique_hands[context.scoring_name] then
			card.ability.extra.unique_hands[context.scoring_name] = true
			card.ability.extra.num = card.ability.extra.num + 1
			return {
				message = localize('k_upgrade_ex')
			}
		end
		if context.press_play and not context.blueprint_card then
			juice_card_endless(card, nil, card.sort_id, true)
		end
		if context.selling_self and card.area and not context.blueprint_card then
			if SMODS.pseudorandom_probability(card, 'potential', card.ability.extra.num, card.ability.extra.den) then
				if #card.area.cards <= card.area.config.card_limit then
					local eligible_copy = {}
					for k, v in pairs(card.area.cards) do
						if v and v ~= card then eligible_copy[#eligible_copy + 1] = v end
					end
					local copy = pseudorandom_element(eligible_copy, 'potential_jokr')
					---@type Card
					local c = copy_card(copy)
					c:add_to_deck()
					card.area:emplace(c)
					return {
						message = localize('k_duplicated_ex')
					}
				else
					return {
						message = localize('k_no_room_ex')
					}
				end
			end
		end
		if context.forcetrigger then
			if #card.area.cards <= card.area.config.card_limit then
				local eligible_copy = {}
				for k, v in pairs(card.area.cards) do
					if v and v ~= card then eligible_copy[#eligible_copy + 1] = v end
				end
				local copy = pseudorandom_element(eligible_copy, 'potential_jokr')
				---@type Card
				local c = copy_card(copy)
				c:add_to_deck()
				card.area:emplace(c)
				return {
					message = localize('k_duplicated_ex')
				}
			else
				return {
					message = localize('k_no_room_ex')
				}
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den)
		return { vars = { num, den } }
	end
}
