bank_panel = {
    x = 100,
    y = 0,
    tab = Tab("right", 5, "bank"),
    items = {},
    is_showing = false,
    labels = {},
    transaction_value = 0,
    lbl_get = Label.new("get", 0, 28, 7),
    lbl_pay = Label.new("pay", 0, 28, 7),

    lbl_more = Label.new(" + ", 0, 12, 7),
    lbl_less = Label.new(" - ", 0, 12, 7),

    update = function(self)
        self.tab:update()

        --TODO: remove this from update. 
        self.lbl_get.x = self.x + 5
        self.lbl_pay.x = self.x + 30

        self.lbl_more.x = self.x + 5
        self.lbl_less.x = self.x + 30

        if self.is_showing then
            foreach(self.labels, function(obj) obj:update() end )
            --self.lbl_get:update()
            --self.lbl_pay:update()
            --self.lbl_more:update()
            --self.lbl_less:update()
            --if wheel_y > 0 then
            --    self.transaction_value = mid(0, self.transaction_value + 100, 4000)
            --elseif wheel_y < 0 then
            --    self.transaction_value = mid(0, self.transaction_value - 100, 4000)
            --end
        end
    end,
    draw = function(self)
        self.tab:draw()
        rectfill(self.x, 0, self.x + 50, 45, 0)
        print("\014    loan ", self.x, 2, 7)

        foreach(self.labels, function(obj) obj:draw() end )
        --self.lbl_get:draw()
        --self.lbl_pay:draw()

        --self.lbl_more:draw()
        --self.lbl_less:draw()
        print("\014" .. tostr(pad_zeros(self.transaction_value, 4)), self.x + 16, 12, 7)
        rect(self.x, 0, self.x + 50, 45, 7)
    end,
    slide_in = function(self)
        flux.to(self, 0.5, { x = 50 }):ease("quadout")
        flux.to(self.tab, 0.5, { x = 46 }):ease("quadout")
        self.is_showing = true
        stats_panel.tab.is_visible = false
        shop_panel.tab.is_visible = false
    end,
    slide_out = function(self)
        flux.to(self, 0.5, { x = 100 }):ease("quadout"):oncomplete(
            function()
                self.is_showing = false
                stats_panel.tab.is_visible = true
                shop_panel.tab.is_visible = true
                self.transaction_value = 0
            end
        )
        flux.to(self.tab, 0.5, { x = 95 }):ease("quadout")
    end,

    get_money = function(self)
        if self.transaction_value > 0 then
            player_stats.cash += self.transaction_value
            player_stats.debt += self.transaction_value + (self.transaction_value * .10)
            sfx(6)
        else
            sfx(8)
        end
        self.transaction_value = 0
    end,
    pay_money = function(self)
        if self.transaction_value > 0 and player_stats.cash >= self.transaction_value then
            player_stats.cash -= self.transaction_value
            player_stats.debt -= self.transaction_value

            self.transaction_value = 0

            if player_stats.debt <= 0 then
                debt_paid = true
            end

            sfx(7)
        else
            sfx(8)
        end

        
    end,
    change_trans_value = function(self, amount)
        self.transaction_value = mid(0, self.transaction_value + amount, 4000)
    end
}

bank_panel.tab.func = function() toggle_bank() end

bank_panel.lbl_get.callback = function() bank_panel:get_money() end
bank_panel.lbl_pay.callback = function() bank_panel:pay_money() end
bank_panel.lbl_more.callback = function() bank_panel:change_trans_value(100) end
bank_panel.lbl_less.callback = function() bank_panel:change_trans_value(-100) end

add(bank_panel.labels, bank_panel.lbl_get)
add(bank_panel.labels, bank_panel.lbl_pay)
add(bank_panel.labels, bank_panel.lbl_more)
add(bank_panel.labels, bank_panel.lbl_less)
