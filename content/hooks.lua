-- ALL HOOKS jesus

-- General start run hook
local sr = Game.start_run
function Game:start_run(args)
	-- Init DOS Card area
	self.payasaka_dos_cardarea = CardArea(0, 0, self.CARD_W * 5, self.CARD_H,
		{ card_limit = 3, type = 'joker', highlight_limit = 1 })
	PTASaka.dos_cardarea = self.payasaka_dos_cardarea

	-- Init adult card area
	G.P_CENTERS.j_payasaka_buruakacard.config.rarity = 3
	self.payasaka_adultcard_cardarea = CardArea(0, 0, self.CARD_W * 6, self.CARD_H,
		{ card_limit = 1, type = 'joker', highlight_limit = 0 })
	PTASaka.adultcard_cardarea = self.payasaka_adultcard_cardarea
	PTASaka.adultcard_fucked = false
	-- Do not draw the current card area
	-- We don't need to anyway
	PTASaka.adultcard_cardarea.draw = function() end

	-- Exponentials
	PTASaka.payasaka_exponential_count = 0

	-- Initialize possible LAB=01 cardareas first
	local PREGAME = args and args.savetext and args.savetext.GAME or
		{ payasaka_lab_joker_ids = {}, payasaka_cast_joker_ids = {} }
	for k, v in pairs(PREGAME.payasaka_lab_joker_ids or {}) do
		PTASaka.create_storage_area("payasaka_lab_jokers_" .. tostring(k), 2, k)
	end
	-- Same with Cast
	for k, v in pairs(PREGAME.payasaka_cast_joker_ids or {}) do
		PTASaka.create_storage_area("payasaka_cast_jokers_" .. tostring(k), 2, k)
	end
	-- Irisu also uses the same system lmao
	for k, v in pairs(PREGAME.payasaka_irisu_ids or {}) do
		PTASaka.create_storage_area("payasaka_irisu_" .. tostring(k), 1e300, k)
	end

	sr(self, args)

	-- Maximus compat
	if G.GAME.modifiers.mxms_nuclear_size then
		G.GAME.modifiers.mxms_nuclear_size = false
		if not Entropy then
			G.GAME.payasaka_exponential_count = G.GAME.payasaka_exponential_count + 1
			PTASaka.recalc_chips_mult_shit("^", G.GAME.payasaka_exponential_count)
		else
			G.GAME.paya_operator = G.GAME.paya_operator + 1
			PTASaka.recalc_chips_mult_shit("^", G.GAME.paya_operator)
		end
		G.GAME.modifiers.mxms_paya_compat = true
	end

	-- Cast proper initialization
	local merged = G.P_BLINDS['bl_payasaka_question']
	if G.GAME.payasaka_merged_boss_keys and next(G.GAME.payasaka_merged_boss_keys) then
		-- get biggest chips multiplier
		for i = 1, #G.GAME.payasaka_merged_boss_keys do
			local blind = G.P_BLINDS[G.GAME.payasaka_merged_boss_keys[i]]
			merged.mult = math.max(merged.mult, blind.mult)
		end
	end
	-- cryptid being a piece of shit
	merged.mult_ante = G.GAME.round_resets.ante

	-- create switch butan for dos cards
	if not TheFamily then
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
	end
	PTASaka.dos_card_status = "DOS Cards"
	PTASaka.dos_card_status_update_tf = nil

	--G.payasaka_dos_cardarea_switch.role.major = nil

	-- Set these to be derivative of G.deck
	PTASaka.dos_cardarea.T.x = G.deck.T.x
	PTASaka.dos_cardarea.T.y = G.deck.T.y + 5
	PTASaka.dos_cardarea.T.w = G.deck.T.w
	PTASaka.dos_cardarea.T.h = G.deck.T.h
	PTASaka.dos_cardarea.role.major = G.ROOM
	PTASaka.dos_cardarea.role.r_bond = 'Weak'
	PTASaka.dos_cardarea.role.xy_bond = 'Weak'
	PTASaka.dos_cardarea.container = G.ROOM
	PTASaka.dos_cardarea.disabled = false

	PTASaka.dos_enabled_string = "Active!"

	-- Bibliotheca
	PTASaka.discovered_modded_jokers = 0
	for k, v in pairs(G.P_CENTERS) do
		if v.set and v.set == "Joker" and v.mod and v.discovered then
			PTASaka.discovered_modded_jokers = PTASaka.discovered_modded_jokers + 1
		end
	end

	-- Ortalab compat
	if Ortalab and not PTASaka.added_ortalab_food_jokers then
		local p = G.P_CENTER_POOLS["Food"]
		SMODS.insert_pool(p, G.P_CENTERS.j_ortalab_taliaferro)
		SMODS.insert_pool(p, G.P_CENTERS.j_ortalab_sunnyside)
		SMODS.insert_pool(p, G.P_CENTERS.j_ortalab_hot_chocolate)
		SMODS.insert_pool(p, G.P_CENTERS.j_ortalab_miracle_cure)
		SMODS.insert_pool(p, G.P_CENTERS.j_ortalab_royal_gala)
		SMODS.insert_pool(p, G.P_CENTERS.j_ortalab_fine_wine)
		SMODS.insert_pool(p, G.P_CENTERS.j_ortalab_mystery_soda)
		SMODS.insert_pool(p, G.P_CENTERS.j_ortalab_popcorn_bag)
		SMODS.insert_pool(p, G.P_CENTERS.j_ortalab_salad)
		PTASaka.added_ortalab_food_jokers = true
	end

	G.GAME.payasaka_reward_tarot_rate = G.GAME.payasaka_reward_tarot_rate or 0.025
end

-- Custom G.GAME stuff
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	-- Risk card stuff
	ret.risk_cards_risks = {}
	ret.payasaka_risk_objects = {}
	ret.risk_cards_rewards = {}
	-- Pyroxenes
	ret.payasaka_pyroxenes = 0
	-- Exponentials
	ret.payasaka_exponential_count = 0
	-- LAB=01
	ret.payasaka_lab_joker_ids = {}
	-- Cast
	ret.payasaka_cast_joker_ids = {}
	-- Irisu
	ret.payasaka_irisu_ids = {}


	-- Custom Modded pool stuff
	ret.payasaka_modded_rate = 0
	ret.payasaka_reward_tarot_rate = 0.025

	if G and G.STAGE == G.STAGES.RUN then
		-- -- Shuffle gacha table
		-- local function shuffle(tbl)
		-- 	for i = #tbl, 2, -1 do
		-- 		local j = pseudorandom('gacha_fuck_you', i)
		-- 		tbl[i], tbl[j] = tbl[j], tbl[i]
		-- 	end
		-- end
		-- shuffle(PTASaka.gacha_rarity_table)

		-- ret.payasaka_gacha_rarity_table = PTASaka.gacha_rarity_table
		ret.payasaka_aliased_gacha_table = PTASaka.create_alias_table(PTASaka.gacha_rarity_table)
		--print(ret.payasaka_aliased_gacha_table)
	end

	return ret
end

PTASaka.DeclineBlacklist = {
	["Tag"] = true,
	["Stake"] = true,
	["Unique"] = true,
	["Seal"] = true,
	["Sticker"] = true,
	["Edition"] = true,
	["Default"] = true,
	["Enhanced"] = true,
}

if Entropy and Entropy.ParakmiBlacklist then
	Entropy.ChaosBlacklist["PTASet"] = true
	Entropy.ParakmiBlacklist["PTASet"] = true
	PTASaka.FH.merge(PTASaka.DeclineBlacklist, Entropy.ParakmiBlacklist)
end

