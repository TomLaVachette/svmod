AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/barney.mdl")
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE, CAP_TURN_HEAD)
    self:SetMaxYawSpeed(90)
    self:DropToFloor()
end

function ENT:Use(ply)
    local veh
    for _, v in ipairs(ents.FindInSphere(self:GetPos(), 320)) do
        if v:GetClass() ~= "prop_vehicle_jeep" then continue end

        veh = v
        break
    end

    if not IsValid(veh) then
        ply:PrintMessage(HUD_PRINTTALK, "There is no vehicle nearby")
        return
    end

    if veh:SV_GetPercentHealth() > 99 then
        ply:PrintMessage(HUD_PRINTTALK, "Your vehicle is already in good condition")
        return
    end

    veh:SV_FullRepair()
    veh:SV_SetFuel(veh:SV_GetMaxFuel())

    ply:PrintMessage(HUD_PRINTTALK, "Your vehicle has been repaired")
end

function ENT:SpawnFunction(ply, tr, class)
    if not tr.Hit then return end
    
    local spawnAng = ply:EyeAngles()
    spawnAng.p = 0
    spawnAng.y = spawnAng.y + 180

    local ent = ents.Create(class)
    ent:SetPos(tr.HitPos + tr.HitNormal * 16)
    ent:SetAngles(spawnAng)
    ent:Spawn()
    ent:Activate()

    return ent
end