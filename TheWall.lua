--- STEAMODDED HEADER
--- MOD_NAME: The Wall
--- MOD_ID: TheWall
--- PREFIX: Wall
--- MOD_AUTHOR: [THE WAAL]
--- MOD_DESCRIPTION: Adds a few blinds and new features!
--- VERSION: 0.0.1


local mod_path = "" .. SMODS.current_mod.path
local config = SMODS.current_mod.config or {}
local debug = false
config.gameset_toggle = true

SMODS.current_mod.config_tab = function()
	return {n = G.UIT.ROOT, config = {r = 0.2, minw = 12, minh = 9, align = "tm", padding = 0.1, colour = HEX('442266'), outline = 3, outline_colour = G.C.PURPLE}, nodes = {
		{n = G.UIT.R, config = {minw=6, minh=3, colour = G.C.CLEAR, padding = 0.3, r = 0.1}, nodes = {
			create_toggle({label = "Zero Blind Size", ref_table = config, ref_value = "Dev"}),
			create_toggle({label = "All Boss Blinds", ref_table = config, ref_value = "AllBoss"}),
			create_toggle({label = "Hard Mode", ref_table = config, ref_value = "HardMode"}),
			create_option_cycle({
				scale = 1, 
				w = 4, 
				label = "Scaling", 
				current_option = config["Blind_Scaling_ID"], 
				opt_callback = 'Waal_upd_score_opt',
				options = {"None", "Needle (0.5x)", "Water (2x)", "House (5x)", "Manacle (10x)", "Voilet Vessel (25x)", "Cryptid (100x)", "Roffle (1000x)", "Ralsei (1e10x)", "The Waal (1e100x)"}})
		}},
	
	}}
end

local allHands = G.handlist



SMODS.Atlas({ key = "waal", atlas_table = "ANIMATION_ATLAS", path = "wall.png", px = 32, py = 32, frames = 1 })
SMODS.Atlas({ key = "jokeratlas1", atlas_table = "ASSET_ATLAS", path = "jokers1.png", px = 71, py = 95 })
SMODS.Atlas({ key = "blindatlas1", atlas_table = "ANIMATION_ATLAS", path = "blindatlas1.png", px = 34, py = 34, frames = 21 })
SMODS.Atlas({ key = "packlas1", atlas_table = "ASSET_ATLAS", path = "pack1.png", px = 71, py = 95 })
SMODS.Atlas({ key = "cons1", atlas_table = "ASSET_ATLAS", path = "cons1.png", px = 71, py = 95 })
SMODS.Atlas({ key = "Jokers", atlas_table = "ASSET_ATLAS", path = "jokers.png", px = 71, py = 95 })
SMODS.Atlas({ key = "Consumeables", atlas_table = "ASSET_ATLAS", path = "consumeables.png", px = 71, py = 95 })
SMODS.Atlas({ key = "GMRA", atlas_table = "ASSET_ATLAS", path = "grosmichelrank.png", px = 71, py = 95 })
SMODS.Atlas({ key = "wstake", atlas_table = "ASSET_ATLAS", path = "stake.png", px = 29, py = 29 })

----
--misc functions
----

G.FUNCS.Waal_upd_score_opt = function(e)
	config.Blind_Scaling_ID = e.to_key
	local scale_opts = {"None", "Needle (0.5x)", "Water (2x)", "House (5x)", "Manacle (10x)", "Voilet Vessel (25x)", "Cryptid (100x)", "Roffle (1000x)", "Ralsei (1e10x)", "The Waal (1e100x)"}
	config.Blind_Scaling = scale_opts[e.to_key]
end


-------------
--hands
-------------

