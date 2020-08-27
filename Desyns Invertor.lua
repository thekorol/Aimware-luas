INVERTORKEY = gui.Keybox(gui.Reference("Ragebot","Anti-Aim","Anti-Aim"),"rbot.antiaim.invertorkey","Invertor Key",false);
MULTIBOX = gui.Multibox(gui.Reference("Ragebot","Anti-Aim","Anti-Aim"), "Invertor Mode");
INVERTORSTANDING = gui.Checkbox(MULTIBOX,"rbot.antiaim.invertor.stand", "Standing" , false);
INVERTORWALK = gui.Checkbox(MULTIBOX,"rbot.antiaim.invertor.walk", "Walk" , false);
INVERTORSLOWWALK = gui.Checkbox(MULTIBOX,"rbot.antiaim.invertor.slowwalk", "Slowwalk" , false);
INVERTORAIR = gui.Checkbox(MULTIBOX,"rbot.antiaim.invertor.air", "In Air" , false);
INVERTORWHENDAMAGEME = gui.Checkbox(MULTIBOX,"rbot.antiaim.invertor.localhurt", "Local Hurt" , false);
INVERTORWHENHIT = gui.Checkbox(MULTIBOX,"rbot.antiaim.invertor.whenhit", "When Hit" , false);
INVERTORATANYSHOT = gui.Checkbox(MULTIBOX,"rbot.antiaim.invertor.atenyshot", "At Any Shot" , false);

function invert()

if gui.GetValue("rbot.antiaim.fakeyawstyle") == 1 then
  gui.SetValue("rbot.antiaim.fakeyawstyle", 2)
  elseif gui.GetValue("rbot.antiaim.fakeyawstyle") == 2 then
  gui.SetValue("rbot.antiaim.fakeyawstyle", 1) 
  elseif gui.GetValue("rbot.antiaim.fakeyawstyle") == 3 then
  gui.SetValue("rbot.antiaim.fakeyawstyle", 4) 
  elseif gui.GetValue("rbot.antiaim.fakeyawstyle") == 4 then
  gui.SetValue("rbot.antiaim.fakeyawstyle", 3) 
end

end

callbacks.Register("FireGameEvent", function(event)

local me = client.GetLocalPlayerIndex();
local int_uid = event:GetInt( 'userid' );
local int_attacker = event:GetInt( 'attacker' );
local index_attacker = client.GetPlayerIndexByUserID( int_attacker );
local index_victim = client.GetPlayerIndexByUserID( int_uid );

if INVERTORWHENDAMAGEME:GetValue() == true then
if ( event:GetName() == nil ) then return;
elseif ( event:GetName() == 'player_hurt' ) then
  if ( index_attacker ~= me and index_victim == me ) then
  invert()
  end
end
end

if INVERTORWHENHIT:GetValue() == true then
if ( event:GetName() == nil ) then return;
elseif ( event:GetName() == 'player_hurt' ) then
  if ( index_attacker == me and index_victim ~= me ) then
  invert()
  end
end
end

if INVERTORATANYSHOT:GetValue() == true then
if event:GetName() ~= "weapon_fire" then return end
invert()
end
  
end)

callbacks.Register("CreateMove", function()

local hLocalPlayer = entities.GetLocalPlayer();

if INVERTORKEY:GetValue() ~= 0 then
if input.IsButtonReleased(INVERTORKEY:GetValue()) then
  invert()
end
end

if INVERTORSTANDING:GetValue() == true then
if math.sqrt(hLocalPlayer:GetPropFloat( "localdata", "m_vecVelocity[0]" ) ^ 2 + hLocalPlayer:GetPropFloat( "localdata", "m_vecVelocity[1]" ) ^ 2) == 0 then
  invert()
end
end

if INVERTORSLOWWALK:GetValue() == true then
if math.sqrt(hLocalPlayer:GetPropFloat( "localdata", "m_vecVelocity[0]" ) ^ 2 + hLocalPlayer:GetPropFloat( "localdata", "m_vecVelocity[1]" ) ^ 2) > 5 then
  invert()
end
end

if INVERTORWALK:GetValue() == true then
if math.sqrt(hLocalPlayer:GetPropFloat( "localdata", "m_vecVelocity[0]" ) ^ 2 + hLocalPlayer:GetPropFloat( "localdata", "m_vecVelocity[1]" ) ^ 2) > 130 then
  invert()
end
end

if INVERTORAIR:GetValue() == true then
if hLocalPlayer:GetPropInt("m_fFlags") / 257 < 1 then
  invert()
end
end

end)
