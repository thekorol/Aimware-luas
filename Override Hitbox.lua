FONT = draw.CreateFont("Microsoft Tai Le","22", 2000 )
local x,y = draw.GetScreenSize();

local guiSet = gui.SetValue
local guiGet = gui.GetValue
local rage_ref_extra = gui.Reference("Ragebot", "Hitscan");

local rage_ref_indicatorpos = gui.Groupbox(rage_ref_extra, "Indicator", 16,536,296,0);
local IndicatorEnable = gui.Checkbox(rage_ref_indicatorpos, "misc.override.indicator", "Enable Indicators", false);
local IndicatorX = gui.Slider(rage_ref_indicatorpos, "misc.override.indicatorx", "X", 0,0,x);
local IndicatorY = gui.Slider(rage_ref_indicatorpos, "misc.override.indicatory", "Y", 0,0,y);
local IndicatorActive = gui.ColorPicker(rage_ref_indicatorpos, "misc.override.indicatorA", "Active", 0,230,0,255);
local IndicatorInactive = gui.ColorPicker(rage_ref_indicatorpos, "misc.override.indicatorD", "Disabled", 230,0,0,255);

local rage_ref_grouphead = gui.Groupbox(rage_ref_extra, "Only Head", 328,276,296,0);
local OnlyHeadKey = gui.Keybox(rage_ref_grouphead, "rbot.hitscan.override.onlyhead", "Only Head Key", 0);
local HeadPointScale = gui.Slider(rage_ref_grouphead, "rbot.hitscan.override.headpoints", "Head Points Scale", 4,1,4);

local rage_ref_groupoverride = gui.Groupbox(rage_ref_extra, "Override", 328,446,296,0);
local OverrideKey = gui.Keybox(rage_ref_groupoverride, "rbot.hitscan.override.key", "Override Key", 0);
OverrideKey:SetDescription("1 = 1 Point | 2 = 3 Points | 3 = 5 Points | 4 = 9 Points");
local OverrideHeadPoint = gui.Slider(rage_ref_groupoverride, "rbot.hitscan.override.override.headpoints", "Head Points Scale", 4,0,4);
local OverrideChestPoint = gui.Slider(rage_ref_groupoverride, "rbot.hitscan.override.override.chestpoints", "Chest Points Scale", 4,0,4);
local OverrideStomathPoint = gui.Slider(rage_ref_groupoverride, "rbot.hitscan.override.override.stomathpoints", "Stomath Points Scale", 4,0,4);
local OverrideArmsPoint = gui.Slider(rage_ref_groupoverride, "rbot.hitscan.override.override.armspoints", "Arms Points Scale", 4,0,4);
local OverrideLegsPoint = gui.Slider(rage_ref_groupoverride, "rbot.hitscan.override.override.legspoints", "Legs Points Scale", 4,0,4);
local OverrideEnableMindamage = gui.Checkbox(rage_ref_groupoverride, "rbot.hitscan.override.override.enablemindmg", "Enable Min Damage Override",false)
local OverrideMindamage = gui.Slider(rage_ref_groupoverride, "rbot.hitscan.override.override.mindmg", "Min Damage", 50,0,100);
local OverrideEnableHitchance = gui.Checkbox(rage_ref_groupoverride, "rbot.hitscan.override.override.enablehitchance", "Enable Hitchacne Override",false)
local OverrideHitchance = gui.Slider(rage_ref_groupoverride, "rbot.hitscan.override.override.hitchance", "Hitchacne", 50,0,100);

local headauto = guiGet("rbot.hitscan.points.asniper.scale")
local headsniper = guiGet("rbot.hitscan.points.sniper.scale")
local headpistol = guiGet("rbot.hitscan.points.pistol.scale")
local headrevolver = guiGet("rbot.hitscan.points.hpistol.scale")
local headsmg = guiGet("rbot.hitscan.points.smg.scale")
local headrifle = guiGet("rbot.hitscan.points.rifle.scale")
local headshotgun = guiGet("rbot.hitscan.points.shotgun.scale")
local headscout = guiGet("rbot.hitscan.points.scout.scale")
local headlmg = guiGet("rbot.hitscan.points.lmg.scale")

