shop_panel = {
    x = -60,
    y = 50,
    tab = Tab(90, 0, 50, 7, 27),
    side = "left",
    is_active = false,

    labels = {},
    lbl_item_1 = Label("item a $200", -55, 60, 7),
    lbl_item_2 = Label("item b $300", -55, 67, 7),
    lbl_item_3 = Label("reset  $000", -55, 67 + 7, 7),
    -- lbl_item_4 = Label("sell soul", -55, 67 + 7 + 9, 7),

    draw = function(self)
        self.tab:draw()
        if self.is_active then
            rectfill(-60, 50, 0, 90, 0)
            print("\014 click to buy    ", self.x, 52, 7)
            foreach(self.labels, function(obj) obj:draw() end)
            rect(-60, 50, 0, 90, 7)
        end
    end,

    update = function(self)
        foreach(self.labels, function(obj) obj:update() end)
        self.tab:update()
    end,

    buy_item = function(self, item_idx)
        if item_idx == 3 then
            player_stats = create_new_save()
            notify("resetting game...")
        elseif item_idx == 1 then
            if player_stats.cash >= 200 then
                player_stats.cash -= 200
            end
        elseif item_idx == 2 then
            if player_stats.cash >= 300 then
                player_stats.cash -= 300
            end
        end
        save_stats()
    end
}

shop_panel.tab.func = function() tab_clicked(shop_panel) end

shop_panel.lbl_item_1.callback = function() shop_panel:buy_item(1) end
shop_panel.lbl_item_2.callback = function() shop_panel:buy_item(2) end
shop_panel.lbl_item_3.callback = function() shop_panel:buy_item(3) end
--shop_panel.lbl_item_4.callback = function() shop_panel:buy_item(4) end

add(shop_panel.labels, shop_panel.lbl_item_1)
add(shop_panel.labels, shop_panel.lbl_item_2)
add(shop_panel.labels, shop_panel.lbl_item_3)
--add(shop_panel.labels, shop_panel.lbl_item_4)