-- for Voucher of Equilibrium
local old_get_current_pool = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append, ...)
	-- If we have Parakmi we don't really need to do anything else...
	if PTASaka.DeclineBlacklist[_type] or next(SMODS.find_card('j_entr_parakmi')) then
		return old_get_current_pool(_type,
			_rarity, _legendary, _append, ...)
	end
	if (_type ~= "Joker" and not G.GAME.used_vouchers["v_payasaka_parakmi"]) or not G.GAME.used_vouchers["v_payasaka_equilibrium"] then
		return old_get_current_pool(_type,
			_rarity, _legendary, _append, ...)
	end
	local pool_items = {}
	local valid_pools = { _type }
	if G.GAME.used_vouchers["v_payasaka_parakmi"] then
		-- Hell on earth.
		valid_pools = {
			"Joker",
			"Consumeables",
			"Voucher",
			"Back",
		}
		if CardSleeves then valid_pools[#valid_pools + 1] = "Sleeve" end
	end
	for _, pool in ipairs(valid_pools) do
		for _, v in pairs(G.P_CENTER_POOLS[pool]) do
			local in_pool, pool_opts
			if v.in_pool and type(v.in_pool) == 'function' then
				in_pool, pool_opts = v:in_pool({ source = _append })
			end
			if v.unlocked
				and not v.no_doe
				and (in_pool or not v.in_pool)
				and not PTASaka.DeclineBlacklist[v.key]
				and not G.GAME.banned_keys[v.key] then
				pool_items[#pool_items + 1] = v.key
			end
		end
	end
	if not next(pool_items) then pool_items[#pool_items + 1] = "j_joker" end
	return pool_items, "payasaka_equilibrium" .. G.GAME.round_resets.ante
end

-- Trigger vanilla back effects
local old_trigger = Back.trigger_effect
function Back:trigger_effect(args)
	local o = { old_trigger(self, args) }
	if not args then return o and unpack(o) or nil end

	if G.GAME.used_vouchers["b_anaglyph"] and args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
		G.E_MANAGER:add_event(Event({
			func = (function()
				add_tag(Tag('tag_double'))
				play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
				play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
				return true
			end)
		}))
	end
	-- No need to retrigger the plasma deck effect twice, idiot
	if G.GAME.used_vouchers["b_plasma"] and args.context == 'final_scoring_step' and self.name ~= 'Plasma Deck' then
		local new_chips, new_mult = unpack(o)
		args.chips, args.mult = new_chips or args.chips, new_mult or args.mult
		local tot = args.chips + args.mult
		args.chips = math.floor(tot / 2)
		args.mult = math.floor(tot / 2)
		update_hand_text({ delay = 0 }, { mult = args.mult, chips = args.chips })

		G.E_MANAGER:add_event(Event({
			func = (function()
				local text = localize('k_balanced')
				play_sound('gong', 0.94, 0.3)
				play_sound('gong', 0.94 * 1.5, 0.2)
				play_sound('tarot1', 1.5)
				ease_colour(G.C.UI_CHIPS, { 0.8, 0.45, 0.85, 1 })
				ease_colour(G.C.UI_MULT, { 0.8, 0.45, 0.85, 1 })
				attention_text({
					scale = 1.4, text = text, hold = 2, align = 'cm', offset = { x = 0, y = -2.7 }, major = G.play
				})
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					blocking = false,
					delay = 4.3,
					func = (function()
						ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
						ease_colour(G.C.UI_MULT, G.C.RED, 2)
						return true
					end)
				}))
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					blocking = false,
					no_delete = true,
					delay = 6.3,
					func = (function()
						G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2],
							G.C.BLUE[3], G.C.BLUE[4]
						G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2],
							G.C.RED[3], G.C.RED[4]
						return true
					end)
				}))
				return true
			end)
		}))

		delay(0.6)
	end

	-- Handle multiple deck calculates for back specific trigger effects
	-- Code mostly taken from CardSleeves (https://github.com/larswijn/CardSleeves/blob/main/CardSleeves.lua#L1853)
	if G.GAME.payasaka_used_decks then
		for back, _ in pairs(G.GAME.payasaka_used_decks) do
			---@class SMODS.Back
			local obj = G.P_CENTERS[back]
			if args.context == "final_scoring_step" then
				local new_chips, new_mult = unpack(o)
				args.chips, args.mult = new_chips or args.chips, new_mult or args.mult
				if obj.calculate and type(obj.calculate) == "function" then
					new_chips, new_mult = obj:calculate(obj, args)
				elseif obj.trigger_effect and type(obj.trigger_effect) == "function" then
					-- support old deprecated trigger_effect
					new_chips, new_mult = obj:trigger_effect(args)
				end
				args.chips, args.mult = new_chips or args.chips, new_mult or args.mult
			elseif type(obj.calculate) == "function" and type(args.context) == "string" then
				local context = type(args.context) == "table" and args.context or
				args                                                       -- bit hacky, though this shouldn't even have to be used?
				local effect = obj:calculate(obj, context)
				if effect then
					SMODS.calculate_effect(effect, G.deck.cards[1] or G.deck)
				end
			elseif obj.trigger_effect and type(obj.trigger_effect) == "function" then
				-- support old deprecated trigger_effect
				obj:trigger_effect(args)
			end
		end
	end
	if G.GAME.payasaka_used_sleeves then
		for back, _ in pairs(G.GAME.payasaka_used_sleeves) do
			---@class SMODS.Back
			local obj = G.P_CENTERS[back]
			if args.context == "final_scoring_step" then
				local new_chips, new_mult = unpack(o)
				args.chips, args.mult = new_chips or args.chips, new_mult or args.mult
				if obj.calculate and type(obj.calculate) == "function" then
					new_chips, new_mult = obj:calculate(obj, args)
				elseif obj.trigger_effect and type(obj.trigger_effect) == "function" then
					-- support old deprecated trigger_effect
					new_chips, new_mult = obj:trigger_effect(args)
				end
				args.chips, args.mult = new_chips or args.chips, new_mult or args.mult
			elseif type(obj.calculate) == "function" and type(args.context) == "string" then
				local context = type(args.context) == "table" and args.context or
				args                                                       -- bit hacky, though this shouldn't even have to be used?
				local effect = obj:calculate(obj, context)
				if effect then
					SMODS.calculate_effect(effect, G.deck.cards[1] or G.deck)
				end
			elseif obj.trigger_effect and type(obj.trigger_effect) == "function" then
				-- support old deprecated trigger_effect
				obj:trigger_effect(args)
			end
		end
	end
	if args.context == "final_scoring_step" then
		return args.chips, args.mult
	end
	return unpack(o)
end

local g_c_a_ref = SMODS.get_card_areas
function SMODS.get_card_areas(_type, context)
	local ret = g_c_a_ref(_type, context)

	if _type == "individual" then
		for back, _ in pairs(G.GAME.payasaka_used_decks or {}) do
			local fake_back = setmetatable({}, {
				__index = G.P_CENTERS[back]
			})
			function fake_back:calculate(c)
				G.P_CENTERS[back].center = G.P_CENTERS[back]
				local fake = { name = G.P_CENTERS[back].name, effect = G.P_CENTERS[back] }
				return Back.trigger_effect(fake, c)
			end

			-- Very annoying.
			---@diagnostic disable-next-line: missing-fields
			ret[#ret + 1] = {
				object = fake_back,
				scored_card = G.deck.cards[1] or G.deck
			}
		end
		for sleeve, _ in pairs(G.GAME.payasaka_used_sleeves or {}) do
			local center = G.P_CENTERS[sleeve]
			if center and center.calculate and type(center.calculate) == "function" then
				local fake_sleeve = setmetatable({}, {
					__index = center
				})
				function fake_sleeve:calculate(c)
					return center:calculate(center, c)
				end

				-- Very annoying.
				---@diagnostic disable-next-line: missing-fields
				ret[#ret + 1] = {
					object = fake_sleeve,
					scored_card = G.deck.cards[1] or G.deck
				}
			end
		end
	end

	return ret
end

local dc = discover_card
function discover_card(card)
	card = card or {}
	local old_discovered = card.discovered
	dc(card)
	if old_discovered then return end
	PTASaka.discovered_modded_jokers = 0
	for k, v in pairs(G.P_CENTERS) do
		if v.set and v.set == "Joker" and v.mod and v.discovered then
			PTASaka.discovered_modded_jokers = PTASaka.discovered_modded_jokers + 1
		end
	end
end

-- Make Ahead cards ALWAYS foil + other stuff
local old_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	if _type == "Back" or _type == "Sleeve" then
		forced_key = pseudorandom_element(G.P_CENTER_POOLS[_type], "ptadeckshit_" .. (key_append or "")).key
	end
	local spawned_via_hidden = false
	if not forced_key and soulable then
		for _, v in ipairs(PTASaka.Reward.pseudo_legendaries) do
			if (_type == v.pta_hidden_set) and not (G.GAME.used_jokers[v.key] and not SMODS.showman(v.key) and not v.can_repeat_soul) and (not v.in_pool or (type(v.in_pool) ~= "function") or v:in_pool()) then
				if pseudorandom('hidden_'..v.key.._type..G.GAME.round_resets.ante) < (G.GAME["payasaka_reward_"..string.lower(v.pta_hidden_set).."_rate"] or 0) then
					forced_key = v.key
					spawned_via_hidden = true
				end
			end
		end
	end
	---@type Card
	local card = old_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	if card and card.config.center.rarity == "payasaka_ahead" and card.config.center.key ~= "j_payasaka_nil" then
		card:set_edition("e_foil", true, nil)
	end
	if card and card.config.center.pta_hidden_pos and spawned_via_hidden and card.ability then
		card.ability.pta_hidden_spawned = true
		--print("reset sprites")
		card:set_sprites(card.config.center)
		--card.ability.pta_hidden_spawned = nil
	end
	return card
end

-- Blow cartridge joker out at the end of round
local er = end_round
function end_round()
	er()
	local cartridges = SMODS.find_card("j_payasaka_cartridge", true)
	if not next(cartridges) then return end
	G.E_MANAGER:add_event(Event {
		func = function()
			for _, cartridge in ipairs(cartridges) do
				if cartridge.debuff then
					card_eval_status_text(cartridge, 'extra', nil, nil, nil, {
						message = "Blown!",
						extrafunc = function()
							cartridge:set_debuff(false)
						end
					})
				end
			end
			return true
		end
	})
end

-- Let Max Headroom do funny stuff when obtaining a consumable
local old_set_ability = Card.set_ability
function Card:set_ability(center, ...)
	old_set_ability(self, center, ...)
	local headrooms = SMODS.find_card("j_payasaka_maxheadroom")
	if center.consumeable and next(headrooms) then
		-- Prevent the original from being misprinted TWICE
		if type(self.ability.consumeable) == "table" then
			self.ability.consumeable = copy_table(center.config)
		end
		for _, headroom in ipairs(headrooms) do
			self.ability = PTASaka.MMisprintize(self.ability, headroom.ability.extra.amt, nil, nil, function(v, a)
				return v + a
			end, PTASaka.headroom_whitelist)
		end
	end
	if self.ability and self.ability.mimic_card then
		self.ability.mimic_card = nil
	end
end

local old_get_id = Card.get_id
function Card:get_id()
	if SMODS.has_enhancement(self, "m_payasaka_mimic") and self.area and (self.area == G.hand or self.area == G.play) then
		-- get left card
		for i = 1, #self.area.cards do
			---@type Card
			local c = self.area.cards[i]
			if c == self and self.area.cards[i-1] then
				return self.area.cards[i-1]:get_id()
			end
		end
	end
	return old_get_id(self)
end

local old_is_suit = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
	if not flush_calc then
		if self.debuff and not bypass_debuff then return end
	end
	if SMODS.has_enhancement(self, "m_payasaka_mimic") and self.area and (self.area == G.hand or self.area == G.play) then
		-- get left card
		for i = 1, #self.area.cards do
			---@type Card
			local c = self.area.cards[i]
			if c == self and self.area.cards[i-1] then
				return self.area.cards[i-1]:is_suit(suit, bypass_debuff, flush_calc)
			end
		end
	end
	return old_is_suit(self, suit, bypass_debuff, flush_calc)
end

local function find_joker_by_sort_id(id)
	for _, area in ipairs(SMODS.get_card_areas('jokers')) do
		if area.cards then
			for i = 1, #area.cards do
				if area.cards[i].sort_id == id then
					return area.cards[i]
				end
			end
		end
	end
	return nil
end

-- Hook to change card juiced in text notifications for adult card
local cest = card_eval_status_text
function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
	if G.STAGE == G.STAGES.RUN and PTASaka.adultcard_cardarea and PTASaka.adultcard_cardarea.cards[1] and card.area == PTASaka.adultcard_cardarea and PTASaka.adultcard_cardarea.pta_owner then
		--PTASaka.adultcard_cardarea.T.x = PTASaka.adultcard_cardarea.pta_owner.VT.x
		card = PTASaka.adultcard_cardarea.pta_owner
	end
	if G.STAGE == G.STAGES.RUN and card and card.area and card.area.config.joker_parent then
		card = find_joker_by_sort_id(card.area.config.joker_parent) or card
	end
	cest(card, eval_type, amt, percent, dir, extra)
end

-- Hook to change general juice up calls to the current owner of le card for adult card
local juice = Card.juice_up
function Card:juice_up(m, m2)
	local c = self
	if G.STAGE == G.STAGES.RUN and PTASaka.adultcard_cardarea and PTASaka.adultcard_cardarea.cards[1] and c.area == PTASaka.adultcard_cardarea and PTASaka.adultcard_cardarea.pta_owner and c ~= PTASaka.adultcard_cardarea.pta_owner then
		--PTASaka.adultcard_cardarea.T.x = PTASaka.adultcard_cardarea.pta_owner.VT.x
		c = PTASaka.adultcard_cardarea.pta_owner
	end
	if G.STAGE == G.STAGES.RUN and c.area and c.area.config.joker_parent then
		c = find_joker_by_sort_id(c.area.config.joker_parent) or c
	end
	juice(c, m, m2)
end

-- Hook to find cards in PTASaka.adultcard_cardarea and LAB=01's cardarea(s)
local find_old = SMODS.find_card
function SMODS.find_card(key, count_debuffed)
	local ret = find_old(key, count_debuffed)

	for k, _ in pairs(G.GAME.payasaka_lab_joker_ids or {}) do
		if G["payasaka_lab_jokers_" .. tostring(k)] and G["payasaka_lab_jokers_" .. tostring(k)].cards then
			for _, v in ipairs(G["payasaka_lab_jokers_" .. tostring(k)].cards) do
				if v and type(v) == 'table' and v.config.center.key == key and (count_debuffed or not v.debuff) then
					ret[#ret + 1] = v
				end
			end
		end
	end

	for k, _ in pairs(G.GAME.payasaka_cast_joker_ids or {}) do
		if G["payasaka_cast_jokers_" .. tostring(k)] and G["payasaka_cast_jokers_" .. tostring(k)].cards then
			for _, v in ipairs(G["payasaka_cast_jokers_" .. tostring(k)].cards) do
				if v and type(v) == 'table' and v.config.center.key == key and (count_debuffed or not v.debuff) then
					ret[#ret + 1] = v
				end
			end
		end
	end

	for k, _ in pairs(G.GAME.payasaka_irisu_ids or {}) do
		if G["payasaka_irisu_" .. tostring(k)] and G["payasaka_irisu_" .. tostring(k)].cards then
			for _, v in ipairs(G["payasaka_irisu_" .. tostring(k)].cards) do
				if v and type(v) == 'table' and v.config.center.key == key and (count_debuffed or not v.debuff) then
					ret[#ret + 1] = v
				end
			end
		end
	end

	if not PTASaka.adultcard_cardarea then return ret end
	if not PTASaka.adultcard_cardarea.cards then return ret end
	if not PTASaka.adultcard_cardarea.cards[1] then return ret end

	for _, v in ipairs(PTASaka.adultcard_cardarea.cards) do
		if v and type(v) == 'table' and v.config.center.key == key and (count_debuffed or not v.debuff) then
			ret[#ret + 1] = v
		end
	end

	return ret
end

local find_joker_ref = find_joker
function find_joker(name, count_debuffed)
	local ret = find_joker_ref(name, count_debuffed) or {}
	for k, _ in pairs(G.GAME.payasaka_irisu_ids or {}) do
		if G["payasaka_irisu_" .. tostring(k)] and G["payasaka_irisu_" .. tostring(k)].cards then
			for _, v in pairs(G["payasaka_irisu_" .. tostring(k)].cards) do
				if v and type(v) == 'table' and v.ability.name == name and (count_debuffed or not v.debuff) then
					table.insert(ret, v)
				end
			end
		end
	end
	return ret
end

-- Selling a card while Adult Card is present
local sell = Card.sell_card
function Card:sell_card()
	sell(self)
	-- Not a joker....
	if self.ability.set ~= "Joker" then return end
	pcall(function() G.GAME.payasaka_last_sold_joker = self.config.center_key end)
	if self.ability.name == "Adult Card" then return end -- No.
	if self.ability.name == "payasaka_nil" then return end -- No!
	-- We don have it yet!
	local wehavit = false
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i].ability.name == "Adult Card" then
			wehavit = true
			break
		end
	end
	if not wehavit then return end
	G.E_MANAGER:add_event(Event({
		delay = 0.8,
		func = function()
			local new_joker = PTASaka.deep_copy(self)
			PTASaka.adultcard_cardarea.config.card_limit = PTASaka.adultcard_cardarea.config.card_limit + 1
			--G.jokers:remove_card(self)
			PTASaka.adultcard_cardarea:emplace(new_joker)
			new_joker:add_to_deck()
			-- Prioritize sold card
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].ability.name == "Adult Card" then
					G.jokers.cards[i].ability.extra.next_joker = #PTASaka.adultcard_cardarea.cards
					card_eval_status_text(G.jokers.cards[i], 'extra', nil, nil, nil,
						{ message = localize('k_payasaka_added_ex') })
				end
			end
			return true
		end
	}))
end

local draw_base = Card.should_draw_base_shader
function Card:should_draw_base_shader()
	if self.config.center_key == "v_payasaka_tmtrainer" or self.config.center_key == "v_payasaka_cooltrainer" then
		return false
	end
	if self.ability.status_payasaka_zzazz then
		return false
	end
	return draw_base(self)
end

-- Individual effects....
local whitelisted_keys = {
	["chips"] = 'chips',
	["h_chips"] = 'chips',
	["chip_mod"] = 'chips',
	["mult"] = 'mult',
	["h_mult"] = 'mult',
	["mult_mod"] = 'mult',
	["dollars"] = 'dollars',
	["h_dollars"] = 'dollars',
	["p_dollars"] = 'dollars',
	["xchips"] = 'xchips',
	["x_chips"] = 'xchips',
	["Xchip_mod"] = 'xchips',
	["xmult"] = 'xmult',
	["x_mult"] = 'xmult',
	["Xmult_mod"] = 'xmult',
	["x_mult_mod"] = 'xmult',
	["Xmult"] = 'xmult',
	["echips"] = 'echips',
	["e_chips"] = 'echips',
	["Echip_mod"] = 'echips',
	["emult"] = 'emult',
	["e_mult"] = 'emult',
	["Emult_mod"] = 'emult',
	["eechips"] = 'eechips',
	["ee_chips"] = 'eechips',
	["EEchip_mod"] = 'eechips',
	["eemult"] = 'eemult',
	["ee_mult"] = 'eemult',
	["EEmult_mod"] = 'eemult',
	["eeechips"] = 'eeechips',
	["eee_chips"] = 'eeechips',
	["EEEchip_mod"] = 'eeechips',
	["eeemult"] = 'eeemult',
	["eee_mult"] = 'eeemult',
	["EEEmult_mod"] = 'eeemult',
}

local pulmenti_redirect = {
	['chips'] = 'x_chips',
	['mult'] = 'x_mult',
	['xchips'] = 'e_chips',
	['xmult'] = 'e_mult',
	['emult'] = 'ee_mult',
	['echips'] = 'ee_chips',
}

-- Insert dummy repetitions in here
table.insert(SMODS.calculation_keys, 1, "fake_repetitions")
-- Same with these, for enotsworrA and Phil
table.insert(SMODS.calculation_keys, 1, "pf_chips")
table.insert(SMODS.calculation_keys, 1, "pfchips")
table.insert(SMODS.calculation_keys, 1, "pf_mult")
table.insert(SMODS.calculation_keys, 1, "pfmult")
table.insert(SMODS.calculation_keys, 1, "pf_chips_mult")
-- exponential stuff for paya
SMODS.calculation_keys[#SMODS.calculation_keys+1] = "e_chips"
SMODS.calculation_keys[#SMODS.calculation_keys+1] = "e_mult"
SMODS.calculation_keys[#SMODS.calculation_keys+1] = "pta_balance"

local calculate_individual_effect_hook = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
	-- For Aww! No Retriggers....
	if key == "fake_repetitions" and PTASaka.stop_you_are_violating_the_law then
		card_eval_status_text(PTASaka.stop_you_are_violating_the_law, 'extra', nil, nil, nil, {
			message = localize('k_nope_ex'),
			colour = G.C.PURPLE,
			sound = "payasaka_coolgong"
		})
		local rand = pseudorandom('aww_random_effect', 1, 3)
		if rand == 1 and amount then
			if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
			mult = mod_mult(mult * amount)
			update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
			card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus,
				'x_mult', amount, percent)
		elseif rand == 2 and amount then
			if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
			hand_chips = mod_chips(hand_chips * amount)
			update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
			card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus,
				'x_chips', amount, percent)
		elseif rand == 3 and amount then
			if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
			ease_dollars(amount)
			card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus,
				'dollars', amount, percent)
		end
		return true
	end

	if amount and is_number(amount) and to_big(amount) > to_big(0) and PTASaka.pulmenti_count and pulmenti_redirect[whitelisted_keys[key]] then
		for i = 1, PTASaka.pulmenti_count do
			if pulmenti_redirect[whitelisted_keys[key]] then
				key = pulmenti_redirect[whitelisted_keys[key]]
			end
		end
	end

	if (key == 'e_chips') and amount ~= 1 and not Talisman then
		if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
		hand_chips = mod_chips(hand_chips ^ amount)
		update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
		if not effect.remove_default_message then
			if from_edition then
				card_eval_status_text(scored_card, 'jokers', nil, percent, nil,
					{ message = ('^%s Chips'):format(number_format(amount)), colour = G.C.DARK_EDITION, edition = true })
			else
				if effect.echip_message then
					card_eval_status_text(
					effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil,
						percent, nil, effect.echip_message)
				else
					card_eval_status_text(
					effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil,
						percent, nil,
						{ message = ('^%s Chips'):format(number_format(amount)), sound = "payasaka_echips", colour = G.C.DARK_EDITION })
				end
			end
		end
		return true
	end

	if (key == 'e_mult') and amount ~= 1 and not Talisman then
		if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
		mult = mod_mult(mult ^ amount)
		update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
		if not effect.remove_default_message then
			if from_edition then
				card_eval_status_text(scored_card, 'jokers', nil, percent, nil,
					{ message = ('^%s Mult'):format(number_format(amount)), colour = G.C.DARK_EDITION, edition = true })
			else
				if effect.emult_message then
					card_eval_status_text(
					effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil,
						percent, nil, effect.emult_message)
				else
					card_eval_status_text(
					effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil,
						percent, nil,
						{ message = ('^%s Mult'):format(number_format(amount)), sound = "payasaka_emult", colour = G.C.DARK_EDITION })
				end
			end
		end
		return true
	end

	if (key == 'ee_chips') and amount ~= 1 and not Talisman then
		if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
		hand_chips = mod_chips(hand_chips ^ (hand_chips ^ (amount - 1)))
		update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
		if not effect.remove_default_message then
			if from_edition then
				card_eval_status_text(scored_card, 'jokers', nil, percent, nil,
					{ message = ('^^%s Chips'):format(number_format(amount)), colour = G.C.DARK_EDITION, edition = true })
			else
				if effect.echip_message then
					card_eval_status_text(
					effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil,
						percent, nil, effect.echip_message)
				else
					card_eval_status_text(
					effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil,
						percent, nil,
						{ message = ('^^%s Chips'):format(number_format(amount)), sound = "payasaka_eechips", colour = G.C.DARK_EDITION })
				end
			end
		end
		return true
	end

	if (key == 'ee_mult') and amount ~= 1 and not Talisman then
		if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
		mult = mod_mult(mult ^ (mult ^ (amount - 1)))
		update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
		if not effect.remove_default_message then
			if from_edition then
				card_eval_status_text(scored_card, 'jokers', nil, percent, nil,
					{ message = ('^%s Mult'):format(number_format(amount)), colour = G.C.DARK_EDITION, edition = true })
			else
				if effect.emult_message then
					card_eval_status_text(
					effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil,
						percent, nil, effect.emult_message)
				else
					card_eval_status_text(
					effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil,
						percent, nil,
						{ message = ('^^%s Mult'):format(number_format(amount)), sound = "payasaka_eemult", colour = G.C.DARK_EDITION })
				end
			end
		end
		return true
	end

	if key == 'pta_balance' and amount then
        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
		local balance_chips = mod_chips(hand_chips * amount)
		local balance_mult = mod_mult(mult * amount)
		local avg = (balance_chips + balance_mult) / 2
		hand_chips = hand_chips + (avg - balance_chips)
        mult = mult + (avg - balance_mult)
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
        G.E_MANAGER:add_event(Event({
            func = (function()
                -- scored_card:juice_up()
                play_sound('gong', 0.94, 0.3)
                play_sound('gong', 0.94*1.5, 0.2)
                play_sound('tarot1', 1.5)
                ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
                ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    blocking = false,
                    delay =  0.8,
                    func = (function() 
                            ease_colour(G.C.UI_CHIPS, G.C.BLUE, 0.8)
                            ease_colour(G.C.UI_MULT, G.C.RED, 0.8)
                        return true
                    end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    blocking = false,
                    no_delete = true,
                    delay =  1.3,
                    func = (function() 
                        G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                        G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                        return true
                    end)
                }))
                return true
            end)
        }))
        if not effect.remove_default_message then
            if effect.balance_message then
                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.balance_message)
            else
                card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, {message = localize('k_balanced'), colour =  {0.8, 0.45, 0.85, 1}})
            end
        end

        return true
    end

	-- Phil and enotsworrA
	if key == "pf_chips" or key == "pfchips" then
		hand_chips = amount(hand_chips)
		update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
		return true
	elseif key == "pf_mult" or key == "pfmult" then
		mult = amount(mult)
		update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
		return true
	elseif key == "pf_chips_mult" then
		hand_chips, mult = amount(hand_chips, mult)
		update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
		return true
	end

	local ret = calculate_individual_effect_hook(effect, scored_card, key, amount, from_edition)
	if amount and is_number(amount) and to_big(amount) > to_big(0) and PTASaka.recuperares and next(PTASaka.recuperares) and whitelisted_keys[key] and ret then
		for k, joker in ipairs(PTASaka.recuperares) do
			local e = joker.ability.extra
			if joker ~= scored_card then
				e[whitelisted_keys[key]] = e[whitelisted_keys[key]] + amount
				card_eval_status_text(joker, 'extra', nil, percent, nil, { message = localize('k_upgrade_ex') })
			end
		end
	end
	return ret
