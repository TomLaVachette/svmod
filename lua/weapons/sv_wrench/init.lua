include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function SWEP:PrimaryAttack()
	if game.SinglePlayer() then
		self:CallOnClient("PrimaryAttack")
	end

	self:SetNextPrimaryFire(CurTime() + 1)
end

util.AddNetworkString("SV_Parts")
function SWEP:SecondaryAttack()
	if game.SinglePlayer() then
		self:CallOnClient("SecondaryAttack")
	end

	local Vehicle = self:GetOwner():GetEyeTrace().Entity
	if not SVMOD:IsVehicle(Vehicle) then return end

	-- Too far away
	if Vehicle:GetPos():DistToSqr(self:GetOwner():EyePos()) > 30000 then return end

	self:SetNextSecondaryFire(CurTime() + 1)

	if not Vehicle.SV_Data.Parts or #Vehicle.SV_Data.Parts == 0 then return end

	Vehicle:SV_SendParts(self:GetOwner())
end