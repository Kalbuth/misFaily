do
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
		local Fsm = self:GetUnitProcess()
		Fsm:AddProcess ( "Planned", "Accept", ACT_ASSIGN_ACCEPT:New( self.TaskBriefing ), { Assigned = "Route", Rejected = "Eject" } )
		Fsm:AddProcess ( "Assigned", "Route", ACT_ROUTE_ZONE:New( self.TargetZone ), { Arrived = "Update" } )
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
  
  
end