end

-- Doing this the hook way since using smods' native set_sprites BREAKS soul sprites for some reason
local set_spritesref = Card.set_sprites
function Card:set_sprites(center, front)
	set_spritesref(self, center, front)
	if center and center.pta_front_pos then
		self.children.pta_front = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[center.atlas or center.set],
			center.pta_front_pos
		)
		self.children.pta_front.role.draw_major = self
		self.children.pta_front.states.hover.can = false
		self.children.pta_front.states.click.can = false
	end
	if center and center.key == 'c_payasaka_gacha' then
		self.children.gacha_layer = Sprite(
			self.T.x,
			self.T.y,
			self.T.w * (85 / 71),
			self.T.h,
			G.ASSET_ATLAS["payasaka_JOE_Tarots_Adjust"],
			{ x = 0, y = 2 }
		)
		self.children.gacha_layer.role.draw_major = self
		self.children.gacha_layer.states.hover.can = false
		self.children.gacha_layer.states.click.can = false
	end
	if center and center.set == "Property" then
		self.children.property_houses = Sprite(
			self.T.x,
			self.T.y,
			self.T.w,
			self.T.h,
			G.ASSET_ATLAS[center.atlas or center.set],
			center.pos
		)
		self.children.property_houses.role.draw_major = self
		self.children.property_houses.states.hover.can = false
		self.children.property_houses.states.click.can = false
	end
	if self and self.ability and self.ability.pta_hidden_spawned and center and center.pta_hidden_pos and self.children.center then
		self.children.center:set_sprite_pos(center.pta_hidden_pos)
	end
