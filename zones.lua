--[[                                                
                                                   
▄▄▄▄▄  ▄▄▄  ▄▄  ▄▄ ▄▄▄▄▄  ▄▄▄▄   ▄▄    ▄▄ ▄▄  ▄▄▄  
  ▄█▀ ██▀██ ███▄██ ██▄▄  ███▄▄   ██    ██ ██ ██▀██ 
▄██▄▄ ▀███▀ ██ ▀██ ██▄▄▄ ▄▄██▀ ▄ ██▄▄▄ ▀███▀ ██▀██ 
                                                   
--]]
BASE:TraceAll(true)

Infantry_template = GROUP:FindByName("infantry_template")
Tank_templatet72 = GROUP:FindByName("tank_templatet72")
Tank_templatet90 = GROUP:FindByName("tank_templatet90")
Capture_b_tank = GROUP:FindByName("capture_b_tank")
Capture_b_infantry = GROUP:FindByName("capture_b_infantry")
Capture_r_tank = GROUP:FindByName("capture_r_tank")
Capture_r_infantry = GROUP:FindByName("capture_r_infantry")

Opszones = { Reneopszone, Beirutopszone, Basselopszone, Hatayopszone }
Friendlyzones = {}

function GetFriendlyZones(zones)
    local friendlyzones = {}
    for _, Opszones in ipairs(zones) do
        if Opszones:GetOwner() == coalition.side.BLUE then
            table.insert(friendlyzones, Opszones)
            table.insert(Friendlyzones, Opszones)
        end
    end
    env.info("Friendly zones found: " .. #friendlyzones)
    for i, zone in ipairs(friendlyzones) do
        -- Assuming the Opszone object has a GetName() method
        env.info("Friendly Zone Name #" .. i .. ": " .. zone:GetName())
    end
    return friendlyzones
end

function CalculateMetersToNM(meters)
    local nm = meters / 1852
    return nm
end

function GetClosestFriendlyZone(initialpoint, friendlyzones)
    local initialpoint = initialpoint
    local friendlyzones = Friendlyzones
    local distance = nil
    local alldistances = {}

    for _, zone in ipairs(friendlyzones) do
        local friendlyzonecoordinate = zone:GetCoordinate()
        local distance = initialpoint:Get2DDistance(friendlyzonecoordinate)
        local converteddistance = CalculateMetersToNM(distance)
        if converteddistance < 50 then
            table.insert(alldistances, distance)
        end
    end

    table.sort(alldistances)

    local closestdistance = alldistances[1]
    return closestdistance
    
end

--[[                                                     
                                                       
█████▄  ▄▄▄▄▄ ▄▄  ▄▄ ▄▄▄▄▄   ██████  ▄▄▄  ▄▄  ▄▄ ▄▄▄▄▄ 
██▄▄██▄ ██▄▄  ███▄██ ██▄▄     ▄▄▀▀  ██▀██ ███▄██ ██▄▄  
██   ██ ██▄▄▄ ██ ▀██ ██▄▄▄   ██████ ▀███▀ ██ ▀██ ██▄▄▄ 
                                                       
--]]

-- Rene variables

local rene_spawn_zones = {
  ZONE:FindByName("rene_spawn-1"),
  ZONE:FindByName("rene_spawn-2"),
  ZONE:FindByName("rene_spawn-3"),
  ZONE:FindByName("rene_spawn-4"),
  ZONE:FindByName("rene_spawn-5"),
  ZONE:FindByName("rene_spawn-6")
}
Rene = ZONE:FindByName("rene")
Reneopszone = OPSZONE:New(ZONE:FindByName("rene"), coalition.side.RED)
if Reneopszone == nil then
  BASE:Trace("Rene Opsgrp is nil!")
end
Reneopszone:Start()

-- Draw Rene zone on map (Not needed taken care of by OPSZONE)

-- trigger.action.circleToAll(-1, 1, rene:GetPointVec3(), 4600, {1, 0, 0, 1}, {1, 0, 0, 0.3}, 1, true, "Rene")
-- trigger.action.textToAll(-1, 2, rene:GetPointVec3(), {1, 0, 0, 1}, {1, 0, 0, 0.3}, 27, true, "Rene")

-- Rene Units spawning

local rene_infantry = SPAWN:NewWithAlias("infantry_template", "Rene Infantry")
  :InitRandomizeZones(rene_spawn_zones)
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)

  for i = 1, 6 do
    rene_infantry:Spawn()
  end

