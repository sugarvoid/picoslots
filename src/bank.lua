


bank = {

}

bank_panel = {
    x = 100, 
    y=0,
    tab = Tab("right", 5, "bank"),
    items = {},
    is_showing=false,
    update=function (self)
        self.tab:update()
    end,
    draw=function(self)
        self.tab:draw()
        rectfill(self.x, 0, self.x+50, 56, 0)
        print("\014  loan ", self.x, 2, 7)
		print("\014 get   ", self.x, 9, 7)
		print("\014 pay   ", self.x, 16, 7)
		--print("\#g\014 pulls:  "..pad_zeros(player_stats.total_pulls, 5), bank_menu.x, 21, 7)

        spr(24, self.x + 5, 16+7)
        print("\0140", self.x + 5, 16+13, 7)
        spr(32, self.x + 5, 16+7+12)

        spr(24, self.x + 5+5, 16+7)
        print("\0140", self.x + 5+5, 16+13, 7)
        spr(32, self.x + 5+5, 16+7+12)

       -- spr(24, self.x + 5, 16+7)
        --print("\0140", self.x + 5, 16+13, 7)
        --spr(32, self.x + 5, 16+7+12)

        spr(24, self.x + 5+5+5, 16+7)
        print("\0140", self.x + 5+5+5, 16+13, 7)
        spr(32, self.x + 5+5+5, 16+7+12)

        spr(24, self.x + 5+5+5+5, 16+7)
        print("\0140", self.x + 5+5+5+5, 16+13, 7)
        spr(32, self.x + 5+5+5+5, 16+7+12)

        spr(24, self.x + 5+5+5+5+5, 16+7)
        print("\0140", self.x + 5+5+5+5+5, 16+13, 7)
        spr(32, self.x + 5+5+5+5+5, 16+7+12)

        spr(24, self.x + 5+5+5+5+5+5, 16+7)
        print("\0140", self.x + 5+5+5+5+5+5, 16+13, 7)
        spr(32, self.x + 5+5+5+5+5+5, 16+7+12)

        rect(self.x, 0, self.x+50, 56, 7)
    end,
    slide_in=function(self)
        flux.to(self, 0.5, { x = 50 }):ease("quadout")
        flux.to(self.tab, 0.5, { x = 46 }):ease("quadout")
        self.is_showing = true
        stats_panel.tab.is_visible = false
        shop_panel.tab.is_visible = false
    end,
    slide_out=function(self)
        flux.to(self, 0.5, { x = 100 }):ease("quadout"):oncomplete(
            function ()
                self.is_showing = false
                stats_panel.tab.is_visible = true
                shop_panel.tab.is_visible = true
            end
        )
        flux.to(self.tab, 0.5, { x = 95 }):ease("quadout")
        
    end,
}

bank_panel.tab.func = function() toggle_bank() end