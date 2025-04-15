return {
	descriptions = {
		Joker = {
			j_payasaka_buruakacard = {
				name = "Adult Card",
				text = {
					"Sold {C:attention}Jokers{}' effects",
					"can be mimicked by this Joker",
					"Joker mimicked changes every time",
					"a Joker could be triggered",
					"{C:inactive,s:0.8}Does not count other Adult Cards",
					"{C:inactive,s:0.8}A Blue Archive reference in my Balatro?",
					"{C:inactive,s:0.8}How absurd.",
				}
			},
			j_payasaka_buruakacard_alt = {
				name = "Adult Card?",
				text = {
					"Sold {C:attention}Jokers{}' effects",
					"can be mimicked by this Joker",
					"{X:attention,C:white}ALL{} Joker effects are applicable",
					"{C:inactive,s:0.8}Does not count other Adult Cards",
					"{C:inactive,s:0.8}A Blue Archive reference in my Balatro?",
					"{C:inactive,s:0.8}How absurd.",
				}
			},
			j_payasaka_charred = {
				name = "Charred Joker",
				text = {
					"Upgrade the level of",
					"the first {C:attention}discarded",
					"poker hand each round by {C:attention}#1#{}",
					"{C:red}-1{} Discard",
					"{C:inactive,s:0.8}Look at this joker...{}",
				}
			},
			j_payasaka_newspaper = {
				name = "Daily Newspaper",
				text = {
					"When {C:attention}Blind{} is selected,",
					"add a card with a random",
					"{C:attention}edition{} to your deck",
					"{C:inactive,s:0.8}Random card takes suit from",
					"{C:inactive,s:0.8}available suits in the deck",
				}
			},
			j_payasaka_photocopier = {
				name = "Photocopier",
				text = {
					"{C:attention}Multiplies{} the effects",
					"of adjacent Jokers by {X:attention,C:white}X#1#{C:inactive}",
					"{C:inactive,s:0.8}Does not affect other Photocopier{}",
					"{C:inactive,s:0.8}If it did, that would be silly.{}"
				}
			},
			j_payasaka_reistorm = {
				name = "Reistorm",
				text = {
					"Retriggers all Jokers",
					"an additional {C:attention}#1#{} times",
					"with {C:green}#2# in #3#{} chance of",
					"creating a random",
					"{C:dark_edition}Negative{} {C:red}Rare{C:attention} Joker{}",
					"at end of round",
					"{C:inactive,s:0.8}Technically not a Brainstorm{}",
					"{C:inactive,s:0.8}but whatever{}",
				}
			},
			j_payasaka_goodnevil = {
				name = "Good 'n Evil",
				text = {
					"For every scored card {C:attention}triggered{}",
					"Add {C:red}#1#{} Mult to current Mult",
					"Amount is {C:attention}incremented{} every time",
					"this Joker is {C:attention}triggered{}",
					"as well as its {C:dark_edition}sign{}",
					"{C:inactive,s:0.8}(Currently {C:red}#2#{C:inactive,s:0.8} Mult)",
					"{C:inactive,s:0.8}Turn the lights off...",
				}
			},
			j_payasaka_markiplier_punch_gif = {
				name = "{X:red,C:white}Multi{}plier",
				text = {
					"{C:green}#1# in #2#{} chance of",
					"turning {C:red}+Mult{} to {X:red,C:white}XMult{}",
					"{C:green}#3# in #4#{} chance of",
					"turning {C:chips}+Chips{} to {X:chips,C:white}XChips{}",
					"{C:inactive,s:0.8}The messages lie...",
				}
			},
			j_payasaka_tentens = {
				name = "Ten 10s",
				text = {
					"{C:green}#1# in #2#{} chance of",
					"retriggering a scored",
					"card {C:attention}#3#{} times",
					"{C:inactive,s:0.8}look at what you",
					"{C:inactive,s:0.8}made me do ari",
				}
			},
			j_payasaka_phil = {
				name = "Phil {s:0.5}& Shirt{}",
				text = {
					"{X:red,C:white}X#1#{} Mult",
					"{C:green}#2# in #3#{} chance of",
					"giving {X:red,C:white}X0{} Mult instead",
					"{C:inactive,s:0.8}when your {X:black,C:white,s:0.8}shirt",
					"{C:inactive,s:0.8}is a geek :laugh:",
				}
			},
			j_payasaka_arona = {
				name = "Arona",
				text = {
					"{X:chips,C:white}X#1#{} Chips {C:inactive,s:0.8}:<{}",
					"unless {C:dark_edition,E:2}Plana{} is around",
					"gives {X:chips,C:white}X#2#{} Chips instead",
					"Gains {X:chips,C:white}X#3#{} every time",
					"this Joker is triggered",
					"{C:inactive,s:0.8}stop stealing my fucking chips",
				}
			},
			j_payasaka_plana = {
				name = "Plana",
				text = {
					"Creates a random {C:dark_edition}Negative",
					"{C:spectral}Spectral{} card every round",
					"Gives {X:red,C:white}X#1#{} Mult",
					"if {C:green,E:2}Arona{} is around",
					"Gains {X:mult,C:white}X#2#{} every time",
					"this Joker is triggered",
					"{C:inactive,s:0.8}now THIS this is a good one",
				}
			},
		},
		Blind = {
			bl_payasaka_nether = {
				name = "The Nether",
				text = {
					"All played cards are destroyed",
				}
			},
		},
		Edition = {
			e_payasaka_jpeg = {
				name = "xX_rainbow_Xx",
				text = {
					"{X:chips,C:white}X#1#{} Chips",
					"{X:mult,C:white}X#2#{} Mult",
					"{C:green}#3# in #4#{} chance of",
					"turning into a",
					"random {C:green}edition{}",
					"or {C:dark_edition}enhancement{}",
					"{C:inactive,s:0.8,E:2}What the fuck?"
				}
			}
		},
		DescriptionDummy = {
			dd_payasaka_adultcard_area = { name = "Sold Jokers", text = { "{C:inactive,s:0.8}Jokers listed have a chance of triggering{}" } },
			dd_payasaka_property_card = { name = "Property", text = { "Each {C:green}house{} gives", "half the price of", "this {C:property}Property", "{C:inactive,s:0.8}Hotels are equivalent{}", "{C:inactive,s:0.8}to 5 houses{}" }}
		},
		Tarot = {
			c_payasaka_greed = {
				name = "The Greed",
				text = {
					"Adds a house to {C:attention}#1#",
					"selected {C:property}Property{} cards",
					"{C:inactive,s:0.8}Having more than 4 houses",
					"{C:inactive,s:0.8}replaces it with a hotel",
				}
			}
		},
		Rotarot = {
			c_payasaka_rot_greed = {
				name = "The Greed!",
				text = {
					"Creates up to {C:attention}#1#",
					"{C:property}Property{} cards",
				}
			}
		},
		Property = {
			c_payasaka_brownproperty = {
				name = 'Brown Property',
				text = {
					"Gains {C:money}$#2#{} if played hand",
					"is a {C:attention}#3#{}",
					"Does nothing else when used",
					"{C:inactive,s:0.8}(Currently {C:money,s:0.8}$#1#{C:inactive,s:0.8} per round)",
				}
			},
			c_payasaka_blueproperty = {
				name = 'Blue Property',
				text = {
					"Gains {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"Randomizes the {C:dark_edition}edition{} of up",
					"to {C:attention}#4#{} selected cards",
					"when used",
					"{C:inactive,s:0.8}(Currently {C:money,s:0.8}$#1#{C:inactive,s:0.8} per round)",
				}
			},
			c_payasaka_pinkproperty = {
				name = 'Pink Property',
				text = {
					"Gains {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"Creates {C:attention}#4#{} random Food",
					"Jokers when used",
					"{C:inactive,s:0.8}(Currently {C:money,s:0.8}$#1#{C:inactive,s:0.8} per round)",
				}
			},
			c_payasaka_orangeproperty = {
				name = 'Orange Property',
				text = {
					"Gains {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"Creates {C:attention}#4#{} {C:tarot}Tarot{}",
					"cards when used",
					"{C:inactive,s:0.8}(Currently {C:money,s:0.8}$#1#{C:inactive,s:0.8} per round)",
					--"{C:inactive,s:0.8}(Must have room)",
				}
			},
			c_payasaka_redproperty = {
				name = 'Red Property',
				text = {
					"Gains {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"Creates a {C:red}Rare{} Joker",
					"when used",
					"{C:inactive,s:0.8}(Currently {C:money,s:0.8}$#1#{C:inactive,s:0.8} per round)",
					--"{C:inactive,s:0.8}(Must have room)",
				}
			},
			c_payasaka_yellowproperty = {
				name = 'Yellow Property',
				text = {
					"Gains {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"Levels up your {C:attention}most{}",
					"{C:attention}played{} hand by {C:attention}#4#{}",
					"levels when used",
					"{C:inactive,s:0.8}(Currently {C:money,s:0.8}$#1#{C:inactive,s:0.8} per round)",
				}
			},
			c_payasaka_greenproperty = {
				name = 'Green Property',
				text = {
					"Gains {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"Creates a {C:dark_edition}Legendary{}",
					"Joker when used",
					"{C:inactive,s:0.8}(Currently {C:money,s:0.8}$#1#{C:inactive,s:0.8} per round)",
					--"{C:inactive,s:0.8}(Must have room)",
				}
			},
			c_payasaka_darkblueproperty = {
				name = 'Dark Blue Property',
				text = {
					"Gains {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"{C:inactive,s:0.8}Does nothing..?",
					"{C:inactive,s:0.8}(Currently {C:money,s:0.8}$#1#{C:inactive,s:0.8} per round)",
				}
			},
			c_payasaka_niyaniya = {
				name = 'Niyaniya',
				text = {
					"Gains {C:money}$#2#{} per round",
					"{C:inactive,s:0.8}(WIP, undecided yet)",
					"{C:inactive,s:0.8}(Currently {C:money,s:0.8}$#1#{C:inactive,s:0.8} per round)",
				}
			},
		},
		Other = {
			undiscovered_property = {
				name = "Not Discovered",
				text = {
					"Purchase or use",
					"this card in an",
					"unseeded run to",
					"learn what it does"
				}
			},
			p_payasaka_property_normal_1 = {
				name = "Property Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:property} Property{} cards to",
					"add to your consumeables"
				}
			},
			p_payasaka_property_normal_2 = {
				name = "Property Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:property} Property{} cards to",
					"add to your consumeables"
				}
			},
			p_payasaka_property_mega_1 = {
				name = "Mega Property Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:property} Property{} cards to",
					"add to your consumeables"
				}
			},
			p_payasaka_property_mega_2 = {
				name = "Mega Property Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:property} Property{} cards to",
					"add to your consumeables"
				}
			},
			p_payasaka_property_jumbo_1 = {
				name = "Jumbo Property Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:property} Property{} cards to",
					"add to your consumeables"
				}
			},
			p_payasaka_property_jumbo_2 = {
				name = "Jumbo Property Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:property} Property{} cards to",
					"add to your consumeables"
				}
			},
		}
	},
	misc = {
		dictionary = {
			k_property = "Property",
			b_property_cards = "Property Cards",
			k_property_pack = "Property Pack",
		},
		labels = {
			payasaka_jpeg = 'YCbCr'
		}
	},
	labels = {
		property = "Property"
	},
}
