local RbotTab = gui.Reference("Ragebot")
local AAPresetTab = gui.Tab(RbotTab,"AA Presets","AA Presets")
local GBox = gui.Groupbox(AAPresetTab, "Anti-Aim Preset's", 16, 16,296,0)
local PresetType = gui.Combobox(GBox, "aa.preset", "Preset", "Legit AA", "Default", "Opposite", "Default Jitter", "Opposite Jitter", "Switch", "Flick", "Low Delta")
local AtTargetEnable = gui.Checkbox(GBox, "aa.preset.targets", "At Target", false)
local InvertEnable = gui.Checkbox(GBox, "aa.preset.invert", "Invert", false)
PresetType:SetDescription("Select the required preset.")
AtTargetEnable:SetDescription("Turns your face away from the enemy.")
InvertEnable:SetDescription("Turns aa in the opposite direction.It is advisable to bind.")
local Invert = -1
local iSWitch = 1
local function SetValues(rotation,lby,lbyex,pitch)
if InvertEnable:GetValue() == false then Invert = -1 else Invert = 1 end
gui.SetValue("rbot.antiaim.base.rotation",rotation*Invert)
gui.SetValue("rbot.antiaim.base.lby",lby*-Invert)
gui.SetValue("rbot.antiaim.advanced.antialign",lbyex)
gui.SetValue("rbot.antiaim.advanced.pitch",pitch)
end
local function NormalizeYaw(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end
    return yaw
end
local function WorldDistance(xdelta, ydelta)
    if xdelta == 0 and ydelta == 0 then
        return 0
    end
    return math.deg(math.atan2(ydelta, xdelta))
end
local function CalcAngle(localplayerxpos, localplayerypos, enemyxpos, enemyypos)
    local ydelta = localplayerypos - enemyypos
    local xdelta = localplayerxpos - enemyxpos
    relativeyaw = math.atan(ydelta / xdelta)
    relativeyaw = NormalizeYaw(relativeyaw * 180 / math.pi)
    if xdelta >= 0 then
        relativeyaw = NormalizeYaw(relativeyaw + 180)
    end
    return relativeyaw
end
callbacks.Register("Draw", function()	
local DesiredYaw = 180
	if PresetType:GetValue() == 0 then DesiredYaw = 0 else DesiredYaw = 180 end 
	gui.SetValue("rbot.antiaim.base", DesiredYaw)
    if not AtTargetEnable:GetValue() then return end

    local pLocal = entities.GetLocalPlayer()
    if pLocal == nil then return end
    if not pLocal:IsAlive() then return end

    local vecLocalPos = pLocal:GetAbsOrigin()
    local BestEnemy = nil
    local BestDistance = math.huge
    local vecLocalPos = pLocal:GetAbsOrigin()
    local angViewAngles = engine.GetViewAngles()
    local Enemies = entities.FindByClass("CCSPlayer")
	
    for i, Enemy in pairs(Enemies) do
        if Enemy:GetPropInt("m_iTeamNum") ~= pLocal:GetPropInt("m_iTeamNum") then

            local vecEnemyPos = Enemy:GetAbsOrigin()
            local Distance = math.abs(NormalizeYaw(WorldDistance(vecLocalPos.x - vecEnemyPos.x, vecLocalPos.y - vecEnemyPos.y) - angViewAngles.y + 180))

            if Distance < BestDistance then
                BestDistance = Distance
                BestEnemy = Enemy
            end
        end
    end

    if BestEnemy ~= nil then
        local vecEnemyPos = BestEnemy:GetAbsOrigin()
        local AtTargets = CalcAngle(vecLocalPos.x, vecLocalPos.y, vecEnemyPos.x, vecEnemyPos.y)
        local Yaw = NormalizeYaw(AtTargets + DesiredYaw - angViewAngles.yaw)
        gui.SetValue("rbot.antiaim.base", Yaw, Yaw)
    else
        gui.SetValue("rbot.antiaim.base", DesiredYaw)
    end
end)
callbacks.Register("Draw", function()
if PresetType:GetValue() == 0 then
SetValues(-58,180,0,0)
elseif PresetType:GetValue() == 1 then
SetValues(58,0,1,1)
elseif PresetType:GetValue() == 2 then
SetValues(58,180,0,1)
elseif PresetType:GetValue() == 3 then
SetValues(math.random(-20,58),180,1,1)
elseif PresetType:GetValue() == 4 then
SetValues(math.random(-30,58),180,0,1)
elseif PresetType:GetValue() == 5 then
if globals.TickCount() % 8 == 0 then
if iswitchYAW == -20 then
SetValues(58,180,1,1)
iswitchYAW = 58
else
SetValues(-20,180,1,1)
iswitchYAW = -20
end
end
elseif PresetType:GetValue() == 6 then
if globals.TickCount() % 32 == 0 then
SetValues(-58,180,1,1)
else
SetValues(58,180,1,1)
end
elseif PresetType:GetValue() == 7 then
SetValues(17,180,1,1)
end
end)