local overrideauto = guiGet("rbot.hitscan.points.asniper.scale")
local overridesniper = guiGet("rbot.hitscan.points.sniper.scale")
local overridepistol = guiGet("rbot.hitscan.points.pistol.scale")
local overriderevolver = guiGet("rbot.hitscan.points.hpistol.scale")
local overridesmg = guiGet("rbot.hitscan.points.smg.scale")
local overriderifle = guiGet("rbot.hitscan.points.rifle.scale")
local overrideshotgun = guiGet("rbot.hitscan.points.shotgun.scale")
local overridescout = guiGet("rbot.hitscan.points.scout.scale")
local overridelmg = guiGet("rbot.hitscan.points.lmg.scale")

local mindmgauto = guiGet("rbot.accuracy.weapon.asniper.mindmg")
local mindmgsniper = guiGet("rbot.accuracy.weapon.sniper.mindmg")
local mindmgpistol = guiGet("rbot.accuracy.weapon.pistol.mindmg")
local mindmgrevolver = guiGet("rbot.accuracy.weapon.hpistol.mindmg")
local mindmgsmg = guiGet("rbot.accuracy.weapon.smg.mindmg")
local mindmgrifle = guiGet("rbot.accuracy.weapon.rifle.mindmg")
local mindmgshotgun = guiGet("rbot.accuracy.weapon.shotgun.mindmg")
local mindmgscout = guiGet("rbot.accuracy.weapon.scout.mindmg")
local mindmglmg = guiGet("rbot.accuracy.weapon.lmg.mindmg")

local hitchanceauto = guiGet("rbot.accuracy.weapon.asniper.hitchance")
local hitchancesniper = guiGet("rbot.accuracy.weapon.sniper.hitchance")
local hitchancepistol = guiGet("rbot.accuracy.weapon.pistol.hitchance")
local hitchancerevolver = guiGet("rbot.accuracy.weapon.hpistol.hitchance")
local hitchancesmg = guiGet("rbot.accuracy.weapon.smg.hitchance")
local hitchancerifle = guiGet("rbot.accuracy.weapon.rifle.hitchance")
local hitchanceshotgun = guiGet("rbot.accuracy.weapon.shotgun.hitchance")
local hitchancescout = guiGet("rbot.accuracy.weapon.scout.hitchance")
local hitchancelmg = guiGet("rbot.accuracy.weapon.lmg.hitchance")

local head = 1;
local override = 1;

function GUIHandler()
if OverrideEnableMindamage:GetValue() == true then
    OverrideMindamage:SetInvisible(false)
    else OverrideMindamage:SetInvisible(true) end
if OverrideEnableHitchance:GetValue() == true then
    OverrideHitchance:SetInvisible(false)
    else OverrideHitchance:SetInvisible(true) end
end

function indicator()
  if IndicatorEnable:GetValue() == false then return end
  if not entities.GetLocalPlayer() or not entities.GetLocalPlayer():IsAlive() then
return end
draw.SetFont( FONT );
if (head%2 == 0) then
draw.Color(IndicatorActive:GetValue());
draw.TextShadow(IndicatorX:GetValue(), IndicatorY:GetValue() - 20, "ONLY HEAD");
    elseif (head%2 == 1) then
draw.Color(IndicatorInactive:GetValue());
draw.TextShadow(IndicatorX:GetValue(), IndicatorY:GetValue() - 20, "ONLY HEAD");
end
if (override%2 == 0) then
draw.Color(IndicatorActive:GetValue());
draw.TextShadow(IndicatorX:GetValue(), IndicatorY:GetValue(), "OVERRIDE");
    elseif (override%2 == 1) then
draw.Color(IndicatorInactive:GetValue());
draw.TextShadow(IndicatorX:GetValue(), IndicatorY:GetValue(), "OVERRIDE");
  end
end

