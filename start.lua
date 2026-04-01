----------------------------------
-- Author:      Zineddine SAIBI
-- Software:    Auzia Conky
-- Type:        Conky Theme
-- Version:     0.4
-- License:     GPL-3.0
-- repository:  https://www.github.com/SZinedine/auzia-conky
----------------------------------
require("abstract")

local S = require("rc/gauge")
local to_draw_titles = true

-- set the appropriate cpu object according to the chosen value for `cpu_cores`
local ncores = nil
if     cpu_cores == 0  then ncores = S.cpu.cores._0cores
elseif cpu_cores == 2  then ncores = S.cpu.cores._2cores
elseif cpu_cores == 4  then ncores = S.cpu.cores._4cores
elseif cpu_cores == 6  then ncores = S.cpu.cores._6cores
elseif cpu_cores == 8  then ncores = S.cpu.cores._8cores
elseif cpu_cores == 10 then ncores = S.cpu.cores._10cores
elseif cpu_cores == 12 then ncores = S.cpu.cores._12cores
else
    print("ERROR. the provided value of cpu_cores is not valid. Defaulting to 4 cores")
    ncores = S.cpu.cores._4cores
end

function start()
    draw_cpu()
    draw_memory()
    draw_clock()
    draw_disks()
    draw_battery()
    draw_titles()
    draw_net()
    draw_igpu()
    draw_egpu()
end


function draw_single_cpu_core(coreN)
    local val = nil
    if coreN.number >= 0 then val = cpu_percent(coreN.number)
    else val = cpu_temperature()
    end

    ring_anticlockwise(S.cpu.x, S.cpu.y, coreN.radius, coreN.thickness, coreN.begin_angle, coreN.end_angle, val, coreN.max_value, color_frompercent(tonumber(val)))

    if coreN.text ~= nil then
        write(coreN.text.x, coreN.text.y, val .. coreN.text.post_particle, 12, colors.text)
    end
end


function draw_cpu()
    for i in pairs(ncores) do
        draw_single_cpu_core(ncores[i])
    end

    write_list_proccesses_cpu(160, 147, 20, 4, 12, colors.text)
end


function draw_memory()
    local memperc = memory_percent()
    local swpperc = swap_percent()
    local usedmem = string.format("Usage: %s / %s (%s%s)", memory(), memory_max(), memperc, "%")

    ring_clockwise(S.mem.x, S.mem.y, S.mem.radius, 18, 0, 320, memperc, 100, color_frompercent(tonumber(memperc)))
    ring_clockwise(S.mem.x, S.mem.y, S.mem.radius-18, 14, 0, 320, swpperc, 100, color_frompercent(tonumber(swpperc)))
    write(S.mem.text.indicators.x, S.mem.text.indicators.y, "ram: " ..memperc .. "%", 12, colors.text)
    write(S.mem.text.indicators.x, S.mem.text.indicators.y+22, "swap: " ..swpperc .. "%", 12, colors.text)

    write(S.mem.text.process_title.x, S.mem.text.process_title.y, usedmem, 12, colors.text)
    write_list_proccesses_mem(S.mem.text.processes.x, S.mem.text.processes.y, 20, 5, 12, colors.text)
end


function draw_clock()
    local s = time_second()
    local m = time_minute()
    local h = time_hour12()
    local date = string.format("%s, %s %s, %s", time_day_short(), time_month_short(), time_day_number(), time_year())

    ring_clockwise(S.clock.x, S.clock.y, S.clock.radius, S.clock.width/4, 60, 420, s, 59, colors.fg)
    ring_clockwise(S.clock.x, S.clock.y, S.clock.radius+7, S.clock.width/2, -60, 300, m, 59, colors.fg)
    ring_clockwise(S.clock.x, S.clock.y, S.clock.radius+18, S.clock.width, 0, 360, h, 23, colors.fg)

    write_bold(S.clock.hr.x, S.clock.hr.y, h, S.clock.font_height, colors.text)
    write(S.clock.mn.x, S.clock.mn.y, m, S.clock.font_m, colors.text)
    write(S.clock.dt.x, S.clock.dt.y, date, 12, colors.text)
    write(S.clock.ut.x, S.clock.ut.y, "Uptime: " .. uptime_short(), 11, colors.text)
end


