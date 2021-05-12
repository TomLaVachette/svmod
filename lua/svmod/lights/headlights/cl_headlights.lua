-- @class SVMOD
-- @clientside

-- Sets the state of the headlights of the vehicle
-- driven by the player.
-- @tparam boolean result True to enable the headlights, false to disable
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
	local veh = net.ReadEntity()
	if not SVMOD:IsVehicle(veh) then return end
	veh = veh:SV_GetDriverSeat()

	local state = net.ReadBool()

	if state then
		veh.SV_States.Headlights = true

		veh:EmitSound("svmod/headlight/switch_on.wav")
	else
		veh.SV_States.Headlights = false

		for _, v in ipairs(veh.SV_Data.Headlights) do
			if v.ProjectedTexture and IsValid(v.ProjectedTexture.Entity) then
				v.ProjectedTexture.Entity:Remove()
				v.ProjectedTexture.Entity = nil
			end
		end

		veh:EmitSound("svmod/headlight/switch_off.wav")
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