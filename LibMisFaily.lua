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
	GROUND_ZONE_CC = {
    ClassName = "GROUND_ZONE_CC",
  }
	
	function GROUND_ZONE_CC:New( Radio )
    local self = BASE:Inherit( self, FSM:New( ) )
    self:F()
  
		self.CasList = {}
   

    self:AddTransition( "Waiting",   "ContactReport",    "LookingForCAS" )
    self:AddTransition( "Waiting",    "Update",   "Waiting" ) 
    --Fsm:AddProcess ( "Updated",    "JTAC",     PROCESS_JTAC:New( self, TaskUnit, self.TargetSetUnit, self.FACUnit  ) )
    --self:AddTransition( "Accounted",  "Success",  "Success" )
    --self:AddTransition( "Failed",     "Fail",     "Failed" )
    
    return self
  end
  
	function GROUND_ZONE_CC:AddCAS( CASGroup )
		self.CasList[#self.CasList] = CASGroup
	end
	
	function GROUND_ZONE_CC:onenterLookingForCAS( From, Event, To, Group)
		for Id, Cas in pairs(self.CasList) do
			local CasGroup = Cas.AIControllable
			if CasGroup:IsAlive() then
				if Cas:Is( "Patrolling" ) then
				-- do Engage this CAS to target zone stuff
				end
			else
				self.CasList[Id] = nil
			end
		end
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