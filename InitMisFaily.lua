-- To do : 
-- Gestion menus - 0
-- Respawn Tankers & AWACS -0 
-- Airbase Warehouse integration & CAP Setup - 0 
-- FARP Warehouse integration & Radio setup - 0 
-- permanent markers settings - 0 

-- Specific Templates & Spawns definitions
Spawn_Tanker_M2K = SPAWN:New( "Template Tanker M2K" ):InitLimit(1,0):InitCleanUp ( 120 )
Spawn_Tanker_Other = SPAWN:New( "Template KC 135" ):InitLimit(1,0):InitCleanUp ( 120 )
Spawn_Tanker_Navy = SPAWN:New( "Template Tanker Navy" ):InitLimit(1,0):InitCleanUp ( 120 )
Spawn_AWACS = SPAWN:New( "Template Blue AWACS" ):InitLimit(1,0):InitCleanUp ( 120 ):OnSpawnGroup( 
	function (SpawnGroup) 
		FailyAWACS = SpawnGroup
	end
	):SpawnScheduled(900,0)

-- SETs definitions
SET_WH_AIRB = SET_STATIC:New():FilterPrefixes("WH_AIRB_"):FilterStart()
SET_BLUE_DETECT = SET_GROUP:New():FilterPrefixes({ "GCI BLU", "Template Blue AWACS" })


-- General functions definition
local function ReSpawnGroup( Template )
   Spawn_Plane = Template:ReSpawn(1)
end

local function ReSpawnAWACS()
	if FailyAWACS then
		FailyAWACS:Destroy()
	end
  FailyAWACS = Spawn_AWACS:Spawn()
end



-- Gestion menus
MenuCoalitionBlue = MENU_COALITION:New( coalition.side.BLUE, "Coalition")
MenuSpawnTanker = MENU_COALITION:New( coalition.side.BLUE, "Spawn Tanker & AWACS", MenuCoalitionBlue )
MenuSpawnPlaneTankerM2K = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Tanker M2K", MenuSpawnTanker, ReSpawnGroup, Spawn_Tanker_M2K )
MenuSpawnPlaneTankerOther = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Tanker KC135", MenuSpawnTanker, ReSpawnGroup, Spawn_Tanker_Other )
MenuSpawnPlaneTankerOther = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Tanker PA", MenuSpawnTanker, ReSpawnGroup, Spawn_Tanker_Navy )
MenuSpawnPlaneAWACS = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "ReSpawn AWACS", MenuSpawnTanker, ReSpawnAWACS )


-- general tasks
FailyAWACS = false
Tanker_M2K = Spawn_Tanker_M2K:Spawn()
Tanker_Other = Spawn_Tanker_Other:Spawn()
Tanker_Navy = Spawn_Tanker_Navy:Spawn()
ReSpawnAWACS()
Blue_Detection = DETECTION_AREAS:New( SET_BLUE_DETECT, 30000 )
Blue_A2ADispatcher = AI_A2A_DISPATCHER:New( Blue_Detection )
Blue_A2ADispatcher:SetEngageRadius(20000)
Blue_A2ADispatcher:SetGciRadius(45000)
Blue_A2ADispatcher:SetSquadron( "Anapa", AIRBASE.Caucasus.Anapa_Vityazevo, { "Template_Blue_CAP_Disp" } )
Blue_A2ADispatcher:SetSquadronTakeoffFromParkingHot( "Anapa" )
Blue_A2ADispatcher:SetSquadronLandingAtEngineShutdown( "Anapa" )
-- ZONE_CAP_BLUE
Blue_A2ADispatcher:SetSquadronCap( "Anapa", ZONE_POLYGON:New( "ZONE_CAP_BLUE", GROUP:FindByName( "ZONE_CAP_BLUE" ) ), 4000, 8000, 600, 800, 800, 1200, "BARO" )
Blue_A2ADispatcher:SetSquadronCapInterval( "Anapa", 2, 30, 120, 1 )


-- WareHouses listing
FailyWH = BASE:New()
FailyWH.classname = "WH_LIST"
FailyWH.Airbases = {}
for whName, whData in pairs(SET_WH_AIRB.Set) do
	FailyWH:E(whName)
	FailyWH:E(whData)
	splitName = csplit(whName, "_")
	abName = splitName[3]
	for id, strg in pairs(splitName) do
		if id > 3 then
			abName = abName .. "_" .. splitName[id]
		end
	end
	FailyWH:E(abName)
	tmpAb = AIRBASE:FindByName(abName)
	FailyWH:E(tmpAb)
	FailyWH.Airbases[abName] = WAREHOUSE:New(whData, abName)
	FailyWH.Airbases[abName]:SetAirbase(tmpAb)
	FailyWH.Airbases[abName]:Start()

end