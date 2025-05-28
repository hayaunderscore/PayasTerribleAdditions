-- Finity cross mod
if next(SMODS.find_mod('finity')) then
	FinisherBossBlindStringMap = FinisherBossBlindStringMap or {}
	FinisherBossBlindStringMap["bl_payasaka_question"] = {"j_payasaka_cast", "The Cast"}
	FinisherBossBlindStringMap["bl_payasaka_question_hard"] = {"j_payasaka_missingno", "MISSINGNO."}
	FinisherBossBlindQuips = FinisherBossBlindQuips or {}
	FinisherBossBlindQuips["bl_payasaka_question"] = {"question", 4}
	FinisherBossBlindQuips["bl_payasaka_question_hard"] = {"m", 4}
end

-- Fuses two boss blinds together. Jesus.
SMODS.Blind {
	key = "question",
	atlas = "JOE_Blinds",
	pos = {x = 0, y = 1},
	dollars = 8,
	mult = 2,
	boss = {
		min = 0, max = 1999, showdown = true,
		merged_keys = {},
	},
	boss_colour = HEX('46585c'),
	collection_loc_vars = function(self)
		return {key = "bl_payasaka_question_alt"}
	end,
	loc_vars = function(self)
		if G.GAME.payasaka_merged_boss_keys and next(G.GAME.payasaka_merged_boss_keys) then
			local localized = {}
			for i = 1, #G.GAME.payasaka_merged_boss_keys do
				localized[#localized+1] = localize { type = 'name_text', key = G.GAME.payasaka_merged_boss_keys[i], set = 'Blind' }
			end
			local conc = table.concat(localized, ", ", 1, #localized-1)
			conc = conc.." and "..localized[#localized]
			return {vars = {conc}}
		else
			return {key = "bl_payasaka_question_alt"}
		end
	end,
	show_fusions = true,
	set_blind = function(self)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		if not next(G.GAME.payasaka_merged_boss_keys) then
			for i = 1,2 do
				-- Fix Finity creating an infinite loop by using The Cast as the bosses for... The Cast.
				local old_name = G.GAME.selected_back.name
				G.GAME.selected_back.name = "b_red"
				-- Generally do not use showdown bosses as valid combinations for the cast
				local showdown = false
				if (G.GAME.round_resets.ante)%G.GAME.win_ante == 0 and G.GAME.round_resets.ante >= 2 then
					G.GAME.round_resets.ante = G.GAME.round_resets.ante - 1
					showdown = true
				end
				G.GAME.banned_keys['bl_payasaka_question'] = true
				local new_boss = get_new_boss()
				G.GAME.banned_keys['bl_payasaka_question'] = nil
				if showdown then
					G.GAME.round_resets.ante = G.GAME.round_resets.ante + 1
				end
				G.GAME.payasaka_merged_boss_keys[i] = new_boss
				-- Differentiate between Cast created by a Cast risk card and Cast as a showdown
				G.GAME.payasaka_natural_cast = true
				G.GAME.selected_back.name = old_name
			end
			G.GAME.blind:set_text()
		end
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			SMODS.merge_lists(self.boss, (G.P_BLINDS[v].boss and type(G.P_BLINDS[v].boss) == "table") and G.P_BLINDS[v].boss or {})
			-- todo support multiple debuffs
			G.GAME.blind.debuff = G.P_BLINDS[v].debuff or {}
			SMODS.merge_lists(G.GAME.blind.debuff, (G.P_BLINDS[v].debuff and type(G.P_BLINDS[v].debuff) == "table") and G.P_BLINDS[v].debuff or {})
			-- blindexpander stuffs
			if G.P_BLINDS[v].passives then
				-- passives support
				G.GAME.blind.passives = G.GAME.blind.passives or {}
				SMODS.merge_lists(G.GAME.blind.passives, (G.P_BLINDS[v].passives and type(G.P_BLINDS[v].passives) == "table") and G.P_BLINDS[v].passives or {})
				if self.passives then
					self.children.alert = UIBox{
						definition = create_UIBox_card_alert(), 
						config = {
							align = "tri",
							offset = {
								x = 0.1, y = 0
							},
							parent = self
						}
					}
				else
					self.children.alert = nil
				end
			end
			-- summons
			if (G.P_BLINDS[v].summon) then
				G.GAME.blind.summon = G.GAME.blind.summon or {}
				SMODS.merge_lists(G.GAME.blind.summon, (G.P_BLINDS[v].summon and type(G.P_BLINDS[v].summon) == "table") and G.P_BLINDS[v].summon or {})
			end
			if G.P_BLINDS[v].set_blind then
				--print("set blind")
				G.P_BLINDS[v].set_blind(G.P_BLINDS[v])
			end
			-- vanilla blinds
			if G.P_BLINDS[v].name == 'The Eye' then
				G.GAME.blind.hands = {
					["Flush Five"] = false,
					["Flush House"] = false,
					["Five of a Kind"] = false,
					["Straight Flush"] = false,
					["Four of a Kind"] = false,
					["Full House"] = false,
					["Flush"] = false,
					["Straight"] = false,
					["Three of a Kind"] = false,
					["Two Pair"] = false,
					["Pair"] = false,
					["High Card"] = false,
				}
			end
			if G.P_BLINDS[v].name == 'The Mouth' then
				G.GAME.blind.only_hand = false
			end
			if G.P_BLINDS[v].name == 'The Fish' then 
				G.GAME.blind.prepped = nil
			end
			if G.P_BLINDS[v].name == 'The Water' then 
				G.GAME.blind.discards_sub = G.GAME.current_round.discards_left
				ease_discard(-G.GAME.blind.discards_sub)
			end
			if G.P_BLINDS[v].name == 'The Needle' then 
				G.GAME.blind.hands_sub = G.GAME.round_resets.hands - 1
				ease_hands_played(-G.GAME.blind.hands_sub)
			end
			if G.P_BLINDS[v].name == 'The Manacle' then
				G.hand:change_size(-1)
			end
			if G.P_BLINDS[v].name == 'Amber Acorn' and #G.jokers.cards > 0 then
				G.jokers:unhighlight_all()
				for k, v in ipairs(G.jokers.cards) do
					v:flip()
				end
				if #G.jokers.cards > 1 then 
					G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
						G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
						delay(0.15)
						G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
						delay(0.15)
						G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1);return true end })) 
						delay(0.5)
					return true end })) 
				end
			end
		
			--add new debuffs
			for _, _v in ipairs(G.playing_cards) do
				G.GAME.blind:debuff_card(_v)
			end
			for _, _v in ipairs(G.jokers.cards) do
				G.GAME.blind:debuff_card(_v, true)
			end
		end
	end,
	disable = function(self)
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].disable then
				--print("disabled")
				G.P_BLINDS[v].disable(G.P_BLINDS[v])
			end
			for k, v in ipairs(G.jokers.cards) do
				if v.facing == 'back' then v:flip() end
			end
			if G.P_BLINDS[v].name == 'The Water' then 
				ease_discard(G.GAME.blind.discards_sub)
			end
			if G.P_BLINDS[v].name == 'The Wheel' or G.P_BLINDS[v].name == 'The House' or G.P_BLINDS[v].name == 'The Mark' or G.P_BLINDS[v].name == 'The Fish' then 
				for i = 1, #G.hand.cards do
					if G.hand.cards[i].facing == 'back' then
						G.hand.cards[i]:flip()
					end
				end
				for k, v in pairs(G.playing_cards) do
					v.ability.wheel_flipped = nil
				end
			end
			if G.P_BLINDS[v].name == 'The Needle' then 
				ease_hands_played(G.GAME.blind.hands_sub)
			end
			if G.P_BLINDS[v].name == 'The Wall' then 
				G.GAME.blind.chips = G.GAME.blind.chips/2
				G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
			end
			if G.P_BLINDS[v].name == 'Cerulean Bell' then 
				for k, v in ipairs(G.playing_cards) do
					v.ability.forced_selection = nil
				end
			end
			if G.P_BLINDS[v].name == 'The Manacle' then 
				G.hand:change_size(1)
				
				G.FUNCS.draw_from_deck_to_hand(1)
			end
			if G.P_BLINDS[v].name == 'The Serpent' then
			end
			if G.P_BLINDS[v].name == 'Violet Vessel' then 
				G.GAME.blind.chips = G.GAME.blind.chips/3
				G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
			end
		end
	end,
	defeat = function(self)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].defeat then
				--print("defeated")
				G.P_BLINDS[v].defeat(G.P_BLINDS[v])
			end
			-- vanilla
			if G.P_BLINDS[v].name == 'The Manacle' and not G.GAME.blind.disabled then
				G.hand:change_size(1)
			end
		end
		G.GAME.payasaka_merged_boss_keys = nil
	end,
	drawn_to_hand = function(self)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].drawn_to_hand then
				--print("drawn")
				G.P_BLINDS[v].drawn_to_hand(G.P_BLINDS[v])
			end
			-- vanilllerekreire
			if not G.GAME.blind.disabled then
				if G.P_BLINDS[v].name == 'Cerulean Bell' then
					local any_forced = nil
					for k, v in ipairs(G.hand.cards) do
						if v.ability.forced_selection then
							any_forced = true
						end
					end
					if not any_forced then 
						G.hand:unhighlight_all()
						local forced_card = pseudorandom_element(G.hand.cards, pseudoseed('cerulean_bell'))
						forced_card.ability.forced_selection = true
						G.hand:add_to_highlighted(forced_card)
					end
				end
				if G.P_BLINDS[v].name == 'Crimson Heart' and G.GAME.blind.prepped and G.jokers.cards[1] then
					local jokers = {}
					for i = 1, #G.jokers.cards do
						if not G.jokers.cards[i].debuff or #G.jokers.cards < 2 then jokers[#jokers+1] =G.jokers.cards[i] end
						G.jokers.cards[i]:set_debuff(false)
					end 
					local _card = pseudorandom_element(jokers, pseudoseed('crimson_heart'))
					if _card then
						_card:set_debuff(true)
						_card:juice_up()
						G.GAME.blind:wiggle()
					end
				end
			end
			G.GAME.blind.prepped = nil
		end
	end,
	press_play = function(self)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].press_play then
				--print("play time")
				G.P_BLINDS[v].press_play(G.P_BLINDS[v])
			end
			-- vanillaaaaaaaaa
			if G.P_BLINDS[v].name == "The Hook" then
				G.E_MANAGER:add_event(Event({ func = function()
					local any_selected = nil
					local _cards = {}
					for k, v in ipairs(G.hand.cards) do
						_cards[#_cards+1] = v
					end
					for i = 1, 2 do
						if G.hand.cards[i] then 
							local selected_card, card_key = pseudorandom_element(_cards, pseudoseed('hook'))
							G.hand:add_to_highlighted(selected_card, true)
							table.remove(_cards, card_key)
							any_selected = true
							play_sound('card1', 1)
						end
					end
					if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
				return true end })) 
				G.GAME.blind.triggered = true
				delay(0.7)
			end
			if G.P_BLINDS[v].name == 'Crimson Heart' then 
				if G.jokers.cards[1] then
					G.GAME.blind.triggered = true
					G.GAME.blind.prepped = true
				end
			end
			if G.P_BLINDS[v].name == 'The Fish' then
				G.GAME.blind.prepped = true
			end
			if G.P_BLINDS[v].name == "The Tooth" then
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
				for i = 1, #G.play.cards do
					G.E_MANAGER:add_event(Event({func = function() G.play.cards[i]:juice_up(); return true end })) 
					ease_dollars(-1)
					delay(0.23)
				end
				return true end })) 
				G.GAME.blind.triggered = true
			end
		end
	end,
	recalc_debuff = function(self, card, from_blind)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		local ret = false
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].recalc_debuff then
				--print("recalculating debuffs")
				ret = G.P_BLINDS[v].recalc_debuff(G.P_BLINDS[v], card, from_blind) == true
			end
		end
		return ret
	end,
	debuff_hand = function(self, cards, hand, handname, check)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		local ret = false
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].debuff_hand then
				--print("debuffed le hand")
				ret = G.P_BLINDS[v].debuff_hand(G.P_BLINDS[v], cards, hand, handname, check) == true
			end
			if G.P_BLINDS[v].debuff then
				G.GAME.blind.triggered = false
				if G.GAME.blind.debuff.hand and next(hand[G.GAME.blind.debuff.hand]) then
					G.GAME.blind.triggered = true
					goto skip_everything
				end
				if G.GAME.blind.debuff.h_size_ge and #cards < G.GAME.blind.debuff.h_size_ge then
					G.GAME.blind.triggered = true
					goto skip_everything
				end
				if G.GAME.blind.debuff.h_size_le and #cards > G.GAME.blind.debuff.h_size_le then
					G.GAME.blind.triggered = true
					goto skip_everything
				end
				if G.P_BLINDS[v].name == "The Eye" then
					if G.GAME.blind.hands[handname] then
						G.GAME.blind.triggered = true
						goto skip_everything
					end
					if not check then G.GAME.blind.hands[handname] = true end
				end
				if G.P_BLINDS[v].name == "The Mouth" then
					if G.GAME.blind.only_hand and G.GAME.blind.only_hand ~= handname then
						G.GAME.blind.triggered = true
						goto skip_everything
					end
					if not check then G.GAME.blind.only_hand = handname end
				end
			end
			if G.P_BLINDS[v].name == 'The Arm' then 
				G.GAME.blind.triggered = false
				if to_big(G.GAME.hands[handname].level) > to_big(1) then
					G.GAME.blind.triggered = true
					if not check then
						level_up_hand(G.GAME.blind.children.animatedSprite, handname, nil, -1)
						G.GAME.blind:wiggle()
					end
				end 
			end
			if G.P_BLINDS[v].name == 'The Ox' then 
				G.GAME.blind.triggered = false
				if handname == G.GAME.current_round.most_played_poker_hand then
					G.GAME.blind.triggered = true
					if not check then
						ease_dollars(-G.GAME.dollars, true)
						G.GAME.blind:wiggle()
					end
				end 
			end
			::skip_everything::
		end
		return ret
	end,
	stay_flipped = function(self, area, card)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		local ret = false
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].stay_flipped then
				--print("never open i think")
				ret = G.P_BLINDS[v].stay_flipped(G.P_BLINDS[v], area, card) == true
			end
			-- vaniller
			if not G.GAME.blind.disabled then
				if G.P_BLINDS[v].name == 'Cerulean Bell' then
					local any_forced = nil
					for k, v in ipairs(G.hand.cards) do
						if v.ability.forced_selection then
							any_forced = true
						end
					end
					if not any_forced then 
						G.hand:unhighlight_all()
						local forced_card = pseudorandom_element(G.hand.cards, pseudoseed('cerulean_bell'))
						if forced_card then
							forced_card.ability.forced_selection = true
							G.hand:add_to_highlighted(forced_card)
						end
					end
				end
				if G.P_BLINDS[v].name == 'Crimson Heart' and G.GAME.blind.prepped and G.jokers.cards[1] then
					local jokers = {}
					for i = 1, #G.jokers.cards do
						if not G.jokers.cards[i].debuff or #G.jokers.cards < 2 then jokers[#jokers+1] =G.jokers.cards[i] end
						G.jokers.cards[i]:set_debuff(false)
					end 
					local _card = pseudorandom_element(jokers, pseudoseed('crimson_heart'))
					if _card then
						_card:set_debuff(true)
						_card:juice_up()
						G.GAME.blind:wiggle()
					end
				end
			end
		end
		return ret
	end,
	modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		local _m, _c, yeppers = mult, hand_chips, false
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].modify_hand then
				--print("modified !!!")
				_m, _c, yeppers = G.P_BLINDS[v].modify_hand(G.P_BLINDS[v], cards, poker_hands, text, _m, _c)
			end
			if G.P_BLINDS[v].name == "The Flint" then
				G.GAME.blind.triggered = true
				_m, _c, yeppers = math.max(math.floor(_m*0.5 + 0.5), 1), math.max(math.floor(_c*0.5 + 0.5), 0), true
			end
		end
		return _m, _c, yeppers
	end,
	get_loc_debuff_text = function(self)
		return "???"
	end,
	cry_ante_base_mod = function(self, dt)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		if G.SETTINGS.paused then
			return 0
		else
			local ret = 0
			for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
				if G.P_BLINDS[v].cry_ante_base_mod then
					--print("yapping")
					ret = ret + G.P_BLINDS[v].cry_ante_base_mod(G.P_BLINDS[v], dt)
				end
			end
			return ret
		end
	end,
	cry_after_play = function(self)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].cry_after_play then
				--print("modified !!!")
				G.P_BLINDS[v].cry_after_play(G.P_BLINDS[v])
			end
		end
	end,
	cry_before_play = function(self)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].cry_before_play then
				--print("modified !!!")
				G.P_BLINDS[v].cry_before_play(G.P_BLINDS[v])
			end
		end
	end,
	cry_calc_ante_gain = function(self)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		local ret = 1
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].cry_calc_ante_gain then
				--print("modified !!!")
				ret = ret * G.P_BLINDS[v].cry_calc_ante_gain(G.P_BLINDS[v])
			end
		end
		return ret
	end,
	cry_cap_score = function(self, score)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		local ret = math.floor(PTASaka.arrow(G.GAME.payasaka_exponential_count,hand_chips or 1e300,mult or 1e300))
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].cry_cap_score then
				--print("modified !!!")
				ret = G.P_BLINDS[v].cry_cap_score(G.P_BLINDS[v], score)
			end
		end
		return ret
	end,
	cry_round_base_mod = function(self, dt)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		local ret = 1
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].cry_round_base_mod then
				--print("modified !!!")
				ret = ret * G.P_BLINDS[v].cry_round_base_mod(G.P_BLINDS[v], dt)
			end
		end
		return ret
	end,
	calculate = function(self, blind, context)
		if not G.GAME.payasaka_merged_boss_keys then G.GAME.payasaka_merged_boss_keys = {} end
		local rets = {}
		for k, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
			if G.P_BLINDS[v].calculate then
				--print("modified !!!")
				local calc = G.P_BLINDS[v].calculate(G.P_BLINDS[v], G.GAME.blind, context) or {}
				rets[#rets+1] = calc
			end
		end
		return PTASaka.recursive_extra(rets, 1)
	end
}

