-- Bomb Info Panel by thekorol and contributors

-- optimization, locals are faster than globals
-- https://lua-users.org/wiki/OptimisingUsingLocalVariables
local math_exp = math.exp
local math_floor = math.floor
local tonumber = tonumber
local unpack = unpack
local string_format = string.format
local input_IsButtonDown = input.IsButtonDown
local input_IsButtonPressed = input.IsButtonPressed
local input_GetMousePos = input.GetMousePos
local client_GetConVar = client.GetConVar
local engine_TraceLine = engine.TraceLine
local vector_Multiply = vector.Multiply
local vector_Add = vector.Add
local vector_Distance = vector.Distance
local draw_Color = draw.Color
local draw_Text = draw.Text
local draw_FilledRect = draw.FilledRect
local draw_GetTextSize = draw.GetTextSize
local draw_SetFont = draw.SetFont
local globals_CurTime = globals.CurTime
local entities_FindByClass = entities.FindByClass
local entities_GetByIndex = entities.GetByIndex
local entities_GetLocalPlayer = entities.GetLocalPlayer


local printPrefix = "[Bomb Info] "

local refMenu = gui.Reference("Menu")
local refC4Timer = gui.Reference("Visuals", "Overlay", "Weapon", "C4 Timer")
local settingBGColor = gui.ColorPicker(refC4Timer, "lua_bombinfo.bgcolor", "", 0, 0, 0, 92)
local settingFGColor = gui.ColorPicker(refC4Timer, "lua_bombinfo.fgcolor", "", 255, 255, 255, 255)
local settingPanelX = gui.Editbox(refC4Timer, "lua_bombinfo.x", "")
settingPanelX:SetInvisible(true)
local settingPanelY = gui.Editbox(refC4Timer, "lua_bombinfo.y", "")
settingPanelY:SetInvisible(true)

local colorT = { 255, 192, 0, 255 }
local colorCT = { 0, 192, 255, 255 }
local colorDamage = { 255, 0, 0, 255 }

