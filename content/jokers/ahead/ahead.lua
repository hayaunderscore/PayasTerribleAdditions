SMODS.Joker {
	name = "canichat",
	key = "canichat",
	rarity = "payasaka_ahead",
	atlas = "JOE_Jokers",
	pos = { x = 4, y = 7 },
	cost = 10,
	blueprint_compat = true,
	demicoloncompat = true,
	eternal_compat = false,
	perishable_compat = false,
	pools = {["Joker"] = true, ["Meme"] = true},
    config = {
        extra = {
            chips = 50,
        }
    },
	pta_credit = {
		idea = {
			credit = "canichatandobserve",
			colour = HEX('7d78b0')
		},
		code = {
			credit = "canichatandobserve",
			colour = HEX('7d78b0')
		}
	},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips}}
    end,
    calculate = function(self, card, context)
        if (context.individual or context.other_joker or context.other_consumeable or context.forcetrigger) and not context.end_of_round then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
}