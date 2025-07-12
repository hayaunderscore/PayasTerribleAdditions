SMODS.Joker {
	name = "Huh! All 20s",
	key = "ha20s",
	atlas = "JOE_Jokers2",
	pos = { x = 6, y = 6 },
	rarity = 3,
	cost = 12,
	blueprint_compat = false,
	demicoloncompat = false,
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
	config = { extra = { trigger = false } },
	calculate = function(self, card, context)
		if ((context.retrigger_joker_check and not context.retrigger_joker) or context.repetition) and card.ability.extra.trigger then
			card.ability.extra.trigger = false
			return {
				repetitions = 1
			}
		end
		if context.payasaka_pseudorandom_result and context.trigger_obj and not card.ability.extra.trigger then
			---@type Card
			local c = context.trigger_obj
			if type(c) == 'table' and c:is(Card) and c.ability and (c.ability.set == "Joker" or c.ability.set == "Enhanced" or c.ability.set == 'Default') then
				card.ability.extra.trigger = true
			end
		end
	end,
}
