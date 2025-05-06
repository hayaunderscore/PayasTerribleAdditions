SMODS.ConsumableType {
	key = 'Risk',
	collection_rows = { 4, 4 },
	primary_colour = HEX('c42430'),
	secondary_colour = HEX('891e2b'),
	shop_rate = 0,
	loc_txt = {},
}

SMODS.UndiscoveredSprite {
	key = 'Risk',
	atlas = 'JOE_Risk',
	path = 'risk.png',
	pos = { x = 3, y = 1 },
	px = 71, py = 95,
}

PTASaka.Risk = SMODS.Consumable:extend {
	set = 'Risk',
	config = { extra = { } },
	use = function(self, card, area, copier)
		G.GAME.risk_cards_risks[#G.GAME.risk_cards_risks + 1] = { key = self.key, ability = PTASaka.deep_copy(card.ability.extra) }
	end,
	can_use = function(self, card)
		return G.STATE == G.STATES.BLIND_SELECT
	end,
	apply_risk = function(self, ability)
	end,
	apply_reward = function(self, ability)
	end,
}

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.risk_cards_risks = {}
	ret.risk_cards_rewards = {}
	return ret
end

PTASaka.Risk {
	key = 'doubledown',
	atlas = "JOE_Risk",
	pos = { x = 0, y = 0 },
	config = { extra = { money = 2, } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end,
	apply_risk = function(self, ability)
		G.GAME.blind.chips = G.GAME.blind.chips * 2
		G.GAME.blind.dollars = G.GAME.blind.dollars * ability.money
	end,
	apply_reward = function(self, ability)
	end,
}

SMODS.Consumable {
	set = 'Risk',
	key = 'showdown',
	atlas = "JOE_Risk",
	pos = { x = 1, y = 0 },
	config = { extra = { } },
	use = function(self, card, area, copier)
		local showdown = {}
		for k, v in pairs(G.P_BLINDS) do
			if v.boss and v.boss.showdown then showdown[k] = true end
		end
		G.E_MANAGER:add_event(Event {
			func = function()
				local par = G.blind_select_opts.boss.parent
				_, G.GAME.round_resets.blind_choices.Boss = pseudorandom_element(showdown, pseudoseed('aikoyori'))

				G.blind_select_opts.boss:remove()
				G.blind_select_opts.boss = UIBox {
					T = { par.T.x, 0, 0, 0, },
					definition =
					{ n = G.UIT.ROOT, config = { align = "cm", colour = G.C.CLEAR }, nodes = {
						UIBox_dyn_container({ create_UIBox_blind_choice('Boss') }, false, get_blind_main_colour('Boss'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))
					} },
					config = { align = "bmi",
						offset = { x = 0, y = G.ROOM.T.y + 9 },
						major = par,
						xy_bond = 'Weak'
					}
				}
				par.config.object = G.blind_select_opts.boss
				par.config.object:recalculate()
				G.blind_select_opts.boss.parent = par
				G.blind_select_opts.boss.alignment.offset.y = 0
				save_run()
				return true
			end
		})
		G.GAME.payasaka_cannot_reroll = true
		PTASaka.Risk.use(self, card, area, copier)
	end,
	can_use = function(self, card)
		return (G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATE.SMODS_BOOSTER_OPENED) and
		not (G.P_BLINDS[G.GAME.round_resets.blind_choices.Boss].boss and G.P_BLINDS[G.GAME.round_resets.blind_choices.Boss].boss.showdown)
	end,
	apply_risk = function(self, ability)
	end,
	apply_reward = function(self, ability)
		SMODS.add_card {
			key = 'c_soul',
			edition = 'e_negative'
		}
		print('hi')
		G.GAME.payasaka_cannot_reroll = nil
	end
}

SMODS.Consumable {
	set = 'Risk',
	key = 'cast',
	atlas = "JOE_Risk",
	pos = { x = 2, y = 0 },
}

SMODS.Consumable {
	set = 'Risk',
	key = 'crime',
	atlas = "JOE_Risk",
	pos = { x = 3, y = 0 },
}

SMODS.Consumable {
	set = 'Risk',
	key = 'hinder',
	atlas = "JOE_Risk",
	pos = { x = 0, y = 1 },
}

SMODS.Consumable {
	set = 'Risk',
	key = 'elysium',
	atlas = "JOE_Risk",
	pos = { x = 1, y = 1 },
}

SMODS.Consumable {
	set = 'Risk',
	key = 'deface',
	atlas = "JOE_Risk",
	pos = { x = 2, y = 1 },
}