SMODS.PokerHand {
	loc_txt = {
		name = '24/7',
		description = {'Hand must contain an enhanced 2, 4, and 7'}
	},
	key = '24/7',
	chips = 24,
	mult = 7,
	visible = false,
	l_chips = 24,
	l_mult = 3,
	example = {
		{'S_3', false, seal = "Red", edition = "e_polychrome", enhancement = "m_glass"},
		{'H_2', true, enhancement = 'm_mult'},
		{'S_4', true, enhancement = 'm_bonus'},
		{'C_7', true, enhancement = 'm_lucky'},
		{'D_K', false, seal = "Blue", edition = "e_negative", enhancement = "m_gold"}
	},
	evaluate = function(parts, hand)
		
		if #get_flush(hand) >= 1 then return {} end
		if #get_straight(hand) >= 1 then return {} end
		local valid = {}
		local count1 = 0
		local count2 = 0
		local count3 = 0

		for i = 1, #hand do
			local card = hand[i]
			
			local num = card:get_id()
			if card.label ~= "Base Card" then
				if num == 2 then
					count1 = count1 + 1
					table.insert(valid, card)
				elseif num == 4 then
					count2 = count2 + 1
					table.insert(valid, card)
				elseif num == 7 then
					count3 = count3 + 1
					table.insert(valid, card)
				end
			end
		end
				

		if #valid > 0 and count1 == 1 and count2 == 1 and count3 == 1 then
			return {valid}
		else
			return {}
		end
	end
}

--planet cards

