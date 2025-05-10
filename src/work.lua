
local OPERATORS = {"+", "-"}

local COL_1 = 105
local COL_2 = 105+12
local COL_3 = 105+12+12

local ROW_1 = 45
local ROW_2 = 45+8
local ROW_3 = 45+8+8
local ROW_4 = 45+8+8+8

work_panel = {
    x = 100,
    y = 0,
    input = "",
    tab = Tab(88, 93, 50),
    side="right",
    is_active=false,
    labels = {},

    lbl_0 = Label(" 0 ", COL_1, ROW_4, 7),

    lbl_enter = Label(" e ", COL_2, ROW_4, 7),
    lbl_clear = Label(" c ", COL_3, ROW_4, 7),

    lbl_1 = Label(" 1 ", COL_1, ROW_3, 7),
    lbl_2 = Label(" 2 ", COL_2, ROW_3, 7),
    lbl_3 = Label(" 3 ", COL_3, ROW_3, 7),


    lbl_4 = Label(" 4 ", COL_1, ROW_2, 7),
    lbl_5 = Label(" 5 ", COL_2, ROW_2, 7),
    lbl_6 = Label(" 6 ", COL_3, ROW_2, 7),

    lbl_7 = Label(" 7 ", COL_1, ROW_1, 7),
    lbl_8 = Label(" 8 ", COL_2, ROW_1, 7),
    lbl_9 = Label(" 9 ", COL_3, ROW_1, 7),


    lbl_question = Label("01+02= ", 105, 35, 7),
    lbl_answer = Label("", 135, 35, 7),

    current_q="",
    current_a=0,

    draw = function(self)
        self.tab:draw()
        if self.is_active then
            rectfill(99, 30, 149, 85, 0)
            if player_stats.cooldown <= 0 then
                foreach(self.labels, function(obj) obj:draw() end )
            else
                p8_print("cooldown", 109, 52, 7)
                rect(100, 31, 148, 84, 8)

                draw_cooldown(109, 70)
            end
            rect(99, 30, 149, 85, 7)
        end
    end,

    update=function(self)
        self.tab:update()
        if self.is_active and player_stats.cooldown <= 0 then
            foreach(self.labels, function(obj) obj:update() end )
        end
    end,

    btn_pressed=function(self, b_idx)
        if b_idx < 11 and #self.input <= 1 then
            self.input ..= tostr(b_idx)
            self.lbl_answer:set_text(self.input)
        elseif b_idx == 11 and #self.input > 0 then
            --local _a = tonum(self.input)
            if tonum(self.input) == self.current_a then
                
                sfx(10)
                player_stats.cash += 2
                player_stats.earned += 2
                MText:new("$2", 27, {x=38, y=2}, 110, 30)
                save_stats()
            else
               sfx(8)
               player_stats.cooldown += 30
            end 
            self.input = ""
            self.lbl_answer:set_text(self.input)
            self:get_equation()
        elseif b_idx == 12 then
            self.input = ""
            self.lbl_answer:set_text(self.input)
        end
    end,
    get_equation=function(self)
        self.lbl_question:set_text("")
        local num_1 = flr(rnd(20)) + 1
        local num_2 = flr(rnd(20)) + 1

        -- 1 addition, 2 subtraction 
        local operation = rnd({1, 2}) 
        local question = pad_zeros(num_1, 2) .. OPERATORS[operation] .. pad_zeros(num_2, 2) .. " = "
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
            self.lbl_question:set_text(question)
        end
end,
}

work_panel.tab.func = function() tab_clicked(work_panel) end

work_panel.lbl_enter.callback = function() work_panel:btn_pressed(11) end
work_panel.lbl_clear.callback = function() work_panel:btn_pressed(12) end

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
add(work_panel.labels, work_panel.lbl_enter)
add(work_panel.labels, work_panel.lbl_clear)

add(work_panel.labels, work_panel.lbl_question)
add(work_panel.labels, work_panel.lbl_answer)

work_panel:get_equation()

