-- Check if card cannot be destroyed (by Eternal or other woes...)
---@param card Card
local function cannot_destroy(card, irisu)
	if card.ability.eternal then return true end
	if card.ability.cry_absolute then return true end
	if card.ability.entr_aleph then return true end
	if card.ability.akyrs_sigma then return true end
	if SMODS.is_eternal(card, irisu) then return true end
	return false
end

local function can_open_irisu_deck(card, skip)
	if not skip and ((G.play and #G.play.cards > 0) or
			(G.CONTROLLER.locked) or
			(G.GAME.STOP_USE and G.GAME.STOP_USE > 0))
	then
		return false
	end
	if G["payasaka_irisu_" .. tostring(card.sort_id)] and #G["payasaka_irisu_" .. tostring(card.sort_id)].cards > 0 then
		return true
	end
	return false
end

function G.FUNCS.payasaka_can_open_irisu_deck(e)
	if can_open_irisu_deck(e.config.ref_table) then
		e.config.colour = G.C.RED
		e.config.button = 'payasaka_open_irisu_deck'
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

-- Very expensive! Figure out a better way of doing this...
local function find_kinda_similar_card_in_area(area, card)
	for _, c in pairs(area.cards) do
		if c.soul_linked == card then
			return c
		end
	end
	return nil
end

function G.FUNCS.payasaka_exit_irisu_deck(e)
	if G.current_irisu_deck then
		table.sort(G.current_irisu_area_ref.cards, function (a, b)
			local ref_a = find_kinda_similar_card_in_area(G.current_irisu_deck, a)
			local ref_b = find_kinda_similar_card_in_area(G.current_irisu_deck, b)
			return (ref_a and ref_a.T.x + ref_a.T.w/2 or math.huge) < (ref_b and ref_b.T.x + ref_b.T.w/2 or math.huge)
		end)
		-- Remove possible links before removal!
		for _, v in pairs(G.current_irisu_deck.cards) do
			v.soul_linked = nil
		end
		G.current_irisu_deck:remove()
		G.current_irisu_deck = nil
		G.current_irisu_area_ref = nil
	end
	return G.FUNCS.exit_overlay_menu()
end

function G.FUNCS.payasaka_open_irisu_deck(e)
	local irisu_area = G["payasaka_irisu_" .. tostring(e.config.ref_table.sort_id)]
	G.current_irisu_deck = CardArea(
		G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
		G.ROOM.T.h,
		G.CARD_W * 5 * 1.1,
		G.CARD_H * 1.1,
		{ card_limit = 5, type = "title", highlight_limit = 1 }
	)
	if irisu_area then
		for _, v in pairs(irisu_area.cards) do
			---@type Card
			local copy = copy_card(v)
			-- Handled somewhere in Card.remove...
			copy.soul_linked = v
			G.current_irisu_deck:emplace(copy)
		end
	end
	G.current_irisu_deck.states.collide.can = false
	G.current_irisu_deck.states.focus.can = false
	G.current_irisu_deck.states.click.can = false
	G.current_irisu_area_ref = G["payasaka_irisu_" .. tostring(e.config.ref_table.sort_id)]
	G.FUNCS.overlay_menu {
		definition = create_UIBox_generic_options(
			{
				back_func = 'payasaka_exit_irisu_deck',
				contents = {
					{
						n = G.UIT.R,
						config = { align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05 },
						nodes = {
							{
								n = G.UIT.C,
								config = { align = "cm", padding = 0, no_fill = true },
								nodes = {
									{
										n = G.UIT.O, config = { object = G.current_irisu_deck }
									}
								}
							}
						}
					},
				}
			}
		),
		pause = false
	}
end

SMODS.Joker {
	name = "pta-irisu",
	key = 'irisu',
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers2",
	pos = { x = 5, y = 2 },
	soul_pos = { x = 7, y = 2 },
	cost = 25,
	no_doe = true, -- :]
	demicoloncompat = false,
	blueprint_compat = true,
	unlocked = true,
	discovered = true,
	config = { extra = { stored_joker_slots = 0 } },
	pta_custom_use = function(card)
		return {
			n = G.UIT.C,
			config = { align = "cr" },
			nodes = {
				{
					n = G.UIT.C,
					config = { ref_table = card, align = "cr", maxw = 1.4, padding = 0.1, r = 0.08, minw = 1.4, minh = 0.1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, button = 'use_card', func = 'payasaka_can_open_irisu_deck' },
					nodes = {
						{ n = G.UIT.B, config = { h = 0.1 } },
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.C,
									config = { align = "cl" },
									nodes = {
										{
											n = G.UIT.R,
											config = { align = "cm" },
											nodes = {
												{ n = G.UIT.T, config = { text = "LOOK", colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true } },
											}
										},
										{
											n = G.UIT.R,
											config = { align = "cl" },
											nodes = {
												{ n = G.UIT.T, config = { text = "INSIDE", colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true } },
											}
										},
									}
								}
							}
						}
					}
				}
			}
		}
	end,
	--[[
	update = function(self, card, dt)
		---@type CardArea
		local irisu_area = G["payasaka_irisu_" .. tostring(card.sort_id)]
		if not irisu_area then return end
		for _, c in pairs(irisu_area.cards) do
			---@type Card
			local c = c
			if c.can_calculate and c:can_calculate(false, false) then
				c:update(dt)
			end
		end
	end,
	]]
	calculate = function(self, card, context)
		---@type CardArea
		local irisu_area = G["payasaka_irisu_" .. tostring(card.sort_id)]
		local rets = {}
		if context.setting_blind and not context.retrigger_joker then
			if not G["payasaka_irisu_" .. tostring(card.sort_id)] then
				irisu_area = PTASaka.create_storage_area("payasaka_irisu_" .. tostring(card.sort_id), 1e300, card.sort_id)
				-- Save this sort_id to the save
				G.GAME.payasaka_irisu_ids[card.sort_id] = true
			end
			-- Destroy a random joker and add it to our list...
			local eligible = {}
			for k, v in pairs(card.area.cards) do
				if v == card then goto continue end
				if v.config.center_key == card.config.center_key then goto continue end -- Cannot murder other Irisus..
				eligible[#eligible + 1] = v
				::continue::
			end
			if next(eligible) then
				---@type Card
				local removed = pseudorandom_element(eligible, pseudoseed('irisu'))
				---@type Card
				local copy = copy_card(removed)
				SMODS.debuff_card(copy, "reset")
				copy:set_debuff(false)
				copy:add_to_deck()
				irisu_area:emplace(copy)
				if not cannot_destroy(removed, card) then
					removed.getting_sliced = true
					G.GAME.joker_buffer = G.GAME.joker_buffer - 1
					G.E_MANAGER:add_event(Event({
						func = function()
							G.GAME.joker_buffer = 0
							card:juice_up(0.8, 0.8)
							removed:start_dissolve({ HEX("57ecab") }, nil, 1.6)
							play_sound('slice1', 0.96 + math.random() * 0.08)
							return true
						end
					}))
					SMODS.calculate_effect({
						message = "Gone!",
						card = removed,
						colour = G.C.SECONDARY_SET.Risk,
						no_juice = true,
					}, card)
					-- Negative? Fuck you add an additional joker slot
					-- This was originally intended before SMODS fixed it
					if removed.edition and removed.edition.negative then
						local value = { value = 1 }
						SMODS.scale_card(card, {
							ref_table = G.jokers.config,
							ref_value = "card_limit",
							scalar_table = value,
							scalar_value = "value",
							message_key = 'a_irisu_joker_slot',
						})
						SMODS.scale_card(card, {
							ref_table = card.ability.extra,
							ref_value = "stored_joker_slots",
							scalar_table = value,
							scalar_value = "value",
							no_message = true
						})
					end
				else
					G.E_MANAGER:add_event(Event({
						func = function()
							card:juice_up(0.8, 0.8)
							return true
						end
					}))
					rets[#rets+1] = {
						message = localize('k_duplicated_ex'),
						card = removed,
					}
				end
			end
		end
		if irisu_area and irisu_area.cards then
			for _, c in pairs(irisu_area.cards) do
				---@type Card
				local c = c
				if c.can_calculate and c:can_calculate(false, false) then
					local ret, _ = c:calculate_joker(context)
					if ret and type(ret) == "table" then
						--if not ret.card then
						--ret.card = card
						--end
						rets[#rets + 1] = ret
						--print("hey i have a ret")
					end
				end
			end
		end
		if next(rets) then return PTASaka.recursive_extra(rets, 1) end
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.stored_joker_slots
	end,
	add_to_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.stored_joker_slots
	end
}