function OnlyHeadEnable()
                    headauto = guiGet("rbot.hitscan.points.asniper.scale")
                    headsniper = guiGet("rbot.hitscan.points.sniper.scale")
                    headpistol = guiGet("rbot.hitscan.points.pistol.scale")
                    headrevolver = guiGet("rbot.hitscan.points.hpistol.scale")
                    headsmg = guiGet("rbot.hitscan.points.smg.scale")
                    headrifle = guiGet("rbot.hitscan.points.rifle.scale")
                    headshotgun = guiGet("rbot.hitscan.points.shotgun.scale")
                    headscout = guiGet("rbot.hitscan.points.scout.scale")
                    headlmg = guiGet("rbot.hitscan.points.lmg.scale")

                    gui.Command('rbot.hitscan.points.asniper.scale ' ..HeadPointScale:GetValue().. ' 0 0 0 0 0 0 0 ')
                    gui.Command('rbot.hitscan.points.sniper.scale ' ..HeadPointScale:GetValue().. ' 0 0 0 0 0 0 0 ')
                    gui.Command('rbot.hitscan.points.pistol.scale ' ..HeadPointScale:GetValue().. ' 0 0 0 0 0 0 0 ')
                    gui.Command('rbot.hitscan.points.hpistol.scale ' ..HeadPointScale:GetValue().. ' 0 0 0 0 0 0 0 ')
                    gui.Command('rbot.hitscan.points.smg.scale ' ..HeadPointScale:GetValue().. ' 0 0 0 0 0 0 0 ')
                    gui.Command('rbot.hitscan.points.rifle.scale ' ..HeadPointScale:GetValue().. ' 0 0 0 0 0 0 0 ')
                    gui.Command('rbot.hitscan.points.shotgun.scale ' ..HeadPointScale:GetValue().. ' 0 0 0 0 0 0 0 ')
                    gui.Command('rbot.hitscan.points.scout.scale ' ..HeadPointScale:GetValue().. ' 0 0 0 0 0 0 0 ')
                    gui.Command('rbot.hitscan.points.lmg.scale ' ..HeadPointScale:GetValue().. ' 0 0 0 0 0 0 0 ')
end

function OnlyHeadDisable()
                    gui.Command('rbot.hitscan.points.asniper.scale ' ..headauto)
                    gui.Command('rbot.hitscan.points.sniper.scale ' ..headsniper)
                    gui.Command('rbot.hitscan.points.pistol.scale ' ..headpistol)
                    gui.Command('rbot.hitscan.points.hpistol.scale ' ..headrevolver)
                    gui.Command('rbot.hitscan.points.smg.scale ' ..headsmg)
                    gui.Command('rbot.hitscan.points.rifle.scale ' ..headrifle)
                    gui.Command('rbot.hitscan.points.shotgun.scale ' ..headshotgun)
                    gui.Command('rbot.hitscan.points.scout.scale ' ..headscout)
                    gui.Command('rbot.hitscan.points.lmg.scale ' ..headlmg)
end

