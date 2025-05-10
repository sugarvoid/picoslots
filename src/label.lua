
Label = Object:extend()

set_draw_target(userdata("u8", 1, 1))

function Label:new(text, x, y, col)	
	local _width = print(text, 0, 0)
	set_draw_target()
	self.is_clickable=true
	self.w=_width - 3
    self.h = 5
    self.x = x
    self.y = y
    self.text = text
    self.col = col
    self.default_col = col
    self.hover_col = col
    self.is_hovered = false
    self.callback=function() error("Add a function")  end
end

function Label:update()
	if self.is_clickable then
		if is_colliding(self, get_mouse_pos()) then
			self.is_hovered = true
			self.col = 12
		else
			self.col = self.default_col
			self.is_hovered = false
		end
	end
end

function Label:was_clicked()
	self:callback()
end

function Label:set_text(str)
	self.text = str
end

function Label:draw()
	print("\014"..self.text, self.x, self.y, self.col)
end