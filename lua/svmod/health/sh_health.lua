--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetHealth()
   Type: Shared
   Desc: Returns the vehicle health.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetHealth()
    local Vehicle = self:SV_GetDriverSeat()

    if not Vehicle.SV_Data.Parts or #Vehicle.SV_Data.Parts == 0 then
        return 0
    end

    local Health = 0

    for _, p in ipairs(Vehicle.SV_Data.Parts) do
        Health = Health + p.Health
    end

    return Health / #Vehicle.SV_Data.Parts
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetMaxHealth()
   Type: Shared
   Desc: Returns the vehicle max health.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetMaxHealth()
    local Vehicle = self:SV_GetDriverSeat()

    return Vehicle:GetMaxHealth()
end

--[[---------------------------------------------------------
   Name: SV_Vehicle:SV_GetPercentHealth()
   Type: Shared
   Desc: Returns the vehicle health as a percentage.
-----------------------------------------------------------]]
function SVMOD.Metatable:SV_GetPercentHealth()
    return self:SV_GetHealth() / self:SV_GetMaxHealth() * 100
end