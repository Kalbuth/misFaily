Zone_SA19_1 = ZONE:New( "SA19-1 Zone" )
Zone_SA19_2 = ZONE:New( "SA19-2 Zone" )
Zone_SA10 = ZONE:New( "SA10_Zone" )
Zone_EWR = ZONE:New( "EWR Zone" )
Zone_BUK = ZONE:New( "SA11 Zone" )
Zone_KUB = ZONE:New( "SA6 Zone" )
Zone_Template = ZONE:New( "Template Zone" )
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





Spawn_M29_1 = SPAWN:New("AI Agressor 1")
Spawn_M29_2 = SPAWN:New("AI Agressor 2")
Spawn_M23_1 = SPAWN:New("AI Agressor 3")
Spawn_M23_2 = SPAWN:New("AI Agressor 4")
Spawn_Tanker_M2K = SPAWN:New( "Template Tanker M2K" ):InitLimit(1,0)
Spawn_Tanker_Other = SPAWN:New( "Template KC 135" ):InitLimit(1,0)
Spawn_Ground_1 = SPAWN:New("RUS_ARMOR_L_1")
Spawn_Ground_2 = SPAWN:New("RUS_ARMOR_L_2")
Spawn_SAM_1 = SPAWN:New("SAM SA19-1"):InitLimit(7, 0)
Spawn_SAM_2 = SPAWN:New("SAM SA19-2"):InitLimit(7, 0)
Spawn_SAM_3 = SPAWN:New("SAM SA10-1"):InitLimit(12, 0)
Spawn_SAM_4 = SPAWN:New("SAM BUK"):InitLimit(9, 0)
Spawn_SAM_5 = SPAWN:New("SAM KUB"):InitLimit(8, 0)
Spawn_Inf_RUS_1 = SPAWN:New("infantry FARP 1")
Spawn_EWR_1 = SPAWN:New("Template EWR1"):InitLimit(3, 0)
Spawn_P51 = SPAWN:New("Template P51D")
Spawn_Bf109 = SPAWN:New("Template Bf109")
Spawn_FW190 = SPAWN:New("Template FW190")
Spawn_Mig15 = SPAWN:New("Template Mig15")
Spawn_F86 = SPAWN:New("Template F86")
Spawn_Blue_P51 = SPAWN:New("Template blue P51")
-- Spawn_Blue_bf109 = SPAWN:New("Template blue Bf109")
Spawn_Blue_fw190 = SPAWN:New("Template blue FW190")
Spawn_Kuta_SAM = SPAWN:New("Template Kutaisi SAM")
Spawn_Kuta_1 = SPAWN:New("Template Kutaisi 1")
Spawn_Kuta_2 = SPAWN:New("Template Kutaisi 2")
Spawn_Kuta_3 = SPAWN:New("Template Kutaisi 3")
Spawn_Kuta_4 = SPAWN:New("Template Kutaisi 4")
Spawn_Kuta_5 = SPAWN:New("Template Kutaisi 5")
Spawn_Sukh_Mi8 = SPAWN:New("Template Sukh Mi8")
Spawn_Sukh_Ka50 = SPAWN:New("Template Sukh Ka50")
Spawn_Gud_Su25T = SPAWN:New("Template Gud Su25T")
Spawn_Mayk_Mig21 = SPAWN:New("template red mig21 maykop")
Spawn_Dog_Mig21 = SPAWN:New("Template Dogfight Mig21")
Spawn_Dog_Mig29A = SPAWN:New("Template Dogfight Mig29A")
Spawn_Dog_Mig29S = SPAWN:New("Template Dogfight Mig29S")
Spawn_Dog_Su27 = SPAWN:New("Template Dogfight Su27")
Spawn_Dog_Mirage = SPAWN:New("Template Dogfight Mirage")


Zone_Achig = ZONE:New("Achigvara")

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


function ActivateSochCAP( event )
	if event.id == world.event.S_EVENT_SHOT and mist.utils.get2DDist(event.initiator:getPosition().p, trigger.misc.getZone("Fight_Zone").point) < 100000 then
		if event.initiator:getCoalition() == coalition.side.BLUE then
			for CAPGroupId, CAPGroupData in pairs ( SetSochCAP:GetSet() ) do
				local CAPGroup = CAPGroupData
				CAPGroupData:OptionROEWeaponFree()
			end
		end
	end