function draw_disks()
    local rt = fs_used_perc("/")
    local hm = fs_used_perc("/mnt/Backup/")
    local rt_text = string.format("Root: %s / %s (%s)", fs_used("/"), fs_size("/"), fs_free("/"))
    local hm_text = string.format("Backup: %s / %s (%s)", fs_used("/mnt/Backup/"), fs_size("/mnt/Backup/"), fs_free("/mnt/Backup/"))

    ring_anticlockwise(S.disk.x, S.disk.y, S.disk.radius, S.disk.thickness, S.disk.begin_angle, S.disk.end_angle, rt, 100, color_frompercent(tonumber(rt)))
    ring_anticlockwise(S.disk.x, S.disk.y, S.disk.radius-22, S.disk.thickness, S.disk.begin_angle, S.disk.end_angle, hm, 100, color_frompercent(tonumber(hm)))

    write(S.disk.x+45, S.disk.y-S.disk.radius+10, rt_text, 11, colors.text)
    write(S.disk.x+40, S.disk.y-S.disk.radius+35, hm_text, 11, colors.text)

    local dsk_info = {
        "Read:  " .. diskio_read(""),
        "Write: " .. diskio_write(""),
    }
    write_line_by_line(S.disk.x-40, S.disk.y-10, 20, dsk_info, colors.text, 12)

end


function draw_net()
    ring_clockwise(S.net.x, S.net.y, S.net.radius, 15, S.net.begin_angle, S.net.end_angle, download_speed_kb(), download_rate_maximum, colors.fg)
    ring_clockwise(S.net.x, S.net.y, S.net.radius-18, 15, S.net.begin_angle, S.net.end_angle, upload_speed_kb(), upload_rate_maximum, colors.fg)

    write(S.net.indicators.down.x, S.net.indicators.down.y, "▼ ".. download_speed(), 12, colors.text)
    write(S.net.indicators.up.x, S.net.indicators.up.y, "▲ "..upload_speed(), 12, colors.text)

    write(S.net.total.down.x-50, S.net.y, "Total ", 12, colors.text)
    write(S.net.total.down.x, S.net.total.down.y, "▼".. download_total(), 12, colors.text)
    write(S.net.total.up.x, S.net.total.up.y, "▲"..upload_total(), 12, colors.text)

    local inf = {}
    table.insert(inf, "OS          :" .. parse("exec grep PRETTY_NAME /etc/os-release | cut -d'\"' -f2"))
    table.insert(inf, "Kernel      :" .. kernel())
    table.insert(inf, "SSID        :" .. string.sub(ssid(), 0, 15))
    table.insert(inf, "WiFi IP     :" .. local_ip())
    table.insert(inf, "Local IP    :" .. local_ipe())
    if use_public_ip then
        if get_public_ip == nil or (updates()%public_ip_refresh_rate) == 0 then
            update_public_ip()
        end

    table.insert(inf, "Public IP   :" .. get_public_ip())
    table.insert(inf, "Country     :" .. country())
    table.insert(inf, "ISP         :" .. isp())


    end
    write_line_by_line(S.net.list.x, S.net.list.y, 20, inf, colors.text, 12)
end


-- ── GPU Configuration ─────────────────────────────────────────────────────────
-- Adjust these to match your hardware:
local IGPU_VRAM_MAX  = 4096   -- iGPU shared VRAM ceiling in MB (e.g. 512–4096)
local IGPU_TEMP_MAX  = 95     -- iGPU max temp °C

local EGPU_VRAM_MAX  = 8192   -- eGPU dedicated VRAM in MB  (e.g. 4096, 8192)
local EGPU_POWER_MAX = 200    -- eGPU TDP in Watts
local EGPU_TEMP_MAX  = 95     -- eGPU max temp °C
-- ──────────────────────────────────────────────────────────────────────────────


-- ── AMD iGPU data (via sysfs + rocm-smi/sensors) ─────────────────────────────
-- Load: reads from /sys/class/drm (card0 = AMD iGPU on most systems)
-- VRAM: reads used VRAM from sysfs memory info
-- Temp: reads via sensors 'edge' label (AMD APU/iGPU standard label)

function igpu_load_percent()
    -- /sys/class/drm/cardX/device/gpu_busy_percent  — available on amdgpu driver
    local v = parse("exec cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null || cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null")
    local n = tonumber(v)
    if n ~= nil then return tostring(n) end
    -- fallback: rocm-smi
    v = parse("exec rocm-smi --showuse 2>/dev/null | awk '/GPU use/{gsub(/[^0-9]/,\"\",$NF); print $NF+0; exit}'")
    n = tonumber(v)
    return tostring(n ~= nil and n or 0)
