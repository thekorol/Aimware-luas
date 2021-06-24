local OOV_color = gui.ColorPicker(gui.Reference("Visuals", "Local", "Helper"), "OOV.clr", "Out Of Viev Color", 255, 255, 255, 255)

local function require(filename, url)
    local filename = filename .. ".lua"
    local function http_write(body)
        file.Write(filename, body)
    end
    local module = RunScript(filename) or http.Get(url, http_write)
    return module or error("unable to load module " .. filename, 2)
end
local renderer = require("libraries/renderer", "https://raw.githubusercontent.com/287871/aimware/renderer/renderer.lua")

local function clamp(val, min, max)
    if val > max then
        return max
    elseif val < min then
        return min
    else
        return val
    end
end

local alpha = {}
local players = {activity = {}}

local function Draw()
    local lp = entities.GetLocalPlayer()
    if not lp then return end

    local fade = ((1.0 / 0.15) * globals.FrameTime()) * 80
    local r, g, b, a = OOV_color:GetValue()

    local screen_size = {draw.GetScreenSize()}
    local screen_size_x = screen_size[1] * 0.5
    local screen_size_y = screen_size[2] * 0.5

    local out_of_view_scale = 15

    local temp = {}
    local lp_abs = lp:GetAbsOrigin()
    local view_angles = engine.GetViewAngles()

    local CCSPlayer = entities.FindByClass("CCSPlayer")
    for k, v in pairs(CCSPlayer) do
        local index = v:GetIndex()

        local v_abs = v:GetAbsOrigin()
        local dist = vector.Distance({v_abs.x, v_abs.y, v_abs.z}, {lp_abs.x, lp_abs.y, lp_abs.z})

        alpha[index] = alpha[index] or 0
        if players.activity[index] then
            alpha[index] = players[index] and lp:IsAlive() and clamp(alpha[index] + fade, 0, a) or clamp(alpha[index] - fade, 0, a)
        else
            alpha[index] =
                v:IsPlayer() and v:GetTeamNumber() ~= lp:GetTeamNumber() and v:IsAlive() and lp:IsAlive() and dist <= 1500 and
                clamp(alpha[index] + fade, 0, a) or
                clamp(alpha[index] - fade, 0, a)
        end

        if alpha[index] ~= 0 then
            table.insert(temp, CCSPlayer[k])
        end
        players[index] = nil
        players.activity[index] = nil
    end

    for k, v in pairs(temp) do
        local index = v:GetIndex()
        local v_abs = v:GetAbsOrigin()
        angle = (v_abs - lp_abs):Angles()
        angle.y = angle.y - view_angles.y
        for i = 1, 2, 0.2 do
            local alpha = i / 5 * alpha[index]

            renderer.circle_outline(
                screen_size_x,
                screen_size_y,
                r,
                g,
                b,
                alpha,
                (65 + i),
                (270 - 0.13 * 170) - angle.y + (i * 0.2),
                0.13 + (i * 0.00005),
                (i * 2)
            )
			renderer.circle_outline(
                screen_size_x,
                screen_size_y,
                r,
                g,
                b,
                alpha,
                (70 + i),
                (270 - 0.13 * 170) - angle.y + (i * 0.2),
                0.13 + (i * 0.00005),
                (i * 0.5)
            )
        end
    end
end

callbacks.Register("Draw", Draw)
