 
-- local SetHelicopter = SET_GROUP:New():FilterPrefixes( "Helicopter" ):FilterStart()
 
-- AICargoDispatcherHelicopter = AI_CARGO_DISPATCHER_HELICOPTER:New( SetHelicopter, SetCargoInfantry, SetDeployZones ) 
--AICargoDispatcherHelicopter:SetHomeZone( ZONE:FindByName( "Home" ) )
-- AICargoDispatcherHelicopter:Start()

-- Logistics parameters definition :

logisticsParameters = {}

-- Prefix used in Logistics Zone Names
logisticsParameters.LogisticsZonePrefixes = {
	"logistic",
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
}

logisticsParameters.SlingloadPrefixes = {
	"TEMPLATE_SLING_1500",
	"TEMPLATE_SLING_3000",
}

logisticsParameters.SlingloadTemplates = {
	["Cargo 1500kg"] = "TEMPLATE_SLING_1500",
	["Cargo 3000Kg"] = "TEMPLATE_SLING_3000",
}

logisticsParameters.CargoTemplatesWeight = {
	["TEMPLATE_AVENGER"] = 1400,
	["TEMPLATE_LINEBACKER"] = 2700,
	["TEMPLATE_CHAPARRAL"] = 4200,
	["TEMPLATE_AMMO"] = 1000,
	["TEMPLATE_SA6"] = 7300,
}

logisticsParameters.CargoTemplatesName = {
	["TEMPLATE_AVENGER"] = "M1097 Avenger (1.4T)",
	["TEMPLATE_LINEBACKER"] = "M6 Linebacker (2.7T)",
	["TEMPLATE_CHAPARRAL"] = "M48 Chaparral with Supply (4.2T)",
	["TEMPLATE_AMMO"] = "Supply Truck (1T)",
	["TEMPLATE_SA6"] = "SA6 Site (7.3T)",
}

-- New Class declaration : handling Logistics :

-- LOGISTICS = BASE:New()
LOGISTICS = {
	ClassName = "LOGISTICS",
	GlobalIndex = 1,
}

function LOGISTICS:New( Parameters )
	local self = BASE:Inherit( self, BASE:New() )
	self.SetCargoInfantry = SET_CARGO:New():FilterTypes( "Spawned_Infantry" ):FilterStart()
	self.SetTransportPlayers = SET_GROUP:New():FilterPrefixes( Parameters.TransportPlayersPrefixes ):FilterStart()
	self.SetInfantryPlayers = SET_GROUP:New():FilterPrefixes( Parameters.InfantryPlayersPrefixes ):FilterStart()
	self.SetLogisticsZones = SET_ZONE:New():FilterPrefixes( Parameters.LogisticsZonePrefixes ):FilterStart()
	self.SetSling = SET_STATIC:New():FilterPrefixes( Parameters.SlingloadPrefixes ):FilterStart()
--	self.SetSling = SET_ZONE:New():FilterPrefixes( Parameters.LogisticsZonePrefixes ):FilterOnce()
	self.TroopList = {}
	self.TroopSpawn = {}
	self.SlingSpawn = {}
	self.SlingList = {}
	self.CargoList = {}
	self.PlayerGroups = {}
	self.DeploySpawn = {}
	self.DeployedAssets = {}
	self.InfantryTemplates = Parameters.InfantryTemplates
	for TroopName, TroopTemplate in pairs(Parameters.InfantryTemplates) do
		self.TroopSpawn[TroopName] = SPAWN
			:NewWithAlias(TroopTemplate, "Spawned_Infantry_" .. TroopName)
	end
	for StaticId, StaticName in pairs( Parameters.SlingloadTemplates ) do
		self.SlingSpawn[StaticName] = SPAWNSTATIC:NewFromStatic(StaticName)
		self.SlingSpawn[StaticName].MenuName = StaticId
	end
	for TemplateName, MenuName in pairs( Parameters.CargoTemplatesName) do 
		self.DeploySpawn[TemplateName] = SPAWN:New(TemplateName)
		self.DeploySpawn[TemplateName].MenuName = MenuName
		self.DeploySpawn[TemplateName].Weight = Parameters.CargoTemplatesWeight[TemplateName]
		self.DeploySpawn[TemplateName].TemplateName = TemplateName
	end
