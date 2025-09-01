--- STEAMODDED HEADER
--- MOD_NAME: The Wall
--- MOD_ID: TheWall
--- PREFIX: Wall
--- MOD_AUTHOR: [THE WAAL]
--- MOD_DESCRIPTION: Adds a few blinds and new features!
--- VERSION: 0.2.3
--- PRIORITY: 1000

SMODS.Atlas({
	key = 'modicon',
	path = 'wall.png',
	px = 32,
	py = 32
})

local mod_path = "" .. SMODS.current_mod.path
local config = SMODS.current_mod.config or {}
local debug = false
config.gameset_toggle = true


--[[
SMODS.current_mod.config_tab = function()
	return {n = G.UIT.ROOT, config = {r = 0.2, minw = 13, minh = 9, align = "tl", padding = 0.1, colour = HEX('442266')}, nodes = {

		{n = G.UIT.C, config = {minw=2, minh=9, colour = HEX('662299'), padding = 0.3, r = 0.1}, nodes = {
			UIBox_button({label = {"Showdown"}, colour = G.C.PURPLE}),
			UIBox_button({label = {"Small"}, colour = G.C.PURPLE}),
			UIBox_button({label = {"Big"}, colour = G.C.PURPLE}),
			UIBox_button({label = {"Boss"}, colour = G.C.PURPLE, button = 'Config_Boss'}),

		}},

		{n = G.UIT.C, config = {minw=6, minh=9, colour = G.C.MONEY, padding = 0.3, r = 0.1}, nodes = {
			create_option_cycle({
				scale = 1, 
				w = 4, 
				label = "Scaling", 
				current_option = config["Blind_Scaling_ID"], 
				opt_callback = 'Waal_upd_score_opt',
				options = {"None", "Needle (0.5x)", "Water (2x)", "House (5x)", "Manacle (10x)", "Voilet Vessel (25x)", "Cryptid (100x)", "Roffle (1000x)", "Ralsei (1e10x)", "The Waal (1e100x)"}
			}),


			create_option_cycle({
				scale = 1, 
				w = 4, 
				label = "Showdown Blind", 
				current_option = config["Blind_Custom"].Showdown, 
				opt_callback = 'Waal_upd_SD_opt',
				options = {"Small", "Big", "Boss", "Showdown", "Removed", "Random"}
			}),

		}},

		{n = G.UIT.C, config = {minw=10, minh=9, colour = HEX('552288'), padding = 0.3, r = 0.1}, nodes = {

			--create_toggle({label = "All Boss Blinds", ref_table = config, ref_value = "AllBoss"}),
			--create_toggle({label = "Hard Mode", ref_table = config, ref_value = "HardMode"}),
			create_toggle({label = "Showdowns", ref_table = config["Blind_Custom"], ref_value = "ShowdownToggle"}),

			create_toggle({label = "Big Blind Showdowns", ref_table = config["Blind_Custom"], ref_value = "Big_SD"}),
			create_toggle({label = "Boss Blind Showdowns", ref_table = config["Blind_Custom"], ref_value = "Boss_SD"}),
		}},
	}}

end
]]
function scaling_tab()
	return {n = G.UIT.ROOT, config = {r = 0.2, minw = 13, minh = 9, align = "tm", padding = 0.1, colour = HEX('442266')}, nodes = {
			create_toggle({label = "Zero Blind Size", ref_table = config, ref_value = "Dev"}),
			create_option_cycle({
				scale = 1, 
				w = 4, 
				label = "Scaling", 
				current_option = config["Blind_Scaling_ID"], 
				opt_callback = 'Waal_upd_score_opt',
				options = {"None", "Anti-Waal (0.1x)", "Needle^2 (0.25x)", "Needle (0.5x)", "Water (2x)", "House (5x)", "Manacle (10x)", "Voilet Vessel (25x)", "Cryptid (100x)", "Roffle (1000x)", "Ralsei (1e10x)", "The Waal (1e100x)"}
			}),
			create_toggle({label = "Scaling applys after ante 8?", ref_table = config, ref_value = "Scaling_Endless"}),
--[[
			{n = G.UIT.R, config = {minw=5, minh=1, colour = G.C.CLEAR, padding = 0.1, r = 0.1}, nodes = {
				create_text_input({
					scale = 1, 
					w = 4, 
					label = "Start Ante", 
					ref_table = config, 
					ref_value = "Start_Ante",
				}),
			}},
			{n = G.UIT.R, config = {minw=5, minh=1, colour = G.C.CLEAR, padding = 0.1, r = 0.1}, nodes = {
				create_text_input({
					scale = 1, 
					w = 4, 
					label = "End Ante", 
					ref_table = config, 
					ref_value = "End_Ante",
				}),
			}},
]]
	}}
