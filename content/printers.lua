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
	calculate = function(self, card, context)
		if context.setting_blind and #G.jokers.cards < G.jokers.config.card_limit then
			SMODS.add_card { key = "j_payasaka_photocopier" }
		end
	end,
	in_pool = function(self, args)
		return true
	end,
	set_badges = function(self, card, badges)
		G.C.P_REVO = HEX('7E7AFF')
		G.C.P_REVO_TEXT = HEX('40093A')
		badges[#badges+1] = create_badge("Revo's Vault", G.C.P_REVO, G.C.P_REVO_TEXT)
	end
}
