--[[
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.payasaka_monopolizer_mult = 0
	ret.payasaka_monopolizer_x_mult = 0
	return ret
end
]]

SMODS.Voucher {
	key = "monopolizer",
	atlas = 'JOE_Vouchers',
	pos = { x = 0, y = 0 },
	cost = 10,
	config = { mult = 10 },
	redeem = function (self, card)
		G.GAME.payasaka_monopolizer_mult = G.GAME.payasaka_monopolizer_mult or 0
		G.GAME.payasaka_monopolizer_mult = G.GAME.payasaka_monopolizer_mult + card.ability.mult
	end,
	unredeem = function (self, card)
		G.GAME.payasaka_monopolizer_mult = G.GAME.payasaka_monopolizer_mult or 0
		G.GAME.payasaka_monopolizer_mult = G.GAME.payasaka_monopolizer_mult - card.ability.mult
	end,
	-- like The Greed, only appear when we have atleast one property card
	in_pool = function(self, args)
		local properties = {}
		if not (G.consumeables and G.consumeables.cards and G.consumeables.cards[1]) then return false end
		for _, v in ipairs(G.consumeables.cards) do
			if v.ability.set == 'Property' then
				table.insert(properties, v)
			end
		end
		return #properties > 0
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult } }
	end
}

SMODS.Voucher {
	key = "meritocracy",
	atlas = 'JOE_Vouchers',
	pos = { x = 1, y = 0 },
	cost = 10,
	config = { x_mult = 1.5 },
	requires = { "v_payasaka_monopolizer" },
	redeem = function (self, card)
		G.GAME.payasaka_monopolizer_x_mult = G.GAME.payasaka_monopolizer_x_mult or 0
		G.GAME.payasaka_monopolizer_x_mult = G.GAME.payasaka_monopolizer_x_mult + card.ability.x_mult
	end,
	unredeem = function (self, card)
		G.GAME.payasaka_monopolizer_x_mult = G.GAME.payasaka_monopolizer_x_mult or 0
		G.GAME.payasaka_monopolizer_x_mult = G.GAME.payasaka_monopolizer_x_mult - card.ability.x_mult
	end,
	-- like The Greed, only appear when we have atleast one property card
	in_pool = function(self, args)
		local properties = {}
		if not (G.consumeables and G.consumeables.cards and G.consumeables.cards[1]) then return false end
		for _, v in ipairs(G.consumeables.cards) do
			if v.ability.set == 'Property' then
				table.insert(properties, v)
			end
		end
		return #properties > 0
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.x_mult } }
	end
}