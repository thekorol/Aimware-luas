x,y = draw.GetScreenSize();
FONT = draw.CreateFont("Microsoft Tai Le","22", 2000 )

callbacks.Register("Draw", function()

if not lp then return end
if not lp:IsAlive() then return end

local lp = entities.GetLocalPlayer()
local wid = lp:GetWeaponID()

draw.SetFont( FONT );

draw.Color(240, 240, 240, 255);

if wid == 1 or wid == 64 then 
draw.TextShadow(20, y - 165, gui.GetValue("rbot.accuracy.weapon.hpistol.mindmg"));
elseif wid == 2 or wid == 3 or wid == 4 or wid == 30 or wid == 32 or wid == 36 or wid == 61 or wid == 63 then
draw.TextShadow(20, y - 165, gui.GetValue("rbot.accuracy.weapon.pistol.mindmg"));
elseif wid == 7 or wid == 8 or wid == 10 or wid == 13 or wid == 16 or wid == 39 or wid == 60 then
draw.TextShadow(20, y - 165, gui.GetValue("rbot.accuracy.weapon.rifle.mindmg"));
elseif wid == 11 or wid == 38 then
draw.TextShadow(20, y - 165, gui.GetValue("rbot.accuracy.weapon.asniper.mindmg"));
elseif wid == 17 or wid == 19 or wid == 23 or wid == 24 or wid == 26 or wid == 33 or wid == 34 then
draw.TextShadow(20, y - 165, gui.GetValue("rbot.accuracy.weapon.smg.mindmg"));
elseif wid == 14 or wid == 28 then
draw.TextShadow(20, y - 165, gui.GetValue("rbot.accuracy.weapon.lmg.mindmg"));
elseif wid == 25 or wid == 27 or wid == 29 or wid == 35 then
draw.TextShadow(20, y - 165, gui.GetValue("rbot.accuracy.weapon.shotgun.mindmg"));
elseif wid == 9 then
draw.TextShadow(20, y - 165, gui.GetValue("rbot.accuracy.weapon.sniper.mindmg"));
elseif wid == 40 then
draw.TextShadow(20, y - 165, gui.GetValue("rbot.accuracy.weapon.scout.mindmg"));
end
end)
