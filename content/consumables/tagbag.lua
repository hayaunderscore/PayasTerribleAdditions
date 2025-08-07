SMODS.ConsumableType {
	key = 'TagBag',
	collection_rows = { 3 },
	primary_colour = HEX('697be8'),
	secondary_colour = HEX('697be8'),
	shop_rate = 0,
	loc_txt = {},
	default = 'c_payasaka_tagbagtest'
}

PTASaka.TagBagLabelPositions = {
	["pta_saka"] = { x = 1, y = 1 },
	["allinjest"] = { x = 2, y = 1 },
	["paperback"] = { x = 3, y = 1 },
	["aikoyorisshenanigans"] = { x = 5, y = 1 },
	["MoreFluff"] = { x = 6, y = 1 },
	["ortalab"] = { x = 7, y = 1 },
	["TOGAPack"] = { x = 8, y = 1 },
	["Cryptid"] = { x = 0, y = 2 },
	["Bunco"] = { x = 2, y = 2 },
	["BHevven"] = { x = 3, y = 2 },
	["sarcpot"] = { x = 5, y = 2 },
}

-- Sets Tag Bag sprites and creates tag bag graphics if needed.
-- Returns tag bag graphic and desired tag bag labels.
---@param self balatro.Card|Card|table
---@param center PTA.TagBag|balatro.Item.Consumable
---@return balatro.AssetAtlas, balatro.AssetAtlas, table|{x: number, y: number}
function PTASaka.CreateTagBagGraphic(self, center)
	local tag = self.ability and self.ability.tagbag_tag or center.pta_default_tag
	local name = localize { type = 'name_text', set = 'Tag', key = tag }

	---@type SMODS.Tag
	---@diagnostic disable-next-line: assign-type-mismatch
	local tag_center = G.P_TAGS[tag]
	name = (name or ""):gsub(" Tag", ""):gsub(" Patch", "")

	-- Main atlas for text and tag graphic
	local atlas = G.ASSET_ATLAS["payasaka_tagbagatlas_" .. name]

	-- Create tag name graphic, if we have not created one yet...
	if not atlas then
		-- New canvas that will serve as our pseudo-image
		local canvas = love.graphics.newCanvas(71, 95)
		---@type love.Font
		local font = SMODS.Fonts["payasaka_Tarot"].FONT
		local text = string.upper(name)
		if font:getWidth(text) > 42 then text = text:lower() end
		-- trim the text until it fits perfectly
		local ot = text
		while font:getWidth(text) > 42 do
			ot = ot:sub(1, -2)
			text = ot .. "."
		end
		-- Create tag graphic quad
		local tag_atlas = G.ASSET_ATLAS[tag_center.atlas or "tags"]
		local quad = love.graphics.newQuad(tag_center.pos.x * tag_atlas.px, tag_center.pos.y * tag_atlas.py,
			tag_atlas.px, tag_atlas.py, tag_atlas.image)

		local oldcanvas = love.graphics.getCanvas()
		love.graphics.setCanvas(canvas)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.printf({ HEX('586473'), text }, font, 1, 15, 71, "center")
		-- Draw the tag graphic here too
		love.graphics.draw(tag_atlas.image, quad, 19, 39)
		love.graphics.setCanvas(oldcanvas)

		G.ASSET_ATLAS["payasaka_tagbagatlas_" .. name] = {
			name = "payasaka_tagbagatlas_" .. name,
			path = G.ASSET_ATLAS["payasaka_JOE_Tarots_Adjust"].path,
			full_path = G.ASSET_ATLAS["payasaka_JOE_Tarots_Adjust"].full_path,
			image = canvas,
			image_data = canvas:newImageData(),
			px = 71,
			py = 95,
			type = 0
		}
		atlas = G.ASSET_ATLAS["payasaka_tagbagatlas_" .. name]
	end

	local label_atlas = G.ASSET_ATLAS["payasaka_tagbag"]
	local pos = { x = 0, y = 1 }

	if tag_center and tag_center.mod then
		pos = { x = 4, y = 2 } -- Blueprint mod default
	end

	-- Mod has a tag label atlas provided
	if tag_center and tag_center.mod and G.ASSET_ATLAS[tag_center.mod.prefix .. "_tagbag_top"] then
		label_atlas = G.ASSET_ATLAS[tag_center.mod.prefix .. "_tagbag_top"]
		pos = { x = 0, y = 0 }
		return atlas, label_atlas, pos
	end

	-- hardcoded lmao
	if tag_center and tag_center.key == "tag_payasaka_nil" then
		pos = { x = 4, y = 1 }
		return atlas, label_atlas, pos
	end

	-- Specified mods by default
	if tag_center and tag_center.mod and PTASaka.TagBagLabelPositions[tag_center.mod.id] then
		pos = PTASaka.TagBagLabelPositions[tag_center.mod.id]
		return atlas, label_atlas, pos
	end

	return atlas, label_atlas, pos
end

---@class PTA.TagBag: SMODS.Consumable
---@field pta_front_pos? table|{x: number, y: number}
---@field pta_front_shadow? boolean
---@field pta_default_tag? string
---@overload fun(self: PTA.TagBag): PTA.TagBag
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
		G.E_MANAGER:add_event(Event {
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
				play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
				play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
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
			key = tag_center and tag_center.mod and tag_center.mod.id == "ortalab" and self.key .. "_patch" or self.key
		}
	end
}
