Zone_SA19_1 = ZONE:New( "SA19-1 Zone" )
Zone_SA19_2 = ZONE:New( "SA19-2 Zone" )
Zone_SA10 = ZONE:New( "SA10_Zone" )
Zone_EWR = ZONE:New( "EWR Zone" )
Zone_BUK = ZONE:New( "SA11 Zone" )
Zone_KUB = ZONE:New( "SA6 Zone" )
Zone_Template = ZONE:New( "Template Zone" )

SetSAMGroup = SET_GROUP:New()
	:FilterPrefixes( "SAM" )
	:FilterStart()

SetSukhGroups = SET_GROUP:New():FilterPrefixes( "Template Sukh"):FilterStart()	
SetSochCAP = SET_GROUP:New():FilterPrefixes( "Template CAP Soch"):FilterStart()	

	
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

Zone_Achig = ZONE:New("Achigvara")

Sukh_CAP_Zone = ZONE:New('Sukh_Patrol')

-- Sukh_PATROL_ZONE = AI_PATROLZONE:New( Sukh_CAP_Zone, 3000, 6000, 500, 800 )

Sukh_CAP_list = { 'Template CAP Soch 1', 'Template CAP Soch 2', 'Template CAP Soch 3', 'Template CAP Soch 4', 'Template CAP Soch 5' }

Sukh_CAP_Spawn = SPAWN
	:New('Template CAP Soch 1')
	:InitRandomizeTemplate( Sukh_CAP_list )
	:InitCleanUp( 120 )
	:OnSpawnGroup( 
		function (SpawnGroup)
			SpawnGroup.PatrolZone = AI_PATROLZONE:New( Sukh_CAP_Zone, 5000, 8000, 500, 800 )
			SpawnGroup.PatrolZone:SetControllable( SpawnGroup )
			SpawnGroup.PatrolZone:ManageFuel( 0.3 , 600 )
			SpawnGroup.PatrolZone:__Start(5)
		end
	)
	:SpawnScheduled( 1800 , 0 )

WWII_CAP_list = { "Template RUS WWII 1" , "Template RUS WWII 1 #001" , "Template RUS WWII 1 #002" }
WWII_CAP_Zone_Group = GROUP:FindByName( "WII RED Patrol Zone Group" ) 
WWII_CAP_Zone = ZONE_POLYGON:New( "WWII_Polygon" , WWII_CAP_Zone_Group )
WWII_CAP_Spawn = SPAWN
	:New("Template RUS WWII 1")
	:InitRandomizeTemplate( WWII_CAP_list )
	:InitCleanUp( 120 )
	:OnSpawnGroup(
		function (SpawnGroup)
			SpawnGroup.PatrolZone = AI_PATROLZONE:New( WWII_CAP_Zone, 3800, 5000, 300, 500 )
			SpawnGroup.PatrolZone:SetControllable( SpawnGroup )
			SpawnGroup.PatrolZone:ManageFuel( 0.3 , 600 )
			SpawnGroup.PatrolZone:__Start(5)
			SpawnGroup:OptionROEWeaponFree()
		end
	)
	:SpawnScheduled( 1800 , 0 )
	
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

local function SpawnKutaisi(withSAM)
	local Spawn_Kut1 = Spawn_Kuta_1:Spawn()
	local Spawn_Kut2 = Spawn_Kuta_2:Spawn()
	local Spawn_Kut3 = Spawn_Kuta_3:Spawn()
	local Spawn_Kut4 = Spawn_Kuta_4:Spawn()
	local Spawn_Kut5 = Spawn_Kuta_5:Spawn()
	if withSAM then
		local Spawn_KutSAM = Spawn_Kuta_SAM:Spawn()
	end
end

local function SpawnAchigvara()
	local Achig_group1 = mist.cloneInZone("infantry FARP 1", "Achigvara")
	local Achig_group2 = mist.cloneInZone("RUS_ARMOR_L_2", "Achigvara")
	local Achig_group3 = mist.cloneInZone("Template Kutaisi 1", "Achigvara")
	local Achig_group4 = mist.cloneInZone("Template Kutaisi 2", "Achigvara")
	local Achig_group5 = mist.cloneInZone("Template Kutaisi 3", "Achigvara")
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


MenuSpawnGround = MENU_COALITION:New( coalition.side.BLUE, "Spawn Ennemy Ground Target" )
MenuSpawnGGroup1 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Armor chemin 1", MenuSpawnGround, SpawnNewGroup, Spawn_Ground_1 )
MenuSpawnGGroup2 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Armor chemin 2", MenuSpawnGround, SpawnNewGroup, Spawn_Ground_2 )
MenuSpawnGGroup3 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Spawn Infantry FARP GH12", MenuSpawnGround, SpawnNewGroup, Spawn_Inf_RUS_1 )
MenuSpawnGGroup4 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Take Kutaisi scenario - no SA19", MenuSpawnGround, SpawnKutaisi, false )
MenuSpawnGGroup5 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Take Kutaisi scenario - w/ SA19", MenuSpawnGround, SpawnKutaisi, true )
MenuSpawnGGroup6 = MENU_COALITION_COMMAND:New( coalition.side.BLUE, "Take Achigvara scenario", MenuSpawnGround, SpawnAchigvara )



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