end
mist.addEventHandler(ActivateSochCAP)

local function SpawnNewGroup( Template )
   Spawn_Plane = Template:Spawn()
end

local function ReSpawnGroup( Template )
   Spawn_Plane = Template:ReSpawn(1)
end

local function ReSpawnGroupInZone( Template, Zone )
	Spawn_Group = Template:SpawnInZone(Zone, 1)
end




local function CleanSAM()
	SetSAMGroup:ForEachGroupNotInZone( Zone_Template,
  --- @param Group#GROUP MooseGroup
		function( MooseGroup )
			DCSGroup = MooseGroup:GetDCSObject()
			if DCSGroup:isExist() then
				MESSAGE:New(MooseGroup.GroupName, 5):ToBlue()
				MooseGroup:Destroy()
			end
		end
	)
end



Spawn_Red_CSAR = SPAWN:New ("Template_RED_CSAR")
ZONE_Red_CSAR_1 = ZONE:New("Fight_Zone")
CSAR_1 = CSAR_HANDLER:New( ZONE_Red_CSAR_1, { Spawn_Red_CSAR, } )
MenuCoalitionBlue = MENU_COALITION:New( coalition.side.BLUE, "Coalition")
MenuSpawnPlane = MENU_COALITION:New( coalition.side.BLUE, "Spawn Ennemy Plane", MenuCoalitionBlue )
MenuSpawnPlaneM29_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 Mig29", MenuSpawnPlane, SpawnNewGroup, Spawn_M29_1 )
MenuSpawnPlaneM29_2 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 2 Mig29", MenuSpawnPlane, SpawnNewGroup, Spawn_M29_2 )
MenuSpawnPlaneM23_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 Mig23", MenuSpawnPlane, SpawnNewGroup, Spawn_M23_1 )
MenuSpawnPlaneM23_2 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 2 Mig23", MenuSpawnPlane, SpawnNewGroup, Spawn_M23_2 )
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
MenuSpawnPlaneSu25T = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Su25T", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_Gud_Su25T )
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

MenuSpawnTanker = MENU_COALITION:New( coalition.side.BLUE, "Spawn Tanker", MenuCoalitionBlue )
MenuSpawnPlaneTankerM2K = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Tanker M2K", MenuSpawnTanker, ReSpawnGroup, Spawn_Tanker_M2K )
MenuSpawnPlaneTankerOther = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Tanker KC135", MenuSpawnTanker, ReSpawnGroup, Spawn_Tanker_Other )

MenuSpawnDogfight = MENU_COALITION:New( coalition.side.BLUE, "Dogfight")
MenuSpawnDogM21 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Mig21", MenuSpawnDogfight, SpawnNewGroup, Spawn_Dog_Mig21 )
MenuSpawnDogM29A = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Mig29A", MenuSpawnDogfight, SpawnNewGroup, Spawn_Dog_Mig29A )
MenuSpawnDogM29S = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Mig29S", MenuSpawnDogfight, SpawnNewGroup, Spawn_Dog_Mig29S )
MenuSpawnDogSu27 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Su27", MenuSpawnDogfight, SpawnNewGroup, Spawn_Dog_Su27 )
MenuSpawnDogMirage = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Mirage", MenuSpawnDogfight, SpawnNewGroup, Spawn_Dog_Mirage )


MenuSpawnRUS = MENU_COALITION:New( coalition.side.RED, "Spawn Assets" )
MenuSpawnEWR = MENU_COALITION_COMMAND:New( coalition.side.RED, "Spawn GCI", MenuSpawnRUS, ReSpawnGroupInZone, Spawn_EWR_1, Zone_EWR )

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

Warzone = BASE:New()
Warzone.ClassName = "MAIN_WARZONE"
Warzone.red = {}
Warzone.blue = {}


