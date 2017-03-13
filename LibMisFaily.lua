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