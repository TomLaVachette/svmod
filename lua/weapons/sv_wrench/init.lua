include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function SWEP:PrimaryAttack()
	if game.SinglePlayer() then
		self:CallOnClient("PrimaryAttack")
	end
end

function SWEP:SecondaryAttack()
	if game.SinglePlayer() then
		self:CallOnClient("SecondaryAttack")
	end
end

function SWEP:Reload()
	local veh = self:GetOwner():GetEyeTrace().Entity
	if not SVMOD:IsVehicle(veh) then
		return
	end

	CAMI.PlayerHasAccess(ply, "SV_RepairVehicle", function(hasAccess)
		if hasAccess then
			if not SVMOD:IsVehicle(veh) then
				return
			end

			veh:SV_FullRepair()
		end
	end)
end