Warzone.red.Templates = {}
Warzone.blue.Templates = {}
for groupName, groupData in pairs( SetRedObj.Set ) do
  Warzone.red.Templates[#Warzone.red.Templates + 1] = groupName
end
for groupName, groupData in pairs( SetBlueObj.Set ) do
  Warzone.blue.Templates[#Warzone.blue.Templates + 1] = groupName
end

Warzone.red.DefSpawn = SPAWN:New(Warzone.red.Templates[1]):InitRandomizeTemplate(Warzone.red.Templates):InitRandomizeUnits(true, 300, 100)
Warzone.blue.DefSpawn = SPAWN:New(Warzone.blue.Templates[1]):InitRandomizeTemplate(Warzone.blue.Templates):InitRandomizeUnits(true, 300, 100)

-- Definition of North Combat Zone ( Ambrolauri )
Warzone.North = {}
Warzone.North.red = {}
Warzone.North.blue = {}
Warzone.North.blue.GroundFreq = 131
Warzone.North.blue.Transmitter = GROUP:FindByName("RADIO_N")
Warzone:E(Warzone.North.blue.Transmitter)
--Warzone.North.blue.Radio = RADIO:New(SpawnGroup)
Warzone.North.blue.Radio = Warzone.North.blue.Transmitter:GetRadio()
Warzone:E(Warzone.North.blue.Radio)
Warzone.North.blue.Radio:SetFileName("beaconsilent.ogg")
Warzone.North.blue.Radio:SetFrequency(Warzone.North.blue.GroundFreq)
Warzone.North.blue.Radio:SetModulation(radio.modulation.AM)
-- Warzone.North.blue.Radio:SetPower(20)
Warzone.North.blue.Radio:SetLoop(false)
Warzone:E(Warzone.North.blue.Radio)
-- Warzone.North.blue.Radio:SetSubtitle("", 0 )
Warzone.North.red.OffGroup = SPAWN:New("GROUP_DYN_R_N"):InitRandomizeTemplate(Warzone.red.Templates):InitLimit(12, 0)
Warzone.North.blue.OffGroup = SPAWN:New("GROUP_DYN_B_N"):InitRandomizeTemplate(Warzone.blue.Templates):InitLimit(12, 0)
Warzone.North.blue.OffSet = SET_GROUP:New()
Warzone.North.red.SpawnZone = ZONE_GROUP:New("North_Red_Spawn", GROUP:FindByName("GROUP_DYN_R_N"), 500)
Warzone.North.blue.SpawnZone = ZONE_GROUP:New("North_Blue_Spawn", GROUP:FindByName("GROUP_DYN_B_N"), 500)
Warzone.North.red.CAS = SPAWN:New("Template_RU_Heli_CAS_N"):InitCleanUp( 60 )
Warzone.North.blue.CAS = SPAWN:New("Template_US_Heli_CAS_N"):InitCleanUp( 60 )

Warzone.North.ZoneSet = SET_GROUP:New():FilterPrefixes( "ZONE_CAPTURE_N" ):FilterOnce()
Warzone.North.RedIndex = 2
Warzone.North.Zones = {}
Warzone.North.ZoneCaptureCoalition = {}
Warzone:E( "WARZONE_NORTH_SET IS :  " .. routines.utils.oneLineSerialize(Warzone.North.ZoneSet.Set) )

function AskReport(Zone)
	local Report = ListReports(Warzone[Zone].blue.OffSet)
--	Warzone[Zone].blue.Radio:SetSubtitle( Report, 30 )
--	Warzone[Zone].blue.Radio:Broadcast()
	Warzone[Zone].blue.Radio:NewUnitTransmission("beaconsilent.ogg", Report, 30, Warzone[Zone].blue.GroundFreq, radio.modulation.AM, false):Broadcast()
	Warzone:E("COMM USAGE ON " .. Warzone[Zone].blue.GroundFreq .. " MHz : " .. Report)
end

function RadioCheck(Zone)
	local Report = "This is " .. Zone .. " Ground control, check in."
--	Warzone[Zone].blue.Radio:SetSubtitle( Report, 30 )
--	Warzone[Zone].blue.Radio:Broadcast()
	Warzone[Zone].blue.Radio:NewUnitTransmission("beaconsilent.ogg", Report, 30, Warzone[Zone].blue.GroundFreq, radio.modulation.AM, false):Broadcast()
	Warzone:E(Report)
end

MenuWarzone = MENU_COALITION:New( coalition.side.BLUE, "Ground Operations")
MenuAskNorth = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "North Zone radio check", MenuWarzone, RadioCheck, "North" )
MenuAskNorth = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "North Zone Report", MenuWarzone, AskReport, "North" )


