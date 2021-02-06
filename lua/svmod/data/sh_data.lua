-- @class SV_Vehicle
-- @shared

local function GetDataPath(model)
	return "svmod/" .. string.Replace(model, "/", "_") .. ".txt"
end

-- Gets the data of a vehicle.
-- @tparam string model Vehicle model
-- @treturn table Data of a vehicle
-- @internal
function SVMOD:GetData(model)
	if self.Data then
		return self.Data[string.lower(model)]
	end
	return nil
end

-- Updates vehicle data. SVMod will contact the web server
-- to get the latest releases.
-- @tparam function callback Function callback
-- @internal
function SVMOD:Data_Update(fun)
	self.Data = {}

	if not file.IsDir("svmod", "DATA") then
		file.CreateDir("svmod")
	end

	local Parameters = {}
	for _, veh in ipairs(SVMOD:GetVehicleList()) do
		local filePath = GetDataPath(veh.Model)

		local CRC = ""
		if file.Exists(filePath, "DATA") then
			CRC = util.CRC(file.Read(filePath, "DATA"))
		end
		table.insert(Parameters, {
			model = veh.Model,
			crc = CRC
		})
	end

	HTTP({
		url = "https://api.svmod.com/get_vehicles.php",
		method = "POST",
		body = util.TableToJSON(Parameters),
		success = function(code, body)
			if code == 200 then
				local createdCount = 0
				local updatedCount = 0

				local JSON = util.JSONToTable(body)

				for _, veh in pairs(JSON) do
					local filePath = GetDataPath(string.lower(veh["model"]))

					if file.Exists(filePath, "DATA") then
						updatedCount = updatedCount + 1
					else
						createdCount = createdCount + 1
					end

					file.Write(filePath, veh["json"])
				end

				SVMOD.CFG.VehicleDataUpdateTime = os.time()
				SVMOD:PrintConsole(SVMOD.LOG.Info, "Updater: " .. createdCount .. " added vehicle" .. self:AddPlurial(createdCount) .. ", " .. updatedCount .. " updated vehicle" .. self:AddPlurial(updatedCount) .. ".")
			else
				SVMOD:PrintConsole(SVMOD.LOG.Alert, "Updater: server responding with code " .. code .. ".")
			end

			self:Data_Load(fun)
		end,
		failed = function()
			SVMOD:PrintConsole(SVMOD.LOG.Alert, "Updater: server not responding.")

			self:Data_Load(fun)
		end
	})
end

