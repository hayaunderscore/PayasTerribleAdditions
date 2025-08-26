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
				name = "Thrillseeker Deck",
				text = {
					"Only {C:red}Risk{} cards,",
					"vouchers and Booster Packs",
					"can {C:attention}appear{} in the shop",
					"{C:inactive,s:0.8}Buffoon Packs are still permitted!"
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
			b_payasaka_prismatic = {
				name = "Prismatic Deck",
				text = {
					"Start with a random",
					"{C:payasaka_prismatic_gradient}Prismatic{} Joker",
				}
			},
			b_payasaka_dummy = {
				name = "Test Deck?",
				text = {
					"If you somehow got this,",
					"{C:payasaka_prismatic_gradient,E:1}congratulations!{}",
					"Have a carrot."
				}
			},
			b_payasaka_sticker = {
				name = "Sticker Deck",
				text = {
					"Start with an {C:attention,T:v_overstock_norm}#1#",
					"and a {C:dark_edition,T:c_payasaka_purify}#2# card",
					"Jokers can have {C:attention}stickers",
					"Stakes {C:attention}increase{} chance for their",
					"{C:attention}respective{} sticker"
				}
			},
			b_payasaka_back = {
				name = "Deck in a Deck in a Deck",
				text = {
					"{C:attention}Decks{} are {C:attention}available",
					"in the shop",
					"{C:inactive}Isn't this just Parakmi?"
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
				name = "Nostalgic Phil",
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
				name = {
					"{f:5}アロナ",
					"{C:edition,s:0.5}Arona"
				},
				text = {
					{
						"{C:inactive,s:0.8}If Plana is not around:",
						"{X:chips,C:white}X#1#{} Chips {C:inactive,s:0.8}:<{}",
					},
					{
						"{C:inactive,s:0.8}If Plana is around:",
						"Gains {X:chips,C:white}X#3#{} Chips for every",
						"{C:diamonds}Diamonds{} or {C:hearts}Hearts{} scored",
						"{C:inactive}(Currently {X:chips,C:white}X#2#{C:inactive} Chips)"
					},
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}stop stealing my fucking chips",
				}
			},
			j_payasaka_plana = {
				name = {
					"{f:5}プラナ",
					"{C:edition,s:0.5}Plana"
				},
				text = {
					{
						"{C:inactive,s:0.8}Default effect:",
						"{C:green}#3# in #4#{} chance to",
						"create a random {C:dark_edition}Negative",
						"{C:spectral}Spectral{} card every round",
					},
					{
						"{C:inactive,s:0.8}If Arona is around:",
						"Gains {X:mult,C:white}X#2#{} Mult for every",
						"{C:spades}Spades{} or {C:clubs}Clubs{} scored",
						"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
					},
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}now THIS this is a good one",
				}
			},
			j_payasaka_flintnsteel2 = {
				name = "Flint and Steel 2",
				text = {
					"This Joker gains {C:mult}+#1#{} Mult for",
					"each pair {C:attention}containing{} one {C:payasaka_suit_light}light{}",
					"suit and one {C:payasaka_suit_dark}dark{} suit",
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
					{
						"Played {C:spades}Spade{} cards",
						"give {X:chips,C:white}X#2#{} Chips",
					},
					{
						"This Joker gains {X:chips,C:white}X#1#",
						"Chips when a {C:attention}Face{} card",
						"with {C:spades}Spade{} suit is {C:attention}scored"
					}
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
				name = {
					"{f:5}ヨニ早坂",
					"{C:edition,s:0.5}Yonii \"Paya\" Hayasaka"
				},
				text = {
					"Adds a new {C:attention}scoring value",
					"based on the {C:attention}average{} of",
					"your chips and mult",
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
					"{B:1,V:2}#2##1#{} Chips?           ",
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
					"Each {C:attention}Queen{} held in",
					"hand gives {X:chips,C:white} X#1# {} Chips",
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
					{
						"Copies ability of",
						"{C:attention}Joker(s){} to the right",
					},
					{
						"Number of Jokers copied",
						"is tied to {C:attention}currently owned{}",
						"Ahead Joker count {C:inactive}[#1#]"
					}
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}wtf"
				}
			},
			j_payasaka_aheadstorm = {
				name = "Aheadstorm",
				text = {
					{
						"Copies the ability",
						"of leftmost {C:attention}Joker",
					},
					{
						"Number of times copied",
						"is tied to {C:attention}currently owned{}",
						"Ahead Joker count {C:inactive}[#1#]"
					}
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
				payasaka_comment = {
					"{C:inactive,s:0.8}She's playable now atleast"
				}
			},
			j_payasaka_cartridge = {
				name = 'Cartridge Joker',
				text = {
					"{X:mult,C:white}X#1#{} Mult with a",
					"{C:green}#2# in #3#{} chance of {C:attention}debuffing",
					"itself for an entire round"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}That's right we're gonna cheat"
				}
			},
			j_payasaka_no_retrigger = {
				name = 'Aww! No Retriggers',
				text = {
					"{C:dark_edition,E:1}Nullifies{} retriggers and",
					"replaces them with XMult,",
					"XChips, or money {C:attention}corresponding{}",
					"to its repetition {C:attention}value{}",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}For Canvas scaling."
				}
			},
			j_payasaka_joker_lua = {
				name = "{f:payasaka_FiraCode}joker.lua",
				text = {
					"{X:mult,C:white}X#1#{} Mult for every",
					"lua file {C:attention}required/loaded",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}How many mods you got",
					"{C:inactive,s:0.8}loaded bud????"
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Im recuperaring it"
				}
			},
			j_payasaka_fanhead = {
				name = "Fanhead",
				text = {
					"Other {C:chips}Chip{} or {C:chips}Ahead{} Jokers",
					"each give {X:dark_edition,C:white}^(#1#*n)+1{} Chips",
					"{C:attention}n{} is Ahead count {C:inactive}[#2#]",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}the only zzz reference",
					"{C:inactive,s:0.8}im ever adding"
				}
			},
			j_payasaka_scrapped = {
				name = "Scrapped",
				text = {
					"Held cards {C:attention}later",
					"give {X:chips,C:white}X#1#{} Chips",
					"when {C:attention}played"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}She still is..."
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}You should play Finity",
					"{C:inactive,s:0.8}Not sponsored"
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
				payasaka_comment = {
					"{C:inactive,s:0.8}Operation Soda Steal"
				}
			},
			j_payasaka_photobinder = {
				name = "Photobinder",
				text = {
					"{C:attention}Multiplies{} the effects",
					"of leftmost and rightmost",
					"Jokers by {X:attention,C:white}X#1#",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Does not affect other Photobinder{}",
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
					"{C:inactive,s:0.8}:sob:",
				}
			},
			j_payasaka_smoker = {
				name = "Smoker",
				text = {
					"Discarding {C:attention}#1#{} cards",
					"draws {C:attention}#2#{} more"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Smoke break..."
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Debuff synergy?",
					"{C:inactive,s:0.8}Debuff synergy."
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}AAAAAAAAAAAAAAAAAAAA"
				}
			},
			j_payasaka_patrick = {
				name = "Lucky",
				text = {
					"This Joker gains {X:mult,C:white}X#1#{} Mult",
					"for each {C:risk}Risk{} card {C:attention}used",
					"Creates a {C:risk}Risk{} card after",
					"defeating the {C:attention}boss blind",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Why she smiling at me",
					"{C:inactive,s:0.8}like that"
				}
			},
			j_payasaka_jackpot = {
				name = "Jackpot Joker",
				text = {
					"{C:attention}Aces{}, {C:attention}7s{}, {C:attention}5s{}",
					"{C:attention}3s{} and {C:attention}2s{} give {X:attention,C:white}X#1#{}",
					"their {C:attention}chip value{} as money",
					"{C:inactive}(Max of {C:money}$#2#{C:inactive})"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Drats! Foiled again"
				}
			},
			j_payasaka_miscommunication = {
				name = "Miscommunication",
				text = {
					"{C:green}#1# in #2#{} chance of",
					"maxing out {C:green,E:1}probabilities",
					"until end of round"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8,f:5}なんか楽しくなってきた",
					"{C:inactive,s:0.8,f:5}なんか楽しくなっちゃった"
				}
			},
			j_payasaka_lab01 = {
				name = "LAB=01",
				text = {
					"Mimics {C:attention}2{} random {C:blue}Common{}",
					"or {C:green}Uncommon{} Jokers upon",
					"setting a blind, lasts until",
					"the end of round",
					"{C:inactive}[1]: #1#",
					"{C:inactive}[2]: #2#",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8,f:5}磁力の父はゆーつか ゆーつか",
					"{C:inactive,s:0.8,f:5}非力の母はミューズか？ミューズか？"
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Boo!",
					"{C:inactive,s:0.8}Did I scare you?"
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
				payasaka_comment = {
					"{C:inactive,s:0.8}The slaughter's on",
					"{C:inactive,s:0.8}I'd love to see you come undone"
				}
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Im diving it",
				}
			},
			j_payasaka_livefast = {
				name = "Live Fast",
				text = {
					"{C:mult}+#1#{} Mult",
					"Creates and uses {C:attention}#2#{} {C:risk}Risk",
					"Cards when {C:attention}selecting",
					"a boss blind"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Quite a buckshot, ain't it?",
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Free Jokers! Or so it seems",
				}
			},
			j_payasaka_dud = {
				name = {
					"{f:5}薬子サヤ",
					"{C:edition,s:0.5}Yakushi Saya"
				},
				text = {
					"{C:mult}+#1#{} Mult",
					"{C:dark_edition}+#2#{} Joker slot",
					"{C:inactive,s:0.8,f:5}あなたは不発弾を手に入れた！"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}What a fool.",
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}I'm casting it....",
				}
			},
			j_payasaka_4byte = {
				name = "Four-Byte Burger",
				text = {
					"This Joker gains {X:mult,C:white}X#1#{} Mult",
					"for each {C:attention}unique{} {C:enhanced}Food{} Joker",
					"taken in this run",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Pristine restoration",
					"{C:inactive,s:0.8}We got here"
				}
			},
			j_payasaka_desperado = {
				name = "Fulminologist",
				text = {
					"Shop has an {C:attention}additional",
					"{C:risk}Risk{} Pack for half the price",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}I can't think of a joke",
				}
			},
			j_payasaka_sissel = {
				name = "Spirit Ploy",
				text = {
					"{C:attention}Triggers{} a random scored",
					"card during scoring"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}ghost trick !?",
					"{C:inactive,s:0.8}powers of the dead !?"
				}
			},
			j_payasaka_prosopagnosia = {
				name = "Prosopagnosia",
				text = {
					"{C:attention}Aces{} also count as",
					"{C:attention}all{} face cards"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Yes this mod has quantum ranks",
				}
			},
			j_payasaka_yomiel = {
				name = "Yomiel",
				text = {
					"{C:attention}Triggers{} a random",
					"Joker during scoring"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}They said a {C:red,s:0.8,E:2}manipulator",
					"{C:inactive,s:0.8}made an {C:red,s:0.8,E:1}impossible move{C:inactive,s:0.8}..."
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Well this is certainly",
					"{C:inactive,s:0.8}a playbook"
				}
			},
			j_payasaka_documentation = {
				name = "Documentation",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"Only the first line of",
					"any description is shown"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}0/10 Documentation",
					"{C:inactive,s:0.8}come back later"
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Figure it out :]",
				}
			},
			j_payasaka_upgraded = {
				name = "Upgraded Joker",
				text = {
					"{X:mult,C:white}X#1#{} Mult"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}We have the technology.",
				}
			},
			j_payasaka_sweetrock = {
				name = "Sweet Rock",
				text = {
					"{C:green}#1# in #2#{} chance of",
					"scoring a {C:attention}random{}",
					"card held in hand",
					"{C:inactive}THIS... IS ROCK."
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Rock indeed.",
				}
			},
			j_payasaka_EVILgarb = {
				name = "EVIL garb,,,",
				text = {
					"On {C:attention}first hand{} of round,",
					"all listed probabilities",
					"are {C:red,E:1}nullified"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}shes EVIL.....",
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Football!",
				}
			},
			j_payasaka_manifold_mayhem = {
				name = "Manifold Mayhem",
				text = {
					"This Joker's XMult is based",
					"on {C:attention}collective{} Small and Big",
					"Blind score {C:attention}surplus ratio{}",
					"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Big ass multiplier",
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
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}My favorite treat",
				}
			},
			j_payasaka_jellybeans = {
				name = "Jellybeans",
				text = {
					"The next {C:attention}#1#{} played cards",
					"get a {C:attention}random{} edition",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Limited ..... Edition.....",
				}
			},
			j_payasaka_deviouslamp = {
				name = "Devious Lamp",
				text = {
					"Scored cards' values are",
					"{C:attention}multiplied{} by {X:attention,C:white}X#1#{} for the",
					"{C:attention}winning hand{} of the blind"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Good Game Design",
				}
			},
			j_payasaka_azusa = {
				name = {
					"{f:5}三浦あずさ",
					"{C:edition,s:0.5}Miura Azusa"
				},
				text = {
					"This Joker gains {X:mult,C:white}X#1#{} Mult",
					"if scored hand {C:attention}contains{}",
					"a {C:attention}7{}, {C:attention}6{} and {C:attention}5{}",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}'765' is 'NAMCO' btw",
				}
			},
			j_payasaka_irisu = {
				name = {
					"{f:5}入巣京子",
					"{C:edition,s:0.5}Kyouko Irisu"
				},
				text = {
					"{C:red}Destroys{} a random Joker",
					"and takes their {C:attention}abilities",
					"upon setting the blind",
					"{C:inactive,s:0.8}Eternal effects are applicable..."
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Here comes Irisu",
					"{C:inactive,s:0.8}with the nailed bat",
				}
			},
			j_payasaka_shinku = {
				name = "Shonk",
				text = {
					{
						"Creates temporary {C:attention}copies",
						"of played cards after scoring",
					},
					{
						"Copies are {C:attention}destroyed",
						"at the end of round"
					}
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Ortalab tomorrow",
				}
			},
			j_payasaka_sheena = {
				name = "Apple of Universal Gravity",
				text = {
					"Held cards forming a {C:attention}Straight{} from",
					"{C:attention}scored cards{} each give {X:mult,C:white}X#1#{} Mult",
					"{C:inactive,s:0.8}Played cards must already form a Straight{}"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Hopefully they don't sue {C:inactive,s:0.8,f:payasaka_NotoEmoji}🙏",
				}
			},
			j_payasaka_toga_warrior = {
				name = "warrior",
				text = {
					"{C:chips}+#1#{} Chips"
				}
				-- This is intentionally left without a comment.
			},
			j_payasaka_toga_soundtracker = {
				name = "Soundtracker",
				text = {
					"Gives {X:mult,C:white}X#1#{} of poker",
					"hand {C:attention}mult{} as {C:attention}XMult",
					"{C:inactive,s:0.8}(Minimum of 1.)",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Keep on trackin'",
				}
			},
			j_payasaka_onepiece = {
				name = "Five Star Edward Newgate",
				text = {
					"{C:green}#1# in #2#{} chance of leveling up",
					"{C:attention}High Card{} if any other",
					"poker hand is leveled up"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Did you only have",
					"{C:inactive,s:0.8}an Edward Newgate?",
				}
			},
			j_payasaka_phil2 = {
				name = "Phil and Shirt",
				text = {
					{
						"Saves up to {C:attention}#1#{}",
						"selected cards when {C:attention}used",
					},
					{
						"{C:attention}Restores{} saved cards",
						"when {C:attention}used{} again",
						"{C:inactive,s:0.8}(#2#)"
					}
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}when your {X:black,C:white,s:0.8}artist",
					"{C:inactive,s:0.8}is a geek :laugh:",
				}
			},
			j_payasaka_sunglasses = {
				name = "Sunglasses",
				text = {
					"{C:green}#2# in #3#{} chance of",
					"creating {C:attention}#1#{} when a",
					"glass card is {C:attention}scored",
					"{C:inactive}(Must have room)"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}This doesnt make sense",
					"{C:inactive,s:0.8}much outside of the pun",
					"{C:inactive,s:0.8}But that winning smile...!",
				}
			},
			j_payasaka_vash = {
				name = "Vash the Stampede",
				text = {
					"This Joker gains {X:mult,C:white}X#1#{} Mult",
					"or {C:chips}+#2#{} Chips for every",
					"Joker or other card {C:red}destroyed",
					"{C:red,E:1}Prevents card destruction",
					"{C:inactive,s:0.8}(Except food, selling, consumables and itself)",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult and {C:chips}+#4#{C:inactive} Chips)"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}LOVE AND PEACE!",
				}
			},
			j_payasaka_mixnmingle = {
				name = "Mix and Mingle Machine",
				text = {
					{
						"{C:attention}Shuffles{} played cards",
						"before scoring",
					},
					{
						"This Joker gains {X:mult,C:white}X#1#{} Mult",
						"times the amount of steps {C:attention}deviated",
						"per card from its original {C:attention}position{}",
						"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
					}
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}MIX.",
					"{C:inactive,s:0.8}MINGLE.",
				}
			},
			j_payasaka_goldship = {
				name = {
					"{f:5}ゴールドシップ",
					"{C:edition,s:0.5}Gold Ship"
				},
				text = {
					"{C:attention}Retriggers{} scored card",
					"if the card before it",
					"has a lower {C:attention}rank"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Type 'affirm' to",
					"{C:inactive,s:0.8}claim 1000 {f:payasaka_NotoEmoji,C:inactive,s:0.8}🥕",
				}
			},
			j_payasaka_flushtuah = {
				name = "Flush Tuah",
				text = {
					"{X:mult,C:white}X#1#{} Mult if played",
					"hand contains a {C:attention}Pair{}",
					"with {C:attention}matching{} suits"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}spit on that thang",
				}
			},
			j_payasaka_paya_friend = {
				name = "Paya",
				text = {
					"Every played {C:attention}card{}",
					"permanently gains",
					"{C:attention}any{} of the values",
					"listed when scored"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}cracked hiker???",
				}
			},
			j_payasaka_kinghalo = {
				name = {
					"{f:5}キングヘイロー",
					"{C:edition,s:0.5}King Halo"
				},
				text = {
					"Retriggers {C:attention}unscored{} card",
					"effects {C:attention}#1#{} additional times"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Is Playing Balatro",
				}
			},
			j_payasaka_adigail = {
				name = "Adigail",
				text = {
					"Adds double the {C:attention}average{} of",
					"all {C:attention}discovered{} poker hands",
					"to Chips and Mult",
					"{C:inactive,s:0.8}(Does not include secret hands)",
					"{C:inactive,s:0.8}(Currently {C:chips,s:0.8}+#1#{C:inactive,s:0.8} and {C:mult,s:0.8}+#2#{C:inactive,s:0.8})"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}challenpoints.ogg",
				}
			},
			j_payasaka_sa8s = {
				name = "Shucks! All 8s",
				text = {
					"Halves the denominator of",
					"all {C:attention}listed {C:green,E:1,S:1.1}probabilities",
					"{C:inactive}(ex: {C:green}1 in 6{C:inactive} -> {C:green}1 in 3{C:inactive})",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Basically just OA6",
				}
			},
			j_payasaka_ha20s = {
				name = "Huh! All 20s",
				text = {
					"{C:attention}Retrigger{} cards or jokers",
					"with {C:green,E:1,S:1.1}probabilities{} once",
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Retrigger jokers...",
				}
			},
			j_payasaka_potential = {
				name = "Potential Energy",
				text = {
					"{C:green}#1# in #2#{} chance of {C:attention}duplicating",
					"a random Joker when sold",
					"Chances increase per {C:attention}unique{}",
					"poker hand played"
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Invisible Joker... 2!",
				}
			},
			j_payasaka_bakushin = {
				name = {
					"{f:5}サクラバクシンオー",
					"{C:edition,s:0.5}Sakura Bakushin O"
				},
				text = {
					"{X:attention,C:white}X#1#{} Speed",
					"{C:inactive,s:0.8}Speed of what????",
				},
			},
			j_payasaka_manhattan = {
				name = {
					"{f:5}マンハッタンカフェ",
					"{C:edition,s:0.5}Manhattan Cafe"
				},
				text = {
					"When a {C:attention}Food Joker{} is",
					"about to be {C:red,E:1}destroyed{},",
					"turn that Joker into",
					"a {C:attention}random{} Food Joker",
					"and {C:red,E:1}prevent destruction"
				},
			},
			j_payasaka_oguri = {
				name = {
					"{f:5}オグリキャップ",
					"{C:edition,s:0.5}Oguri Cap"
				},
				text = {
					"Scaling Jokers scale",
					"{C:attention}twice{} as fast",
					"{C:inactive,s:0.8}(e.g. +2 -> +4)",
					"{C:inactive,s:0.8}Does not include",
					"{C:inactive,s:0.8}run scaling jokers"
				},
			},
			j_payasaka_kitasan = {
				name = {
					"{f:5}キタサンブラック",
					"{C:edition,s:0.5}Kitasan Black"
				},
				text = {
					{
						"This Joker gains {X:mult,C:white}X#1#{} Mult at",
						"{C:attention}random{} times during the run",
						"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
					},
					{
						"Gained XMult {C:attention}exponentially",
						"increases for each {C:attention}copy{} of",
						"this Joker currently owned",
					}
				},
			},
			j_payasaka_catchan = {
				name = "Catchan",
				text = {
					"This Joker gains {C:attention}+#1#{} hand",
					"size after defeating",
					"a boss blind",
					"{C:inactive}(Currently {C:attention}+#2#{C:inactive} Hand Size)",
				},
			},
			j_payasaka_kacey = {
				name = "Kacey",
				text = {
					"{C:attention}Upgrades{} Booster Packs",
					"in the shop to be",
					"one {C:attention}tier{} higher",
					"{C:inactive,s:0.8}(e.g. Jumbo -> Mega)"
				}
			},
			j_payasaka_haru = {
				name = {
					"{f:5}ハルウララ",
					"{C:edition,s:0.5}Haru Urara"
				},
				text = {
					"This Joker gains {C:chips}+#2#{} Chips",
					"for each {C:attention}unscored{} card",
					"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
				},
			},
			j_payasaka_ichiro = {
				name = {
					"{f:5}大神 一郎",
					"{C:edition,s:0.5}Ichiro Ogami"
				},
				text = {
					"First Voucher in the shop is",
					"replaced with a {C:attention}Voucher Pack",
				}
			},
			j_payasaka_across_the_world = {
				name = "Across the World",
				text = {
					"Buffoon Packs in the shop",
					"have a {C:green}#1# in #2#{} chance",
					"of being {C:attention}replaced{} with a",
					"corresponding {C:payasaka_friend}Friend{} Pack"
				},
			},
			j_payasaka_sinisterpotion = {
				name = "Sinister Potion",
				text = {
					"Has a {C:legendary,E:1}random effect{}",
					"{C:inactive}Buy my Sinister Potion!"
				}
			},
			j_payasaka_gungho = {
				name = "Gung-ho Gun",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"{C:green}#2# in #3#{} chance for",
					"drawn cards to be",
					"{C:attention}marked for death"
				},
			},
			j_payasaka_contract = {
				name = "Contract Killer",
				text = {
					"Marks a random card",
					"currently {C:attention}held in hand",
					"{C:attention}Destroyed{} cards",
					"each give {C:money}$#1#"
				},
			},
			j_payasaka_snowyday = {
				name = "Snowy Day",
				text = {
					"{C:attention}+#1#{} hand size",
					"Freezes the first card",
					"in {C:attention}scored hand",
				},
			},
			j_payasaka_blizzard = {
				name = "Blizzard",
				text = {
					"{C:green}#1# in #2#{} chance of",
					"freezing random cards",
					"in {C:attention}scored hand",
					"Frozen cards retrigger",
					"{C:attention}#3#{} additional times"
				},
			},
			j_payasaka_almondeye = {
				name = {
					"{f:5}アーモンドアイ",
					"{C:edition,s:0.5}Almond Eye",
				},
				text = {
					"{X:dark_edition,C:white}^#1#{} Score",
					"All blinds are {C:dark_edition}Boss Blinds",
				}
			},
			j_payasaka_jlm = {
				name = "A Jimbo Like Me",
				text = {
					{
						"Scored cards have a",
						"{C:green}#1# in #2#{} chance of",
						"giving {X:mult,C:white}X#3#{} Mult",
					},
					{
						"Odds {C:attention}increase{} by {C:attention}#4#",
						"each time it {C:attention}fails{}",
						"Resets when {C:attention}triggered{}"
					}
				}
			},
			j_payasaka_windysummer = {
				name = "WINDY SUMMER",
				text = {
					"Adds the {C:attention}second-to-last{} card",
					"in your {C:attention}discard pile{} to",
					"the current played hand",
					"{C:inactive}(Currently {C:light_black}#1#{C:inactive} of {V:1}#2#{C:inactive})"
				}
			},
			j_payasaka_chicot = {
				name = "Chicot",
				text = {
					"{C:attention}Retrigger{} each card",
					"based on the {C:attention}amount{} of",
					"{C:risk}Risk{} cards currently {C:attention}active",
					"{C:inactive}(Currently {C:attention}#1#.{C:inactive})"
				},
				-- These guys don't have comments
			},
			j_payasaka_luchador = {
				name = "Luchador",
				text = {
					"Sell this card to make",
					"{C:risk}Risk{} cards used this",
					"ante {C:attention}persist{} for the",
					"rest of the run"
				},
				-- These guys don't have comments
			},
			j_payasaka_pulmenti = {
				name = "Numerus Pulmenti",
				text = {
					"All calculations are",
					"considered as an",
					"operator {C:attention}higher"
				}
			}
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
					"Multiplies score by X#1#",
					"if current score does not",
					"meet the blind requirement"
				}
			},
			bl_payasaka_construct = {
				name = "The Downpour",
				text = {
					"Score is deducted by",
					"Blind requirement / 10",
				}
			},
			bl_payasaka_scholar = {
				name = "The Scholar",
				text = {
					"Ranks are debuffed",
					"sequentially per hand",
				}
			},
			bl_payasaka_chamber = {
				name = "The Chamber",
				text = {
					"Mark 3 cards for",
					"death each hand",
				}
			},
			bl_payasaka_stasis = {
				name = "The Stasis",
				text = {
					"Freeze a random card",
					"in played hand",
				}
			},
			bl_payasaka_showdown_maroon_rose = {
				name = "Maroon Rose",
				text = {
					"Debuffs leftmost and",
					"rightmost played cards",
					"after pressing play"
				}
			},
			bl_payasaka_showdown_the_nameless = {
				name = "The Nameless",
				text = {
					"#1# in #2# chance of",
					"washing out drawn cards"
				}
			}
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
			},
			m_payasaka_volatile = {
				name = "Volatile Card",
				text = {
					"{X:mult,C:white}X#1#{} Mult if",
					"played but unscored",
				}
			},
			m_payasaka_laser = {
				name = "Laser Card",
				text = {
					"{C:legendary}Balance{} {C:attention}#1#%{} of",
					"{C:chips}Chips{} and {C:mult}Mult{}",
				}
			},
			m_payasaka_true = {
				name = "True Card",
				text = {
					"{C:attention}Reduces{} score",
					"req. by {C:attention}#1#{}%",
				}
			},
			m_payasaka_mimic = {
				name = "Mimic Card",
				text = {
					"{C:attention}Mimics{} the properties of",
					"the card to the left",
					"{C:inactive,s:0.8}(Except seals and editions)"
				}
			},
			m_payasaka_ice = {
				name = "Ice Card",
				text = {
					"Turns into a",
					"Frozen Card",
					"when played"
				}
			},
			m_payasaka_score = {
				name = "Score Card",
				text = {
					"Counts as both",
					"scored and unscored",
					"{C:chips}+#1#{} chips per",
					"scored card"
				}
			},
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
					"{C:attention}during{} this ante's boss blind",
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
			},
			dd_payasaka_paya_variables = {
				name = "Permanent upgrades",
				text = {
					"{C:chips}+#1#{} Chips, {C:mult}+#2#{} Mult,",
					"{X:mult,C:white}X#3#{} Mult, {X:dark_edition,C:white}^#4#{} Mult",
					"{C:money}$#5#{}, {C:legendary}#6#%{} Balance",
				}
			},
			dd_payasaka_dummy = {
				text = {
					"???"
				}
			},
			dd_payasaka_frozen = {
				name = "Frozen Card",
				text = {
					"Forced to be",
					"selected",
					"Can be played 2",
					"more times"
				}
			},
			dd_payasaka_thaw = {
				name = "Frozen Card",
				text = {
					"Forced to be",
					"selected",
					"Can be played 1",
					"additional time"
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
					"Levels up played",
					"hand by {C:attention}#1#",
					"temporarily"
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
					"{C:property}Mega Real Estate Pack",
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
					"{C:payasaka_prismatic_gradient}Ahead Joker",
				},
			},
			tag_payasaka_potential = {
				name = "T=ag2",
				text = {
					"Shop has a",
					"{C:dark_edition}Potential Energy",
					"{C:inactive,s:0.8}(The name doesn't make sense.)"
				},
			},
			tag_payasaka_friend = {
				name = "Landline Tag",
				text = {
					"Creates a",
					"{C:payasaka_friend}Friend Joker",
					"{C:inactive}(Must have room)"
				},
			},
			tag_payasaka_thrillseeker = {
				name = "Desperado Tag",
				text = {
					"Gives a free",
					"{C:risk}Mega Risk Pack",
				},
			},
			tag_payasaka_tier1reward = {
				name = {
					"Reward Tag",
					"{C:edition,s:0.5}Tier 1"
				},
				text = {
					"Gives a free",
					"{C:reward}Reward Pack",
				},
			},
			tag_payasaka_tier2reward = {
				name = {
					"Reward Tag",
					"{C:edition,s:0.5}Tier 2"
				},
				text = {
					"Gives a free",
					"{C:reward}Jumbo Reward Pack",
				},
			},
			tag_payasaka_tier3reward = {
				name = {
					"Reward Tag",
					"{C:edition,s:0.5}Tier 3"
				},
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
					"{C:legendary}Random Stamp{} or",
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
					{
						"Turns {C:attention}#1#{} selected {C:red}nil{} card",
						"into a {C:attention}selected{} Joker of",
						"choice from {C:attention}your collection",
						"{C:inactive,s:0.8}No limits.",
					},
					{
						"Adds {C:dark_edition}Eternal{} to all",
						"selected {C:red}nil{} cards"
					}
				},
				payasaka_comment = {
					"{C:inactive,s:0.8}Fluffy...",
				}
			},
			c_payasaka_grow = {
				name = "Grow",
				text = {
					"{C:attention}Doubles{} the values",
					"of a {C:attention}random{} Joker",
					"and adds {C:dark_edition}Giant{} to",
					"the selected Joker",
					"{C:inactive}(Must have room)"
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
					"Levels up the {C:attention}2",
					"{C:purple,E:1}most played{} poker",
					"hands by {C:attention}#1#",
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
					"skip tag and a",
					"{C:attention}Tag Bag{} of it"
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
			c_payasaka_bloom = {
				name = "Bloom",
				text = {
					"Creates {C:attention}#2# enhanced{} copies",
					"of {C:attention}#1#{} selected card",
				}
			},
			c_payasaka_enlighten = {
				name = "Enlighten",
				text = {
					"Creates {C:attention}#1#{} random",
					"{C:dark_edition}Negative{} consumables",
					"{C:inactive,s:0.8}(Cannot create Reward cards)"
				}
			},
			c_payasaka_rebirth = {
				name = "Rebirth",
				text = {
					"{C:red}Destroys{} {C:attention}#1#{} selected Joker",
					"and {C:attention}creates{} another Joker",
					"of a higher {C:attention}rarity",
				}
			},
			c_payasaka_recall = {
				name = "Recall",
				text = {
					"Creates the last Joker",
					"you recently {C:attention}sold{}",
					"{C:inactive}(Does not need room)"
				}
			},
			c_payasaka_meld = {
				name = "Meld",
				text = {
					"Turn {C:attention}#2#{} random cards",
					"held in hand to the",
					"selected card's {C:attention}rank",
				}
			},
			c_payasaka_harmony = {
				name = "Harmony",
				text = {
					"Converts all cards",
					"in hand to a single",
					"random {C:attention}enhancement",
				}
			},
			c_payasaka_legacy = {
				name = "Legacy",
				text = {
					"Destroy a {C:attention}random",
					"Joker, {C:dark_edition}+#1#{} hand size",
				}
			},
			c_payasaka_companion = {
				name = "Companion",
				text = {
					"Creates a random",
					"{C:payasaka_friend}Friend{} Joker",
					"{C:inactive}(Must have room)"
				}
			},
			c_payasaka_spirit = {
				name = "Bountiful Spirit",
				text = {
					"Enhances {C:attention}#1#",
					"selected cards to",
					"{C:attention}#2#s",
				}
			},
			c_payasaka_truth = {
				name = "Highest Truth",
				text = {
					"Enhances {C:attention}#1#",
					"selected cards to",
					"{C:attention}#2#s",
				}
			},
			c_payasaka_righteousmind = {
				name = "Righteous Mind",
				text = {
					"Enhances {C:attention}#1#",
					"selected card to a",
					"{C:attention}#2#",
				}
			},
			c_payasaka_health = {
				name = "Perfect Health",
				text = {
					"Enhances {C:attention}#1#",
					"selected cards to",
					"{C:attention}#2#s",
				}
			},
			c_payasaka_purify = {
				name = "{C:edition}Purify",
				text = {
					"Removes {C:attention}all{} stickers",
					"on {C:attention}#1#{} selected Joker"
				}
			}
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
			v_payasaka_broad_strokes = {
				name = "Broad Strokes",
				text = {
					"{C:green}#1# in #2#{} chance of creating",
					"a corresponding {C:attention}rarity tag{} when",
					"a Joker is {C:attention}sold{} or {C:attention}destroyed{}"
				}
			},
			v_payasaka_fine_motion = {
				name = "Fine Tuning",
				text = {
					"{C:green}#1# in #2#{} chance of creating",
					"a corresponding {C:attention}edition tag{} when",
					"a Joker is {C:attention}sold{} or {C:attention}destroyed{}"
				}
			},
			v_payasaka_deck_builder = {
				name = "Deck Builder",
				text = {
					"Shop has an additional",
					"{C:attention}#1#{} for sale"
				}
			},
			v_payasaka_ityc = {
				name = "Is This Your Card?",
				text = {
					"#1#s always use",
					"cards from your {C:attention}own deck{}",
					"{C:attention}+#2#{} #1# card"
				}
			},
			v_payasaka_storage = {
				name = "Expanded Storage",
				text = {
					"{C:dark_edition}+#1#{} Joker slot",
					"{C:attention}Rightmost{} Joker is {C:attention}debuffed",
					"when no Joker slots left"
				}
			},
			v_payasaka_hangar = {
				name = "Advanced Hangar",
				text = {
					"{C:attention}Rightmost{} Joker is",
					"only {C:attention}debuffed during",
					"{C:attention}Small{} and {C:attention}Big{} Blinds"
				}
			}
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
					{
						"{X:attention,C:white}X#5#{} Blind size",
					},
					{
						"Create a {C:dark_edition}Negative{}",
						"{C:reward}Reward{} card for",
						"every {C:attention}#4#{} rounds",
						"this has been held",
						"{C:inactive}(Currently {C:attention}#1#{C:inactive}, {}[{C:attention}#2#{C:inactive}#3#{}]{C:inactive})",
					}
				}
			},
		},
		Status = {
			status_payasaka_frozen = {
				name = "Frozen",
				text = {
					"Forced selected",
					"until played",
					"or discarded"
				}
			},
			status_payasaka_marked = {
				name = "Marked",
				text = {
					"Destroyed if",
					"held in hand"
				}
			},
			status_payasaka_zzazz = {
				name = "{f:payasaka_pokemon}ZZAZZAZZ",
				text = {
					"{f:payasaka_pokemon}______",
					"{f:payasaka_pokemon}TYPE",
					"{f:payasaka_pokemon}CoolTrainer♀"
				},
			},
			status_payasaka_awful = {
				name = "Awful",
				text = {
					"All card values are",
					"reduced by {C:attention}25%",
				},
			},
			status_payasaka_playing = {
				name = "Playing",
				text = {
					"This music track is",
					"currently being played"
				}
			}
		},
		TagBag = {
			c_payasaka_tagbagtest = {
				name = "Tag Bag",
				text = {
					"Creates a",
					"{C:attention}#1#"
				}
			},
			c_payasaka_tagbagtest_patch = {
				name = "Patch Pouch",
				text = {
					"Creates a",
					"{C:attention}#1#"
				}
			}
		},
		Other = {
			card_extra_e_chips = {
				text = {
					"{X:dark_edition,C:white}^#1#{} extra chips"
				}
			},
			card_extra_e_mult = {
				text = {
					"{X:dark_edition,C:white}^#1#{} extra Mult"
				}
			},
			card_extra_balance = {
				text = {
					"{C:legendary}#1#%{} extra balance"
				}
			},
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
				name = "Real Estate Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:property} Property{} cards to",
					"add to your consumeables"
				}
			},
			p_payasaka_property_normal_2 = {
				name = "Real Estate Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:property} Property{} cards to",
					"add to your consumeables"
				}
			},
			p_payasaka_property_mega_1 = {
				name = "Mega Real Estate Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:property} Property{} cards to",
					"add to your consumeables"
				}
			},
			p_payasaka_property_mega_2 = {
				name = "Mega Real Estate Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:property} Property{} cards to",
					"add to your consumeables"
				}
			},
			p_payasaka_property_jumbo_1 = {
				name = "Jumbo Real Estate Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:property} Property{} cards to",
					"add to your consumeables"
				}
			},
			p_payasaka_property_jumbo_2 = {
				name = "Jumbo Real Estate Pack",
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
			p_payasaka_arcana_ultra = {
				name = "Ultra Arcana Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:tarot} Tarot{} cards to",
					"be used immediately",
				}
			},
			p_payasaka_celestial_ultra = {
				name = "Ultra Celestial Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:planet} Planet{} cards to",
					"be used immediately",
				}
			},
			p_payasaka_spectral_ultra = {
				name = "Ultra Spectral Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:spectral} Spectral{} cards to",
					"be used immediately",
				}
			},
			p_payasaka_standard_ultra = {
				name = "Ultra Standard Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:attention} Playing{} cards to",
					"add to your deck",
				}
			},
			p_payasaka_buffoon_ultra = {
				name = "Ultra Buffoon Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:joker} Joker{} cards",
				},
			},
			p_payasaka_code_ultra = {
				name = "Ultra Program Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:cry_code} Code{} card#<s>2#",
				},
			},
			p_payasaka_friend_normal_1 = {
				name = "Friend Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:payasaka_friend} Friend{} Jokers",
				},
			},
			p_payasaka_friend_normal_2 = {
				name = "Friend Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:payasaka_friend} Friend{} Jokers",
				},
			},
			p_payasaka_friend_jumbo_1 = {
				name = "Jumbo Friend Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:payasaka_friend} Friend{} Jokers",
				},
			},
			p_payasaka_friend_mega_1 = {
				name = "Mega Friend Pack",
				text = {
					"Choose {C:attention}#1#{} of up to",
					"{C:attention}#2#{C:payasaka_friend} Friend{} Jokers",
				},
			},
			p_payasaka_voucher_normal_1 = {
				name = "Voucher Pack",
				text = {
					"Redeem {C:attention}#1#{} of up to",
					"{C:attention}#2#{} random Vouchers{}",
				}
			},
			p_payasaka_voucher_jumbo_1 = {
				name = "Jumbo Voucher Pack",
				text = {
					"Redeem {C:attention}#1#{} of up to",
					"{C:attention}#2#{} random Vouchers{}",
				}
			},
			payasaka_random_seal = {
				name = "Random Stamp",
				text = {
					"{C:attention}Each effect{} has a",
					"{C:green}#1# in #2#{} chance",
					"to be given",
					"when played",
				}
			},
			payasaka_thunder_seal = {
				name = "Thunder Stamp",
				text = {
					"Creates a {C:risk}Risk{} card if",
					"played but {C:attention}unscored",
					"{C:inactive}(Must have room)",
				}
			},
			payasaka_ghost_seal = {
				name = "Ghost Stamp",
				text = {
					"Creates a {C:dark_edition}Spectral{} card",
					"and a {C:attention}copy{} of this card",
					"once its {C:red}destroyed",
					"{C:inactive}(Must have room)",
					"{C:inactive}(Does not copy seal)",
				}
			},
			payasaka_sunset = {
				name = "Sunset",
				text = {
					"{C:green}#1# in #2#{} chance of",
					"{C:red}self-destructing{} if",
					"blind was not beaten",
					"in one hand"
				}
			},
			payasaka_tired = {
				name = "Tired",
				text = {
					"Debuffed on the",
					"{C:attention}first hand{} of round",
				}
			},
			payasaka_giant = {
				name = "Giant",
				text = {
					"{C:dark_edition}-#1#{} Joker slot",
				}
			},
			payasaka_delivery = {
				name = "Delivery",
				text = {
					"Debuffed for",
					"{C:attention}2{} rounds",
					"{C:inactive}({C:attention}#1#{C:inactive} remaining)",
				}
			},
			payasaka_delivered = {
				name = "Delivered",
				text = {
					"No effects",
				}
			},
			payasaka_taunt = {
				name = "Taunt",
				text = {
					"{X:dark_edition,C:white}X#1#{} Blind size",
				}
			},
			payasaka_unlucky = {
				name = "Unlucky",
				text = {
					"Halves listed",
					"{C:green,E:1}probabilities"
				}
			},
			payasaka_liability = {
				name = "Liability",
				text = {
					"{C:money}$#1#{} interest cap",
				}
			},
			payasaka_balance = {
				name = "Balance",
				text = {
					"{C:red}-1{} hand on first",
					"discard of round",
					"{C:red}-1{} discard on first",
					"hand of round",
				}
			},
			payasaka_warranty = {
				name = "Warranty",
				text = {
					"{C:money}$#1#{} if sold",
					"or destroyed",
				}
			},
			payasaka_polymorph = {
				name = "Polymorph",
				text = {
					"{C:attention}Transforms{} into a",
					"{C:attention}random #1#{} at the",
					"end of round"
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
			sleeve_payasaka_sticker = {
				name = "Sticker Sleeve",
				text = {
					"Start with an {C:attention,T:v_overstock_norm}#1#",
					"and a {C:dark_edition,T:c_payasaka_purify}#2# card",
					"Jokers can have {C:attention}stickers",
					"Stakes {C:attention}increase{} chance for their",
					"{C:attention}respective{} sticker"
				}
			},
			sleeve_payasaka_sticker_alt = {
				name = "Sticker Sleeve",
				text = {
					"Start with an {C:attention,T:v_overstock_plus}#1#",
					"and a {C:dark_edition,T:c_payasaka_purify}#2# card",
					"{E:1,C:legendary}Any{} card can have a {C:attention}sticker",
				}
			},
			sleeve_payasaka_back = {
				name = "Sleeve in a Sleeve in a Sleeve",
				text = {
					"{C:attention}Sleeves{} are {C:attention}available",
					"in the shop",
					"{C:inactive}Isn't this just Parakmi?"
				}
			},
			sleeve_payasaka_deck_alt = {
				name = "Super Probably Sleeve",
				text = {
					"{C:attention}Decks{} and {C:attention}Sleeves{} are",
					"{C:attention}available{} in the shop",
					"{C:inactive}Get Smooshed!"
				}
			},
		},
		Seal = {
			payasaka_random = {
				name = "Random Stamp",
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
		PTADummy = {

		},
		PTASet = {
			ptaset_payasaka_experimental = {
				name = "Experimental Features",
				text = {
					"Enables new funny features!",
					"{C:inactive,s:0.8}Includes stuff that may be broken."
				}
			},
			ptaset_payasaka_ahead = {
				name = "Ahead Jokers",
				text = {
					{
						"Meme rarity that focuses on",
						"{X:chips,C:white}XChips{}, {C:spades}Spades{} or both",
						"{C:inactive,s:0.8}Intentionally unbalanced."
					},
					{
						"Also includes {C:payasaka_prismatic_gradient}Prismatic",
						"Jokers and other stuff."
					}
				}
			},
			ptaset_payasaka_property = {
				name = "Property Cards",
				text = {
					"Consumables that focus",
					"on {C:money}econ{} generation",
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
			ptaset_payasaka_newrunplus = {
				name = "New Run+",
				text = {
					"Allow restarting your run",
					"with certain things intact!"
				},
				unlock = {
					"Beat a run with a",
					"{C:attention}Paya's Terrible Additions{}",
					"Joker currently held"
				},
			},
			ptaset_payasaka_fatty = {
				name = "Oguri Globalization",
				text = {
					"Allow {C:attention}Oguri Cap{} to always detect",
					"{C:attention}scaling changes{} in ALL Jokers",
					"{C:dark_edition}Might break some things!"
				},
			},
			ptaset_payasaka_hidden = {
				name = "???",
				text = {
					"YOU SHOULD NOT BE HERE",
				},
				unlock = {
					"???"
				}
			},
			ptaset_payasaka_prismatic_music = {
				name = {
					"THROWBACK",
					"{C:edition,s:0.6}Kool Cat the Martian"
				},
				text = {
					"Music that plays while having",
					"a {C:payasaka_prismatic_gradient}Prismatic Joker{}",
					"{C:inactive,s:0.6}https://www.youtube.com/watch?v=tZZu9HUf0-Y"
				},
			},
			ptaset_payasaka_mechanic_music = {
				name = {
					"Main Theme",
					"{s:0.7}(Demo Version)",
					"{C:edition,s:0.6}SiIvaGunner"
				},
				text = {
					"Music that plays in the",
					"{C:spectral}Mechanic{} or {C:dark_edition}Wild DOS{} menu",
					"{C:inactive,s:0.6}https://www.youtube.com/watch?v=-mck1CdwXGs"
				},
			},
			ptaset_payasaka_property_music = {
				name = {
					"balatro.mid",
					"{C:edition,s:0.6}AirRice"
				},
				text = {
					"Music that plays in",
					"{C:property}Real Estate{} Packs",
					"{C:inactive,s:0.6}https://www.youtube.com/watch?v=dskn803flbA"
				},
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
					"used for Property Cards",
					"{C:inactive,s:0.6}https://www.youtube.com/watch?v=dskn803flbA"
				}
			},
			credit_kctm = {
				name = "Kool Cat the Martian",
				text = {
					"\"THROWBACK\" Balatro theme",
					"used for {C:payasaka_prismatic_gradient}Prismatic{} Jokers",
					"{C:inactive,s:0.6}https://www.youtube.com/watch?v=tZZu9HUf0-Y"
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
		achievement_names = {
			ach_payasaka_gacha_prismatic = "3☆ Make Debut Ticket",
			ach_payasaka_beat_ante39 = "The End?",
			ach_payasaka_risktaker = "I'm Risking It!",
			ach_payasaka_thunderstruck = "Great Summoning",
			-- Don't tell anyone this was originally Friend Inside Me
			ach_payasaka_friend = "Three's a Crowd"
		},
		achievement_descriptions = {
			ach_payasaka_gacha_prismatic = {
				"Obtain a Prismatic Joker",
				"from a Gacha card"
			},
			ach_payasaka_beat_ante39 = {
				"Win the Ante 39",
				"superboss"
			},
			ach_payasaka_risktaker = {
				"Use more than 10 Risk",
				"cards in a single ante"
			},
			ach_payasaka_thunderstruck = {
				"Attempt to debuff a boss blind",
				"while Risk cards are in effect",
			},
			ach_payasaka_friend = {
				"Win a run with atleast",
				"3 Friend Jokers"
			}
		},
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
			lq_manifold_1 = {
				"Don't push",
				"your luck!"
			},
			lq_manifold_2 = {
				"Maybe try scoring",
				"less next time?"
			},
			lq_manifold_3 = {
				"The looming 183X",
				"Base boss blind:"
			},
			lq_manifold_4 = {
				"Thou shan't not",
				"proceed... Maybe.",
			},
			lq_perfectheart_1 = {
				"Remember, you",
				"brought this",
				"upon yourself!"
			},
			lq_perfectheart_2 = {
				"It seems you must",
				"try a bit harder.."
			},
			lq_perfectheart_3 = {
				"Don't make me",
				"do this again."
			},
			lq_perfectheart_4 = {
				"Tsk.. Showing your",
				"emotions makes you",
				"easier to read...",
			},
		},
		v_text = {
			ch_c_payasaka_dream_fest_indicator = {
				"Good luck!",
			}
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
			k_property_pack = "Real Estate Pack",
			k_tagbag = "Tag Bag",
			k_tagbag_patch = "Patch Pouch",
			b_tagbag_cards = "Tag Bag",
			k_friend_pack = "Friend Pack",
			k_voucher_pack = "Voucher Pack",
			k_moji_pack = "Reward Pack",
			k_risk_pack = "Risk Pack",
			k_gacha_pack = "Gacha Pack",
			k_legendary_pack = "Legendary Pack",
			b_payasaka_reroll = "Reroll",
			k_payasaka_comment = "Paya's comment:",
			k_payasaka_ahead = "Ahead",
			k_payasaka_daeha = "Prismatic",
			k_payasaka_thunderstruck = "Thunderstruck",
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
			k_status = "Status",
			k_statuses = "Status Effects",
			k_ptaset = "Config",
			ml_payasaka_status_info = {
				"Cards can have multiple status",
				"effects at once"
			}
			-- #endregion
		},
		v_dictionary = {
			pta_art_credit = { "Art: #1#" },
			pta_idea_credit = { "Idea: #1#" },
			pta_code_credit = { "Code: #1#" },
			a_tallymult = "&#1# Mult",
			a_irisu_joker_slot = "+#1# Slot?",
			a_jlm_odds = "+#1# Odds",
			a_whatchips = "#1# Chips",
		},
		labels = {
			payasaka_jpeg = 'YCbCr',
			payasaka_checkered = 'Checkered',
			payasaka_random_seal = "Random Stamp",
			payasaka_thunder_seal = "Thunder Stamp",
			payasaka_ghost_seal = "Ghost Stamp",
			payasaka_sunset = "Sunset",
			payasaka_tired = "Tired",
			payasaka_giant = "Giant",
			payasaka_delivery = "Delivery",
			payasaka_delivered = "Delivered",
			payasaka_taunt = "Taunt",
			payasaka_unlucky = "Unlucky",
			payasaka_liability = "Liability",
			payasaka_balance = "Balance",
			payasaka_warranty = "Warranty",
			payasaka_polymorph = "Polymorph",
			status_payasaka_frozen = "Frozen",
			status_payasaka_marked = "Marked",
			status_payasaka_zzazz = "ZZAZZ",
			status_payasaka_awful = "Awful",
			status_payasaka_playing = "Playing",
			k_payasaka_ahead = "Ahead",
			k_payasaka_daeha = "Prismatic",
			k_payasaka_thunderstruck = "Thunderstruck",
		},
		challenge_names = {
			c_payasaka_stuckrock = "Stuck between a Rock and a Hard Place",
			c_payasaka_freeticket = "Eternal Ticket to Hell",
			c_payasaka_dreamfest = "Dream Fest Legend"
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
