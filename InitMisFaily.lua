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

WWII_Blue_CC = COMMANDCENTER:New( STATIC:FindByName( "WWII_BLUE_CC" ), "MinVody Ground Control" )

-- WWII_Blue_Mission_CAP = MISSION:New( WWII_Blue_CC, "CAP MinVody area", "Primary", "Patrol Friendly airspace", "Blue" )

-- TestTargetSet = SET_UNIT:New():FilterPrefixes( "TEST_TASK_INTERCEPT" ):FilterStart()

-- WWII_Blue_Task_CAP = TASK_INTERCEPT:New( WWII_Blue_Mission_CAP, SetGroupClientWWII, "CAP", TestTargetSet )


-- WWII_Blue_Mission_CAP:AddTask( WWII_Blue_Task_CAP )

-- Spawn_WWII.Red.CAP.Spawn = SPAWN:New( Spawn_WWII.Red.CAP.Set[1] )


Kobu_CC = COMMANDCENTER:New( STATIC:FindByName( "CC_KOBU" ), "Senaki Ground Control" )
-- Kobu_CAP_MISSION = MISSION:New ( WWII_Blue_CC, "CAP Kobuleti area", "Primary", "Intercept ennemies", "Blue" )
SetGroupKobu = SET_GROUP:New():FilterPrefixes( "41.MinVody Blue" ):FilterStart()

SetZoneObj = SET_GROUP:New():FilterPrefixes( "ZONE_OBJ" ):FilterStart()
SetZoneObj:E("Zone Set Defined :" .. routines.utils.oneLineSerialize(SetZoneObj.Set) )

SpawnBlueFAC = SPAWN:New( "Template_Blue_FAC" ):InitRandomizeUnits(true, 3000, 2000)
ListZoneObj = {}