end

local old_can_use = Card.can_use_consumeable
function Card:can_use_consumeable(any, skip)
	if not skip and ((G.play and #G.play.cards > 0) or
			(G.CONTROLLER.locked) or
			(G.GAME.STOP_USE and G.GAME.STOP_USE > 0))
	then
		return false
	end
	local ret = old_can_use(self, any, skip)
	if self.config.center.pta_usable then
		ret = self.config.center.can_use(self.config.center, self)
	end
	return ret
end

-- Deep find a key with the word "chip" on it for Fanhead to detect it is a chip joker
local function find_chips_n_shit(ret)
	for k, v in pairs(ret or {}) do
		if v and type(v) == "table" then
			return find_chips_n_shit(v)
		else
			if k and type(k) == "string" and k:match("chip") and (not k:match("message")) and v then
				return true
			end
		end
	end
	return false
end

-- Fanhead chip detection
local old_eval_card = eval_card
function eval_card(card, context, ...)
	local ret, post = old_eval_card(card, context, ...)
	if context.end_of_round then
		card.ability.payasaka_chip_joker = false
	end
	-- Set this as a chip joker
	if ret and type(ret) == "table" and next(ret) and card.ability.set == "Joker" then
		if find_chips_n_shit(ret) then
			card.ability.payasaka_chip_joker = true
		end
	end
	return ret, post
end

-- Handle Cyan planet card effects
local oldluh = level_up_hand
---@param card Card|nil
---@param hand string
---@param instant boolean|nil
---@param amount number
function level_up_hand(card, hand, instant, amount, ...)
	local ret = {}
	SMODS.calculate_context({
		payasaka_level_up_before = true,
		other_card = card,
		scoring_name = hand,
		poker_hand = G
			.GAME.hands[hand],
		instant = instant,
		level_amount = amount,
	}, ret)
	if next(ret) then SMODS.trigger_effects(ret, card) end
	oldluh(card, hand, instant, amount, ...); ret = {}
	SMODS.calculate_context({
		payasaka_level_up_after = true,
		other_card = card,
		scoring_name = hand,
		poker_hand = G
			.GAME.hands[hand],
		instant = instant,
		level_amount = amount,
	}, ret)
	if next(ret) then SMODS.trigger_effects(ret, card) end
end

-- Deep Deck Diver's discard effects
local gfcr = G.FUNCS.can_discard
G.FUNCS.can_discard = function(e)
	local can_deep = next(find_joker('Deep Deck Diver'))
	if can_deep then
		---@type Card
		local diver = find_joker('Deep Deck Diver')[1]
		can_deep = can_deep and
			not (to_big(G.GAME.dollars - G.GAME.bankrupt_at) - to_big(diver.ability.extra.cost or 0) < to_big(0))
	end
	if ((G.GAME.current_round.discards_left or 0) <= 0 and can_deep) and #G.hand.highlighted > 0 then
		e.config.colour = G.C.RED
		e.config.button = 'discard_cards_from_highlighted'
	else
		gfcr(e)
	end
end

-- Accept dos card buy space
local cfbs = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
	if card.ability.set == 'DOSCard' and not (#PTASaka.dos_cardarea.cards < PTASaka.dos_cardarea.config.card_limit + (card.edition and card.edition.card_limit or 0)) then
		alert_no_space(card, PTASaka.dos_cardarea)
		return false
	elseif card.ability.set == 'DOSCard' then
		return true
	end
	return cfbs(card)
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

-- DOS Card flip mechanics
local u = CardArea.align_cards
function CardArea:align_cards()
	-- Winton, disable alignment
	if self.payasaka_disable_alignment then
		if self.config.type == 'play' or self.config.type == 'shop' then
			local cnt = 0
			local n_cnt = 0
			for k, card in ipairs(self.cards) do
				if not card.payasaka_winton_spawned_aligned then
					cnt = cnt + 1
				else
					n_cnt = n_cnt + 1
				end
			end
			for k, card in ipairs(self.cards) do
				if not card.states.drag.is then
					card.T.r = 0
					-- stupid hack
					local max_cards = 5
					if cnt >= 5 then
						max_cards = cnt
					end
					card.T.x = self.T.x +
						(self.T.w - self.card_w) *
						((k - 1) / math.max(max_cards - 1, 1) - 0.5 * (cnt - max_cards) / math.max(max_cards - 1, 1)) +
						0.5 * (self.card_w - card.T.w) +
						(self.config.card_limit == 1 and 0.5 * (self.T.w - card.T.w) or 0)
					local highlight_height = G.HIGHLIGHT_H
					if not card.highlighted then highlight_height = 0 end
					card.T.y = self.T.y + self.T.h / 2 - card.T.h / 2 - highlight_height
					card.T.x = card.T.x + card.shadow_parrallax.x / 30
				end
			end
			--table.sort(self.cards, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
		end
		return
	end
	if self ~= PTASaka.dos_cardarea then return u(self) end
	u(self)
	for k, card in ipairs(self.cards) do
		card.rank = k
	end
	local deck_height = (self.config.deck_height or -0.15) / self.config.card_limit
	for k, card in ipairs(self.cards) do
		-- override rotation
		card.T.r = 0 + 0.3 * self.shuffle_amt * (1 + k * 0.05) * (k % 2 == 1 and 1 or -0)
		card.T.y = card.T.y + deck_height * k
		if not card.states.drag.can then goto continue end
		if card.facing == 'front' and not card.states.drag.is and k ~= #self.cards then
			card:flip()
		elseif card.facing == 'back' and k == #self.cards then
			card:flip()
		end
		::continue::
	end
end

-- mmmyeah
local up = CardArea.update
function CardArea:update(dt)
	up(self, dt)
	if self ~= PTASaka.dos_cardarea then return end
	--self.states.hover.can = self.states.collide.can
	if self.disabled or (G.play and #G.play.cards > 0) or
		(G.CONTROLLER.locked) or
		(G.GAME.STOP_USE and G.GAME.STOP_USE > 0) then
		for k, card in ipairs(self.cards) do
			card.states.drag.can = false
			card.states.click.can = false
		end
		PTASaka.dos_enabled_string = 'Active!'
		--print("hiii")
	else
		for k, card in ipairs(self.cards) do
			card.states.drag.can = true
			card.states.click.can = true
		end
		PTASaka.dos_enabled_string = 'Inactive!'
		--print("noooo")
	end
end

-- yeah
local c_up = Card.update
function Card:update(dt)
	if self.area then
		-- Annoying fix for Jokers that remove their area for Vash/Manhattan Cafe
		self.old_area = self.area
	end
	return c_up(self, dt)
end

-- Round evaluation stuff
local update_round_evalref = Game.update_round_eval
function Game:update_round_eval(dt)
	update_round_evalref(self, dt)

	for k, card in ipairs(PTASaka.dos_cardarea.cards) do
		if card.ability.payasaka_exclamation_point then
			card:set_ability(G.P_CENTERS["c_payasaka_dos_exclam"])
			card:juice_up()
			card.ability.payasaka_exclamation_point = false
			PTASaka.dos_cardarea.disabled = false
		end
	end
	G.payasaka_exclamation_point = {}
end

-- Hooks for various pyroxene related consumables
local old_can_buy = G.FUNCS.can_buy
function G.FUNCS.can_buy(e)
	old_can_buy(e)
	if (e.config.ref_table.config and e.config.ref_table.config.center and e.config.ref_table.config.center.pyroxenes and e.config.ref_table.config.center.pyroxenes > G.GAME.payasaka_pyroxenes) and (e.config.ref_table.config.center.pyroxenes > 0) then
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	elseif (e.config.ref_table.config and e.config.ref_table.config.center and e.config.ref_table.config.center.pyroxenes) then
		e.config.colour = G.C.ORANGE
		e.config.button = 'buy_from_shop'
	end
end

local old_can_buy_and_use = G.FUNCS.can_buy_and_use
function G.FUNCS.can_buy_and_use(e)
	if (e.config.ref_table.config and e.config.ref_table.config.center and e.config.ref_table.config.center.pyroxenes and e.config.ref_table.config.center.pyroxenes > G.GAME.payasaka_pyroxenes) and (e.config.ref_table.config.center.pyroxenes > 0) then
		e.UIBox.states.visible = false
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else
		old_can_buy_and_use(e)
	end
end

local can_open = G.FUNCS.can_open
G.FUNCS.can_open = function(e)
	can_open(e)
	if (e.config.ref_table.config and e.config.ref_table.config.center and e.config.ref_table.config.center.pyroxenes and e.config.ref_table.config.center.pyroxenes > G.GAME.payasaka_pyroxenes) and (e.config.ref_table.config.center.pyroxenes > 0) then
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

-- No rerolling!
local reroll = G.FUNCS.reroll_boss
function G.FUNCS.reroll_boss(e)
	if G.GAME.payasaka_cannot_reroll then return end
	reroll(e)
end

-- Handle select button since I don't want to haggle with it
-- Also stuff for DOS cards too
local oldusb = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
	local ret = oldusb(card)
	if card and card.area == G.pack_cards and card.ability.consumeable and card.config.center.pta_selectable then
		return {
			n = G.UIT.ROOT,
			config = { padding = 0, colour = G.C.CLEAR },
			nodes = {
				{
					n = G.UIT.R,
					config = { ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5 * card.T.w - 0.15, maxw = 0.9 * card.T.w - 0.15, minh = 0.3 * card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'pta_can_select_consumable' },
					nodes = {
						{ n = G.UIT.T, config = { text = localize('b_select'), colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true } }
					}
				},
			}
		}
	end
	return ret
end

-- For TMTRAINER
local basegamesounds = {
	"button",
	"cancel",
	"card1",
	"card3",
	"cardFan2",
	"cardSlide1",
	"cardSlide2",
	"chips1",
	"chips2",
	"coin1",
	"coin2",
	"coin3",
	"coin4",
	"coin5",
	"coin6",
	"coin7",
	"crumple1",
	"crumple2",
	"crumple3",
	"crumple4",
	"crumple5",
	"crumpleLong1",
	"crumpleLong2",
	"crumpleLong2",
	"foil1",
	"foil2",
	"generic1",
	"glass1",
	"glass2",
	"glass3",
	"glass4",
	"glass5",
	"glass6",
	"gold_seal",
	"gong",
	"highlight1",
	"highlight2",
	"holo1",
	"magic_crumple",
	"magic_crumple2",
	"magic_crumple3",
	"multhit1",
	"multhit2",
	"negative",
	"other1",
	"paper1",
	"polychrome1",
	"slice1",
	"tarot1",
	"tarot2",
	"timpani",
	"whoosh",
	"whoosh1",
	"whoosh2",
}

-- Randomize shit for tmtrainer
local cached_sound_list = basegamesounds

local old_play_sound = play_sound
function play_sound(sound, per, vol)
	if cached_sound_list and not SMODS.Sounds[sound] and G.GAME.payasaka_tmtrainer_effects and string.sub(sound, 1, 7) ~= "ambient" and string.sub(sound, 1, 3) ~= "mus" and string.sub(sound, 1, 3) ~= "win" and string.sub(sound, 1, 9) ~= "explosion" and string.sub(sound, 1, 5) ~= "voice" and string.sub(sound, 1, 5) ~= "intro" and string.sub(sound, 1, 6) ~= "splash" then
		sound = cached_sound_list[math.random(1, #cached_sound_list)]
		return old_play_sound(sound, per, vol)
	end
	return old_play_sound(sound, per, vol)
end

local old_mod_chips = mod_chips
function mod_chips(_chips)
	_chips = _chips *
		pseudorandom("payasaka_tmtrainer_randomness", G.GAME.payasaka_tmtrainer_low_rnd or 1,
			G.GAME.payasaka_tmtrainer_high_rnd or 1)
	return old_mod_chips(_chips)
end

local old_mod_mult = mod_mult
function mod_mult(_mult)
	_mult = _mult *
		pseudorandom("payasaka_tmtrainer_randomness", G.GAME.payasaka_tmtrainer_low_rnd or 1,
			G.GAME.payasaka_tmtrainer_high_rnd or 1)
	return old_mod_mult(_mult)
end

local old_juice_up = Moveable.juice_up
function Moveable:juice_up(amt, rot)
	old_juice_up(self, amt, rot)
	-- Randomize juice amounts
	if not (self.juice and next(self.juice)) then return end
	self.juice.r_amt = (self.juice.r_amt or 0) *
		pseudorandom("payasaka_tmtrainer_vrandomness", G.GAME.payasaka_tmtrainer_low_rnd or 1,
			G.GAME.payasaka_tmtrainer_high_rnd or 1)
	self.juice.scale_amt = (self.juice.scale_amt or 0) *
		pseudorandom("payasaka_tmtrainer_vrandomness", G.GAME.payasaka_tmtrainer_low_rnd or 1,
			G.GAME.payasaka_tmtrainer_high_rnd or 1)
	self.VT.scale = (self.VT.scale or 1) *
		pseudorandom("payasaka_tmtrainer_vrandomness", G.GAME.payasaka_tmtrainer_low_rnd or 1,
			G.GAME.payasaka_tmtrainer_high_rnd or 1)
end

local cardHoverHook = Card.hover
function Card:hover()
	if self.area == PTASaka.adultcard_cardarea then return end
	PTASaka.current_hover_card = self
	local ret = cardHoverHook(self)
	return ret
end

-- Hook onto Card:click for mechanic menu and dos card menu
local old_click = Card.click
function Card:click()
	old_click(self)
	-- Mechanic
	if self.area and PTASaka.mechanic_menu then
		PTASaka.mechanic_selected_card = self.config.center.key
		PTASaka.mechanic_got_selected = true
		G.FUNCS.exit_overlay_menu()
	end
	-- DOS card menu
	if self.area and PTASaka.dos_menu then
		PTASaka.dos_selected_card = self.config.center.key
		PTASaka.dos_got_selected = true
		G.FUNCS.exit_overlay_menu()
	end
end

function PTASaka.use_joker(card, area, copier)
	stop_use()
	if card.debuff then return nil end
	local used_tarot = copier or card
	if card.ability.rental and G.GAME.cry_consumeable_rental_rate then
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			blocking = false,
			blockable = false,
			func = (function()
				ease_dollars(-G.GAME.cry_consumeable_rental_rate)
				return true
			end)
		}))
	end

	local obj = card.config.center
	if obj.use and type(obj.use) == 'function' then
		obj:use(card, area, copier)
		return
	end
end

function G.UIDEF.payasaka_joker_use_buttons(card, use_button)
	local sell = {
		n = G.UIT.C,
		config = { align = "cr" },
		nodes = {
			{
				n = G.UIT.C,
				config = { ref_table = card, align = "cr", padding = 0.1, r = 0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'sell_card', func = 'can_sell_card' },
				nodes = {
					{ n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
					{
						n = G.UIT.C,
						config = { align = "tm" },
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm", maxw = 1.25 },
								nodes = {
									{ n = G.UIT.T, config = { text = localize('b_sell'), colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true } }
								}
							},
							{
								n = G.UIT.R,
								config = { align = "cm" },
								nodes = {
									{ n = G.UIT.T, config = { text = localize('$'), colour = G.C.WHITE, scale = 0.4, shadow = true } },
									{ n = G.UIT.T, config = { ref_table = card, ref_value = 'sell_cost_label', colour = G.C.WHITE, scale = 0.55, shadow = true } }
								}
							}
						}
					}
				}
			},
		}
	}
	local use = use_button and use_button(card) or {
		n = G.UIT.C,
		config = { align = "cr" },
		nodes = {

			{
				n = G.UIT.C,
				config = { ref_table = card, align = "cr", maxw = 1.25, padding = 0.1, r = 0.08, minw = 1.25, minh = (card.area and card.area.config.type == 'joker') and 0 or 1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, button = 'use_card', func = 'can_use_consumeable' },
				nodes = {
					{ n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
					{ n = G.UIT.T, config = { text = localize('b_use'), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true } }
				}
			}
		}
	}
	local t = {
		n = G.UIT.ROOT,
		config = { padding = 0, colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.C,
				config = { padding = 0.15, align = 'cl' },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = 'cl' },
						nodes = {
							sell
						}
					},
					{
						n = G.UIT.R,
						config = { align = 'cl' },
						nodes = {
							use
						}
					},
				}
			},
		}
	}
	return t
