
Coin = Object:extend()
all_coins = {}

function randi_rang(l, h)
    return flr(rnd(h - l + 1)) + l
end

function Coin:new(x, y)
	self.img = 13
	self.x = x
	self.y = y 
end

function Coin:draw()
	if self.y >= 74 then
		spr(self.img, self.x, self.y)
	end
end

function Coin:update()
	self.y += 0.5
	if self.y >= 95 then
		del(all_coins, self)
	end 
end

function draw_coins()
	foreach(all_coins, function(obj) obj:draw() end )
end

function update_coins()
	foreach(all_coins, function(obj) obj:update() end )
end

function spawn_coin(num)
	for i=1, num+1 do
		local x = randi_rang(30, 62)
		local y = 74 - randi_rang(2, 15)
		add(all_coins, Coin(x,y))
	end
end


