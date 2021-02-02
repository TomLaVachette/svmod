--[[---------------------------------------------------------
   Name: SVMOD:SetHeadlightsState(int value = false)
   Type: Client
   Desc: Sets the state of the headlights of the vehicle
		 driven by the player.
-----------------------------------------------------------]]
function SVMOD:SetHeadlightsState(value)
	local veh = LocalPlayer():GetVehicle()
	if not SVMOD:IsVehicle(veh) or not veh:SV_IsDriverSeat() then
		return
	end

	if not value then
		value = false
	end

	net.Start("SV_SetHeadlightsState")
	net.WriteBool(value)
	net.SendToServer()
end

net.Receive("SV_TurnHeadlights", function()
	local Vehicle = net.ReadEntity()
	if not SVMOD:IsVehicle(Vehicle) then return end

	local State = net.ReadBool()

	if State then
		Vehicle.SV_States.Headlights = true

		Vehicle:EmitSound("svmod/headlight/switch_on.wav")
	else
		Vehicle.SV_States.Headlights = false

		for _, v in ipairs(Vehicle.SV_Data.Headlights) do
			if v.ProjectedTexture and IsValid(v.ProjectedTexture.Entity) then
				v.ProjectedTexture.Entity:Remove()
				v.ProjectedTexture.Entity = nil
			end
		end

		Vehicle:EmitSound("svmod/headlight/switch_off.wav")
	end
end)

hook.Add("EntityRemoved", "SV_RemoveHeadlights", function(ent)
	if not SVMOD:IsVehicle(ent) or not ent:SV_IsDriverSeat() then return end

	for _, v in pairs(ent.SV_Data.Headlights) do
		if v.ProjectedTexture and IsValid(v.ProjectedTexture.Entity) then
			v.ProjectedTexture.Entity:Remove()
		end
	end
end)