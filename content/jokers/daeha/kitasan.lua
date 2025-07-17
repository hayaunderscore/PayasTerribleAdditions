SMODS.Joker {
	name = "pta-KitasanBlack",
	key = 'kitasan',
	rarity = "payasaka_daeha",
	atlas = "JOE_Jokers2",
	pos = { x = 1, y = 6 },
	soul_pos = { x = 2, y = 8 },
	pta_front_pos = { x = 1, y = 8 },
	cost = 25,
	no_doe = true, -- :]
	demicoloncompat = true,
	blueprint_compat = true,
	config = { immutable = { timer_till_upgrade_attempt = 2 }, extra = { xmult_gain = 1, xmult = 1 } },
	update = function(self, card, dt)
		if card.debuff then return end
		if G.STAGE == G.STAGES.RUN
			and card.area == G.jokers
			and G.STATE ~= G.STATES.HAND_PLAYED then
			card.ability.immutable.timer_till_upgrade_attempt = card.ability.immutable.timer_till_upgrade_attempt - dt
		end
		if card.ability.immutable.timer_till_upgrade_attempt <= 0 then
			-- reset
			card.ability.immutable.timer_till_upgrade_attempt = 2
			-- roll and see if we should upgrade. atleast 1 in 6 chance
			if pseudorandom('kitasan') < 1/6 then
				card.ability.extra.xmult = card.ability.extra.xmult + (card.ability.extra.xmult_gain * (2 ^ (#SMODS.find_card('j_payasaka_kitasan') - 1)))
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex'), instant = true })
			end
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.xmult
			}
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult }
		}
	end,
	shine_front_pos = true,
}