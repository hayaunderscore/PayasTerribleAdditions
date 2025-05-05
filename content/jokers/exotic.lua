SMODS.Joker {
	name = "Doodle Kosmos",
	key = 'doodlekosmos',
	rarity = "cry_exotic",
	atlas = "JOE_Exotic",
	pos = { x = 0, y = 0 },
	soul_pos = { x = 2, y = 0, draw = function(card, scale_mod, rotate_mod)
		local shader = card.ability.immutable.level > 2 and 'negative' or 'dissolve'
		local send = card.ability.immutable.level > 2 and card.ARGS.send_to_shader or nil
		card.children.floating_sprite:draw_shader(shader,0, send, nil, card.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
		card.children.floating_sprite:draw_shader(shader, nil, send, nil, card.children.center, scale_mod, rotate_mod)
	end, extra = { x = 1, y = 0 } },
	cost = 50,
	-- If Photocopier, Oil Lamp and Gemini could control the level that would be *too* broken
	config = { extra = { ee_mult = 1, ee_mult_add = .06, odds = 16 }, immutable = { level = 2 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = { key = "payasaka_doodlekosmos_evolution", set = "Other" }
		local prefix = ((card.ability.immutable.level > 5 and ('{' .. card.ability.immutable.level .. '}') or string.rep('^', card.ability.immutable.level))).."%s"
		return { vars = { prefix:format(number_format(card.ability.extra.ee_mult)), prefix:format(number_format(card.ability.extra.ee_mult_add)), card.ability.cry_rigged and card.ability.extra.odds or (G.GAME.probabilities.normal or 1), card.ability.extra.odds },
		key = "j_payasaka_doodlekosmos"..(card.ability.immutable.level > 2 and "_alt" or "") }
	end,
	blueprint_compat = true,
	demicoloncompat = true,
	update = function(self, card, dt)
		-- For those updating from the old one...
		if card.ability.extra.evolved ~= nil then
			card.ability.immutable = {}
			card.ability.immutable.level = card.ability.extra.evolved and 3 or 2
			card.ability.extra.evolved = nil
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local m = ((card.ability.immutable.level > 5 and ('{' .. card.ability.immutable.level .. '}') or string.rep('^', card.ability.immutable.level)) .. card.ability.extra.ee_mult).." Mult"
			return {
				hypermult = {card.ability.immutable.level, card.ability.extra.ee_mult},
				hypermult_message = {
					message = m, colour = G.C.DARK_EDITION, sound = card.ability.immutable.level == 2 and "talisman_eemult" or "talisman_eeemult"
				},
				colour = G.C.DARK_EDITION,
			}
		end
		if (context.individual and context.cardarea == G.hand and not context.end_of_round) or context.force_trigger then
			card.ability.extra.ee_mult = card.ability.extra.ee_mult + card.ability.extra.ee_mult_add
			if context.other_card then
				context.other_card:juice_up()
			end
			return {
				message = localize("k_upgrade_ex"),
				colour = G.C.DARK_EDITION,
				card = card
			}
		end
		if context.end_of_round and context.cardarea == G.jokers then
			local rng = pseudorandom("payasaka_doodlekosmos")
			if rng < (G.GAME.probabilities.normal or 1) / card.ability.extra.odds or card.ability.cry_rigged then
				G.E_MANAGER:add_event(Event{
					trigger = 'before',
					delay = 0.8125,
					func = function()
						card.ability.immutable.level = card.ability.immutable.level+1
						-- The odds increase every time making it harder to evolve (unless rigged of course)
						card.ability.extra.odds = card.ability.extra.odds * 2
						card.ability.cry_rigged = false
						card:juice_up()
						play_sound('talisman_eeemult')
						card_eval_status_text(card, 'extra', nil, nil, nil, {
							message = "Evolved!",
							colour = G.C.DARK_EDITION,
							instant = true,
							delay = 0.8125,
						})
						return true
					end
				})
			end
		end
	end
}

SMODS.Joker {
	name = 'Imerlogio',
	key = 'imerlogio',
	rarity = "cry_exotic",
	atlas = "JOE_Exotic",
	pos = { x = 0, y = 1 },
	soul_pos = { x = 2, y = 1, extra = { x = 1, y = 1 } },
	cost = 50,
	config = { extra = { x_mult = 1, add = 2, starting_x_mult = 1 } },
	demicoloncompat = true,
	loc_vars = function(self, info_queue, card)
		local count = PTASaka.discovered_modded_jokers or 0
		if count == 0 then
			for k, v in pairs(G.P_CENTERS) do
				if v.set and v.set == "Joker" and v.mod and v.discovered then
					count = count + 1
				end
			end
		end
		return { vars = { card.ability.extra.starting_x_mult, card.ability.extra.add, card.ability.extra.x_mult * count } }
	end,
	update = function(self, card, dt)
		card.ability.extra.x_mult = card.ability.extra.starting_x_mult + (card.ability.extra.add*(G.jokers and math.max(0, #G.jokers.cards-1) or 0))
	end,
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			local count = PTASaka.discovered_modded_jokers or 0
			if count == 0 then
				for k, v in ipairs(G.P_CENTERS) do
					if v.set and v.set == "Joker" and v.mod and v.discovered then
						count = count + 1
					end
				end
			end
			return {
				x_mult = card.ability.extra.x_mult * count
			}
		end
	end
}

local sr = Game.start_run
function Game:start_run(args)
	sr(self, args)
	PTASaka.discovered_modded_jokers = 0
	for k, v in pairs(G.P_CENTERS) do
		if v.set and v.set == "Joker" and v.mod and v.discovered then
			PTASaka.discovered_modded_jokers = PTASaka.discovered_modded_jokers + 1
		end
	end
	--print(PTASaka.discovered_modded_jokers)
end

local dc = discover_card
function discover_card(card)
	card = card or {}
	local old_discovered = card.discovered
	dc(card)
	if old_discovered then return end
	PTASaka.discovered_modded_jokers = 0
	for k, v in pairs(G.P_CENTERS) do
		if v.set and v.set == "Joker" and v.mod and v.discovered then
			PTASaka.discovered_modded_jokers = PTASaka.discovered_modded_jokers + 1
		end
	end
end

SMODS.Joker {
	name = 'Regina',
	key = 'regina',
	rarity = "cry_exotic",
	atlas = "JOE_Exotic",
	pos = { x = 0, y = 2 },
	soul_pos = { x = 2, y = 2, extra = { x = 1, y = 2 } },
	cost = 50,
	config = { extra = { x_mult = 1, add = 0.1 } },
	demicoloncompat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.add, card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context)
		if context.payasaka_before then
			for i = 1, #context.scoring_hand do
				local _c = context.scoring_hand[i]
				if _c.base.id == 12 then goto continue end
				_c.base.id = 12
				_c.base.nominal = 12
				_c.base.value = 'Queen'
				card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.add
				G.E_MANAGER:add_event(Event{
					trigger = 'after',
					delay = 0.8125,
					func = function()
						local suit_prefix = string.sub(_c.base.suit, 1, 1)..'_'
						_c:set_base(G.P_CARDS[suit_prefix..'Q'])
						_c:juice_up()
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize("k_upgrade_ex"), instant = true })
						return true
					end
				})
				::continue::
			end
			local text,disp_text,poker_hands = G.FUNCS.get_poker_hand_info(context.scoring_hand)
			delay(0.8125)
			update_hand_text({delay = 0, modded = true}, {handname=disp_text, level=G.GAME.hands[text].level, mult = G.GAME.hands[text].mult, chips = G.GAME.hands[text].chips})
			mult = mod_mult(G.GAME.hands[text].mult)
			hand_chips = mod_chips(G.GAME.hands[text].chips)
			delay(0.4)
		end
		if context.joker_main or context.forcetrigger then
			return {
				e_mult = card.ability.extra.x_mult,
				colour = G.C.DARK_EDITION
			}
		end
	end
}