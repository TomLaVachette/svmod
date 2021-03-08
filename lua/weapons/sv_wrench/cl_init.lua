include("shared.lua")

function SWEP:Initialize()
	if self:GetOwner() ~= LocalPlayer() then return end


end

function SWEP:OnRemove()
	if self:GetOwner() ~= LocalPlayer() then return end

	-- hook.Remove("PostDrawTranslucentRenderables", "SV_WrenchHUD")
end

function SWEP:PrimaryAttack()
	local Vehicle = self:GetOwner():GetEyeTrace().Entity
	if Vehicle ~= SVMOD.VehicleRenderedParts then return end

	if not Vehicle.SV_Data.Parts or #Vehicle.SV_Data.Parts == 0 then return end

	local BestDistance = 6000
	local Index

	for i, p in ipairs(Vehicle.SV_Data.Parts) do
		local Distance = Vehicle:LocalToWorld(p.Position):DistToSqr(self:GetOwner():GetPos())
		if Distance < BestDistance then
			BestDistance = Distance
			Index = i
		end
	end

	if not Index then return end

	-- Already full health
	if Vehicle.SV_Data.Parts[Index].Health == 100 then return end

	net.Start("SV_StartRepair")
	net.WriteEntity(Vehicle)
	net.WriteUInt(Index, 4) -- max: 15
	net.SendToServer()

	hook.Add("Think", "SV_Wrench", function()
		if not IsValid(self) then
			hook.Remove("Think", "SV_Wrench")
		elseif not self:GetOwner():KeyDown(IN_ATTACK) then
			net.Start("SV_StopRepair")
			net.WriteEntity(Vehicle)
			net.SendToServer()

			hook.Remove("Think", "SV_Wrench")
		end
	end)
end

function SWEP:SecondaryAttack()
	local Vehicle = self:GetOwner():GetEyeTrace().Entity
	if not SVMOD:IsVehicle(Vehicle) then return end

	if not Vehicle.SV_Data.Parts or #Vehicle.SV_Data.Parts == 0 then return end

	-- Too far away
	if Vehicle:GetPos():DistToSqr(self:GetOwner():EyePos()) > 30000 then return end

	SVMOD.VehicleRenderedParts = Vehicle
end

function SWEP:Holster()
	if self:GetOwner() == LocalPlayer() then
		SVMOD.VehicleRenderedParts = nil
	end
end