end

-- Use soul_linked parameter if applicable + Vash
local remove_ref = Card.remove
function Card:remove()
	if self.soul_linked and not self.ability.akyrs_sigma then
		self.soul_linked:remove()
		self.soul_linked = nil
	end
	if PTASaka.VashDestroy(self) then
		self.getting_sliced = nil
		self.shattered = nil
		self.destroyed = nil
		return
	end
	return remove_ref(self)
end

local delete_run_ref = Game.delete_run
function Game:delete_run()
	G.PAYASAKA_IGNORE_VASH_SENTIMENT = true
	delete_run_ref(self)
	G.PAYASAKA_IGNORE_VASH_SENTIMENT = nil
end

-- Mostly taken from Aikoyori's Letter Wild Cards as a reference
local cardhighlighthook = Card.highlight
function Card:highlight(is_higlighted)
	local exists = self.children.use_button ~= nil
	local ret = cardhighlighthook(self, is_higlighted)

	-- For Deviant Memory and Rei, allow use button to appear on cards
	if self.config.center.pta_usable and self.area and self.area ~= G.pack_cards then
		if self.highlighted and self.area and self.area.config.type ~= 'shop' and (self.area == G.jokers or self.area == G.consumeables) then
			if self.children.use_button then
				self.children.use_button:remove()
				self.children.use_button = nil
			end
			self.children.use_button = UIBox {
				definition = G.UIDEF.payasaka_joker_use_buttons(self),
				config = { align =
					((self.area == G.jokers) or (self.area == G.consumeables)) and "cr" or
					"bmi"
				, offset =
					((self.area == G.jokers) or (self.area == G.consumeables)) and { x = -0.5, y = 0 } or
					{ x = 0, y = 0.65 },
					parent = self }
			}
		elseif exists and self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end
	end

	-- Irisu technically has a "use" button but does not run the use_consumeable routine
	if self.config.center.pta_custom_use and self.area and self.area ~= G.pack_cards then
		if self.highlighted and self.area and self.area.config.type ~= 'shop' and (self.area == G.jokers or self.area == G.consumeables) then
			if self.children.use_button then
				self.children.use_button:remove()
				self.children.use_button = nil
			end
			self.children.use_button = UIBox {
				definition = G.UIDEF.payasaka_joker_use_buttons(self, self.config.center.pta_custom_use),
				config = { align =
					((self.area == G.jokers) or (self.area == G.consumeables)) and "cr" or
					"bmi"
				, offset =
					((self.area == G.jokers) or (self.area == G.consumeables)) and { x = -0.5, y = 0 } or
					{ x = 0, y = 0.65 },
					parent = self }
			}
		elseif exists and self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end
	end

	if self.children.wild_use_button then
		self.children.wild_use_button:remove()
		self.children.wild_use_button = nil
	end

	if (self.area and (self.area == PTASaka.dos_cardarea or (self.ability and self.ability.extra and type(self.ability.extra) == 'table' and (self.ability.extra.payasaka_dos or self.ability.payasaka_dos)))) then
		if self.highlighted and self.area and self.area.config.type ~= 'shop' and (self.area ~= G.play or self.area ~= G.discard) and self.ability.payasaka_dos_wild then
			self.children.use_button = UIBox {
				definition = PTASaka.dos_wild_card_ui(self),
				config = { align =
				"bm",
					offset = { x = 0, y = -0.35 },
					parent = self }
			}
			self.children.wild_use_button = UIBox {
				definition = PTASaka.dos_card_hover_ui(self),
				config = { align =
				"cr",
					offset = { x = -0.5, y = -0.35 },
					parent = self }
			}
		elseif self.highlighted and self.area and self.area.config.type ~= 'shop' and (self.area ~= G.play or self.area ~= G.discard) then
			self.children.use_button = UIBox {
				definition = PTASaka.dos_card_hover_ui(self),
				config = { align =
				"cr",
					offset = { x = -0.5, y = -0.35 },
					parent = self }
			}
		elseif self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end
	end

	-- Backs and Sleeves
	if (self.area and self.area.config.type ~= 'shop' and self.ability and (self.ability.set == "Back" or self.ability.set == "Sleeve")) then
		if self.highlighted then
			local t2 = {
				n = G.UIT.ROOT,
				config = { ref_table = self, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GREEN, shadow = true, r = 0.08, minh = 0.94, func = 'can_redeem_deck_or_sleeve', one_press = true, button = 'redeem_from_shop', hover = true },
				nodes = {
					{ n = G.UIT.T, config = { text = localize('b_redeem'), colour = G.C.WHITE, scale = 0.4 } }
				}
			}
			if self.children.use_button then
				self.children.use_button:remove()
				self.children.use_button = nil
			end
			self.children.use_button = UIBox {
				definition = t2,
				config = { align = "bm"
				, offset = { x = 0, y = -0.3 },
					parent = self }
			}
		elseif self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end
	end

	return ret
