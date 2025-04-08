-- Talisman,,,,
to_big = to_big or function(a) return a end
is_number = is_number or function(a) return type(a) == "number" end

-- Loosely based on Cryptid's misprintize.lua
PTASaka.BaseValues = {}
PTASaka.MisprintizeForbidden = {
	["id"] = true,
	["perish_tally"] = true,
	["colour"] = true,
	["suit_nominal"] = true,
	["base_nominal"] = true,
	["face_nominal"] = true,
	["qty"] = true,
	["selected_d6_face"] = true,
	--["x_mult"] = true,
}
local function sanitycheck(tbl, val)
	if val == nil then val = {} end
	if tbl == nil then tbl = val end
	return tbl
end
function PTASaka.deep_copy(obj, seen)
	if type(obj) ~= "table" then
		return obj
	end
	if seen and seen[obj] then
		return seen[obj]
	end
	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))
	s[obj] = res
	for k, v in pairs(obj) do
		res[PTASaka.deep_copy(k, s)] = PTASaka.deep_copy(v, s)
	end
	return res
end

-- Does not handle recursive tables, work on that
function PTASaka.MisprintizeTable(key, tbl, baseval, mult, stack)
	if not key then return end
	if not tbl then return end
	-- Add a key if not added already
	PTASaka.BaseValues[key] = sanitycheck(PTASaka.BaseValues[key],{})
	baseval = sanitycheck(baseval,PTASaka.BaseValues[key])
	
	local cpy = PTASaka.deep_copy(tbl)
	
	for k, v in pairs(cpy) do
		local typ = type(v)
		-- Number?
		if is_number(v) and not PTASaka.MisprintizeForbidden[k] then 
			baseval[k] = sanitycheck(baseval[k],cpy[k])
			if baseval[k] > 0 then
				cpy[k] = cpy[k] * mult
				--sendInfoMessage("Misprintized value named "..k.. " with value "..baseval[k], "PTASaka")
				--sendInfoMessage("Value should now be "..cpy[k].." from "..baseval[k], "PTASaka")
			end
		end
	end
	
	return cpy
end

-- Taken from Cryptid...
function PTASaka.with_deck_effects(card, func)
	if not card.added_to_deck then
		return func(card)
	else
		card:remove_from_deck(true)
		local ret = func(card)
		card:add_to_deck(true)
		return ret
	end
end

function PTASaka.Photocopy(jkr, mult, unphotocopy)
	local mul = mult
	if unphotocopy == true then mul = 1 / mult end
	-- Cryptid is on, just use misprintize
	if Cryptid then
		Cryptid.with_deck_effects(jkr, function(card)
			Cryptid.misprintize(card, { min = mul, max = mul }, nil, true)
			card.ability.photocopied = not unphotocopy
		end)
		return
	end
	-- Otherwise, use ours
	PTASaka.with_deck_effects(jkr, function(jkr)
		local key = jkr.config.center_key
		jkr.ability = PTASaka.MisprintizeTable(key, jkr.ability, nil, mul, true)
		PTASaka.BaseValues[key]["ability"] = {}
		for k, v in pairs(jkr.ability) do
			if type(jkr.ability[k]) == "table" and not is_number(jkr.ability[k]) then
				jkr.ability[k] = PTASaka.MisprintizeTable(jkr.config.center_key, jkr.ability[k], PTASaka.BaseValues[key]["ability"], mul, true)
			end
		end
		--jkr.ability.extra = PTASaka.MisprintizeTable(jkr.config.center_key, jkr.ability.extra, nil, mul, true)
		jkr.ability.photocopied = not unphotocopy
	end)
end

-- Photocopier
SMODS.Joker {
	name = "Photocopier",
	key = "photocopier",
	config = { extra = { coolmult = 2, old_jkrs = {nil, nil} } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.coolmult } }
	end,
	rarity = 3, 
	atlas = "JOE_Jokers",
	pos = { x = 4, y = 0 },
	cost = 15,
	blueprint_compat = false,
	update = function(self, card2, dt)
		if G.STAGE == G.STAGES.RUN then
			-- Get cards from left and right
			local cards = {nil, nil}
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card2 then 
					cards[1] = G.jokers.cards[i+1]
					if i > 1 then
						cards[2] = G.jokers.cards[i-1]
					end
				end
			end
			
			-- Do not affect other Photocopiers....
			if cards[1] and cards[1].config.center.key == card2.config.center.key then cards[1] = nil end
			if cards[2] and cards[2].config.center.key == card2.config.center.key then cards[2] = nil end
			
			local mult = card2.ability.extra.coolmult
			-- Switched jokers, halve the old one
			if card2.ability.extra.old_jkrs[1] and card2.ability.extra.old_jkrs[1] ~= cards[1] then
				local jkr = card2.ability.extra.old_jkrs[1]
				if jkr.config and not Card.no(jkr, "immutable", true) then
					PTASaka.Photocopy(jkr, mult, true)
				end
			end
			if card2.ability.extra.old_jkrs[2] and card2.ability.extra.old_jkrs[2] ~= cards[2] then
				local jkr = card2.ability.extra.old_jkrs[2]
				if jkr.config and not Card.no(jkr, "immutable", true) then
					PTASaka.Photocopy(jkr, mult, true)
				end
			end
			
			-- Switched jokers, double the new one
			if cards[1] and not cards[1].ability.photocopied and not Card.no(cards[1], "immutable", true) then
				PTASaka.Photocopy(cards[1], mult, false)
			end
			if cards[2] and not cards[2].ability.photocopied and not Card.no(cards[2], "immutable", true) then
				PTASaka.Photocopy(cards[2], mult, false)
			end
			
			card2.ability.extra.old_jkrs = cards
		end
	end,
}