SMODS.Consumable {
	key = "James-Games",
	set = 'Planet',
	loc_txt = {
		name = 'James Games',
		text = {'Upgrades 24/7'}
	},
	atlas = "Consumeables",
	pos = {x = 0, y = 0},
	cost = 4,
	--set_badges = function(self, card, badges)
	--	badges[#badges+1] = create_badge('Wall Mod', G.C.PURPLE, G.C.BLACK, 1.2 )
	--end,
	pools = {
		["Planet"] = true,
		["Modded"] = true,
		["Wall"] = true
	},
	can_use = function(self, card)
		return true
	end, 
	use = function(self, card, area)
		update_hand_text(
			{sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, 
			{mult = G.GAME.hands["Wall_24/7"].mult, chips = G.GAME.hands["Wall_24/7"].chips, handname = '24/7', level = G.GAME.hands["Wall_24/7"].level}
		)
		level_up_hand(card, "Wall_24/7", false, 1)
		update_hand_text(
			{sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, 
			{mult = 0, chips = 0, handname = '', level = ''}
		)
	end
}


--stakes
--nothing here yet :(

--jokers
SMODS.Joker {
	key = "JamesGamesWeak",
	loc_txt = {
		name = 'JamesGames',
		text = { 'Scoring cards give {X:mult,C:white}X#1#{} Mult,', 'Increases by {X:mult,C:white}X#2#{} when a{C:money} 2, 4, {}or{C:money} 7{} is scored' }
	},
	loc_vars = function(self, info_q, card)
		return {
			vars = {card.ability.extra.mult, card.ability.extra.gain},
			--text_colour = G.C.WHITE,
		}
	end,
	config = {extra = {mult = 1.0, gain = 0.05}},
	atlas = "Jokers",
	pos = {x = 0, y = 0},
	soul_pos = {x = 1, y = 0},
	rarity = 3,
	blueprint_compat = true,
	pools = {["Modded"] = true, ["Wall"] = true},
	cost = 7,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			
			if context.other_card:get_id() == 2 or context.other_card:get_id() == 4 or context.other_card:get_id() == 7 then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
				
				if true then return {message = "Upgrade", colour = G.C.MONEY, xmult = card.ability.extra.mult} end
			else
				return {xmult = card.ability.extra.mult}
			end
		end
	end,
}



--blinds
--[[ most disabled because I dont like them lol
SMODS.Blind {
	loc_txt = {
		name = 'Forest Fire',
		text = { '+30% blind size when a hand/discard is used' }
	},
	key = 'forest_fire',
	config = {},
	boss = {showdown = true, min = 8, max = 8, hardcore = true}, 
	boss_colour = HEX("8c3616"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 0},
	
	dollars = 5,
	mult = 1,

	set_blind = function(self, reset, silent)
		if reset then
			self.vars.count = 0 
		end
	end,

	 drawn_to_hand = function(self)
		G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.3),
		G.GAME.blind:wiggle()
	end,

	disable = function(self)
		self.vars.count = 0
	end
}






SMODS.Blind {
	loc_txt = {
		name = 'Parasta Ikina',
		text = { 'POWERRRRRRRRRR' }
	},
	key = 'parasta_ikina',
	config = {},
	boss = {showdown = true, min = 8, max = 8, hardcore = true}, 
	boss_colour = HEX("0000ff"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 1},
	dollars = 10,
	mult = 8,
	
	drawn_to_hand = function(self)
		G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.1),
		G.GAME.blind:wiggle()
	end,

	set_blind = function(self, reset, silent)
		if reset then
			
		end
	end,


	disable = function(self)
		 G.GAME.blind:wiggle()
	end
}



SMODS.Blind {
	loc_txt = {
		name = 'Gros Michel Blind',
		text = { '1/2 chance to halve blind size', 'when hand played' }
	},
	key = 'banana',
	config = {},
	boss = {showdown = true, min = 8, max = 8, hardcore = true}, 
	boss_colour = HEX("eeee00"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 2 },
	vars = {},
	dollars = 6,
	mult = 30,

	set_blind = function(self, reset, silent)
		if not reset then
			-- blank
		end
	end,

	press_play = function(self) -- Triggers when a hand is played
		if math.random() < 0.5 then -- 50% chance
			delay(0.4)
			G.GAME.blind.chips = math.max(1, math.floor(G.GAME.blind.chips * 0.5)) -- Halve chips, min 1

			G.GAME.blind:wiggle() -- Trigger animation
			
			
		end
	end,

	disable = function(self)
		-- blank
	end
}

SMODS.Blind {
	loc_txt = {
		name = 'Heartache',
		text = { 'Weakens most played hand to', '10 chips, 2 mult' }
	},
	key = 'sad',
	config = {},
	boss = {min = 4, max = 20, hardcore = true}, 
	boss_colour = HEX("eedddd"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 3 },
	vars = {},
	dollars = 2,
	mult = 1,
	debuff = {},

	loc_vars = function(self)
		return {localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands')}
	end,

	set_blind = function(self, reset, silent)
		if not reset then
			
			local most_played_hand = G.GAME.current_round.most_played_poker_hand

			if most_played_hand and G.GAME.hands[most_played_hand] then
				local hand = G.GAME.hands[most_played_hand]
				hand.level = 1 
				hand.mult	= 2
				hand.chips = 10
			end

			
			delay(2)
			G.GAME.blind:wiggle()
			delay(0.1)
			G.GAME.blind:wiggle()
			delay(0.1)
			G.GAME.blind:wiggle()
			delay(0.1)
			G.GAME.blind:wiggle()
			delay(0.1)
			G.GAME.blind:wiggle()
			delay(0.1)
			G.GAME.blind:wiggle()
			delay(0.3)
			G.GAME.blind:juice_up()
		end
	end,

	disable = function(self)
		
	end
}




SMODS.Blind	{
	loc_txt = {
		name = 'Bob',
		text = { 'Bob like you! duplicate played hand', '(*bostin stole bobs pennut butter, does not work*)'}
	},
	key = 'bob',
	config = {},
	boss = {min = 2, max = 20, hardcore = true}, 
	boss_colour = HEX("00AAAA"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 4},
	vars = {},
	dollars = 7,
	mult = 3,
	set_blind = function(self, reset, silent)
		if not reset then
			-- blank
		end
	end,
	--press_play = function(self)
		--for x in scoring_hand: card = x, card:add_to_deck, card:emplace,
	--end,


	disable = function(self)
		-- blank
	end
}
SMODS.Blind	{
	loc_txt = {
		name = 'Forths',
		text = { 'Bob in pain...'}
	},
	key = 'four',
	config = {},
	boss = {min = 3, max = 20, hardcore = true}, 
	boss_colour = HEX("ff0000"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 5},
	vars = {},
	dollars = 2,
	mult = 1,
	

	

	set_blind = function(self, reset, silent)
		if not reset then
			G.hand:change_size(-4)
			if (G.GAME.round_resets.hands > 2) then
				G.GAME.blind.hands_sub = G.GAME.round_resets.hands - 2
				ease_hands_played(-G.GAME.blind.hands_sub)
			end
			if (G.GAME.current_round.discards_left < 10) then
				G.GAME.blind.discards_sub = -5
				ease_discard(-G.GAME.blind.discards_sub)
			end
		end
	end,
	disable = function(self)
		-- blank
	end
}

SMODS.Blind	{
	loc_txt = {
		name = 'Roulette',
		text = { 'Gambling?'}
	},
	key = 'gamble',
	config = {},
	boss = {min = 3, max = 20, hardcore = true}, 
	boss_colour = HEX("880000"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 7},
	vars = {},
	dollars = 10,
	mult = 2,
	set_blind = function(self, reset, silent)
		if not reset then
			-- blank
		end
	end,
	drawn_to_hand = function(self)
		G.GAME.blind:juice_up()
		delay(1.5)
		EventNum = math.random(1, 11)

		if EventNum == 1 then
			G.hand:change_size(1)
		end
		if EventNum == 2 then
			G.hand:change_size(-1)
		end
		if EventNum == 3 then
			G.GAME.blind.hands_sub = 1
			ease_hands_played(G.GAME.blind.hands_sub)
		end
		if EventNum == 4 then
			G.GAME.blind.hands_sub = -1
			ease_hands_played(G.GAME.blind.hands_sub)
		end
		if EventNum == 5 then
			G.GAME.blind.discards_sub = 1
			ease_discard(G.GAME.blind.discards_sub)
		end
		if EventNum == 6 then
			G.GAME.blind.discards_sub = -1
			ease_discard(G.GAME.blind.discards_sub)
		end
		if EventNum == 7 then
			G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.3)
		end
		if EventNum == 8 then
			G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.5)
		end
		if EventNum == 9 then
			G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.2)
		end
		if EventNum == 10 then
			G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.1)
		end
		if EventNum == 11 then
			G.GAME.blind:wiggle()
			if math.random(1, 5) == 1 then
				G.GAME.blind:wiggle()
				G.GAME.blind:wiggle()
				G.GAME.blind:wiggle()
				JACKPOT = math.random(1, 3)
				if JACKPOT == 1 then
					G.hand:change_size(10)
				elseif JACKPOT == 2 then
					G.GAME.blind.hands_sub = 5,
					ease_hands_played(G.GAME.blind.hands_sub)
				elseif JACKPOT == 3 then
					G.GAME.blind.discards_sub = 7,
					ease_discard(G.GAME.blind.discards_sub)
				end
			elseif math.random(1, 2) == 1 then
				G.GAME.blind:wiggle()
				G.GAME.blind.dollars = G.GAME.blind.dollars + 3
			end
		end
	end,
	disable = function(self)
		-- blank
	end
}
SMODS.Blind	{
	loc_txt = {
		name = 'Hieman Kestävämpi Seinä',
		text = { 'the wall?'}
	},
	key = 'waal',
	config = {},
	boss = {min = 2, max = 20, hardcore = true}, 
	boss_colour = HEX("ff00ff"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 8},
	vars = {},
	dollars = 8,
	mult = 5,
	set_blind = function(self, reset, silent)
		if not reset then
			-- blank
		end
	end,
	disable = function(self)
		-- blank
	end
}
SMODS.Blind	{
	loc_txt = {
		name = 'Three Goblets',
		text = { '-1 hand, hand size, and discard'}
	},
	key = 'three',
	config = {},
	boss = {showdown = true, min = 2, max = 20, hardcore = true}, 
	boss_colour = HEX("aa00aa"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 9},
	vars = {},
	dollars = 12,
	mult = 4,
	set_blind = function(self, reset, silent)
		if not reset then
			G.hand:change_size(-1)
			if (G.GAME.round_resets.hands > 1) then
				G.GAME.blind.hands_sub = 1
				ease_hands_played(-G.GAME.blind.hands_sub)
			end
			if (G.GAME.current_round.discards_left > 1) then
				G.GAME.blind.discards_sub = 1
				ease_discard(-G.GAME.blind.discards_sub)
			end
		end
	end,
	disable = function(self)
		-- blank
	end
}
]]
SMODS.Blind	{
	loc_txt = {
		name = 'Four leaf clover',
		text = { '1/2 chance to lose 1 hand when hand played' }
	},
	key = 'fourleaf',
	config = {},
	boss = {min = 1, max = 8, hardcore = true}, 
	boss_colour = HEX("88ff88"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 10},
	vars = {},
	dollars = 7,
	mult = 2,
	set_blind = function(self, reset, silent)
		if not reset then
			-- blank
		end
	end,
	press_play = function(self) 
		if math.random() < 0.5 then 
			delay(0.4)
			 
			G.GAME.blind.hands_sub = 1
			ease_hands_played(-G.GAME.blind.hands_sub)
			
		end
	end,
	disable = function(self)
		-- blank
	end
}
--[[
SMODS.Blind	{
	loc_txt = {
		name = 'Target',
		text = { ' -1 hand size,','no discards' }
	},
	key = 'rip',
	config = {},
	boss = { min = 5, max = 8, hardcore = true}, 
	boss_colour = HEX("ee5555"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 11},
	vars = {},
	dollars = 6,
	mult = 1,
	set_blind = function(self, reset, silent)
		if not reset then
			G.hand:change_size(-1)
			if (G.GAME.current_round.discards_left > 0) then
				G.GAME.blind.discards_sub = G.GAME.current_round.discards_left
				ease_discard(-G.GAME.blind.discards_sub)
			end
		end
	end,
	disable = function(self)
		-- blank
	end
}
SMODS.Blind	{
	loc_txt = {
		name = 'Boss blind',
		text = { 'Set hands to 1, +1 discard' }
	},
	key = 'banana',
	config = {},
	boss = {min = 8, max = 8, hardcore = true}, 
	boss_colour = HEX("ee5511"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 12},
	vars = {},
	dollars = 12,
	mult = 3,
	set_blind = function(self, reset, silent)
		if not reset then
			if (G.GAME.round_resets.hands > 1) then
				G.GAME.blind.hands_sub = G.GAME.round_resets.hands - 1
				ease_hands_played(-G.GAME.blind.hands_sub)
			end
			if (G.GAME.current_round.discards_left > 1) then
				G.GAME.blind.discards_sub = 1
				ease_discard(G.GAME.blind.discards_sub)
			end
		end
	end,
	disable = function(self)
		-- blank
	end
}
SMODS.Blind	{
	loc_txt = {
		name = 'The EYE',
		text = { 'Your greed consumes you...' }
	},
	key = 'scaryeye',
	config = {},
	boss = {min = 4, max = 20, hardcore = true}, 
	boss_colour = HEX("991111"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 13},
	vars = {},
	dollars = 0,
	mult = 1,
	set_blind = function(self, reset, silent)
		if not reset then
			-- blank
		end
	end,
	disable = function(self)
		-- blank
	end
}
SMODS.Blind	{
	loc_txt = {
		name = 'Tiny Bob',
		text = { 'Bob Small, duplicate all 2s 2 times,', 'hand is disallowed if hand has no 2s,', 'he got stuck in pennut butter (WIP)'}
	},
	key = 'Tbob',
	config = {},
	boss = {min = 1, max = 5, hardcore = true}, 
	boss_colour = HEX("00AAAA"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 14},
	vars = {},
	dollars = 2,
	mult = 1,
	set_blind = function(self, reset, silent)
		if not reset then
			-- blank
		end
	end,
	disable = function(self)
		-- blank
	end
}
SMODS.Blind	{
	loc_txt = {
		name = 'Joe',
		text = { '-5$'}
	},
	key = 'joe',
	config = {},
	boss = {min = 1, max = 8, hardcore = true}, 
	boss_colour = HEX("22ff22"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 15},
	vars = {},
	dollars = -5,
	mult = 2,
	set_blind = function(self, reset, silent)
		if not reset then
	
		end
	end,
	disable = function(self)
		-- blank
	end
}
SMODS.Blind	{
	loc_txt = {
		name = 'voimakas violetti valo',
		text = { '"small" blind'}
	},
	key = 'valo',
	config = {},
	boss = {showdown = true, min = 8, max = 8, hardcore = true}, 
	boss_colour = HEX("ff00ff"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 16},
	vars = {},
	dollars = 10,
	mult = 30,
	set_blind = function(self, reset, silent)
		if not reset then
			-- blank
		end
	end,
	disable = function(self)
		-- blank
	end
}
]]
SMODS.Blind	{
	loc_txt = {
		name = 'Sanin',
		text = { 'Weakens all hands'}
	},
	key = 'Samin',
	config = {},
	boss = {min = 3, max = 8, hardcore = true}, 
	boss_colour = HEX("ffff00"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 18},
	vars = {},
	dollars = 5,
	mult = 2,
	
	
	set_blind = function(self, reset, silent)
		if not reset then
			for _, hand in ipairs(allHands) do
				level_up_hand(nil, hand, true, -1 * math.floor(G.GAME.hands[hand].level / 2))
			end
		end
	end,
	
	disable = function(self)
		-- blank
	end
}
--[[
SMODS.Blind	{
	loc_txt = {
		name = 'The Oven',
		text = { '-1 hand size each hand/discard used'}
	},
	key = 'Cook',
	config = {},
	boss = {showdown = true, min = 8, max = 8, hardcore = true}, 
	boss_colour = HEX("ffaa00"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 17},
	vars = {},
	dollars = 3,
	mult = 2,
	set_blind = function(self, reset, silent)
		if not reset then
			-- blank
		end
	end,
	drawn_to_hand = function(self)
		G.GAME.blind:juice_up()
		G.hand:change_size(-1)
	end,
	disable = function(self)
		-- blank
	end
}
SMODS.Blind	{
	loc_txt = {
		name = 'bostin',
		text = { 'Combine effects of Sanin, Joe, and Bob,', 'austin stole bostins house (does not work WIP)'}
	},
	key = 'austin',
	config = {},
	boss = {min = 1, max = 8, hardcore = true}, 
	boss_colour = HEX("313131"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 19},
	vars = {},
	dollars = 25,
	mult = 9,
	set_blind = function(self, reset, silent)
		if not reset then
			-- blank
		end
	end,
	disable = function(self)
		-- blank
	end
}
SMODS.Blind	{
	loc_txt = {
		name = '',
		text = { '...?'}
	},
	key = 'void',
	config = {},
	boss = {min = 1, max = 8, hardcore = true}, 
	boss_colour = HEX("000000"),
	atlas = "blindatlas1",
	pos = { x = 0, y = 20},
	vars = {},
	dollars = 0,
	mult = 0,
	set_blind = function(self, reset, silent)
		if not reset then
			-- blank
		end
	end,
	disable = function(self)
		-- blank
	end
}





SMODS.Blind {
	loc_txt = {
		name = 'The Waal',
		text = { 'The final boss of balatro'}
	},
	key = 'Waaaaaaaaaaallll',
	config = {},
	boss = {min = 1, max = 8, hardcore = true}, 
	boss_colour = HEX("ff00ff"),
	atlas = "waal",
	pos = { x = 0, y = 0},
	vars = {},
	dollars = 1,
	mult = 1e298*(1/3),
	set_blind = function(self, reset, silent)
		if not reset then
			-- blank
		end
	end,
	disable = function(self)
		-- blank
	end
}
]]


