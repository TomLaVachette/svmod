-- @class SV_Vehicle
-- @serverside

-- Sets the vehicule fuel in liters.
-- @tparam number fuel Fuel in liters
util.AddNetworkString("SV_SetFuel")
function SVMOD.Metatable:SV_SetFuel(value)
	local veh = self
	if self:SV_IsPassengerSeat() then
		veh = self:SV_GetDriverSeat()
	end

	local MaxFuel = veh:SV_GetMaxFuel()

	value = math.Round(math.Clamp(value, 0, MaxFuel), 2)

	-- Out of fuel sound when we go below 20%
	if value > 0 and veh:SV_GetPercentFuel() > 20 and (value / MaxFuel * 100) <= 20 then
		veh:EmitSound("svmod/out_of_fuel.wav")
	end

	veh.SV_Fuel = value

	net.Start("SV_SetFuel")
	net.WriteEntity(veh)
	net.WriteFloat(veh.SV_Fuel)
	net.Send(veh:SV_GetAllPlayers())

	-- Out of fuel
	if value <= 0 then
		veh:EnableEngine(false)
		veh:StartEngine(false)
		veh:EmitSound("svmod/out_of_fuel.wav")

		hook.Run("SV_OutOfFuel", veh)
	end
end

-- Sets the vehicle maximum fuel in liters.
-- @tparam number maxFuel Maximum fuel in leters
util.AddNetworkString("SV_SetMaxFuel")
function SVMOD.Metatable:SV_SetMaxFuel(value)
	local Vehicle = self
	if self:SV_IsPassengerSeat() then
		Vehicle = self:SV_GetDriverSeat()
	end

	value = math.Round(math.Clamp(value, 0, 300), 2)

	Vehicle.SV_MaxFuel = value

	net.Start("SV_SetMaxFuel")
	net.WriteEntity(Vehicle)
	net.WriteFloat(Vehicle:SV_GetMaxFuel())
	net.Send(Vehicle:SV_GetAllPlayers())
end

-- Sends the fuel and the maximum fuel of the vehicle.
-- @tparam Player The player to send the information to.
util.AddNetworkString("SV_GetFuel")
function SVMOD.Metatable:SV_SendFuel(ply)
	local veh = self
	if self:SV_IsPassengerSeat() then
		veh = self:SV_GetDriverSeat()
	end

	net.Start("SV_GetFuel")
	net.WriteEntity(veh)
	net.WriteFloat(veh:SV_GetFuel())
	net.WriteFloat(veh:SV_GetMaxFuel())
	net.Send(ply)
end

hook.Add("PlayerEnteredVehicle", "SV_Fuel_SendFuel", function(ply, veh)
	if not SVMOD:IsVehicle(veh) then return end

	veh:SV_SendFuel(ply)
end)

hook.Add("PlayerEnteredVehicle", "SV_Fuel_StartFuelConsumption", function(ply, veh)
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then return end

	if not SVMOD.CFG.Fuel.IsEnabled then return end

	-- Timer needed here because Source use the next frame to start the engine
	timer.Simple(FrameTime() * 4, function()
		-- Stop the engine if the vehicle is out of fuel
		if veh:SV_GetPercentFuel() == 0 then
			veh:EnableEngine(false)
			veh:StartEngine(false)

			return
		end
	end)

	veh.SV_LastPosition = veh:GetPos()
	timer.Create("SV_Fuel_Consumption_" .. veh:EntIndex(), 5, 0, function()
		local newFuel = veh:SV_GetFuel() - (veh:GetPos():Distance(veh.SV_LastPosition) * 0.00005715 * (veh.SV_Data.Fuel.Consumption or 5) * SVMOD.CFG.Fuel.Multiplier)
		veh:SV_SetFuel(newFuel)

		if newFuel <= 0 then
			timer.Remove("SV_Fuel_Consumption_" .. veh:EntIndex())
		end

		veh.SV_LastPosition = veh:GetPos()
	end)
end)

local function DisableFuel(veh)
	if SVMOD:IsVehicle(veh) and veh:SV_IsDriverSeat() then
		timer.Remove("SV_Fuel_Consumption_" .. veh:EntIndex())
	end
end

hook.Add("PlayerLeaveVehicle", "SV_Fuel_DisableConsumptionOnLeave", function(ply, veh)
	DisableFuel(veh)
end)

hook.Add("PlayerDisconnected", "SV_Fuel_DisableConsumptionOnDisconnect", function(ply)
	DisableFuel(ply:GetVehicle())
end)

hook.Add("SV_UnloadVehicle", "SV_Fuel_DisableConsumptionOnRemove", function(veh)
	DisableFuel(veh)
end)