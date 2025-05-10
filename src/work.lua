
local OPERATORS = {"+", "-"} 


work_panel = {
    x = 100,
    y = 0,
    input = "",
    tab = Tab(88, 93, 50), --"right", 50, "work"),
    side="right",
    is_active=false,

    labels = {},

    lbl_0 = Label(" 0 ", 114, 70, 7),
    lbl_o = Label(" o ", 126, 70, 7),
    lbl_x = Label(" x ", 138, 70, 7),

    lbl_1 = Label(" 1 ", 114, 60, 7),
    lbl_2 = Label(" 2 ", 126, 60, 7),
    lbl_3 = Label(" 3 ", 138, 60, 7),


    lbl_4 = Label(" 4 ", 114, 52, 7),
    lbl_5 = Label(" 5 ", 126, 52, 7),
    lbl_6 = Label(" 6 ", 138, 52, 7),

    lbl_7 = Label(" 7 ", 114, 45, 7),
    lbl_8 = Label(" 8 ", 126, 45, 7),
    lbl_9 = Label(" 9 ", 138, 45, 7),


    lbl_question = Label("01+02= ", 105, 35, 7),
    lbl_answer = Label("", 135, 35, 7),

    current_q,
    current_a,
    
    
    draw = function(self)
        self.tab:draw()
        if self.is_active then
            rectfill(100, 30, 149, 85, 0)
            foreach(self.labels, function(obj) obj:draw() end )
            rect(100, 30, 149, 85, 7)
        end
    end,

    update=function(self)
        self.tab:update()
        if self.is_active then
            --self.stat_tab.x = self.x + 5
            foreach(self.labels, function(obj) obj:update() end )
            --self.tab:update()
            --self.lbl_7.x = self.x + 14
            --self.lbl_8.x = self.x + 14+12
            --self.lbl_9.x = self.x + 14+12+12

            ---self.lbl_4.x = self.x + 14
            --self.lbl_5.x = self.x + 14+12
            --self.lbl_6.x = self.x + 14+12+12

            --self.lbl_1.x = self.x + 14
            --self.lbl_2.x = self.x + 14+12
            --self.lbl_3.x = self.x + 14+12+12

            --self.lbl_0.x = self.x + 14
            --self.lbl_o.x = self.x + 14+12
            --self.lbl_x.x = self.x + 14+12+12

            --self.lbl_question.x  = self.x + 5 
            --self.lbl_answer.x  = self.x + 5+30
        end


        --self.lbl_item_1.x = self.x + 5
       -- self.lbl_item_2.x = self.x + 5
       -- self.lbl_item_3.x = self.x + 5
       -- self.lbl_item_4.x = self.x + 5
    end,

    -- slide_in=function(self)
    --     sfx(5)
    --     flux.to(self, 0.5, { x = 50 }):ease("quadout")
    --     flux.to(self.tab, 0.5, { x = 46 }):ease("quadout")
    --     self.is_showing = true
    --     stats_panel.tab.is_visible = false
    --     shop_panel.tab.is_visible = false
    --     stats_panel.tab.is_visible = false
    --     bank_panel.tab.is_visible = false
    --     shop_panel.tab.is_visible = false
    -- end,
    -- slide_out = function(self)
    --     sfx(9)
    --     flux.to(self, 0.5, { x = 100 }):ease("quadout"):oncomplete(
    --         function()
    --             self.is_showing = false
    --             stats_panel.tab.is_visible = true
    --             shop_panel.tab.is_visible = true
    --             bank_panel.tab.is_visible = true
    --             self.transaction_value = 0
    --         end
    --     )
    --     flux.to(self.tab, 0.5, { x = 95 }):ease("quadout")
    -- end,
    btn_pressed=function(self, b_idx)
        if b_idx < 11 and #self.input <= 1 then
            self.input ..= tostr(b_idx)
            self.lbl_answer:set_text(self.input)
        elseif b_idx == 11 then
            --local _a = tonum(self.input)
            if tonum(self.input) == self.current_a then
                
                sfx(10)
                player_stats.cash += 2
                notify("Earned $2.00")
                save_stats()
            else
               sfx(8)
            end 
            self.input = ""
            self.lbl_answer:set_text(self.input)
            self:get_equation()
            --self.lbl_question:set_text(get_equation())

        elseif b_idx == 12 then
            self.input = ""
            self.lbl_answer:set_text(self.input)
        end

        
        --notify(tostr(b_idx) .. " pressed")
    end,
    get_equation=function(self)
        self.lbl_question:set_text("")
        local num_1 = flr(rnd(20)) + 1
        local num_2 = flr(rnd(20)) + 1


        local operation = rnd({1, 2}) -- 1 addition, 2 subtraction 


        local question = pad_zeros(num_1, 2) .. OPERATORS[operation] .. pad_zeros(num_2,2) .. " = "



        local answer = 0

        if operation == 1 then
            answer = num_1 + num_2
        else
            answer = num_1 - num_2
        end 

        if answer < 0 or answer > 20 then
            return self:get_equation()
        else
            self.current_q = question
            self.current_a = answer
            --return question, answer
            self.lbl_question:set_text(question)
        end

end,
}

work_panel.tab.func = function() tab_clicked(work_panel) end

work_panel.lbl_o.callback = function() work_panel:btn_pressed(11) end
work_panel.lbl_x.callback = function() work_panel:btn_pressed(12) end

work_panel.lbl_0.callback = function() work_panel:btn_pressed(0) end
work_panel.lbl_1.callback = function() work_panel:btn_pressed(1) end
work_panel.lbl_2.callback = function() work_panel:btn_pressed(2) end
work_panel.lbl_3.callback = function() work_panel:btn_pressed(3) end
work_panel.lbl_4.callback = function() work_panel:btn_pressed(4) end
work_panel.lbl_5.callback = function() work_panel:btn_pressed(5) end
work_panel.lbl_6.callback = function() work_panel:btn_pressed(6) end
work_panel.lbl_7.callback = function() work_panel:btn_pressed(7) end
work_panel.lbl_8.callback = function() work_panel:btn_pressed(8) end
work_panel.lbl_9.callback = function() work_panel:btn_pressed(9) end

work_panel.lbl_question.is_clickable = false
work_panel.lbl_answer.is_clickable = false



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

work_panel:get_equation()






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


