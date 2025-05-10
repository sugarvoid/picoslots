Face = Object:extend()

local FACE_STR = {
	{ "lemon",  10 },
	{ "heart",  8 },
	{ "bell",   9 },
	{ "clover", 27 },
	{ "bar",    10 },
	{ "dimond", 28 },
	{ "melon",  11 },
	{ "seven",  8 },
}


function Face:new(reel, img, y)
	self.parent = reel
	self.img = img
	self.top = reel.y - 60
	self.bottom = reel.y + 75
	self.x = reel.x + 1
	self.y = y
	self.speed = 3
end

function Face:draw()
	if self.y >= 15 and self.y <= 45 then
		spr(self.img, self.x, self.y)
	end
end

function Face:update()
	self.y += self.speed
	if self.y >= self.bottom then
		self.y = self.top
	end
end

function get_face_string(num)
	return tostr(num), FACE_STR[num][2]
	--return FACE_STR[num][1], FACE_STR[num][2]
end
