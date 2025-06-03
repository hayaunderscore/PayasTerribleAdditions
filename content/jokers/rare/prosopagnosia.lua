SMODS.Joker {
	name = "Prosopagnosia",
	key = "prosopagnosia",
	rarity = 3,
	atlas = "JOE_Jokers2",
	pos = { x = 1, y = 0 },
	cost = 6,
	blueprint_compat = false,
	demicoloncompat = false,
}

local ids_op_ref = ids_op
function ids_op(card, op, b, c)
	local id = card:get_id()
	local other_results = false
	if ids_op_ref ~= nil then
		other_results = ids_op_ref(card, op, b, c)
	end

	local function alias(x)
		local prosopagnosia = next(SMODS.find_card("j_payasaka_prosopagnosia"))
		if prosopagnosia and card.base.id == 14 and (({[11]=true, [12]=true, [13]=true, [id]=true})[b]) then
			return 11
		end
		return x
	end

	if other_results == true then
		return true
	end

	if op == "mod" then
		return (id % b) == c
	end

	if op == "==" then
		local lhs = alias(id)
		local rhs = alias(b)
		return lhs == rhs
	end
	if op == "~=" then
		local lhs = alias(id)
		local rhs = alias(b)
		return lhs ~= rhs
	end

	if op == ">=" then return id >= b end
	if op == "<=" then return id <= b end
	if op == ">" then return id > b end
	if op == "<" then return id < b end

	error("ids_op: unsupported op " .. tostring(op))
end

local is_face = Card.is_face
function Card:is_face(...)
	local ret = is_face(self, ...)
	if next(SMODS.find_card("j_payasaka_prosopagnosia")) and self.base.id == 14 then
		ret = true
	end
	return ret
end