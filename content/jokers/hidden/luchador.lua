SMODS.Joker:take_ownership('luchador', {
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
						card:set_ability("j_payasaka_luchador")
						play_sound('tarot2')
						card:flip()
						return true
					end
				})
				SMODS.calculate_effect({ message = "Transformed!" }, card)
				check_for_unlock({ type = 'payasaka_encounter_thunderstruck' })
			end
			return nil, true -- This is for Joker retrigger purposes
		end
		if context.selling_self then
            if G.GAME.blind and not G.GAME.blind.disabled and G.GAME.blind.boss then
                return {
                    message = localize('ph_boss_disabled'),
                    func = function() -- This is for timing purposes, it runs after the message
                        G.GAME.blind:disable()
                    end
                }
            end
        end
	end
}, true)

-- Luchador?
SMODS.Joker {
	name = "ThunderstruckLuchador",
	key = "luchador",
	rarity = "payasaka_thunderstruck",
	atlas = "JOE_Jokers2",
	pos = { x = 1, y = 5 },
	cost = 25,
	blueprint_compat = false,
	demicoloncompat = false,
	no_doe = true,
	no_collection = true,
	discovered = true,
	unlocked = true,
	-- These guys are unobtainable without Luchador!
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
		if context.selling_self and not context.blueprint_card then
			if G.GAME.risk_cards_risks and next(G.GAME.risk_cards_risks) then
				for _, v in pairs(G.GAME.payasaka_risk_objects) do
					v.ability.persist = true
				end
			end
			return {
				message = "Locked!"
			}
		end
		-- go back to being luchador
		if context.round_eval and not context.blueprint_card then
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
					card:set_ability("j_luchador")
					play_sound('tarot2')
					card:flip()
					return true
				end
			})
			SMODS.calculate_effect({ message = "Reverted!" }, card)
			return nil, true
		end
	end,
}
