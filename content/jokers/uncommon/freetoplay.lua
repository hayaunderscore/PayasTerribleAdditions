SMODS.Joker {
	name = "Free to Play Model",
	key = "freetoplay",
	rarity = 2,
	atlas = "JOE_Jokers",
	pos = { x = 7, y = 8 },
	cost = 6,
	blueprint_compat = true,
	demicoloncompat = true,
	config = { extra = { x_mult = 1, x_gain = 0.25, odds = 2 } },
	calculate = function(self, card, context)
		if context.payasaka_taking_gacha and not context.blueprint_card then
			card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_gain
			return {
				message = localize('k_upgrade_ex')
			}
		end
		if context.joker_main or context.forcetrigger then
			return {
				x_mult = card.ability.extra.x_mult
			}
		end
		if context.end_of_round and context.main_eval and ((pseudorandom('f2p_model') < (G.GAME.probabilities.normal or 1)/card.ability.extra.odds)) then
			local _card = SMODS.add_card({ key = "c_payasaka_gacha" })
			card:juice_up()
			_card:juice_up()
		end
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.j_payasaka_dud
		info_queue[#info_queue+1] = G.P_CENTERS.c_payasaka_gacha
		return { vars = { card.ability.extra.x_gain, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.x_mult } }
	end
}

SMODS.Joker {
	name = "Dud",
	key = "dud",
	rarity = "payasaka_dud",
	atlas = "JOE_Jokers",
	pos = { x = 8, y = 8 },
	cost = 1,
	blueprint_compat = true,
	demicoloncompat = true,
	config = { extra = { mult = 10, joker_slot = 0.5 } },
	no_doe = true,
	calculate = function(self, card, context)
		if context.joker_main or context.forcetrigger then
			return {
				mult = card.ability.extra.mult
			}
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		if from_debuff then return end
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slot
	end,
	remove_from_deck = function(self, card, from_debuff)
		if from_debuff then return end
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.joker_slot
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.joker_slot } }
	end,
	in_pool = function(self, args)
		return false
	end
}