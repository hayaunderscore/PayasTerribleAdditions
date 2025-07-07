-- Potential Energy
SMODS.Joker {
	name = "pta-Potential Energy",
	key = "potential",
	rarity = 3,
	atlas = "JOE_Jokers2",
	pos = { x = 4, y = 6 },
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
	config = { extra = { num = 1, den = 10, unique_hands = {} } },
	calculate = function(self, card, context)
		if context.before and not card.ability.extra.unique_hands[context.scoring_name] then
			card.ability.extra.unique_hands[context.scoring_name] = true
			card.ability.extra.num = card.ability.extra.num + 1
			return {
				message = localize('k_upgrade_ex')
			}
		end
		if context.selling_self and card.area and not context.blueprint_card then
			if SMODS.pseudorandom_probability(card, 'potential', card.ability.extra.num, card.ability.extra.den) then
				if #card.area.cards <= card.area.config.card_limit then
					local eligible_copy = {}
					for k, v in pairs(card.area.cards) do
						if v and v ~= card then eligible_copy[#eligible_copy+1] = v end
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
					if v and v ~= card then eligible_copy[#eligible_copy+1] = v end
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
