local Distance = gui.GetValue("esp.local.thirdpersondist")
local Enable = gui.Checkbox(gui.Reference("Visuals","Local","Camera"),"animthirdperson", "Animate Thirdperson Enable" , false);
Enable:SetDescription("Unbind Enable Third Person checkbox and bind this")
local value = 0;

function Thirdperson()
if value > Distance then value = Distance
elseif value < 0 then gui.SetValue("esp.local.thirdperson",false); value = 0 end
if Enable:GetValue() and value < Distance then gui.SetValue("esp.local.thirdperson",true); value = value + 8 end
if not Enable:GetValue() then value = value - 8 end
gui.SetValue("esp.local.thirdpersondist", value)
end

function ReturnThirdperson() gui.SetValue("esp.local.thirdpersondist",Distance) end

callbacks.Register("Draw",Thirdperson)
callbacks.Register("Unload",ReturnThirdperson)
