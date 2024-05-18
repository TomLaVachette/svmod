hook.Add("canDropWeapon", "SV_DoNotDropGasolinePistol", function(ply, weapon)
    if weapon:GetClass() == "weapon_gasolinepistol" then
        return false
    end
end)