--__cool stuff
--[[
local gnb = get_new_boss
function get_new_boss()
	local bl = gnb()
	for k, v in pairs(G.P_BLINDS) do
		if not G.GAME.bosses_used[k] then
			G.GAME.bosses_used[k] = 0
		end
	end
	return bl
end
]]

local s_table = {"None", "Needle (0.5x)", "Water (2x)", "House (5x)", "Manacle (10x)", "Voilet Vessel (25x)", "Cryptid (100x)", "Roffle (1000x)", "Ralsei (1e10x)", "The Waal (1e100x)"}
local n_table = {nil, 0.5, 2, 5, 10, 25, 100, 1000, 1e10, 1e100}
local gba = get_blind_amount
function get_blind_amount(ante)
	local amount = gba(ante)
	if config.Dev then
		return 0
	end
	if config["HardMode"] then
		local power = ante^2 * 0.00100099 + 1
		amount = amount ^ power ^ (ante/8)
	end

	if config["Blind_Scaling"] and config["Blind_Scaling"] ~= "None" then
		local num = 1
		local scaling = 1
		for i = 1, #s_table do
			if config["Blind_Scaling"] == s_table[i] then num = i end
		end
		if num ~= 1 then
			scaling = math.log(n_table[num]*50000,50000)
		end
		amount = amount ^ scaling^(ante/8)
	end

	return amount
