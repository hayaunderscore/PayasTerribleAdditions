SMODS.ConsumableType {
	key = 'DOSCard',
	collection_rows = { 5, 6 },
	primary_colour = HEX('4f6368'),
	secondary_colour = HEX('a1c5c4'),
	shop_rate = 0.3,
	loc_txt = {},
}

SMODS.UndiscoveredSprite {
	key = 'DOSCard',
	atlas = "JOE_DOS",
	path = 'dos.png',
	pos = { x = 3, y = 3 },
	px = 71, py = 95,
}

PTASaka.DOSCard = SMODS.Consumable:extend {
	set = 'DOSCard',
	atlas = "JOE_DOS",
	pyroxenes = 5,
	cost = 0,
	required_params = {
		'key',
	},
	update = function(self, card, dt)
		if card.area == G.consumeables then
			local copy = copy_card(card)
			card:remove()
			card:remove_from_area()
			PTASaka.dos_cardarea:emplace(copy)
		end
	end,
	can_use = function(self, card)
		return false
	end,
	in_pool = function(self, args)
		return true
	end,
}

PTASaka.DOSCard {
	key = 'dos_wild',
	atlas = "JOE_DOS",
	pos = { x = 0, y = 0 }
}

PTASaka.DOSCard {
	key = 'dos_exclam',
	atlas = "JOE_DOS",
	pos = { x = 1, y = 0 }
}

PTASaka.DOSCard {
	key = 'dos_wildtwo',
	atlas = "JOE_DOS",
	pos = { x = 2, y = 0 }
}

PTASaka.DOSCard {
	key = 'dos_three',
	atlas = "JOE_DOS",
	pos = { x = 3, y = 0 }
}

PTASaka.DOSCard {
	key = 'dos_four',
	atlas = "JOE_DOS",
	pos = { x = 0, y = 1 }
}

PTASaka.DOSCard {
	key = 'dos_five',
	atlas = "JOE_DOS",
	pos = { x = 1, y = 1 }
}

PTASaka.DOSCard {
	key = 'dos_six',
	atlas = "JOE_DOS",
	pos = { x = 2, y = 1 }
}

PTASaka.DOSCard {
	key = 'dos_seven',
	atlas = "JOE_DOS",
	pos = { x = 3, y = 1 }
}

PTASaka.DOSCard {
	key = 'dos_eight',
	atlas = "JOE_DOS",
	pos = { x = 0, y = 2 }
}

PTASaka.DOSCard {
	key = 'dos_nine',
	atlas = "JOE_DOS",
	pos = { x = 1, y = 2 }
}

PTASaka.DOSCard {
	key = 'dos_ten',
	atlas = "JOE_DOS",
	pos = { x = 2, y = 2 }
}

G.FUNCS.payasaka_open_dos_cardarea = function(e)
	if not G.deck.states.visible then
		G.FUNCS.payasaka_open_deck(e)
		return
	end
	G.CONTROLLER.dos_area_lock = true
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function()
			play_sound('other1')
			--G.deck:set_role({ xy_bond = 'Weak' })
			G.deck.T.y = G.deck.T.y + 20
			return true
		end
	}))
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.3,
		func = (function()
			--PTASaka.dos_cardarea:set_role({ xy_bond = 'Weak' })
			PTASaka.dos_cardarea.T.y = PTASaka.dos_cardarea.T.y - 20
			G.payasaka_dos_cardarea_switch.role.major = PTASaka.dos_cardarea
			G.deck.states.visible = false
			G.CONTROLLER.dos_area_lock = false
			local text = G.payasaka_dos_cardarea_switch:get_UIE_by_ID("payasaka_dos_text")
			text.config.text = "Deck"
			G.payasaka_dos_cardarea_switch:recalculate()
			return true
		end)
	}))
end

G.FUNCS.payasaka_open_deck = function(e)
	G.CONTROLLER.dos_area_lock = true
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function()
			play_sound('other1')
			--PTASaka.dos_cardarea:set_role({ xy_bond = 'Weak' })
			PTASaka.dos_cardarea.T.y = PTASaka.dos_cardarea.T.y + 20
			return true
		end
	}))
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.3,
		func = (function()
			--G.deck:set_role({ xy_bond = 'Weak' })
			G.deck.T.y = G.deck.T.y - 20
			G.payasaka_dos_cardarea_switch.role.major = G.deck
			G.deck.states.visible = true
			G.CONTROLLER.dos_area_lock = false
			local text = G.payasaka_dos_cardarea_switch:get_UIE_by_ID("payasaka_dos_text")
			text.config.text = "DOS Cards"
			G.payasaka_dos_cardarea_switch:recalculate()
			return true
		end)
	}))
end

G.FUNCS.payasaka_can_open_dos_cardarea = function(e)
	if G.CONTROLLER.dos_area_lock then
		e.states.button = nil
	else
		e.states.button = "payasaka_open_dos_cardarea"
	end
end

local old_start_run = Game.start_run
function Game:start_run(args)
	self.payasaka_dos_cardarea = CardArea(0, 0, self.CARD_W * 5, self.CARD_H,
		{ card_limit = 1, type = 'deck', highlight_limit = 1 })
	PTASaka.dos_cardarea = self.payasaka_dos_cardarea
	--PTASaka.dos_cardarea.alignment.offset.y = 20
	old_start_run(self, args)
	-- create switch butan
	G.payasaka_dos_cardarea_switch = UIBox {
		definition = { n = G.UIT.ROOT, config = { align = 'cm', colour = G.C.CLEAR, minw = G.deck.T.w, minh = 0.5 }, nodes = {
			{ n = G.UIT.R, nodes = {
				{
					n = G.UIT.C,
					config = {
						align = "tm",
						minw = 2,
						padding = 0.1,
						r = 0.1,
						hover = true,
						colour = G.C.UI.BACKGROUND_DARK,
						shadow = true,
						button = "payasaka_open_dos_cardarea",
						func = "payasaka_can_open_dos_cardarea",
					},
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "bcm", padding = 0 },
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = "DOS Cards",
										scale = 0.35,
										colour = G.C.UI.TEXT_LIGHT,
										id = "payasaka_dos_text"
									}
								}
							}
						},
					}
				}
			} }
		} },
		config = { major = G.deck, align = 'tm', offset = { x = 0, y = -0.35 }, bond = 'Weak' }
	}

	--G.payasaka_dos_cardarea_switch.role.major = nil

	PTASaka.dos_cardarea.T.x = G.deck.T.x
	PTASaka.dos_cardarea.T.y = G.deck.T.y + 20
	PTASaka.dos_cardarea.T.w = G.deck.T.w
	PTASaka.dos_cardarea.T.h = G.deck.T.h
	PTASaka.dos_cardarea.role.major = G.ROOM
	PTASaka.dos_cardarea.role.r_bond = 'Weak'
	PTASaka.dos_cardarea.role.xy_bond = 'Weak'
	PTASaka.dos_cardarea.container = G.ROOM
end

local ssp = set_screen_positions
function set_screen_positions()
	ssp()
	if PTASaka.dos_cardarea then
		if G.STAGE == G.STAGES.RUN then
			--PTASaka.dos_cardarea:hard_set_VT()
			--PTASaka.dos_cardarea.states.visible = not G.deck.states.visible
			PTASaka.dos_cardarea.states.visible = true
		end
		if G.STAGE == G.STAGES.MAIN_MENU then
			PTASaka.dos_cardarea.states.visible = false
		end
	end
end
