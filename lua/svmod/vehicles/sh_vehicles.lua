-- @class SVMOD
-- @shared

-- Checks if the entity is a SV_Vehicle or not.
-- @treturn boolean True if the entity is a SV_Vehicle, false otherwise
function SVMOD:IsVehicle(veh)
	return IsValid(veh) and (veh.SV_IsEditMode or (veh.SV_GetDriverSeat and veh:SV_GetDriverSeat().SV_States ~= nil))
end

hook.Add("OnEntityCreated", "SV_LoadVehicle", function(ent)
	if not IsValid(ent) or not ent:IsVehicle() then return end

	if not SVMOD:GetAddonState() then
		-- Addon disabled or we do not know the state of the addon yet
		return
	end

	-- SVMod not loaded yet?!
	if not SVMOD.Data then
		return
	end

	if SERVER then
		-- Wait, because the entity is not fully loaded on the server!
		timer.Simple(FrameTime(), function()
			-- SVMOD:Compatiblity_VCMod_Seat_Fix()
			SVMOD:LoadVehicle(ent)
		end)
	else -- CLIENT
		SVMOD:LoadVehicle(ent)
	end
end)

hook.Add("EntityRemoved", "SV_UnloadVehicle", function(ent)
	if SVMOD:IsVehicle(ent) then
		-- Same as SVMOD:UnloadVehicle without removing pointers
		-- because it is unnecessary
		hook.Run("SV_UnloadVehicle", ent)
		hook.Run("SV_VehicleUnloaded", ent)
	end
end)

hook.Add("SV_Enabled", "SV_UpdateAndLoad", function()
	SVMOD:Data_Update(function()
		SVMOD:LoadAllVehicles()
	end)
end)

hook.Add("SV_Disabled", "SV_Unload", function()
	SVMOD:UnloadAllVehicles()
end)

-- Loads a vehicle, which allows it to become an SV Vehicle.
-- @tparam Vehicle Vehicle to be loaded
-- @internal
function SVMOD:LoadVehicle(veh)
	if not IsValid(veh) or not veh:IsVehicle() then
		return
	end

	local data = SVMOD:GetData(veh:GetModel())

	if (veh.SV_IsEditMode or data) or veh:GetNW2Bool("SV_IsSeat", false) then
		if SERVER and data then -- Is a driver seat
			local driver = veh:GetDriver()
			if IsValid(driver) then
				driver:ExitVehicle()
			end
		end

		-- Add pointers to the vehicle metatable
		for k, v in pairs(SVMOD.Metatable) do
			veh[k] = v
		end

		-- Get configuration and call InitEntity on driver seat ONLY
		if veh:GetModel() ~= "models/nova/airboat_seat.mdl" then
			veh.SV_States = {
				Headlights = false,
				BackLights = false,
				LeftBlinkers = false,
				RightBlinkers = false,
				HazardLights = false,
				FlashingLights = false,
				Horn = false
			}

			if data then
				veh.SV_Data = SVMOD:DeepCopy(data)

				hook.Run("SV_LoadVehicle", veh)
				hook.Run("SV_VehicleLoaded", veh)
			end
		end
	end
end

-- Unloads a vehicle, which allows it to become a basic vehicle.
-- @tparam SV_Vehicle SV_Vehicle to be unloaded
-- @internal
function SVMOD:UnloadVehicle(veh)
	if IsValid(veh) then
		hook.Run("SV_UnloadVehicle", veh)
		hook.Run("SV_VehicleUnloaded", ent)

		-- Remove pointers to the vehicle metatable
		for k, _ in pairs(SVMOD.Metatable) do
			veh[k] = nil
		end
	end
end

-- Loads all vehicles of the game.
-- @internal
function SVMOD:LoadAllVehicles()
	for _, veh in ipairs(ents.FindByClass("prop_vehicle_jeep")) do
		if SERVER and IsValid(veh) then
			local ply = veh:GetDriver()
			if IsValid(ply) then
				ply:ExitVehicle()
			end
		end

		SVMOD:LoadVehicle(veh)
	end
end

-- Unloads all vehicles of the game.
-- @internal
function SVMOD:UnloadAllVehicles()
	for _, veh in ipairs(ents.FindByClass("prop_vehicle_jeep")) do
		if SVMOD:IsVehicle(veh) then
			if SERVER then
				for _, ply in ipairs(veh:SV_GetAllPlayers()) do
					ply:ExitVehicle()
				end
			end

			timer.Simple(FrameTime() * 4, function()
				SVMOD:UnloadVehicle(veh)
			end)
		end
	end
end