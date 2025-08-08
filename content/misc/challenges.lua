
local function SigmaOrNah()
	if AKYRS then return false end
	return true
end

SMODS.Challenge {
	key = 'stuckrock',
	jokers = {
		{ id = "j_payasaka_locomotive", eternal = SigmaOrNah(), akyrs_sigma = true, pinned = true }
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

if MoreFluff then
	SMODS.Challenge {
		key = 'freeticket',
		vouchers = { { id = 'v_mf_superboss_ticket' } }
	}
end

SMODS.Challenge {
	key = 'dreamfest',
	jokers = {
		{ id = "j_payasaka_almondeye", eternal = SigmaOrNah(), akyrs_sigma = true, payasaka_status = {["payasaka_awful"] = true} }
	},
	rules = {
		custom = {
			{ id = 'payasaka_dream_fest_indicator', value = true }
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

	if MoreFluff and next(SMODS.find_mod('finity')) and CardSleeves then
		AKYRS.HardcoreChallenge {
			key = 'finityfreeticket',
			vouchers = { { id = 'v_mf_superboss_ticket' } },
			sleeve = 'sleeve_finity_challenger',
			difficulty = 8,
		}
	end
end
