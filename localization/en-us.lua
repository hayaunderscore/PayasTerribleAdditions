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
			b_payasaka_gacha = {
				name = "Gacha Deck",
				text = {
					"Jokers and Buffoon Packs can no",
					"longer {C:attention}appear{} in the shop",
					"Get {C:blue}¥5{} every round",
					"Start with a {C:attention,T:c_payasaka_gacha}Gacha{} spectral",
					"at the start of an ante",
					"{C:attention}+#1#{} Joker slots",
					"{C:inactive,s:0.8}Is this even fair?"
				}
			},
			b_payasaka_erraticerraticerratic = {
				name = "Chaos Deck",
				text = {
					"Playing cards' {C:attention}Rank{} and {C:attention}Suit{}",
					"are randomized when drawn",
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
					"{C:diamonds}Diamonds{} or {C:hearts}Hearts{} scored",
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
					"Gives {X:mult,C:white}X#1#{} Mult",
					"if {C:green,E:2}Arona{} is around",
					"Gains {X:mult,C:white}X#2#{} for every",
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
					"Selecting a blind moves this",
					"Joker to the {C:attention}far-right{} and",
					"{C:red}nil{}-ifies Jokers passed through",
					"This Joker gains {X:chips,C:white}X#1#{} Chips for",
					"every Joker {C:attention}replaced{} this way",
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
					"{X:mult,C:white}X#1#{} Blind Size for {X:mult,C:white}X#2#{} Mult",
					"Mult decreases by {X:mult,C:white}X#3#{} at the",
					"{C:attention}end{} of round and {C:red}self destructs",
					"if XMult goes below {X:mult,C:white}X1"
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
					"adds it to the {C:attention}scoring hand",
					"{C:inactive}(Max of #2#)"
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
					"{C:green}#1# in #2#{} chance of",
					"changing the {C:attention}operator",
					"from {C:red}X{} to {C:white,X:dark_edition}^{} upon",
					"selecting a blind",
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
					"{C:attention}Debuffed{} cards,",
					"Jokers and consumables",
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
					"Other {C:chips}Chip{} or {C:chips}Ahead{} Jokers",
					"each give {X:dark_edition,C:white}^(#1#*n)+1{} Chips",
					"{C:attention}n{} is Ahead count {C:inactive}[#2#]",
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
				name = "{f:payasaka_pokemon}MISSINGNO.",
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
			j_payasaka_smoker = {
				name = "Smoker",
				text = {
					"Discarding {C:attention}#1#{} cards",
					"draws {C:attention}#2#{} more"
				}
			},
			j_payasaka_suittaker = {
				name = "Lady",
				text = {
					"Debuffs cards with",
					"{V:1}#2#{} suit, {C:attention}held",
					"debuffed cards each",
					"give {X:mult,C:white}X#1#{} Mult",
					"{C:inactive,s:0.8}Suit changes every round"
				}
			},
			j_payasaka_catcher = {
				name = "Claw Catcher",
				text = {
					"{C:attention}+#1#{} consumable slot",
					"{C:attention}Creates{} a random",
					"consumable at the",
					"end of round",
					"{C:inactive}(Must have room)"
				}
			},
			j_payasaka_patrick = {
				name = "Lucky",
				text = {
					"{X:mult,C:white}X#1#{} Mult for {C:attention}every",
					"{C:risk}Risk{} card used in",
					"this {C:attention}run, creates",
					"{C:attention}#2#{} {C:risk}Risk{} card at",
					"the end of an {C:attention}ante",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)"
				}
			},
			j_payasaka_jackpot = {
				name = "Jackpot Joker",
				text = {
					"{C:attention}Aces{}, {C:attention}7s{}, {C:attention}5s{}",
					"{C:attention}3s{} and {C:attention}2s{} give {X:attention,C:white}X#1#{}",
					"their {C:attention}chip value{} as money",
					"{C:inactive}(Max of {C:money}$#2#{C:inactive})"
				}
			},
			j_payasaka_miscommunication = {
				name = "Miscommunication",
				text = {
					"When entering a blind,",
					"{C:green}#1# in #2#{} chance of",
					"guaranteeing any {C:attention}probability",
					"until end of round"
				}
			},
			j_payasaka_lab01 = {
				name = "LAB=01",
				text = {
					"Mimics {C:attention}2{} random",
					"{C:blue}Common{} or {C:green}Uncommon",
					"Jokers upon setting",
					"a blind, lasts",
					"until end of round",
					"{C:inactive}[1]: #1#",
					"{C:inactive}[2]: #2#",
				}
			},
			j_payasaka_droptarget = {
				name = "Drop Target",
				text = {
					"This Joker gains {C:blue}+#1#{} chips",
					"when a played card gets",
					"a {C:green}#2# in #3#{} chance to be",
					"sent back to the deck",
					"{C:inactive}(Currently {C:blue}+#4#{C:inactive} Chips)"
				}
			},
			j_payasaka_butcher = {
				name = "Butcher Vanity",
				text = {
					"When a blind is selected,",
					"gain {X:mult,C:white}X#1#{} Mult and {C:attention}destroy{}",
					"a random {C:attention}Food{} Joker",
					"{C:red,E:1}Self destructs{} if there",
					"are no Food Jokers",
					"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
				},
			},
			j_payasaka_diver = {
				name = "Deep Deck Diver",
				text = {
					"Each discard costs {C:money}$#1#",
					"when discarding {C:attention}without",
					"any discards left",
					"Cost {C:attention}doubles{} for every",
					"discard done this way",
					"{C:inactive}Resets at the end of ante"
				}
			},
			j_payasaka_livefast = {
				name = "Live Fast",
				text = {
					"{C:mult}+#1#{} Mult",
					"Creates and uses",
					"{C:attention}#2#{} Risk cards",
					"when selecting a",
					"boss blind"
				}
			},
			j_payasaka_freetoplay = {
				name = "F2P Model",
				text = {
					"Gains {X:mult,C:white}X#1#{} Mult when a",
					"non {C:attention}Dud{} Joker is picked",
					"in a {C:spectral}Gacha{} card",
					"{C:green}#2# in #3#{} chance of creating",
					"a {C:spectral}Gacha{} card at the",
					"end of round",
					"{C:inactive,s:0.8}Can spawn Duds in Gacha cards",
					"{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult)"
				}
			},
			j_payasaka_dud = {
				name = "{f:5}薬子サヤ",
				text = {
					"{C:mult}+#1#{} Mult",
					"{C:dark_edition}+#2#{} Joker slot",
					"{C:inactive,s:0.8,f:5}あなたは不発弾を手に入れた！"
				}
			},
			j_payasaka_cast = {
				name = "Cast",
				text = {
					"Mimics {C:attention}2{} random {C:red}Showdown{}",
					"Jokers when selecting a blind",
					"Resets when exiting the shop",
					"{C:inactive}Joker values are kept",
					"{C:inactive}[1]: #1#",
					"{C:inactive}[2]: #2#",
				}
			},
			j_payasaka_4byte = {
				name = "Four-Byte Burger",
				text = {
					"This Joker gains {X:mult,C:white}X#1#{} Mult",
					"for each {C:attention}unique{} {C:enhanced}Food{} Joker",
					"taken in this run",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
				}
			},
			j_payasaka_desperado = {
				name = "Fulminologist",
				text = {
					"Shop has an {C:attention}additional",
					"{C:risk}Risk{} Pack for half the price",
				}
			},
			j_payasaka_sissel = {
				name = "Spirit Ploy",
				text = {
					"{C:attention}Triggers{} a random scored",
					"card during scoring"
				}
			},
			j_payasaka_prosopagnosia = {
				name = "Prosopagnosia",
				text = {
					"{C:attention}Aces{} also count as",
					"{C:attention}all{} face cards"
				}
			},
			j_payasaka_yomiel = {
				name = "Yomiel",
				text = {
					"{C:attention}Triggers{} a random",
					"Joker during scoring"
				}
			},
			j_payasaka_iroyokia = {
				name = "{f:payasaka_reversed}iroyokiA",
				text = {
					{
						"Prevents {C:red}death{} by",
						"{C:attention}restoring{} your deck,",
						"hands and discards",
					},
					{
						"Mimics {C:dark_edition}Aikoyori{} if",
						"it is present"
					}
				}
			},
			j_payasaka_documentation = {
				name = "Documentation",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"Only the first line of",
					"any description is shown"
				}
			},
			j_payasaka_tablecount = {
				name = "print(table.maxn(table))",
				text = {
					"{X:mult,C:white}X#1#{} Mult and {X:chips,C:white}X#2#{} Chips if",
					"played hand contains exactly",
					"{C:inactive}#3#{} cards",
					"{C:inactive,s:0.8}The count value, that is.",
					"{C:inactive,s:0.8}Values are randomized each round",
					"{C:inactive,s:0.8}Figure it out :]",
				}
			},
			j_payasaka_upgraded = {
				name = "Upgraded Joker",
				text = {
					"{X:mult,C:white}X#1#{} Mult"
				}
			},
			j_payasaka_sweetrock = {
				name = "Sweet Rock",
				text = {
					"{C:green}#1# in #2#{} chance of",
					"scoring a {C:attention}random{}",
					"card held in hand",
					"{C:inactive}THIS... IS ROCK."
				}
			},
			j_payasaka_EVILgarb = {
				name = "EVIL garb,,,",
				text = {
					"On {C:attention}first hand{} of round,",
					"all listed probabilities are",
					"{C:red}nullified"
				}
			},
			j_payasaka_johnmadden = {
				name = "Ask Madden",
				text = {
					"When drawing from the deck,",
					"this Joker selects a specific",
					"card on your hand, {C:attention}playing",
					"this card gives {C:chips}+#1#{} Chips",
					"and {C:mult}+#2#{} Mult",
					"{C:inactive}This uses DECTalk!{}"
				}
			},
			j_payasaka_manifold_mayhem = {
				name = "Manifold Mayhem",
				text = {
					"This Joker's XMult is based",
					"on {C:attention}collective{} Small and Big",
					"Blind score {C:attention}surplus ratio{}",
					"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
				}
			},
			j_payasaka_sweet_sleep = {
				name = "Sweet Sleep",
				text = {
					"{X:chips,C:white}X#1#{} Chips per scored",
					"card on the {C:attention}first{} hand",
					"Gains {X:chips,C:white}X#2#{} Chips",
					"per {C:attention}discarded{} card",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}It's best to unleash it all",
					"{C:inactive,s:0.8}on the first hand, right?",
					" ",
					"{C:inactive,s:0.8}Right?",
				}
			},
			j_payasaka_halfmoon = {
				name = "Half Moon Cookie",
				text = {
					"Levels up the played",
					"hand by {C:attention}#1#{} for the",
					"next {C:attention}#2#{} hands",
				}
			},
			j_payasaka_jellybeans = {
				name = "Jellybeans",
				text = {
					"The next {C:attention}#1#{} played cards",
					"get a {C:attention}random{} edition",
				}
			},
			j_payasaka_deviouslamp = {
				name = "Devious Lamp",
				text = {
					"Scored cards' values are",
					"{C:attention}multiplied{} by {X:attention,C:white}X#1#{} for the",
					"{C:attention}winning hand{} of the blind"
				}
			},
			j_payasaka_azusa = {
				name = "Azusa Miura",
				text = {
					"This Joker gains {X:mult,C:white}X#1#{} Mult",
					"if scored hand {C:attention}contains{}",
					"a {C:attention}7{}, {C:attention}6{} and {C:attention}5{}",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
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
				name = 'Prelude Blind',
				text = {
					"The calm before",
					"the storm..."
				}
			},
			bl_payasaka_showdown_manifold_mayhem = {
				name = 'Manifold Mayhem',
				text = {
					"Very variable blind"
				}
			},
			bl_payasaka_showdown_sweet_sleep = {
				name = 'Sweet Sleep',
				text = {
					"Score naneinf 10 times",
					"...or don't!"
				}
			},
			bl_payasaka_showdown_sweet_sleep_alt = {
				name = 'Sweet Sleep',
				text = {
					"Multiplies chips by X#1#",
					"if current chips does not",
					"meet the blind requirement"
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
			dd_payasaka_property_card = { name = "Property", text = { "Get {C:money}$#1#{} upon beating", "the Boss Blind", "Resets back to {C:money}$#2#{}", "after cashing out", "{C:inactive,s:0.8}Houses add additional", "{C:attention,s:0.8}sell value", "{C:inactive,s:0.8}Hotels are equivalent{}", "{C:inactive,s:0.8}to 5 houses{}" } },
			dd_payasaka_ahead = {
				name = "Ahead",
				text = {
					"This card is feeling",
					"rather {C:blue}pointy"
				}
			},
			dd_payasaka_risk = {
				name = "Risk Card",
				text = {
					"Effects are only applied",
					"{C:attention}during{} the boss blind",
					"{C:inactive,s:0.9}(Reward: {C:dark_edition,s:0.9}#1#{C:inactive,s:0.9})"
				}
			},
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
			},
			dd_payasaka_manifold_limiter = {
				name = "No Cryptid?",
				text = {
					"Max of {X:mult,C:white}X#1#",
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
					"random {C:property}Property{} cards",
					"in your consumables",
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
					"Adds {C:dark_edition}Eternal{} to",
					"selected Joker",
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
					"a {C:ayasaka_prismatic_gradient}Prismatic{} Joker and",
					"turn {C:attention}all{} other Jokers into",
					"ones of the same {C:attention}rarity{}"
				}
			},
			c_payasaka_gacha = {
				name = "Gacha",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:joker} {C:attention,E:1}random{} {C:joker}Jokers{}",
					"{C:inactive,s:0.8}9B, 1G :){}"
				},
			},
			c_payasaka_niyaniya = {
				name = 'Niyaniya',
				text = {
					"Sell value increases",
					"by {C:money}$#2#{} every round",
					"{C:inactive,s:0.8}Does nothing..?",
					"{C:inactive,s:0.8}Does not reset",
				}
			},
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
					"{X:attention,C:white}÷#1#{} poker",
					"hand levels",
				}
			},
			c_payasaka_stunted = {
				name = "Stunted",
				text = {
					"Played {C:attention}Enhanced{} cards have a",
					"{C:green}#1# in #2#{} chance of not {C:attention}activating",
				}
			},
			c_payasaka_crime = {
				name = "Crime",
				text = {
					"{C:red}-#1#{} hand size",
				}
			},
			c_payasaka_hinder = {
				name = "Hinder",
				text = {
					"{C:attention}Debuff{} {C:attention}#1#{} random",
					"cards in your deck",
				}
			},
			c_payasaka_hollow = {
				name = "Hollow",
				text = {
					"{C:attention}Debuff{} all consumables",
				}
			},
			c_payasaka_leak = {
				name = "Leak",
				text = {
					"Lose {C:money}$#1#{} per",
					"{C:attention}scored{} card"
				}
			},
			c_payasaka_elysium = {
				name = "Elysium",
				text = {
					"{C:attention}Debuff{} the {C:attention}rightmost",
					"and {C:attention}leftmost{} Joker",
				}
			},
			c_payasaka_elusive = {
				name = "Elusive",
				text = {
					"{C:attention}First{} drawn card",
					"is faced down",
					"Held cards are",
					"flipped after playing"
				}
			},
			c_payasaka_prelude = {
				name = "Prelude",
				text = {
					"{C:attention}Encounter{} a",
					"{C:attention}Prelude Blind"
				}
			},
			c_payasaka_shrink = {
				name = "Shrink",
				text = {
					"Scored cards give",
					"{C:attention}half{} its chip value",
				},
			},
			c_payasaka_genesis = {
				name = "Genesis",
				text = {
					"Adds {C:attention}#1#{} random basic",
					"cards to your deck",
				},
			},
			c_payasaka_burden = {
				name = "Burden",
				text = {
					"Adds {C:purple}Eternal{} to",
					"a random Joker",
				},
			},
			c_payasaka_ethereal = {
				name = "Ethereal",
				text = {
					"Adds {C:purple}Perishable{} to",
					"a random Joker",
				},
			},
			c_payasaka_cyclone = {
				name = "Cyclone",
				text = {
					"Held cards are {C:attention}shuffled",
					"back into the deck",
				},
			},
			c_payasaka_perpetuate = {
				name = "Perpetuate",
				text = {
					"Discarded cards {C:attention}return",
					"back into the deck",
				},
			},
			c_payasaka_backfire = {
				name = "Backfire",
				text = {
					"{C:green}#1# in #2#{} chance of",
					"reversing Joker order",
					"when hand is played",
				},
			},
			c_payasaka_flow = {
				name = "Flow",
				text = {
					"Held cards are {C:attention}debuffed",
					"after playing a hand",
				},
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
				name = "Align",
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
					"Give up to {C:attention}#1#{} cards",
					"a {C:attention}random{} edition,",
					"enhancement or seal",
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
					"Creates a random",
					"{C:dark_edition}Negative{} Joker",
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
				name = "{f:payasaka_pokemon}TMTRAINER",
				text = {
					"",
				}
			},
			v_payasaka_cooltrainer = {
				name = "{f:payasaka_pokemon}CoolTrainer♀",
				text = {
					"",
				}
			},
			v_payasaka_friends = {
				name = "Friends of Jimbo",
				text = {
					"Modded Jokers appear",
					"{C:attention}#1#%{} more frequently",
					"in the shop"
				}
			},
			v_payasaka_crash = {
				name = "Crash Log",
				text = {
					"{C:red}Rare{} and {C:legendary}Legendary{} Jokers",
					"appear {C:attention}#1#%{} and {C:attention}#2#%{}",
					"more frequently in the",
					"shop respectively"
				}
			},
			v_payasaka_equilibrium = {
				name = "Equilibrium",
				text = {
					"All Jokers have the",
					"{C:attention}same chance{} of",
					"appearing in the shop",
				}
			},
			v_payasaka_parakmi = {
				name = "Decline",
				text = {
					"{C:attention}Anything{} can appear in",
					"the place of {C:attention}any{} card",
					"{C:inactive}So entropic...",
					"{C:inactive,s:0.8}(Jokers, Consumeables,",
					"{C:inactive,s:0.8}Decks and even Sleeves!)",
				}
			},
		},
		Property = {
			c_payasaka_brownproperty = {
				name = 'Joker Avenue',
				text = {
					"Sell value increases",
					"by {C:money}$#2#{} if played hand",
					"is a {C:attention}#3#{}",
					"{C:inactive}Does nothing.",
				}
			},
			c_payasaka_blueproperty = {
				name = 'Jest Road',
				text = {
					"Sell value increases",
					"by {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"Randomizes the {C:dark_edition}edition{}",
					"of up to {C:attention}#4#{} selected",
					"cards when used",
				}
			},
			c_payasaka_pinkproperty = {
				name = 'Comic Mall',
				text = {
					"Sell value increases",
					"by {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"Creates {C:attention}#4#{} Food",
					"Jokers when used",
				}
			},
			c_payasaka_orangeproperty = {
				name = 'Droll Street',
				text = {
					"Sell value increases",
					"by {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"Creates {C:attention}#4#{} {C:tarot}Tarot{}",
					"cards when used",
					--"{C:inactive,s:0.8}(Must have room)",
				}
			},
			c_payasaka_redproperty = {
				name = 'Virtue Square',
				text = {
					"Sell value increases",
					"by {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"Creates a {C:red}Rare{}",
					"Joker when used",
					--"{C:inactive,s:0.8}(Must have room)",
				}
			},
			c_payasaka_yellowproperty = {
				name = 'Leicester Square',
				text = {
					"Sell value increases",
					"by {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"Levels up your {C:attention}most{}",
					"{C:attention}played{} hand by {C:attention}#4#{}",
					"levels when used",
				}
			},
			c_payasaka_greenproperty = {
				name = 'Wit Street',
				text = {
					"Sell value increases",
					"by {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"Creates a {C:dark_edition}Legendary{}",
					"Joker when used",
					--"{C:inactive,s:0.8}(Must have room)",
				}
			},
			c_payasaka_darkblueproperty = {
				name = 'Mayfair',
				text = {
					"Sell value increases",
					"by {C:money}$#2#{} if played hand",
					"contains a {C:attention}#3#{}",
					"{C:inactive,s:0.8}Does nothing..?",
				}
			},
		},
		Colour = {
			c_payasaka_mfc_maroon = {
				name = "Maroon",
				text = {
					"Create and use a",
					"random {C:risk}Risk{} card for",
					"every {C:attention}#4#{} rounds",
					"this has been held",
					"{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
				}
			},
			c_payasaka_mfc_lightblue = {
				name = "Light Blue",
				text = {
					"Create a {C:dark_edition}Negative{}",
					"{C:reward}Reward{} card for",
					"every {C:attention}#4#{} rounds",
					"this has been held",
					"{X:attention,C:white}X#5#{} Blind size",
					"{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
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
			undiscovered_doscard = {
				name = "Not Discovered",
				text = {
					"Purchase or use",
					"this card in an",
					"unseeded run to",
					"learn what it does"
				}
			},
			undiscovered_risk = {
				name = "Not Discovered",
				text = {
					"Purchase or use",
					"this card in an",
					"unseeded run to",
					"learn what it does"
				}
			},
			undiscovered_reward = {
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
			sleeve_payasaka_gambling_alt = {
				name = "Inaccurate Gacha Sleeve",
				text = {
					"Can {C:attention}reroll{} Booster Packs",
					"in the {C:green}shop",
					"Gacha weights are {C:dark_edition}nonexistent",
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
		PTASet = {
			ptaset_payasaka_ahead = {
				name = "Ahead Jokers",
				text = {
					"Meme rarity that focuses on",
					"{X:chips,C:white}XChips{}, {C:spades}Spades{} or both",
					"{C:inactive,s:0.8}Intentionally unbalanced."
				}
			},
			ptaset_payasaka_property = {
				name = "Property Cards",
				text = {
					"Consumables that focus",
					"on {C:money}econ{} generation",
					"{C:inactive,s:0.8}Under construction."
				}
			},
			ptaset_payasaka_risk = {
				name = "Risk Cards",
				text = {
					"Consumables that implement",
					"a {C:risk}Risk{} and {C:reward}Reward{} system",
					"{C:inactive}Risks give Rewards.",
					"{C:inactive,s:0.8}Under construction."
				}
			},
			ptaset_payasaka_crossmod = {
				name = "Cross-Mod Content",
				text = {
					"Cross-mod content featuring",
					"{C:attention}additional{} content for Cryptid,",
					"Revo's Vault, Ortalab, Finity",
					"and more!"
				}
			},
			ptaset_payasaka_music = {
				name = "\"Soundtrack\"",
				text = {
					"Additional music for specific",
					"areas throughout the mod",
				}
			},
			ptaset_payasaka_comments = {
				name = "Witty Comments",
				text = {
					"Paya's thoughts on",
					"things... Probably."
				}
			},
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
			},
			credit_missingnumber = {
				name = "missingnumber",
				text = {
					"Art and inspiration for",
					"{f:payasaka_pokemon}MISSINGNO."
				}
			},
			credit_loggers = {
				name = "Mr. Logan",
				text = {
					"Additional art",
					"and ideas"
				}
			}
		}
	},
	misc = {
		quips = {
			lq_question_1 = {
				"Quite, quite",
				"unfortunate!"
			},
			lq_question_2 = {
				"Going back to your",
				"Cryptid hide-hole?"
			},
			lq_question_3 = {
				"Had The Plant as",
				"one of the fused?"
			},
			lq_question_4 = {
				"All that's left of",
				"you is dust...",
				"and your skull."
			},
			lq_m_1 = {
				"Interesting...",
			},
			lq_m_2 = {
				"Very, very",
				"interesting..."
			},
			lq_m_3 = {
				"ZZAZZAZZAZAZZAZ",
				"ZAZZZAZAZAZZAZA"
			},
			lq_m_4 = {
				"______",
				"{f:payasaka_pokemon}TYPE",
				"{f:payasaka_pokemon}CoolTrainer♀"
			},
		},
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
			k_gacha_pack = "Gacha Pack",
			k_legendary_pack = "Legendary Pack",
			b_payasaka_reroll = "Reroll",
			k_payasaka_comment = "Paya's comment:",
			k_payasaka_ahead = "Ahead",
			k_payasaka_daeha = "Prismatic",
			k_payasaka_dud = "Dud",
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
			c_payasaka_stuckrock = "Stuck between a Rock and a Hard Place",
			c_payasaka_freeticket = "Eternal Ticket to Hell"
		},
		hardcore_challenge_names = {
			hc_payasaka_ultrastuckrock = "Trains vs. Jimbo",
			hc_payasaka_finityfreeticket = "Finite Ticket to Limbo"
		},
	},
	labels = {
		property = "Property",
		doscard = "DOS",
		risk = "Risk",
		back = "Deck",
	},
}
