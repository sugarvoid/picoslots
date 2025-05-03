flux = get_flux()

local W, H = 100, 100

mx, my, mb = mouse()

local last_time = time()
local dt = 0
local key_delay = 0

local clock_pull = Clock()
local clock_stop_1 = Clock()
local clock_stop_2 = Clock()
local clock_stop_3 = Clock()

local clocks = {}
add(clocks, clock_pull)
add(clocks, clock_stop_1)
add(clocks, clock_stop_2)
add(clocks, clock_stop_3)

local results = { 0, 0, 0 }

local PAYOUTS_3 = {
    100, 200, 300, 400, 500, 600, 700, 800
}

local PAYOUTS_2 = {
    10, 20, 30, 40, 50, 60, 70, 80
}

auto_mode = false
has_spun = false
show_payout = false

payout = 0
curr_bet = 5
reels = {}
stats_hud = { x = -60, is_showing = false }
-- bank_menu = { x = 160, is_showing=false}
game_window = { x = 0 }

-- player stats (mabye save these?? yes!)
--player_stats = {}





local canvas = userdata("u8", W, H)
local canvas_stats = userdata("u8", W, H)
local canvas_bank = userdata("u8", W, H)
local canvas_shop = userdata("u8", W, H)


local tabs = {}

--local stat_tab = Tab("left", 5, "stats")
--stat_tab.func = function() toggle_stats() end

local shop_tab = Tab("left", 55, "shop")

local bank_tab = Tab("right", 5, "bank")

add(tabs, stats_panel.tab)
add(tabs, shop_panel.tab)
add(tabs, bank_panel.tab)

function _init()
    mkdir("/appdata/slots")
    -- player_stats = {
    --     total_pulls = 0,
    --     total_spent = 0,
    --     total_earned = 0,
    --     total_profit = 0,
    --     two_kind = 0,
    --     three_kind = 0,
    --     cash = 200,
    -- }
    --save_stats()
    load_stats()
    --player_stats = fetch("/appdata/slots/player_stats.pod")
    poke(0x5f5c, 255)
    poke(0x5f5d, 255)
    window {
        width      = 100,
        height     = 100,
        resizeable = false,
        title      = "Slots",
        fullscreen = false,
        x          = 260,
        y          = 50,
        --icon=get_spr(15)
    }

    reel_1 = Reel(20, 42)
    reel_2 = Reel(40, 42)
    reel_3 = Reel(60, 42)

    add(reels, reel_1)
    add(reels, reel_2)
    add(reels, reel_3)

    toggle_window_size()
end

function _update()
    mx, my, mb = mouse()
    


    if mb == 1 then
        if m_delay == 0 then
            on_mouse_click(mx, my)
            m_delay = m_delay + 1
            return
        end
    else
        m_delay = 0
    end


    if _keyp("s") then
        toggle_stats()
        
    end

    if _keyp("b") then
        toggle_bank()
    end

    if _keyp("f") then
        --toggle_window_size()
    end

    if not stats_hud.is_showing then
        if not auto_mode then
            if btnp(3) and not are_reels_spinning() and player_stats.cash >= curr_bet then
                pull_handle()
            end
        end

        if _keyp("a") then
            toggle_auto_mode()
        end

        if btnp(1) and not are_reels_spinning() then
            curr_bet = mid(5, curr_bet + 5, 80)
        elseif btnp(0) and not are_reels_spinning() then
            curr_bet = mid(5, curr_bet - 5, 80)
        end

        if btnp(4) then
            all_lights[2]:turn_on()
        end
    end

    update_dt()
    flux.update(dt)
    update_coins()
    update_lights()
    light_man:update()

    stats_panel:update()
    bank_panel:update()
    shop_panel:update()

    handle:update()
    --stat_tab:update()
    --shop_tab:update()
    --bank_tab:update()

    foreach(reels, function(obj) obj:update() end)
    foreach(clocks, function(obj) obj:update() end)

    if clock_pull.seconds >= 5 then
        clock_pull.seconds = 0
        pull_handle()
    end

    if clock_stop_1.seconds == 2 then
        clock_stop_1:stop()
        stop_reel(1)
    end
    if clock_stop_2.seconds == 3 then
        clock_stop_2:stop()
        stop_reel(2)
    end
    if clock_stop_3.seconds == 4 then
        clock_stop_3:stop()
        stop_reel(3)
    end
