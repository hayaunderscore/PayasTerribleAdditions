local light_gradient = SMODS.Gradient {
	key = "suit_light",
	colours = { G.C.SO_1.Hearts, G.C.SO_1.Diamonds },
	cycle = 5,
	interpolation = 'linear'
}

local dark_gradient = SMODS.Gradient {
	key = "suit_dark",
	colours = { G.C.SO_1.Spades, G.C.SO_1.Clubs },
	cycle = 5,
	interpolation = 'linear'
}

local colorblind_change = G.FUNCS.refresh_contrast_mode
function G.FUNCS.refresh_contrast_mode()
	local ret = colorblind_change()
	local so = G.C["SO_"..(G.SETTINGS.colourblind_option and 2 or 1)]
	light_gradient.colours = { so.Hearts, so.Diamonds }
	dark_gradient.colours = { so.Spades, so.Clubs }
	return ret
end

local start_up_ref = Game.start_up
function Game:start_up()
	start_up_ref(self)
	local so = G.C["SO_"..(G.SETTINGS.colourblind_option and 2 or 1)]
	light_gradient.colours = { so.Hearts, so.Diamonds }
	dark_gradient.colours = { so.Spades, so.Clubs }
end

SMODS.Joker {
	name = "Flint and Steel 2",
	key = 'flintnsteel2',
	config = { extra = { mult = 3, cmult = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.cmult } }
	end,
	atlas = "JOE_Jokers",
	pos = { x = 5, y = 2 },
	cost = 3,
	blueprint_compat = true,
	demicoloncompat = true,
	calculate = function(self, card, context)
		if not context.blueprint_card then
			if context.before then
				local gain = 0
				if next(context.poker_hands['Pair']) then
					for _, hand in pairs(context.poker_hands['Pair']) do
						-- LIGHT AND DARK.
						local light = 0
						local dark = 0
						for _, c in pairs(hand) do
							if c:is_suit('Spades') or c:is_suit('Clubs') then dark = 1 end
							if c:is_suit('Hearts') or c:is_suit('Diamonds') then light = 1 end
						end
						if light == dark then gain = gain + card.ability.extra.mult end
					end
				end
				card.ability.extra.cmult = card.ability.extra.cmult + gain
				if gain > 0 then
					return {
						message = localize { type = 'variable', key = 'a_mult', vars = { gain } },
						sound = "payasaka_flint"
					}
				end
			end
		end
		if context.joker_main or context.forcetrigger then
			return {
				mult = card.ability.extra.cmult
			}
		end
	end
}