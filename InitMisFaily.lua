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

