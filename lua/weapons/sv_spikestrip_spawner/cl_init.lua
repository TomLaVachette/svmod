include('shared.lua')
SWEP.PrintName			= 'Spike Strip'
SWEP.Slot				= 2
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false

local previewModel

function SWEP:Think()
    if IsValid(previewModel) then
        local tr = {}
        tr.start = LocalPlayer():GetShootPos()
        tr.endpos = LocalPlayer():GetShootPos() + 200 * LocalPlayer():GetAimVector()
        tr.filter = {LocalPlayer()}
        local trace = util.TraceLine(tr)
        previewModel:SetPos(trace.HitPos)
        previewModel:SetAngles(Angle(0, LocalPlayer():GetAngles().y, 0))
    else
        previewModel = ClientsideModel('models/novacars/spikestrip/spikestrip.mdl', RENDERGROUP_BOTH)
        previewModel:SetRenderMode(RENDERMODE_TRANSCOLOR)
        previewModel:SetColor(Color(0, 255, 0, 150))
    end
end

function SWEP:OnRemove()
    if previewModel then
        previewModel:Remove()
        previewModel = nil
    end
end

function SWEP:Holster(weapon)
    if IsValid(previewModel) then
        previewModel:Remove()
        previewModel = nil
    end
    return true
end