--	self:HandleEvent( EVENTS.PlayerEnterUnit )
	self.Check = SCHEDULER:New( nil, 
		function( args )
			self:E( "Regular check with args : " .. routines.utils.oneLineSerialize(args))
			args:CheckCargos()
		end, { self }, 5, 60
	)
	self.Menu = SCHEDULER:New( nil, 
		function(  )
			self.SetTransportPlayers:ForEachGroupAlive(
				function ( PlayerGroup )
					local GroupName = PlayerGroup:GetName()
					if not self.PlayerGroups[GroupName] then
						self:AddTransportMenu( PlayerGroup )
					end
				end
			)
		end, {}, 10, 10
	)
	return self
end

function LOGISTICS:CheckCargos()
	for infId, infData in pairs(self.TroopList) do
		if not infData:IsAlive() then
			self.TroopList[infId]:Destroy()
			self.TroopList[infId] = nil
		end
	end
	for cargoId, cargoData in pairs(self.CargoList) do
		if not cargoData:IsAlive() then
			self.CargoList[cargoId]:Destroy()
			self.CargoList[cargoId] = nil
		end
	end
end





function LOGISTICS:AddTransportMenu( PlayerGroup )
--	local PlayerGroup = IniUnit:GetGroup()
	local GroupName = PlayerGroup:GetName()
	self.PlayerGroups[GroupName] = {}
	self.PlayerGroups[GroupName].Group = PlayerGroup
	self:E( "PLAYER entered group : " .. routines.utils.oneLineSerialize(PlayerGroup))
	self.PlayerGroups[GroupName].MenuLogistics = MENU_GROUP:New( PlayerGroup, "Logistics")
--	if self.SetInfantryPlayers:IsIncludeObject( PlayerGroup ) then 
--		self:AddInfMenu( PlayerGroup )
--		self.PlayerGroups[GroupName].MenuInfantry = MENU_GROUP:New( PlayerGroup, "Spawn Infantry", self.PlayerGroups[GroupName].MenuLogistics)
--		self.PlayerGroups[GroupName].CommandInfantry = {}
--		for InfName, InfSpawn in pairs(self.TroopSpawn) do 
--			self.PlayerGroups[GroupName].CommandInfantry[InfName] = MENU_GROUP_COMMAND:New( PlayerGroup, InfName, self.PlayerGroups[GroupName].MenuInfantry, self.SpawnInfGroup, self, PlayerGroup, InfSpawn, InfName )
--		end
--	end
	self.PlayerGroups[GroupName].MenuSpawn = MENU_GROUP:New( PlayerGroup, "Spawn", self.PlayerGroups[GroupName].MenuLogistics )
	self.PlayerGroups[GroupName].MenuSling = MENU_GROUP:New( PlayerGroup, "Spawn Cargos", self.PlayerGroups[GroupName].MenuSpawn )
	self:AddInfMenu( PlayerGroup )
	self.PlayerGroups[GroupName].CommandSling = {}
	for SlingName, SlingSpawn in pairs(self.SlingSpawn) do
		self.PlayerGroups[GroupName].CommandSling[SlingName] = MENU_GROUP_COMMAND:New( PlayerGroup, SlingSpawn.MenuName, self.PlayerGroups[GroupName].MenuSling, self.SpawnSling, self, PlayerGroup, SlingSpawn )
	end
	self.PlayerGroups[GroupName].MenuDeploy = MENU_GROUP:New( PlayerGroup, "Deploy Assets", self.PlayerGroups[GroupName].MenuLogistics )
	self.PlayerGroups[GroupName].CommandDeploy = {}
	for DeployTemplate, DeploySpawn in pairs(self.DeploySpawn) do
		self.PlayerGroups[GroupName].CommandDeploy[DeployTemplate] = MENU_GROUP_COMMAND:New( PlayerGroup, DeploySpawn.MenuName, self.PlayerGroups[GroupName].MenuDeploy, self.DeployAsset, self, PlayerGroup, DeploySpawn )
	end
	self:AddLoadMenu( PlayerGroup )
	