end

function blinds_tab()
	return {n = G.UIT.ROOT, config = {r = 0.2, minw = 12, minh = 9, align = "cm", padding = 0.1, colour = HEX('442266')}, nodes = {
		{n = G.UIT.C, config = {minw=4, minh=9, colour = HEX('552288'), padding = 0.3, r = 0.1}, nodes = {
			{n = G.UIT.R, config = {minw=4, minh=1, colour = G.C.CLEAR, r = 0.1, align = "tm"}, nodes = {
				{n = G.UIT.T, config = {minw=4, minh=1, colour = HEX('FFFFFF'), r = 0.1, text = "Small Blind", scale = 1}, nodes = {}},
			}},
			create_option_cycle({
				scale = 1, 
				w = 4, 
				label = "Blind Type", 
				current_option = config["Blind_Custom"].Small, 
				opt_callback = 'Waal_upd_SB_opt',
				options = {"Small", "Big", "Boss", "Showdown", "Removed", "Random"}
			}),
			create_toggle({label = "Small Blind Showdowns", ref_table = config["Blind_Custom"], ref_value = "Small_SD"}),
			create_option_cycle({
				scale = 1, 
				w = 4, 
				label = "Showdown Blind Type", 
				current_option = config["Blind_Custom"].Small_SDT, 
				opt_callback = 'Waal_upd_SBSD_opt',
				options = {"Small", "Big", "Boss", "Showdown", "Removed", "Random"}
			}),
		}},
		{n = G.UIT.C, config = {minw=4, minh=9, colour = HEX('552288'), padding = 0.3, r = 0.1}, nodes = {
			{n = G.UIT.R, config = {minw=4, minh=1, colour = G.C.CLEAR, r = 0.1, align = "tm"}, nodes = {
				{n = G.UIT.T, config = {minw=4, minh=1, colour = HEX('FFFFFF'), r = 0.1, text = "Big Blind", scale = 1}, nodes = {}},
			}},
			create_option_cycle({
				scale = 1, 
				w = 4, 
				label = "Blind Type", 
				current_option = config["Blind_Custom"].Big, 
				opt_callback = 'Waal_upd_BB_opt',
				options = {"Small", "Big", "Boss", "Showdown", "Removed", "Random"}
			}),
			create_toggle({label = "Big Blind Showdowns", ref_table = config["Blind_Custom"], ref_value = "Big_SD"}),
			create_option_cycle({
				scale = 1, 
				w = 4, 
				label = "Showdown Blind Type", 
				current_option = config["Blind_Custom"].Big_SDT, 
				opt_callback = 'Waal_upd_BBSD_opt',
				options = {"Small", "Big", "Boss", "Showdown", "Removed", "Random"}
			}),
		}},
		{n = G.UIT.C, config = {minw=4, minh=9, colour = HEX('552288'), padding = 0.3, r = 0.1}, nodes = {
			{n = G.UIT.R, config = {minw=4, minh=1, colour = G.C.CLEAR, r = 0.1, align = "tm"}, nodes = {
				{n = G.UIT.T, config = {minw=4, minh=1, colour = HEX('FFFFFF'), r = 0.1, text = "Boss Blind", scale = 1}, nodes = {}},
			}},
			create_option_cycle({
				scale = 1, 
				w = 4, 
				label = "Blind Type", 
				current_option = config["Blind_Custom"].Boss, 
				opt_callback = 'Waal_upd_BS_opt',
				options = {"Small", "Big", "Boss", "Showdown", "Random"}
			}),
			create_toggle({label = "Boss Blind Showdowns", ref_table = config["Blind_Custom"], ref_value = "Boss_SD"}),
			create_option_cycle({
				scale = 1, 
				w = 4, 
				label = "Showdown Blind Type", 
				current_option = config["Blind_Custom"].Boss_SDT, 
				opt_callback = 'Waal_upd_BSSD_opt',
				options = {"Small", "Big", "Boss", "Showdown", "Random"}
			}),
		}},
	}}
