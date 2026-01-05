Opszones = { Reneopszone, Beirutopszone, Basselopszone, Hatayopszone, Wujahopszone, Latakiaopszone }

Platoon1 = PLATOON:New("blue_ca_unit", 10, "M1A2 SEPv3 Abrams Platoon")
Platoon1:AddMissionCapability({AUFTRAG.Type.GROUNDATTACK, AUFTRAG.Type.CAPTUREZONE}, 90)

FS13 = SQUADRON:New("fa18c_squadron", 8, "F/A-18C Squadron")
FS13:SetGrouping(2)                      -- Two-ships. Good to have a wingmen.
FS13:SetModex(100)                       -- Onboard numbers are 100, 101, ...
FS13:SetCallsign(CALLSIGN.Aircraft.Ford) -- Call sign is Ford.
FS13:SetRadio(260)                       -- Squadon communicates on 260 MHz AM.
FS13:SetSkill(AI.Skill.EXCELLENT)        -- These guy are really good.
FS13:AddMissionCapability({AUFTRAG.Type.ORBIT, AUFTRAG.Type.INTERCEPT, AUFTRAG.Type.CAP, AUFTRAG.Type.ESCORT}, 90)

BrigadeIncirlik = BRIGADE:New(STATIC:FindByName("Warehouse Incirlik-1"):GetName(), "Incirlik Brigade")
AirwingIncirlik = AIRWING:New(STATIC:FindByName("Warehouse Incirlik-1"):GetName(), "Incirlik Airwing")

if BrigadeIncirlik == nil then
end
BrigadeIncirlik:AddPlatoon(Platoon1)
if AirwingIncirlik == nil then
end
AirwingIncirlik:AddSquadron(FS13)

Agents = SET_GROUP:New():FilterPrefixes({"Blue EWR", "Blue", "Aerial"}):FilterStart()

Chief = CHIEF:New(coalition.side.BLUE, Agents)

Chief:SetTacticalOverviewOn()
Chief:SetStrategy(CHIEF.Strategy.OFFENSIVE)
Chief:AddBrigade(BrigadeIncirlik)
Chief:AddAirwing(AirwingIncirlik)
Chief:__Start(1)
Chief:AddStrategicZone(Hatayopszone, 50, 1)
function Chief:OnAfterNewContact(From, Event, To, Contact)

    -- Gather info of contact.
    local ContactName = Chief:GetContactName(Contact)
    local ContactType = Chief:GetContactTypeName(Contact)
    local ContactThreat = Chief:GetContactThreatlevel(Contact)

    -- Text message.
    local text = string.format("Detected NEW contact: Name=%s, Type=%s, Threat Level=%d", ContactName, ContactType,
        ContactThreat)
    -- Show message in log file.
    env.info(text)
end

function Chief:OnAfterMissionAssign(From, Event, To, Mission, Legions)
    local text2 = string.format("Debug message" .. From  ..  Event  ..  To  ..  Mission  ..  Legions)
    env.info(text2)
end

