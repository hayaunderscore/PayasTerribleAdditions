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
		if context.setting_blind or context.forcetrigger then
			local random_roll = pseudorandom('sinister', 1, 5)
			if random_roll == 1 then
				-- create a random negative joker
				local eligible = {}
				for k, v in pairs(G.P_CENTER_POOLS.Joker) do
					if v.unlocked and v.discovered
						and (not v.in_pool or v:in_pool({}))
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
			elseif random_roll == 2 then
				-- level up a random poker hand
				local eligible = {}
				for k, v in pairs(G.handlist) do
					if G.GAME.hands[v].visible then eligible[#eligible + 1] = v end
				end
				SMODS.smart_level_up_hand(card, pseudorandom_element(eligible, 'sinister'), nil, 1)
				return {
					message = "Sinister!"
				}
			elseif random_roll == 3 then
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
			elseif random_roll == 4 then
				-- normal upgrade
				card.ability.extra.xmult = card.ability.extra.xmult + 1
				return {
					message = "Sinister!"
				}
			elseif random_roll == 5 then
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
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end,
}
