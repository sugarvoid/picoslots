stats_panel = {
    x = -60,
    y = 0,
    tab = Tab("left", 5, "stats"),
    
    draw = function(self)
        rectfill(self.x, 0, self.x + 56, 7 + 42, 0)
        --print("\014     stats    ", stats_hud.x, 0, 7)
        print("\014 debt:  " .. pad_zeros(player_stats.debt, 5), self.x, 7, 8)
        --print("\014 profit: " .. pad_zeros(player_stats.total_spent, 5), self.x, 14, 7)
        print("\014 pulls:  " .. pad_zeros(player_stats.total_pulls, 5), self.x, 21, 7)
        print("\014 2-kind: " .. pad_zeros(player_stats.two_kind, 5), self.x, 28, 7)
        print("\014 3-kind: " .. pad_zeros(player_stats.three_kind, 5), self.x, 35, 7)
        --print("\014 3-kind: " .. pad_zeros(player_stats.three_kind, 5), self.x, 42, 7)
        rect(self.x, 0, self.x + 56, 7 + 42, 7)
        self.tab:draw()
    end,

    update=function(self)
        --self.stat_tab.x = self.x + 5
        self.tab:update()
    end,

    slide_in=function(self)
        sfx(5)
        flux.to(self, 0.5, { x = -2 }):ease("quadout")
        flux.to(self.tab, 0.5, { x = 56 }):ease("quadout")
        self.is_showing = true
        shop_panel.tab.is_visible = false
        bank_panel.tab.is_visible = false
    end,
    slide_out=function(self)
        sfx(9)
        flux.to(self, 0.5, { x = -60 }):ease("quadin"):oncomplete(
            function ()
                self.is_showing = false
               -- stats_display.stat_tab.is_visible = true
                shop_panel.tab.is_visible = true
                bank_panel.tab.is_visible = true
            end
        )
        flux.to(self.tab, 0.5, { x = 2 }):ease("quadin")
        
    end,
}

stats_panel.tab.func = function() toggle_stats() end
