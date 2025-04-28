-- Probably gonna be moved directly into Revo's Vault at some point...

SMODS.Joker {
	name = "Inkblot Printer",
	key = 'inkblot',
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 0, y = 0 },
	atlas = "REVO_JOE_Printers",
	dependencies = "RevosVault",
	calculate = function(self, card, context)
		if context.setting_blind and #G.jokers.cards < G.jokers.config.card_limit then
			SMODS.add_card { key = "j_payasaka_photocopier" }
		end
	end,
	in_pool = function(self, args)
		return true
	end
}

SMODS.Joker {
	name = "Monopoly Printer",
	key = 'monoprint',
	rarity = "crv_p",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	pos = { x = 1, y = 0 },
	atlas = "REVO_JOE_Printers",
	dependencies = "RevosVault",
	calculate = function(self, card, context)
		if context.setting_blind and #G.consumeables.cards < G.consumeables.config.card_limit then
			SMODS.add_card { set = "Property" }
			return {
				message = "Printed!"
			}
		end
	end,
	in_pool = function(self, args)
		return true
	end
}