-- Info to show the boss blinds fused
-- Taken from blindexpander and mangled
-- Left here as well for now...

local set_blindref = Blind.set_blind
function Blind.set_blind(self, blind, reset, silent)
    if not reset then
        self.show_fusions = blind and blind.show_fusions or false
        if self.show_fusions then
            self.children.alert = UIBox{
                definition = create_UIBox_card_alert(), 
                config = {
                    align = "tri",
                    offset = {
                        x = 0.1, y = 0
                    },
                    parent = self
                }
            }
        else
            self.children.alert = nil
        end
    end
    set_blindref(self, blind, reset, silent)
end

function info_from_fused(fused)
    local width = 6
    for _, v in ipairs(SMODS.Mods) do
        if v.fused_ui_size and type(v.fused_ui_size) == "function" then
            width = math.max(width, v.fused_ui_size())
        end
    end
    local desc_nodes = {}
	local name_nodes = localize{type = 'name', key = fused, set = "Blind", name_nodes = {}, vars = {}}
	local spr = AnimatedSprite(0,0, 0.5, 0.5, G.ANIMATION_ATLAS[G.P_BLINDS[fused].atlas] or G.ANIMATION_ATLAS['blind_chips'],  G.P_BLINDS[fused].pos)
	spr:define_draw_steps({   {shader = 'dissolve', shadow_height = 0.05},  {shader = 'dissolve'}  })
	spr.float = true
	spr.config = {blind = G.P_BLINDS[fused], force_focus = true}
	table.insert(name_nodes, 1, {
		n = G.UIT.O,
		config={align = "cl", object = spr},
	})
	local loc_vars = G.P_BLINDS[fused].vars
	if G.P_BLINDS[fused].loc_vars then loc_vars = G.P_BLINDS[fused].loc_vars(G.P_BLINDS[fused]) end
    localize{type = 'descriptions', key = fused, set = "Blind", nodes = desc_nodes, vars = loc_vars and loc_vars.vars and loc_vars.vars or {}}
    local desc = {}
    for _, v in ipairs(desc_nodes) do
        desc[#desc+1] = {n=G.UIT.R, config={align = "cl"}, nodes=v}
    end
    return
    {n=G.UIT.R, config={align = "cl", colour = lighten(G.P_BLINDS[fused].boss_colour or G.C.GREY, 0.4), r = 0.1, padding = 0.05}, nodes={
        {n=G.UIT.R, config={align = "cl", padding = 0.05, r = 0.1}, nodes = name_nodes},
        {n=G.UIT.R, config={align = "cl", minw = width, minh = 0.4, r = 0.1, padding = 0.05, colour = desc_nodes.background_colour or G.C.WHITE}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=desc}}}
    }}
