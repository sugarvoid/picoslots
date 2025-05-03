Tab = Object:extend()

function Tab:new(side, y, text)
    if side == "left" then
      self.x = 2
    else
        self.x = 95
    end
    self.color = 0
    
    self.y = y
    self.h = 0
    self.text = text
    self.text_table = {}
    self.value = 0
    self.btn_up = {}
    self.btn_down = {}
    for c in text:gmatch(".") do
        table.insert(self.text_table, c)
        self.h += 7
    end
    self.is_hovered = false
    self.is_visible = true
    self.w = 8
    self.func = function () end
    --notify(#self.text_table)
end

function Tab:update()
    if is_colliding(mx/2, my/2, self) then
        self.color = 12
        self.is_hovered = true
    else
        self.color = 1
        self.is_hovered = false
    end
end

function Tab:draw()
    if self.is_visible then
        rectfill(self.x - 2, self.y - 2, (self.x - 2) + 6, (self.y-2) + self.h, self.color)
        for key, value in ipairs(self.text_table) do
            --for c in all(self.text_table) do
            key-=1
            print("\014" .. value, self.x, self.y + (6 * key), 7)
        end
        rect(self.x - 2, self.y - 2, (self.x - 2) + 6, (self.y-2) + self.h, 7)
    end
end

function Tab:was_clicked()
    sfx(5)
    self.func()
end
