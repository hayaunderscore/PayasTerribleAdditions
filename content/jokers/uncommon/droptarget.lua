SMODS.Joker {
	name = "Drop Target",
	key = "droptarget",
	atlas = "JOE_Jokers",
	pos = { x = 6, y = 6 },
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	demicoloncompat = false,
	config = { extra = { odds = 6, chips = 21, chips_add = 14 }, immutable = { sprite_state = 0, random_values = nil } },
	pta_credit = {
		idea = {
			credit = 'Mr. Logan',
			colour = HEX('c1410e')
		},
		art = {
			credit = 'Mr. Logan',
			colour = HEX('c1410e')
		},
	},
	calculate = function(self, card, context)
		if context.payasaka_play_to_discard then
			if not card.ability.immutable.random_values then
				card.ability.immutable.random_values = {}
				for i = 1, 3 do
					card.ability.immutable.random_values[i] = pseudorandom('drop_target')
				end
			end
			local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
			if card.ability.immutable.random_values[1] < num / den then
				local o = context.other_card
				G.E_MANAGER:add_event(Event{
					trigger = 'after',
					delay = 0.1,
					func = function()
						play_sound('payasaka_drop_target', 1, 0.3)
						card.ability.immutable.sprite_state = 0
						---@type Sprite
						local spr = card.children.center
						spr:set_sprite_pos({ x = self.pos.x + card.ability.immutable.sprite_state, y = self.pos.y })
						if o then o:juice_up(0.7) end
						return true
					end
				})
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_add
				table.remove(card.ability.immutable.random_values, 1)
				card.ability.immutable.random_values[#card.ability.immutable.random_values+1] = pseudorandom('drop_target')
				return {
					message = "Ping!",
					target = G.deck
				}
			end
			if card.ability.immutable.random_values[3] < num / den then
				G.E_MANAGER:add_event(Event{
					func = function()
						card.ability.immutable.sprite_state = 1
						card:juice_up(0.7)
						---@type Sprite
						local spr = card.children.center
						spr:set_sprite_pos({ x = self.pos.x + card.ability.immutable.sprite_state, y = self.pos.y })
						--print("PREDICTED")
						return true
					end
				})
			end
			if card.ability.immutable.random_values[2] < num / den then
				G.E_MANAGER:add_event(Event{
					func = function()
						card.ability.immutable.sprite_state = 2
						card:juice_up(0.7)
						---@type Sprite
						local spr = card.children.center
						spr:set_sprite_pos({ x = self.pos.x + card.ability.immutable.sprite_state, y = self.pos.y })
						--print("PREDICTED 2")
						return true
					end
				})
			end
			table.remove(card.ability.immutable.random_values, 1)
			card.ability.immutable.random_values[#card.ability.immutable.random_values+1] = pseudorandom('drop_target')
			-- Call pseudorandom_result here teehee
			SMODS.post_prob = SMODS.post_prob or {}
			SMODS.calculate_context({payasaka_pseudorandom_result = true, result = card.ability.immutable.random_values[1] or 0, trigger_obj = card, numerator = num, denominator = den, identifier = 'drop_target'})
    		SMODS.post_prob[#SMODS.post_prob+1] = {pseudorandom_result = true, result = card.ability.immutable.random_values[1] or 0, trigger_obj = card, numerator = num, denominator = den, identifier = 'drop_target'}
		end
		if context.joker_main or context.forcetrigger then
			return {
				chips = card.ability.extra.chips
			}
		end
	end,
	set_sprites = function(self, card, front)
		if not (card.children and card.children.center) then return end
		if not (self.discovered and not self.bypass_discovery_center) then return end
		---@type Sprite
		local spr = card.children.center
		spr:set_sprite_pos({ x = self.pos.x + ((card.ability or self.config).immutable or { sprite_state = 0 }).sprite_state, y = self.pos.y })
	end,
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
		return {
			vars = { card.ability.extra.chips_add, num, den, card.ability.extra.chips }
		}
	end
}
