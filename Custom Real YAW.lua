yawtype = gui.Combobox(gui.Reference( "Ragebot", "Anti-Aim", "Anti-Aim" ), "rbot.antiaim.customyaw", "Yaw Customization", "Off" , "Static", "Cycle", "Cycle Inverted", "Switch", "Jitter")
yawminimal = gui.Slider(gui.Reference( "Ragebot", "Anti-Aim", "Anti-Aim" ), "rbot.antiaim.yawminimal", "Yaw Minimal", 0, -180, 180)
yawmaximal = gui.Slider(gui.Reference( "Ragebot", "Anti-Aim", "Anti-Aim" ), "rbot.antiaim.yawmaximal", "Yaw Maximal", 0, -180, 180)
cyclespeed = gui.Slider(gui.Reference( "Ragebot", "Anti-Aim", "Anti-Aim" ), "rbot.antiaim.cyclespeed", "Speed", 10, 1, 100)
yawstatic = gui.Slider(gui.Reference( "Ragebot", "Anti-Aim", "Anti-Aim" ), "rbot.antiaim.yawmaximal", "Yaw", 0, -180, 180)

cycledirection = 0
cyclevalue = 0
iswitch = 0

function aa()

if yawtype:GetValue() == 0 then
return 

gui.SetValue("rbot.antiaim.extra.advconfig", true);

elseif yawtype:GetValue() == 1 then
        gui.SetValue("rbot.antiaim.yaw" , yawstatic:GetValue())

elseif yawtype:GetValue() == 2 then
        if cyclevalue >= yawmaximal:GetValue() then cycledirection = 1
        elseif cyclevalue <= yawminimal:GetValue() + cyclespeed:GetValue() / 8 then  cycledirection = 0 end

        if cycledirection == 0 then cyclevalue = cyclevalue + cyclespeed:GetValue() / 8
        elseif cycledirection == 1 then cyclevalue = cyclevalue - cyclespeed:GetValue() / 8 end      
        gui.SetValue("rbot.antiaim.yaw", cyclevalue)

elseif yawtype:GetValue() == 3 then
        if cyclevalue >= yawmaximal:GetValue() then cycledirection = 1 ;  
        if gui.GetValue("rbot.antiaim.fakeyawstyle") < 3 then gui.SetValue("rbot.antiaim.fakeyawstyle", 2)
        else gui.SetValue("rbot.antiaim.fakeyawstyle", 4) end
        elseif cyclevalue <= yawminimal:GetValue() + cyclespeed:GetValue() / 8 then  cycledirection = 0 ; 
        if gui.GetValue("rbot.antiaim.fakeyawstyle") < 3 then gui.SetValue("rbot.antiaim.fakeyawstyle", 1) 
        else gui.SetValue("rbot.antiaim.fakeyawstyle", 3) end end
        if cycledirection == 0 then cyclevalue = cyclevalue + cyclespeed:GetValue() / 8
        elseif cycledirection == 1 then cyclevalue = cyclevalue - cyclespeed:GetValue() / 8 end      
        gui.SetValue("rbot.antiaim.yaw", cyclevalue)

elseif yawtype:GetValue() == 4 then
        if iswitch == yawminimal:GetValue() then
        gui.SetValue( "rbot.antiaim.yaw", yawmaximal:GetValue() )
        iswitch = yawmaximal:GetValue()
        else
        gui.SetValue( "rbot.antiaim.yaw", yawminimal:GetValue() )
        iswitch = yawminimal:GetValue() end

elseif yawtype:GetValue() == 5 then 
gui.SetValue("rbot.antiaim.yaw", math.random(yawminimal:GetValue(), yawmaximal:GetValue()))

end
end


function GUIHandler()
    
if yawtype:GetValue() == 0 then
yawminimal:SetInvisible(true); 
yawmaximal:SetInvisible(true);
yawstatic:SetInvisible(true);
cyclespeed:SetInvisible(true);

elseif yawtype:GetValue() == 1 then
yawminimal:SetInvisible(true); 
yawmaximal:SetInvisible(true);
yawstatic:SetInvisible(false);
cyclespeed:SetInvisible(true);

elseif yawtype:GetValue() == 2 then
yawminimal:SetInvisible(false); 
yawmaximal:SetInvisible(false);
yawstatic:SetInvisible(true);
cyclespeed:SetInvisible(false);

elseif yawtype:GetValue() == 3 then
yawminimal:SetInvisible(false); 
yawmaximal:SetInvisible(false);
yawstatic:SetInvisible(true);
cyclespeed:SetInvisible(false);

else
yawminimal:SetInvisible(false); 
yawmaximal:SetInvisible(false);
yawstatic:SetInvisible(true);
cyclespeed:SetInvisible(true);
end

end

callbacks.Register("Draw",GUIHandler);
callbacks.Register("CreateMove", aa)