end




function get_new_showdown()
	G.GAME.perscribed_bosses = G.GAME.perscribed_bosses or {}
	if G.GAME.perscribed_bosses and G.GAME.perscribed_bosses[G.GAME.round_resets.ante] then 
		local ret_boss = G.GAME.perscribed_bosses[G.GAME.round_resets.ante] 
		G.GAME.perscribed_bosses[G.GAME.round_resets.ante] = nil
		G.GAME.bosses_used[ret_boss] = G.GAME.bosses_used[ret_boss] + 1
		return ret_boss
	end
	local min_use = 100
	if G.FORCE_BOSS then return G.FORCE_BOSS end
	local eligible_bosses = {}
	for k, v in pairs(G.P_BLINDS) do
		if not v.boss then
			
		elseif not v.boss.showdown and (v.boss.min <= math.max(1, G.GAME.round_resets.ante) and ((math.max(1, G.GAME.round_resets.ante))%G.GAME.win_ante ~= 0 or G.GAME.round_resets.ante < 2)) then
			--eligible_bosses[k] = true
		elseif v.boss.showdown then
			eligible_bosses[k] = true
		end
	end
	for k, v in pairs(G.GAME.bosses_used) do
		if eligible_bosses[k] then
			eligible_bosses[k] = v
			if eligible_bosses[k] <= min_use then 
				min_use = eligible_bosses[k]
			end
		end
	end
	for k, v in pairs(eligible_bosses) do
		if eligible_bosses[k] then
			if eligible_bosses[k] > min_use then 
				eligible_bosses[k] = nil
			end
		end
	end
	local _, boss = pseudorandom_element(eligible_bosses, pseudoseed('boss'))
	G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] + 1
	
	return boss


