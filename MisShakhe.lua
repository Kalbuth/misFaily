SpawnAssaultAdlerBackup=SPAWN:New("BLUE  Inf Sochi_Assault Backup")
SpawnBLUEGround=SPAWN:New("BLUE Ground template")
SpawnCivPlane=SPAWN:New("RED civ template")
SpawnAssaultAdlerInf=SPAWN:New("BLUE  Inf Sochi_Assault 1")
SpawnAssaultAdlerHeli=SPAWN:New("BLUE AirMobile Sochi_Assault 1")

misShakhe = {}

indexAssault = 1
function SpawnNewGroup( Template )
   Spawn_Plane = Template:Spawn()
	 return Spawn_Plane
end

function SpawnNewFromUnit( Template, Unit)
	Spawn_Group = Template:SpawnFromUnit(Unit, 30, 8)
end

function startAircraft(groupName)
	Group.getByName(groupName):getController():setCommand({["id"] = "Start", ["params"] = {}, })
end



-- function dropTroops()
-- 	local infGroup = Group.getByName("BLUE Kolhida Inf Sochi_Assault 1")
-- 	local infControl = infGroup:getController()
--	sochi = Airbase.getByName("Sochi-Adler")
-- 	local pos = {}
-- 	pos.x = Airbase.getPoint(sochi).x
--	pos.y = Airbase.getPoint(sochi).z
--	infControl:pushTask({["id"] = "DisembarkFromTransport", ["params"] = { ["x"] = pos.x, ["y"] = pos.y, ["zoneRadius"] = 500 } })
-- end

function initSochAssault()
	misShakhe.AssaultAdlerInf = SpawnAssaultAdlerInf:Spawn()
	misShakhe.AssaultAdlerHeli = SpawnAssaultAdlerHeli:Spawn()
end

function dropTroops()
	Group.activate(Group.getByName("BLUE  Inf Sochi_Assault " .. indexAssault))
	Group.activate(Group.getByName("BLUE AirMobile Sochi_Assault ".. indexAssault))
	indexAssault = indexAssault + 1
end

function dropTroopsNew()
	local InfGroup = misShakhe.AssaultAdlerInf
	local CargoSet = SET_BASE:New()
	for UnitID, UnitData in pairs( InfGroup:GetUnits() ) do
		CargoSet:Add( UnitData:Name() , AI_CARGO_UNIT:New( UNIT:FindByName( UnitData:Name() ), "Soldiers", "Soldier", 81 ) )
	end
	local InfantryCargo = AI_CARGO_GROUPED:New( CargoSet, "Soldiers", "Soldiers" )
	local CargoCarrierGroup = misShakhe.AssaultAdlerHeli
	local CargoCarrier = CargoCarrierGroup:GetUnit( 1 )
	InfantryCargo:Load( CargoCarrier )
	misShakhe.AssaultAdlerHeli:TaskLandAtVec2( CargoCarrier:GetPointVec2(), 30 )
	InfantryCargo:UnBoard()
end


UNITPOOL = { }
UNITPOOL.BLUE = {}
UNITPOOL.RED = {}

UNITTYPES = { "Ka50", "Su25", "Mig21", "Mig23", "Su25T", "Su27", "Mig29A", "Mig29S", "M2000C", "A10C", "SA342M", "SA342Mistral" }

MenuStartAIAir = MENU_COALITION:New( coalition.side.RED, "Start AI Planes" )
MenuStartAirports = {}

for k, c in ipairs({"RED", "BLUE"}) do
	for i, airport in ipairs(coalition.getAirbases(coalition.side[c])) do
		MenuStartAirports[Airbase.getCallsign(airport)] = {}
		MenuStartAirports[Airbase.getCallsign(airport)].menuBase = MENU_COALITION:New( coalition.side.RED, Airbase.getCallsign(airport), MenuStartAIAir )
		MenuStartAirports[Airbase.getCallsign(airport)].subMenus = {}
		for j, model in ipairs(UNITTYPES) do
			env.info("Checking aircraft existence for coalition ".. c .. " at airport " .. Airbase.getCallsign(airport) .. " for plane model " .. model)
			env.info("Starting by searching for group named : " .. c .." " .. Airbase.getCallsign(airport) .. " " .. model .. " template")
			if Group.getByName(c .." " .. Airbase.getCallsign(airport) .. " " .. model .. " template") then
				airbaseName = Airbase.getCallsign(airport)
				groupName = c .. " " .. airbaseName .. " " .. model .. " template"
				if not MenuStartAirports[airbaseName].subMenus[model] then
					MenuStartAirports[airbaseName].subMenus[model] = {}
					MenuStartAirports[airbaseName].subMenus[model].template = SPAWN:New(groupName)
					MenuStartAirports[airbaseName].subMenus[model].command = MENU_COALITION_COMMAND:New( coalition.side.RED, "Start " .. groupName, MenuStartAirports[Airbase.getCallsign(airport)].menuBase, SpawnNewGroup, MenuStartAirports[airbaseName].subMenus[model].template )
				end
			end
		end
	end
end

GROUNDTEMPLATE = {}
GROUNDTEMPLATE.Sochi = "Template vec Sochi"
GROUNDTEMPLATE.Adler = "Template vec Adler Airport"
GROUNDTEMPLATE.Lazarevskoe = "Template vec Lazar"

MenuStarAIGround = MENU_COALITION:New( coalition.side.RED, "Start AI Vehicles")
MenuStartGround = {}

MenuDivers = MENU_COALITION:New( coalition.side.RED, "Mission Control")
MenuAssaultSochiInit = MENU_COALITION_COMMAND:New( coalition.side.RED, "Spawn debarquement Sochi", MenuDivers, initSochAssault )
MenuAssaultSochi = MENU_COALITION_COMMAND:New( coalition.side.RED, "Debarquer sur Sochi", MenuDivers, dropTroopsNew )
MenuAssaultSochiBackup = MENU_COALITION_COMMAND:New( coalition.side.RED, "Assaut Sochi Secours", MenuDivers, SpawnNewGroup, SpawnAssaultAdlerBackup )
MenuBLUEGround = MENU_COALITION_COMMAND:New( coalition.side.RED, "Spawn Support troupes Georgie", MenuDivers, SpawnNewGroup, SpawnBLUEGround )
MenuCiv = MENU_COALITION_COMMAND:New( coalition.side.RED, "Spawn avion civil", MenuDivers, SpawnNewGroup, SpawnCivPlane )


for place, template in pairs(GROUNDTEMPLATE) do
	MenuStartGround[place] = {}
	MenuStartGround[place].template = SPAWN:New(template)
	MenuStartGround[place].command = MENU_COALITION_COMMAND:New( coalition.side.RED, "Start group at " .. place, MenuStarAIGround, SpawnNewGroup, MenuStartGround[place].template )
end