function OverrideEnable()
                    overridauto = guiGet("rbot.hitscan.points.asniper.scale")
                    overridsniper = guiGet("rbot.hitscan.points.sniper.scale")
                    overridpistol = guiGet("rbot.hitscan.points.pistol.scale")
                    overridrevolver = guiGet("rbot.hitscan.points.hpistol.scale")
                    overridsmg = guiGet("rbot.hitscan.points.smg.scale")
                    overridrifle = guiGet("rbot.hitscan.points.rifle.scale")
                    overridshotgun = guiGet("rbot.hitscan.points.shotgun.scale")
                    overridscout = guiGet("rbot.hitscan.points.scout.scale")
                    overridlmg = guiGet("rbot.hitscan.points.lmg.scale")

                    mindmgauto = guiGet("rbot.accuracy.weapon.asniper.mindmg")
                    mindmgsniper = guiGet("rbot.accuracy.weapon.sniper.mindmg")
                    mindmgpistol = guiGet("rbot.accuracy.weapon.pistol.mindmg")
                    mindmgrevolver = guiGet("rbot.accuracy.weapon.hpistol.mindmg")
                    mindmgsmg = guiGet("rbot.accuracy.weapon.smg.mindmg")
                    mindmgrifle = guiGet("rbot.accuracy.weapon.rifle.mindmg")
                    mindmgshotgun = guiGet("rbot.accuracy.weapon.shotgun.mindmg")
                    mindmgscout = guiGet("rbot.accuracy.weapon.scout.mindmg")
                    mindmglmg = guiGet("rbot.accuracy.weapon.lmg.mindmg")

                    hitchanceauto = guiGet("rbot.accuracy.weapon.asniper.hitchance")
                    hitchancesniper = guiGet("rbot.accuracy.weapon.sniper.hitchance")
                    hitchancepistol = guiGet("rbot.accuracy.weapon.pistol.hitchance")
                    hitchancerevolver = guiGet("rbot.accuracy.weapon.hpistol.hitchance")
                    hitchancesmg = guiGet("rbot.accuracy.weapon.smg.hitchance")
                    hitchancerifle = guiGet("rbot.accuracy.weapon.rifle.hitchance")
                    hitchanceshotgun = guiGet("rbot.accuracy.weapon.shotgun.hitchance")
                    hitchancescout = guiGet("rbot.accuracy.weapon.scout.hitchance")
                    hitchancelmg = guiGet("rbot.accuracy.weapon.lmg.hitchance")

                    gui.Command('rbot.hitscan.points.asniper.scale '..OverrideHeadPoint:GetValue()..' '..OverrideChestPoint:GetValue()..' '..OverrideArmsPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue())
                    gui.Command('rbot.hitscan.points.sniper.scale '..OverrideHeadPoint:GetValue()..' '..OverrideChestPoint:GetValue()..' '..OverrideArmsPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue())
                    gui.Command('rbot.hitscan.points.pistol.scale '..OverrideHeadPoint:GetValue()..' '..OverrideChestPoint:GetValue()..' '..OverrideArmsPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue())
                    gui.Command('rbot.hitscan.points.hpistol.scale '..OverrideHeadPoint:GetValue()..' '..OverrideChestPoint:GetValue()..' '..OverrideArmsPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue())
                    gui.Command('rbot.hitscan.points.smg.scale '..OverrideHeadPoint:GetValue()..' '..OverrideChestPoint:GetValue()..' '..OverrideArmsPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue())
                    gui.Command('rbot.hitscan.points.rifle.scale '..OverrideHeadPoint:GetValue()..' '..OverrideChestPoint:GetValue()..' '..OverrideArmsPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue())
                    gui.Command('rbot.hitscan.points.shotgun.scale '..OverrideHeadPoint:GetValue()..' '..OverrideChestPoint:GetValue()..' '..OverrideArmsPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue())
                    gui.Command('rbot.hitscan.points.scout.scale '..OverrideHeadPoint:GetValue()..' '..OverrideChestPoint:GetValue()..' '..OverrideArmsPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue())
                    gui.Command('rbot.hitscan.points.lmg.scale '..OverrideHeadPoint:GetValue()..' '..OverrideChestPoint:GetValue()..' '..OverrideArmsPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideStomathPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue()..' '..OverrideLegsPoint:GetValue())

                    if OverrideEnableMindamage:GetValue() == true then 
                    guiSet("rbot.accuracy.weapon.asniper.mindmg", math.floor(OverrideMindamage:GetValue()))
                    guiSet("rbot.accuracy.weapon.sniper.mindmg", math.floor(OverrideMindamage:GetValue()))
                    guiSet("rbot.accuracy.weapon.pistol.mindmg", math.floor(OverrideMindamage:GetValue()))
                    guiSet("rbot.accuracy.weapon.hpistol.mindmg", math.floor(OverrideMindamage:GetValue()))
                    guiSet("rbot.accuracy.weapon.smg.mindmg", math.floor(OverrideMindamage:GetValue()))
                    guiSet("rbot.accuracy.weapon.rifle.mindmg", math.floor(OverrideMindamage:GetValue()))
                    guiSet("rbot.accuracy.weapon.shotgun.mindmg", math.floor(OverrideMindamage:GetValue()))
                    guiSet("rbot.accuracy.weapon.scout.mindmg", math.floor(OverrideMindamage:GetValue()))
                    guiSet("rbot.accuracy.weapon.lmg.mindmg", math.floor(OverrideMindamage:GetValue()))
                    end

                    if OverrideEnableHitchance:GetValue() == true then 
                    guiSet("rbot.accuracy.weapon.asniper.hitchance", math.floor(OverrideHitchance:GetValue()))
                    guiSet("rbot.accuracy.weapon.sniper.hitchance", math.floor(OverrideHitchance:GetValue()))
                    guiSet("rbot.accuracy.weapon.pistol.hitchance", math.floor(OverrideHitchance:GetValue()))
                    guiSet("rbot.accuracy.weapon.hpistol.hitchance", math.floor(OverrideHitchance:GetValue()))
                    guiSet("rbot.accuracy.weapon.smg.hitchance", math.floor(OverrideHitchance:GetValue()))
                    guiSet("rbot.accuracy.weapon.rifle.hitchance", math.floor(OverrideHitchance:GetValue()))
                    guiSet("rbot.accuracy.weapon.shotgun.hitchance", math.floor(OverrideHitchance:GetValue()))
                    guiSet("rbot.accuracy.weapon.scout.hitchance", math.floor(OverrideHitchance:GetValue()))
                    guiSet("rbot.accuracy.weapon.lmg.hitchance", math.floor(OverrideHitchance:GetValue()))
                    end        
