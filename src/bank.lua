bank_panel = {
    --x = 100,
    --y = 0,
    tab = Tab(89, 93, 7),
    items = {},
    is_showing = false,
    side="right",
    is_active=false,
    labels = {},
    transaction_value = 0,
    lbl_get = Label("get", 105, 28, 7),
    lbl_pay = Label("pay", 130, 28, 7),
    lbl_more = Label(" + ", 105, 12, 7),
    lbl_less = Label(" - ", 130, 12, 7),

    update = function(self)
        self.tab:update()

        if self.is_active then
            foreach(self.labels, function(obj) obj:update() end )
        end
    end,

    draw = function(self)
        self.tab:draw()
        if self.is_active then
            rectfill(99, 0, 149, 40, 0)
            print("\014    loan ", 100, 2, 7)
            foreach(self.labels, function(obj) obj:draw() end )
            print("\014" .. tostr(pad_zeros(self.transaction_value, 4)), 116, 12, 7)
            rect(99, 0, 149, 40, 7)
        end
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

bank_panel.tab.func = function() tab_clicked(bank_panel) end

bank_panel.lbl_get.callback = function() bank_panel:get_money() end
bank_panel.lbl_pay.callback = function() bank_panel:pay_money() end
bank_panel.lbl_more.callback = function() bank_panel:change_trans_value(100) end
bank_panel.lbl_less.callback = function() bank_panel:change_trans_value(-100) end

add(bank_panel.labels, bank_panel.lbl_get)
add(bank_panel.labels, bank_panel.lbl_pay)
add(bank_panel.labels, bank_panel.lbl_more)
add(bank_panel.labels, bank_panel.lbl_less)
