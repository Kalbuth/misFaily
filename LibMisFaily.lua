--[[
   Save Table to File
   Load Table from File
   v 1.0
   
   Lua 5.2 compatible
   
   Only Saves Tables, Numbers and Strings
   Insides Table References are saved
   Does not save Userdata, Metatables, Functions and indices of these
   ----------------------------------------------------
   table.save( table , filename )
   
   on failure: returns an error msg
   
   ----------------------------------------------------
   table.load( filename or stringtable )
   
   Loads a table that has been saved via the table.save function
   
   on success: returns a previously saved table
   on failure: returns as second argument an error msg
   ----------------------------------------------------
   
   Licensed under the same terms as Lua itself.
]]--
do
local write, writeIndent, writers, refCount;

persistence =
{
	store = function (path, ...)
		local file, e = io.open(path, "w");
		if not file then
			return error(e);
		end
		local n = select("#", ...);
		-- Count references
		local objRefCount = {}; -- Stores reference that will be exported
		for i = 1, n do
			refCount(objRefCount, (select(i,...)));
		end;
		-- Export Objects with more than one ref and assign name
		-- First, create empty tables for each
		local objRefNames = {};
		local objRefIdx = 0;
		file:write("-- Persistent Data\n");
		file:write("local multiRefObjects = {\n");
		for obj, count in pairs(objRefCount) do
			if count > 1 then
				objRefIdx = objRefIdx + 1;
				objRefNames[obj] = objRefIdx;
				file:write("{};"); -- table objRefIdx
			end;
		end;
		file:write("\n} -- multiRefObjects\n");
		-- Then fill them (this requires all empty multiRefObjects to exist)
		for obj, idx in pairs(objRefNames) do
			for k, v in pairs(obj) do
				file:write("multiRefObjects["..idx.."][");
				write(file, k, 0, objRefNames);
				file:write("] = ");
				write(file, v, 0, objRefNames);
				file:write(";\n");
			end;
		end;
		-- Create the remaining objects
		for i = 1, n do
			file:write("local ".."obj"..i.." = ");
			write(file, (select(i,...)), 0, objRefNames);
			file:write("\n");
		end
		-- Return them
		if n > 0 then
			file:write("return obj1");
			for i = 2, n do
				file:write(" ,obj"..i);
			end;
			file:write("\n");
		else
			file:write("return\n");
		end;
		if type(path) == "string" then
			file:close();
		end;
	end;

	load = function (path)
		local f, e;
		if type(path) == "string" then
			f, e = loadfile(path);
		else
			f, e = path:read('*a')
		end
		if f then
			return f();
		else
			return nil, e;
		end;
	end;
}

-- Private methods

-- write thing (dispatcher)
write = function (file, item, level, objRefNames)
	writers[type(item)](file, item, level, objRefNames);
end;

-- write indent
writeIndent = function (file, level)
	for i = 1, level do
		file:write("\t");
	end;
end;

-- recursively count references
refCount = function (objRefCount, item)
	-- only count reference types (tables)
	if type(item) == "table" then
		-- Increase ref count
		if objRefCount[item] then
			objRefCount[item] = objRefCount[item] + 1;
		else
			objRefCount[item] = 1;
			-- If first encounter, traverse
			for k, v in pairs(item) do
				refCount(objRefCount, k);
				refCount(objRefCount, v);
			end;
		end;
	end;
end;

-- Format items for the purpose of restoring
writers = {
	["nil"] = function (file, item)
			file:write("nil");
		end;
	["number"] = function (file, item)
			file:write(tostring(item));
		end;
	["string"] = function (file, item)
			file:write(string.format("%q", item));
		end;
	["boolean"] = function (file, item)
			if item then
				file:write("true");
			else
				file:write("false");
			end
		end;
	["table"] = function (file, item, level, objRefNames)
			local refIdx = objRefNames[item];
			if refIdx then
				-- Table with multiple references
				file:write("multiRefObjects["..refIdx.."]");
			else
				-- Single use table
				file:write("{\n");
				for k, v in pairs(item) do
					writeIndent(file, level+1);
					file:write("[");
					write(file, k, level+1, objRefNames);
					file:write("] = ");
					write(file, v, level+1, objRefNames);
					file:write(";\n");
				end
				writeIndent(file, level);
				file:write("}");
			end;
		end;
	["function"] = function (file, item)
			-- Does only work for "normal" functions, not those
			-- with upvalues or c functions
			local dInfo = debug.getinfo(item, "uS");
			if dInfo.nups > 0 then
				file:write("nil --[[functions with upvalue not supported]]");
			elseif dInfo.what ~= "Lua" then
				file:write("nil --[[non-lua function not supported]]");
			else
				local r, s = pcall(string.dump,item);
				if r then
					file:write(string.format("loadstring(%q)", s));
				else
					file:write("nil --[[function could not be dumped]]");
				end
			end
		end;
	["thread"] = function (file, item)
			file:write("nil --[[thread]]\n");
		end;
	["userdata"] = function (file, item)
			file:write("nil --[[userdata]]\n");
		end;
}
end

