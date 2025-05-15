-- Dango
SMODS.Joker {
	name = "pta-dango",
	key = "dango",
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 4, y = 9 },
	config = { extra = { x_mult = 1.5 } },
	cost = 8,
	blueprint_compat = true,
	demicoloncompat = true,
	pools = {
		["Joker"] = true,
		["Food"] = true,
	},
	update = function(self, card, dt)
		if G.STAGE ~= G.STAGES.RUN then return end
		local food = false
		for _, joker in ipairs(G.jokers.cards) do
			---@type SMODS.Joker
			local center = joker.config.center
			if PTASaka.food_jokers[center.key] and joker ~= card then
				food = true
				break
			end
		end
		card.children.center:set_sprite_pos({ x = 4 + ((not food) and 1 or 0), y = 9 })
	end,
	calculate = function(self, card, context)
		if context.other_joker or context.forcetrigger then
			if context.other_joker then
				---@type SMODS.Joker
				local center = context.other_joker.config.center
				if PTASaka.food_jokers[center.key] and context.other_joker ~= card then
					return {
						x_mult = card.ability.extra.x_mult
					}
				end
				return nil, true
			end
			-- demitrigger? do not care
			return {
				x_mult = card.ability.extra.x_mult
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.x_mult }
		}
	end
}

-- I should really conglomerate these hooks into one
local old_start_run = Game.start_run
function Game:start_run(args)
	old_start_run(self, args)
	PTASaka.food_jokers = {}
	-- Index based list -> Key-Value based list
	for k, v in ipairs(G.P_CENTER_POOLS["Food"]) do
		PTASaka.food_jokers[v.key] = v
	end
end