end

function reset_blinds()
	G.GAME.round_resets.blind_states = G.GAME.round_resets.blind_states or {Small = 'Select', Big = 'Upcoming', Boss = 'Upcoming'}
	if config["AllBoss"] then
		if G.GAME.round_resets.blind_choices.Big == "bl_big" then
			G.GAME.round_resets.blind_choices.Big = get_new_boss()
		end
		if G.GAME.round_resets.blind_choices.Small == "bl_small" then
			G.GAME.round_resets.blind_choices.Small = get_new_boss()
		end

	end
	if G.GAME.round_resets.blind_states.Boss == 'Defeated' then

		if config["AllBoss"] or config["HardMode"] and G.GAME.round_resets.ante > G.GAME.win_ante then
			G.GAME.round_resets.blind_choices.Big = get_new_boss()
			G.GAME.round_resets.blind_choices.Small = get_new_boss()
		else
			G.GAME.round_resets.blind_choices.Small = "bl_small"
			G.GAME.round_resets.blind_choices.Big = "bl_big"
		end
		if config["HardMode"] and G.GAME.round_resets.ante > G.GAME.win_ante then
			G.GAME.round_resets.blind_choices.Boss = get_new_showdown()
		else
			G.GAME.round_resets.blind_choices.Boss = get_new_boss()
		end


		G.GAME.round_resets.blind_states.Small = 'Upcoming'
		G.GAME.round_resets.blind_states.Big = 'Upcoming'
		G.GAME.round_resets.blind_states.Boss = 'Upcoming'
		G.GAME.blind_on_deck = 'Small'
		--G.GAME.round_resets.ante = G.GAME.round_resets.ante - 1
		G.GAME.round_resets.boss_rerolled = false
	end


end



----



