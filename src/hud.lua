
p_spr_1 = 75
p_spr_2 = 75
p_spr_3 = 75
p_spr_4 = 75


player_stats = {cash = 0}

hud = {
	draw=function(self)
		print("$", 32, 0, 7)
		print("\014" .. pad_zeros(player_stats.cash, 6), 38, 2, 7)
		if show_payout then
			spr(p_spr_1, 42, 31)
			spr(p_spr_2, 42+4, 31)
			spr(p_spr_3, 42+8, 31)
			spr(p_spr_4, 42+8+4, 31)
		end
		spr(81,58,61)
		spr(83,34,61)
		
		if btnp(1) then
			spr(84,58,61)
		end
		
		if btnp(0) then
			spr(82,34,61)
		end
		if auto_mode and flr(time() * 2) % 2 == 0  then
			print("AUTO", 1, 92, 7)
		end

        --rect(-1,3,7,35,7)
        --print("\014s", 1, 5, 7)
        --print("\014t", 1, 5+5+1, 7)
        --print("\014a", 1, 15+2, 7)
        --print("\014t", 1, 20+3, 7)
        --print("\014s", 1, 25+4, 7)


        --rect(-1,43,7,70,7)
        --print("\014s", 1, 45, 7)
        --print("\014h", 1, 45+5+1, 7)
        --print("\014o", 1, 45+5+5+2, 7)
        --print("\014p", 1, 45+5+5+5+3, 7)



        --print("\014b", 96, 5, 7)
        --print("\014a", 96, 5+5+1, 7)
        --print("\014n", 96, 15+2, 7)
        --print("\014k", 96, 20+3, 7)
	end,
	update_payout_spr=function(self,num)
		p_spr_1, p_spr_2, p_spr_3, p_spr_4 = number_to_spr(num)
	end,
}

local sprite_map = {
    ["0"] = 75,
    ["1"] = 65,
    ["2"] = 66,
    ["3"] = 67,
    ["4"] = 68,
    ["5"] = 69,
    ["6"] = 70,
    ["7"] = 71,
    ["8"] = 73,
    ["9"] = 74
}


function number_to_spr(num)
	local s1,s2,s3,s4 = nil,nil,nil,nil
	
	local char_array = split_num(num)
	
	s1 = sprite_map[char_array[1]] or 75
	s2 = sprite_map[char_array[2]] or 75
	s3 = sprite_map[char_array[3]] or 75
	s4 = sprite_map[char_array[4]] or 75

	return s1,s2,s3,s4
end

function split_num(num_str) 
	num_str = tostr(pad_zeros(num_str, 4))
	local chars = {}
	for c in num_str:gmatch(".") do
		table.insert(chars, c)
	end
	return chars
end