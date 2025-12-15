--[[                                                
                                                   
▄▄▄▄▄  ▄▄▄  ▄▄  ▄▄ ▄▄▄▄▄  ▄▄▄▄   ▄▄    ▄▄ ▄▄  ▄▄▄  
  ▄█▀ ██▀██ ███▄██ ██▄▄  ███▄▄   ██    ██ ██ ██▀██ 
▄██▄▄ ▀███▀ ██ ▀██ ██▄▄▄ ▄▄██▀ ▄ ██▄▄▄ ▀███▀ ██▀██ 
                                                   
--]]
BASE:TraceAll(true)

local infantry_template = GROUP:FindByName("infantry_template")
local tank_templatet72 = GROUP:FindByName("tank_templatet72")
local tank_templatet90 = GROUP:FindByName("tank_templatet90")

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
local rene = ZONE:FindByName("rene")

-- Draw Rene zone on map

trigger.action.circleToAll(-1, 1, rene:GetPointVec3(), 4600, {1, 0, 0, 1}, {1, 0, 0, 0.3}, 1, true, "Rene")
trigger.action.textToAll(-1, 2, rene:GetPointVec3(), {1, 0, 0, 1}, {1, 0, 0, 0.3}, 27, true, "Rene")

-- Rene Unit spawning

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

-- Set up the zone so it can be captured

local rene_capture_zone = ZONE_CAPTURE_COALITION:New(rene, coalition.side.RED)
  :SetMarkZone(false)

rene_capture_zone:Start(10, 30)