
Reel = Object:extend()

local bg_spr = 9

function Reel:new(x, y)
	self.img = 1
	self.x = x
	self.y = y
	self.reel_y = 0 
	self.faces = {}
	set_upfaces(self)
	self.spinning = false
	self.face = 3 
end

function Reel:stop()
	if self.spinning then
		sfx(4)
		self.spinning = false
		self.face = flr(rnd(8)) + 1 
	end
end

function Reel:update()
	if self.spinning then
		for f in all(self.faces) do 
			f:update()
		end
	end
end

function Reel:draw()
	if not self.spinning then
		spr(self.face, self.x+1, self.y+1)
	else
		for f in all(self.faces) do 
			f:draw()
		end
	end
	
	spr(bg_spr, self.x, self.y)
end

function set_upfaces(reel)
	local start_y = reel.y +1
	for i=1, 8 do
		local f = Face(reel, i, start_y -(i - 1) * 16)
		add(reel.faces, f)
	end
end

function Reel:spin()
	self.spinning = true
end