end

-- Draw wild card use buttan


-- Mechanic doesn't disintegrate when used without selecting a joker
local old_start_dissolve = Card.start_dissolve
function Card:start_dissolve(c, s, t, j)
	if not PTASaka.mechanic_got_selected and self.config.center.key == "c_payasaka_mechanic" then
		draw_card(G.play, G.consumeables, 1, 'up', true, self, nil, true)
		return
	end
	if PTASaka.VashDestroy(self) then
		self.getting_sliced = nil
		self.shattered = nil
		self.destroyed = nil
		return
	end
	return old_start_dissolve(self, c, s, t, j)
end

-- Mechanic and Wild DOS cards shouldn't make the Banner side bar popup if Banner exists
if BANNERMOD then
	local old_collection_click = BANNERMOD.handle_collection_click_card
	function BANNERMOD.handle_collection_click_card(card)
		if PTASaka.mechanic_menu or PTASaka.dos_menu then return false end
		return old_collection_click(card)
	end
end

-- Hooks for Risk Cards
local oldce = Card.calculate_enhancement
function Card:calculate_enhancement(context)
	if self.ability.payasaka_stunted then return nil end
	return oldce(self, context)
end

local oldcb = Card.get_chip_bonus
function Card:get_chip_bonus()
	if self.ability.payasaka_stunted then return (self.base.nominal + (self.ability.perma_bonus or 0)) /
		(G.GAME.payasaka_shrink_active and 2 or 1) end
	return (oldcb(self) or 0) / (G.GAME.payasaka_shrink_active and 2 or 1)
