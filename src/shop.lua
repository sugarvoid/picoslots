shop_panel = {
    x = -60,
    y = 50,
    tab = Tab(90, 0, 50, 7, 27),
    side="left",
    is_active=false,

    labels = {},
    lbl_item_1 = Label("item a $200", -55, 60, 7),
    lbl_item_2 = Label("item b $300", -55, 67, 7),
    lbl_item_3 = Label("reset  $000", -55, 67+7, 7),
    lbl_item_4 = Label("sell soul", -55, 67+7+9, 7),
    
    draw = function(self)
        self.tab:draw()
        if self.is_active then
            rectfill(-60, 50, 0, 90, 0)
            print("\014 click to buy    ", self.x, 52, 7)
            --print("\014 item a: " .. pad_zeros(200, 5), self.x, 60, 7)
        -- print("\014 item b: " .. pad_zeros(300, 5), self.x, 67, 7)
        -- print("\014 reset:  " .. pad_zeros(0, 5), self.x, 67+7, 7)
            foreach(self.labels, function(obj) obj:draw() end )
            --print("\014 2-kind: " .. pad_zeros(player_stats.two_kind, 5), self.x, 28, 7)
            --print("\014 3-kind: " .. pad_zeros(player_stats.three_kind, 5), self.x, 35, 7)
            rect(-60, 50, 0, 90, 7)
        end
        
    end,

    update=function(self)
        --self.stat_tab.x = self.x + 5
        foreach(self.labels, function(obj) obj:update() end )
        self.tab:update()
        --self.lbl_item_1.x = self.x + 5
        --self.lbl_item_2.x = self.x + 5
        --self.lbl_item_3.x = self.x + 5
        --self.lbl_item_4.x = self.x + 5
        
    end,

    -- slide_in=function(self)
    --     sfx(5)
    --     flux.to(self, 0.5, { x = -2 }):ease("quadout")
    --     flux.to(self.tab, 0.5, { x = 56 }):ease("quadout")
    --     self.is_showing = true
    --     stats_panel.tab.is_visible = false
    --     bank_panel.tab.is_visible = false
    --     work_panel.tab.is_visible = false
    -- end,
    -- slide_out=function(self)
    --     sfx(9)
    --     flux.to(self, 0.5, { x = -60 }):ease("quadin"):oncomplete(
    --         function ()
    --             self.is_showing = false
    --             stats_panel.tab.is_visible = true
    --             work_panel.tab.is_visible = true
    --            -- shop_pannel.tab.is_visible = true
    --             bank_panel.tab.is_visible = true
    --         end
    --     )
    --     flux.to(self.tab, 0.5, { x = 2 }):ease("quadin")
        
    -- end,
    buy_item=function(self,item_idx)
        --notify("buying item")
        notify("buying item " .. tostr(item_idx))
        if item_idx == 3 then
            player_stats = create_new_save()
            notify("resetting game...")
        end
    end
}

shop_panel.tab.func = function() tab_clicked(shop_panel) end


shop_panel.lbl_item_1.callback = function() shop_panel:buy_item(1) end
shop_panel.lbl_item_2.callback = function() shop_panel:buy_item(2) end
shop_panel.lbl_item_3.callback = function() shop_panel:buy_item(3) end
shop_panel.lbl_item_4.callback = function() shop_panel:buy_item(4) end


add(shop_panel.labels, shop_panel.lbl_item_1)
add(shop_panel.labels, shop_panel.lbl_item_2)
add(shop_panel.labels, shop_panel.lbl_item_3)
add(shop_panel.labels, shop_panel.lbl_item_4)