end

SMODS.current_mod.extra_tabs = function()
	return {
		{label = 'Scaling', tab_definition_function = scaling_tab},
		{label = 'Blinds', tab_definition_function = blinds_tab},
		--{label = 'Scaling', tab_definition_function = scaling_tab},
		--{label = 'Scaling', tab_definition_function = scaling_tab},
		--{label = 'Scaling', tab_definition_function = scaling_tab},
	}
end

local allHands = G.handlist




----
--misc functions
----

G.FUNCS.Waal_upd_score_opt = function(e)
	config.Blind_Scaling_ID = e.to_key
	local scale_opts = {"None", "Anti-Waal (0.1x)", "Needle^2 (0.25x)", "Needle (0.5x)", "Water (2x)", "House (5x)", "Manacle (10x)", "Voilet Vessel (25x)", "Cryptid (100x)", "Roffle (1000x)", "Ralsei (1e10x)", "The Waal (1e100x)"}
	config.Blind_Scaling = scale_opts[e.to_key]
end

G.FUNCS.Waal_Start_Ante_opt = function(e)
	config.Start_Ante = e
end
G.FUNCS.Waal_upd_SB_opt = function(e)
	config.Blind_Custom.Small = e.to_key
end
G.FUNCS.Waal_upd_BB_opt = function(e)
	config.Blind_Custom.Big = e.to_key
end
G.FUNCS.Waal_upd_BS_opt = function(e)
	config.Blind_Custom.Boss = e.to_key
end
G.FUNCS.Waal_upd_SBSD_opt = function(e)
	config.Blind_Custom.Small_SDT = e.to_key
end
G.FUNCS.Waal_upd_BBSD_opt = function(e)
	config.Blind_Custom.Big_SDT = e.to_key
end
G.FUNCS.Waal_upd_BSSD_opt = function(e)
	config.Blind_Custom.Boss_SDT = e.to_key
end
G.FUNCS.Waal_upd_SD_opt = function(e)
	config.Blind_Custom.Showdown = e.to_key
end

G.FUNCS.Config_Boss = function(e)
	for _, i in pairs(e.parent.parent.parent) do print(_) print(i) end
	local config_uibox = e.parent.parent.parent

	local menu_wrap = config_uibox.parent
	
	-- Delete the current menu UIBox:
	menu_wrap.config.object:remove()
	-- Create the new menu UIBox:
	menu_wrap.config.object = UIBox({
		definition = my_menu_function(e.config.my_data),
		config = {parent = menu_wrap, type = "cm"} -- You MUST specify parent!
	})
	-- Update the UI:
	menu_wrap.UIBox:recalculate()
	
end
-------------
--hands
-------------


--blinds


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

local s_table = {"None", "Anti-Waal (0.1x)", "Needle^2 (0.25x)", "Needle (0.5x)", "Water (2x)", "House (5x)", "Manacle (10x)", "Voilet Vessel (25x)", "Cryptid (100x)", "Roffle (1000x)", "Ralsei (1e10x)", "The Waal (1e100x)"}
local n_table = {nil, 0.1, 0.25, 0.5, 2, 5, 10, 25, 100, 1000, 1e10, 1e100}
local gba = get_blind_amount
function get_blind_amount(ante)
	local amount = 1
	if ante - math.floor(ante) ~= 0 then
		local a = gba(math.floor(ante)) ^ (ante - math.floor(ante))
		local b = gba(math.ceil(ante)) ^ (1 - (ante - math.floor(ante)))
		amount = a * b

	else
		amount = gba(ante)
	end
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
		print(scaling)
		if config["Scaling_Endless"] or ante <= 8 then 
			if num ~= 1 then
				scaling = math.log(n_table[num]*50000,50000)
			end
			if ante == 1 then scaling = scaling ^ 0.5 end
			
			amount = amount ^ scaling^(ante/8)
			--amount = math.floor(amount/10^math.floor(math.log10(amount))*10)/10*10^math.floor(math.log10(amount))
		else
			amount = amount * n_table[num]
		end
	end

	return amount
