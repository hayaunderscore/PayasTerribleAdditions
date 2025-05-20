return {
	descriptions = {
		Back = {
			b_payasaka_shittim = {
				name = "Shittim Deck",
				text = {
					"Start run with",
					"an {C:attention,T:j_payasaka_buruakacard}Adult Card{}",
					"with {C:blue,T:j_payasaka_arona}Arona{} and {C:dark_edition,T:j_payasaka_plana}Plana{}",
					"Can {C:attention}reroll{} Booster Packs in the {C:green}shop",
				}
			},
			b_payasaka_dark_shittim = {
				name = "Shittim Deck?",
				text = {
					"Start run with",
					"an {C:attention,T:j_payasaka_buruakacard}Adult Card?{}",
					"with {C:blue,T:j_payasaka_arona}Arona{} and {C:dark_edition,T:j_payasaka_plana}Plana{}",
					"as {C:green}Sold{} jokers",
					"Can {C:attention}reroll{} Booster Packs in the {C:green}shop",
				}
			},
			b_payasaka_monopoly = {
				name = "Monopoly Deck",
				text = {
					"Start the run",
					"with a {C:attention,T:v_payasaka_monopolizer}Monopolizer{},",
					"a {C:attention,T:v_payasaka_meritocracy}Meritocracy{}",
					"and {C:attention}#1#{} random {C:property}Property{} cards",
					"No {C:attention}numbered{} cards in the deck",
					"{C:attention}X2{} deck size",
					"{C:attention}+#2#{} consumable slots",
				}
			},
			b_payasaka_purgatory = {
				name = "Purgatory Deck",
				text = {
					"Only {C:red}Risk{} cards,",
					"vouchers and Booster Packs",
					"can {C:attention}appear{} in the shop",
					"{C:inactive}(Heavy WIP!)"
				}
			},
		},
		Joker = {
			j_payasaka_buruakacard = {
				name = "Adult Card",
				text = {
					"Sold {C:attention}Jokers{}' effects",
					"can be mimicked by this Joker",
					"Joker mimicked changes every time",
					"a Joker could be triggered",
					"{C:inactive,s:0.8}Does not count other Adult Cards",
				},
				payasaka_comment = {
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
				},
				payasaka_comment = {
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
				},
				payasaka_comment = {
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}'The Onion'. Or is it 'The Joker'?{}",
				}
			},
			j_payasaka_photocopier = {
				name = "Photocopier",
				text = {
					"{C:attention}Multiplies{} the effects",
					"of adjacent Jokers by {X:attention,C:white}X#1#{C:inactive}",
				},
				payasaka_comment = {
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Technically not a Brainstorm{}",
					"{C:inactive,s:0.8}but whatever{}",
				}
			},
			j_payasaka_goodnevil = {
				name = "Good 'n Evil",
				text = {
					"{C:red}#2#{} Mult per {C:attention}scored{} card",
					"Gains {X:dark_edition,C:white}abs(#1#)*1(n){} Mult per",
					"scored card",
					"{X:dark_edition,C:white}n{} is multiplied by {X:dark_edition,C:white}X-1{}"
				},
				payasaka_comment = {
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Does not work on MacOS",
					"{C:inactive,s:0.8}The messages lie...",
				}
			},
			j_payasaka_tentens = {
				name = "Ten 10s",
				text = {
					"{C:green}#1# in #2#{} chance of",
					"retriggering a scored",
					"card {C:attention}#3#{} times",
				},
				payasaka_comment = {
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
				},
				payasaka_comment = {
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
					"Gains {X:chips,C:white}X#3#{} for every",
					"{C:diamonds}Diamonds{} or {C:diamonds}Hearts{} scored",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}stop stealing my fucking chips",
				}
			},
			j_payasaka_plana = {
				name = "Plana",
				text = {
					"{C:green}#3# in #4#{} chance to",
					"create a random {C:dark_edition}Negative",
					"{C:spectral}Spectral{} card every round",
					"Gives {X:red,C:white}X#1#{} Mult",
					"if {C:green,E:2}Arona{} is around",
					"Gains {X:chips,C:white}X#2#{} for every",
					"{C:spades}Spades{} or {C:clubs}Clubs{} scored",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}now THIS this is a good one",
				}
			},
			j_payasaka_flintnsteel2 = {
				name = "Flint and Steel 2",
				text = {
					"If played hand contains a {C:attention}Pair{}",
					"one {C:hearts}Hearts{} or {C:diamonds}Diamonds{} suit",
					"and one {C:spades}Spades{} or {C:clubs}Clubs{} suit",
					"give {C:mult}+#1#{} Mult",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
					"{C:inactive}(e.g. {C:hearts}H{C:inactive}+{C:spades}S{C:inactive}, \
{C:diamonds}D{C:inactive}+{C:clubs}C{C:inactive}, \
{C:hearts}H+{C:clubs}C{C:inactive}, \
{C:diamonds}D{C:inactive}+{C:spades}S{C:inactive})",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Not to be confused with the Joker",
					"{C:inactive,s:0.8}of the same name from MoreFluff",
				}
			},
			j_payasaka_inkblot = {
				name = "Inkblot Printer",
				text = {
					"When Blind is selected,",
					"print a {C:attention}Photocopier{}",
					"{C:inactive,s:0.8}(Must have room)",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}insert witty comment here"
				}
			},
			j_payasaka_rainy = {
				name = "Rainy Apartments",
				text = {
					"All played cards without",
					"an enhancement are turned",
					"into {C:attention}Damp Cards{}",
					"Prevents {C:attention}Damp Cards{} from",
					"turning into {C:attention}Wet Cards{}",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}It took me 40 minutes",
					"{C:inactive,s:0.8}to get this screenshot",
				}
			},
			j_payasaka_mrseal = {
				name = "Mr. Seal",
				text = {
					"Retrigger all cards",
					"with a {C:attention}seal{}",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Any seal, really!",
				}
			},
			j_payasaka_doodlekosmos = {
				name = "Interitus",
				text = {
					"This Joker gains {X:dark_edition,C:white}#2#{} Mult",
					"for every card held in {C:attention}hand",
					"{C:green}#3# in #4#{} chance to {C:dark_edition}Evolve{}",
					"at the {C:attention}end of a round",
					"{C:inactive}(Currently {X:dark_edition,C:white}#1#{C:inactive} Mult)",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Dollar store kosmos",
				}
			},
			j_payasaka_doodlekosmos_alt = {
				name = "Interitus",
				text = {
					"This Joker gains {X:dark_edition,C:white}#2#{} Mult",
					"for every card held in {C:attention}hand",
					"{C:green}#3# in #4#{} chance to {C:dark_edition}Evolve{}",
					"at the {C:attention}end of a round",
					"{C:inactive}(Currently {X:dark_edition,C:white}#1#{C:inactive} Mult)",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}The cooler",
					"{C:inactive,s:0.8}Dollar store kosmos",
				}
			},
			j_payasaka_joyousspring = {
				name = "Joyous Spring",
				text = {
					"{X:mult,C:white}X#1#{} Mult for each time either",
					"the words {C:attention}\"joyousspring\"{} or {C:attention}\"joyous spring\"{}",
					"have been said in the {C:attention}Balatro Discord{}",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
					"{C:blue,s:0.7}https://discord.gg/balatro{}",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}You should play JoyousSpring",
					"{C:inactive,s:0.8}Usually updated daily",
				}
			},
			-- JoyousSpring cross mod
			j_payasaka_joyousspring_alt = {
				name = "Joyous Spring",
				text = {
					"Base {X:mult,C:white}X#1#{} Mult for each time either",
					"the words {C:attention}\"joyousspring\"{} or {C:attention}\"joyous spring\"{}",
					"have been said in the {C:attention}Balatro Discord{}",
					"{C:green}#3# in #4#{} chance to not draw cards",
					"after playing/discarding",
					"Gains {X:mult,C:white}X#5#{} Mult each time",
					"this effect is triggered",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
					"{C:blue,s:0.7}https://discord.gg/balatro{}",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}You should play JoyousSpring",
					"{C:inactive,s:0.8}Usually updated daily",
				}
			},
			j_payasaka_arrowstone = {
				name = "Arrowstone",
				text = {
					"{C:green}#1# in #2#{} chance for",
					"played cards with",
					"{C:spades}Spade{} suit to give",
					"{X:chips,C:white} X#3# {} Chips when scored",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}:drool:",
				}
			},
			j_payasaka_drapingtablet = {
				name = "Draping Tablet",
				text = {
					"Retrigger {C:attention}first{} played",
					"card used in scoring",
					"for each card with",
					"{C:spades}Spade{} suit",
					"in your {C:attention}hand",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}For all those Flush bros",
					"{C:inactive,s:0.8}out there...."
				}
			},
			j_payasaka_locomotive = {
				name = "Locomotive Getaway",
				text = {
					"Turn Jokers to the right",
					"of this Joker to {C:red}nil{}",
					"This Joker will {C:attention}always{} move",
					"to the right of the list",
					"{X:chips,C:white}X#1#{} Chips for every",
					"Joker replaced",
					"{C:inactive}(Currently {X:chips,C:white}X#2#{C:inactive} Chips)",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}- shupo -",
					"{C:inactive,s:0.8}A japanese onomatopoeia",
					"{C:inactive,s:0.8}meaning 'train'",
				}
			},
			j_payasaka_nil = {
				name = "",
				text = {
					""
				}
			},
			j_payasaka_world = {
				name = "World is Spades",
				text = {
					"{C:green}#2# in #3#{} chance of",
					"{C:attention}turning{} non-{C:spades}Spade{} suit",
					"cards to {C:spades}Spades{}",
					"{X:chips,C:white}X#1#{} for each",
					"card {C:attention}changed",
					"{C:inactive}(Currently {X:chips,C:white}X#4#{C:inactive} Chips)",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}sekai de",
				}
			},
			j_payasaka_arrowgraph = {
				name = "Arrowgraph",
				text = {
					"Played {C:spades}Spade{} cards",
					"add {X:chips,C:white}X#1#{} Chips",
					"when {C:attention}scored",
					"Scored card gives",
					"{X:chips,C:white}X#2#{} Chips"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}look at this graph",
				}
			},
			j_payasaka_imerlogio = {
				name = "Bibliotheca",
				text = {
					"{X:mult,C:white}X#1#{} Mult for {C:attention}every{} modded",
					"Joker in your {C:dark_edition}Collection",
					"Additional {X:mult,C:white}X#2#{} Mult for {C:attention}every{}",
					"other Joker you currently own",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Nxkoo having a",
					"{C:inactive,s:0.8}field day right now",
				}
			},
			j_payasaka_btryacidspaghet = {
				name = "Battery Acid Spaghetti",
				text = {
					"{X:mult,C:white}X#1#{} Blind Size",
					"for {X:mult,C:white}X#2#{} Mult",
					"Mult decreases by {X:mult,C:white}X#3#{}",
					"at the {C:attention}end{} of round",
					"{C:red}Self destructs",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}don't do this"
				}
			},
			j_payasaka_monster = {
				name = "Monster Energy",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"Decreases by {X:mult,C:white}X#2#{}",
					"for every {C:diamonds}Diamond",
					"or {C:hearts}Heart{} card played",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}My favorite energy drink"
				}
			},
			j_payasaka_pyroxene = {
				name = "Pyroxene Card",
				text = {
					"Additional {C:blue}¥#1#{}",
					"every round",
					"Increases by {C:blue}¥#2#",
					"for every {C:clubs}Club",
					"or {C:spades}Spade{} card played",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}RE-DO!"
				}
			},
			j_payasaka_winton = {
				name = "Winton",
				text = {
					"Copies the {C:attention}leftmost",
					"scored card {C:attention}#1#{} time and",
					"adds it to the {C:attention}scoring hand"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}winton"
				}
			},
			j_payasaka_shotgun = {
				name = "Shotgun",
				text = {
					"{C:attention}ALWAYS{} destroy the",
					"Joker to its right",
					"regardless of its stickers",
					"{X:mult,C:white}X#1#{} for every Joker",
					"destroyed this way",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}*pickup* SHOTGUN"
				}
			},
			j_payasaka_raceasaring = {
				name = "Ringing Joker",
				text = {
					"Add {X:mult,C:white}X#1#{} Mult for",
					"{C:attention}buying{}, {C:attention}selling{} or {C:attention}using{}",
					"cards, vouchers and Booster",
					"Packs or selecting a {C:attention}blind{}",
					"Skipping a {C:attention}blind{} or skipping",
					"a {C:attention}Booster Pack{} decreases",
					"current Mult by {X:mult,C:white}X#2#{}",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Not sponsored by",
					"{C:inactive,s:0.8}Kart Krew",
				}
			},
			j_payasaka_regina = {
				name = "Regina",
				text = {
					"Turns scored cards",
					"to {C:dark_edition}Queens",
					"{X:dark_edition,C:white}^#1#{} Mult for each",
					"card changed",
					"{C:inactive}(Currently {X:dark_edition,C:white}^#2#{C:inactive} Mult)",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}blahaj 2",
				}
			},
			j_payasaka_monoprint = {
				name = "Monopoly Printer",
				text = {
					"When Blind is selected,",
					"print a {C:property}Property Card{}",
					"{C:inactive,s:0.8}(Must have room)",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}this is very monopoly"
				}
			},
			j_payasaka_paya = {
				name = "Yonii Payasaka",
				text = {
					"Upon {C:attention}selecting{} a blind,",
					"{C:green}#1# in #2#{} chance of",
					"turning the {C:attention}operation{} of",
					"chips and mult from",
					"{C:attention}multiplication to",
					"{X:dark_edition,C:white}exponentiation"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Self insert joker"
				}
			},
			j_payasaka_ari = {
				name = "Ari",
				text = {
					"Scored {C:attention}Aces{}, {C:attention}2s",
					"and {C:attention}3s{} give {X:mult,C:white}X#1#{} Mult"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}it's just a slice of ham"
				}
			},
			j_payasaka_enotsworra = {
				name = "enotsworrA",
				text = {
					"       cards     ",
					"           give",
					"{B:1,V:2}#2##1#{} Chips            ",
				},
			},
			j_payasaka_canichat = {
				name = "A    head",
				text = {
					"       cards     ",
					"           give",
					"{C:chips}+#1#{} Chips            ",
				}
			},
			j_payasaka_bahead = {
				name = "Bahead",
				text = {
					"Each {C:attention}Queen{} of",
					"{C:spades}Spades{} held in hand",
					"gives {X:chips,C:white} X#1# {} Chips",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}baronness is back"
				}
			},
			j_payasaka_envelope = {
				name = "Shiny Envelope",
				text = {
					"{C:green}#1# in #2#{} chance of",
					"creating a {C:attention}random",
					"consumable at the {C:attention}end{}",
					"of a round, {C:attention}increasing{}",
					"current XChips by {X:chips,C:white}X#3#",
					"{C:inactive}(Currently {X:chips,C:white}X#4#{C:inactive} Chips)"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}There are no purple"
				}
			},
			j_payasaka_printhead = {
				name = "Printhead",
				text = {
					"Copies ability of",
					"{C:attention}Joker(s){} to the right",
					"Number of Jokers copied",
					"is tied to {C:attention}currently owned{}",
					"Ahead Joker count {C:inactive}[#1#]"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}wtf"
				}
			},
			j_payasaka_aheadstorm = {
				name = "Aheadstorm",
				text = {
					"Copies the ability",
					"of leftmost {C:attention}Joker",
					"Number of times copied",
					"is tied to {C:attention}currently owned{}",
					"Ahead Joker count {C:inactive}[#1#]"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}wth"
				}
			},
			j_payasaka_triahead = {
				name = "Triahead",
				text = {
					"Held and scored cards each",
					"give {X:chips,C:white} X#1# {} Chips when scored",
					"if played hand is a",
					"{C:attention}Three of a Kind"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}MoreFluff cross mod!!!!"
				}
			},
			j_payasaka_snapgraph = {
				name = "Deviant Memory",
				text = {
					"When used, current {C:attention}held",
					"hand is {C:attention}saved",
					"{C:attention}Restores{} said {C:attention}held{} hand",
					"when used a second time",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Say cheese!"
				}
			},
			j_payasaka_rei = {
				name = "Nomasa Rei",
				text = {
					"Selects the {C:attention}best{} possible",
					"hand type to play when {C:attention}used",
					"{C:inactive,s:0.8}Does not support modded poker hands"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}blue archive refereeeence"
				}
			},
			j_payasaka_niveusterras = {
				name = "Album Agros",
				text = {
					"All cards are {X:payasaka_prismatic_gradient,C:white}Ahead",
					"Scored cards give {X:dark_edition,C:white}^#1#{} Chips",
					"Additional {X:dark_edition,C:white}^#2#{} Chips when",
					"played hand is a {C:attention}Flush{}",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}The clouds are coming"
				}
			},
			j_payasaka_cyan = {
				name = "Cyan",
				text = {
					"{X:chips,C:white}X#1#{} Chips and",
					"{X:attention,C:white}X#1#{} {C:planet}Planet{} multiplier",
					"Gains {X:chips,C:white}X#2#{} Chips per",
					"{C:attention}scored{} {C:spades}Spades{} or {C:clubs}Clubs{}",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}:("
				}
			},
			j_payasaka_s16 = {
				name = "{s:4}Joker{}",
				text = {
					"{C:mult,s:16}+#1#{s:16} Mult",
					"{s:4}This huge text is very important",
					"{s:2}trust me"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}how can you still see this"
				}
			},
			j_payasaka_idk = {
				name = "Speed Fiend",
				text = {
					"Main Joker effects trigger",
					"{C:attention}first{} before scored cards"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Speed Demon."
				}
			},
			j_payasaka_maxheadroom = {
				name = "Max Headroom",
				text = {
					"Consumables can target",
					"more than {C:attention}#2#{} card",
					"{C:money}-$#2#{} for each",
					"consumable used"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}FUUUTURE !!"
				}
			},
			j_payasaka_dango = {
				name = "Dango",
				text = {
					"{C:attention}Food{} Jokers",
					"each give {X:mult,C:white}X#1#{} Mult",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Just let her have it",
					"{C:inactive,s:0.8}dammit"
				}
			},
			j_payasaka_silenced = {
				name = 'Silenced',
				text = {
					"{C:attention}Debuffed{} cards and Jokers",
					"each give {X:mult,C:white}X#1#{} Mult"
				},
			},
			j_payasaka_cartridge = {
				name = 'Cartridge Joker',
				text = {
					"{X:mult,C:white}X#1#{} Mult with a",
					"{C:green}#2# in #3#{} chance of {C:attention}debuffing",
					"itself for an entire round"
				},
			},
			j_payasaka_no_retrigger = {
				name = 'Aww! No Retriggers',
				text = {
					"{C:dark_edition,E:1}Nullifies{} retriggers and",
					"replaces them with XMult,",
					"XChips, or money {C:attention}corresponding{}",
					"to its repetition {C:attention}value{}",
				}
			},
			j_payasaka_joker_lua = {
				name = "joker.lua",
				text = {
					"{X:mult,C:white}X#1#{} Mult for every",
					"lua file {C:attention}required/loaded",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
				}
			},
			j_payasaka_recuperare = {
				name = "Recuperare",
				text = {
					"{C:attention}Saves{} values of triggered",
					"cards to this Joker",
					"then {C:attention}returns{} saved values",
					"one {C:attention}level{} higher",
					"{C:inactive}(e.g. +Mult -> XMult)"
				}
			},
			j_payasaka_fanhead = {
				name = "Fanhead",
				text = {
					"{C:chips}Ahead{} Jokers each",
					"give {X:dark_edition,C:white}^#1#*#2#{} Chips",
				}
			},
			j_payasaka_scrapped = {
				name = "Scrapped",
				text = {
					"Held cards {C:attention}later",
					"give {X:chips,C:white}X#1#{} Chips",
					"when {C:attention}played"
				}
			},
			j_payasaka_missingno = {
				name = "{font:payasaka_pokemon}MISSINGNO.",
				text = {
					"{X:mult,C:white}X#1#{} Mult for each time the",
					"word {C:attention}\"finity\"{} has been said",
					"in the {C:attention}Balatro Discord{}",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
					"{C:blue,s:0.7}https://discord.gg/balatro{}",
				}
			},
			j_payasaka_bajablast = {
				name = "Baja Blast",
				text = {
					"{X:chips,C:white}X#1#{} Chips",
					"Decreases by {X:chips,C:white}X#2#{}",
					"for every {C:spades}Spade",
					"or {C:clubs}Club{} card played",
				},
			},
			j_payasaka_photobinder = {
				name = "Photobinder",
				text = {
					"{C:attention}Multiplies{} the effects",
					"of leftmost and rightmost",
					"Jokers by {X:attention,C:white}X#1#",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Does not affect other Photocopier{}",
					"{C:inactive,s:0.8}If it did, that would be silly.{}"
				}
			},
			j_payasaka_clubcleaver = {
				name = "Club Cleaver",
				text = {
					"{C:green}#1# in #2#{} chance for",
					"held cards with",
					"{C:clubs}Club{} suit to give",
					"{X:chips,C:white}X#3#{} Chips",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}:drool:",
				}
			},
		},
		Blind = {
			bl_payasaka_nether = {
				name = "The Nether",
				text = {
					"All played cards",
					"are destroyed",
				}
			},
			bl_payasaka_question = {
				name = 'The Cast', text = { "Fusion of the blinds", "#1#" }
			},
			bl_payasaka_question_alt = { name = 'The Cast', text = { "You shouldn't spoil", "yourself, now..." } },
			bl_payasaka_prelude = {
				name = 'Prelude Blind'
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
			},
			e_payasaka_checkered = {
				name = "Checkered",
				text = {
					"{X:chips,C:white}X#1#{} Chips?",
				}
			}
		},
		Enhanced = {
			m_payasaka_damp = {
				name = "Damp Card",
				text = {
					"{X:chips,C:white}X#1#{} Chips",
					"{X:mult,C:white}X#2#{} Mult",
					"{C:green}#3# in #4#{} chance to",
					"turn into a",
					"{C:attention}Wet Card{}",
				}
			},
			m_payasaka_wet = {
				name = "Wet Card",
				text = {
					"{C:chips}+#1#{} Chips",
					"No rank but",
					"Can be used",
					"as any suit",
				}
			}
		},
		DescriptionDummy = {
			dd_payasaka_adultcard_area = { name = "Sold Jokers", text = { "{C:inactive,s:0.8}Jokers listed have a chance of triggering{}" } },
			dd_payasaka_property_card = { name = "Property", text = { "Each {C:green}house{} gives", "half the price of", "this {C:property}Property", "{C:inactive,s:0.8}Hotels are equivalent{}", "{C:inactive,s:0.8}to 5 houses{}" } },
			dd_payasaka_ahead = { name = "Ahead", text = { "This card is feeling", "rather {C:blue}pointy" } },
			dd_payasaka_recuperare = {
				name = "://VALUES",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"{X:chips,C:white}X#2#{} Chips",
					"{X:dark_edition,C:white}^#3#{} Mult",
					"{X:dark_edition,C:white}^#4#{} Chips",
					"{X:dark_edition,C:white}^^#5#{} Mult",
					"{X:dark_edition,C:white}^^#6#{} Chips",
					"{X:dark_edition,C:white}^^^#7#{} Mult",
					"{X:dark_edition,C:white}^^^#8#{} Chips",
					"{X:dark_edition,C:white}^^^^#9#{} Mult",
					"{X:dark_edition,C:white}^^^^#10#{} Chips",
					"{C:money}$#11#{}",
				}
			},
			dd_payasaka_missingno_finity = {
				name = "With Finity enabled:",
				text = {
					"{C:green}#1# in #2#{} chance of",
					"creating a {C:dark_edition}Showdown{} Joker",
					"{C:inactive}(Must have room)"
				}
			}
		},
		DOSCard = {
			c_payasaka_dos_wild = {
				name = "Wild",
				text = {
					"Can be set as",
					"{C:attention}any{} {C:dark_edition}DOS{} card",
				}
			},
			c_payasaka_dos_exclam = {
				name = "Exclamation",
				text = {
					"Turn into a {C:attention}random{}",
					"Joker for an {C:attention}entire{}",
					"round when enabled",
				}
			},
			c_payasaka_dos_wildtwo = {
				name = "Wild 2",
				text = {
					"Turn into the",
					"{C:attention}rightmost{} scored",
					"card when enabled"
				}
			},
			c_payasaka_dos_three = {
				name = "3",
				text = {
					"{C:inactive}Does nothing",
					"{C:inactive}currently"
				}
			},
			c_payasaka_dos_four = {
				name = "4",
				text = {
					"{C:inactive}Does nothing",
					"{C:inactive}currently"
				}
			},
			c_payasaka_dos_five = {
				name = "5",
				text = {
					"{C:inactive}Does nothing",
					"{C:inactive}currently"
				}
			},
			c_payasaka_dos_six = {
				name = "6",
				text = {
					"{C:inactive}Does nothing",
					"{C:inactive}currently"
				}
			},
			c_payasaka_dos_seven = {
				name = "7",
				text = {
					"{C:inactive}Does nothing",
					"{C:inactive}currently"
				}
			},
			c_payasaka_dos_eight = {
				name = "8",
				text = {
					"{C:inactive}Does nothing",
					"{C:inactive}currently"
				}
			},
			c_payasaka_dos_nine = {
				name = "9",
				text = {
					"{C:inactive}Does nothing",
					"{C:inactive}currently"
				}
			},
			c_payasaka_dos_ten = {
				name = "10",
				text = {
					"{C:inactive}Does nothing",
					"{C:inactive}currently"
				}
			},
		},
		Tarot = {
			c_payasaka_greed = {
				name = "Avarice",
				text = {
					"Adds a house to {C:attention}#1#",
					"selected {C:property}Property{} cards",
					"{C:inactive,s:0.8}Having more than 4 houses",
					"{C:inactive,s:0.8}replaces it with a hotel",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}The Greed was taken",
				}
			},
			c_payasaka_stamp = {
				name = "The Inscribe",
				text = {
					"Turns up to {C:attention}#1#",
					"selected {C:red}nil{} cards",
					"to a {C:attention}random{} Joker",
					"{C:inactive,s:0.8}No regards to weight.",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Stamping? I did",
					"{C:inactive,s:0.8}stamping once.",
				}
			}
		},
		Tag = {
			tag_payasaka_propertytag = {
				name = "Property Tag",
				text = {
					"Gives a free",
					"{C:property}Mega Property Pack",
				},
			},
			tag_payasaka_nil = {
				name = " Tag",
				text = {
					"Shop has a free",
					"{C:red}nil",
				},
			},
			tag_payasaka_ahead = {
				name = "Ahead Tag",
				text = {
					"Shop has a free",
					"{C:edition}Ahead Joker",
				},
			},
			tag_payasaka_tier1reward = {
				name = "Reward Tag",
				text = {
					"Gives a free",
					"{C:reward}Reward Pack",
				},
			},
			tag_payasaka_tier2reward = {
				name = "Reward Tag (II)",
				text = {
					"Gives a free",
					"{C:reward}Jumbo Reward Pack",
				},
			},
			tag_payasaka_tier3reward = {
				name = "Reward Tag (III)",
				text = {
					"Gives a free",
					"{C:reward}Mega Reward Pack",
				},
			},
		},
		Spectral = {
			c_payasaka_crack = {
				name = "Crack",
				text = {
					"Add either a",
					"{C:legendary}Random Seal{} or",
					"a {C:dark_edition}xX_rainbow_Xx{}",
					"to {C:attention}#1#{} selected",
					"card in your hand"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Peter, what are",
					"{C:inactive,s:0.8}you doing?",
				}
			},
			c_payasaka_mechanic = {
				name = "Mechanic",
				text = {
					"Turns up to {C:attention}#1#",
					"selected {C:red}nil{} card",
					"to a Joker of choice",
					"{C:inactive,s:0.8}No limits.",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Fluffy...",
				}
			},
			c_payasaka_showdown = {
				name = "Showdown",
				text = {
					"{C:attention}Transforms{} the boss",
					"blind to a {C:attention}showdown",
					"boss blind for a",
					"{C:dark_edition}Negative{} {C:reward}Mind"
				}
			},
			c_payasaka_center = {
				name = "Center",
				text = {
					"Turns {C:attention}#1#{} selected Joker into",
					"a {C:prismatic}Prismatic{} Joker and",
					"turn {C:attention}all{} other Jokers into",
					"ones of the same {C:attention}rarity{}"
				}
			}
		},
		Risk = {
			c_payasaka_doubledown = {
				name = "Double Down",
				text = {
					"{C:attention}Doubles{} the boss",
					"blind's {C:attention}requirement",
				}
			},
			c_payasaka_cast = {
				name = "Cast",
				text = {
					"{C:attention}Applies{} a {C:attention}random{}",
					"boss blind's {C:attention}ability",
					"to current boss blind",
				}
			},
			c_payasaka_decay = {
				name = "Eclipse",
				text = {
					"{X:attention,C:white}÷#1#{} poker hand levels",
					"during the boss blind",
				}
			},
			c_payasaka_stunted = {
				name = "Stunted",
				text = {
					"Played {C:attention}Enhanced{} cards have a",
					"{C:green}#1# in #2#{} chance of not {C:attention}activating",
					"during the {C:attention}next{} boss blind",
				}
			},
			c_payasaka_crime = {
				name = "Crime",
				text = {
					"{C:red}-#1#{} hand size when the",
					"boss blind is {C:attention}selected{}",
				}
			},
			c_payasaka_hinder = {
				name = "Hinder",
				text = {
					"{C:attention}Debuff{} {C:attention}#1#{} random",
					"cards in your deck upon",
					"{C:attention}entering{} the boss blind"
				}
			},
			c_payasaka_hollow = {
				name = "Hollow",
				text = {
					"{C:attention}Debuffs{} all consumables",
					"during the {C:attention}next{} boss blind",
				}
			},
			c_payasaka_leak = {
				name = "Leak",
				text = {
					"Lose {C:money}$#1#{} per {C:attention}scored{} card",
					"during the {C:attention}next{} boss blind",
				}
			},
			c_payasaka_elysium = {
				name = "Elysium",
				text = {
					"{C:attention}Debuff{} the {C:attention}rightmost",
					"Joker during the boss blind",
				}
			},
			c_payasaka_elusive = {
				name = "Elusive",
				text = {
					"{C:attention}First{} drawn card is faced",
					"down during the boss blind",
				}
			},
			c_payasaka_prelude = {
				name = "Prelude",
				text = {
					"{C:attention}Encounter{} a {C:attention}Prelude Blind",
					"before the boss blind",
				}
			},
		},
		Reward = {
			c_payasaka_conform = {
				name = "Conform",
				text = {
					"Convert up to {C:attention}#1#{} selected",
					"cards into the {C:attention}rightmost",
					"card's {C:attention}suit",
				}
			},
			c_payasaka_chance = {
				name = "Chance",
				text = {
					"Get {C:attention}X#1#{} the sell value",
					"of a {C:attention}random{} Joker",
				}
			},
			c_payasaka_hone = {
				name = "Hone",
				text = {
					"Levels up the {C:purple,E:1}most played",
					"poker hand by {C:attention}#1#",
				}
			},
			c_payasaka_metalicize = {
				name = "Metalicize",
				text = {
					"Add {C:dark_edition}Foil{}, {C:dark_edition}Holographic{}",
					"or {C:dark_edition}Polychrome{} edition",
					"to a random {C:attention}Joker",
				}
			},
			c_payasaka_shine = {
				name = "Shine",
				text = {
					"Give up to {C:attention}#1#{} cards a {C:attention}random{}",
					"edition, enhancement or seal",
				}
			},
			c_payasaka_parlay = {
				name = "Parlay",
				text = {
					"Creates up to {C:attention}#1#",
					"random {C:risk}Risk{} cards",
					"{C:inactive}(Must have room)",
				}
			},
			c_payasaka_remember = {
				name = "Remember",
				text = {
					"{C:purple,E:1}Upgrades{} a",
					"{C:attention}random{} voucher",
				}
			},
			c_payasaka_dream = {
				name = "Dream",
				text = {
					"Creates a {C:dark_edition}Negative",
					"{C:chips}Common{} Joker",
				}
			},
			c_payasaka_sprint = {
				name = "Sprint",
				text = {
					"Creates a {C:attention}random",
					"skip tag",
				}
			},
			c_payasaka_sulfur = {
				name = "Sulfur",
				text = {
					"Destroys up to",
					"{C:attention}#1#{} selected cards",
				},
			},
			c_payasaka_mind = {
				name = "Mind",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:joker} {C:purple,E:1}Legendary{} {C:joker}Jokers{}",
				},
			},
		},
		Rotarot = {
			c_payasaka_rot_greed = {
				name = "Avarice!",
				text = {
					"Creates up to {C:attention}#1#",
					"{C:property}Property{} cards",
					"{C:inactive,s:0.8}(Must have room)"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}First ever cross mod",
					"{C:inactive,s:0.8}rotarot????",
				}
			},
			c_payasaka_rot_stamp = {
				name = "The Inscribe!",
				text = {
					"Creates up to {C:attention}#1#",
					"{C:red}nil{} cards",
					"{C:inactive,s:0.8}(Must have room)"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Wow! Look, nothing",
				}
			}
		},
		Voucher = {
			v_payasaka_monopolizer = {
				name = "Monopolizer",
				text = {
					"Property cards each",
					"give {C:mult}+#1#{} Mult"
				}
			},
			v_payasaka_meritocracy = {
				name = "Meritocracy",
				text = {
					"Property cards each",
					"give {X:mult,C:white}X#1#{} Mult"
				}
			},
			v_payasaka_tmtrainer = {
				name = "{font:payasaka_pokemon}TMTRAINER",
				text = {
					"",
				}
			},
			v_payasaka_cooltrainer = {
				name = "{font:payasaka_pokemon}CoolTrainer♀",
				text = {
					"",
				}
			},
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
			p_payasaka_moji_normal_1 = {
				name = "Reward Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:reward} Reward{} cards to",
					"be used immediately",
				}
			},
			p_payasaka_moji_normal_2 = {
				name = "Reward Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:reward} Reward{} cards to",
					"be used immediately",
				}
			},
			p_payasaka_moji_mega_1 = {
				name = "Mega Reward Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:reward} Reward{} cards to",
					"be used immediately",
				}
			},
			p_payasaka_moji_jumbo_1 = {
				name = "Jumbo Reward Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:reward} Reward{} cards to",
					"be used immediately",
				}
			},
			p_payasaka_risk_normal_1 = {
				name = "Risk Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:risk} Risk{} cards to",
					"be used immediately",
				}
			},
			p_payasaka_risk_normal_2 = {
				name = "Risk Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:risk} Risk{} cards to",
					"be used immediately",
				}
			},
			p_payasaka_risk_mega_1 = {
				name = "Mega Risk Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:risk} Risk{} cards to",
					"be used immediately",
				}
			},
			p_payasaka_risk_jumbo_1 = {
				name = "Jumbo Risk Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:risk} Risk{} cards to",
					"be used immediately",
				}
			},
			p_payasaka_legendary_normal_1 = {
				name = "Legendary Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:joker} {C:purple,E:1}Legendary{} {C:joker}Jokers{}",
				}
			},
			payasaka_random_seal = {
				name = "Random Seal",
				text = {
					"{C:attention}Each effect{} has a",
					"{C:green}#1# in #2#{} chance",
					"to be given",
					"when played",
				}
			},
			payasaka_randomeffects = {
				name = "Effects:",
				text = {
					"{C:money}$#1#{}",
					"{X:chips,C:white}X#2#{} Chips",
					"{X:mult,C:white}X#3#{} Mult"
				},
			},
			payasaka_randomeffects_talisman = {
				name = "Effects",
				text = {
					"{C:money}$#1#{}",
					"{X:chips,C:white}X#2#{} Chips",
					"{X:mult,C:white}X#3#{} Mult",
					"{X:dark_edition,C:white}^#4#{} Chips",
					"{X:dark_edition,C:white}^#5#{} Mult"
				},
			},
			payasaka_doodlekosmos_evolution = {
				name = "Evolution",
				text = {
					"Each evolution adds",
					"{C:attention}1{} additional",
					"arrow to {C:dark_edition}Mult",
					"and decreases {C:green}odds",
					"of evolving",
					"{C:inactive,s:0.8}tetration -> pentation ->",
					"{C:inactive,s:0.8}hyper-6 -> hyper-7, etc.",
				},
			}
		},
		Sleeve = {
			sleeve_payasaka_gambling = {
				name = "Gambling Sleeve",
				text = {
					"Can {C:attention}reroll{} Booster Packs",
					"in the {C:green}shop",
					"{C:inactive,s:0.8}Does not work on MacOS",
				},
			},
		},
		Seal = {
			payasaka_random = {
				name = "Random Seal",
				text = {
					"{C:attention}Each effect{} has a",
					"{C:green}#1# in #2#{} chance",
					"to be given",
					"when played",
				}
			}
		},
		PTAOptions = {
			option_balanced = {
				name = "Balanced",
				text = {
					"{E:2,C:edition}Not functional yet!"
				}
			},
			option_property_cards = {
				name = "Property Cards",
				text = {
					"Toggles Property Cards",
					"They're from Monopoly!",
					"Who {E:1,C:white}doesn't{} like Monopoly?",
					"{C:inactive,s:0.8}(Requires a restart)"
				}
			},
			option_crossmod = {
				name = "Cross-Mod Content",
				text = {
					"Toggles Cross-Mod content",
					"with {C:dark_edition}Cryptid{}, {C:edition}Revo's Vault",
					"and possibly more",
					"{C:inactive,s:0.8}(Requires a restart)"
				}
			},
			option_music = {
				name = "Music",
				text = {
					"Toggles custom music",
					"tracks for specific occassions",
					"{C:inactive,s:0.8}(Currently only Property booster packs)"
				}
			},
			option_wittycomments = {
				name = "Witty Comments",
				text = {
					"Toggles additional comments",
					"for specific cards",
					"(mostly Jokers)"
				}
			}
		},
		PTACredits = {
			credit_haya = {
				name = "haya3218",
				text = {
					"Made {C:attention}almost{} everything",
					"Don't take my word for it"
				}
			},
			credit_ari = {
				name = "ariyi",
				text = {
					"Some cool ideas",
					"Most other art",
				}
			},
			credit_aikoyori = {
				name = "Aikoyori",
				text = {
					"Emotional support :-)",
					"some art",
				}
			},
			credit_airrice = {
				name = "AirRice",
				text = {
					"Balatro theme MIDI",
					"used for Property Cards"
				}
			},
			credit_canichat = {
				name = "canichatandobserve",
				text = {
					"Original progenitor",
					"of the 'Ahead' joke"
				}
			},
			credit_notmario = {
				name = "notmario",
				text = {
					"Art for Triahead",
					":]"
				}
			}
		}
	},
	misc = {
		dictionary = {
			k_property = "Property",
			b_property_cards = "Property Cards",
			k_doscard = "DOS",
			b_doscard_cards = "DOS Cards",
			k_risk = "Risk",
			b_risk_cards = "Risk Cards",
			k_reward = "Reward",
			b_reward_cards = "Reward Cards",
			k_property_pack = "Property Pack",
			k_moji_pack = "Reward Pack",
			k_risk_pack = "Risk Pack",
			k_legendary_pack = "Legendary Pack",
			b_payasaka_reroll = "Reroll",
			k_payasaka_comment = "Paya's comment:",
			k_payasaka_ahead = "Ahead",
			k_payasaka_daeha = "Prismatic",
			k_payasaka_pyroxene_bonus = "Pyroxene drop",
			b_payasaka_dos_switch = "SWITCH",
			k_payasaka_active = "active",
			k_payasaka_ready = "ready",
			k_payasaka_inactive = "inactive",
			ph_bought_risks = "Risk cards bought this ante",
			ph_no_risk = "No risk cards bought this ante",
			-- #region Jokers
			k_payasaka_monster_sip = "Sip...",
			k_payasaka_phil_fail = "Aww...",
			k_payasaka_lucky_ex = "Lucky!",
			k_payasaka_bas_degrade = "Augh...",
			k_payasaka_bas_eaten = "Don't do this.",
			k_payasaka_reading_ex = "Reading...",
			k_payasaka_added_ex = "Added!",
			k_payasaka_teehee_ex = "Teehee!",
			k_payasaka_nil_ex = "nil",
			k_payasaka_enotsworra_change = "???",
			k_payasaka_hyperactive_ex = "Hyperactive!",
			k_payasaka_inactive_ex = "Inactive!",
			k_payasaka_saved_ex = "Saved!",
			k_payasaka_loaded_ex = "Loaded!",
			k_payasaka_hehe_ex = "Future!",
			k_payasaka_dusty_ex = "Dusty!",
			k_payasaka_blown_ex = "Blown!",
			-- #endregion
		},
		v_dictionary = {
			pta_art_credit = { "Art: #1#" },
			pta_idea_credit = { "Idea: #1#" },
			a_tallymult = "&#1# Mult",
			a_whatchips = "#1# Chips",
		},
		labels = {
			payasaka_jpeg = 'YCbCr',
			payasaka_checkered = 'Checkered',
			payasaka_random_seal = "Random Seal",
			k_payasaka_ahead = "Ahead",
			k_payasaka_daeha = "Prismatic",
		},
		challenge_names = {
			c_payasaka_stuckrock = "Stuck between a Rock and a Hard Place"
		},
		hardcore_challenge_names = {
			hc_payasaka_ultrastuckrock = "Trains vs. Jimbo"
		},
	},
	labels = {
		property = "Property",
		doscard = "DOS",
		risk = "Risk",
	},
}
