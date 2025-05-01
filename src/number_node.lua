NumberNode = Object:extend()

function NumberNode:new(x,y)
    self.x = x
    self.y = y
    self.value = 0
    self.btn_up = {}
    self.btn_down = {}
end