
local OPERATORS = {"+", "-"} 


work_panel = {
    x = 100,
    y = 0,

    tab = Tab(88, 93, 50), --"right", 50, "work"),

    labels = {},

    lbl_0 = Label(" 0 ", 0, 70, 7),
    lbl_o = Label(" o ", 0, 70, 7),
    lbl_x = Label(" x ", 0, 70, 7),

    lbl_1 = Label(" 1 ", 0, 60, 7),
    lbl_2 = Label(" 2 ", 0, 60, 7),
    lbl_3 = Label(" 3 ", 0, 60, 7),


    lbl_4 = Label(" 4 ", 10, 52, 7),
    lbl_5 = Label(" 5 ", 18, 52, 7),
    lbl_6 = Label(" 6 ", 26, 52, 7),

    lbl_7 = Label(" 7 ", 10, 45, 7),
    lbl_8 = Label(" 8 ", 18, 45, 7),
    lbl_9 = Label(" 9 ", 26, 45, 7),


    lbl_question = Label("01+02= ", 26, 35, 7),
    lbl_answer = Label("03", 26, 35, 7),

    
    
    draw = function(self)
        self.tab:draw()
        rectfill(self.x, 30, self.x + 50, 85, 0)
 
        --print("\014 click to buy    ", self.x, 52, 7)
        --print("\014 item a: " .. pad_zeros(200, 5), self.x, 60, 7)
       -- print("\014 item b: " .. pad_zeros(300, 5), self.x, 67, 7)
       -- print("\014 reset:  " .. pad_zeros(0, 5), self.x, 67+7, 7)
        foreach(self.labels, function(obj) obj:draw() end )
        --print("\014 2-kind: " .. pad_zeros(player_stats.two_kind, 5), self.x, 28, 7)
        --print("\014 3-kind: " .. pad_zeros(player_stats.three_kind, 5), self.x, 35, 7)
       -- rect(self.x, self.y, self.x + 56, self.y + 40, 7)
        --self.tab:draw()
        rect(self.x, 30, self.x + 50, 85, 7)
    end,

    update=function(self)
        self.tab:update()
        --self.stat_tab.x = self.x + 5
        foreach(self.labels, function(obj) obj:update() end )
        --self.tab:update()
        self.lbl_7.x = self.x + 14
        self.lbl_8.x = self.x + 14+12
        self.lbl_9.x = self.x + 14+12+12

        self.lbl_4.x = self.x + 14
        self.lbl_5.x = self.x + 14+12
        self.lbl_6.x = self.x + 14+12+12

        self.lbl_1.x = self.x + 14
        self.lbl_2.x = self.x + 14+12
        self.lbl_3.x = self.x + 14+12+12

        self.lbl_0.x = self.x + 14
        self.lbl_o.x = self.x + 14+12
        self.lbl_x.x = self.x + 14+12+12

        self.lbl_question.x  = self.x + 5 
        self.lbl_answer.x  = self.x + 5+30


        --self.lbl_item_1.x = self.x + 5
       -- self.lbl_item_2.x = self.x + 5
       -- self.lbl_item_3.x = self.x + 5
       -- self.lbl_item_4.x = self.x + 5
    end,

    slide_in=function(self)
        sfx(5)
        flux.to(self, 0.5, { x = 50 }):ease("quadout")
        flux.to(self.tab, 0.5, { x = 46 }):ease("quadout")
        self.is_showing = true
        stats_panel.tab.is_visible = false
        shop_panel.tab.is_visible = false
        stats_panel.tab.is_visible = false
        bank_panel.tab.is_visible = false
        shop_panel.tab.is_visible = false
    end,
    slide_out = function(self)
        sfx(9)
        flux.to(self, 0.5, { x = 100 }):ease("quadout"):oncomplete(
            function()
                self.is_showing = false
                stats_panel.tab.is_visible = true
                shop_panel.tab.is_visible = true
                bank_panel.tab.is_visible = true
                self.transaction_value = 0
            end
        )
        flux.to(self.tab, 0.5, { x = 95 }):ease("quadout")
    end,
    btn_pressed=function(self, b_idx)
        notify(tostr(b_idx) .. " pressed")
    end
}

work_panel.tab.func = function() toggle_work() end

work_panel.lbl_o.callback = function() work_panel:btn_pressed(11) end
work_panel.lbl_x.callback = function() work_panel:btn_pressed(12) end

work_panel.lbl_0.callback = function() work_panel:btn_pressed() end
work_panel.lbl_1.callback = function() work_panel:btn_pressed() end
work_panel.lbl_2.callback = function() work_panel:btn_pressed() end
work_panel.lbl_3.callback = function() work_panel:btn_pressed() end
work_panel.lbl_4.callback = function() work_panel:btn_pressed() end
work_panel.lbl_5.callback = function() work_panel:btn_pressed() end
work_panel.lbl_6.callback = function() work_panel:btn_pressed() end
work_panel.lbl_7.callback = function() work_panel:btn_pressed() end
work_panel.lbl_8.callback = function() work_panel:btn_pressed() end
work_panel.lbl_9.callback = function() work_panel:btn_pressed() end

work_panel.lbl_question.is_static = true
work_panel.lbl_answer.is_static = true



add(work_panel.labels, work_panel.lbl_item_1)
add(work_panel.labels, work_panel.lbl_0)
add(work_panel.labels, work_panel.lbl_1)
add(work_panel.labels, work_panel.lbl_2)
add(work_panel.labels, work_panel.lbl_3)
add(work_panel.labels, work_panel.lbl_4)
add(work_panel.labels, work_panel.lbl_5)
add(work_panel.labels, work_panel.lbl_6)
add(work_panel.labels, work_panel.lbl_7)
add(work_panel.labels, work_panel.lbl_8)
add(work_panel.labels, work_panel.lbl_9)
add(work_panel.labels, work_panel.lbl_o)
add(work_panel.labels, work_panel.lbl_x)

add(work_panel.labels, work_panel.lbl_question)
add(work_panel.labels, work_panel.lbl_answer)








function get_equation()
    local num_1 = math.random(1, 20)
    local num_2 = math.random(1, 20)


    local operation = math.random(1, 2) -- 1 addition, 2 subtraction 


    local question = pad_zeros(num_1, 2) .. OPERATORS[operation] .. pad_zeros(num_2,2) .. " = "



    local answer = ""

    if operation == 1 then
        answer = num_1 + num_2
    else
        answer = num_1 - num_2
    end 

    if answer < 0 or answer > 20 then
        return get_equation()
    else
        return question, answer
    end

end

work_panel.lbl_question:set_text(get_equation())