for groupName, groupData in pairs( SetZoneObj.Set ) do
  BASE:E("1st Sub is " .. (string.gsub(groupName, "ZONE_OBJ_", "")))
  local tmpSub = string.gsub(groupName, "ZONE_OBJ_", "")
  BASE:E("2nd Sub is " .. (string.gsub(tmpSub, "%D", "")))
  local radius = tonumber( string.gsub(tmpSub, "%D", "") )
  
  local name = string.gsub(tmpSub, "%A", "")

  ListZoneObj[#ListZoneObj + 1] = ZONE_GROUP:New( name, groupData, radius )

end

SetRedObj = SET_GROUP:New():FilterPrefixes( "Template_RED_OBJ" ):FilterOnce()
SetRedObj:E("Group Set Defined :" .. routines.utils.oneLineSerialize(SetRedObj) )
ListSpawnRedObj = {}
for groupName, groupData in pairs( SetRedObj.Set ) do
  ListSpawnRedObj[#ListSpawnRedObj + 1] = SPAWN:New( groupName ):InitRandomizeUnits(true, 300, 100)
end

SetAllBlue = SET_GROUP:New():FilterCoalitions( "blue" )

RndGrdObj = {}

RndMission = MISSION:New(Kobu_CC, "Attaque au sol", "Primary", "Support A2G Zone Nord Ouest" , "Blue" )
FACSet = SET_GROUP:New():FilterPrefixes( "Template_Blue_FAC" ):FilterStart()
FACAreas = DETECTION_AREAS:New( FACSet, 5000, 1000 )
FACAreas:BoundDetectedZones()
AttackGroups = SET_GROUP:New():FilterPrefixes( "8.Ka50" ):FilterStart()
TaskDispatcher = TASK_A2G_DISPATCHER:New( RndMission, Kobu_CC, AttackGroups, FACAreas )
function RandomGroundObj()
  RndGrdObj[#RndGrdObj + 1] = {}
  RndGrdObj[#RndGrdObj].SetAGTargets = SET_UNIT:New()
  local rndZone = math.random(1, #ListZoneObj)
  local rndGroup = math.random(1, #ListSpawnRedObj)
  local newZone = ListZoneObj[ rndZone ]
  local ZoneName = newZone:GetName()
  local newSpawn = ListSpawnRedObj[ rndGroup ]
  local newGroup = newSpawn:SpawnInZone( newZone, true )
  RndGrdObj[#RndGrdObj].FAC = SpawnBlueFAC:SpawnFromUnit(newGroup:GetUnit( 1 ))
end

function ClearGroundObj()
  for _, objData in pairs(RndGrdObj) do
    local tmpSet = objData.SetAGTargets.Set
    for _, unitData in pairs( tmpSet ) do
      unitData:Destroy()
    end
    objData.FAC:Destroy()
    -- RndGrdObj[#RndGrdObj].AGMission:ClearMissionMenu()
    -- RndGrdObj[#RndGrdObj].AGMission = nil
    -- RndGrdObj[#RndGrdObj].AGTask = nil
  end
end

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
Spawn_Blue_bf109 = SPAWN:New("Template blue Bf109")
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

Zone_Achig = ZONE:New("Achigvara")

Sukh_CAP_Zone = ZONE:New('Sukh_Patrol')

-- Sukh_PATROL_ZONE = AI_CAP_ZONE:New( Sukh_CAP_Zone, 3000, 6000, 500, 800 )

Sukh_CAP_list = { 'Template CAP Soch 1', 'Template CAP Soch 2', 'Template CAP Soch 3', 'Template CAP Soch 4', 'Template CAP Soch 5' }

Sukh_CAP_Spawn = SPAWN
	:New('Template CAP Soch 1')
	:InitRandomizeTemplate( Sukh_CAP_list )
	:InitCleanUp( 120 )
	:OnSpawnGroup( 
		function (SpawnGroup)
			SpawnGroup.PatrolZone = AI_CAP_ZONE:New( Sukh_CAP_Zone, 5000, 8000, 500, 800 )
			SpawnGroup.PatrolZone:SetControllable( SpawnGroup )
			SpawnGroup.PatrolZone:ManageFuel( 0.3 , 600 )
			SpawnGroup.PatrolZone:__Start(5)
		end
	)
--	:SpawnScheduled( 1800 , 0 )

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
WWII_CAP_Spawn = SPAWN
	:New("Template RUS WWII 1")
	:InitRandomizeTemplate( WWII_CAP_list )
	:InitCleanUp( 120 )
	:OnSpawnGroup(
		function (SpawnGroup)
			SpawnGroup.PatrolZone = AI_CAP_ZONE:New( WWII_CAP_Zone, 3800, 5000, 300, 500 )
			SpawnGroup.PatrolZone:SetControllable( SpawnGroup )
			SpawnGroup.PatrolZone:ManageFuel( 0.3 , 600 )
			SpawnGroup.PatrolZone:__Start(5)
--			SpawnGroup:OptionROEWeaponFree()
			env.info("KALBUTH01 : Listing Units in Group :")
			env.info(routines.utils.oneLineSerialize(SpawnGroup:GetUnits()))
			SpawnGroup.TargetSet = SET_UNIT:New()
			local DCSGroup = Group.getByName( SpawnGroup.GroupName )
			for unitID, unitData in pairs(DCSGroup:getUnits()) do
				env.info("KALBUTH02 : Adding unit to Target Set")
				env.info(routines.utils.oneLineSerialize(_DATABASE.UNITS[unitData:getName()]))
				_DATABASE:AddUnit( unitData:getName() )
				env.info(routines.utils.oneLineSerialize(_DATABASE.UNITS[unitData:getName()]))
				local MooseUnit = UNIT:Find( unitData )
				env.info(routines.utils.oneLineSerialize(unitData))
				env.info(routines.utils.oneLineSerialize(unitData:getName()))
				env.info(routines.utils.oneLineSerialize(MooseUnit))
				SpawnGroup.TargetSet:AddUnit( MooseUnit )
			end
			Kobu_Missions[#Kobu_Missions + 1] = {}
			local missionName = "CAP MinVody area (" .. #Kobu_Missions ..")"
			local taskName = "Intercept (" .. #Kobu_Missions .. ")"
			Kobu_Missions[#Kobu_Missions].Mission = MISSION:New ( WWII_Blue_CC, missionName, "Primary", "Intercept ennemies", "Blue" )
			Kobu_Missions[#Kobu_Missions].Task = TASK_INTERCEPT:New( Kobu_Missions[#Kobu_Missions].Mission, SetGroupKobu, taskName, SpawnGroup.TargetSet ):SetTimeOut( 1800 )
			Kobu_Missions[#Kobu_Missions].Mission:AddTask( Kobu_Missions[#Kobu_Missions].Task )
		end
	)
--	:SpawnScheduled( 1800 , 0 )
-- 	:SpawnScheduled( 120 , 0 )

Circus_RED_SPAWN = SPAWN
	:New( "Template RUS Circus" )
	:InitCleanUp ( 120 )
	:OnSpawnGroup(
		function (SpawnGroup)
			SpawnGroup.PatrolZone = AI_CAP_ZONE:New( WWII_Circus_Zone, 2500, 5000, 300, 500 )
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
			SpawnGroup.PatrolZone = AI_CAP_ZONE:New( WWII_Circus_Zone, 2500, 5000, 300, 500 )
			SpawnGroup.PatrolZone:SetControllable( SpawnGroup )
			SpawnGroup.PatrolZone:ManageFuel( 0.2 , 600 )
			SpawnGroup.PatrolZone:__Start(5)
		end
	)
Circus_Sched = {}
Circus_GroupList = {}

function StartCircus(  )
	for i = 0, 7 do
--		Circus_Sched[#Circus_Sched + 1] = SCHEDULER:New( Circus_RED_SPAWN,
--			function ( Object, Timer )
--				Object:Spawn()
--			end, { i }, 1 + ( i * 10 )
--		)
--		Circus_Sched[#Circus_Sched + 1] = SCHEDULER:New( Circus_BLUE_SPAWN,
--			function ( Object, Timer )
--				Object:Spawn()
--			end, { i }, 1 + ( i * 10 )
--		)
		Circus_GroupList[ #Circus_GroupList + 1 ] = Circus_RED_SPAWN:Spawn()
		Circus_GroupList[ #Circus_GroupList + 1 ] = Circus_BLUE_SPAWN:Spawn()
	end
  local FollowGroupSet = SET_GROUP:New():FilterCategories("plane"):FilterCoalitions("blue"):FilterPrefixes("Template BLUE Circus"):FilterStart()

  FollowGroupSet:Flush()

  local LeaderUnit = Circus_GroupList[1]:GetUnit(1)

  local LargeFormation = AI_FORMATION:New( LeaderUnit, FollowGroupSet, "Large Formation", "Briefing" ):TestSmokeDirectionVector(false)

  LargeFormation:__Start( 1 )
end

	
SetMirageClients = SET_CLIENT:New():FilterPrefixes("Pilot M2000C"):FilterStart()

-- Sukh_Balancer = AI_BALANCER:New( SetMirageClients, Sukh_CAP_Spawn )
-- Sukh_Balancer:ReturnToHomeAirbase( 20000 )

-- Sukh_CAP = Sukh_CAP_Spawn:Spawn()

 

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
-- Zone_prise_Kutaisi
CSAR_Kutaisi = {"Template_RED_CSAR", "Template_RED_CSAR #001"}
Spawn_Red_CSAR_Kutaisi = SPAWN:New ("Template_RED_CSAR"):InitRandomizeTemplate( CSAR_Kutaisi )
Zone_Red_CSAR_Kutaisi = ZONE:New("Zone_prise_Kutaisi")
local function SpawnKutaisi(withSAM)
	local Spawn_Kut1 = Spawn_Kuta_1:Spawn()
	local Spawn_Kut2 = Spawn_Kuta_2:Spawn()
	local Spawn_Kut3 = Spawn_Kuta_3:Spawn()
	local Spawn_Kut4 = Spawn_Kuta_4:Spawn()
	local Spawn_Kut5 = Spawn_Kuta_5:Spawn()
	CSAR_Kutaisi = CSAR_HANDLER:New( Zone_Red_CSAR_Kutaisi, { Spawn_Red_CSAR_Kutaisi, } )
	if withSAM then
		local Spawn_KutSAM = Spawn_Kuta_SAM:Spawn()
	end
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

MenuSpawnPlane = MENU_COALITION:New( coalition.side.BLUE, "Spawn Ennemy Plane" )
MenuSpawnPlaneM29_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 Mig29", MenuSpawnPlane, SpawnNewGroup, Spawn_M29_1 )
MenuSpawnPlaneM29_2 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 2 Mig29", MenuSpawnPlane, SpawnNewGroup, Spawn_M29_2 )
MenuSpawnPlaneM23_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 Mig23", MenuSpawnPlane, SpawnNewGroup, Spawn_M23_1 )
MenuSpawnPlaneM23_2 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 2 Mig23", MenuSpawnPlane, SpawnNewGroup, Spawn_M23_2 )
MenuSpawnPlaneOther = MENU_COALITION:New( coalition.side.BLUE, "Other", MenuSpawnPlane)
MenuSpawnPlaneP51 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 P51D", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_P51 )
MenuSpawnPlaneFW190 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 FW-190 D9", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_FW190 )
MenuSpawnPlaneBf109 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 Bf109 K4", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_Bf109 )
MenuSpawnPlaneMig15 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 Mig15Bis", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_Mig15 )
MenuSpawnPlaneF86 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn 1 F86-F", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_F86 )
MenuSpawnCircus = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Un Grand Cirque!", MenuSpawnPlaneOther, StartCircus )
MenuSpawnPlaneMi8 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Mi8", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_Sukh_Mi8 )
MenuSpawnPlaneKa50 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Ka50", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_Sukh_Ka50 )
MenuSpawnPlaneSu25T = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Su25T", MenuSpawnPlaneOther, SpawnNewGroup, Spawn_Gud_Su25T )
MenuSpawnPlaneControl = MENU_COALITION:New( coalition.side.BLUE, "Controle des spawns", MenuSpawnPlane)
MenuSpawnPlaneStopSochi =  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Stopper le spawn auto a Sochi", MenuSpawnPlaneControl, StartSetSpawning, Sukh_CAP_Spawn )
MenuSpawnPlaneStartSochi =  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Demarrer le spawn auto a Sochi", MenuSpawnPlaneControl,  StopSetSpawning, Sukh_CAP_Spawn )
MenuSpawnPlaneClearSochi =  MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Detruire les CAP ennemis en vol", MenuSpawnPlaneControl,  ClearSetGroup, SetSukhCAP )


MenuSpawnGround = MENU_COALITION:New( coalition.side.BLUE, "Spawn Ennemy Ground Target" )
MenuSpawnGGroup1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Armor chemin 1", MenuSpawnGround, SpawnNewGroup, Spawn_Ground_1 )
MenuSpawnGGroup2 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Armor chemin 2", MenuSpawnGround, SpawnNewGroup, Spawn_Ground_2 )
MenuSpawnGGroup4 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Take Kutaisi scenario - no SA19", MenuSpawnGround, SpawnKutaisi, false )
MenuSpawnGGroup5 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Take Kutaisi scenario - w/ SA19", MenuSpawnGround, SpawnKutaisi, true )
MenuSpawnGGroup7 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Random Ground Attack scenario", MenuSpawnGround, RandomGroundObj )
MenuSpawnGroundControl = MENU_COALITION:New( coalition.side.BLUE, "Controle des troupes", MenuSpawnGround)
MenuSpawnGroundClearRnd = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Detruire les troupes des objectifs random", MenuSpawnGroundControl, ClearGroundObj )


MenuSpawnSAM = MENU_COALITION:New( coalition.side.BLUE, "Spawn Ennemy SAM" )
MenuSpawnSA19_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn SAM Position 1", MenuSpawnSAM, ReSpawnGroupInZone, Spawn_SAM_1, Zone_SA19_1 )
MenuSpawnSA19_2 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn SAM Position 2", MenuSpawnSAM, ReSpawnGroupInZone, Spawn_SAM_2, Zone_SA19_2 )
MenuSpawnSA10_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn SAM SA6", MenuSpawnSAM, ReSpawnGroupInZone, Spawn_SAM_5, Zone_KUB )
MenuSpawnSA10_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn SAM SA11", MenuSpawnSAM, ReSpawnGroupInZone, Spawn_SAM_4, Zone_BUK )
MenuSpawnSA10_1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn SAM SA10 Gudauta", MenuSpawnSAM, ReSpawnGroupInZone, Spawn_SAM_3, Zone_SA10 )
MenuSpawnEWR = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn GCI RED", MenuSpawnSAM, ReSpawnGroupInZone, Spawn_EWR_1, Zone_EWR )
MenuCleanSAM = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Destroy all SAMs", MenuSpawnSAM, CleanSAM )

MenuSpawnTanker = MENU_COALITION:New( coalition.side.BLUE, "Spawn Tanker" )
MenuSpawnPlaneTankerM2K = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Tanker M2K", MenuSpawnTanker, ReSpawnGroup, Spawn_Tanker_M2K )
MenuSpawnPlaneTankerOther = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Tanker KC135", MenuSpawnTanker, ReSpawnGroup, Spawn_Tanker_Other )

MenuSpawnFriendly = MENU_COALITION:New( coalition.side.BLUE, "Spawn Friendly Units" )
MenuSpawnFP51 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn blue P51 over Senakhi", MenuSpawnFriendly, SpawnNewGroup, Spawn_Blue_P51 )
MenuSpawnFbf109 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn blue Bf109 over Senakhi", MenuSpawnFriendly, SpawnNewGroup, Spawn_Blue_bf109 )
MenuSpawnFfw190 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn blue FW190 over Senakhi", MenuSpawnFriendly, SpawnNewGroup, Spawn_Blue_fw190 )

MenuSpawnRUS = MENU_COALITION:New( coalition.side.RED, "Spawn Assets" )
MenuSpawnEWR = MENU_COALITION_COMMAND:New( coalition.side.RED, "Spawn GCI", MenuSpawnRUS, ReSpawnGroupInZone, Spawn_EWR_1, Zone_EWR )


function addTroops( )

end
