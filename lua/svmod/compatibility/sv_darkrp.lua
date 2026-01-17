hook.Add("canDropWeapon", "SV_DoNotDropGasolinePistol", function(ply, weapon)
    -- Check if weapon entity is valid before calling GetClass()
    if not IsValid(weapon) then
        return
    end
    
    if weapon:GetClass() == "weapon_gasolinepistol" then
        return false
    end
end)
