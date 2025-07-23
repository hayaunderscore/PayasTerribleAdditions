PTASaka.RetriggerableCenters = {}

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
		if ((context.retrigger_joker_check and not context.retrigger_joker) or context.repetition) then
			if context.other_card and context.other_card.config and PTASaka.RetriggerableCenters[context.other_card.config.center_key] then
				return {
					repetitions = 1
				}
			end
		end
		if context.payasaka_pseudorandom_result and context.trigger_obj then
			---@type Card
			local c = context.trigger_obj
			if type(c) == 'table' and c:is(Card) and c.ability and (c.ability.set == "Joker" or c.ability.set == "Enhanced" or c.ability.set == 'Default') then
				PTASaka.RetriggerableCenters[c.config.center_key] = true
			end
		end
	end,
}