--	local MenuSpawnTroops = MENU_GROUP_COMMAND:New( PlayerGroup, "Spawn Troops", MenuSpawn, LOGISTICS.SpawnInfGroup, LOGISTICS, PlayerGroup )
end

function LOGISTICS:AddLoadMenu( PlayerGroup )
	local GroupName = PlayerGroup:GetName()
	self.PlayerGroups[GroupName].MenuLoad = MENU_GROUP:New( PlayerGroup, "Load", self.PlayerGroups[GroupName].MenuLogistics )
	self.PlayerGroups[GroupName].CommandLoadCargo = MENU_GROUP_COMMAND:New( PlayerGroup, "Load Nearest Cargo", self.PlayerGroups[GroupName].MenuLoad, self.LoadSling, self, PlayerGroup )
	self.PlayerGroups[GroupName].CommandLoadInf = MENU_GROUP_COMMAND:New( PlayerGroup, "Load Nearest Infantry", self.PlayerGroups[GroupName].MenuLoad, self.LoadInf, self, PlayerGroup )
end

function LOGISTICS:AddInfMenu( PlayerGroup )
	local GroupName = PlayerGroup:GetName()
	self.PlayerGroups[GroupName].MenuInfantry = MENU_GROUP:New( PlayerGroup, "Spawn Infantry", self.PlayerGroups[GroupName].MenuSpawn)
	self.PlayerGroups[GroupName].CommandInfantry = {}
	for InfName, InfSpawn in pairs(self.TroopSpawn) do 
		self.PlayerGroups[GroupName].CommandInfantry[InfName] = MENU_GROUP_COMMAND:New( PlayerGroup, InfName, self.PlayerGroups[GroupName].MenuInfantry, self.SpawnInfGroup, self, PlayerGroup, InfSpawn, InfName )
	end
end


function LOGISTICS:AddUnboardMenu( PlayerGroup )
	local GroupName = PlayerGroup:GetName()
	self.PlayerGroups[GroupName].CommandUnboard = MENU_GROUP_COMMAND:New( PlayerGroup, "Unboard Cargo", self.PlayerGroups[GroupName].MenuLogistics, self.UnboardCargo, self, PlayerGroup )
end

function LOGISTICS:UnboardCargo( PlayerGroup )
	local GroupName = PlayerGroup:GetName()
	local PlayerUnit = PlayerGroup:GetUnits()[1]
	local coord = PlayerUnit:GetCoordinate()
	local dir = PlayerUnit:GetHeading()
	local Tcoord = coord:Translate(20, dir)
	self:E( "UNLOAD POINT : " .. routines.utils.oneLineSerialize(Tcoord:GetVec2()))
	if PlayerGroup.Cargo.ClassName == "CARGO_CRATE" then
		PlayerGroup.Cargo:UnLoad(Tcoord)
		self.PlayerGroups[GroupName].CommandUnboard:Remove()
		self:AddLoadMenu( PlayerGroup )
	end
	if PlayerGroup.Cargo.ClassName == "CARGO_GROUP" then
		PlayerGroup.Cargo:UnBoard()
		self.PlayerGroups[GroupName].CommandUnboard:Remove()
		self:AddLoadMenu( PlayerGroup )
	end
end

function LOGISTICS:LoadSling( PlayerGroup )
	local GroupName = PlayerGroup:GetName()
	local dist = 10000
	local PlayerCoord = PlayerGroup:GetCoordinate()
	local SlingCoord = false
	local NearSling = false
	for StaticID, StaticData in pairs(self.CargoList) do
		local StaticCoord = StaticData:GetCoordinate()
		if ( StaticCoord:Get3DDistance( PlayerCoord ) < dist ) then
			dist = StaticCoord:Get3DDistance( PlayerCoord )
			SlingCoord = StaticCoord
			NearSling = StaticData
		end
	end
	if ( dist < 50 ) then
		MESSAGE:New("Loading Crate."):ToGroup( PlayerGroup )
		local Carrier = PlayerGroup:GetUnits()[1]
		NearSling:Load( Carrier )
		PlayerGroup.Cargo = NearSling
		self.PlayerGroups[GroupName].MenuLoad:Remove()
		self:AddUnboardMenu( PlayerGroup )
	else
		MESSAGE:New("No nearby crate found. Stand less than 50m from one."):ToGroup( PlayerGroup )
	end
