--[[---------------------------------------------------------
   Name: Vehicle:SV_SetFuel()
   Type: Server
   Desc: Sets the vehicule fuel in liters.
-----------------------------------------------------------]]
util.AddNetworkString("SV_SetFuel")
function SVMOD.Metatable:SV_SetFuel(value)
	local Vehicle = self
	if self:SV_IsPassengerSeat() then
		Vehicle = self:SV_GetDriverSeat()
	end

	local MaxFuel = Vehicle:SV_GetMaxFuel()

	value = math.Round(math.Clamp(value, 0, MaxFuel), 2)

	-- Out of fuel sound when we go below 20%
	if value > 0 and Vehicle:SV_GetPercentFuel() > 20 and (value / MaxFuel * 100) <= 20 then
		Vehicle:EmitSound("svmod/out_of_fuel.wav")
	end

	Vehicle.SV_Fuel = value
	
	net.Start("SV_SetFuel")
	net.WriteEntity(Vehicle)
	net.WriteFloat(Vehicle.SV_Fuel)
	net.Send(Vehicle:SV_GetAllPlayers())

	-- Out of fuel
	if value <= 0 then
		Vehicle:EnableEngine(false)
		Vehicle:StartEngine(false)
		Vehicle:EmitSound("svmod/out_of_fuel.wav")

		hook.Run("SV_OutOfFuel", Vehicle)
	end
end

--[[---------------------------------------------------------
   Name: Vehicle:SV_SetMaxFuel()
   Type: Server
   Desc: Sets the vehicule max fuel in liters.
-----------------------------------------------------------]]
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

util.AddNetworkString("SV_GetFuel")
hook.Add("PlayerEnteredVehicle", "SV_Fuel_SendFuel", function(ply, veh)
	if not SVMOD:IsVehicle(veh) then return end

	local Vehicle = veh:SV_GetDriverSeat()

	net.Start("SV_GetFuel")
	net.WriteEntity(Vehicle)
	net.WriteFloat(Vehicle:SV_GetFuel())
	net.WriteFloat(Vehicle:SV_GetMaxFuel())
	net.Send(ply)
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
		local NewFuel = veh:SV_GetFuel() - (veh:GetPos():Distance(veh.SV_LastPosition) * 0.01905 * 0.004 * (veh.SV_Data.Fuel.Consumption or 5) * SVMOD.CFG.Fuel.Multiplier)
		veh:SV_SetFuel(NewFuel)

		if NewFuel <= 0 then
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