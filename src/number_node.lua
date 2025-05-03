NumberNode = Object:extend()

function NumberNode:new(x,y)
    self.x = x
    self.y = y
    self.value = 0
    self.btn_up = {}
    self.btn_down = {}
end

function NumberNode:draw()
    spr(24, self.x, self.y)
    print("\014" .. tostr(self.value), self.x, self.y + 8, 7)
    spr(32, self.x, self.y + 16)
end