end

function igpu_temp()
    -- amdgpu driver exposes temp via hwmon under the device
    local v = parse("exec cat /sys/class/drm/card0/device/hwmon/hwmon*/temp1_input 2>/dev/null | head -1")
    local n = tonumber(v)
    if n ~= nil and n > 1000 then return tostring(math.floor(n / 1000)) end  -- millidegrees → °C
    if n ~= nil and n > 0    then return tostring(n) end
    -- fallback: sensors edge label
    v = parse("exec sensors 2>/dev/null | awk '/^edge/{gsub(/[^0-9.]/,\"\",$2); print int($2+0); exit}'")
    n = tonumber(v)
    return tostring(n ~= nil and n or 0)
end

function igpu_vram_used()
    -- amdgpu sysfs: mem_info_vram_used in bytes
    local v = parse("exec cat /sys/class/drm/card0/device/mem_info_vram_used 2>/dev/null || cat /sys/class/drm/card1/device/mem_info_vram_used 2>/dev/null")
    local n = tonumber(v)
    if n ~= nil and n > 0 then return tostring(math.floor(n / 1024 / 1024)) end  -- bytes → MB
    return "0"
end

function igpu_vram_total()
    -- amdgpu sysfs: mem_info_vram_total in bytes
    local v = parse("exec cat /sys/class/drm/card0/device/mem_info_vram_total 2>/dev/null || cat /sys/class/drm/card1/device/mem_info_vram_total 2>/dev/null")
    local n = tonumber(v)
    if n ~= nil and n > 0 then return math.floor(n / 1024 / 1024) end  -- bytes → MB
    return IGPU_VRAM_MAX  -- fallback to configured max
end
-- ──────────────────────────────────────────────────────────────────────────────

function igpu_name()
    local v = parse("exec lspci 2>/dev/null | awk '/VGA|Display/{if(/AMD|ATI/){gsub(/.*\\[/,\"\"); gsub(/\\].*/,\"\"); print; exit}}'")
    return (v == nil or v == "") and "AMD iGPU" or v
end


function egpu_load()
    return parse("exec nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | tr -d ' '")
end

function egpu_vram_used()
    return parse("exec nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits 2>/dev/null | tr -d ' '")
end

function egpu_temp()
    return parse("exec nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | tr -d ' '")
end

function egpu_power()
    return parse("exec nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits 2>/dev/null | awk '{print int($1)}'")
end

function egpu_name()
    return parse("exec nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits 2>/dev/null")
end


function draw_igpu()
    local load_str = igpu_load_percent()
    local temp_str = igpu_temp()
    local vram_str = igpu_vram_used()
    local name_str = igpu_name()
    local vram_max = igpu_vram_total()  -- read actual total from sysfs

    local lv = tonumber(load_str) or 0
    local tv = tonumber(temp_str) or 0
    local vv = tonumber(vram_str) or 0
    if vram_max == 0 then vram_max = IGPU_VRAM_MAX end

    -- Outer ring: AMD iGPU load %
    ring_clockwise(S.igpu.x, S.igpu.y, S.igpu.radius,    14, 0, 320,
        lv, 100, color_frompercent(lv))
    -- Middle ring: VRAM usage (against actual total)
    ring_clockwise(S.igpu.x, S.igpu.y, S.igpu.radius-18, 11, 0, 320,
        vv, vram_max, color_frompercent(math.floor(vv / vram_max * 100)))
    -- Inner ring: Temperature
    ring_clockwise(S.igpu.x, S.igpu.y, S.igpu.radius-33,  9, 0, 320,
        tv, IGPU_TEMP_MAX, color_frompercent(math.floor(tv / IGPU_TEMP_MAX * 100)))

    write(S.igpu.text.load.x, S.igpu.text.load.y, "load: " .. lv .. "%",        11, colors.text)
    write(S.igpu.text.vram.x, S.igpu.text.vram.y, "vram: " .. vv .. " MB",      11, colors.text)
    write(S.igpu.text.temp.x, S.igpu.text.temp.y, "temp: " .. tv .. "\xc2\xb0C", 11, colors.text)
    write(S.igpu.text.name.x, S.igpu.text.name.y, string.sub(name_str, 1, 20),  10, colors.text)
end


