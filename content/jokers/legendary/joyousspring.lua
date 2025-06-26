-- JoyousSpring cross mod !!!!!
local init_joy_table = JoyousSpring and JoyousSpring.init_joy_table or function(t) return t end

SMODS.Joker {
	name = "Joyous Spring",
	key = "joyousspring",
	config = {
		extra = {
			-- amount of times the words 'joyousspring' or 'joyous spring'
			-- has been uttered in the Balatro discord
			joyous_amt = 1073,
			joyous_mult = 1, -- Will change the more people utter it
			joyous_spring = init_joy_table {
				is_tuner = true,
				attribute = "FIRE",
				monster_type = "Zombie"
			},
			odds = 2,
			base_xmult = 0.2,
		}
	},
	rarity = 4,
	atlas = "JOE_Jokers",
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	cost = 25,
	blueprint_compat = true,
	demicoloncompat = true,
	dependencies = JoyousSpring and 'JoyousSpring' or nil,
	generate_ui = JoyousSpring and JoyousSpring.generate_info_ui or SMODS.Joker.generate_ui,
	pta_credit = {
		art = {
			credit = 'ariyi',
			colour = HEX('09d707')
		},
	},
	--set_sprites = JoyousSpring and JoyousSpring.set_back_sprite or SMODS.Joker.set_sprites,
	calculate = function(self, card, context)
		if not JoyousSpring then
			if context.joker_main or context.forcetrigger then
				return {
					x_mult = card.ability.extra.joyous_amt * card.ability.extra.joyous_mult
				}
			end
		elseif JoyousSpring and JoyousSpring.can_use_abilities(card) then
			if not context.blueprint_card_card and not context.retrigger_joker and context.joy_no_draw then
                card.ability.extra.joyous_mult = card.ability.extra.joyous_mult + card.ability.extra.base_xmult
                return {
                    message = localize('k_upgrade_ex')
                }
            end

            if context.joker_main or context.forcetrigger then
                return {
                    x_mult = card.ability.extra.joyous_amt * card.ability.extra.joyous_mult
                }
            end
		end
	end,
	loc_vars = function(self, info_queue, card)
		return { 
			key = JoyousSpring and "j_payasaka_joyousspring_alt" or "j_payasaka_joyousspring",
			set = "Joker",
			vars = { card.ability.extra.joyous_mult, card.ability.extra.joyous_amt * card.ability.extra.joyous_mult, G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.base_xmult } 
		}
	end
}
