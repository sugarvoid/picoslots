


bank = {

}

bank_menu = {
    x = 160, 
    items = {},
    is_showing=false,
    draw=function(self)
        rectfill(self.x, 0, self.x+50, 56, 0)
        print("\014  bank    ", self.x, 2, 7)
		print("\014 get loan  ", self.x, 9, 7)
		print("\014 pay loan  ", self.x, 16, 7)
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
}