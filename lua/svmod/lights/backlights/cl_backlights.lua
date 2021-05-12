net.Receive("SV_TurnBackLights", function()
	local veh = net.ReadEntity()
	if not SVMOD:IsVehicle(veh) then return end
	veh = veh:SV_GetDriverSeat()

	veh.SV_States.BackLights = net.ReadBool()

	if veh.SV_States.BackLights then
		veh.SV_IsReversing = false

		timer.Create("SV_DetectReversing_" .. veh:EntIndex(), 0.1, 0, function()
			if not SVMOD:IsVehicle(veh) then
				timer.Remove("SV_DetectReversing_" .. veh:EntIndex())
				return
			end

			local speed = veh:SV_GetSpeed()

			if veh.SV_PreviousSpeed and speed > veh.SV_PreviousSpeed then
				veh.SV_IsReversing = true

				-- Remove the timer because the vehicle can not brake after reversing.
				timer.Remove("SV_DetectReversing_" .. veh:EntIndex())
			else
				veh.SV_IsReversing = false
			end

			veh.SV_PreviousSpeed = speed
		end)
	else
		timer.Remove("SV_DetectReversing_" .. veh:EntIndex())

		veh.SV_PreviousSpeed = nil
	end
end)