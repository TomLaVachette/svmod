util.AddNetworkString("SV_TurnHeadlights")

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_TurnOnHeadlights()
   Type: Server
   Desc: Turns on the headlights of a vehicle.
		 Returns true if the headlights have been switched
		 on, false otherwise. The operation will fail if the
		 headlights are already on, if the vehicle has no
		 headlights, or if the headlights have been disabled.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_TurnOnHeadlights()
	if not self.SV_IsEditMode and #self.SV_Data.Headlights == 0 then
		return false -- No headlight on this vehicle
	elseif not SVMOD.CFG.Lights.AreHeadlightsEnabled then
		return false -- Headlights disabled
	elseif self:SV_GetHeadlightsState() then
		return false -- Headlights already active
	end

	net.Start("SV_TurnHeadlights")
	net.WriteEntity(self)
	net.WriteBool(true)
	net.Broadcast()
	
	self.SV_States.Headlights = true

	return true
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_TurnOffHeadlights()
   Type: Server
   Desc: Turns off the headlights of a vehicle.
		 Returns true if the headlights have been switched
		 off, false otherwise. The operation will fail if the
		 headlights are already switched off.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_TurnOffHeadlights()
	if not self:SV_GetHeadlightsState() then
		return false -- Headlights already inactive
	end

	net.Start("SV_TurnHeadlights")
	net.WriteEntity(self)
	net.WriteBool(false)
	net.Broadcast()
	
	self.SV_States.Headlights = false

	return true
end

util.AddNetworkString("SV_SetHeadlightsState")
net.Receive("SV_SetHeadlightsState", function(_, ply)
	local Vehicle = ply:GetVehicle()
	if not SVMOD:IsVehicle(Vehicle) or not Vehicle:SV_IsDriverSeat() then return end

	local State = net.ReadBool()

	if State then
		Vehicle:SV_TurnOnHeadlights()
	else
		Vehicle:SV_TurnOffHeadlights()
	end
end)

local function DisableHeadlights(veh)
	if not SVMOD.CFG.Lights.TurnOffHeadlightsOnExit then return end

	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then return end

	timer.Create("SV_DisableHeadlights_" .. veh:EntIndex(), SVMOD.CFG.Lights.TimeTurnOffHeadlights, 1, function()
		if not SVMOD:IsVehicle(veh) then return end
		
		veh:SV_TurnOffHeadlights()
	end)
end

hook.Add("PlayerLeaveVehicle", "SV_DisableHeadlightsOnLeave", function(ply, veh)
	DisableHeadlights(veh)
end)

hook.Add("PlayerDisconnected", "SV_DisableHeadlightsOnDisconnect", function(ply, veh)
	DisableHeadlights(ply:GetVehicle())
end)

hook.Add("PlayerEnteredVehicle", "SV_UndoDisableHeadlightsOnLeave", function(ply, veh)
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	timer.Remove("SV_DisableHeadlights_" .. veh:EntIndex())
end)