flux = get_flux()

local W, H = 100, 100

local mx, my, mb = mouse()

local last_time = time()
local dt = 0
local key_delay = 0

local VERSION = 3

local clock_pull = Clock()
local clock_stop_1 = Clock()
local clock_stop_2 = Clock()
local clock_stop_3 = Clock()

local clocks = {}
add(clocks, clock_pull)
add(clocks, clock_stop_1)
add(clocks, clock_stop_2)
add(clocks, clock_stop_3)

mouse_offset = 2

cam_pos = {x=0, y=0}

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

debt_paid = false

payout = 0
curr_bet = 5
reels = {}

main_window = { x = 0 }


local canvas_main = userdata("u8", 100, 100)

--local canvas_stats = userdata("u8", W, H)
--local canvas_bank = userdata("u8", W, H)
--local canvas_shop = userdata("u8", W, H)
--local canvas_work = userdata("u8", W, H)

local cpu = 0


--local canvas_empty = userdata("u8", W, H)


local tabs = {}

--local stat_tab = Tab("left", 5, "stats")
--stat_tab.func = function() toggle_stats() end

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
        title      = "Slots",
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
            on_mouse_click(mx, my)
            m_delay = m_delay + 1
            return
        end
    else
        m_delay = 0
    end


    if _keyp("s") then
        tab_clicked(shop_panel)
    end

    if _keyp("i") then
        tab_clicked(stats_panel)
    end

    if _keyp("b") then
        tab_clicked(bank_panel)
    end

    if _keyp("e") then
        tab_clicked(work_panel)
    end

    if _keyp("f") then
        toggle_window_size()
    end


    if btn(2) then cam_pos.y-=1  end
    if btn(3) then cam_pos.y+=1  end
    if btn(0) then cam_pos.x-=1  end
    if btn(1) then cam_pos.x+=1  end


    if main_window.x == 0 then
        if not auto_mode then
            --if btnp(3) and not are_reels_spinning() and player_stats.cash >= curr_bet then
                --pull_handle()
            --end
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


    --update_title(string.format("%.2f", stat(1)*100) .. "% cpu")

    --cpu = string.format("%.2f", stat(1)*100) .. "% cpu"
    --cpu = stat(1)



    
end


function get_mouse_pos()
    local _x, _y = mouse()
    --return (mx-cam_pos.x)*mouse_offset, (my-cam_pos.y)*mouse_offset
    return _x/mouse_offset+cam_pos.x, _y/mouse_offset+cam_pos.y
end



-- function toggle_stats()
--     if stats_panel.is_showing then
--         stats_panel:slide_out()
--         flux.to(main_window, 0.5, { x = 0 }):ease("quadin")
--     else
--         stats_panel:slide_in()
--         flux.to(main_window, 0.5, { x = (W / 2) + 10 }):ease("quadout")
--     end
-- end

-- function toggle_shop()
--     if shop_panel.is_showing then
--         shop_panel:slide_out()
--         flux.to(main_window, 0.5, { x = 0 }):ease("quadin")
--     else
--         shop_panel:slide_in()
--         flux.to(main_window, 0.5, { x = (W / 2) + 10 }):ease("quadout")
--     end
-- end

-- function toggle_bank()
--     if bank_panel.is_showing then
--         bank_panel:slide_out()
--         flux.to(main_window, 0.5, { x = 0 }):ease("quadin")
--     else
--         bank_panel:slide_in()
--         flux.to(main_window, 0.5, { x = -W / 2 }):ease("quadout")
--     end
-- end

-- function toggle_work()
--     if work_panel.is_active then
--         work_panel:slide_out()
--         flux.to(main_window, 0.5, { x = 0 }):ease("quadin")
--     else
--         work_panel:slide_in()
--         flux.to(main_window, 0.5, { x = -W / 2 }):ease("quadout")
--     end
-- end

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
        --clicked_panel.is_active = false
    end
end

function hide_panels()
   --TODO: Add
   -- this will hide all the other panels when one is clicked
end

function pan_home()
    if true then
        --bank_panel:slide_out()
        flux.to(cam_pos, 0.5, { x = 0 }):ease("quadin"):oncomplete(
            function()
                shop_panel.is_active = false
                bank_panel.is_active = false
                stats_panel.is_active = false
                work_panel.is_active = false
            end
        )
    else
        --bank_panel:slide_in()
        --flux.to(main_window, 0.5, { x = -W / 2 }):ease("quadout")
    end
end

function pan_left()
    if true then
        --bank_panel:slide_out()
        flux.to(cam_pos, 0.5, { x = -60 }):ease("quadin")
    else
        --bank_panel:slide_in()
        --flux.to(main_window, 0.5, { x = -W / 2 }):ease("quadout")
    end
end

function pan_right()
    if true then
        --bank_panel:slide_out()
        flux.to(cam_pos, 0.5, { x = 50 }):ease("quadin")
    else
        --bank_panel:slide_in()
        --flux.to(main_window, 0.5, { x = -W / 2 }):ease("quadout")
    end
end

function _draw()
    cls()

    if not debt_paid then

        -- Stats Canvas --
        --set_draw_target(canvas_stats)
        --cls()
        
        

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
        hud:draw()
        bank_panel:draw()
        shop_panel:draw()
        work_panel:draw()
        set_draw_target()
        sspr(canvas_main, 0, 0, 100, 100, cam_pos.x, cam_pos.y, W, H)
    else
        print("Debt paid", 30, 50, 7)
    end


    local y = date("*t")
    --print(stat(1), (0+cam_pos.x)/mouse_offset, 190+cam_pos.y/mouse_offset, 7 )
    print(y.sec, (0+cam_pos.x)/mouse_offset, 190+cam_pos.y/mouse_offset, 7 )
    --window { title = tostr(stat(1)) }

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
        if not are_reels_spinning() and player_stats.cash >= curr_bet then
            pull_handle()
        end
        return
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
   -- window { title = "$" .. pad_zeros(num, 6) }
    window { title = num  }
end

function toggle_window_size()
    --todo: both will always be the same, do i need both varibles?
    if W == 100 then
        W, H = 200, 200
        mouse_offset = 2
    else
        W, H = 100, 100
        mouse_offset = 1
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
        version = 3,
        total_pulls = 0,
        total_spent = 0,
        total_earned = 0,
        total_profit = 0,
        two_kind = 0,
        three_kind = 0,
        cash = 200,
        debt = 22100,
        date = { y = 0, m = 0, d = 0 },
    }
end

function save_stats()
    store("/appdata/slots/save_data.pod", player_stats)
end


-- function get_panel_item_x(panel_x, offset)
--     return panel_x + offset
-- end

