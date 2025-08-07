SMODS.Achievement {
	key = 'gacha_prismatic',
	unlock_condition = function(self, args)
		if args and args.type == 'payasaka_gacha_select' then
			if args.card and args.card.config.center and args.card.config.center.rarity == "payasaka_daeha" then
				return true
			end
		end
		return false
	end
}

SMODS.Achievement {
	key = 'beat_ante39',
	unlock_condition = function(self, args)
		if args and args.type == 'ante_up' and args.ante == 40 and G.GAME.blind.config.blind.key == "bl_payasaka_showdown_sweet_sleep" then
			return true
		end
		return false
	end
}

SMODS.Achievement {
	key = 'risktaker',
	unlock_condition = function(self, args)
		if args and args.type == 'payasaka_risk_count' and args.amount > 10 then
			return true
		end
		return false
	end
}

SMODS.Achievement {
	key = 'thunderstruck',
	unlock_condition = function(self, args)
		if args and args.type == 'payasaka_encounter_thunderstruck' then
			return true
		end
		return false
	end
}

SMODS.Achievement {
	key = 'friend',
	unlock_condition = function(self, args)
		if args and args.type == 'win' and G.jokers then
			local count = 0
			for k, v in pairs(G.jokers.cards) do
				if v and v.config.center and v.config.center.pools and v.config.center.pools["Friend"] then
					count = count + 1
				end
			end
			return count >= 3
		end
		return false
	end
}