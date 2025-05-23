flux = get_flux()

local W, H = 100, 100

local mx, my, mb = mouse()

local last_time = time()
local dt = 0
local key_delay = 0

local VERSION = 6
local sec_tick = 0

local clock_pull = Clock()
local clock_stop_1 = Clock()
local clock_stop_2 = Clock()
local clock_stop_3 = Clock()

local clocks = {}
add(clocks, clock_pull)
add(clocks, clock_stop_1)
add(clocks, clock_stop_2)
add(clocks, clock_stop_3)

window_scale = 2

cam_pos = { x = 0, y = 0 }

local results = { 0, 0, 0 }

local left_close = CloseRect(7, 40)
local right_close = CloseRect(50, 42)

left_close.func = function() pan_home() end
right_close.func = function() pan_home() end


local close_rects = {}

add(close_rects, left_close)
add(close_rects, right_close)

local PAYOUTS_3 = {
    100, 200, 300, 400, 500, 600, 700, 800
}

local PAYOUTS_2 = {
    10, 20, 30, 40, 50, 60, 70, 80
}

auto_mode = false
has_spun = false
show_payout = false

debt_paid = false

payout = 0
PULL_COST = 5
reels = {}

main_window = { x = 0 }


local canvas_main = userdata("u8", 100, 100)

local tabs = {}


add(tabs, stats_panel.tab)
add(tabs, shop_panel.tab)
add(tabs, bank_panel.tab)
add(tabs, work_panel.tab)

function _init()
    local folder_there, _, _ = fstat("/appdata/slots")

    if not folder_there then
        mkdir("/appdata/slots")
    end

    load_stats()

    poke(0x5f5c, 255)
    poke(0x5f5d, 255)
    window {
        width      = 100,
        height     = 100,
        resizeable = false,
        title      = "Picoslots",
        fullscreen = false,
        x          = 260,
        y          = 50,
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
            on_mouse_click()
            m_delay = m_delay + 1
            return
        end
    else
        m_delay = 0
    end

    if _keyp("f") then
        toggle_window_size()
    end

    --if btn(2) then cam_pos.y-=1  end
    --if btn(3) then cam_pos.y+=1  end
    --if btn(0) then cam_pos.x-=1  end
    --if btn(1) then cam_pos.x+=1  end

    if cam_pos.x == 0 then
        if not auto_mode then
            if btnp(3) and not are_reels_spinning() and player_stats.cash >= PULL_COST then
                pull_handle()
            end
        end

        if _keyp("a") then
            toggle_auto_mode()
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
    work_panel:update()
    handle:update()

    foreach(reels, function(obj) obj:update() end)
    foreach(clocks, function(obj) obj:update() end)
    foreach(all_m_text, function(obj) obj:update() end)
    foreach(close_rects, function(obj) obj:update() end)

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

    sec_tick -= 1
    if sec_tick <= 0 then
        on_second()
    end
end

function get_mouse_pos()
    --local _x, _y = mouse()
    return mx / window_scale + cam_pos.x, my / window_scale + cam_pos.y
end

function on_second()
    if player_stats.cooldown > 0 then
        player_stats.cooldown -= 1
    end
    sec_tick = 60
end

function tab_clicked(clicked_panel)
    if not clicked_panel.is_active then
        if clicked_panel.side == "left" then
            clicked_panel.is_active = true
            pan_left()
        elseif clicked_panel.side == "right" then
            clicked_panel.is_active = true
            pan_right()
        end
    else
        pan_home()
    end
end

function hide_panels()
    --TODO: Add
    -- this will hide all the other panels when one is clicked
end

function pan_home()
    if cam_pos.x != 0 then
        flux.to(cam_pos, 0.5, { x = 0 }):ease("quadin"):oncomplete(
            function()
                shop_panel.is_active = false
                bank_panel.is_active = false
                stats_panel.is_active = false
                work_panel.is_active = false
                show_tabs()
            end
        )
    end
end

function pan_left()
    flux.to(cam_pos, 0.5, { x = -60 }):ease("quadin")
end

function pan_right()
    flux.to(cam_pos, 0.5, { x = 50 }):ease("quadin")
end

function _draw()
    cls()

    if not debt_paid then
        -- Main Canvas --
        set_draw_target(canvas_main)
        cls()

        camera(cam_pos.x, cam_pos.y)

        stats_panel:draw()

        line(0, 80, 17, 80, 4)
        line(80, 80, 100, 80, 4)

        -- slot machine
        spr(64, 15, 25)

        draw_lights()
        draw_coins()

        --clip(20, 42, 58, 20)
        reel_1:draw()
        reel_2:draw()
        reel_3:draw()

        handle:draw()

        bank_panel:draw()
        shop_panel:draw()
        work_panel:draw()

        hud:draw()

        --foreach(close_rects, function(obj) obj:draw() end)

        set_draw_target()
        sspr(canvas_main, 0, 0, 100, 100, cam_pos.x, cam_pos.y, W, H)
    else
        print("Debt paid", 30, 50, 7)
    end
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
        payout = payout * (PULL_COST / 5)
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

function on_mouse_click()
    for t in all(tabs) do
        if t.is_hovered and t.is_visible then
            t:was_clicked()
            hide_tabs(t)
            return
        end
    end

    if bank_panel.is_active then
        for l in all(bank_panel.labels) do
            if l.is_hovered then
                l:was_clicked()
                return
            end
        end
    end

    if shop_panel.is_active then
        for l in all(shop_panel.labels) do
            if l.is_hovered then
                l:was_clicked()
                return
            end
        end
    end

    if work_panel.is_active then
        for l in all(work_panel.labels) do
            if l.is_hovered then
                l:was_clicked()
                return
            end
        end
    end

    if handle.is_hovered and cam_pos.x == 0 then
        if not are_reels_spinning() and player_stats.cash >= PULL_COST then
            pull_handle()
        end
        return
    end

    if cam_pos.x != 0 then
        for r in all(close_rects) do
            if r.is_hovered then
                r:was_clicked()
                return
            end
        end
    end
end

function hide_tabs(clicked_tab)
    for t in all(tabs) do
        if t != clicked_tab then
            t.is_visible = false
        end
    end
end

function show_tabs()
    for t in all(tabs) do
        t.is_visible = true
    end
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

function update_title(num)
    window { title = num }
end

function draw_cooldown(x, y)
    p8_print(seconds_to_hms(player_stats.cooldown), x, y, 7)
end

function toggle_window_size()
    --todo: both will always be the same, do i need both varibles?
    if W == 100 then
        W, H = 200, 200
        window_scale = 2
    else
        W, H = 100, 100
        window_scale = 1
    end
    window {
        width  = W,
        height = H
    }
    if stats_panel.is_showing or shop_panel.is_showing then
        main_window.x = W / 2
    elseif bank_panel.is_showing then
        main_window.x = -W / 2
    end
end

function load_stats()
    local data = fetch("/appdata/slots/save_data.pod")

    if not data or data.version < VERSION then
        player_stats = create_new_save()
    else
        player_stats = data
    end
end

function create_new_save()
    return {
        version = 6,
        total_pulls = 0,
        total_spent = 0,
        total_earned = 0,
        total_profit = 0,
        two_kind = 0,
        three_kind = 0,
        cash = 100,
        debt = 22100,
        cooldown = 0,
        earned = 0,
        date = { y = 0, m = 0, d = 0 },
    }
end

function save_stats()
    store("/appdata/slots/save_data.pod", player_stats)
end

function seconds_to_hms(seconds)
    local h = flr(seconds / 3600)
    local m = flr((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end
