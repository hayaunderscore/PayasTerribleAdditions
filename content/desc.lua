PTASaka.DescriptionDummies = {}

-- ui stuff Taken from Aikoyori thanks aikoyori
PTASaka.DescriptionDummy = SMODS.Center:extend {
	set = 'DescriptionDummy',
	obj_buffer = {},
	obj_table = PTASaka.DescriptionDummies,
	class_prefix = 'dd',
	required_params = {
		'key',
	},
	pre_inject_class = function(self)
		G.P_CENTER_POOLS[self.set] = {}
	end,
	inject = function(self)
		SMODS.Center.inject(self)
	end,
	get_obj = function(self, key)
		if key == nil then
			return nil
		end
		return self.obj_table[key]
	end
}

PTASaka.DescriptionDummy {
	key = "property_card"
}

PTASaka.DescriptionDummy {
	key = "ahead",
	generate_ui = function(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		desc_nodes.title = localize({ type = 'name_text', set = 'DescriptionDummy', key = _c.key })
		localize { type = 'descriptions', set = 'DescriptionDummy', key = _c.key, nodes = desc_nodes, vars = specific_vars or _c.vars or {} }
	end
}

PTASaka.DescriptionDummy {
	key = "missingno_finity",
	generate_ui = function(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		desc_nodes.title = localize({ type = 'name_text', set = 'DescriptionDummy', key = _c.key })
		localize { type = 'descriptions', set = 'DescriptionDummy', key = _c.key, nodes = desc_nodes, vars = specific_vars or _c.vars or {} }
	end
}

PTASaka.DescriptionDummy {
	key = "recuperare",
	generate_ui = function(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		desc_nodes.title = localize({ type = 'name_text', set = 'DescriptionDummy', key = _c.key })
		localize { type = 'descriptions', set = 'DescriptionDummy', key = _c.key, nodes = desc_nodes, vars = specific_vars or _c.vars or {} }
	end
}

-- Adult card card list
local dummy = PTASaka.DescriptionDummy {
	key = "adultcard_area",
	generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
		if not PTASaka.adultcard_cardarea then return end
		local cards = {}
		for i = 1, #PTASaka.adultcard_cardarea.cards do
			local v = PTASaka.adultcard_cardarea.cards[i]
			cards[#cards + 1] = Card(0, 0, G.CARD_W, G.CARD_H, nil, G.P_CENTERS[v.config.center.key])
		end

		if desc_nodes ~= full_UI_table.main then
			PTASaka.card_area_preview(PTASaka.adultcard_cardarea_ui, desc_nodes, {
				cards = cards,
				override = true,
				w = 3.5,
				h = 0.6,
				--mt = -1,
				ml = 0,
				box_height = 2,
				alignment = "bm",
				scale = 0.5,
			})
		end
	end
}
--PTASaka.DescriptionDummies["dd_adultcard_area"] = dummy
