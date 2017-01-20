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
		
		local zoneName = "ZONE_INTERCEPT_" .. tmpTgtName .."_" .. tostring(tmpRandomIndex)
--		local zoneName = "ZONE_INTERCEPT_" .. tostring(tmpRandomIndex)
		
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
	
end