function setContains(set, key)
    return set[key] ~= nil
end

do
	ACT_ROUTE_TARGET = { 
    ClassName = "ACT_ROUTE_TARGET",
  }
	
	function ACT_ROUTE_TARGET:New( TargetZone )
    local self = BASE:Inherit( self, ACT_ROUTE_ZONE:New( TargetZone ) )
		
		return self
	end
	
	function ACT_ROUTE_TARGET:onenterReporting( ProcessUnit, From, Event, To )
  
    local ZoneVec2 = self.TargetZone:GetVec2()
    local ZonePointVec2 = POINT_VEC2:New( ZoneVec2.x, ZoneVec2.y )
    local TaskUnitVec2 = ProcessUnit:GetVec2()
		local ZoneVec3 = self.TargetZone.ZoneGROUP:GetVec3()
		local ZonePointVec3 = POINT_VEC3:New( ZoneVec3.x, ZoneVec3.y, ZoneVec3.z )
    local TaskUnitPointVec2 = POINT_VEC2:New( TaskUnitVec2.x, TaskUnitVec2.y )
    local RouteText = "Route to " .. TaskUnitPointVec2:GetBRText( ZonePointVec2 ) .. " km to target, altitude " .. ZonePointVec3:GetAltitudeText() .. " meters."
		self:Message( RouteText )
  end
	
	TASK_INTERCEPT = {
		ClassName = "TASK_INTERCEPT",
	}
	
	function TASK_INTERCEPT:New( Mission, SetGroup, TaskName, TargetSetUnit )
		local self = BASE:Inherit( self, TASK:New( Mission, SetGroup, TaskName, "Interception" ) )
		self:F()
		
		local tmpTgtGroup
		local tmpTgtName
		local tmpRandomIndex = math.random(100, 10000)
		
		self.TargetSetUnit = TargetSetUnit
				
		for unitID, unitData in pairs(TargetSetUnit:GetSet()) do
			tmpTgtGroup = unitData:GetGroup()
			tmpTgtName = unitData:GetCallsign()
		end
		
