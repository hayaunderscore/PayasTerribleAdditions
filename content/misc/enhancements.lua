SMODS.Enhancement {
	name = "Damp",
	key = 'damp',
	atlas = "JOE_Enhancements",
	pos = { x = 0, y = 0 },
	config = { x_chips = 1.5, x_mult = 1.5, odds = 8 },
	always_scores = true,
	calculate = function(self, card, context)
		if context.final_scoring_step and context.cardarea == G.play then
			if SMODS.pseudorandom_probability(card, "payasaka_damp_card", 1, card.ability.odds) and not next(SMODS.find_card('j_payasaka_rainy')) then
				G.E_MANAGER:add_event(Event {
					delay = 0.2,
					func = function()
						card:set_ability(G.P_CENTERS.m_payasaka_wet)
						card:juice_up()
						card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Wet!", colour = G.C.BLUE })
						return true
					end
				})
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_payasaka_wet
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.odds)
		return {
			vars = { card.ability.x_chips, card.ability.x_mult, num, den }
		}
	end
}

SMODS.Enhancement {
	name = "Wet",
	key = 'wet',
	atlas = "JOE_Enhancements",
	pos = { x = 1, y = 0 },
	replace_base_card = true,
	no_rank = true,
	any_suit = true,
	config = { bonus = 100 },
	always_scores = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.bonus } }
	end
}

SMODS.Enhancement {
	name = "pta-Volatile",
	key = 'volatile',
	atlas = "JOE_Enhancements",
	pos = { x = 2, y = 0 },
	config = { extra = { xmult = 2 } },
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
		if not context.end_of_round then
			if context.main_scoring and context.cardarea == "unscored" then
				return {
					x_mult = card.ability.extra.xmult
				}
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end
}

SMODS.Enhancement {
	name = "pta-Laser",
	key = 'laser',
	atlas = "JOE_Enhancements",
	pos = { x = 3, y = 0 },
	config = { laser_balance = 0.05 },
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
		if not context.end_of_round then
			if context.main_scoring and context.cardarea == G.play then
				return {
					pta_balance = card.ability.laser_balance,
				}
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.laser_balance * 100 } }
	end
}

SMODS.Enhancement {
	name = "pta-True",
	key = 'true',
	atlas = "JOE_Enhancements",
	pos = { x = 4, y = 0 },
	config = { true_reduce = 0.01 },
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
		if not context.end_of_round then
			if context.main_scoring and context.cardarea == G.play then
				return {
					message = "Reduced!",
					extrafunc = function()
						G.GAME.blind.chips = G.GAME.blind.chips - G.GAME.blind.chips * card.ability.true_reduce
						G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
						G.HUD_blind:get_UIE_by_ID("HUD_blind_count"):juice_up()
					end
				}
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.true_reduce * 100 } }
	end
}

SMODS.Enhancement {
	name = "pta-Score",
	key = 'score',
	atlas = "JOE_Enhancements",
	pos = { x = 6, y = 0 },
	config = { card_chips = 2 },
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
	always_scores = true,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.main_scoring then
			for _, c in pairs(context.scoring_hand) do
				SMODS.calculate_effect({ chip_mod = card.ability.card_chips }, c)
				card_eval_status_text(c, 'extra', nil, (percent or 1) + 0.1, nil, { message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.card_chips}}, colour = G.C.BLUE, delay = 0.2, sound = 'chips1' })
			end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.card_chips } }
	end
}

SMODS.Enhancement {
	name = "pta-Ice",
	key = 'ice',
	atlas = "JOE_Enhancements",
	pos = { x = 8, y = 0 },
	pta_credit = {
		idea = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
		art = {
			credit = 'Mr. Logan',
			colour = HEX('c1410e')
		},
	},
	calculate = function(self, card, context)
		if context.before and card.area == G.play then
			PTASaka.freeze_card(card, true, true, nil, true)
		end
		if context.end_of_round then
			PTASaka.freeze_card(card, false, nil, true)
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = { key = 'status_payasaka_frozen', set = "Status", vars = {} }
	end
}

