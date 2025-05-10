
Label = Object:extend()

set_draw_target(userdata("u8", 1, 1))

function Label:new(text, x, y, col)	
	local _width = print(text, 0, 0)
	set_draw_target()
	self.is_clickable=true
	--self.is_static=false
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
	
	--self:check_clicked()
end

function Label:was_clicked()
	--sfx(2)
	self:callback()
end

function Label:set_text(str)
	self.text = str
end

-- function is_colliding_lbl(m_x, m_y, box)
--     if m_x < box.x + box.w and
--         m_x > box.x and
--         m_y < box.y + box.h and
--         m_y > box.y then
--         return true
--     else
--         return false
--     end
-- end

function Label:draw()
	--rect(self.x, self.y, self.x+self.w, self.y+16, 3)
	print("\014"..self.text, self.x, self.y, self.col)
end