--		local zoneName = "ZONE_INTERCEPT_" .. tmpTgtName .."_" .. tostring(tmpRandomIndex)
		local zoneName = "ZONE_INTERCEPT_" .. tostring(tmpRandomIndex)
		
		self.TargetZone = ZONE_GROUP:New( zoneName, tmpTgtGroup, 1000 )
		self.TargetZone:E( "Group Zone created for task :" .. routines.utils.oneLineSerialize(self.TargetZone) )
		local Fsm = self:GetUnitProcess()
		Fsm:AddProcess ( "Planned", "Accept", ACT_ASSIGN_ACCEPT:New( self.TaskBriefing ), { Assigned = "Route", Rejected = "Eject" } )
		Fsm:AddProcess ( "Assigned", "Route", ACT_ROUTE_TARGET:New( self.TargetZone ), { Arrived = "Update" } )
		Fsm:AddTransition( "Rejected", "Eject", "Planned" )
		Fsm:AddTransition( "Arrived", "Update", "Updated" )
		Fsm:AddProcess ( "Updated", "Account", ACT_ACCOUNT_DEADS:New( self.TargetSetUnit, "Interception" ), { Accounted = "Success" } )
		Fsm:AddTransition( "Accounted", "Success", "Success" )
		Fsm:AddTransition( "Failed", "Fail", "Failed" )
		
		function Fsm:onenterUpdated( TaskUnit )
			self:E( { self } )
			self:Account()
		end
		
		return self
	
	end
	
	function TASK_INTERCEPT:GetPlannedMenuText()
		return self:GetStateString() .. " - " .. self:GetTaskName() .. " ( " .. self.TargetSetUnit:GetUnitTypesText() .. " )"
	end
	
	TASK_A2G_NOFAC = {
    ClassName = "TASK_A2G_NOFAC",
  }
	
	function TASK_A2G_NOFAC:New( Mission, SetGroup, TaskName, TaskType, TargetSetUnit, TargetZone )
    local self = BASE:Inherit( self, TASK:New( Mission, SetGroup, TaskName, TaskType ) )
    self:F()
  
    self.TargetSetUnit = TargetSetUnit
    self.TargetZone = TargetZone
    
    local A2GUnitProcess = self:GetUnitProcess()

    A2GUnitProcess:AddProcess   ( "Planned",    "Accept",   ACT_ASSIGN_ACCEPT:New( "Attack the Area" ), { Assigned = "Route", Rejected = "Eject" } )
    A2GUnitProcess:AddProcess   ( "Assigned",   "Route",    ACT_ROUTE_ZONE:New( self.TargetZone ), { Arrived = "Update" } )
    A2GUnitProcess:AddTransition( "Rejected",   "Eject",    "Planned" )
    A2GUnitProcess:AddTransition( "Arrived",    "Update",   "Updated" ) 
    A2GUnitProcess:AddProcess   ( "Updated",    "Account",  ACT_ACCOUNT_DEADS:New( self.TargetSetUnit, "Attack" ), { Accounted = "Success" } )
    --Fsm:AddProcess ( "Updated",    "JTAC",     PROCESS_JTAC:New( self, TaskUnit, self.TargetSetUnit, self.FACUnit  ) )
    A2GUnitProcess:AddTransition( "Accounted",  "Success",  "Success" )
    A2GUnitProcess:AddTransition( "Failed",     "Fail",     "Failed" )
    
    function A2GUnitProcess:onenterUpdated( TaskUnit )
      self:E( { self } )
      self:Account()
      self:Smoke()
    end

    
    
    --_EVENTDISPATCHER:OnPlayerLeaveUnit( self._EventPlayerLeaveUnit, self )
    --_EVENTDISPATCHER:OnDead( self._EventDead, self )
    --_EVENTDISPATCHER:OnCrash( self._EventDead, self )
    --_EVENTDISPATCHER:OnPilotDead( self._EventDead, self )

    return self
  end
  
    --- @param #TASK_A2G self
  function TASK_A2G_NOFAC:GetPlannedMenuText()
    return self:GetStateString() .. " - " .. self:GetTaskName() .. " ( " .. self.TargetSetUnit:GetUnitTypesText() .. " )"
  end
  
  CSAR_HANDLER = {
    ClassName = "CSAR_HANDLER",
  }
	
	function CSAR_HANDLER:New( HostileZone, HostileSpawnList )
  	local self = BASE:Inherit( self, BASE:New() )
    self:F( HostileZone )
  
    self.HostileZone = HostileZone
    self.HostileSpawnList = HostileSpawnList
    
    self.MaxHostileSpawnRange = 10000
    self.MinHostileSpawnRange = 7000
    self.MaxHostileMoveRange = 4000
    self.MinHostileMoveRange = 2000
    self.ZoneID = 1
    
    self:HandleEvent( EVENTS.Birth )
    
    return self
	end
	
	function CSAR_HANDLER:OnEventBirth( EventData )
	 local RescueGroup = EventData.IniGroup
	 local RescueUnit = RescueGroup:GetUnit( 1 )
	 local RescueUnitName = EventData.IniUnitName
	 if string.find(RescueUnitName, "Wounded Pilot", 1) then 
	   if ( self.HostileZone:IsPointVec3InZone( RescueUnit:GetPointVec3() )) then
	     local SpawnZone = ZONE_UNIT:New( "ZONE_SPAWN_" .. self.ClassName .. self.ClassID .. "_" .. tostring(self.ZoneID), RescueUnit, self.MaxHostileSpawnRange )
	     local MoveZone = ZONE_UNIT:New( "ZONE_MOVE_" .. self.ClassName .. self.ClassID .. "_" .. tostring(self.ZoneID), RescueUnit, self.MaxHostileMoveRange )
	     self.ZoneID = self.ZoneID + 1
	     for SpawnID, SpawnData in pairs(self.HostileSpawnList) do
	       local SpawnPoint = SpawnZone:GetRandomPointVec2(self.MinHostileSpawnRange)
	       local MovePoint = MoveZone:GetRandomPointVec2(self.MinHostileMoveRange)
	       local HostileGroup = SpawnData:SpawnFromVec2( SpawnPoint:GetVec2() )
	       local TaskHostile = HostileGroup:TaskRouteToVec2( MovePoint:GetVec2(), 40 )
	       self:E( "Task for ground group: " .. routines.utils.oneLineSerialize(TaskHostile))
	       -- HostileGroup:SetTask( TaskHostile )
	     end
	   end
	 end
	end
	
	function CSAR_HANDLER:SetSpawnParams( MaxSpawnRange, MinSpawnRange )
	 self:F2( MaxSpawnRange, MinSpawnRange )
	 self.MaxHostileSpawnRange =MaxSpawnRange
	 self.MinHostileSpawnRange =MinSpawnRange
	 return self
	end
	
	function CSAR_HANDLER:SetMoveParams( MaxMoveRange, MinMoveRange )
	 self:F2( MaxMoveRange, MinMoveRange )
   self.MaxHostileMoveRange = MaxMoveRange
   self.MinHostileMoveRange = MinMoveRange
   return self
  end
  
	WARZONE_HANDLER = {
		ClassName = "WARZONE_HANDLER"
	}
	
	
	
  function csplit(str,sep)
   local ret={}
   local n=1
   for w in str:gmatch("([^"..sep.."]*)") do
      ret[n] = ret[n] or w -- only set once (so the blank after a string is ignored)
      if w=="" then
         n = n + 1
      end -- step forwards on a blank but not a string
   end
   return ret
  end
