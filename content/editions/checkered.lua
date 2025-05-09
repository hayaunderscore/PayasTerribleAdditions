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
		return {
			vars = {
				card.edition and card.edition.extra.x_chips or nil
			}
		}
	end
}