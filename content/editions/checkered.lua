SMODS.Shader {
	key = 'checkered',
	path = 'checkered.fs'
}

SMODS.Edition {
	key = 'checkered',
	shader = 'payasaka_checkered',
	sound = { sound = "foil2", per = 1.2, vol = 0.8 },
	config = {
		extra = {
			x_chips = 1.5,
		}
	},
	calculate = function (self, card, context)
		
	end,
	loc_vars = function(self, info_queue, card)
		local conf = card and card.edition and card.edition or self.config or { extra = {} }
		return {
			vars = {
				conf.extra.x_chips
			}
		}
	end
}