end


function get_new_boss()
	G.GAME.perscribed_bosses = G.GAME.perscribed_bosses or {
	}
	if G.GAME.perscribed_bosses and G.GAME.perscribed_bosses[G.GAME.round_resets.ante] then 
		local ret_boss = G.GAME.perscribed_bosses[G.GAME.round_resets.ante] 
		G.GAME.perscribed_bosses[G.GAME.round_resets.ante] = nil
		G.GAME.bosses_used[ret_boss] = G.GAME.bosses_used[ret_boss] + 1
		return ret_boss
	end
	if G.FORCE_BOSS then return G.FORCE_BOSS end
	
	local eligible_bosses = {}
	for k, v in pairs(G.P_BLINDS) do
		if not v.boss then

		elseif not v.boss.showdown and (v.boss.min <= math.max(1, G.GAME.round_resets.ante)) then
			eligible_bosses[k] = true
		elseif v.boss.showdown and (G.GAME.round_resets.ante)%G.GAME.win_ante == 0 and G.GAME.round_resets.ante >= 2 then
			eligible_bosses[k] = nil
		end
	end
	for k, v in pairs(G.GAME.banned_keys) do
		if eligible_bosses[k] then eligible_bosses[k] = nil end
	end

	local min_use = 100
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

function get_new_blind(type)
	if type == 1 then return "bl_small" end
	if type == 2 then return "bl_big" end
	if type == 3 then return get_new_boss() end
	if type == 4 then return get_new_showdown() end
	if type == 6 then return get_new_blind(math.random(1, 4)) end
	
	return "bl_wall"
end

function set_small_blind()
	
	if (G.GAME.round_resets.ante)%G.GAME.win_ante == 0 and config.Blind_Custom.Small_SD then
		if config.Blind_Custom.Small_SDT == 5 then
			G.GAME.round_resets.blind_states["Small"] = "Hide"
		else
			G.GAME.round_resets.blind_states["Small"] = "Upcoming"
		end
		G.GAME.round_resets.blind_choices.Small = get_new_blind(config.Blind_Custom.Small_SDT)
	else
		if config.Blind_Custom.Small == 5 then
			G.GAME.round_resets.blind_states["Small"] = "Hide"
		elseif config.Blind_Custom.Small ~= 5 then

			G.GAME.round_resets.blind_states["Small"] = "Upcoming"
		end
		G.GAME.round_resets.blind_choices.Small = get_new_blind(config.Blind_Custom.Small)
	end
	
	
end

function set_big_blind()
	
	if (G.GAME.round_resets.ante)%G.GAME.win_ante == 0 and config.Blind_Custom.Big_SD then
		if config.Blind_Custom.Big_SDT == 5 then
			G.GAME.round_resets.blind_states["Big"] = "Hide"
		else
			G.GAME.round_resets.blind_states["Big"] = "Upcoming"
		end
		G.GAME.round_resets.blind_choices.Big = get_new_blind(config.Blind_Custom.Big_SDT)
	else
		if config.Blind_Custom.Big == 5 then
			G.GAME.round_resets.blind_states["Big"] = "Hide"
		elseif config.Blind_Custom.Big ~= 5 then

			G.GAME.round_resets.blind_states["Big"] = "Upcoming"
		end
		G.GAME.round_resets.blind_choices.Big = get_new_blind(config.Blind_Custom.Big)
	end
	
	
end


function set_boss_blind()
	G.GAME.round_resets.blind_states["Boss"] = "Upcoming"
	
	if (G.GAME.round_resets.ante)%G.GAME.win_ante == 0 and config.Blind_Custom.Boss_SD then
		G.GAME.round_resets.blind_choices.Boss = get_new_blind(config.Blind_Custom.Boss_SDT)
		if config.Blind_Custom.Boss_SDT == 5 then
			G.GAME.round_resets.blind_choices.Boss = get_new_blind(6)
		end
		
	else
		G.GAME.round_resets.blind_choices.Boss = get_new_blind(config.Blind_Custom.Boss)
		if config.Blind_Custom.Boss == 5 then
			G.GAME.round_resets.blind_choices.Boss = get_new_blind(6)
		end
	end
	
	