end

local oldcm = Card.get_chip_mult
function Card:get_chip_mult()
	if self.ability.payasaka_stunted then return (self.ability.perma_mult or 0) end
	return oldcm(self)
end

local oldcxm = Card.get_chip_x_mult
function Card:get_chip_x_mult(context)
	if self.ability.payasaka_stunted then return (self.ability.perma_x_mult or 0) end
	return oldcxm(self, context)
end

local oldchm = Card.get_chip_h_mult
function Card:get_chip_h_mult()
	if self.ability.payasaka_stunted then return (self.ability.perma_h_mult or 0) end
	return oldchm(self)
end

local oldchxm = Card.get_chip_h_x_mult
function Card:get_chip_h_x_mult()
	if self.ability.payasaka_stunted then return (self.ability.perma_h_x_mult or 0) end
	return oldchxm(self)
end

local oldcxb = Card.get_chip_x_bonus
function Card:get_chip_x_bonus(context)
	if self.ability.payasaka_stunted then return (self.ability.perma_x_chips or 0) end
	return oldcxb(self, context)
end

local oldchb = Card.get_chip_h_bonus
function Card:get_chip_h_bonus()
	if self.ability.payasaka_stunted then return (self.ability.perma_h_chips or 0) end
	return oldchb(self)
end

