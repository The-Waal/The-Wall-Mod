--- STEAMODDED HEADER
--- MOD_NAME: The Wall
--- MOD_ID: TheWall
--- PREFIX: Wall
--- MOD_AUTHOR: [THE WAAL]
--- MOD_DESCRIPTION: Adds a few blinds and new features!
--- VERSION: 0.0.0


local mod_path = "" .. SMODS.current_mod.path
local config = SMODS.current_mod.config or {}
local debug = false
config.gameset_toggle = true

SMODS.current_mod.config_tab = function()
	return {n = G.UIT.ROOT, config = {r = 0.2, minw = 12, minh = 9, align = "tm", padding = 0.1, colour = HEX('442266'), outline = 3, outline_colour = G.C.PURPLE}, nodes = {
		{n = G.UIT.R, config = {minw=6, minh=3, colour = G.C.CLEAR, padding = 0.3, r = 0.1}, nodes = {
			create_toggle({label = "0BlindSize (restart)", ref_table = config, ref_value = "Dev"}),
			create_toggle({label = "AllBossBlinds", ref_table = config, ref_value = "AllBoss"})
		}},
	
	}}
end

local allHands = G.handlist



SMODS.Atlas({ key = "waal", atlas_table = "ANIMATION_ATLAS", path = "wall.png", px = 32, py = 32, frames = 1 })
SMODS.Atlas({ key = "jokeratlas1", atlas_table = "ASSET_ATLAS", path = "jokers1.png", px = 71, py = 95 })
SMODS.Atlas({ key = "blindatlas1", atlas_table = "ANIMATION_ATLAS", path = "blindatlas1.png", px = 34, py = 34, frames = 21 })
SMODS.Atlas({ key = "packlas1", atlas_table = "ASSET_ATLAS", path = "pack1.png", px = 71, py = 95 })
SMODS.Atlas({ key = "cons1", atlas_table = "ASSET_ATLAS", path = "cons1.png", px = 71, py = 95 })
SMODS.Atlas({ key = "Consumeables", atlas_table = "ASSET_ATLAS", path = "consumeables.png", px = 71, py = 95 })
SMODS.Atlas({ key = "GMRA", atlas_table = "ASSET_ATLAS", path = "grosmichelrank.png", px = 71, py = 95 })
SMODS.Atlas({ key = "wstake", atlas_table = "ASSET_ATLAS", path = "stake.png", px = 29, py = 29 })

----
--misc functions
----

function get_flush(hand)
  local ret = {}
  local four_fingers = next(find_joker('Four Fingers'))
  local suits = {
    "Spades",
    "Hearts",
    "Clubs",
    "Diamonds"
  }
  if #hand > 5 or #hand < (5 - (four_fingers and 1 or 0)) then return ret else
    for j = 1, #suits do
      local t = {}
      local suit = suits[j]
      local flush_count = 0
      for i=1, #hand do
        if hand[i]:is_suit(suit, nil, true) then flush_count = flush_count + 1;  t[#t+1] = hand[i] end 
      end
      if flush_count >= (5 - (four_fingers and 1 or 0)) then
        table.insert(ret, t)
        return ret
      end
    end
    return {}
  end
end

function get_straight(hand)
  local ret = {}
  local four_fingers = next(find_joker('Four Fingers'))
  if #hand > 5 or #hand < (5 - (four_fingers and 1 or 0)) then return ret else
    local t = {}
    local IDS = {}
    for i=1, #hand do
      local id = hand[i]:get_id()
      if id > 1 and id < 15 then
        if IDS[id] then
          IDS[id][#IDS[id]+1] = hand[i]
        else
          IDS[id] = {hand[i]}
        end
      end
    end

    local straight_length = 0
    local straight = false
    local can_skip = next(find_joker('Shortcut')) 
    local skipped_rank = false
    for j = 1, 14 do
      if IDS[j == 1 and 14 or j] then
        straight_length = straight_length + 1
        skipped_rank = false
        for k, v in ipairs(IDS[j == 1 and 14 or j]) do
          t[#t+1] = v
        end
      elseif can_skip and not skipped_rank and j ~= 14 then
          skipped_rank = true
      else
        straight_length = 0
        skipped_rank = false
        if not straight then t = {} end
        if straight then break end
      end
      if straight_length >= (5 - (four_fingers and 1 or 0)) then straight = true end 
    end
    if not straight then return ret end
    table.insert(ret, t)
    return ret
  end
end

function get_X_same(num, hand)
	local vals = {{},{},{},{},{},{},{},{},{},{},{},{},{},{}}
	for i=#hand, 1, -1 do
		local curr = {}
		table.insert(curr, hand[i])
		for j=1, #hand do
			if hand[i]:get_id() == hand[j]:get_id() and i ~= j then
				table.insert(curr, hand[j])
			end
		end
		if #curr == num then
			vals[curr[1]:get_id()] = curr
		end
	end
	local ret = {}
	for i=#vals, 1, -1 do
		if next(vals[i]) then table.insert(ret, vals[i]) end
	end
	return ret
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
		{'S_3', false},
		{'H_2', true, enhancement = 'm_mult'},
		{'S_4', true, enhancement = 'm_bonus'},
		{'C_7', true, enhancement = 'm_lucky'},
		{'D_K', false}
	},
	evaluate = function(parts, hand)
		if true then return {} end
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
		--if hand[1].base.id == 10 then
		--	print("WOOOOOOOOW")
		--end
				

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
function reset_blinds()
	G.GAME.round_resets.blind_states = G.GAME.round_resets.blind_states or {Small = 'Select', Big = 'Upcoming', Boss = 'Upcoming'}
	--print(G.GAME.round_resets.blind_choices.Big)
	if config["AllBoss"] then
		if G.GAME.round_resets.blind_choices.Big == "bl_big" then
			G.GAME.round_resets.blind_choices.Big = get_new_boss()
		end
		if G.GAME.round_resets.blind_choices.Small == "bl_small" then
			G.GAME.round_resets.blind_choices.Small = get_new_boss()
		end

	end
	if G.GAME.round_resets.blind_states.Boss == 'Defeated' then

		if config["AllBoss"] then
			G.GAME.round_resets.blind_choices.Big = get_new_boss()
			G.GAME.round_resets.blind_choices.Small = get_new_boss()
		end

		G.GAME.round_resets.blind_choices.Boss = get_new_boss()

		G.GAME.round_resets.blind_states.Small = 'Upcoming'
		G.GAME.round_resets.blind_states.Big = 'Upcoming'
		G.GAME.round_resets.blind_states.Boss = 'Upcoming'
		G.GAME.blind_on_deck = 'Small'
		--G.GAME.round_resets.ante = G.GAME.round_resets.ante - 1
		G.GAME.round_resets.boss_rerolled = false
	end


end

if config.Dev then
	function get_blind_amount(ante)
		return 0
	end
end

----



