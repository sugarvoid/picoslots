
Light = Object:extend()

local light_y = 17

function Light:new(x)
	self.img = 11
	self.tic = 0
	self.x = x
	self.is_on = false 
	self.col = 8
end

function Light:draw()
	pal(30, self.col)
	spr(self.img, self.x, light_y)
	pal()
end

function Light:update()
	if self.is_on then
		self.tic += 1
		if self.tic == 10 then
			self:turn_off()
		end
	end
end

function Light:turn_on()
	self.is_on = true
	self.img = 10
end

function Light:turn_off()
	self.is_on = false
	self.img = 11
	self.tic = 0
end

function draw_lights()
	foreach(all_lights, function(obj) obj:draw() end )
end

function update_lights()
	foreach(all_lights, function(obj) obj:update() end )
end

local light_small_actions = {
	[1] = function()
		all_lights[4]:turn_on()
	end,
	[2] = function()
		all_lights[3]:turn_on()
		all_lights[5]:turn_on()
	end,
	[3] = function()
		all_lights[2]:turn_on()
		all_lights[6]:turn_on()
	end,
	[4] = function()
		all_lights[1]:turn_on()
		all_lights[7]:turn_on()
	end,
	[5] = function()
		all_lights[2]:turn_on()
		all_lights[6]:turn_on()
	end,
	[6] = function()
		all_lights[3]:turn_on()
		all_lights[5]:turn_on()
	end,
	[7] = function()
		all_lights[4]:turn_on()
	end,
	[9] = function()
		light_man:restart()
	end,
}

light_man = {
	is_running=false,
	t=0,
	seconds=0,
	update=function(self)
		if self.is_running then
	        self.t = self.t + 1
	        if self.t >= 5 then
	            --self:tick()
	            self.seconds+=1
	            do_small_lights()
	            self.t = 0
	        end
	    end
	end,
	restart=function(self)
		self.is_running=false
		self.t=0
		self.seconds=0
	end,
}

function do_small_lights()
	local action = light_small_actions[light_man.seconds]
	if action then
		action()
	end
end

all_lights = {
	Light(21),
	Light(29),
	Light(37),
	Light(45),
	Light(53),
	Light(61),
	Light(69),
}
