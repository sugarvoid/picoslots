stats_panel = {
    x = -60,
    y = 0,
    tab = Tab(91, 0, 7),

    side="left",
    is_active=false,
    
    draw = function(self)
        self.tab:draw()
        if self.is_active then
            rectfill(-60, 0, 0, 45, 0)
            print("\014 debt:  " .. pad_zeros(player_stats.debt, 5), self.x, 7, 8)
            print("\014 pulls:  " .. pad_zeros(player_stats.total_pulls, 5), self.x, 21, 7)
            print("\014 2-kind: " .. pad_zeros(player_stats.two_kind, 5), self.x, 28, 7)
            print("\014 3-kind: " .. pad_zeros(player_stats.three_kind, 5), self.x, 35, 7)
            rect(-60, 0, 0, 45, 7)
        end
        
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
        work_panel.tab.is_visible = false
    end,
    slide_out=function(self)
        sfx(9)
        flux.to(self, 0.5, { x = -60 }):ease("quadin"):oncomplete(
            function ()
                self.is_showing = false
               -- stats_display.stat_tab.is_visible = true
                shop_panel.tab.is_visible = true
                bank_panel.tab.is_visible = true
                work_panel.tab.is_visible = true
            end
        )
        flux.to(self.tab, 0.5, { x = 2 }):ease("quadin")
        
    end,
}

stats_panel.tab.func = function() tab_clicked(stats_panel) end