end

function toggle_stats()
    if stats_panel.is_showing then
        stats_panel:slide_out()
        --flux.to(stats_pannel, 0.5, { x = -60 }):ease("quadin")
        --flux.to(stats_pannel.stat_tab, 0.5, { x = 2 }):ease("quadin")
        --flux.to(stats_hud, 0.5, { x = -60 }):ease("quadin")
        flux.to(game_window, 0.5, { x = 0 }):ease("quadin")

        --stats_hud.is_showing = false
        --store("/appdata/slots/player_stats.pod", player_stats )
    else
        stats_panel:slide_in()
        --flux.to(stats_hud, 0.5, { x = -2 }):ease("quadout")
        --flux.to(stats_pannel, 0.5, { x = -2 }):ease("quadout")
        --flux.to(stats_pannel.stat_tab, 0.5, { x = 56 }):ease("quadout")
        flux.to(game_window, 0.5, { x = (W / 2) + 10 }):ease("quadout")
        --stats_hud.is_showing = true
    end
end

function toggle_shop()
    if shop_panel.is_showing then
        shop_panel:slide_out()
        
        --flux.to(stats_hud, 0.5, { x = -60 }):ease("quadin")
        flux.to(game_window, 0.5, { x = 0 }):ease("quadin")


        --store("/appdata/slots/player_stats.pod", player_stats )
    else
  
        shop_panel:slide_in()
        
        flux.to(game_window, 0.5, { x = (W / 2) + 10 }):ease("quadout")
    end
end

function toggle_bank()
    --toggle_stats()
    if bank_panel.is_showing then
        bank_panel:slide_out()
        --flux.to(bank_menu, 0.5, { x = 160 }):ease("quadin")
        flux.to(game_window, 0.5, { x = 0 }):ease("quadin")

        
        --store("/appdata/slots/player_stats.pod", player_stats )
    else
        --flux.to(bank_menu, 0.5, { x = 50 }):ease("quadout")
        bank_panel:slide_in()
        flux.to(game_window, 0.5, { x = -W / 2 }):ease("quadout")
 
    end
end

function _draw()
    set_draw_target(canvas_stats)

    cls()
    stats_panel:draw()
    --rectfill(stats_hud.x, 0, stats_hud.x + 56, 7 + 50, 1)
    --print("\014     stats    ", stats_hud.x, 0, 7)
    --print("\014 spent:  " .. pad_zeros(player_stats.total_spent, 5), stats_hud.x, 7, 7)
    --print("\014 profit: " .. pad_zeros(player_stats.total_profit, 5), stats_hud.x, 14, 7)
    --print("\014 pulls:  " .. pad_zeros(player_stats.total_pulls, 5), stats_hud.x, 21, 7)
    --print("\014 2-kind: " .. pad_zeros(player_stats.two_kind, 5), stats_hud.x, 28, 7)
    --print("\014 3-kind: " .. pad_zeros(player_stats.three_kind, 5), stats_hud.x, 35, 7)
    --rect(stats_hud.x, 0, stats_hud.x + 56, 7 + 50, 7)


    set_draw_target()

    cls()
    set_draw_target(canvas)
    cls()

    line(0, 80, 17, 80, 4)
    line(80, 80, 100, 80, 4)

    spr(64, 15, 25)
    draw_lights()
    draw_coins()

    clip(20, 42, 58, 20)
    reel_1:draw()
    reel_2:draw()
    reel_3:draw()
    clip()

    spr(12, 78, 52)

    handle:draw()

    -- print("\014" .. pad_zeros(curr_bet, 2), 46, 62, 7)


    --print("mem: " .. stat(0) .. "kb", 10, 0, 8)
    --print("cpu: " .. stat(1) * 100 .. "%", 10, 8, 8)

    hud:draw()
    
    -- stat_tab:draw()
    



    set_draw_target()


    set_draw_target(canvas_bank)
    cls()
    bank_panel:draw()
    set_draw_target()


    set_draw_target(canvas_shop)
    cls()
    shop_panel:draw()
    set_draw_target()





    sspr(canvas_bank, 0, 0, 100, 100, 0, 0, W, H)
    sspr(canvas, 0, 0, 100, 100, game_window.x, 0, W, H)
    sspr(canvas_stats, 0, 0, 100, 100, 0, 0, W, H)
    sspr(canvas_shop, 0, 0, 100, 100, 0, 0, W, H)
