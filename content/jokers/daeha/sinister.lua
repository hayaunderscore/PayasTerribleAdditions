---@class SinisterDefinition
---@field should_apply fun(card: Card, context: CalcContext)
---@field effect fun(card: Card, context:CalcContext)

---@type table<SinisterDefinition>
PTASaka.SinisterList = {
	{
		should_apply = function(card, context) return true end,
		effect = function(card, context)
			-- create a random negative joker
			local eligible = {}
			for k, v in pairs(G.P_CENTER_POOLS.Joker) do
				if v.unlocked and v.discovered
					and (not v.in_pool or type(v.in_pool) ~= "function" or v:in_pool({}))
					and v.rarity ~= "payasaka_daeha" and v.rarity ~= 1 then
					eligible[#eligible + 1] = v
				end
			end
			if next(eligible) then
				G.E_MANAGER:add_event(Event {
					func = function()
						SMODS.add_card { key = pseudorandom_element(eligible, "sinister").key, edition = 'e_negative' }
						return true
					end
				})
				return {
					message = "Sinister!"
				}
			end
		end
	},
	{
		should_apply = function(card, context) return true end,
		effect = function(card, context)
			-- level up a random poker hand
			local eligible = {}
			for k, v in pairs(G.handlist) do
				if G.GAME.hands[v].visible then eligible[#eligible + 1] = v end
			end
			SMODS.smart_level_up_hand(card, pseudorandom_element(eligible, 'sinister'), nil, 1)
			return {
				message = "Sinister!"
			}
		end
	},
	{
		should_apply = function(card, context) return true end,
		effect = function(card, context)
			-- create a red seal steel king and put it in the deck
			G.E_MANAGER:add_event(Event {
				func = function()
					card:juice_up(0.7)
					local c = SMODS.add_card { suit = "Clubs", rank = "King", set = 'Enhanced', enhancement = "m_steel", seal = "Red", area = G.play }
					G.E_MANAGER:add_event(Event {
						trigger = 'after',
						delay = 0.3,
						func = function()
							draw_card(G.play, G.deck, 1, nil, nil, c)
							G.deck:shuffle('fuckyea')
							return true
						end
					})
					return true
				end
			})
			return {
				message = "Sinister!"
			}
		end
	},
	{
		should_apply = function(card, context) return true end,
		effect = function(card, context)
			-- normal upgrade
			card.ability.extra.xmult = card.ability.extra.xmult + 1
			return {
				message = "Sinister!"
			}
		end
	},
	{
		should_apply = function(card, context) return true end,
		effect = function(card, context)
			-- random tag
			G.E_MANAGER:add_event(Event {
				func = function()
					local tag = Tag(pseudorandom_element(G.P_CENTER_POOLS.Tag, pseudoseed('dreamsprint')).key)
					if tag.name == "Orbital Tag" then
						local _poker_hands = {}
						for k, v in pairs(G.GAME.hands) do
							if v.visible then
								_poker_hands[#_poker_hands + 1] = k
							end
						end
						tag.ability.orbital_hand = pseudorandom_element(_poker_hands, "joy_orbital")
					end
					add_tag(tag)
					return true
				end
			})
			return {
				message = "Sinister!"
			}
		end
	},
	{
		should_apply = function(card, context) return true end,
		effect = function(card, context)
			local enhancement = SMODS.poll_enhancement({ key = 'harmony_proc', guaranteed = true })
			G.E_MANAGER:add_event(Event {
				func = function()
					local cards = math.min(G.hand.config.card_limit, #G.deck.cards)
					for i = 1, cards do
						draw_card(G.deck, G.hand, i * 100 / cards, 'up', true)
					end
					delay(0.4)
					G.E_MANAGER:add_event(Event {
						func = function()
							for k, v in pairs(G.hand.cards) do
								G.E_MANAGER:add_event(Event {
									trigger = 'after',
									delay = 0.15,
									func = function()
										v:juice_up(0.7)
										play_sound('timpani')
										v:set_ability(G.P_CENTERS[enhancement])
										card_eval_status_text(v, 'extra', nil, nil, nil,
											{ message = "Sinister!", instant = true })
										return true
									end
								})
							end
							return true
						end
					})
					delay(0.4)
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Sinister!" })
					return true
				end
			})
		end
	},
	{
		-- Do not roll on blueprint or retriggering
		-- Also don't roll when its triggered not on blind start
		should_apply = function(card, context) return not (context.blueprint_card or context.retrigger_joker) and context.payasaka_pre_setting_blind end,
		effect = function(card, context)
			-- win
			end_round()
			-- Make SURE it shows up as the blind defeat rather than "Saved by Mr. Bones"
			G.GAME.payasaka_defeated_perfectheart = true
			-- Prevent odd wins
			PTASaka.payasaka_temp_no_draw = true
			return {
				message = "Sinister!"
			}
		end
	},
}

SMODS.Joker {
	name = "pta-SinisterPotion",
	key = 'sinisterpotion',
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers2",
	pos = { x = 7, y = 0 },
	soul_pos = { x = 7, y = 1 },
	cost = 25,
	no_doe = true, -- :]
	demicoloncompat = true,
	blueprint_compat = true,
	config = { extra = { xmult = 1 } },
	calculate = function(self, card, context)
		if context.payasaka_pre_setting_blind or context.forcetrigger then
			local effects = {}
			for _, v in pairs(PTASaka.SinisterList) do
				if v.should_apply and v.should_apply(card, context) then
					effects[#effects+1] = v
				end
			end
			local effect = G.GAME.force_sinister and PTASaka.SinisterList[G.GAME.force_sinister] or pseudorandom_element(effects, 'sinister')
			if effect then
				return effect.effect(card, context)
			end
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end,
}