local rene_tankt72 = SPAWN:NewWithAlias("tank_templatet72", "Rene T-72")
  :InitRandomizeZones(rene_spawn_zones)
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)

  for i = 1, math.random(3, 5) do
    rene_tankt72:Spawn()
  end

local rene_tankt90 = SPAWN:NewWithAlias("tank_templatet90", "Rene T-90")
  :InitRandomizeZones(rene_spawn_zones)
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)

  for i = 1, math.random(2, 4) do
    rene_tankt90:Spawn()
  end


function Reneopszone:OnAfterCaptured(From, Event, To, Coalition)
  if Coalition == coalition.side.BLUE then
      Ctld:AddCTLDZone("rene", CTLD.CargoZoneType.UNLOAD, nil, true, false)

      GetFriendlyZones(Opszones)

        local renebluecatimer = TIMER:New( function()
        end)

        renebluecatimer:Start(1, nil, math.random(1400, 2600))

      end
  if Coalition == coalition.side.RED then
      Ctld:DeactivateZone("Rene", CTLD.CargoZoneType.UNLOAD)
      
      end
  end


-- Set up the zone so it can be captured (Not needed taken care of by OPSZONE)

-- local rene_capture_zone = ZONE_CAPTURE_COALITION:New(rene, coalition.side.RED)
   -- :SetMarkZone(false)

-- rene_capture_zone:Start(10, 30)

-- For testing send units to attack Rene (Not needed here gonna be moved to ai.lua)



local rene_attack_unit = SPAWN:NewWithAlias("Ground-1", "Rene Attack Infantry")
  :OnSpawnGroup(
    function( spawned_group )
      local attack_task = AUFTRAG:NewCAPTUREZONE(Reneopszone, coalition.side.BLUE, 10)
      local opsgrp = ARMYGROUP:New( spawned_group )
      if opsgrp == nil then
        BASE:Trace("Opsgrp is nil!")
        return
      end
      opsgrp:AddMission( attack_task )
    end
  )
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)

rene_attack_unit:SpawnFromPointVec3(ZONE:FindByName("rene_attack_spawn"):GetPointVec3())
  -- :RouteToVec3(rene:GetPointVec3())
  -- :SetSpeed(20)
  -- :AddMission(AUFTRAG:NewGROUNDATTACK(GROUP:FindByName("Rene Infantry#001"), 20, ENUMS.Formation.Vehicle.OnRoad))


--[[                                                        
                                                               
█████▄ ▄▄▄▄▄ ▄▄ ▄▄▄▄  ▄▄ ▄▄ ▄▄▄▄▄▄   ██████  ▄▄▄  ▄▄  ▄▄ ▄▄▄▄▄ 
██▄▄██ ██▄▄  ██ ██▄█▄ ██ ██   ██      ▄▄▀▀  ██▀██ ███▄██ ██▄▄  
██▄▄█▀ ██▄▄▄ ██ ██ ██ ▀███▀   ██     ██████ ▀███▀ ██ ▀██ ██▄▄▄ 
                                                               
--]]

-- Beirut variables

local beirut_spawn_zones = {
  ZONE:FindByName("beirut_spawn-1"),
  ZONE:FindByName("beirut_spawn-2"),
  ZONE:FindByName("beirut_spawn-3"),
  ZONE:FindByName("beirut_spawn-4"),
  ZONE:FindByName("beirut_spawn-5"),
  ZONE:FindByName("beirut_spawn-6"),
  ZONE:FindByName("beirut_spawn-7"),
  ZONE:FindByName("beirut_spawn-8"),
  ZONE:FindByName("beirut_spawn-9"),
  ZONE:FindByName("beirut_spawn-10"),
  ZONE:FindByName("beirut_spawn-11"),
  ZONE:FindByName("beirut_spawn-12"),
  ZONE:FindByName("beirut_spawn-13"),
  ZONE:FindByName("beirut_spawn-14"),
  ZONE:FindByName("beirut_spawn-15")
}

Beirut = ZONE:FindByName("beirut")
Beirutopszone = OPSZONE:New(ZONE:FindByName("beirut"), coalition.side.RED)
Beirutopszone:Start()

-- Beirut Units spawning

local beirut_infantry = SPAWN:NewWithAlias("infantry_template", "Beirut Infantry")
  :InitRandomizeZones(beirut_spawn_zones)
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)

  for i = 1, math.random(10, 15) do
    beirut_infantry:Spawn()
  end