-- https://lua-users.org/wiki/BaseSixtyFour
local function DecodeBase64(data)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = string.gsub(data, "[^" .. alphabet .. "=]", "")
    return (data:gsub(
        ".",
        function(x)
            if (x == "=") then
                return ""
            end
            local r, f = "", (alphabet:find(x) - 1)
            for i = 6, 1, -1 do
                r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0")
            end
            return r
        end
    ):gsub(
        "%d%d%d?%d?%d?%d?%d?%d?",
        function(x)
            if (#x ~= 8) then
                return ""
            end
            local c = 0
            for i = 1, 8 do
                c = c + (x:sub(i, i) == "1" and 2 ^ (8 - i) or 0)
            end
            return string.char(c)
        end
    ))
end

local stratum2Bold = [[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]]
draw.AddFontResource(DecodeBase64(stratum2Bold))

local font = draw.CreateFont("StratumNo2", 24, 800)
draw_SetFont(font)

local _, fontHeight = draw_GetTextSize("A")
fontHeight = fontHeight + 1 -- fix
local padding = 5
local panelW = 0
local oneLineH = fontHeight + padding * 2
local twoLinesH = fontHeight * 2 + padding * 3
local panelH = oneLineH
local barH = 3
local siteW = draw_GetTextSize("Site: ")
local hpW = draw_GetTextSize("HP: ")
local plantLength = 3.125
local plantingW = draw_GetTextSize(string_format("Planting: %.0f.0", plantLength)) -- font isn't monotype so make space for zero
local defusingW = draw_GetTextSize("Defusing: 10.0")
local noTimeW = draw_GetTextSize("Defusing: No Time")

local plantTime = -1
local bombsiteName = "?"

local function InitPanel()
	local screenW, screenH = draw.GetScreenSize()
	panelW = screenW * 0.208 + 2 * 6 -- width of 6 comp avatars, they have 1 px margin (2 px)
	if panelW < 280 then
		panelW = 280
	end
	settingPanelX:SetValue((screenW - panelW) * 0.5)
	settingPanelY:SetValue(screenH * 0.0535)
end

InitPanel()

local isDragging = false
local dragPrevX, dragPrevY = 0, 0

local function Drag()
	if not (isDragging and input_IsButtonDown(1)) and not input_IsButtonPressed(1) then
		isDragging = false
		return
	end

	local panelX = tonumber(settingPanelX:GetValue())
	local panelY = tonumber(settingPanelY:GetValue())

	local mouseX, mouseY = input_GetMousePos()

	if isDragging then
		settingPanelX:SetValue(panelX + (mouseX - dragPrevX))
		settingPanelY:SetValue(panelY + (mouseY - dragPrevY))

		dragPrevX = mouseX
		dragPrevY = mouseY
	else
		if panelX <= mouseX and mouseX <= (panelX + panelW) and
			panelY <= mouseY and mouseY <= (panelY + panelH) then
			isDragging = true

			dragPrevX = mouseX
			dragPrevY = mouseY
		end
	end
end

-- aka Demolition
local function IsPlayingGunGameTRBomb()
	local game_type = tonumber(client_GetConVar("game_type"))
	local game_mode = tonumber(client_GetConVar("game_mode"))
	return game_type == 1 and game_mode == 1
end

local CM_LoadMap__pattern = mem.FindPattern("engine.dll", "80 3E 00 74 74 8B D6 33 C9 E8 ?? ?? ?? ?? FF 75 0C BA")
assert(CM_LoadMap__pattern and CM_LoadMap__pattern ~= 0, printPrefix .. "FindPattern failed")

local g_BSPData = ffi.cast("uintptr_t*", CM_LoadMap__pattern + 18)[0]
local g_BSPData__map_entitystring__m_buf__m_Memory__m_pMemory = ffi.cast("char**", g_BSPData + 0xE4 + 0x4 + 0x0 + 0x0)
local g_BSPData__map_entitystring__m_buf__m_Put = ffi.cast("int*", g_BSPData + 0xE4 + 0x4 + 0x10)

local function GetMapBombRadius()
	local memory = g_BSPData__map_entitystring__m_buf__m_Memory__m_pMemory[0]
	local count = g_BSPData__map_entitystring__m_buf__m_Put[0]

	if not count or count <= 0 or not memory or memory == nil then
		return nil
	end

	local entityString = ffi.string(memory, count)
	if not entityString or entityString == nil then
		return nil
	end

	return tonumber(string.match(entityString, "\"bombradius\"%s+\"(%d+)\""))
end

local mapBombRadius = GetMapBombRadius()

local CONTENTS_SOLID	= 0x1
local CONTENTS_WINDOW	= 0x2
local CONTENTS_GRATE	= 0x8
local CONTENTS_MOVEABLE	= 0x4000
local CONTENTS_MONSTER	= 0x2000000

local MASK_SOLID = bit.bor(CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_WINDOW, CONTENTS_MONSTER, CONTENTS_GRATE)

local function clamp(val, min, max)
	if val > max then
		return max
	elseif val < min then
		return min
	else
		return val
	end
end

local function ArrayLerp(arr1, arr2, ratio)
	local result = {}
	for i = 1, #arr1 do
		result[i] = arr1[i] + (arr2[i] - arr1[i]) * ratio
	end
	return result
end

local function ScaleBombDamage(localPlayer, flDamage)
	local armorValue = localPlayer:GetPropInt("m_ArmorValue")
	if armorValue <= 0 then
		return flDamage
	end

	local flArmorRatio = 0.5
	local flArmorBonus = 0.5

	local fHeavyArmorDamageReductionRatio = 0.85

	local hasHeavyArmor = localPlayer:GetPropBool("m_bHasHeavyArmor")
	if hasHeavyArmor then
		flDamage = flDamage * fHeavyArmorDamageReductionRatio
	end

	-- skipped getting armor ratio because hOwnerEntity is set to NULL before explosion

	local fDamageToHealth = flDamage
	local fDamageToArmor = 0
	local fHeavyArmorBonus = 1.0

	if hasHeavyArmor then
		flArmorRatio = flArmorRatio * 0.5
		flArmorBonus = 0.33
		fHeavyArmorBonus = 0.33
	end

	-- skipped IsArmored because our m_LastHitGroup is always HITGROUP_GENERIC (true)

	fDamageToHealth = flDamage * flArmorRatio
	fDamageToArmor = (flDamage - fDamageToHealth) * (flArmorBonus * fHeavyArmorBonus)

	if fDamageToArmor > armorValue then
		fDamageToHealth = flDamage - armorValue / flArmorBonus
		fDamageToArmor = armorValue
		armorValue = 0
	else
		if fDamageToArmor < 0 then
			fDamageToArmor = 1
		end
		armorValue = armorValue - fDamageToArmor
	end

	flDamage = fDamageToHealth

	return flDamage
end

local function CalcBombDamage(bomb, localPlayer)
	-- CPlantedC4::C4Think
	-- https://github.com/perilouswithadollarsign/cstrike15_src/blob/master/game/shared/cstrike15/weapon_c4.cpp#L480

	local bombOrigin = bomb:GetAbsOrigin()
	bombOrigin = { bombOrigin["x"], bombOrigin["y"], bombOrigin["z"] }

	local tr = engine_TraceLine(
		Vector3(bombOrigin[1], bombOrigin[2], bombOrigin[3] + 8),
		Vector3(bombOrigin[1], bombOrigin[2], bombOrigin[3] - 32),
		MASK_SOLID
	)

	-- CPlantedC4::Explode
	-- https://github.com/perilouswithadollarsign/cstrike15_src/blob/master/game/shared/cstrike15/weapon_c4.cpp#L896
	if tr["fraction"] ~= 1.0 then
		local planeNormal = tr["plane"]["normal"]
		planeNormal = { planeNormal["x"], planeNormal["y"], planeNormal["z"] }

		local normalMultiplied = { vector_Multiply(planeNormal, 0.6) }

		local endpos = tr["endpos"]
		endpos = { endpos["x"], endpos["y"], endpos["z"] }

		bombOrigin = { vector_Add(endpos, normalMultiplied) }
	end

	local bombDamage = 0

	if mapBombRadius then
		bombDamage = mapBombRadius
	else
		bombDamage = IsPlayingGunGameTRBomb() and 300 or 500
	end

	local bombRadius = bombDamage * 3.5

	-- CCSGameRules::RadiusDamage
	-- https://gitlab.com/KittenPopo/csgo-2018-source/-/blob/main/game/shared/cstrike15/cs_gamerules.cpp#L5366

	bombOrigin[3] = bombOrigin[3] + 1

	local vecSpot = localPlayer:GetAbsOrigin()
	local viewOffsetZ = localPlayer:GetPropFloat("localdata", "m_vecViewOffset[2]")
	-- https://github.com/perilouswithadollarsign/cstrike15_src/blob/master/game/server/player.cpp#L7120
	vecSpot = { vecSpot["x"], vecSpot["y"], vecSpot["z"] + (viewOffsetZ * 0.85) }

	local fDist = vector_Distance(vecSpot, bombOrigin)
	local fSigma = bombRadius / 3.0
	local fGaussianFalloff = math_exp(-fDist * fDist / (2.0 * fSigma * fSigma))
	local flAdjustedDamage = bombDamage * fGaussianFalloff
	if flAdjustedDamage <= 0 then
		return 0
	end

	local scaledDamage = ScaleBombDamage(localPlayer, flAdjustedDamage)
	if scaledDamage <= 0 then
		return 0
	end

	return scaledDamage
end

local function DrawBackground(x, y, w, h, color)
	draw_Color(unpack(color))
	draw_FilledRect(x, y, x + w, y + h)
end

local function DrawBar(x, y, w, h, ratio, color)
	draw_Color(unpack(color))
	local barRight = x + (w * ratio)
	draw_FilledRect(x, y, barRight, y + h)
end

local function DrawSite(x, y, colorText, colorSite)
	draw_Color(unpack(colorText))
	draw_Text(x, y, "Site:")

	draw_Color(unpack(colorSite))
	draw_Text(x + siteW, y, bombsiteName)
end

local function DrawPlanting(plantTime, plantLength, curTime, panelX, panelY, panelW, panelH, barH, textX, textY, colorStart, colorEnd)
	local plantCountdown = plantTime - curTime
	local plantRatio = 1 - clamp(plantCountdown / plantLength, 0, 1)

	local plantColor = ArrayLerp(colorStart, colorEnd, plantRatio)

	draw_Color(unpack(colorStart))
	draw_Text(textX - plantingW, textY, "Planting:")

	draw_Color(unpack(plantColor))
	local text = string_format("%.1f", plantCountdown)
	local textW = draw_GetTextSize(text)
	draw_Text(textX - textW, textY, text)

	DrawBar(panelX, panelY + panelH, panelW, barH, plantRatio, plantColor)
end

local function DrawHP(bomb, localPlayer, x, y, colorMin, colorMax)
	if not localPlayer or not localPlayer:IsAlive() then
		return
	end

	local health = localPlayer:GetHealth()

	-- bomb damage has small randomness involved (in BodyTarget), assume we are unlucky
	local damage = math_floor(CalcBombDamage(bomb, localPlayer) + 0.105)

	local hpLeft = health - damage
	if hpLeft < 0 then
		hpLeft = 0
	end

	local hpLeftRatio = clamp(hpLeft / health, 0, 1)

	local hpLeftColor = ArrayLerp(colorMin, colorMax, hpLeftRatio)

	draw_Color(unpack(colorMax))
	draw_Text(x, y, "HP:")

	draw_Color(unpack(hpLeftColor))
	draw_Text(x + hpW, y, hpLeft)
end

local function DrawBlow(blowTime, timerLength, curTime, panelX, panelY, panelW, panelH, barH, textX, textY, colorStart, colorEnd)
	local blowCountdown = blowTime - curTime
	local blowColorRatio = 1 - clamp((blowCountdown - 5) / (timerLength - 5), 0, 1) -- max color when no time

	local blowColor = ArrayLerp(colorStart, colorEnd, blowColorRatio)

	draw_Color(unpack(blowColor))
	local text = string_format("%.1f", blowCountdown)
	local textW = draw_GetTextSize(text)
	draw_Text(textX - textW, textY, text)

	local blowRatio = clamp(blowCountdown / timerLength, 0, 1)

	DrawBar(panelX, panelY + panelH, panelW, barH, blowRatio, blowColor)
end

local function DrawDefusing(bomb, defuser, blowTime, timerLength, curTime, panelX, panelY, panelW, panelH, barH, textX, textY, colorStart, colorEnd, colorNoTime)
	if defuser == -1 then
		return
	end

	local defuseTime = bomb:GetPropFloat("m_flDefuseCountDown")
	if defuseTime < curTime then
		return
	end

	local defuseCountdown = defuseTime - curTime

	if defuseTime < blowTime then
		local defuseLength = bomb:GetPropFloat("m_flDefuseLength")

		local defuseRatio = 1 - clamp(defuseCountdown / defuseLength, 0, 1)

		local defuseColor = ArrayLerp(colorStart, colorEnd, defuseRatio)

		draw_Color(unpack(colorStart))
		draw_Text(textX - defusingW, textY, "Defusing:")

		draw_Color(unpack(defuseColor))
		local text = string_format("%.1f", defuseCountdown)
		local textW = draw_GetTextSize(text)
		draw_Text(textX - textW, textY, text)
	else
		draw_Color(unpack(colorNoTime))
		draw_Text(textX - noTimeW, textY, "Defusing: No Time")
	end

	local defuseBarRatio = clamp(defuseCountdown / timerLength, 0, 1)

	DrawBar(panelX, panelY + panelH, panelW, barH, defuseBarRatio, colorEnd)
end

local function DrawPanel()
	local panelX = tonumber(settingPanelX:GetValue())
	local panelY = tonumber(settingPanelY:GetValue())

	local curTime = globals_CurTime()

	local blowTime = -1
	local localPlayer = nil
	local defuser = nil

	local bomb = entities_FindByClass("CPlantedC4")[1]
	if bomb then
		-- sometimes the panel continues to get drawn when round finishes with a planted bomb
		-- i assume it happens due to dormancy
		if bombsiteName == "?" then
			return
		end
		
		blowTime = bomb:GetPropFloat("m_flC4Blow")
		if blowTime < curTime then
			return
		end

		if not bomb:GetPropBool("m_bBombTicking") or bomb:GetPropBool("m_bBombDefused") then
			return
		end

		localPlayer = entities_GetLocalPlayer()
		defuser = bomb:GetPropInt("m_hBombDefuser")

		if (localPlayer and localPlayer:IsAlive()) or defuser ~= -1 then
			panelH = twoLinesH
		else
			panelH = oneLineH
		end
	else
		-- draw when menu is open
		if refMenu:IsActive() then
			panelH = twoLinesH
		else
			if plantTime < curTime then
				return
			end
			panelH = oneLineH
		end
	end

	local left = panelX + padding
	local right = panelX + panelW - padding
	local firstLine = panelY + padding
	local secondLine = panelY + panelH - padding - fontHeight

	local colorBG = { settingBGColor:GetValue() }
	local colorFG = { settingFGColor:GetValue() }

	draw_SetFont(font)

	DrawBackground(panelX, panelY, panelW, panelH, colorBG)

	DrawSite(left, firstLine, colorFG, colorT)

	if not bomb then
		if plantTime >= curTime then
			DrawPlanting(plantTime, plantLength, curTime, panelX, panelY, panelW, panelH, barH, right, firstLine, colorFG, colorT)
		end
		return
	end

	DrawHP(bomb, localPlayer, left, secondLine, colorDamage, colorFG)

	local timerLength = bomb:GetPropFloat("m_flTimerLength")

	DrawBlow(blowTime, timerLength, curTime, panelX, panelY, panelW, panelH, barH, right, firstLine, colorFG, colorDamage)

	DrawDefusing(bomb, defuser, blowTime, timerLength, curTime, panelX, panelY, panelW, panelH, barH, right, secondLine, colorFG, colorCT, colorDamage)
end

callbacks.Register("Draw", function()
	if not refC4Timer:GetValue() then
		return
	end

	DrawPanel()

	-- make our panel draggable when menu is open
	if refMenu:IsActive() then
		Drag()
	end
end)

local function GetBombsiteName(siteEntity)
	local mins = siteEntity:GetMins()
	mins = { mins["x"], mins["y"], mins["z"] }

	local maxs = siteEntity:GetMaxs()
	maxs = { maxs["x"], maxs["y"], maxs["z"] }

	local center = ArrayLerp(mins, maxs, 0.5)

	local playerResources = entities.GetPlayerResources()

	local a = playerResources:GetPropVector("m_bombsiteCenterA")
	a = { a["x"], a["y"], a["z"] }

	local b = playerResources:GetPropVector("m_bombsiteCenterB")
	b = { b["x"], b["y"], b["z"] }

	local distToA = vector_Distance(center, a)
	local distToB = vector_Distance(center, b)

	return distToA > distToB and "B" or "A"
end

client.AllowListener("game_newmap")
client.AllowListener("bomb_beginplant")
client.AllowListener("bomb_abortplant")
client.AllowListener("bomb_planted")
client.AllowListener("round_officially_ended")
client.AllowListener("cs_game_disconnected")

local currentMap = engine.GetMapName()

callbacks.Register("FireGameEvent", function(event)
	local eventName = event:GetName()

	-- comparisons sorted by most frequent
	if eventName == "round_officially_ended" or
		eventName == "bomb_abortplant" or
		eventName == "cs_game_disconnected" then
		plantTime = -1
		bombsiteName = "?"

	elseif eventName == "bomb_beginplant" then
		plantTime = globals_CurTime() + plantLength
		bombsiteName = GetBombsiteName(entities_GetByIndex(event:GetInt("site")))

	elseif eventName == "bomb_planted" then
		plantTime = -1

	elseif eventName == "game_newmap" then
		local newMap = event:GetString("mapname")
		if currentMap ~= newMap then
			currentMap = newMap
			mapBombRadius = GetMapBombRadius()
		end
	end
end)