-- Kacey
SMODS.Joker {
	name = "pta-Kacey",
	key = "kacey",
	rarity = 2,
	atlas = "JOE_Jokers2",
	pos = { x = 3, y = 7 },
	cost = 8,
	blueprint_compat = false,
	demicoloncompat = false,
	immutable = true,
	pools = { ["Joker"] = true, ["Friend"] = true },
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	calculate = function(self, card, context)
		if context.starting_shop and not context.blueprint_card then
			for _, area in pairs({ G.shop_vouchers, G.shop_booster }) do
				if not area.cards then goto area_continue end
				-- Check if boosters have a valid upgradable pack size
				for i = 1, #area.cards do
					---@type Card
					local booster = area.cards[i]
					---@type SMODS.Booster
					local center = booster.config.center
					if center.set ~= "Booster" then goto continue end
					-- Naively assume that if it ends in a number, its the pack skin to extract the full key without it
					-- If not, ok just go along anyway and determine tier as is
					-- Look if you name your boosters weird and not like that, thats on you
					-- Strip that
					local key = center.key or ""
					local current_sub = key:sub(-1)
					local ends_in_number = current_sub:match("^%d+$")
					if ends_in_number then
						-- strip until last _
						while current_sub ~= "_" and string.len(key) > 0 do
							current_sub = key:sub(-1)
							key = key:sub(0, string.len(key) - 1)
						end
					end
					local type, old_type = "ERROR_LMAO", "ERROR_LMAO"
					if key:match('normal') then
						type = 'jumbo'; old_type = 'normal'
					elseif key:match('jumbo') then
						type = 'mega'; old_type = 'jumbo'
					elseif key:match('mega') then
						type = 'ultra'; old_type = 'mega'
					end
					-- ortalab please
					if key:match('small') then
						type = 'mid'; old_type = 'small'
					elseif key:match('mid') then
						type = 'big'; old_type = 'mid'
					end
					if not center.mod and type == 'ultra' then -- Prefix MY mod key
						key = key:gsub('p_', 'p_payasaka_')
					end
					local new_key = key:gsub(old_type, type) ..
						(type == 'ultra' and "" or "_1") -- Only supports ONE skin for now
					if not G.P_CENTERS[new_key] then -- try without the pack skin suffix
						new_key = key:gsub(old_type, type)
					end
					if G.P_CENTERS[new_key] and new_key ~= center.key then
						booster:set_ability(G.P_CENTERS[new_key])
						booster:set_sprites(G.P_CENTERS[center.key])
						G.E_MANAGER:add_event(Event {
							func = function()
								booster:set_cost()
								booster:set_sprites(G.P_CENTERS[new_key])
								create_shop_card_ui(booster)
								booster:juice_up(0.7)
								return true
							end
						})
						SMODS.calculate_effect({ message = localize('k_upgrade_ex') }, card)
					end
					::continue::
				end
				::area_continue::
			end
		end
	end
}