-- Checks the data types of the input.
-- @tparam table data Data to check
-- @treturn boolean result True if valid, false if not
-- @internal
function SVMOD:Data_Check(x)
	local function checkLights(x)
		if not istable(x) then
			return ""
		end

		for i, v in ipairs(x) do
			if v.Sprite then
				if v.ActiveTime and not isnumber(v.ActiveTime) then
					return "Sprite[" .. i .. "].ActiveTime"
				elseif v.Color and not iscolor(v.Color) then
					return "Sprite[" .. i .. "].Color"
				elseif v.Height and not isnumber(v.Width) then
					return "Sprite[" .. i .. "].Height"
				elseif v.HiddenTime and not isnumber(v.HiddenTime) then
					return "Sprite[" .. i .. "].HiddenTime"
				elseif v.Position and not isvector(v.Position) then
					return "Sprite[" .. i .. "].Position"
				elseif v.Size and not isnumber(v.Size) then
					return "Sprite[" .. i .. "].Size"
				elseif v.Width and not isnumber(v.Width) then
					return "Sprite[" .. i .. "].Width"
				end
			elseif v.ProjectedTexture then
				if v.Angle and not isvector(v.Angle) then
					return "Sprite[" .. i .. "].Angle"
				elseif v.Color and not iscolor(v.Color) then
					return "Sprite[" .. i .. "].Color"
				elseif v.FOV and not isnumber(v.FOV) then
					return "Sprite[" .. i .. "].FOV"
				elseif v.Position and not isvector(v.Position) then
					return "Sprite[" .. i .. "].Position"
				elseif v.Size and not isnumber(v.Size) then
					return "Sprite[" .. i .. "].Size"
				end
			end
		end

		return nil
	end

	local function checkParts(x)
		if not istable(x) then
			return ""
		end

		for i, v in ipairs(x) do
			if v.Angle and not isangle(v.Angle) then
				return "Sprite[" .. i .. "].Angle"
			elseif v.Health and not isnumber(v.Health) then
				return "Sprite[" .. i .. "].Health"
			elseif v.LastLerp and not isnumber(v.LastLerp) then
				return "Sprite[" .. i .. "].LastLerp"
			elseif v.Position and not isvector(v.Position) then
				return "Sprite[" .. i .. "].Position"
			elseif v.StartLerp and not isnumber(v.StartLerp) then
				return "Sprite[" .. i .. "].StartLerp"
			end
		end

		return nil
	end

	local function checkSeats(x)
		if not istable(x) then
			return false
		end

		for i, v in ipairs(x) do
			if v.Angle and not isangle(v.Angle) then
				return "Sprite[" .. i .. "].Angle"
			elseif v.Position and not isvector(v.Position) then
				return "Sprite[" .. i .. "].Position"
			end
		end

		return nil
	end

	if not x.Author then
		return "DATA.Author"
	else
		if not isstring(x.Author.Name) then
			return "DATA.Author.Name"
		elseif not isstring(x.Author.SteamID64) then
			return "DATA.Author.SteamID64"
		end
	end

	if not isnumber(x.Timestamp) then
		return "DATA.Timestamp"
	end

	if not x.Back then
		return "DATA.Back"
	else
		local brakeLights = checkLights(x.Back.BrakeLights)
		local reversingLights = checkLights(x.Back.ReversingLights)
		if brakeLights then
			return "DATA.Back.BrakeLights." .. brakeLights
		elseif reversingLights then
			return "DATA.Back.ReversingLights." .. reversingLights
		end
	end

	if not x.Blinkers then
		return "DATA.Blinkers"
	else
		local leftLights = checkLights(x.Blinkers.LeftLights)
		local rightLights = checkLights(x.Blinkers.RightLights)
		if leftLights then
			return "DATA.Blinkers.LeftLights." .. leftLights
		elseif rightLights then
			return "DATA.Blinkers.RightLights." .. rightLights
		end
	end

	if not x.FlashingLights then
		return "DATA.FlashingLights"
	else
		local flashingLights = checkLights(x.FlashingLights)
		if flashingLights then
			return "DATA.FlashingLights." .. flashingLights
		end
	end

	if not x.Fuel then
		return "DATA.Fuel"
	else
		if not isnumber(x.Fuel.Capacity) then
			return "DATA.Fuel.Capacity"
		elseif not isnumber(x.Fuel.Consumption) then
			return "DATA.Fuel.Consumption"
		end
	end

	if not x.Headlights then
		return "DATA.Headlights"
	else
		local headlights = checkLights(x.Headlights)
		if headlights then
			return "DATA.Headlights." .. headlights
		end
	end

	if not x.Horn then
		return "DATA.Horn"
	else
		if x.Horn.Sound and not isstring(x.Horn.Sound) then
			return "DATA.Horn.Sound"
		end
	end
			

	if not x.Parts then
		return "DATA.Parts"
	else
		local parts = checkParts(x.Parts)
		if parts then
			return "DATA.Parts." .. parts
		end
	end

	if not x.Seats then
		return "DATA.Seats"
	else
		local seats = checkSeats(x.Seats)
		if seats then
			return "DATA.Seats." .. seats
		end
	end

	if not x.Sounds then
		return "DATA.Sounds"
	else
		if x.Sounds.Siren and not isstring(x.Sounds.Siren) then
			return "DATA.Sounds.Siren"
		end
	end

	return nil
end

-- Loads vehicle data.
-- @tparam function callback Function callback
-- @internal
function SVMOD:Data_Load(fun)
	for _, veh in ipairs(SVMOD:GetVehicleList()) do
		local model = string.lower(veh.Model)
		if file.Exists(GetDataPath(model), "DATA") then
			local JSON = util.JSONToTable(file.Read(GetDataPath(model), "DATA"))
			local checkResult = SVMOD:Data_Check(JSON)
			if checkResult == nil then
				self.Data[model] = JSON
			else
				SVMOD:PrintConsole(SVMOD.LOG.Alert, veh.Model .. " cannot be loaded, syntax error on " .. checkResult)
			end
		end
	end

	local importedCount = table.Count(self.Data)
	local incompatibleCount = table.Count(SVMOD:GetVehicleList()) - importedCount

	SVMOD:PrintConsole(SVMOD.LOG.Info, "Loader: " .. importedCount .. " loaded vehicle" .. self:AddPlurial(importedCount) .. ", " .. incompatibleCount .. " incompatible vehicle" .. self:AddPlurial(incompatibleCount) .. ".")

	if fun then
		fun()
	end
end