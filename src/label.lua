
Label={}
Label.__index=Label



 set_draw_target(userdata("u8", 1, 1))

function Label.new(text, x, y, col)
    local _l = setmetatable({},Label)
	
    _l.w = 35--print(text, 0, -20)
    --set_draw_target(userdata("u8", 1, 1))
	local foo = print(text, 0, 0)
	set_draw_target()
	_l.interactive=true
	_l.w=foo
    _l.h = 5
    _l.x = x
    _l.y = y
    _l.text = text
    _l.col = col
    _l.default_col = col
    _l.hover_col = col
    _l.is_hovered = false
    _l.callback=function() error("Add a function")  end
    return _l
end

function Label:update()
	if is_colliding_lbl(mx/mouse_offset, my/mouse_offset, self) then
		self.is_hovered = true
		self.col = 12
	else
		self.col = self.default_col
		self.is_hovered = false
	end
	
	--self:check_clicked()
end

function Label:was_clicked()
	self:callback()
end

function is_colliding_lbl(m_x, m_y, box)
    if m_x < box.x + box.w and
        m_x > box.x and
        m_y < box.y + box.h and
        m_y > box.y then
        return true
    else
        return false
    end
end

function Label:draw()
	--rect(self.x, self.y, self.x+self.w, self.y+16, 3)
	print("\014"..self.text, self.x, self.y, self.col)
end