function draw_egpu()
    local load_str  = egpu_load()
    local vram_str  = egpu_vram_used()
    local temp_str  = egpu_temp()
    local power_str = egpu_power()
    local name_str  = egpu_name()

    local lv = tonumber(load_str)  or 0
    local vv = tonumber(vram_str)  or 0
    local tv = tonumber(temp_str)  or 0
    local pv = tonumber(power_str) or 0

    -- Outer ring: eGPU load %
    ring_clockwise(S.egpu.x, S.egpu.y, S.egpu.radius,    15, 0, 320,
        lv, 100, color_frompercent(lv))
    -- Second ring: VRAM usage
    ring_clockwise(S.egpu.x, S.egpu.y, S.egpu.radius-19, 12, 0, 320,
        vv, EGPU_VRAM_MAX, color_frompercent(math.floor(vv / EGPU_VRAM_MAX * 100)))
    -- Third ring: Power draw
    ring_clockwise(S.egpu.x, S.egpu.y, S.egpu.radius-35, 10, 0, 320,
        pv, EGPU_POWER_MAX, colors.fg)
    -- Inner ring: Temperature
    ring_clockwise(S.egpu.x, S.egpu.y, S.egpu.radius-49,  8, 0, 320,
        tv, EGPU_TEMP_MAX, color_frompercent(math.floor(tv / EGPU_TEMP_MAX * 100)))

    -- Labels
    write(S.egpu.text.load.x, S.egpu.text.load.y, "load: " .. lv .. "%",   11, colors.text)
    write(S.egpu.text.vram.x, S.egpu.text.vram.y, "vram: " .. vv .. " MB",  11, colors.text)
    write(S.egpu.text.temp.x, S.egpu.text.temp.y, "temp: " .. tv .. "°C",   11, colors.text)
    write(S.egpu.text.pwr.x,  S.egpu.text.pwr.y,  "pwr:  " .. pv .. " W",   11, colors.text)

    -- GPU model name (trimmed to fit)
    write(S.egpu.text.name.x, S.egpu.text.name.y, string.sub(name_str, 1, 24), 10, colors.text)
end


function draw_battery()
    if not has_battery then return end
    if not initialized_battery and tonumber(updates()) > startup_delay + 6 then
        init_battery()
    end

    local bat      = battery_percent()
    local bat_time = parse("battery_time BAT0")
    local pwr_mode = parse("execi 5 gdbus call --system --dest net.hadess.PowerProfiles "
                        .. "--object-path /net/hadess/PowerProfiles "
                        .. "--method org.freedesktop.DBus.Properties.Get "
                        .. "\"net.hadess.PowerProfiles\" \"ActiveProfile\" "
                        .. "| awk -F\"'\" '{print $2}'")

    -- battery arc ring
    ring_anticlockwise(S.battery.x, S.battery.y, S.battery.radius, S.battery.width,
        S.battery.begin, S.battery.end_, bat, 100, color_frompercent_reverse(tonumber(bat)))

    -- text labels
    write(S.battery.text.perc.x,       S.battery.text.perc.y,       bat .. "%",                   15, colors.text)
    write(S.battery.text.title.x,      S.battery.text.title.y,       "Battery",                    15, colors.text)
    write(S.battery.text.time_left.x,  S.battery.text.time_left.y,   "Time left:  " .. bat_time,   12, colors.text)
    write(S.battery.text.power_mode.x, S.battery.text.power_mode.y,  "Power mode: " .. pwr_mode,   12, colors.text)
end


function draw_titles()
    if not to_draw_titles then return end
    write(180, 270, "CPU", 18, colors.text)
    write(325, S.net.y+80, "Internet", 15, colors.text)
    write(S.mem.text.ring_title.x, S.mem.text.ring_title.y, "Memory", 18, colors.text)
    write(S.disk.x+100, S.disk.y-S.disk.radius+130, "Hard Disk", 15, colors.text)
    write(S.igpu.text.title.x, S.igpu.text.title.y, "AMD",    14, colors.text)
    write(S.egpu.text.title.x, S.egpu.text.title.y, "NVIDIA", 14, colors.text)
end


function conky_main()
    if conky_window == nil then
        return
    elseif colors == nil then
        io.stderr:write("Fatal Error. Please define a theme")
    end

    local updates_ = tonumber(updates())
    if initialized_battery == false and updates_ > startup_delay  then
        init_battery()
    end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable,
                                         conky_window.visual, conky_window.width,
                                         conky_window.height)
    cr = cairo_create(cs)

    start()

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr = nil
end

