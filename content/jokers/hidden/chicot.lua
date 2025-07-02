SMODS.Joker:take_ownership('chicot', {
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint and context.blind.boss then
			if G.GAME.risk_cards_risks and next(G.GAME.risk_cards_risks) then
				-- Nuh uh
				G.E_MANAGER:add_event(Event{
					trigger = 'after',
					delay = 0.2,
					func = function()
						card:flip()
						return true
					end
				})
				G.E_MANAGER:add_event(Event{
					trigger = 'after',
					delay = 0.2,
					func = function()
						card:set_ability("j_payasaka_chicot")
						play_sound('tarot2')
						card:flip()
						return true
					end
				})
				return {
					message = "Transformed!"
				}
			else
				G.E_MANAGER:add_event(Event({
					func = function()
						G.E_MANAGER:add_event(Event({
							func = function()
								G.GAME.blind:disable()
								play_sound('timpani')
								delay(0.4)
								return true
							end
						}))
						SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
						return true
					end
				}))
			end
			return nil, true -- This is for Joker retrigger purposes
		end
	end
}, true)

-- Chicot?
SMODS.Joker {
	name = "ThunderstruckChicot",
	key = "chicot",
	rarity = "payasaka_thunderstruck",
	atlas = "JOE_Jokers2",
	pos = { x = 0, y = 5 },
	cost = 25,
	blueprint_compat = false,
	demicoloncompat = false,
	no_doe = true,
	no_collection = true,
	discovered = true,
	unlocked = true,
	-- These guys are unobtainable without Chicot!
	in_pool = function(self, args)
		return false
	end,
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
	calculate = function(self, card, context)
		if context.repetition and G.GAME.risk_cards_risks and next(G.GAME.risk_cards_risks) then
			return {
				repetitions = G.GAME.risk_cards_risks and #G.GAME.risk_cards_risks or 0
			}
		end
		-- go back to being chicot
		if context.round_eval then
			-- Nuh uh
			G.E_MANAGER:add_event(Event{
				trigger = 'after',
				delay = 0.2,
				func = function()
					card:flip()
					return true
				end
			})
			G.E_MANAGER:add_event(Event{
				trigger = 'after',
				delay = 0.2,
				func = function()
					card:set_ability("j_chicot")
					play_sound('tarot2')
					card:flip()
					return true
				end
			})
			return {
				message = "Reverted!"
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { G.GAME.risk_cards_risks and #G.GAME.risk_cards_risks or 0 }
		}
	end
}