local oldchxb = Card.get_chip_h_x_bonus
function Card:get_chip_h_x_bonus()
	if self.ability.payasaka_stunted then return (self.ability.perma_h_x_chips or 0) end
	return oldchxb(self)
end

local oldhd = Card.get_h_dollars
function Card:get_h_dollars()
	if self.ability.payasaka_stunted then return (self.ability.perma_h_dollars or 0) end
	return oldhd(self)
end

-- Whitelisted card areas for ahead checking
PTASaka.WhitelistedAheadAreas = {
	'jokers', 'consumeables', 'hand', 'discard', 'play'
}
PTASaka.ahead_count = 0

function PTASaka.recalc_chips_mult_shit(str, op)
	local x_marks_the_spot = G.HUD:get_UIE_by_ID('chips_what_mult')
	if x_marks_the_spot then
		text_size = #str - 1
		PTASaka.payasaka_text_size = text_size
		x_marks_the_spot.config.object.config.string = { str }
		x_marks_the_spot.config.object:update_text(true)
		x_marks_the_spot.config.object.colours = { (op or G.GAME.payasaka_exponential_count) <= 0 and G.C.MULT or
		G.C.EDITION }
		G.FUNCS.text_super_juice(x_marks_the_spot, 0.8)
		local chips_box = G.HUD:get_UIE_by_ID('hand_chip_area')
		if chips_box then
			chips_box.config.minw = 2 - (math.max(text_size, 0) * 0.14)
		end
		local mult_box = G.HUD:get_UIE_by_ID('hand_mult_area')
		if mult_box then
			mult_box.config.minw = 2 - (math.max(text_size, 0) * 0.14)
		end
		G.HUD:recalculate()
	end
	return x_marks_the_spot
end

-- Update hook for checking and do some misc stuff
local old_update = Game.update
function Game:update(dt)
	old_update(self, dt)
	PTASaka.ahead_count = 0
	local violating = SMODS.find_card('j_payasaka_no_retrigger')
	PTASaka.stop_you_are_violating_the_law = next(violating) and violating[1]
	local recuperares = SMODS.find_card('j_payasaka_recuperare')
	PTASaka.recuperares = next(recuperares) and recuperares
	PTASaka.pulmenti_count = #SMODS.find_card('j_payasaka_pulmenti')
	local niveus_terras = next(SMODS.find_card('j_payasaka_niveusterras'))
	PTASaka.scale_modifier_jokers = SMODS.find_card('j_payasaka_oguri')
	-- Get ahead count after updating
	for _, s in ipairs(PTASaka.WhitelistedAheadAreas) do
		local area = G[s]
		if not (area and area.cards) then goto continue end
		for _, card in ipairs(area.cards) do
			if card and card.is_ahead and (niveus_terras or card:is_ahead()) then
				PTASaka.ahead_count = PTASaka.ahead_count + 1
			end
		end
		::continue::
	end
end

-- Hooks to localize functions for comments
local init_ref = init_localization
function init_localization()
	init_ref()
	-- This is awfully nested....
	for g_k, group in pairs(G.localization) do
		if g_k == 'descriptions' then
			for _, set in pairs(group) do
				for _, center in pairs(set) do
					center.payasaka_comment_parsed = {}
					if center.payasaka_comment then
						for _, line in ipairs(center.payasaka_comment) do
							center.payasaka_comment_parsed[#center.payasaka_comment_parsed + 1] = loc_parse_string(line)
						end
					end
				end
			end
		end
	end
end

local localize_ref = localize
function localize(args, misc_cat)
	if args and not (type(args) == 'table') then
		return localize_ref(args, misc_cat)
	end

	local loc_target = nil
	if args and (type(args) == 'table') and args.type == 'payasaka_comment' then
		loc_target = G.localization.descriptions[(args.set or args.node.config.center.set)]
			[args.key or args.node.config.center.key]

		if loc_target then
			for _, lines in ipairs(loc_target[args.type .. "_parsed"]) do
				local final_line = {}
				for _, part in ipairs(lines) do
					local assembled_string = ''
					for _, subpart in ipairs(part.strings) do
						assembled_string = assembled_string ..
							(type(subpart) == 'string' and subpart or args.vars[tonumber(subpart[1])] or 'ERROR')
					end
					local desc_scale = (SMODS.Fonts[part.control.f] or G.FONTS[tonumber(part.control.f)] or G.LANG.font)
					.DESCSCALE
					if G.F_MOBILE_UI then desc_scale = desc_scale * 1.5 end
					if args.type == 'name' then
						final_line[#final_line + 1] = {
							n = G.UIT.O,
							config = {
								object = DynaText({
									string = { assembled_string },
									colours = { (part.control.V and args.vars.colours[tonumber(part.control.V)]) or (part.control.C and loc_colour(part.control.C)) or G.C.UI.TEXT_LIGHT },
									bump = true,
									silent = true,
									pop_in = 0,
									pop_in_rate = 4,
									maxw = 5,
									shadow = true,
									y_offset = -0.6,
									spacing = math.max(0, 0.32 * (17 - #assembled_string)),
									font = SMODS.Fonts[part.control.f] or G.FONTS[tonumber(part.control.f)],
									scale = (0.55 - 0.004 * #assembled_string) *
										(part.control.s and tonumber(part.control.s) or 1)
								})
							}
						}
					elseif part.control.E then
						local _float, _silent, _pop_in, _bump, _spacing = nil, true, nil, nil, nil
						if part.control.E == '1' then
							_float = true; _silent = true; _pop_in = 0
						elseif part.control.E == '2' then
							_bump = true; _spacing = 1
						end
						final_line[#final_line + 1] = {
							n = G.UIT.O,
							config = {
								object = DynaText({
									string = { assembled_string },
									colours = { part.control.V and args.vars.colours[tonumber(part.control.V)] or loc_colour(part.control.C or nil) },
									float = _float,
									silent = _silent,
									pop_in = _pop_in,
									bump = _bump,
									spacing = _spacing,
									font = SMODS.Fonts[part.control.f] or G.FONTS[tonumber(part.control.f)],
									scale = 0.32 * (part.control.s and tonumber(part.control.s) or 1) * desc_scale
								})
							}
						}
					elseif part.control.X then
						final_line[#final_line + 1] = {
							n = G.UIT.C,
							config = { align = "m", colour = loc_colour(part.control.X), r = 0.05, padding = 0.03, res = 0.15 },
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = assembled_string,
										colour = loc_colour(part.control.C or nil),
										scale = 0.32 * (part.control.s and tonumber(part.control.s) or 1) * desc_scale
									}
								},
							}
						}
					else
						final_line[#final_line + 1] = {
							n = G.UIT.T,
							config = {
								detailed_tooltip = part.control.T and
									(G.P_CENTERS[part.control.T] or G.P_TAGS[part.control.T]) or nil,
								text = assembled_string,
								shadow = args.shadow,
								colour = part.control.V and args.vars.colours[tonumber(part.control.V)] or
									loc_colour(part.control.C or nil, args.default_col),
								font = SMODS.Fonts[part.control.f] or G.FONTS[tonumber(part.control.f)],
								scale = 0.32 * (part.control.s and tonumber(part.control.s) or 1) * desc_scale
							},
						}
					end
				end
				if args.type == 'name' or args.type == 'text' then
					return final_line
				end
				args.nodes[#args.nodes + 1] = final_line
			end
		end
	else
		return localize_ref(args, misc_cat)
	end
end

-- Second fucking hook
local yay = localize
function localize(args, misc_cat)
	local ret = yay(args, misc_cat)
	if ret and type(ret) == "string" and G and G.GAME and G.GAME.payasaka_tmtrainer_effects then
		-- randomize string
		--ret = PTASaka.ZZAZZ_string(ret)
	end
	return ret
end
