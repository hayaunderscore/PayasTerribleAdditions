SMODS.Challenge {
	key = 'stuckrock',
	jokers = {
		{ id = "j_payasaka_locomotive", eternal = true, stickers = {"cry_absolute"}, pinned = true }
	},
	restrictions = {
		banned_cards = {
			{ id = 'p_celestial_normal_1', ids = {
				'p_celestial_normal_1', 'p_celestial_normal_2', 'p_celestial_normal_3', 'p_celestial_normal_4', 'p_celestial_jumbo_1', 'p_celestial_jumbo_2', 'p_celestial_mega_1', 'p_celestial_mega_2',
			} },
			{ id = 'p_standard_normal_1', ids = {
				'p_standard_normal_1', 'p_standard_normal_2', 'p_standard_normal_3', 'p_standard_normal_4', 'p_standard_jumbo_1', 'p_standard_jumbo_2', 'p_standard_mega_1', 'p_standard_mega_2',
			} },
			{
				id = 'c_hanged_man',
			},
			{
				id = 'c_heirophant',
			},
			{
				id = 'c_lovers',
			},
			{
				id = 'c_world',
			},
			{
				id = 'c_sun',
			},
			{
				id = 'c_star',
			},
			{
				id = 'c_moon',
			},
		}
	}
}

if AKYRS then
	AKYRS.HardcoreChallenge {
		key = 'ultrastuckrock',
		rules = {
			modifiers = {
				{id = 'joker_slots', value = 1e200},
				{id = 'consumable_slots', value = 1e200},
			}
		},
		jokers = {
			{ id = "j_payasaka_locomotive", eternal = true, stickers = {"cry_absolute"}, pinned = true }
		},
		deck = {
			deck = "Hardcore Challenge Deck",
			yes_ranks = {
				['A'] = true,
				['K'] = true,
				['Q'] = true,
				['J'] = true,
				['T'] = true,
				--["9"] = true,
			}
		},
		restrictions = {
			banned_cards = {
				{ id = 'p_celestial_normal_1', ids = {
					'p_celestial_normal_1', 'p_celestial_normal_2', 'p_celestial_normal_3', 'p_celestial_normal_4', 'p_celestial_jumbo_1', 'p_celestial_jumbo_2', 'p_celestial_mega_1', 'p_celestial_mega_2',
				} },
				{ id = 'p_standard_normal_1', ids = {
					'p_standard_normal_1', 'p_standard_normal_2', 'p_standard_normal_3', 'p_standard_normal_4', 'p_standard_jumbo_1', 'p_standard_jumbo_2', 'p_standard_mega_1', 'p_standard_mega_2',
				} },
				{
					id = 'c_hanged_man',
				},
				{
					id = 'c_heirophant',
				},
				{
					id = 'c_lovers',
				},
				{
					id = 'c_world',
				},
				{
					id = 'c_sun',
				},
				{
					id = 'c_star',
				},
				{
					id = 'c_moon',
				},
			}
		},
		difficulty = 8,
	}
end
