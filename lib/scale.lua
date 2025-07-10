-- Double Scale/Scalae inspired scale manipulation shit why not
-- Proxy stuff inspired by https://github.com/Steamodded/smods/pull/781

--- table for keys blacklisted for scaling
PTASaka.valid_scaling_keys = {
	['immutable'] = true,
	['consumeable'] = true,
	['mimic_effect'] = true,
}

---@param card Card
---@param tree table
---@param tbl table | nil
---@param key string | nil
---@param pass boolean | nil
function PTASaka.create_card_scale_proxy(card, tree, tbl, key, pass)
	-- Immutable cards do not need a proxy
	if card.config.center.immutable then return end

	if pass == nil then
		pass = true
		key = 'ability'
		if not (tbl or card)[key] then return end
	end

	tree[key.."_orig"] = (tbl or card)[key]

	local nested = {}
	for k, v in pairs((tbl or card)[key]) do
		-- Only scale extra and ability tables outright
		if type(v) == 'table' and not (v.is and v:is(Object)) and (k == 'ability' or k == 'extra') then
			tree[k] = {}
			nested[k] = PTASaka.create_card_scale_proxy(card, tree[k], (tbl or card)[key], k, false)
		end
	end

	if not key then return end

	-- We will set this as a proxy
	-- All values indexed and fed will be via metatable
	(tbl or card)[key] = {}
	for k, v in pairs(nested) do
		(tbl or card)[key][k] = v
	end

	setmetatable((tbl or card)[key], {
		__newindex = function(t, k, v)
			if tree[key.."_orig"][k] == v then return end -- Unmodified, so ignore

			-- Not in game, not in an area, area is collection, or the value is not a number
			-- If so, ignore, and just modify it normally
			if (G.STAGE ~= G.STAGES.RUN or not card.area or card.area.config.collection) or PTASaka.valid_scaling_keys[k] then
				tree[key.."_orig"][k] = v
				return
			end

			if not is_number(v) then
				tree[key.."_orig"][k] = v
				return
			end

			-- Change scaling here
			-- As there is only one joker that does scaling so far, this is VERY hardcoded to only use that joker...
			-- Which is scaling this shit 2x as much
			-- Will be unhardcoded soon probably
			local new_val = v
			local diff = new_val - (tree[key.."_orig"][k] or 0)
			new_val = (tree[key.."_orig"][k] or 0) + diff * 2 ^ (PTASaka.scale_modifier_jokers and #PTASaka.scale_modifier_jokers or 0)
			tree[key..'_orig'][k] = new_val
		end,
		__index = function(t, k)
			return tree[key..'_orig'][k]
		end
	})
end

function PTASaka.remove_card_scale_proxy(parent, tree, key)
	key = key or 'ability'
	if not tree[key.."_orig"] then
		return
	end

	parent[key] = tree[key.."_orig"]
	setmetatable(parent[key], nil)

	for k, _ in pairs(tree) do
		if k ~= key.."_orig" then
			PTASaka.remove_card_scale_proxy(parent[key], tree[k], k)
		end
	end
end

local old_set_ability = Card.set_ability
function Card:set_ability(...)
	if self.pta_ability_scaled then
		PTASaka.remove_card_scale_proxy(self, self.pta_ability_scaled)
		--self.pta_ability_scaled = nil
	end
	old_set_ability(self, ...)
	self.pta_ability_scaled = {}
	PTASaka.create_card_scale_proxy(self, self.pta_ability_scaled)
end

local old_save = Card.save
function Card:save()
	if self.pta_ability_scaled then
		PTASaka.remove_card_scale_proxy(self, self.pta_ability_scaled)
		--self.pta_ability_scaled = nil
	end
	local ret = old_save(self)
	ret.ability = copy_table(self.ability)
	self.pta_ability_scaled = {}
	PTASaka.create_card_scale_proxy(self, self.pta_ability_scaled)
	return ret
end

local old_load = Card.load
function Card:load(cardTable, other_card)
	if self.pta_ability_scaled then
		PTASaka.remove_card_scale_proxy(self, self.pta_ability_scaled)
		--self.pta_ability_scaled = nil
	end
	local ret = old_load(self, cardTable, other_card)
	self.pta_ability_scaled = {}
	PTASaka.create_card_scale_proxy(self, self.pta_ability_scaled)
	return ret
end