local beirut_tankt72 = SPAWN:NewWithAlias("tank_templatet72", "Beirut T-72")
  :InitRandomizeZones(beirut_spawn_zones)
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)
  for i = 1, math.random(3, 5) do
    beirut_tankt72:Spawn()
  end

local beirut_tankt90 = SPAWN:NewWithAlias("tank_templatet90", "Beirut T-90")
  :InitRandomizeZones(beirut_spawn_zones)
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)
  for i = 1, math.random(3, 5) do
    beirut_tankt90:Spawn()
  end
--[[                                                    
                                                          
██  ██  ▄▄▄ ▄▄▄▄▄▄ ▄▄▄  ▄▄ ▄▄   ██████  ▄▄▄  ▄▄  ▄▄ ▄▄▄▄▄ 
██████ ██▀██  ██  ██▀██ ▀███▀    ▄▄▀▀  ██▀██ ███▄██ ██▄▄  
██  ██ ██▀██  ██  ██▀██   █     ██████ ▀███▀ ██ ▀██ ██▄▄▄ 
                                                          
--]]

-- Hatay variables

local hatay_spawn_zones = {
  ZONE:FindByName("hatay_spawn-1"),
  ZONE:FindByName("hatay_spawn-2"),
  ZONE:FindByName("hatay_spawn-3")
}

Hatay = ZONE:FindByName("hatay")
Hatayopszone = OPSZONE:New(ZONE:FindByName("hatay"), coalition.side.RED)
Hatayopszone:Start()

-- Hatay Units spawning

local hatay_infantry = SPAWN:NewWithAlias("infantry_template", "Hatay Infantry")
  :InitRandomizeZones(hatay_spawn_zones)
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)

  for i = 1, math.random(5, 8) do
    hatay_infantry:Spawn()
  end

local hatay_tankt72 = SPAWN:NewWithAlias("tank_templatet72", "Hatay T-72")
  :InitRandomizeZones(hatay_spawn_zones)
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)

  for i = 1, math.random(2, 4) do
    hatay_tankt72:Spawn()
  end

local hatay_tankt90 = SPAWN:NewWithAlias("tank_templatet90", "Hatay T-90")
  :InitRandomizeZones(hatay_spawn_zones)
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)

  for i = 1, math.random(1, 3) do
    hatay_tankt90:Spawn()
  end

--[[                                                             
                                                                 
█████▄  ▄▄▄   ▄▄▄▄  ▄▄▄▄ ▄▄▄▄▄ ▄▄      ██████  ▄▄▄  ▄▄  ▄▄ ▄▄▄▄▄ 
██▄▄██ ██▀██ ███▄▄ ███▄▄ ██▄▄  ██       ▄▄▀▀  ██▀██ ███▄██ ██▄▄  
██▄▄█▀ ██▀██ ▄▄██▀ ▄▄██▀ ██▄▄▄ ██▄▄▄   ██████ ▀███▀ ██ ▀██ ██▄▄▄ 
                                                                 
--]]

-- Bassel variables

local bassel_spawn_zones = {
  ZONE:FindByName("bassel_spawn-1"),
  ZONE:FindByName("bassel_spawn-2"),
  ZONE:FindByName("bassel_spawn-3"),
  ZONE:FindByName("bassel_spawn-4"),
  ZONE:FindByName("bassel_spawn-5"),
  ZONE:FindByName("bassel_spawn-6"),
  ZONE:FindByName("bassel_spawn-7"),
  ZONE:FindByName("bassel_spawn-8")
}

Bassel = ZONE:FindByName("bassel")
Basselopszone = OPSZONE:New(ZONE:FindByName("bassel"), coalition.side.RED)
Basselopszone:Start()

-- Bassel Units spawning

local bassel_infantry = SPAWN:NewWithAlias("infantry_template", "Bassel Infantry")
  :InitRandomizeZones(bassel_spawn_zones)
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)

  for i = 1, math.random(8, 12) do
    bassel_infantry:Spawn()
  end

local bassel_tankt72 = SPAWN:NewWithAlias("tank_templatet72", "Bassel T-72")
  :InitRandomizeZones(bassel_spawn_zones)
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)

  for i = 1, math.random(3, 6) do
    bassel_tankt72:Spawn()
  end

local bassel_tankt90 = SPAWN:NewWithAlias("tank_templatet90", "Bassel T-90")
  :InitRandomizeZones(bassel_spawn_zones)
  :InitCleanUp(300)
  :InitValidateAndRepositionGroundUnits(true)

  for i = 1, math.random(2, 4) do
    bassel_tankt90:Spawn()
  end

