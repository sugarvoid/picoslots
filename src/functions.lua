function pad_zeros(num, zeros)
    return string.format("%0" .. zeros .. "d", num)
end


function is_colliding(box, m_x, m_y)
    if m_x < box.x + box.w and
        m_x > box.x and
        m_y < box.y + box.h and
        m_y > box.y then
        return true
    else
        return false
    end
end