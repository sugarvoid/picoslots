CloseRect = Object:extend()

function CloseRect:new(x, w)
    self.color = 7
    self.x = x
    self.y = 0
    self.h = 99
    self.w = w
    self.is_hovered = false
    self.is_visible = true
    self.func = nil
end

function CloseRect:update()
    if is_colliding(self, get_mouse_pos()) then
        self.color = 12
        self.is_hovered = true
    else
        self.color = 7
        self.is_hovered = false
    end
end

-- function CloseRect:draw()
--     rect(self.x, self.y, self.x + self.w, self.y + self.h, self.color)
-- end

function CloseRect:was_clicked()
    self.func()
end