end

function OverrideDisable()
                    gui.Command('rbot.hitscan.points.asniper.scale ' ..overridauto)
                    gui.Command('rbot.hitscan.points.sniper.scale ' ..overridsniper)
                    gui.Command('rbot.hitscan.points.pistol.scale ' ..overridpistol)
                    gui.Command('rbot.hitscan.points.hpistol.scale ' ..overridrevolver)
                    gui.Command('rbot.hitscan.points.smg.scale ' ..overridsmg)
                    gui.Command('rbot.hitscan.points.rifle.scale ' ..overridrifle)
                    gui.Command('rbot.hitscan.points.shotgun.scale ' ..overridshotgun)
                    gui.Command('rbot.hitscan.points.scout.scale ' ..overridscout)
                    gui.Command('rbot.hitscan.points.lmg.scale ' ..overridlmg)

                    if OverrideEnableMindamage:GetValue() == true then 
                    guiSet("rbot.accuracy.weapon.asniper.mindmg", mindmgauto)
                    guiSet("rbot.accuracy.weapon.sniper.mindmg", mindmgsniper)
                    guiSet("rbot.accuracy.weapon.pistol.mindmg", mindmgpistol)
                    guiSet("rbot.accuracy.weapon.hpistol.mindmg", mindmgrevolver)
                    guiSet("rbot.accuracy.weapon.smg.mindmg", mindmgsmg)
                    guiSet("rbot.accuracy.weapon.rifle.mindmg", mindmgrifle)
                    guiSet("rbot.accuracy.weapon.shotgun.mindmg", mindmgshotgun)
                    guiSet("rbot.accuracy.weapon.scout.mindmg", mindmgscout)
                    guiSet("rbot.accuracy.weapon.lmg.mindmg", mindmglmg)
                    end

                    if OverrideEnableHitchance:GetValue() == true then 
                    guiSet("rbot.accuracy.weapon.asniper.hitchance", hitchanceauto)
                    guiSet("rbot.accuracy.weapon.sniper.hitchance", hitchancesniper)
                    guiSet("rbot.accuracy.weapon.pistol.hitchance", hitchancepistol)
                    guiSet("rbot.accuracy.weapon.hpistol.hitchance", hitchancerevolver)
                    guiSet("rbot.accuracy.weapon.smg.hitchance", hitchancesmg)
                    guiSet("rbot.accuracy.weapon.rifle.hitchance", hitchancerifle)
                    guiSet("rbot.accuracy.weapon.shotgun.hitchance", hitchanceshotgun)
                    guiSet("rbot.accuracy.weapon.scout.hitchance", hitchancescout)
                    guiSet("rbot.accuracy.weapon.lmg.hitchance", hitchancelmg)
                    end
end

function OnlyHead()
if OnlyHeadKey:GetValue() == 0 then return end
    if(input.IsButtonPressed(OnlyHeadKey:GetValue())) then
            head = head + 1;
    elseif(input.IsButtonDown) then
    -- do nothing
    end
    if(input.IsButtonReleased(OnlyHeadKey:GetValue())) then
            if (head%2 == 0) then
        if (override%2 == 0) then
OverrideDisable()
                    override = 1;
end
                    OnlyHeadEnable()
                    head = 0;
            elseif (head%2 == 1) then
                    OnlyHeadDisable()
                    head = 1;
            end
    end
end

function Override()
if OverrideKey:GetValue() == 0 then return end
    if(input.IsButtonPressed(OverrideKey:GetValue())) then
            override = override + 1;
    elseif(input.IsButtonDown) then
    -- do nothing
    end
    if(input.IsButtonReleased(OverrideKey:GetValue())) then
            if (override%2 == 0) then
        if (head%2 == 0) then
OnlyHeadDisable()
                    head = 1;
end
                    OverrideEnable()
                    override = 0;
            elseif (override%2 == 1) then
                    OverrideDisable()
                    override = 1;
            end
    end
end

callbacks.Register("Draw",OnlyHead);
callbacks.Register("Draw",Override);
callbacks.Register("Draw",GUIHandler);
callbacks.Register("Draw",indicator);