end

function start_reels()
    sfx(3, 2)
    results = { 0, 0, 0 }
    payout = 0
    show_payout = false
    has_spun = true
    foreach(reels, function(obj) obj:spin() end)
end

function stop_reel(num)
    if num == 1 then
        reel_1:stop()
        results[1] = reel_1.face
    elseif num == 2 then
        reel_2:stop()
        results[2] = reel_2.face
    elseif num == 3 then
        reel_3:stop()
        results[3] = reel_3.face
    end
    if not are_reels_spinning() and has_spun then
        sfx(-1, 2)
        has_spun = false
        show_payout = true
        payout = get_payout(results)
        payout = payout * (curr_bet / 5)
        hud:update_payout_spr(payout)
        player_stats.cash = mid(0, player_stats.cash + payout, 999999)
        player_stats.total_earned += payout
        player_stats.total_profit = player_stats.total_earned - player_stats.total_spent
        save_stats()
    end
end

function update_dt()
    local t = time()
    dt = t - last_time
    last_time = t
end

function on_mouse_click(x, y)
    for t in all(tabs) do
        if t.is_hovered then
            t:was_clicked()
            return
        end
    end

    if handle.is_hovered and not stats_hud.is_showing then
        if not are_reels_spinning() and player_stats.cash >= curr_bet then
            pull_handle()
        end
        return
    end
end

function pad_zeros(num, zeros)
    return string.format("%0" .. zeros .. "d", num)
end

function toggle_auto_mode()
    auto_mode = not auto_mode
    if auto_mode then
        if not are_reels_spinning() then
            pull_handle()
        else
            start_reel_clocks()
        end
        clock_pull:start()
    else
        clock_pull:stop()
    end
end

function are_reels_spinning()
    return reel_1.spinning or reel_2.spinning or reel_3.spinning
end

function pull_handle()
    handle:pull()
    start_reel_clocks()
end

function start_reel_clocks()
    clock_stop_1:start()
    clock_stop_2:start()
    clock_stop_3:start()
end

function _keyp(k)
    if keyp(k) and key_delay <= 0 then
        key_delay = 20
        return true
    else
        key_delay = mid(0, key_delay - 0.5, 21)
    end
end

function get_payout(r)
    --TODO: Figure out better payout math
    if r[1] == 0 or r[2] == 0 or r[3] == 0 then
        return 0
    end
    if r[1] == r[2] and r[2] == r[3] then
        sfx(2)
        light_man.is_running = true
        spawn_coin(10)
        player_stats.three_kind += 1
        return PAYOUTS_3[r[1]]
    elseif r[1] == r[2] or r[2] == r[3] or r[1] == r[3] then
        local match = r[1] == r[2] and r[1] or r[2] == r[3] and r[2] or r[1]
        sfx(1)
        light_man.is_running = true
        spawn_coin(10)
        player_stats.two_kind += 1
        return PAYOUTS_2[match] or 0
    else
        sfx(0)
        return 0
    end
end

--function update_player_cash()
--store("slots_cash.pod", cash)
--end

function update_title(num)
    window { title = "$" .. pad_zeros(num, 6) }
end

function toggle_window_size()
    --todo: both will always be the same, do i need both varibles?
    if W == 100 then
        W, H = 200, 200
    else
        W, H = 100, 100
    end
    window {
        width  = W,
        height = H
    }
    if stats_hud.is_showing then
        game_window.x = W / 2
    end
end

function load_stats()
    player_stats = fetch("/appdata/slots/player_stats.pod") or {
        total_pulls = 0,
        total_spent = 0,
        total_earned = 0,
        total_profit = 0,
        two_kind = 0,
        three_kind = 0,
        cash = 200,
        --- testing ---
        debt = 420165,
        date = { y = 0, m = 0, d = 0 },
    }
end

function save_stats()
    store("/appdata/slots/player_stats.pod", player_stats)
end

function is_colliding(m_x, m_y, box)
    if m_x < box.x + box.w and
        m_x > box.x and
        m_y < box.y + box.h and
        m_y > box.y then
        return true
    else
        return false
    end
end
