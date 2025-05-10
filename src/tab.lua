Tab = Object:extend()

function Tab:new(img, x, y)
    self.img = img
    self.color = 7
    self.x = x
    self.y = y
    self.h = 27
    self.w = 7
    self.is_hovered = false
    self.is_visible = true
    self.func = function() end
end

function Tab:update()
    if is_colliding(self, get_mouse_pos()) then
        self.color = 12
        self.is_hovered = true
    else
        self.color = 7
        self.is_hovered = false
    end
end

function Tab:draw()
    if self.is_visible then
        pal(7, self.color)
        spr(self.img, self.x, self.y)
        pal()
    end
end

function Tab:was_clicked()
    self.func()
end
