
Zones_WWII = {}
Zones_WWII[1] = ZONE:New( "ZONE_WWII_MAYSKIY" )

SetSAMGroup = SET_GROUP:New()
	:FilterPrefixes( "SAM" )
	:FilterStart()

SetSukhGroups = SET_GROUP:New():FilterPrefixes( "Template Sukh"):FilterStart()	
SetSochCAP = SET_GROUP:New():FilterPrefixes( "Template CAP Soch"):FilterStart()	

SetClientWWII = SET_CLIENT:New():FilterPrefixes( "PilWWIIBlue" ):FilterStart()
SetGroupClientWWII = SET_GROUP:New():FilterPrefixes( "41.MinVody Blue" ):FilterStart()

-- SetGroupWWIIBlueCAP = SET_GROUP:New():FilterPrefixes( "WWII_Template_CAP_Blue" ):FilterOnce()
-- SetGroupWWIIRedCAP = SET_GROUP:New():FilterPrefixes( "WWII_Template_CAP_Red" ):FilterOnce()

Spawn_WWII = {}

Spawn_WWII.Blue = {}
Spawn_WWII.Red = {}
Spawn_WWII.Blue.CAP = {}
Spawn_WWII.Blue.CAP.Set = SET_GROUP:New():FilterPrefixes( "WWII_Template_CAP_BLUE" ):FilterOnce()
Spawn_WWII.Red.CAP = {}
Spawn_WWII.Red.CAP.Set = SET_GROUP:New():FilterPrefixes( "WWII_Template_CAP_RED" ):FilterOnce()
--Spawn_WWII.Blue.CAP.Spawn = SPAWN:New( Spawn_WWII.Blue.CAP.Set[1].GroupName )
Spawn_WWII.Blue.CAP.Table = {}
Spawn_WWII.Red.CAP.Table = {}

