handle = {
	x = 78,
	y = 30,
	w = 9,
	h = 9,
	is_hovered = false,
	draw = function(self)
		spr(12, 78, 52)
		rect(self.x + 4, self.y + 5, self.x + 5, 55, 6)
		pal(14, 0)
		spr(16, self.x, self.y)
		pal()
		-- if self.is_hovered then
		-- 	rect(self.x, self.y, self.x + 9, self.y + 9, 7)
		-- end
	end,
	update = function(self)
		self.is_hovered = is_colliding(self, get_mouse_pos())
	end,
	pull = function(self)
		if self.y == 30 then
			player_stats.total_pulls += 1
			player_stats.cash = mid(0, player_stats.cash - PULL_COST, 999999)
			player_stats.total_spent += PULL_COST
			flux.to(self, 0.6, { y = 70 }):ease("quadin"):oncomplete(
				function()
					start_reels()
					flux.to(self, 1, { y = 30 }):ease("backin")
				end
			)
		end
	end,
}
