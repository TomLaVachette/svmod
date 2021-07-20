-- VC_VehCanEnter has compatibility issues that impact seats switch from inside a vehicle.
function SVMOD:Compatiblity_VCMod_Seat_Fix()
	hook.Remove("CanPlayerEnterVehicle", "VC_VehCanEnter")
end

-- Players scrubbing vehicles could get killed without this fix.
hook.Add("EntityTakeDamage", "SV_CollisionFix", function(target, dmg)
	if target:IsPlayer() and dmg:GetAttacker() == game.GetWorld() and dmg:GetDamageType() == 1 then
		dmg:SetDamage(0)
	end
end)

-- Allow player to shot bullets in vehicle
hook.Add("EntityFireBullets", "SV_BulletsFix", function(ent, data)
	if not IsValid(ent) or not ent:IsPlayer() or not ent:InVehicle() then return end

	data.Src = data.Src + 50 * data.Dir

	return true
end)

hook.Add("PlayerSwitchWeapon", "SV_BlacklistedWeapons", function(ply, old, new)
	if not IsValid(ply) or not ply:IsPlayer() or not ply:InVehicle() or not IsValid(new) or not SVMOD.FCFG.BlacklistedWeapons[new:GetClass()] then return end

	return true
end)