for groupName, groupData in pairs( Spawn_WWII.Blue.CAP.Set.Set ) do
	Spawn_WWII.Blue.CAP.Table[#Spawn_WWII.Blue.CAP.Table + 1] = groupData.GroupName
end

Spawn_WWII.Blue.CAP.Spawn = SPAWN:New( Spawn_WWII.Blue.CAP.Table[1] ):InitRandomizeTemplate( Spawn_WWII.Blue.CAP.Table ):InitCleanUp( 120 )
for groupName, groupData in pairs( Spawn_WWII.Red.CAP.Set.Set ) do
	Spawn_WWII.Red.CAP.Table[#Spawn_WWII.Red.CAP.Table + 1] = groupData.GroupName
end

Spawn_WWII.Red.CAP.Spawn = SPAWN:New( Spawn_WWII.Red.CAP.Table[1] ):InitRandomizeTemplate( Spawn_WWII.Red.CAP.Table ):InitCleanUp( 120 )

-- WWII_Blue_CC = COMMANDCENTER:New( STATIC:FindByName( "WWII_BLUE_CC" ), "MinVody Ground Control" )

-- WWII_Blue_Mission_CAP = MISSION:New( WWII_Blue_CC, "CAP MinVody area", "Primary", "Patrol Friendly airspace", "Blue" )

-- TestTargetSet = SET_UNIT:New():FilterPrefixes( "TEST_TASK_INTERCEPT" ):FilterStart()

-- WWII_Blue_Task_CAP = TASK_INTERCEPT:New( WWII_Blue_Mission_CAP, SetGroupClientWWII, "CAP", TestTargetSet )


-- WWII_Blue_Mission_CAP:AddTask( WWII_Blue_Task_CAP )

-- Spawn_WWII.Red.CAP.Spawn = SPAWN:New( Spawn_WWII.Red.CAP.Set[1] )


-- Kobu_CAP_MISSION = MISSION:New ( WWII_Blue_CC, "CAP Kobuleti area", "Primary", "Intercept ennemies", "Blue" )


SetAllBlue = SET_GROUP:New():FilterCoalitions( "blue" )




FailyAWACS = false

Spawn_Tanker_M2K = SPAWN:New( "Template Tanker M2K" ):InitLimit(1,0):InitCleanUp ( 120 )
Spawn_Tanker_Other = SPAWN:New( "Template KC 135" ):InitLimit(1,0):InitCleanUp ( 120 )
Spawn_Tanker_Navy = SPAWN:New( "Template Tanker Navy" ):InitLimit(1,0):InitCleanUp ( 120 )
Spawn_AWACS = SPAWN:New( "Template Blue AWACS" ):InitLimit(1,0):InitCleanUp ( 120 ):OnSpawnGroup( 
	function (SpawnGroup) 
		FailyAWACS = SpawnGroup
	end
	):SpawnScheduled(900,0)

-- Spawn_Blue_P51 = SPAWN:New("Template blue P51")
-- Spawn_Blue_bf109 = SPAWN:New("Template blue Bf109")
-- Spawn_Blue_fw190 = SPAWN:New("Template blue FW190")

Spawn_Sukh_Mi8 = SPAWN:New("Template Sukh Mi8")
Spawn_Sukh_Ka50 = SPAWN:New("Template Sukh Ka50")
Spawn_Mayk_Mig21 = SPAWN:New("template red mig21 maykop")
Spawn_Dog_Mig21 = SPAWN:New("Template Dogfight Mig21")
Spawn_Dog_Mig29A = SPAWN:New("Template Dogfight Mig29A")
Spawn_Dog_Mig29S = SPAWN:New("Template Dogfight Mig29S")
Spawn_Dog_Su27 = SPAWN:New("Template Dogfight Su27")
Spawn_Dog_Mirage = SPAWN:New("Template Dogfight Mirage")



Sukh_CAP_Zone = ZONE:New('Sukh_Patrol')

-- Sukh_PATROL_ZONE = AI_CAP_ZONE:New( Sukh_CAP_Zone, 3000, 6000, 500, 800 )

Sukh_CAP_list = { 'Template CAP Soch 1', 'Template CAP Soch 2', 'Template CAP Soch 3', 'Template CAP Soch 4', 'Template CAP Soch 5' }

Sukh_CAP_Spawn = SPAWN
	:New('Template CAP Soch 1')
	:InitRandomizeTemplate( Sukh_CAP_list )
	:InitCleanUp( 120 )
	:InitLimit(4, 2)
	:OnSpawnGroup( 
		function (SpawnGroup)
			local DCSControllable = SpawnGroup:GetDCSObject()
			if DCSControllable then 
				local Controller = DCSControllable:getController()
				Controller:setOption( AI.Option.Air.id.PROHIBIT_AG , true )
			end
			SpawnGroup.PatrolZone = AI_CAP_ZONE:New( Sukh_CAP_Zone, 5000, 8000, 500, 800 )
			SpawnGroup.PatrolZone:SetControllable( SpawnGroup )
			SpawnGroup.PatrolZone:ManageFuel( 0.3 , 600 )
			SpawnGroup.PatrolZone:__Start(5)
		end
	)
:SpawnScheduled( 1800 , 0 )

SetSukhCAP = SET_GROUP:New():FilterPrefixes( "Template CAP Soch 1#"):FilterStart()

function StartSetSpawning( SetGroup )
  SetGroup:SpawnScheduleStart()
end

function StopSetSpawning( SetGroup )
  SetGroup:SpawnScheduleStop()
end

function ClearSetGroup(SetGroup)
  for groupID, groupData in pairs( SetGroup.Set ) do
    groupData:Destroy()
  end
end


	Kobu_Tasks = {}
	Kobu_Missions = {}
	
WWII_CAP_list = { "Template RUS WWII 1" , "Template RUS WWII 1 #001" , "Template RUS WWII 1 #002" }
WWII_CAP_Zone_Group = GROUP:FindByName( "WII RED Patrol Zone Group" ) 
WWII_Circus_Zone_Group = GROUP:FindByName( "WWII Circus Zone" )
WWII_CAP_Zone = ZONE_POLYGON:New( "WWII_Polygon" , WWII_CAP_Zone_Group )
WWII_Circus_Zone = ZONE:New( "ZONE_WWII_MAYSKIY" )


Circus_RED_SPAWN = SPAWN
	:New( "Template RUS Circus" )
	:InitCleanUp ( 120 )
	:OnSpawnGroup(
		function (SpawnGroup)
			SpawnGroup.PatrolZone = AI_CAP_ZONE:New( WWII_Circus_Zone, 2500, 3000, 300, 500 )
			SpawnGroup.PatrolZone:SetControllable( SpawnGroup )
			SpawnGroup.PatrolZone:ManageFuel( 0.2 , 600 )
			SpawnGroup.PatrolZone:__Start(5)
		end
	)
Circus_BLUE_SPAWN = SPAWN
	:New( "Template BLUE Circus" )
	:InitCleanUp ( 120 )
	:OnSpawnGroup(
		function (SpawnGroup)
			SpawnGroup.PatrolZone = AI_CAP_ZONE:New( WWII_Circus_Zone, 2500, 3000, 300, 500 )
			SpawnGroup.PatrolZone:SetControllable( SpawnGroup )
			SpawnGroup.PatrolZone:ManageFuel( 0.2 , 600 )
			SpawnGroup.PatrolZone:__Start(5)
		end
	)
Circus_Sched = {}
Circus_GroupList = {}

function StartCircus(  )
	for i = 0, 7 do
		Circus_GroupList[ #Circus_GroupList + 1 ] = Circus_RED_SPAWN:Spawn()
		Circus_GroupList[ #Circus_GroupList + 1 ] = Circus_BLUE_SPAWN:Spawn()
	end
  local FollowGroupSet = SET_GROUP:New():FilterCategories("plane"):FilterCoalitions("blue"):FilterPrefixes("Template BLUE Circus"):FilterStart()

  FollowGroupSet:Flush()

  local LeaderUnit = Circus_GroupList[1]:GetUnit(1)

  local LargeFormation = AI_FORMATION:New( LeaderUnit, FollowGroupSet, "Large Formation", "Briefing" ):TestSmokeDirectionVector(false)

  LargeFormation:__Start( 1 )
end

Korea_RED_SPAWN = SPAWN
	:New( "Template RUS Korea" )
	:InitCleanUp ( 120 )
	:OnSpawnGroup(
		function (SpawnGroup)
			SpawnGroup.PatrolZone = AI_CAP_ZONE:New( WWII_Circus_Zone, 2500, 3000, 300, 500 )
			SpawnGroup.PatrolZone:SetControllable( SpawnGroup )
			SpawnGroup.PatrolZone:ManageFuel( 0.2 , 600 )
			SpawnGroup.PatrolZone:__Start(5)
		end
	)
Korea_BLUE_SPAWN = SPAWN
	:New( "Template BLUE Korea" )
	:InitCleanUp ( 120 )
	:OnSpawnGroup(
		function (SpawnGroup)
			SpawnGroup.PatrolZone = AI_CAP_ZONE:New( WWII_Circus_Zone, 2500, 3000, 300, 500 )
			SpawnGroup.PatrolZone:SetControllable( SpawnGroup )
			SpawnGroup.PatrolZone:ManageFuel( 0.2 , 600 )
			SpawnGroup.PatrolZone:__Start(5)
		end
	)
Korea_Sched = {}
Korea_GroupList = {}

function StartKorea(  )
	for i = 0, 3 do
		Korea_GroupList[ #Korea_GroupList + 1 ] = Korea_RED_SPAWN:Spawn()
		Korea_GroupList[ #Korea_GroupList + 1 ] = Korea_BLUE_SPAWN:Spawn()
	end
  local FollowGroupSet = SET_GROUP:New():FilterCategories("plane"):FilterCoalitions("blue"):FilterPrefixes("Template BLUE Korea"):FilterStart()

  FollowGroupSet:Flush()

  local LeaderUnit = Korea_GroupList[1]:GetUnit(1)

  local LargeFormation = AI_FORMATION:New( LeaderUnit, FollowGroupSet, "Large Formation", "Briefing" ):TestSmokeDirectionVector(false)

  LargeFormation:__Start( 1 )
end

	
SetMirageClients = SET_CLIENT:New():FilterPrefixes("Pilot M2000C"):FilterStart()


 

Tanker_M2K = Spawn_Tanker_M2K:Spawn()
Tanker_Other = Spawn_Tanker_Other:Spawn()
Tanker_Navy = Spawn_Tanker_Navy:Spawn()



local function SpawnNewGroup( Template )
   Spawn_Plane = Template:Spawn()
end

local function ReSpawnGroup( Template )
   Spawn_Plane = Template:ReSpawn(1)
end

local function ReSpawnAWACS()
	if FailyAWACS then
		FailyAWACS:Destroy()
	end
  FailyAWACS = Spawn_AWACS:Spawn()
end

local function ReSpawnGroupInZone( Template, Zone )
	Spawn_Group = Template:SpawnInZone(Zone, 1)
end







Spawn_Red_CSAR = SPAWN:New ("Template_RED_CSAR")
ZONE_Red_CSAR_1 = ZONE:New("Fight_Zone")
MenuCoalitionBlue = MENU_COALITION:New( coalition.side.BLUE, "Coalition")
MenuSpawnPlane = MENU_COALITION:New( coalition.side.BLUE, "Spawn Ennemy Plane", MenuCoalitionBlue )
MenuSpawnPlaneM21_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 2 Mig21 Maykop", MenuSpawnPlane, SpawnNewGroup, Spawn_Mayk_Mig21 )
MenuSpawnPlaneOther = MENU_COALITION:New( coalition.side.BLUE, "Other", MenuSpawnPlane)
MenuSpawnPlaneP51 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 P51D", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_P51 )
MenuSpawnPlaneFW190 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 FW-190 D9", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_FW190 )
MenuSpawnPlaneBf109 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 Bf109 K4", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_Bf109 )
MenuSpawnPlaneMig15 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 Mig15Bis", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_Mig15 )
MenuSpawnPlaneF86 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 F86-F", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_F86 )
MenuSpawnCircus = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Un Grand Cirque!", MenuSpawnPlaneOther, StartCircus )
MenuSpawnKorea = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Korean Furball", MenuSpawnPlaneOther, StartKorea )
-- MenuSpawnCircus = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Bf 109 Practice target", MenuSpawnPlaneOther, SpawnPractice109 )
MenuSpawnPlaneMi8 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Mi8", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_Sukh_Mi8 )
MenuSpawnPlaneKa50 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Ka50", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_Sukh_Ka50 )
MenuSpawnPlaneControl = MENU_COALITION:New( coalition.side.BLUE, "Controle des spawns", MenuSpawnPlane)
MenuSpawnPlaneStopSochi =  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Stopper le spawn auto a Sochi", MenuSpawnPlaneControl, StartSetSpawning, Sukh_CAP_Spawn )
MenuSpawnPlaneStartSochi =  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Demarrer le spawn auto a Sochi", MenuSpawnPlaneControl,  StopSetSpawning, Sukh_CAP_Spawn )
MenuSpawnPlaneClearSochi =  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Detruire les CAP ennemis en vol", MenuSpawnPlaneControl,  ClearSetGroup, SetSukhCAP )


MenuSpawnGround = MENU_COALITION:New( coalition.side.BLUE, "Spawn Ennemy Ground Target", MenuCoalitionBlue )
MenuSpawnGGroup1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Armor chemin 1", MenuSpawnGround, SpawnNewGroup, Spawn_Ground_1 )
MenuSpawnGGroup2 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Armor chemin 2", MenuSpawnGround, SpawnNewGroup, Spawn_Ground_2 )
MenuSpawnGGroup4 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Take Kutaisi scenario - no SA19", MenuSpawnGround, SpawnKutaisi, false )
MenuSpawnGGroup5 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Take Kutaisi scenario - w/ SA19", MenuSpawnGround, SpawnKutaisi, true )
MenuSpawnGGroup7 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Random Ground Attack scenario", MenuSpawnGround, RandomGroundObj )
MenuSpawnGroundControl = MENU_COALITION:New( coalition.side.BLUE, "Controle des troupes", MenuSpawnGround)
MenuSpawnGroundClearRnd = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Detruire les troupes des objectifs random", MenuSpawnGroundControl, ClearGroundObj )


--MenuSpawnSAM = MENU_COALITION:New( coalition.side.BLUE, "Spawn Ennemy SAM" )
--MenuSpawnSA19_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn SAM Position 1", MenuSpawnSAM, ReSpawnGroupInZone, Spawn_SAM_1, Zone_SA19_1 )
--MenuSpawnSA19_2 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn SAM Position 2", MenuSpawnSAM, ReSpawnGroupInZone, Spawn_SAM_2, Zone_SA19_2 )
--MenuSpawnSA10_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn SAM SA6", MenuSpawnSAM, ReSpawnGroupInZone, Spawn_SAM_5, Zone_KUB )
--MenuSpawnSA10_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn SAM SA11", MenuSpawnSAM, ReSpawnGroupInZone, Spawn_SAM_4, Zone_BUK )
--MenuSpawnSA10_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn SAM SA10 Gudauta", MenuSpawnSAM, ReSpawnGroupInZone, Spawn_SAM_3, Zone_SA10 )
--MenuSpawnEWR = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn GCI RED", MenuSpawnSAM, ReSpawnGroupInZone, Spawn_EWR_1, Zone_EWR )
--MenuCleanSAM = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Destroy all SAMs", MenuSpawnSAM, CleanSAM )

MenuSpawnTanker = MENU_COALITION:New( coalition.side.BLUE, "Spawn Tanker & AWACS", MenuCoalitionBlue )
MenuSpawnPlaneTankerM2K = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Tanker M2K", MenuSpawnTanker, ReSpawnGroup, Spawn_Tanker_M2K )
MenuSpawnPlaneTankerOther = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Tanker KC135", MenuSpawnTanker, ReSpawnGroup, Spawn_Tanker_Other )
MenuSpawnPlaneTankerOther = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Tanker PA", MenuSpawnTanker, ReSpawnGroup, Spawn_Tanker_Navy )
MenuSpawnPlaneAWACS = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "ReSpawn AWACS", MenuSpawnTanker, ReSpawnAWACS )


MenuSpawnDogfight = MENU_COALITION:New( coalition.side.BLUE, "Dogfight")
MenuSpawnDogM21 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Mig21", MenuSpawnDogfight, SpawnNewGroup, Spawn_Dog_Mig21 )
MenuSpawnDogM29A = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Mig29A", MenuSpawnDogfight, SpawnNewGroup, Spawn_Dog_Mig29A )
MenuSpawnDogM29S = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Mig29S", MenuSpawnDogfight, SpawnNewGroup, Spawn_Dog_Mig29S )
MenuSpawnDogSu27 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Su27", MenuSpawnDogfight, SpawnNewGroup, Spawn_Dog_Su27 )
MenuSpawnDogMirage = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Mirage", MenuSpawnDogfight, SpawnNewGroup, Spawn_Dog_Mirage )



-- WWII Target Practice Menu
SetBlueWWIIPlanes = SET_GROUP:New():FilterPrefixes( "41.MinVody Blue"):FilterStart()
Spawn_RED_109_Tgt = SPAWN:New("Template WWII RED Single 109")
local function SpawnPractice109( playerClient )
	local playerGroup = playerClient
	local name = playerGroup:GetName()
	local radius = 500
	local playerZone = ZONE_GROUP:New( name .. "_zone_practice", playerGroup , radius)
	local nmeGroup = Spawn_RED_109_Tgt:SpawnInZone(playerZone, true)
end

for clientName, clientData in pairs( SetBlueWWIIPlanes.Set ) do
	BASE:E({ clientName, routines.utils.oneLineSerialize(clientData)})
	clientData.MenuGroup = MENU_GROUP:New( clientData, "Group")
	clientData.MenuSpawnDogfight = MENU_GROUP_COMMAND:New( clientData, "Bf 109 Practice target", clientData.MenuGroup, SpawnPractice109, clientData )

end

for clientName, clientData in pairs( SetClientWWII.Set ) do
	BASE:E({ clientName, routines.utils.oneLineSerialize(clientData)})
--	clientData.MenuClient = MENU_CLIENT:New( clientData, "Client")
--	clientData.MenuSpawnDogfight2 = MENU_CLIENT_COMMAND:New( clientData, "Bf 109 Practice target", clientData.MenuClient, SpawnPractice109, clientData:GetGroup() )

end


-- Dynamic ground movement (Kutaisi - Kashuri region) begins here
-- DynGround holds all variable and functions for Dynamic Ground war stuff
SetBlueObj = SET_GROUP:New():FilterPrefixes( "Template_BLUE_OBJ" ):FilterOnce()
SetBlueObj:Flush()

SetBlueOff = SET_GROUP:New():FilterPrefixes( "GROUP_DYN_B" ):FilterOnce()
SetBlueOff:Flush()
SetRedOff = SET_GROUP:New():FilterPrefixes( "GROUP_DYN_R" ):FilterOnce()
SetRedOff:Flush()





SetRedObj = SET_GROUP:New():FilterPrefixes( "Template_RED_OBJ" ):FilterOnce()
SetBlueObj = SET_GROUP:New():FilterPrefixes( "Template_BLUE_OBJ" ):FilterOnce()

CallSigns = {
	[1]= "Axeman",	
	[2]= "Darknight",
	[3]= "Warrior",
	[4]= "Pointer",
	[5]= "Eyeball",	
	[6]= "Moonbeam",	
	[7]= "Whiplash",	
	[8]= "Finger",	
	[9]= "Pinpoint",	
	[10]= "Ferret",	
	[11]= "Shaba",	
	[12]= "Playboy",	
	[13]= "Hammer",	
	[14]= "Jaguar",	
	[15]= "Deathstar",	
	[16]= "Anvil",	
	[17]= "Firefly",	
	[18]= "Mantis",
	[19]= "Badger",
}

-- ConfigVars = {}
-- ConfigVars.UnpackedUnits = {}
-- ConfigVars.Zones = {}
ConfigVars = {}
do
	local FailyLfs = require('lfs')
	ConfigVars = persistence.load( FailyLfs.writedir()..'/scripts/misFaily/MissionConfig.lua' )
end
BASE:E("Config Variable : " .. routines.utils.oneLineSerialize(ConfigVars))
BASE:E(routines.utils.oneLineSerialize(ConfigVars.Zones))


function ListReports(GroupSet)
	local Report = "We have on ground on zone :\n"
	for groupName, groupData in pairs(GroupSet.Set) do
		if groupData:IsAlive() then
			local Detect = groupData.Detection
			local Freq = groupData.Frequency / 1000000
			local Callsign = groupData.Callsign
			local Count = 0 
			for Index, Value in pairs( Detect.DetectedObjects ) do
				Count = Count + 1
			end 
			Report = Report .. Callsign .. ", on " .. Freq .." MHz, in contact with " .. Count .." group(s).\n"
		end
	end
	return Report
end

function GenerateReport(DetectedItems, FACName, FACFreq)
	local Report = "This is " .. FACName .. ". We have contact with enemy :\n"
	local Contacts = {}
	local Count = 0
	for Id, Item in pairs(DetectedItems) do
		Count = Count + 1
		Contacts[Id] = {}
		Contacts[Id].Text = Item.ThreatText
		local Coord = COORDINATE:NewFromVec2(Item.Zone.LastVec2)
		Contacts[Id].Coord = Coord:ToStringLLDDM()
	end
	Report = Report .. " " .. Count .. " group(s) detected : \n"
	for Id, Contact in pairs(Contacts) do
		Report = Report .. "Group " .. Id .. " of " .. Contact.Text .. " at " .. Contact.Coord .. ".\n"
	end
	return Report
end

function BlueSpawnFunc(SpawnGroup, Region, Offensive)
	SpawnGroup.Frequency = (2600 + math.random(199) + Warzone[Region].blue.RadioOffset) * 100000
	local Callsign = math.random(19)
	local Id = math.random(5)
	SpawnGroup.Id = tostring(Id)
	SpawnGroup.RadioName = CallSigns[Callsign]
	SpawnGroup.Callsign = CallSigns[Callsign] .. " " .. Id
	SpawnGroup.Engaged = false
	SpawnGroup.LastTransmission = 11
	SpawnGroup.Offensive = false
	if Offensive then
		SpawnGroup.Offensive = true
		SpawnGroup:TaskRouteToZone( Warzone[Region].Zones[Warzone[Region].RedIndex], false, 15, "On Road" )
		SpawnGroup.TargetZone = Warzone[Region].Zones[Warzone[Region].RedIndex]
	end
	SpawnGroup.Radio = Warzone[Region].blue.Transmitter:GetRadio()
	SpawnGroup.Radio:SetFileName("beaconsilent.ogg")
	SpawnGroup.Radio:SetFrequency(SpawnGroup.Frequency / 1000000)
	SpawnGroup.Radio:SetModulation(radio.modulation.AM)
	SpawnGroup.Radio:SetPower(20)
	SpawnGroup.Radio:SetLoop(false)
	SpawnGroup.Radio:SetSubtitle("", 0 )
	SpawnGroup.LocalSet = SET_GROUP:New():AddGroupsByName(SpawnGroup.GroupName)
	Warzone[Region].blue.OffSet:AddGroupsByName(SpawnGroup.GroupName)
	SpawnGroup.Detection = DETECTION_AREAS:New(SpawnGroup.LocalSet, 500)
	SpawnGroup.Detection:SetAcceptRange( 5000 )
	SpawnGroup.Detection:InitDetectVisual( true )
	SpawnGroup.Detection:InitDetectOptical( true )
	SpawnGroup.Detection.LocalGroup = SpawnGroup.GroupName
	SpawnGroup.Detection:Start()
	local tmpCoord = SpawnGroup:GetCoordinate()
	SpawnGroup.Mark = tmpCoord:MarkToCoalitionBlue( "Group : " .. SpawnGroup.Callsign .. "\nFrequency : " .. (SpawnGroup.Frequency / 1000000) .. "MHz.\nEngaged : false" )
	SpawnGroup.Detection.OnAfterDetect = function (self, From, Event, To)
		local Count = 0
		-- local SpawnGroup = GROUP:FindByName(self.LocalGroup)
		if (self.DetectionSetGroup:Count() == 0) then
			self:E({"No more group detecting, stopping Detection Process", self})
			self:Stop()
			self = nil
			return
		end
		SpawnGroup = self.DetectionSetGroup:GetFirst()
		if not SpawnGroup:IsAlive() then
			self:E("Detecting group is dead, Stopping Detection Process")
			self:Stop()
			self=nil
			return
		end
		for Index, Value in pairs( self.DetectedObjects ) do
			Count = Count + 1
		end
		ennemyAlive = false
		if Count > 0 then 
			for Id, Item in pairs(self.DetectedItems) do
				Item.Set:ForEachUnit( function ( UnitObject )
					if UnitObject:IsAlive() then
						ennemyAlive = true
					end
				end
				)
			end
			if ennemyAlive then
				if SpawnGroup.Engaged == false then 
					SpawnGroup.Engaged = true
					local StopZone = ZONE_GROUP:New("Stop_Zone_" .. SpawnGroup.GroupName, SpawnGroup, 300)
					SpawnGroup:TaskRouteToZone( StopZone, true, 25, "Vee" )
					SpawnGroup:EnRouteTaskFAC( 5000, 5)
					for Id, Item in pairs(self.DetectedItems) do
						SpawnGroup.EnnemyPosition = COORDINATE:NewFromVec2(Item.Zone.LastVec2)
					end
					Warzone[Region].blue.Engaged[SpawnGroup.GroupName] = SpawnGroup
					Warzone:E("New nme detected",Warzone[Region].blue.Engaged )
				end
			end
			SpawnGroup.LastTransmission = SpawnGroup.LastTransmission + 1
		end
		if ( ( not ennemyAlive ) and ( SpawnGroup.Engaged == true ) ) then
			SpawnGroup.Engaged = false
			if Warzone[Region].blue.Engaged[SpawnGroup.GroupName] then
				Warzone[Region].blue.Engaged[SpawnGroup.GroupName] = nil
			end
			if SpawnGroup.Offensive then
				SpawnGroup:TaskRouteToZone( Warzone.North.Zones[Warzone.North.RedIndex], false, 15, "On Road" )
			end
		end
		local tmpCoord = SpawnGroup:GetCoordinate()
		if SpawnGroup.Mark then
			tmpCoord:RemoveMark ( SpawnGroup.Mark )
		end
		if SpawnGroup.Engaged then
			SpawnGroup.Mark = tmpCoord:MarkToCoalitionBlue( "Group : " .. SpawnGroup.Callsign .. "\nFrequency : " .. (SpawnGroup.Frequency / 1000000) .. "MHz.\nEngaged : true " )
		else
			SpawnGroup.Mark = tmpCoord:MarkToCoalitionBlue( "Group : " .. SpawnGroup.Callsign .. "\nFrequency : " .. (SpawnGroup.Frequency / 1000000) .. "MHz.\nEngaged : false " )
		end
	end
end

function AskReport(DetectingGroup)
--	local Report = ListReports(Warzone[Zone].blue.OffSet)
--	Warzone[Zone].blue.Radio:SetSubtitle( Report, 30 )
--	Warzone[Zone].blue.Radio:Broadcast()
	--Warzone[Zone].blue.Radio:NewUnitTransmission("beaconsilent.ogg", Report, 30, Warzone[Zone].blue.GroundFreq, radio.modulation.AM, false):Broadcast()
	--Warzone:E("COMM USAGE ON " .. Warzone[Zone].blue.GroundFreq .. " MHz : " .. Report)
	local Speech = {
		[1] = "this_is",
		[2] = DetectingGroup.RadioName,
		[3] = DetectingGroup.Id,
	}
	Speech[#Speech + 1] = "pause"
	Speech[#Speech + 1] = "armored_targets"
	Speech[#Speech + 1] = "at"
	local Coord = DetectingGroup.EnnemyPosition
	Speech = CoordToSpeech(Speech, Coord)
	RadioSpeech(DetectingGroup, Speech)
end

function RadioCheck(Zone)
	local Report = "This is " .. Zone .. " Ground control, check in."
--	Warzone[Zone].blue.Radio:SetSubtitle( Report, 30 )
--	Warzone[Zone].blue.Radio:Broadcast()
	Warzone[Zone].blue.Radio:NewUnitTransmission("beaconsilent.ogg", Report, 30, Warzone[Zone].blue.GroundFreq, radio.modulation.AM, false):Broadcast()
	Warzone:E(Report)
end




Warzone = BASE:New()
Warzone.ClassName = "MAIN_WARZONE"
Warzone.red = {}
Warzone.blue = {}
Warzone.MenuWarzone = MENU_COALITION:New( coalition.side.BLUE, "Ground Operations")
Warzone.ZoneList = {}
Warzone.red.Templates = {}
Warzone.blue.Templates = {}
Warzone.red.WHTemplate = SPAWNSTATIC:NewFromStatic("WH_R")
Warzone.blue.WHTemplate = SPAWNSTATIC:NewFromStatic("WH_B")
Warzone.red.CAS = {}
Warzone.red.CAS.CASGroups = {}
Warzone.red.CAS.AI_CAS = AI_CAS_ZONE:New( ZONE:New("RED_CAS_PATROL_1"), 100, 300, 80, 120, ZONE:New("RED_CAS_PATROL_1") )
--Warzone.red.CAS.CASSpawn = SPAWN:New("Template_RU_Heli_CAS_Center"):InitLimit(2, 0):OnSpawnGroup(
--			function (SpawnGroup)
--				Warzone.red.CAS.CASGroups[#Warzone.red.CAS.CASGroups + 1] = SpawnGroup
--				Warzone.red.CAS.AI_CAS:SetControllable( SpawnGroup )
--				Warzone.red.CAS.AI_CAS:__Start(1)
--			end)
--			:SpawnScheduled(1200,0)
for groupName, groupData in pairs( SetRedObj.Set ) do
  Warzone.red.Templates[#Warzone.red.Templates + 1] = groupName
end
for groupName, groupData in pairs( SetBlueObj.Set ) do
  Warzone.blue.Templates[#Warzone.blue.Templates + 1] = groupName
end

function Warzone:UpdateWarzoneMenu()
	self:E("updating Warzone Menu")
	for _, Zone in pairs(self.ZoneList) do
		self:E(Zone)
		-- Add missing menus
		for GroupName, GroupData in pairs(Warzone[Zone].blue.Engaged) do
			self:E({"GROUP ENGAGED", GroupName})
			if not Warzone[Zone].MenuZone.Commands[GroupName] then
				Warzone[Zone].MenuZone.Commands[GroupName] = MENU_COALITION_COMMAND:New( coalition.side.BLUE, GroupData.RadioName .. " " .. GroupData.Id .. " Report", Warzone[Zone].MenuZone.Main, AskReport, GroupData )
			end
		end
		-- Remove unneeded menus
		for GroupName, MenuData in pairs(Warzone[Zone].MenuZone.Commands) do
			if not Warzone[Zone].blue.Engaged[GroupName] then
				MenuData:Remove()
				Warzone[Zone].MenuZone.Commands[GroupName] = nil
			end
		end
	end
end

function CreateWH(Warzone, Zone, id, name, radius, static, groupData, side)
	BASE:E({"CREATEWH" , Zone, id, name, radius, static, groupData, side})
	BASE:E({"CREATEWH" , "ID", STATIC:FindByName("Static_" .. Zone .. "_" .. id):GetID()})
	Warzone[Zone].WH[id] = WAREHOUSE:New(STATIC:FindByName("Static_" .. Zone .. "_" .. id), "WareHouse_" .. Zone .. "_" .. id)
	Warzone[Zone].WH[id]:SetAutoDefenceOn()
	Warzone[Zone].Zones[id] = ZONE_GROUP:New(name .. "_Zone", groupData, radius)
	Warzone[Zone].WH[id]:SetWarehouseZone(Warzone[Zone].Zones[id])
	Warzone[Zone].WH[id]:Start()
	Warzone[Zone].ZoneCaptureCoalition[id] = {}
	-- Warzone[Zone].WH[id]:ChangeCountry(country.id.RUSSIA)
	--Warzone[Zone].ZoneCaptureCoalition[id].zcc = ZONE_CAPTURE_COALITION:New( Warzone[Zone].Zones[id] , coalition.side.RED )
	local Def = Warzone[side].DefSpawn:SpawnInZone( Warzone[Zone].WH[id].zone, true )
	Warzone[Zone].WH[id]:AddAsset(Def)
	Warzone[Zone].WH[id].WarzoneName = Zone
	Warzone[Zone].WH[id].OnAfterCaptured = function ( self, From, Event, To, Coalition, Country )
		local Coalition = Coalition
		if Coalition == coalition.side.RED then
			Warzone[Zone].RedIndex = Warzone[Zone].RedIndex + 1
			ConfigVars.Zones[Zone].RedIndex = Warzone[Zone].RedIndex
			local reinforcement = Warzone[Zone].red.OffGroup:Spawn()
			Warzone[Zone].red.WH:AddAsset(reinforcement)
			self:AddRequest(Warzone[Zone].red.WH, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_APC, 1)
			-- reinforcement:TaskRouteToZone( Warzone[Zone].Zones[Warzone[Zone].RedIndex], false, 15, "On Road" )
		end
		if Coalition == coalition.side.BLUE then
			Warzone[Zone].RedIndex = Warzone[Zone].RedIndex - 1
			ConfigVars.Zones[Zone].RedIndex = Warzone[Zone].RedIndex
			local reinforcement = Warzone[Zone].blue.OffGroup:Spawn()
			Warzone[Zone].blue.WH:AddAsset(reinforcement)
			self:AddRequest(Warzone[Zone].blue.WH, WAREHOUSE.Descriptor.ATTRIBUTE, WAREHOUSE.Attribute.GROUND_APC, 1)
			-- reinforcement:TaskRouteToZone( Warzone[Zone].Zones[Warzone[Zone].RedIndex + 1], false, 15, "On Road" )
		end
	end

	Warzone[Zone].WH[id].OnAfterAttacked = function ( self, From, Event, To, Coalition, Country )
		local Coalition = Coalition
		local AttackCoord = self.Zone:GetRandomCoordinate()
		if Coalition == coalition.side.RED then
			HeliGroup = Warzone[Zone].red.CAS:Spawn()
		end
		if Coalition == coalition.side.BLUE then
			HeliGroup = Warzone[Zone].blue.CAS:Spawn()
		end
		local HeliCoord = HeliGroup:GetCoordinate()
		local CurrentWaypoint = HeliCoord:WaypointAirTurningPoint( COORDINATE.WaypointAltType.RADIO, 110 )
		local ToWaypoint = AttackCoord:WaypointAirTurningPoint( COORDINATE.WaypointAltType.RADIO, 110 )
		HeliGroup:Route( { CurrentWaypoint , ToWaypoint }, 1 )
--		HeliGroup:TaskRouteToZone( self.Zone, true, 120, "Vee" )
		HeliGroup:OptionROEWeaponFree()
	end
	Warzone[Zone].WH[id].OnAfterSelfRequest = function (self, From, Event, To, groupset, request)
		if self:GetCoalition() == coalition.side.BLUE then
			for _, _group in pairs(groupset:GetSetObjects()) do
				local group = _group
				BlueSpawnFunc(group, self.WarzoneName, false)
			end
		end
	end
	Warzone[Zone].WH[id].OnAfterDefeated = function(From, Event, To)
		if self.autodefence then
			for _,request in pairs(self.defending) do
				for _,_group in pairs(request.cargogroupset:GetSetObjects()) do
					local group=_group
					group.Detection:Stop()
				end
			end
		end
	end
end

Warzone.red.DefSpawn = SPAWN:New(Warzone.red.Templates[1]):InitRandomizeTemplate(Warzone.red.Templates):InitRandomizeUnits(true, 300, 100)
-- Warzone.blue.DefSpawn = SPAWN:New(Warzone.blue.Templates[1]):InitRandomizeTemplate(Warzone.blue.Templates):InitRandomizeUnits(true, 300, 100)

Constants = {}
-- Constants.North = {}
Constants.Center = {}
Constants.NovoNorth = {}
Constants.NovoCoast = {}
-- Constants.North.GroundFreq = 131
-- Constants.North.RadioOffset = 0
-- Constants.North.RedIndex = 2
-- Constants.North.Name = "Zone Nord"
Constants.Center.GroundFreq = 137
Constants.Center.RadioOffset = 200
Constants.Center.RedIndex = 3
Constants.Center.Name = "Zone Anapa Krymsk"
Constants.NovoNorth.GroundFreq = 132
Constants.NovoNorth.RadioOffset = 400
Constants.NovoNorth.RedIndex = 1
Constants.NovoNorth.Name = "Zone Novorossyisk Krymsk"
Constants.NovoCoast.GroundFreq = 133
Constants.NovoCoast.RadioOffset = 600
Constants.NovoCoast.RedIndex = 2
Constants.NovoCoast.Name = "Zone cotiere Novorossyisk"


for Zone, Values in pairs(Constants) do
	Warzone[Zone] = {}
	Warzone[Zone].red = {}
	Warzone[Zone].blue = {}
	Warzone[Zone].blue.Engaged = {}
	Warzone.ZoneList[#Warzone.ZoneList +1] = Zone
	Warzone[Zone].Name = Values.Name
	Warzone[Zone].MenuZone = {}
	Warzone[Zone].MenuZone.Main = MENU_COALITION:New( coalition.side.BLUE, Values.Name, Warzone.MenuWarzone )
	Warzone[Zone].MenuZone.Commands = {}
	Warzone[Zone].blue.GroundFreq = Values.GroundFreq
	Warzone[Zone].blue.RadioOffset = Values.RadioOffset
	Warzone[Zone].blue.Transmitter = GROUP:FindByName("RADIO_" .. Zone)
	--Warzone.Center.blue.Radio = RADIO:New(SpawnGroup)
	Warzone[Zone].blue.Radio = Warzone[Zone].blue.Transmitter:GetRadio()
	Warzone[Zone].blue.Radio:SetFileName("beaconsilent.ogg")
	Warzone[Zone].blue.Radio:SetFrequency(Warzone[Zone].blue.GroundFreq)
	Warzone[Zone].blue.Radio:SetModulation(radio.modulation.AM)
	Warzone[Zone].blue.Radio:SetPower(20)
	Warzone[Zone].blue.Radio:SetLoop(false)
	Warzone[Zone].blue.Radio:SetSubtitle("", 0 )
	Warzone[Zone].red.OffGroup = SPAWN:New("GROUP_DYN_R_" .. Zone):InitRandomizeTemplate(Warzone.red.Templates):InitLimit(12, 0)
	Warzone[Zone].blue.OffGroup = SPAWN:New("GROUP_DYN_B_" .. Zone):InitRandomizeTemplate(Warzone.blue.Templates):InitLimit(12, 0)
	Warzone[Zone].blue.OffSet = SET_GROUP:New()
	Warzone[Zone].blue.DefSpawn = SPAWN:NewWithAlias(Warzone.blue.Templates[1], "Template_" .. Zone .. "_DEF_"):InitRandomizeTemplate(Warzone.blue.Templates):InitRandomizeUnits(true, 300, 100):OnSpawnGroup( BlueSpawnFunc, Zone, false )
	Warzone[Zone].red.SpawnZone = ZONE_GROUP:New(Zone .. "_Red_Spawn", GROUP:FindByName("GROUP_DYN_R_" .. Zone), 500)
	Warzone[Zone].blue.SpawnZone = ZONE_GROUP:New(Zone .. "_Blue_Spawn", GROUP:FindByName("GROUP_DYN_B_" .. Zone), 500)
	Warzone[Zone].red.CAS = SPAWN:New("Template_RU_Heli_CAS_" .. Zone):InitCleanUp( 60 ):InitLimit(2, 0)
	Warzone[Zone].blue.CAS = SPAWN:New("Template_US_Heli_CAS_" .. Zone):InitCleanUp( 60 ):InitLimit(2, 0)
	Warzone[Zone].red.WH = WAREHOUSE:New(STATIC:FindByName("WH_" .. Zone .. "_R"))
	BASE:E({"CREATEWH", "Static template", STATIC:FindByName("WH_" .. Zone .. "_R"):GetID()})
	Warzone[Zone].red.WH:Start()
	Warzone[Zone].blue.WH = WAREHOUSE:New(STATIC:FindByName("WH_" .. Zone .. "_B"))
	BASE:E({"CREATEWH", "Static template", STATIC:FindByName("WH_" .. Zone .. "_R"):GetID()})
	Warzone[Zone].blue.WH:Start()
	Warzone[Zone].ZoneSet = SET_GROUP:New():FilterPrefixes( "ZONE_CAPTURE_" .. Zone ):FilterOnce()
	Warzone[Zone].RedIndex = Values.RedIndex
--	if setContains(ConfigVars, "Zones") then
	if ConfigVars.Zones then
--		if setContains(ConfigVars.Zones, Zone) then
		if ConfigVars.Zones[Zone] then
--			if setContains(ConfigVars.Zones[Zone], "RedIndex") then
			if ConfigVars.Zones[Zone].RedIndex then
				BASE:E("Using Config File Defined RedIndex "  .. ConfigVars.Zones[Zone].RedIndex .. " for Zone : " .. Zone)
				Warzone[Zone].RedIndex = ConfigVars.Zones[Zone].RedIndex
			end
		end
	end
	-- ConfigVars.Zones[Zone].RedIndex = Values.RedIndex
	Warzone[Zone].Zones = {}
	Warzone[Zone].ZoneCaptureCoalition = {}
	Warzone[Zone].WH = {}


	for groupName, groupData in pairs( Warzone[Zone].ZoneSet.Set ) do
		local tmpSub = string.gsub(groupName, "ZONE_CAPTURE_" .. Zone .. "_", "")
		local splitSub = csplit(tmpSub, "_")
		local radius = tonumber(splitSub[3])
		local name = splitSub[2]
		
		local id = tonumber(splitSub[1])

		Warzone:E( "Creating Warzone in " .. name .. ", zone " .. Zone .. ", id " .. id)
		-- Warzone[Zone].WH[id] = WAREHOUSE:New(STATIC:FindByName("WH_" .. Zone .. "_" .. id ))
		
		if id <= Warzone[Zone].RedIndex then
			local static = Warzone.red.WHTemplate:SpawnFromPointVec2(groupData:GetPointVec2(), 0, "Static_" .. Zone .. "_" .. id)
			BASE:E({"SPAWNSTATICID", static:GetID()})
			-- Warzone[Zone].WH[id] = WAREHOUSE:New(STATIC:FindByName("Static_" .. Zone .. "_" .. id), "WareHouse_" .. Zone .. "_" .. id)
			local WHSched = SCHEDULER:New(nil, CreateWH, {Warzone, Zone, id, name, radius, static, groupData, "red"}, 5)
		else
			BASE:E("Check for Warzone id : " .. id .. " in Zone " .. Zone)
			local static = Warzone.blue.WHTemplate:SpawnFromPointVec2(groupData:GetPointVec2(), 0, "Static_" .. Zone .. "_" .. id)
			local WHSched = SCHEDULER:New(nil, CreateWH, {Warzone, Zone, id, name, radius, static, groupData, "blue"}, 5)
		end
		-- Warzone[Zone].ZoneCaptureCoalition[id].zcc:Mark()
		-- Warzone[Zone].ZoneCaptureCoalition[id].zcc:Start( 5, 60 )
		
		
	end

	Warzone[Zone].blue.OffGroup:OnSpawnGroup( BlueSpawnFunc, Zone, true )
	Warzone[Zone].blue.OffGroup:SpawnScheduled( 2400 , 0.4 )

	Warzone[Zone].red.OffGroup:OnSpawnGroup(
			function (SpawnGroup)
				SpawnGroup:TaskRouteToZone( Warzone[Zone].Zones[Warzone[Zone].RedIndex + 1], false, 15, "On Road" )
				SpawnGroup.TargetZone = Warzone[Zone].Zones[Warzone[Zone].RedIndex]
				SpawnGroup.LocalSet = SET_GROUP:New():AddGroupsByName(SpawnGroup.GroupName)
				SpawnGroup.Detection = DETECTION_AREAS:New(SpawnGroup.LocalSet, 500)
				SpawnGroup.Detection:SetAcceptRange( 5000 )
				SpawnGroup.Detection:InitDetectVisual( true )
				SpawnGroup.Detection:InitDetectOptical( true )
				SpawnGroup.Detection.LocalGroup = SpawnGroup.GroupName
				SpawnGroup.Detection:Start()
				SpawnGroup.Detection.OnAfterDetect = function (self, From, Event, To)
					local Count = 0
					for Index, Value in pairs( self.DetectedObjects ) do
						Count = Count + 1
					end
					if Count > 0 then 
						if SpawnGroup.Engaged == false then 
							SpawnGroup.Engaged = true
							local StopZone = ZONE_GROUP:New("Stop_Zone_" .. SpawnGroup.GroupName, SpawnGroup, 300)
							SpawnGroup:TaskRouteToZone( StopZone, true, 25, "Vee" )
						end
					end
					if ( ( Count == 0 ) and ( SpawnGroup.Engaged == true ) ) then
						SpawnGroup.Engaged = false
						SpawnGroup:TaskRouteToZone( Warzone[Zone].Zones[Warzone[Zone].RedIndex + 1], false, 15, "On Road" )
					end
				end
			end
		)
	Warzone[Zone].red.OffGroup:SpawnScheduled( 2400 , 0.4 )
	--MENU_COALITION_COMMAND:New( coalition.side.BLUE, Zone .. " Zone radio check", Warzone.MenuWarzone, RadioCheck, Zone )
	--MENU_COALITION_COMMAND:New( coalition.side.BLUE, Zone .. " Zone Report", Warzone.MenuWarzone, AskReport, Zone )
end

Warzone.MenuUpdater = SCHEDULER:New(nil, Warzone.UpdateWarzoneMenu, { Warzone }, 60, 60 )


function CoordToSpeech(Speech, Coord)
	local Coords = Coord:ToStringLLDDM()
	tmpSub = string.gsub(Coords , "LL DDM", "")
	splitSub = csplit(tmpSub, "'")
	myLat = string.gsub(splitSub[1], ", ", "")
	for c in myLat:gmatch"." do 
		if c == " " then c = "North" end
		if c == "." then c = "Point" end
		Speech[#Speech + 1] = c
	end
	Speech[#Speech + 1] = "pause"
	myLon = string.gsub(splitSub[2], "N   ", "")
	for c in myLon:gmatch"." do 
		if c == " " then c = "East" end
		if c == "." then c = "Point" end
		Speech[#Speech + 1] = c
	end
	return Speech
end


BASE:E("Pushing params for SPEECH : " .. routines.utils.oneLineSerialize(SpeechTest))
function RadioSpeech(RadioGroup, SpeechTest)
	local Delay = 2
	BASE:E( "TestRadio launched, initial delay is : " .. Delay)
	for Id, Sp in pairs(SpeechTest) do
		local SpeechData = SPEECH[Sp]
		SCHEDULER:New( nil, 
			function()
				RadioGroup.Radio:NewUnitTransmission(SpeechData.FileName, "", SpeechData.Duration, RadioGroup.Frequency / 1000000, radio.modulation.AM, false):Broadcast()				
			end, {}, Delay
		)	
		Delay = Delay + SpeechData.Duration
		SCHEDULER:New( nil, 
			function()
				RadioGroup:SetCommand({
					id = "StopTransmission",
					params = {}
				})
			end, {}, Delay
		)	
		Delay = Delay + 0.2
		-- BASE:E( "Next speech delay is : " .. Delay)
	end
end



function SaveConfig()
	local FailyLfs = require('lfs')
	persistence.store( FailyLfs.writedir()..'/scripts/misFaily/MissionConfig.lua' , ConfigVars)
end

MarkedGroups = {}
MarkedGroups[#MarkedGroups + 1] = GROUP:FindByName("CG Patulacci")
MarkedGroups[#MarkedGroups + 1] = GROUP:FindByName("CG Robichet")
MarkedGroups[#MarkedGroups + 1] = GROUP:FindByName("FARP_NORD_SUPPORT")
MarkedGroups[#MarkedGroups + 1] = GROUP:FindByName("FARP_EAST_SUPPORT")
PermanentMarkers = {}
for Id, Group in pairs(MarkedGroups) do
	PermanentMarkers[#PermanentMarkers + 1] = Group:GetCoordinate():MarkToCoalitionBlue( Group.GroupName .. "\nCap : " .. Group:GetHeading() )
end

function checkAssets(Logi, ConfigVars)
	BASE:E("Regular asset checking")
	BASE:E(Logi)
	BASE:E(ConfigVars)
	ConfigVars["Generation"] = ConfigVars["Generation"] + 1
	local pers = {}
	for Id, Asset in pairs(Logi.DeployedAssets) do
		local g = Asset.Deployed
		g:GetCoordinate():RemoveMark(g.mark)
		if not Asset.Generation then
			Asset.Generation = ConfigVars.Generation
		end
		if g:IsAlive() then
			local persInfo = {}
			persInfo.Template = Asset.Template
			persInfo.x = g:GetCoordinate()["x"]
			persInfo.y = g:GetCoordinate()["y"]
			persInfo.z = g:GetCoordinate()["z"]
			persInfo.Player = Asset.Player
			persInfo.Generation = Asset.Generation
			persInfo.isArty = Asset.isArty
			pers[#pers + 1] = persInfo
		end
	end
	ConfigVars["UnpackedUnits"] = pers
	SaveConfig()
	for Id, Mark in pairs(PermanentMarkers) do
		COORDINATE:RemoveMark( Mark )
	end
	PermanentMarkers = {}
	for Id, Group in pairs(MarkedGroups) do
		PermanentMarkers[#PermanentMarkers + 1] = Group:GetCoordinate():MarkToCoalitionBlue( Group.GroupName .. "\nCap : " .. Group:GetHeading() )
	end
end



logisticsParameters = {}

-- Prefix used in Logistics Zone Names
logisticsParameters.LogisticsZonePrefixes = {
	"pickzone",
}


-- Prefix used in Group names able to do infantry transport tasks
logisticsParameters.InfantryPlayersPrefixes = {
	"120",
	"320",
	"420",
	"520",
}

-- Prefix used in Group names able to do any transport tasks
logisticsParameters.TransportPlayersPrefixes = {
	"120",
	"320",
	"420",
	"520",
}

-- Templates of infantry groups - Format : ["<Menu group name>"] = "ME Group template name"
logisticsParameters.InfantryTemplates = {
	["Basic Squad"] = "Infantry1",
	["AA Squad"] = "Infantry2",
	["AT Squad"] = "Infantry3",
}

logisticsParameters.SlingloadPrefixes = {
	"TEMPLATE_SLING_1500",
	"TEMPLATE_SLING_3000",
}

logisticsParameters.SlingloadTemplates = {
	["Cargo 1500kg"] = "TEMPLATE_SLING_1500",
	["Cargo 3000Kg"] = "TEMPLATE_SLING_3000",
}

logisticsParameters.SlingloadWeights = {
	["Cargo 1500kg"] = 1500,
	["Cargo 3000Kg"] = 3000
}

logisticsParameters.CargoTemplatesWeight = {
	["TEMPLATE_AVENGER"] = 1400,
	["TEMPLATE_LINEBACKER"] = 2700,
	["TEMPLATE_CHAPARRAL"] = 4200,
	["TEMPLATE_AMMO"] = 1000,
	["TEMPLATE_SA6"] = 7300,
	["TEMPLATE_MLRS"] = 6400,
	["TEMPLATE_PALADIN"] = 9800,
	["TEMPLATE_NONA"] = 2900,
	["TEMPLATE_GVOSDIKA"] = 4400,
}

logisticsParameters.CargoTemplatesName = {
	["TEMPLATE_AVENGER"] = "M1097 Avenger (1.4T)",
	["TEMPLATE_LINEBACKER"] = "M6 Linebacker (2.7T)",
	["TEMPLATE_CHAPARRAL"] = "M48 Chaparral with Supply (4.2T)",
	["TEMPLATE_AMMO"] = "Supply Truck (1T)",
	["TEMPLATE_SA6"] = "SA6 Site (7.3T)",
	["TEMPLATE_MLRS"] = "MLRS Arty (6.4T)",
	["TEMPLATE_PALADIN"] = "Paladin Arty (9.8T)",
	["TEMPLATE_NONA"] = "Nona Arty (2.9T)",
	["TEMPLATE_GVOSDIKA"] = "Gvosdika Arty (4.4T)",
}

logisticsParameters.isArty = {
	["TEMPLATE_AVENGER"] = false,
	["TEMPLATE_LINEBACKER"] = false,
	["TEMPLATE_CHAPARRAL"] = false,
	["TEMPLATE_AMMO"] = false,
	["TEMPLATE_SA6"] = true,
	["TEMPLATE_MLRS"] = true,
	["TEMPLATE_PALADIN"] = true,
	["TEMPLATE_NONA"] = true,
	["TEMPLATE_GVOSDIKA"] = true,
}


FailyLogistics = LOGISTICS:New( logisticsParameters )
-- Doing Asset check every 5 minutes
-- 864 * 5 minutes is 3 days, all assets will last 3 days
MaxGeneration = 863
for Id, Asset in pairs(ConfigVars["UnpackedUnits"]) do
	if ( ConfigVars["Generation"] - Asset.Generation ) > MaxGeneration then
		ConfigVars["UnpackedUnits"][Id] = nil
	else
		local DeploySpawn = FailyLogistics["DeploySpawn"][Asset.Template]
		local playerName = Asset.Player
		local v2 = COORDINATE:New( Asset.x, Asset.y , Asset.z )
		local SpawnObject = SPAWN:NewWithAlias(DeploySpawn.TemplateName, "Spawned_" .. DeploySpawn.TemplateName .. "_by_" .. playerName)
		local depGroup = SpawnObject:SpawnFromVec2( v2:GetVec2() )
		if DeploySpawn.isArty then
			depGroup.arty = ARTY:New( depGroup )
			depGroup.arty:SetMarkAssignmentsOn()
			depGroup.arty:Start()
		end
		local pers = {}
		pers.Deployed = depGroup
		pers.Template = DeploySpawn.TemplateName
		pers.x = depGroup:GetCoordinate()["x"]
		pers.y = depGroup:GetCoordinate()["y"]
		pers.z = depGroup:GetCoordinate()["z"]
		pers.Player = Asset.Player
		pers.Generation = Asset.Generation
		pers.Deployed.mark = v2:MarkToCoalitionBlue( DeploySpawn["MenuName"] .. "\nDeployed by : " .. Asset.Player .. "\nGroup : " .. depGroup.GroupName )
		FailyLogistics.DeployedAssets[#FailyLogistics.DeployedAssets + 1 ] = pers
	end

end

DataSaver = SCHEDULER:New(nil, checkAssets, {FailyLogistics, ConfigVars}, 300, 300 )

AdminGroup = GROUP:FindByName("ADMIN")
AdminMenu = MENU_GROUP:New(AdminGroup, "Admin")
MENU_GROUP_COMMAND:New(AdminGroup, "Save Config", AdminMenu, SaveConfig)

Arty_Group = GROUP:FindByName("ARTY_GROUP_TEST")
Arty_Object = ARTY:New( Arty_Group )
BASE:E({Arty_Object})
Arty_Object.Debug = false
Arty_Object:SetMarkAssignmentsOn()
Arty_Object:Start()
