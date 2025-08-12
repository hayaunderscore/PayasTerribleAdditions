-- Global calculate

PTASaka.Mod.calculate = function(self, context)
	if context.after then
		-- Return cardarea state & Wild Two revert
		PTASaka.dos_cardarea.disabled = G.GAME.payasaka_dos_should_return
		G.E_MANAGER:add_event(Event({
			func = function()
				for k, card in ipairs(G.play.cards) do
					if card.payasaka_wild_two then
						card:flip()
					end
				end
				return true
			end
		}))
		G.GAME.payasaka_dos_should_return = nil
	end
	if context.setting_blind then
		-- Light Blue increases blind size
		-- As for why this isn't in a (consumable) calculate function.... Bunco tends to mess with that.
		-- I want this to work out of the box
		for _, card in pairs(G.consumeables.cards) do
			if card.ability.set == "Colour" and card.ability.name == "col_Light_Blue" then
				G.E_MANAGER:add_event(Event{
					func = function()
						G.GAME.blind.chips = G.GAME.blind.chips * card.ability.blind_size_multiplier
						G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
						G.GAME.blind:wiggle()
						return true
					end
				})
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Hardened!" })
			end
		end
		-- Risk Card initialization
		if G.GAME.risk_cards_risks and G.GAME.blind_on_deck == 'Boss' then
			for k, v in ipairs(G.GAME.risk_cards_risks) do
				-- TODO: Deprecated at this point...
				G.P_CENTERS[v.key].apply_risk(G.P_CENTERS[v.key], v.ability)
				G.GAME.payasaka_risk_objects[#G.GAME.payasaka_risk_objects+1] = PTASaka.RiskObject(v.key)
			end
		end
		for k, v in pairs(G.GAME.payasaka_risk_objects) do
			v:calculate({setting_blind = true, blind = G.GAME.round_resets.blind})
		end
	end
	if context.end_of_round and context.main_eval then
		-- Perfectheart saving
		if (G.GAME.payasaka_scored_naneinfs or 0) >= 9 then
			G.GAME.payasaka_scored_naneinfs = 0
			G.GAME.payasaka_defeated_perfectheart = true
			return {
				saved = true
			}
		end
		-- Risk Card deinitialization
		if G.GAME.risk_cards_risks and G.GAME.blind_on_deck == 'Boss' then
			for k_, v in ipairs(G.GAME.risk_cards_risks) do
				G.P_CENTERS[v.key].apply_reward(G.P_CENTERS[v.key], v.ability)
				if G.P_CENTERS[v.key].tier > 0 then
					add_tag(Tag('tag_payasaka_tier'..G.P_CENTERS[v.key].tier..'reward'))
				end
			end
			G.GAME.risk_cards_risks = {}
		end
		if G.GAME.payasaka_risk_objects and G.GAME.blind_on_deck == 'Boss' then
			local persist = {}
			for k_, v in pairs(G.GAME.payasaka_risk_objects) do
				if v and not v.ability.persist then
					v:remove()
				elseif v and v.ability.persist then
					persist[#persist+1] = v
					G.GAME.risk_cards_risks[#G.GAME.risk_cards_risks+1] = {
						key = v.center.key,
						ability = PTASaka.deep_copy(v.ability.extra)
					}
				end
			end
			G.GAME.payasaka_risk_objects = persist
		end
	end
end