for groupName, groupData in pairs( Warzone.North.ZoneSet.Set ) do
	local tmpSub = string.gsub(groupName, "ZONE_CAPTURE_N_", "")
	local splitSub = csplit(tmpSub, "_")
	local radius = tonumber(splitSub[3])
	local name = splitSub[2]
	Warzone:E( "Creating Warzone in " .. name )
	local id = tonumber(splitSub[1])
	Warzone.North.Zones[id] = ZONE_GROUP:New(name .. "_Zone", groupData, radius)
	Warzone.North.ZoneCaptureCoalition[id] = {}
	if id <= Warzone.North.RedIndex then
		Warzone.North.ZoneCaptureCoalition[id].zcc = ZONE_CAPTURE_COALITION:New( Warzone.North.Zones[id] , coalition.side.RED )
		else
		Warzone.North.ZoneCaptureCoalition[id].zcc = ZONE_CAPTURE_COALITION:New( Warzone.North.Zones[id] , coalition.side.BLUE )
	end
	Warzone.North.ZoneCaptureCoalition[id].zcc.OnEnterEmpty = function ( self, From, Event, To )
		if From == "Guarded" then
			local tutu = ""
		else
			local Coalition = self:GetCoalition()
			local ZoneName = self:GetZoneName()
			if Coalition == coalition.side.RED then
				Warzone.red.DefSpawn:SpawnInZone( self.Zone, true )
			end
			if Coalition == coalition.side.BLUE then
				Warzone.blue.DefSpawn:SpawnInZone( self.Zone, true )
			end
		end
	end
	Warzone.North.ZoneCaptureCoalition[id].zcc:Mark()
	Warzone.North.ZoneCaptureCoalition[id].zcc:Start( 5, 60 )
	
	Warzone.North.ZoneCaptureCoalition[id].zcc.OnEnterCaptured = function ( self )
		local Coalition = self:GetCoalition()
		if Coalition == coalition.side.RED then
			Warzone.North.RedIndex = Warzone.North.RedIndex + 1
			local reinforcement = Warzone.North.red.OffGroup:Spawn()
			reinforcement:TaskRouteToZone( Warzone.North.Zones[Warzone.North.RedIndex], false, 15, "On Road" )
		end
		if Coalition == coalition.side.BLUE then
			Warzone.North.RedIndex = Warzone.North.RedIndex - 1
			local reinforcement = Warzone.North.blue.OffGroup:Spawn()
			reinforcement:TaskRouteToZone( Warzone.North.Zones[Warzone.North.RedIndex + 1], false, 15, "On Road" )
		end
	end

	Warzone.North.ZoneCaptureCoalition[id].zcc.OnEnterAttacked = function ( self )
		local Coalition = self:GetCoalition()
		local AttackCoord = self.Zone:GetRandomCoordinate()
		if Coalition == coalition.side.RED then
			HeliGroup = Warzone.North.red.CAS:Spawn()
		end
		if Coalition == coalition.side.BLUE then
			HeliGroup = Warzone.North.blue.CAS:Spawn()
		end
		local HeliCoord = HeliGroup:GetCoordinate()
		local CurrentWaypoint = HeliCoord:WaypointAirTurningPoint( COORDINATE.WaypointAltType.RADIO, 110 )
		local ToWaypoint = AttackCoord:WaypointAirTurningPoint( COORDINATE.WaypointAltType.RADIO, 110 )
		HeliGroup:Route( { CurrentWaypoint , ToWaypoint }, 1 )
--		HeliGroup:TaskRouteToZone( self.Zone, true, 120, "Vee" )
		HeliGroup:OptionROEWeaponFree()
	end
end