local card_update_ref = Card.update
function Card:update(dt)
	local ret = card_update_ref(self, dt)
	if self.ability.pta_frozen and self.area == G.hand and self.area.highlighted then
		local fin = false
		for k, v in pairs(self.area.highlighted) do
			if v == self then
				fin = true
				break
			end
		end
		if not fin then
			self.highlighted = true
			self.area:add_to_highlighted(self, true)
			self.ability.forced_selection = true
		end
	end
	return ret
end

-- Edited version of the hologram shader for Mimic
SMODS.Shader {
	key = 'hologram',
	path = 'hologram.fs'
}

-- SHUT
local should_hide_front = Card.should_hide_front
function Card:should_hide_front()
	if self.config.center_key == "m_payasaka_mimic" then return false end
	if should_hide_front then return should_hide_front(self) end
end

SMODS.Enhancement {
	name = "pta-Mimic",
	key = 'mimic',
	atlas = "JOE_Enhancements",
	pos = { x = 5, y = 0 },
	config = { mimic_card = true, mimic_effect = 2 },
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
	no_suit = true,
	no_rank = true,
	replace_base_card = true,
	update = function(self, card, dt)
		if G.STAGE == G.STAGES.RUN then
			if card.area == G.hand and G.STATE ~= G.STATES.HAND_PLAYED then
				-- get left card
				local found = false
				for i = 1, #card.area.cards do
					---@type Card
					local c = card.area.cards[i]
					---@type Card
					local l = card.area.cards[i-1]
					if c == card and not l then
						card.ability.card_copied = -1
					end
					if c == card and l then
						if card.ability.last_card_copied ~= card.ability.card_copied then
							local _atlas, _pos = get_front_spriteinfo((l.ability.conf_card or l.config.card))
							if not card.children.front then
								card.children.front = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, _atlas, _pos)
								card.children.front.states.hover = card.states.hover
								card.children.front.states.click = card.states.click
								card.children.front.states.drag = card.states.drag
								card.children.front.states.collide.can = false
								card.children.front:set_role({major = card, role_type = 'Glued', draw_major = card})
							end
							if card.children.front then
								---@type Sprite
								local front = card.children.front
								front.atlas = _atlas
								front:set_sprite_pos(_pos)
							end
							card.ability.mimic_effect = 1
							card.ability.last_card_copied = l.ability.last_card_copied or l.sort_id
						end
						if l and l.ability.pta_none then
							if card.children.front then
								card.children.front:remove()
								card.children.front = nil
							end
						end
						card.ability.lastbase = (l.ability.lastbase or l.base)
						card.ability.conf_card = (l.ability.conf_card or l.config.card)
						card.ability.card_copied = l.ability.card_copied or l.sort_id
						card.ability.pta_none = nil
						found = true
						break
					end
					if c == card and not l then
						card.ability.pta_none = true
						if card.children.front then
							card.children.front:remove()
							card.children.front = nil
						end
					end
				end
			end
			function lerp(a, b, t)
				return a + (b - a) * t
			end
			if card.ability.mimic_effect and (card.area == G.hand or card.area == G.play) then
				card.ability.mimic_effect = lerp(card.ability.mimic_effect, 0, G.real_dt*5)
			end
		end
	end,
	calculate = function(self, card, context)
		if context.before and card.area ~= G.deck and card.area ~= G.discard then
			-- Get left card and copy its ability
			local left = nil
			for i = 1, #card.area.cards do
				if card.area.cards[i] == card then
					left = card.area.cards[i-1]
				end
			end
			if left and left.config.center_key ~= "m_payasaka_mimic" then
				card:set_ability(left.config.center_key, false, true)
				assert(SMODS.change_base(card, left.base.suit, left.base.value))
				card.ability.mimic_card = true
				return {
					message = "Copied!"
				}
			end
		end
	end
}

local emplace_ref = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped, ...)
	if self ~= G.play then
		if card and card.ability.mimic_card and card.config.center_key ~= "m_payasaka_mimic" then
			card:set_ability("m_payasaka_mimic", false, true)
		end
	end
	return emplace_ref(self, card, location, stay_flipped, ...)
end