end

function create_UIBox_blind_fused(blind)
    local fused_lines = {}
    for _, v in ipairs(G.GAME.payasaka_merged_boss_keys) do
        fused_lines[#fused_lines+1] = info_from_fused(v)
    end
    return
    {n=G.UIT.ROOT, config = {align = 'cm', colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, emboss = 0.05, padding = 0.05}, nodes={
        {n=G.UIT.R, config={align = "cm", emboss = 0.05, r = 0.1, minw = 2.5, padding = 0.05, colour = G.C.GREY}, nodes={
            {n=G.UIT.C, config = {align = "lm", padding = 0.1}, nodes = fused_lines}
        }}
    }}
end

local blind_hoverref = Blind.hover
function Blind.hover(self)
    if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
        if not self.hovering and self.states.visible and self.children.animatedSprite.states.visible then
            if G.GAME.payasaka_merged_boss_keys and next(G.GAME.payasaka_merged_boss_keys) and self.config.blind and self.config.blind.show_fusions then
                G.blind_fused = UIBox{
                    definition = create_UIBox_blind_fused(self),
                    config = {
                        major = self,
                        parent = nil,
                        offset = {
                            x = 0.15,
                            y = 0.2 + 0.38*#G.GAME.payasaka_merged_boss_keys,
                        },  
                        type = "cr",
                    }
                }
                G.blind_fused.attention_text = true
                G.blind_fused.states.collide.can = false
                G.blind_fused.states.drag.can = false
                if self.children.alert then
                    self.children.alert:remove()
                    self.children.alert = nil
                end
            end
        end
    end
    blind_hoverref(self)
end

local blind_stop_hoverref = Blind.stop_hover
function Blind.stop_hover(self)
    if G.blind_fused then
        G.blind_fused:remove()
        G.blind_fused = nil
    end
    blind_stop_hoverref(self)
end
