-- Manhattan Cafe
SMODS.Joker {
	name = "pta-Manhattan Cafe",
	key = "manhattan",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 0, y = 7 },
	cost = 6,
	blueprint_compat = false,
	demicoloncompat = false,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	pools = { ["Joker"] = true, ["Friend"] = true },
	calculate = function(self, card, context)
		if (context.payasaka_card_removed or context.payasaka_prevent_destroy_card) and not context.blueprint_card then
			if context.card and PTASaka.is_food(context.card) then
				-- Turn this into a random Food Joker
				local eligible_food = {}
				for k, v in pairs(G.P_CENTER_POOLS["Food"]) do
					---@type SMODS.Joker
					local center = v
					local in_pool, pool_opts
					if center.in_pool and type(v.in_pool) == 'function' then
						in_pool, pool_opts = v:in_pool({ source = "manhattan" })
					end
					if center.unlocked
						and not center.no_doe
						and (in_pool or not center.in_pool)
						and center.key ~= card.config.center.key
						and not G.GAME.banned_keys[center.key] then
						eligible_food[#eligible_food + 1] = center.key
					end
				end
				local c = context.card
				context.card:set_ability(pseudorandom_element(eligible_food, 'cafe'), true, true)
				c.children.center.pinch.x = false
				c.states.drag.is = false
				G.E_MANAGER:add_event(Event{
					func = function()
						c:juice_up(0.7)
						card:juice_up(0.7)
						return true
					end
				})
				c.REMOVED = false
				--print("prevent this mf")
				SMODS.calculate_effect({ message = "Changed!" }, context.card or card)
				return {
					prevent_remove = true,
					remove = false,
				}
			end
		end
	end
}