end

do
	SPEECH = {
		["0"] = {
			FileName = "0-continue.wav",
			Duration = 0.5
		},
		["1"] = {
			FileName = "1-continue.wav",
			Duration = 0.4
		},
		["2"] = {
			FileName = "2-continue.wav",
			Duration = 0.4
		},
		["3"] = {
			FileName = "3-continue.wav",
			Duration = 0.4
		},
		["4"] = {
			FileName = "4-continue.wav",
			Duration = 0.4
		},
		["5"] = {
			FileName = "5-continue.wav",
			Duration = 0.4
		},
		["6"] = {
			FileName = "6-continue.wav",
			Duration = 0.45
		},
		["7"] = {
			FileName = "7-continue.wav",
			Duration = 0.4
		},
		["8"] = {
			FileName = "8-continue.wav",
			Duration = 0.4
		},
		["9"] = {
			FileName = "9-continue.wav",
			Duration = 0.4
		},
		["this_is"] = {
			FileName = "this is.wav",
			Duration = 0.4
		},
		["Axeman"] = {
			FileName = "Axeman.wav",
			Duration = 0.7
		},
		["Darknight"] = {
			FileName = "Darknight.wav",
			Duration = 0.7
		},
		["Warrior"] = {
			FileName = "Warrior.wav",
			Duration = 0.7
		},
		["Pointer"] = {
			FileName = "Pointer.wav",
			Duration = 0.7
		},
		["Eyeball"] = {
			FileName = "Eyeball.wav",
			Duration = 0.7
		},
		["Moonbeam"] = {
			FileName = "Moonbeam.wav",
			Duration = 0.7
		},
		["Whiplash"] = {
			FileName = "Whiplash.wav",
			Duration = 0.7
		},
		["Finger"] = {
			FileName = "Finger.wav",
			Duration = 0.7
		},
		["Pinpoint"] = {
			FileName = "Pinpoint.wav",
			Duration = 0.7
		},
		["Ferret"] = {
			FileName = "Ferret.wav",
			Duration = 0.7
		},
		["Shaba"] = {
			FileName = "Shaba.wav",
			Duration = 0.7
		},
		["Playboy"] = {
			FileName = "Playboy.wav",
			Duration = 0.7
		},
		["Hammer"] = {
			FileName = "Hammer.wav",
			Duration = 0.7
		},
		["Jaguar"] = {
			FileName = "Jaguar.wav",
			Duration = 0.7
		},
		["Deathstar"] = {
			FileName = "Deathstar.wav",
			Duration = 0.7
		},
		["Anvil"] = {
			FileName = "Anvil.wav",
			Duration = 0.7
		},
		["Firefly"] = {
			FileName = "Firefly.wav",
			Duration = 0.7
		},
		["Mantis"] = {
			FileName = "Mantis.wav",
			Duration = 0.7
		},
		["Badger"] = {
			FileName = "Badger.wav",
			Duration = 0.7
		},
		["North"] = {
			FileName = "N.wav",
			Duration = 0.5
		},
		["East"] = {
			FileName = "E.wav",
			Duration = 0.45
		},
		["Point"] = {
			FileName = "point-continue.wav",
			Duration = 0.5
		},
		["at"] = {
			FileName = "at.wav",
			Duration = 0.3
		},
		["armored_targets"] = {
			FileName = "armored vehicles.wav",
			Duration = 1
		},
		["pause"] = {
			FileName = "beaconsilent.ogg",
			Duration = 2
		},
	}
end