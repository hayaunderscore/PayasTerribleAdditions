SMODS.ConsumableType {
	key = 'TagBag',
	collection_rows = { 3 },
	primary_colour = HEX('697be8'),
	secondary_colour = HEX('697be8'),
	shop_rate = 0,
	loc_txt = {},
	default = 'c_payasaka_tagbagtest'
}

SMODS.Consumable {
	set = 'TagBag',
	key = 'tagbagtest',
	atlas = "tagbag",
	pos = { x = 0, y = 0 },
	pta_front_pos = { x = 0, y = 1 },
	pta_front_shadow = true,
	config = { tagbag_tag = "tag_rare" },
	pta_default_tag = "tag_rare",
	unlocked = true,
	discovered = true,
	draw = function(self, card, layer)
		card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event{
			trigger = 'after',
			delay = 0.5,
			func = function()
				local tag = Tag(card.ability.tagbag_tag or self.pta_default_tag)
				if tag.name == "Orbital Tag" then
					local _poker_hands = {}
					for k, v in pairs(G.GAME.hands) do
						if v.visible then
							_poker_hands[#_poker_hands + 1] = k
						end
					end
					tag.ability.orbital_hand = pseudorandom_element(_poker_hands, "joy_orbital")
				end
				add_tag(tag)
				play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
				play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
				card:juice_up()
				return true
			end
		})
		delay(0.6)
	end,
	can_use = function(self, card)
		return true
	end,
	update = function(self, card, dt)
		if card.match_tag ~= card.ability.tagbag_tag then
			card:set_sprites(self)
			card.match_tag = card.ability.tagbag_tag
		end
	end,
	set_ability = function(self, card, initial, delay_sprites)
		if initial then
			-- use a random tag
			card.ability.tagbag_tag = pseudorandom_element(G.P_CENTER_POOLS.Tag, 'tagbag').key
			card.match_tag = card.ability.tagbag_tag
		end
		card:set_sprites(self)
	end,
	set_badges = function(self, card, badges)
		local tag_center = G.P_TAGS[card.ability.tagbag_tag or self.pta_default_tag]
		if not tag_center then tag_center = G.P_TAGS["tag_uncommon"] end
		self.pta_credit = tag_center.pta_credit or {}
		if tag_center.mod ~= self.mod then
			SMODS.create_mod_badges(tag_center, badges)
		end
	end,
	set_card_type_badge = function(self, card, badges)
		local tag_center = G.P_TAGS[card.ability.tagbag_tag or self.pta_default_tag]
		badges[#badges + 1] = create_badge(
			tag_center and tag_center.mod and tag_center.mod.id == "ortalab" and localize('k_tagbag_patch') or
			localize('k_tagbag'),
			G.C.SECONDARY_SET[card.ability.set], nil, 1.2
		)
	end,
	loc_vars = function(self, info_queue, card)
		local tag_center = G.P_TAGS[card.ability.tagbag_tag or self.pta_default_tag]
		--info_queue[#info_queue + 1] = tag_center
		return {
			vars = {
				localize {
					type = 'name_text',
					key = card.ability.tagbag_tag or self.pta_default_tag,
					set = 'Tag',
					vars = {}
				}
			},
			key = tag_center and tag_center.mod and tag_center.mod.id == "ortalab" and self.key.."_patch" or self.key
		}
	end
}
