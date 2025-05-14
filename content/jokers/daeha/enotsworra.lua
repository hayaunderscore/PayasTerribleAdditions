local bit = require "bit"

local enotsworrA_signs = {
	["mult"] = {sign = "X", bgcolor = G.C.CHIPS, color = G.C.WHITE},
	["plus"] = {sign = "+", bgcolor = G.C.WHITE, color = G.C.CHIPS},
	["minus"] = {sign = "-", bgcolor = G.C.WHITE, color = G.C.CHIPS},
	["equals"] = {sign = "=", bgcolor = G.C.DARK_EDITION, color = G.C.WHITE},
	["exponent"] = {sign = "^", bgcolor = G.C.DARK_EDITION, color = G.C.WHITE},
	["divide"] = {sign = "D", bgcolor = G.C.MULT, color = G.C.WHITE},
	["lsh"] = {sign = "<<", bgcolor = G.C.DARK_EDITION, color = G.C.WHITE}
}

local enotsworrA_validsigns = {
	"mult", "plus", "minus", "equals", "exponent", "divide", "lsh"
}

to_number = to_number or function(a) return a end

table.insert(SMODS.calculation_keys, 1,"pf_chips")
table.insert(SMODS.calculation_keys, 1,"pfchips")
table.insert(SMODS.calculation_keys, 1,"pf_mult")
table.insert(SMODS.calculation_keys, 1,"pfmult")
table.insert(SMODS.calculation_keys, 1,"pf_chips_mult")

local calculate_individual_effect_hook = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    if key == "pf_chips" or key == "pfchips" then
        hand_chips = amount(hand_chips)
        update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
		print("PLEASE")
        return true
    elseif key == "pf_mult" or key == "pfmult" then
        mult = amount(mult)
        update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
        return true
    elseif key == "pf_chips_mult" then
        hand_chips, mult = amount(hand_chips, mult)
        update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
        return true
    end
    return calculate_individual_effect_hook(effect, scored_card, key, amount, from_edition)
end

-- enotsworrA
SMODS.Joker {
	name = "enotsworrA",
	key = 'enotsworra',
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers",
	pos = { x = 0, y = 7 },
	cost = 25,
	config = { extra = { chips = 50 }, current_sign = "plus", odds = 4 },
	demicoloncompat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, enotsworrA_signs[card.ability.current_sign].sign, colours = { enotsworrA_signs[card.ability.current_sign].bgcolor, enotsworrA_signs[card.ability.current_sign].color } } }
	end,
	calculate = function(self, card, context)
		if (context.end_of_round and pseudorandom('enotsworra_fuck') < (G.GAME.probabilities.normal or 1)/card.ability.odds and not context.repetition and not context.individual and not context.retrigger_joker_check) or context.forcetrigger then
			local new_sign = nil
			while (new_sign == nil) or new_sign == card.ability.current_sign do
				new_sign = pseudorandom_element(enotsworrA_validsigns, pseudoseed('enotsworra_fuck_shit'))
			end
			card.ability.current_sign = new_sign
			return {
				message = localize('k_payasaka_enotsworra_change')
			}
		end
		if context.individual and (context.cardarea == G.play or context.cardarea == G.hand) and not context.end_of_round then
			local sign = card.ability.current_sign
			local val = card.ability.extra.chips
			return {
				message = localize { type = 'variable', key = 'a_whatchips', vars = { enotsworrA_signs[card.ability.current_sign].sign..tostring(val) } },
				colour = G.C.CHIPS,
				sound = 'xchips',
				pf_chips = function(hand_chips)
					if sign == "plus" then
						hand_chips = hand_chips + val
					elseif sign == "minus" then
						hand_chips = hand_chips - val
					elseif sign == "mult" then
						hand_chips = hand_chips * val
					elseif sign == "divide" then
						hand_chips = hand_chips / val
					elseif sign == "equals" then
						hand_chips = val
					elseif sign == "exponent" then
						hand_chips = hand_chips ^ val
					elseif sign == "lsh" then
						hand_chips = bit.lshift(to_number(hand_chips), val)
					end
					return hand_chips
				end
			}
		end
	end,
	draw = function(self, card, layer)
		card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
	end,
}