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