Warzone.North.blue.OffGroup:OnSpawnGroup(
		function (SpawnGroup)
			SpawnGroup.Frequency = (2600 + math.random(200)) * 100000
			local Command = { 
							id = 'SetFrequency', 
							params = { 
								frequency = SpawnGroup.Frequency, 
								modulation = radio.modulation.AM, 
							} 
						}
--			SpawnGroup:SetCommand( Command )
			local Callsign = math.random(19)
			local Id = math.random(5)
			SpawnGroup.Callsign = CallSigns[Callsign] .. " " .. Id
			Command = { 
							id = 'SetCallsign', 
							params = { 
								callname = Callsign, 
								number = Id, 
							} 
						}
--			SpawnGroup:SetCommand( Command )
			SpawnGroup.Engaged = false
			SpawnGroup.LastTransmission = 11
			SpawnGroup:TaskRouteToZone( Warzone.North.Zones[Warzone.North.RedIndex], false, 15, "On Road" )
			SpawnGroup.TargetZone = Warzone.North.Zones[Warzone.North.RedIndex]
			SpawnGroup.Radio = Warzone.North.blue.Transmitter:GetRadio()
			SpawnGroup.Radio:SetFileName("beaconsilent.ogg")
			SpawnGroup.Radio:SetFrequency(SpawnGroup.Frequency / 1000000)
			SpawnGroup.Radio:SetModulation(radio.modulation.AM)
			SpawnGroup.Radio:SetPower(20)
			SpawnGroup.Radio:SetLoop(false)
			SpawnGroup.Radio:SetSubtitle("", 0 )
			SpawnGroup.LocalSet = SET_GROUP:New():AddGroupsByName(SpawnGroup.GroupName)
			Warzone.North.blue.OffSet:AddGroupsByName(SpawnGroup.GroupName)
			SpawnGroup.Detection = DETECTION_AREAS:New(SpawnGroup.LocalSet, 500)
			SpawnGroup.Detection:SetAcceptRange( 5000 )
			SpawnGroup.Detection:InitDetectVisual( true )
			SpawnGroup.Detection:InitDetectOptical( true )
			SpawnGroup.Detection.LocalGroup = SpawnGroup.GroupName
			SpawnGroup.Detection:Start()
			SpawnGroup.Detection.OnAfterDetect = function (self, From, Event, To)
				local Count = 0
				local SpawnGroup = GROUP:FindByName(self.LocalGroup)
				for Index, Value in pairs( self.DetectedObjects ) do
					Count = Count + 1
				end
				if Count > 0 then 
					if SpawnGroup.Engaged == false then 
						SpawnGroup.Engaged = true
						local StopZone = ZONE_GROUP:New("Stop_Zone_" .. SpawnGroup.GroupName, SpawnGroup, 300)
						SpawnGroup:TaskRouteToZone( StopZone, true, 25, "Vee" )
						SpawnGroup:EnRouteTaskFAC( 5000, 5)
					end
					if SpawnGroup.LastTransmission > 4 then 
						SpawnGroup.LastTransmission = -1
						Warzone:E( "DETECTED GROUP COMPOSITION IS :  " .. routines.utils.oneLineSerialize(self.DetectedItems) )
						local DetectionReport = GenerateReport(self.DetectedItems, SpawnGroup.Callsign , SpawnGroup.Frequency / 1000000)
						local Speech = {
							[1] = "this_is",
							[2] = SpawnGroup.RadioName,
							[3] = SpawnGroup.Id,
						}
						for Id, Item in pairs(self.DetectedItems) do
							Speech[#Speech + 1] = "pause"
							Speech[#Speech + 1] = "armored_targets"
							Speech[#Speech + 1] = "at"
							Count = Count + 1
							local Coord = COORDINATE:NewFromVec2(Item.Zone.LastVec2)
							Speech = CoordToSpeech(Speech, Coord)
						end
--						SpawnGroup.Radio:SetSubtitle( DetectionReport, 60 )
--						SpawnGroup.Radio:Broadcast()
--						SpawnGroup.Radio:NewUnitTransmission("beaconsilent.ogg", DetectionReport, 30, SpawnGroup.Frequency / 1000000, radio.modulation.AM, false):Broadcast()
						RadioSpeech(SpawnGroup, Speech)
					end
					SpawnGroup.LastTransmission = SpawnGroup.LastTransmission + 1
				end
				if ( ( Count == 0 ) and ( SpawnGroup.Engaged == true ) ) then
					SpawnGroup.Engaged = false
					SpawnGroup:TaskRouteToZone( Warzone.North.Zones[Warzone.North.RedIndex], false, 15, "On Road" )
				end
			end
		end
	)
Warzone.North.blue.OffGroup:SpawnScheduled( 2400 , 0.4 )

Warzone.North.red.OffGroup:OnSpawnGroup(
		function (SpawnGroup)
			SpawnGroup:TaskRouteToZone( Warzone.North.Zones[Warzone.North.RedIndex + 1], false, 15, "On Road" )
			SpawnGroup.TargetZone = Warzone.North.Zones[Warzone.North.RedIndex]
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
					SpawnGroup:TaskRouteToZone( Warzone.North.Zones[Warzone.North.RedIndex + 1], false, 15, "On Road" )
				end
			end
		end
	)
Warzone.North.red.OffGroup:SpawnScheduled( 2400 , 0.4 )


Warzone.Center = {}
Warzone.Center.red = {}
Warzone.Center.blue = {}
Warzone.Center.blue.GroundFreq = 137
Warzone.Center.blue.Transmitter = GROUP:FindByName("RADIO_C")
--Warzone.Center.blue.Radio = RADIO:New(SpawnGroup)
Warzone.Center.blue.Radio = Warzone.Center.blue.Transmitter:GetRadio()
Warzone.Center.blue.Radio:SetFileName("beaconsilent.ogg")
Warzone.Center.blue.Radio:SetFrequency(Warzone.Center.blue.GroundFreq)
Warzone.Center.blue.Radio:SetModulation(radio.modulation.AM)
Warzone.Center.blue.Radio:SetPower(20)
Warzone.Center.blue.Radio:SetLoop(false)
Warzone.Center.blue.Radio:SetSubtitle("", 0 )
Warzone.Center.red.OffGroup = SPAWN:New("GROUP_DYN_R_C"):InitRandomizeTemplate(Warzone.red.Templates):InitLimit(12, 0)
Warzone.Center.blue.OffGroup = SPAWN:New("GROUP_DYN_B_C"):InitRandomizeTemplate(Warzone.blue.Templates):InitLimit(12, 0)
Warzone.Center.blue.OffSet = SET_GROUP:New()
Warzone.Center.red.SpawnZone = ZONE_GROUP:New("Center_Red_Spawn", GROUP:FindByName("GROUP_DYN_R_C"), 500)
Warzone.Center.blue.SpawnZone = ZONE_GROUP:New("Center_Blue_Spawn", GROUP:FindByName("GROUP_DYN_B_C"), 500)
Warzone.Center.red.CAS = SPAWN:New("Template_RU_Heli_CAS_C"):InitCleanUp( 60 )
Warzone.Center.blue.CAS = SPAWN:New("Template_US_Heli_CAS_C"):InitCleanUp( 60 )

Warzone.Center.ZoneSet = SET_GROUP:New():FilterPrefixes( "ZONE_CAPTURE_C" ):FilterOnce()
Warzone.Center.RedIndex = 3
Warzone.Center.Zones = {}
Warzone.Center.ZoneCaptureCoalition = {}


for groupName, groupData in pairs( Warzone.Center.ZoneSet.Set ) do
	local tmpSub = string.gsub(groupName, "ZONE_CAPTURE_C_", "")
	local splitSub = csplit(tmpSub, "_")
	local radius = tonumber(splitSub[3])
	local name = splitSub[2]
	Warzone:E( "Creating Warzone in " .. name )
	local id = tonumber(splitSub[1])
	Warzone.Center.Zones[id] = ZONE_GROUP:New(name .. "_Zone", groupData, radius)
	Warzone.Center.ZoneCaptureCoalition[id] = {}
	if id <= Warzone.Center.RedIndex then
		Warzone.Center.ZoneCaptureCoalition[id].zcc = ZONE_CAPTURE_COALITION:New( Warzone.Center.Zones[id] , coalition.side.RED )
		else
		Warzone.Center.ZoneCaptureCoalition[id].zcc = ZONE_CAPTURE_COALITION:New( Warzone.Center.Zones[id] , coalition.side.BLUE )
	end
	Warzone.Center.ZoneCaptureCoalition[id].zcc.OnEnterEmpty = function ( self, From, Event, To )
		if From == "Guarded" then
			local tutu = ""
		else
			local Coalition = self:GetCoalition()
			local ZoneName = self:GetZoneName()
			if Coalition == coalition.side.RED then
				Warzone.red.DefSpawn:SpawnInZone( self.Zone, true )
			end
			if Coalition == coalition.side.BLUE then
				Warzone.blue.DefSpawn:SpawnInZone( self.Zone, true )
			end
		end
	end
	Warzone.Center.ZoneCaptureCoalition[id].zcc:Mark()
	Warzone.Center.ZoneCaptureCoalition[id].zcc:Start( 5, 60 )
	
	Warzone.Center.ZoneCaptureCoalition[id].zcc.OnEnterCaptured = function ( self )
		local Coalition = self:GetCoalition()
		if Coalition == coalition.side.RED then
			Warzone.Center.RedIndex = Warzone.Center.RedIndex + 1
			local reinforcement = Warzone.Center.red.OffGroup:Spawn()
			reinforcement:TaskRouteToZone( Warzone.Center.Zones[Warzone.Center.RedIndex], false, 15, "On Road" )
		end
		if Coalition == coalition.side.BLUE then
			Warzone.Center.RedIndex = Warzone.Center.RedIndex - 1
			local reinforcement = Warzone.Center.blue.OffGroup:Spawn()
			reinforcement:TaskRouteToZone( Warzone.Center.Zones[Warzone.Center.RedIndex + 1], false, 15, "On Road" )
		end
	end

	Warzone.Center.ZoneCaptureCoalition[id].zcc.OnEnterAttacked = function ( self )
		local Coalition = self:GetCoalition()
		local AttackCoord = self.Zone:GetRandomCoordinate()
		if Coalition == coalition.side.RED then
			HeliGroup = Warzone.Center.red.CAS:Spawn()
		end
		if Coalition == coalition.side.BLUE then
			HeliGroup = Warzone.Center.blue.CAS:Spawn()
		end
		local HeliCoord = HeliGroup:GetCoordinate()
		local CurrentWaypoint = HeliCoord:WaypointAirTurningPoint( COORDINATE.WaypointAltType.RADIO, 110 )
		local ToWaypoint = AttackCoord:WaypointAirTurningPoint( COORDINATE.WaypointAltType.RADIO, 110 )
		HeliGroup:Route( { CurrentWaypoint , ToWaypoint }, 1 )
--		HeliGroup:TaskRouteToZone( self.Zone, true, 120, "Vee" )
		HeliGroup:OptionROEWeaponFree()
	end
end

Warzone.Center.blue.OffGroup:OnSpawnGroup(
		function (SpawnGroup)
			SpawnGroup.Frequency = (2800 + math.random(200)) * 100000
			local Command = { 
							id = 'SetFrequency', 
							params = { 
								frequency = SpawnGroup.Frequency, 
								modulation = radio.modulation.AM, 
							} 
						}
			SpawnGroup:SetCommand( Command )
			local Callsign = math.random(19)
			local Id = math.random(5)
			SpawnGroup.Id = tostring(Id)
			SpawnGroup.RadioName = CallSigns[Callsign]
			SpawnGroup.Callsign = CallSigns[Callsign] .. " " .. Id
			Command = { 
							id = 'SetCallsign', 
							params = { 
								callname = Callsign, 
								number = Id, 
							} 
						}
			SpawnGroup:SetCommand( Command )
			SpawnGroup.Engaged = false
			SpawnGroup.LastTransmission = 11
			SpawnGroup:TaskRouteToZone( Warzone.Center.Zones[Warzone.Center.RedIndex], false, 15, "On Road" )
			SpawnGroup.TargetZone = Warzone.Center.Zones[Warzone.Center.RedIndex]
			SpawnGroup.Radio = Warzone.Center.blue.Transmitter:GetRadio()
			SpawnGroup.Radio:SetFileName("beaconsilent.ogg")
			SpawnGroup.Radio:SetFrequency(SpawnGroup.Frequency / 1000000)
			SpawnGroup.Radio:SetModulation(radio.modulation.AM)
			SpawnGroup.Radio:SetPower(20)
			SpawnGroup.Radio:SetLoop(false)
			SpawnGroup.Radio:SetSubtitle("", 0 )
			SpawnGroup.LocalSet = SET_GROUP:New():AddGroupsByName(SpawnGroup.GroupName)
			Warzone.Center.blue.OffSet:AddGroupsByName(SpawnGroup.GroupName)
			SpawnGroup.Detection = DETECTION_AREAS:New(SpawnGroup.LocalSet, 500)
			SpawnGroup.Detection:SetAcceptRange( 5000 )
			SpawnGroup.Detection:InitDetectVisual( true )
			SpawnGroup.Detection:InitDetectOptical( true )
			SpawnGroup.Detection.LocalGroup = SpawnGroup.GroupName
			SpawnGroup.Detection:Start()
			SpawnGroup.Detection.OnAfterDetect = function (self, From, Event, To)
				local Count = 0
				local SpawnGroup = GROUP:FindByName(self.LocalGroup)
				for Index, Value in pairs( self.DetectedObjects ) do
					Count = Count + 1
				end
				if Count > 0 then 
					if SpawnGroup.Engaged == false then 
						SpawnGroup.Engaged = true
						local StopZone = ZONE_GROUP:New("Stop_Zone_" .. SpawnGroup.GroupName, SpawnGroup, 300)
						SpawnGroup:TaskRouteToZone( StopZone, true, 25, "Vee" )
						SpawnGroup:EnRouteTaskFAC( 5000, 5)
					end
					if SpawnGroup.LastTransmission > 4 then 
						SpawnGroup.LastTransmission = -1
						Warzone:E( "DETECTED GROUP COMPOSITION IS :  " .. routines.utils.oneLineSerialize(self.DetectedItems) )
						local DetectionReport = GenerateReport(self.DetectedItems, SpawnGroup.Callsign , SpawnGroup.Frequency / 1000000)
						local Speech = {
							[1] = "this_is",
							[2] = SpawnGroup.RadioName,
							[3] = SpawnGroup.Id,
						}
						for Id, Item in pairs(self.DetectedItems) do
							Speech[#Speech + 1] = "pause"
							Speech[#Speech + 1] = "armored_targets"
							Speech[#Speech + 1] = "at"
							Count = Count + 1
							local Coord = COORDINATE:NewFromVec2(Item.Zone.LastVec2)
							Speech = CoordToSpeech(Speech, Coord)
						end
--						SpawnGroup.Radio:SetSubtitle( DetectionReport, 60 )
--						SpawnGroup.Radio:Broadcast()
--						SpawnGroup.Radio:NewUnitTransmission("beaconsilent.ogg", DetectionReport, 30, SpawnGroup.Frequency / 1000000, radio.modulation.AM, false):Broadcast()
						RadioSpeech(SpawnGroup, Speech)
					end
					SpawnGroup.LastTransmission = SpawnGroup.LastTransmission + 1
				end
				if ( ( Count == 0 ) and ( SpawnGroup.Engaged == true ) ) then
					SpawnGroup.Engaged = false
					SpawnGroup:TaskRouteToZone( Warzone.Center.Zones[Warzone.Center.RedIndex], false, 15, "On Road" )
				end
			end
		end
	)
Warzone.Center.blue.OffGroup:SpawnScheduled( 2400 , 0.4 )

Warzone.Center.red.OffGroup:OnSpawnGroup(
		function (SpawnGroup)
			SpawnGroup:TaskRouteToZone( Warzone.Center.Zones[Warzone.Center.RedIndex + 1], false, 15, "On Road" )
			SpawnGroup.TargetZone = Warzone.Center.Zones[Warzone.Center.RedIndex]
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
					SpawnGroup:TaskRouteToZone( Warzone.Center.Zones[Warzone.Center.RedIndex + 1], false, 15, "On Road" )
				end
			end
		end
	)
Warzone.Center.red.OffGroup:SpawnScheduled( 2400 , 0.4 )

MenuAskCenter = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Center Zone radio check", MenuWarzone, RadioCheck, "Center" )
MenuAskCenter = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Center Zone Report", MenuWarzone, AskReport, "Center" )



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
		BASE:E( "Next speech delay is : " .. Delay)
	end
end

do
-- validate functions with a dummy unit broadcasting shit every 60s on 136MHz
	local RadioGroup = GROUP:FindByName("TEST_RADIO")
	RadioGroup.Radio = RadioGroup:GetRadio()
	RadioGroup.Frequency = 136000000

	local SpeechTest = {
		[1] = "this_is",
		[2] = "Axeman",
		[3] = "3",
		[4] = "pause",
		[5] = "armored_targets",
		[6] = "at",
	}
	local SpeechTest = CoordToSpeech(SpeechTest, COORDINATE:NewFromVec2(RadioGroup:GetVec2()))
	SCHEDULER:New( nil, 
		function()
			RadioSpeech(RadioGroup, SpeechTest)
		end, {}, 5, 60
	)	
end