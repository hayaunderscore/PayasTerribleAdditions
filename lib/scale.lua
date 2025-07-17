-- Double Scale/Scalae inspired scale manipulation shit why not
-- Proxy stuff inspired by https://github.com/Steamodded/smods/pull/781

--- table for keys blacklisted for scaling
PTASaka.invalid_scaling_keys = {
	['immutable'] = true,
	['consumeable'] = true,
	['mimic_effect'] = true,
	['id'] = true,
	['identifier'] = true, -- used by Finity's Crimson Heart
	['finitycrimsonheartmark'] = true, -- Ditto
	['finityceruleanbellmark'] = true, -- Cerulean Bell
	['finityrazzleraindropmark'] = true, -- Razzle Raindrop
	['finitysaffronshieldmark'] = true, -- Saffron Shield
	["ID"] = true,
	["sort_id"] = true,
	["perish_tally"] = true,
	["colour"] = true,
	["suit_nominal"] = true,
	["base_nominal"] = true,
	["face_nominal"] = true,
	["qty"] = true,
	["selected_d6_face"] = true,
	['next_joker'] = true, -- Adult Card
}

-- Table for keys whitelisted ONLY on the ability table
PTASaka.whitelisted_ability_keys = {
	['mult'] = true,
	['h_mult'] = true,
	['h_x_mult'] = true,
	['h_dollars'] = true,
	['p_dollars'] = true,
	['t_mult'] = true,
	['t_chips'] = true,
	['x_mult'] = true,
	['h_chips'] = true,
	['x_chips'] = true,
	['h_x_chips'] = true,
	['h_size'] = true,
	['d_size'] = true,
    ['extra'] = true,
	['extra_value'] = true,
	['perma_bonus'] = true,
	['perma_x_chips'] = true,
	['perma_mult'] = true,
	['perma_x_mult'] = true,
	['perma_h_chips'] = true,
	['perma_h_mult'] = true,
	['perma_h_x_mult'] = true,
	['perma_p_dollars'] = true,
	['perma_h_dollars'] = true,
	['caino_xmult'] = true,
	['invis_rounds'] = true,
	['yorick_discards'] = true, -- Accounted for
	['perma_e_chips'] = true,
	['perma_e_mult'] = true,
	['perma_balance'] = true,
	['partial_rounds'] = true, -- Accounted for
	['val'] = true
}

---@param card Card
---@param tree table
---@param tbl table | nil
---@param key string | nil
---@param pass boolean | nil
function PTASaka.create_card_scale_proxy(card, tree, tbl, key, pass)
	-- Immutable cards do not need a proxy
	if card.config.center.immutable then return end

	PTASaka.ignore_proxy_check = true

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

	-- For some checks later
	local center_key = card.config.center_key
	local center = card.config.center
	local set = card.ability.set
	local exclusion_function = card.config.center.pta_exclusion_function

	-- Add a fallback just in case if there was already a metatable for this before...
	local old_meta = getmetatable((tbl or card)[key])

	setmetatable((tbl or card)[key], {
		__proxy_meta = tree[key.."_orig"],
		__newindex = function(t, k, v)
			if tree[key.."_orig"][k] == v then return end -- Unmodified, so ignore

			-- Not in game, not in an area, area is collection, or the value is not a number
			-- If so, ignore, and just modify it normally
			if (G.STAGE ~= G.STAGES.RUN or not card.area or card.area.config.collection) or (PTASaka.invalid_scaling_keys[k] or (key == 'ability' and not PTASaka.whitelisted_ability_keys[k])) then
				tree[key.."_orig"][k] = v
				--if type(v) == 'table' then print(v) end
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

			-- Specific stuff for specific jokers/consumables
			-- Yorick's extra.yorick_discards should not exceed discards
			if center_key == "j_yorick" and k == 'yorick_discards' then tree[key.."_orig"][k] = math.min(new_val, v); return end
			-- Colour cards upgrade rounds should not inflate beyond 0 or negatives
			if set == "Colour" or set == "Shape" and k == 'partial_rounds' then tree[key.."_orig"][k] = math.max(new_val, v); return end
			-- Custom jokers can add `pta_exclusion_function` to their jokers for specific things
			if exclusion_function and type(exclusion_function) == 'function' then
				-- Card center, card instance, current value, old value, new value, key of value to be modified, table key of value
				local ret = exclusion_function(center, card, tree[key.."_orig"][k], v, new_val, k, key)
				-- Boolean, simply prevent scaling
				if type(ret) == 'boolean' and not ret then
					tree[key.."_orig"][k] = v
					return
				end
				-- Number, return modified value
				if type(ret) == 'number' then
					tree[key.."_orig"][k] = ret
					return
				end
			end

			tree[key..'_orig'][k] = new_val
		end,
		__index = function(t, k)
			return tree[key..'_orig'][k]
		end
	})

	PTASaka.ignore_proxy_check = nil
end

function PTASaka.remove_card_scale_proxy(parent, tree, key)
	key = key or 'ability'
	if not tree[key.."_orig"] then
		return
	end

	parent[key] = tree[key.."_orig"]
	setmetatable(parent[key], nil)

	PTASaka.ignore_proxy_check = true
	for k, _ in pairs(tree) do
		if k ~= key.."_orig" then
			PTASaka.remove_card_scale_proxy(parent[key], tree[k], k)
		end
	end
	PTASaka.ignore_proxy_check = nil
end

function PTASaka.remove_proxy(self)
	if self.pta_ability_scaled then
		PTASaka.remove_card_scale_proxy(self, self.pta_ability_scaled)
		--self.pta_ability_scaled = nil
	end
	self.pta_ability_scaled = {}
end

function PTASaka.create_proxy(self)
	self.pta_ability_scaled = {}
	PTASaka.create_card_scale_proxy(self, self.pta_ability_scaled)
end

-- Ok look its very stupid but __pairs doesn't exist until Lua 5.2 so bear with me
local next_ref = next
function next(table, index)
	local mt = getmetatable(table)
	if mt and mt.__proxy_meta and not PTASaka.ignore_proxy_check then table = mt.__proxy_meta end
	return next_ref(table, index)
end

local pairs_ref = pairs
function pairs(t)
	local mt = getmetatable(t)
	if mt and mt.__proxy_meta and not PTASaka.ignore_proxy_check then t = mt.__proxy_meta end
	return pairs_ref(t)
end

local old_set_ability = Card.set_ability
function Card:set_ability(...)
	PTASaka.remove_proxy(self)
	old_set_ability(self, ...)
	PTASaka.create_proxy(self)
end

-- Remove proxy on copy_card
local old_copy_card = copy_card
function copy_card(other, ...)
	PTASaka.remove_proxy(other)
	local ret = old_copy_card(other, ...)
	PTASaka.create_proxy(other)
	return ret
end

local old_save = Card.save
function Card:save()
	PTASaka.remove_proxy(self)
	local ret = old_save(self)
	ret.ability = copy_table(self.ability)
	PTASaka.create_proxy(self)
	return ret
end

local old_load = Card.load
function Card:load(cardTable, other_card)
	PTASaka.remove_proxy(self)
	local ret = old_load(self, cardTable, other_card)
	PTASaka.create_proxy(self)
	return ret
end