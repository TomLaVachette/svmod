-- @class SVMOD
-- @shared

local function getDataPath(model)
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

	local vehicles = {}
	for _, veh in ipairs(SVMOD:GetVehicleList()) do
		local filePath = getDataPath(veh.Model)

		local CRC = ""
		if file.Exists(filePath, "DATA") then
			CRC = util.CRC(file.Read(filePath, "DATA"))
		end
		table.insert(vehicles, {
			model = veh.Model,
			crc = CRC
		})
	end

	HTTP({
		url = "https://api.svmod.com/get_vehicles_new.php",
		method = "POST",
		body = util.TableToJSON({
			version = SVMOD.FCFG.DataVersion,
			enterpriseID = SVMOD.CFG.Contributor.EnterpriseID,
			vehicles = vehicles
		}),
		success = function(code, body)
			if code == 200 then
				local createdCount = 0
				local updatedCount = 0

				local JSON = util.JSONToTable(body)

				for _, veh in pairs(JSON) do
					local filePath = getDataPath(string.lower(veh["model"]))

					if file.Exists(filePath, "DATA") then
						updatedCount = updatedCount + 1
					else
						createdCount = createdCount + 1
					end

					file.Write(filePath, veh["json"])
				end

				SVMOD.VehicleDataUpdateTime = os.time()
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

local function temp_angleToAngles(x)
	for k, v in pairs(x) do
		if istable(v) then
			temp_angleToAngles(v)
		elseif k == "Angle" then
			x["Angles"] = v
			x[k] = nil
		end
	end
end
--
--local function temp_fuelpump(data)
--	if data.Fuel.GasTank.Angles then
--		local pos = data.Fuel.GasTank.Position
--		local ang = data.Fuel.GasTank.Angles
--
--		if data.Fuel.GasolinePistol then
--			data.Fuel.GasTank = {
--				{
--					GasHole = {
--						Position = pos,
--						Angles = ang
--					},
--					GasolinePistol = {
--						Position = data.Fuel.GasolinePistol.Position,
--						Angles = data.Fuel.GasolinePistol.Angles
--					}
--				}
--			}
--		else
--			data.Fuel.GasTank = {
--				{
--					GasHole = {
--						Position = pos,
--						Angles = ang
--					}
--				}
--			}
--		end
--	end
--end

local function temp_partType(data)
	for _, part in ipairs(data.Parts) do
		if not part.Type then
			part.Type = "engine"
		end
	end
end

-- Loads vehicle data.
-- @tparam function callback Function callback
-- @internal
function SVMOD:Data_Load(fun)
	for _, veh in ipairs(SVMOD:GetVehicleList()) do
		local model = string.lower(veh.Model)
		if file.Exists(getDataPath(model), "DATA") then
			local JSON = util.JSONToTable(file.Read(getDataPath(model), "DATA"))

			temp_angleToAngles(JSON)
			--temp_fuelpump(JSON)
			temp_partType(JSON)

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