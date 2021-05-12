-- @class SVMOD
-- @clientside

-- Sets the state of the left blinker of the vehicle
-- driven by the player.
-- @tparam boolean result True to enable the left blinker, false to disable
function SVMOD:SetLeftBlinkerState(value)
	local veh = LocalPlayer():GetVehicle()
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then return end

	if not value then
		value = false
	end

	net.Start("SV_SetLeftBlinkerState")
	net.WriteBool(value)
	net.SendToServer()
end

-- Sets the state of the right blinker of the vehicle
-- driven by the player.
-- @tparam boolean result True to enable the right blinker, false to disable
function SVMOD:SetRightBlinkerState(value)
	local Vehicle = LocalPlayer():GetVehicle()
	if not SVMOD:IsVehicle(Vehicle) or not Vehicle:SV_IsDriverSeat() then return end

	if not value then
		value = false
	end

	net.Start("SV_SetRightBlinkerState")
	net.WriteBool(value)
	net.SendToServer()
end

net.Receive("SV_TurnLeftBlinker", function()
	local veh = net.ReadEntity()
	if not SVMOD:IsVehicle(veh) then return end
	veh = veh:SV_GetDriverSeat()

	veh.SV_States.LeftBlinkers = net.ReadBool()
	veh.SV_States.RightBlinkers = false

	if veh.SV_States.LeftBlinkers then
		veh:EmitSound("svmod/blinker/switch_on.wav")
	else
		veh:EmitSound("svmod/blinker/switch_off.wav")
	end
end)

net.Receive("SV_TurnRightBlinker", function()
	local veh = net.ReadEntity()
	if not SVMOD:IsVehicle(veh) then return end
	veh = veh:SV_GetDriverSeat()

	veh.SV_States.RightBlinkers = net.ReadBool()
	veh.SV_States.LeftBlinkers = false

	if veh.SV_States.RightBlinkers then
		veh:EmitSound("svmod/blinker/switch_on.wav")
	else
		veh:EmitSound("svmod/blinker/switch_off.wav")
	end
end)

hook.Add("SV_PlayerEnteredVehicle", "SV_AddBlinkerDisablerHook", function(_, veh)
	if not SVMOD.CFG.Lights.DisableBlinkersOnTurn then return end

	hook.Add("VehicleMove", "SV_BlinkerDisabler", function(ply, veh, mv)
		if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
			hook.Remove("VehicleMove", "SV_BlinkerDisabler")
			return
		end

		if veh:SV_GetLeftBlinkerState() and mv:KeyReleased(IN_MOVELEFT) then
			SVMOD:SetLeftBlinkerState(false)
		elseif veh:SV_GetRightBlinkerState() and mv:KeyReleased(IN_MOVERIGHT) then
			SVMOD:SetRightBlinkerState(false)
		end
	end)
end)

hook.Add("SV_PlayerLeaveVehicle", "SV_RemoveBlinkerDisablerHook", function()
	hook.Remove("VehicleMove", "SV_BlinkerDisabler")
end)