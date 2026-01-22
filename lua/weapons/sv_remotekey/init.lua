AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.PrimaryFireDelay)
    self.Owner:DoAttackEvent()
    
    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    ply:EmitSound("svmod/key_click.wav", 100, 100)

    local tr = ply:GetEyeTrace()
    local veh = tr.Entity

    if not IsValid(veh) or not veh:IsVehicle() then return end
    
    if SVMOD and not SVMOD:IsVehicle(veh) then return end

    if tr.HitPos:DistToSqr(ply:GetShootPos()) > self.MaxUseDistanceSqr then return end

    local isOwner = self:IsVehicleOwner(ply, veh)
    if not isOwner then return end

    if veh:SV_IsLocked() then
        veh:SV_Unlock()
    else
        veh:SV_Lock()
    end
end

function SWEP:IsVehicleOwner(ply, veh)
    if veh.isKeysOwnedBy and veh:isKeysOwnedBy(ply) then
        return true
    end
    
    if veh:GetOwner() == ply then
        return true
    end
    
    if veh.CPPIGetOwner then
        local owner = veh:CPPIGetOwner()
        if IsValid(owner) and owner == ply then
            return true
        end
    end
    
    return false
end