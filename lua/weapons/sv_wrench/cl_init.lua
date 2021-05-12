include("shared.lua")

function SWEP:PrimaryAttack()
	local veh = self:GetOwner():GetEyeTrace().Entity
	if veh ~= SVMOD.VehicleRenderedParts then return end

	if not veh.SV_Data.Parts or #veh.SV_Data.Parts == 0 then return end

	local bestDistance = 6000
	local index

	for i, p in ipairs(veh.SV_Data.Parts) do
		local distance = veh:LocalToWorld(p.Position):DistToSqr(self:GetOwner():GetPos())
		if distance < bestDistance then
			bestDistance = distance
			index = i
		end
	end

	if not index then return end

	-- Already full health
	if veh.SV_Data.Parts[index]:GetHealth() == 100 then return end

	net.Start("SV_StartRepair")
	net.WriteEntity(veh)
	net.WriteUInt(index, 4) -- max: 15
	net.SendToServer()

	hook.Add("Think", "SV_Wrench", function()
		if not IsValid(self) then
			hook.Remove("Think", "SV_Wrench")
		elseif not self:GetOwner():KeyDown(IN_ATTACK) then
			net.Start("SV_StopRepair")
			net.WriteEntity(veh)
			net.SendToServer()

			hook.Remove("Think", "SV_Wrench")
		end
	end)
end

function SWEP:SecondaryAttack()
	local veh = self:GetOwner():GetEyeTrace().Entity
	if not SVMOD:IsVehicle(veh) then return end

	if not veh.SV_Data.Parts or #veh.SV_Data.Parts == 0 then return end

	-- Too far away
	if veh:GetPos():DistToSqr(self:GetOwner():EyePos()) > 45000 then return end

	SVMOD.VehicleRenderedParts = veh
end

function SWEP:Holster()
	if self:GetOwner() == LocalPlayer() then
		SVMOD.VehicleRenderedParts = nil
	end
end