end

function reset_blinds()
	G.GAME.round_resets.blind_states = G.GAME.round_resets.blind_states or {Small = 'Select', Big = 'Upcoming', Boss = 'Upcoming'}
	--G.GAME.round_resets.blind_states["Small"] = "Hide"
	--G.GAME.round_resets.blind_states["Big"] = "Hide"
	--set_small_blind()
	
	if G.GAME.round_resets.blind_states["Small"] == "Defeated" and G.GAME.round_resets.blind_states["Big"] == "Hide" then
		G.GAME.round_resets.blind_states["Boss"] = "Select"
	end
--[[
	if G.GAME.round == 0 then
		if not tonumber(config["Start_Ante"]) then config["Start_Ante"] = 1 end
		if not tonumber(config["End_Ante"]) then config["End_Ante"] = 8 end	
		config["Start_Ante"], config["End_Ante"] = tonumber(config["Start_Ante"]), tonumber(config["End_Ante"])
		G.GAME.round_resets.ante = config["Start_Ante"]
		G.GAME.round_resets.ante_disp = G.GAME.round_resets.ante
		G.GAME.round_resets.blind_ante = G.GAME.round_resets.ante
		G.GAME.win_ante = config.End_Ante
	end
]]
	if G.GAME.round_resets.blind_states.Boss == 'Defeated' or G.GAME.round == 0 then
		--G.GAME.round_resets.ante = G.GAME.round_resets.ante + 0.5
		set_small_blind()
		set_boss_blind()
		set_big_blind()


		G.GAME.blind_on_deck = 'Small'
	
		G.GAME.round_resets.boss_rerolled = false
	end


end

G.FUNCS.reroll_boss = function(e) 
	stop_use()
	G.GAME.round_resets.boss_rerolled = true
	if not G.from_boss_tag then ease_dollars(-10) end
	G.from_boss_tag = nil
	G.CONTROLLER.locks.boss_reroll = true
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function()
			play_sound('other1')
			G.blind_select_opts.boss:set_role({xy_bond = 'Weak'})
			G.blind_select_opts.boss.alignment.offset.y = 20
			return true
		end
	}))
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.3,
		func = (function()
		local par = G.blind_select_opts.boss.parent
		print(G.GAME.round_resets.ante)
		print(G.GAME.round_resets.blind_ante)
		if (G.GAME.round_resets.ante)%G.GAME.win_ante == 0 and config.Blind_Custom.Boss_SD then
			G.GAME.round_resets.blind_choices.Boss = get_new_blind(config.Blind_Custom.Boss_SDT)
		else
			G.GAME.round_resets.blind_choices.Boss = get_new_blind(config.Blind_Custom.Boss)
		end
		G.blind_select_opts.boss:remove()
		G.blind_select_opts.boss = UIBox{
			T = {par.T.x, 0, 0, 0, },
			definition =
			{n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
				UIBox_dyn_container({create_UIBox_blind_choice('Boss')},false,get_blind_main_colour('Boss'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))
			}},
			config = {align="bmi",
					offset = {x=0,y=G.ROOM.T.y + 9},
					major = par,
					xy_bond = 'Weak'
					}
		}
		par.config.object = G.blind_select_opts.boss
		par.config.object:recalculate()
		G.blind_select_opts.boss.parent = par
		G.blind_select_opts.boss.alignment.offset.y = 0
		
		G.E_MANAGER:add_event(Event({blocking = false, trigger = 'after', delay = 0.5,func = function()
			G.CONTROLLER.locks.boss_reroll = nil
			return true
			end
		}))

		save_run()
		for i = 1, #G.GAME.tags do
			if G.GAME.tags[i]:apply_to_run({type = 'new_blind_choice'}) then break end
		end
			return true
		end)
	}))
end



----



