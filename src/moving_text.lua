
MText = Object:extend()
all_m_text = {}



function MText:new(str, col, end_pos, x, y)
	self.str = str
	self.x = x
	self.y = y 
    self.col = col or 7
    self:move(end_pos)
    add(all_m_text, self)
end

function MText:draw()
    p8_print(self.str, self.x, self.y, self.col)
	if self.y >= 74 then
		spr(self.img, self.x, self.y)
	end
end

function MText:update()

end

function MText:move(new_pos)
    flux.to(self, 1.5, { x = new_pos.x, y = new_pos.y }):ease("sineout"):oncomplete(
            function()
                self:remove()
            end
        )
end

function MText:remove()
    del(all_m_text, self)
end

