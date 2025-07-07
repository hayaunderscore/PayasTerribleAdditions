---@class PseudoCard: table
---@field suit string
---@field value string
---@field ability_base string
---@field ability_table? table
---@field seal? table
---@field edition? table

local function can_save_phil(card, skip)
	if not skip and ((G.play and #G.play.cards > 0) or
			(G.CONTROLLER.locked) or
			(G.GAME.STOP_USE and G.GAME.STOP_USE > 0))
	then
		return false
	end
	if G.hand and G.hand.highlighted and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_selection then
		return true
	end
	return false
end

local function can_unleash_phil(card, skip)
	if not skip and ((G.play and #G.play.cards > 0) or
			(G.CONTROLLER.locked) or
			(G.GAME.STOP_USE and G.GAME.STOP_USE > 0))
	then
		return false
	end
	if card.ability.saved_cards and #card.ability.saved_cards > 0 then
		return true
	end
	return false
end

function G.FUNCS.payasaka_can_use_phil(e)
	if (next(e.config.ref_table.ability.saved_cards) and can_unleash_phil(e.config.ref_table) or can_save_phil(e.config.ref_table)) then
		e.config.colour = G.C.RED
		e.config.button = 'payasaka_use_phil'
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

function G.FUNCS.payasaka_use_phil(e)
	stop_use()
	---@type Card
	local card = e.config.ref_table
	card:highlight(false)
	if next(card.ability.saved_cards) then
		for i = 1, #card.ability.saved_cards do
			---@type PseudoCard
			local fake = card.ability.saved_cards[i]
			G.E_MANAGER:add_event(Event{
				trigger = 'after',
				delay = 0.15,
				func = function()
					local c = SMODS.add_card({ set = "Base", area = G.hand, suit = fake.suit, rank = fake.value })
					if G.P_CENTERS[fake.ability_base] then
						c:set_ability(G.P_CENTERS[fake.ability_base], true)
					end
					c:set_edition(fake.edition or nil)
					c:set_seal(fake.seal or nil)
					for k, v in pairs(fake.ability_table or {}) do
						c.ability[k] = v
					end
					c:hard_set_T(card.VT.x, card.VT.y)
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Unleashed!", sound = 'timpani', instant = true })
					return true
				end
			})
			card.sell_cost = card.sell_cost - 2
		end
		card.ability.saved_cards = {}
	else
		for i = 1, #G.hand.highlighted do
			---@type Card
			local c = G.hand.highlighted[i]
			G.E_MANAGER:add_event(Event{
				trigger = 'after',
				delay = 0.15,
				func = function()
					c:start_dissolve()
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Saved!", sound = 'timpani', instant = true })
					return true
				end
			})
			card.ability.saved_cards[#card.ability.saved_cards+1] = {
				suit = c.base.suit, value = c.base.value,
				ability_base = c.config.center_key, ability_table = c.ability,
				seal = c.seal, edition = c.edition
			}
			card.sell_cost = card.sell_cost + 2
		end
	end
end

-- Phil and Shirt (2)
SMODS.Joker {
	name = "pta-Phil",
	key = "phil2",
	rarity = 3,
	atlas = "JOE_Jokers",
	pos = { x = 8, y = 4 },
	cost = 8,
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
	pools = { ["Joker"] = true, ["Friend"] = true },
	config = { saved_cards = {}, extra = { max_selection = 5 } },
	loc_vars = function(self, info_queue, card)
		---@type PseudoCard[]
		local saved = card.ability.saved_cards
		local arr = {}
		for _, v in pairs(saved) do
			arr[#arr+1] = (SMODS.Ranks[v.value] or {card_key = '?'}).card_key..(SMODS.Suits[v.suit] or {card_key = '?'}).card_key
		end
		return { vars = { card.ability.extra.max_selection, next(arr) and table.concat(arr, ", ") or "Inactive!" } }
	end,
	pta_custom_use = function(card)
		return {
			n = G.UIT.C,
			config = { align = "cr" },
			nodes = {
				{
					n = G.UIT.C,
					config = { ref_table = card, align = "cr", maxw = next(card.ability.saved_cards) and 2 or 1.4, padding = 0.2, r = 0.08, minw = next(card.ability.saved_cards) and 2 or 1.4, minh = 0.15, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, button = 'use_card', func = 'payasaka_can_use_phil' },
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
										next(card.ability.saved_cards) and {
											n = G.UIT.R,
											config = { align = "cl" },
											nodes = {
												{ n = G.UIT.T, config = { text = "UNLEASH", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true } },
											}
										} or nil,
										not next(card.ability.saved_cards) and {
											n = G.UIT.R,
											config = { align = "cl" },
											nodes = {
												{ n = G.UIT.T, config = { text = "SAVE", colour = G.C.UI.TEXT_LIGHT, scale = 0.5, shadow = true } },
											}
										} or nil,
									}
								}
							}
						}
					}
				}
			}
		}
	end,
}