end

function LOGISTICS:LoadInf( PlayerGroup )
	local GroupName = PlayerGroup:GetName()
	local dist = 10000
	local PlayerCoord = PlayerGroup:GetCoordinate()
	local InfCoord = false
	local NearInf = false
	for InfID, InfData in pairs(self.TroopList) do
		local tmpInfCoord = InfData:GetCoordinate()
		if ( tmpInfCoord:Get3DDistance( PlayerCoord ) < dist ) then
			dist = tmpInfCoord:Get3DDistance( PlayerCoord )
			InfCoord = tmpInfCoord
			NearInf = InfData
		end
	end
	if ( dist < 50 ) then
		MESSAGE:New("Infantry group boarding, hold on."):ToGroup( PlayerGroup )
		local Carrier = PlayerGroup:GetUnits()[1]
		NearInf:Board( Carrier )
		PlayerGroup.Cargo = NearInf
		self.PlayerGroups[GroupName].MenuLoad:Remove()
		self:AddUnboardMenu( PlayerGroup )
	else
		MESSAGE:New("No infantry group found. Stand less than 50m from one."):ToGroup( PlayerGroup )
	end
end

function LOGISTICS:SpawnInfGroup( PlayerGroup, InfSpawn, InfName )
	local GroupName = PlayerGroup:GetName()
	self:E("Spawning troops!")
	local isInZone = false
	local LocalZone = {}
	for ZoneName, ZoneData in pairs(self.SetLogisticsZones.Set) do
		if PlayerGroup:IsCompletelyInZone( ZoneData ) then 
			isInZone = true 
			LocalZone = ZoneData
		end
	end
	if isInZone then 
		local InfGroup = InfSpawn:SpawnInZone( LocalZone , false )
		local Carrier = PlayerGroup:GetUnits()[1]
		local PlayerName = Carrier:GetPlayerName()
		self.TroopList[#self.TroopList + 1] = CARGO_GROUP:New( InfGroup, "Spawned_Infantry", "Spawned_Infantry_by_" .. PlayerName )
		self.LatestTroops = self.TroopList[#self.TroopList]
--		PlayerGroup.Cargo:Board( Carrier )
		local GroupName = PlayerGroup:GetName()
--		self.PlayerGroups[GroupName].MenuInfantry:Remove()
--		self:AddUnboardMenu( PlayerGroup )
		MESSAGE:New(InfName .. " available.", 10, "Logistics"):ToGroup( PlayerGroup )
		function self.LatestTroops:OnEnterLoaded( From, Event, To, CargoCarrier )
			if From == "Boarding" then
				MESSAGE:New("Infantry group has boarded."):ToGroup( CargoCarrier:GetGroup() )
			end
		end
		function self.LatestTroops:OnEnterUnLoaded( From, Event, To, ToPointVec2 )
			local CargoCarrier = self.CargoCarrier
			if From == "UnBoarding" then
				MESSAGE:New("Infantry group has unboarded."):ToGroup( CargoCarrier:GetGroup() )
			end
		end
	else
		MESSAGE:New("You are not in any Logistics Zone.", 10, "Logistics"):ToGroup( PlayerGroup )
	end
end

function LOGISTICS:SpawnSling( PlayerGroup, SlingSpawn )
	local isInZone = false
	local LocalZone = {}
	for ZoneName, ZoneData in pairs(self.SetLogisticsZones.Set) do
		if PlayerGroup:IsCompletelyInZone( ZoneData ) then 
			isInZone = true 
-- 			LocalZone = ZoneData
		end
	end
	if isInZone then 
		local GroupName = PlayerGroup:GetName()
		local PlayerUnit = PlayerGroup:GetUnits()[1]
		local coord = PlayerUnit:GetCoordinate()
		local dir = PlayerUnit:GetHeading()
		local Tcoord = coord:Translate(40, dir)
		LocalZone = ZONE_RADIUS:New( "tmpZoneSpawnStatic" .. GroupName, Tcoord:GetVec2() , 15 )
		local LastSling = SlingSpawn:SpawnFromZone( LocalZone, 0 )
--		local LastSling = SlingSpawn:SpawnFromPointVec2( Tcoord:GetVec2() , dir )
		local plyr = PlayerGroup:GetPlayerUnits()[1]
		local slingName = plyr:GetPlayerName() .. "'s " .. SlingSpawn.MenuName
		self.CargoList[ #self.CargoList + 1 ] = CARGO_CRATE:New( LastSling, "Supplies", slingName )
		self:RegisterStatic( LastSling )
	else
		MESSAGE:New("You are not in any Logistics Zone.", 10, "Logistics"):ToGroup( PlayerGroup )
	end
end

function LOGISTICS:RegisterStatic( Object )
	for paramID, paramData in pairs( Object ) do
		self:E("Static parameter : " .. routines.utils.oneLineSerialize(paramID))
	end
	self.SlingList[#self.SlingList + 1] = Object
	self:E("Adding Static into Zone : " .. routines.utils.oneLineSerialize(self.SlingList[#self.SlingList]))

end

function LOGISTICS:DeployAsset( PlayerGroup, DeploySpawn )
	local PlayerCoord = PlayerGroup:GetCoordinate()
	local TotalWeight = 0
	local SlingList = {}
	for StaticID, StaticData in pairs(self.CargoList) do
		local StaticCoord = StaticData:GetCoordinate()
		if ( StaticCoord:Get3DDistance( PlayerCoord ) < 100 ) then
			local StaticWeight = 0
			local DCSStatic = StaticData.CargoObject:GetDCSObject()
			if DCSStatic then 
				StaticWeight = DCSStatic:getCargoWeight()
			end
			TotalWeight = TotalWeight + StaticWeight
			self:E("Total Weight : " .. TotalWeight )
			StaticData.StaticID = StaticID
			SlingList[#SlingList + 1] = StaticData
		end
	end
	local NeededWeight = DeploySpawn.Weight
	if ( TotalWeight > NeededWeight ) then
		MESSAGE:New("Deploying " .. DeploySpawn.MenuName .. ".", 10, "Logistics"):ToGroup( PlayerGroup )
		
		local coord = PlayerCoord:GetRandomVec2InRadius( 60, 40 )
--		local PlayerZone = ZONE_GROUP:New( "DEPLOY_ZONE_" .. PlayerGroup:GetName(), PlayerGroup , 100 )
		local depGroup = DeploySpawn:SpawnFromVec2( coord )
		for id, Static in pairs(SlingList) do
			Static.CargoObject:Destroy()
			self.CargoList[Static.StaticID] = nil
		end
		local playerUnit = PlayerGroup:GetUnits()[1]
		local playerName = playerUnit:GetPlayerName()
		local playerCoalition = PlayerGroup:GetCoalition()
		MESSAGE:New( DeploySpawn.MenuName .. " has been deployed by " .. playerName , 10, "Logistics"):ToCoalition( playerCoalition )
		COORDINATE:NewFromVec2( coord ):MarkToCoalition( DeploySpawn.MenuName .. "\nDeployed by : " .. playerName, playerCoalition  )
		self:E({coord, depGroup:GetCoordinate()})
		local pers = {}
		pers.Deployed = depGroup
		pers.Template = DeploySpawn.TemplateName
		pers.x = depGroup:GetCoordinate()["x"]
		pers.y = depGroup:GetCoordinate()["y"]
		pers.z = depGroup:GetCoordinate()["z"]
		pers.Player = playerName
		self.DeployedAssets[#self.DeployedAssets + 1 ] = pers
	else
		MESSAGE:New("Not enough supply nearby to deploy " .. DeploySpawn.MenuName .. " Bring more.", 10, "Logistics"):ToGroup( PlayerGroup )
	end
end

-- Logistics = LOGISTICS:New( Parameters )
