include("shared.lua")

function SWEP:GetViewModelPosition(pos, ang)
    local offset = self.ViewModelPos
    local rotate = self.ViewModelAng

    local animFrac = 0
    if self.AnimKeyTime and self.AnimKeyTime > CurTime() then
        animFrac = 1 - ((self.AnimKeyTime - CurTime()) / self.AnimKeyDuration)
        animFrac = math.Clamp(animFrac, 0, 1)
    end

    pos = pos + ang:Forward() * offset.x
    pos = pos + ang:Right() * offset.y
    pos = pos + ang:Up() * offset.z

    ang:RotateAroundAxis(ang:Right(), rotate.p)
    ang:RotateAroundAxis(ang:Up(), rotate.y)
    ang:RotateAroundAxis(ang:Forward(), rotate.r)

    if animFrac > 0 then
        local clickIntensity = math.sin(animFrac * math.pi)
        local clickOffset = clickIntensity * -0.50
        local clickRotation = clickIntensity * 20
        
        pos = pos + ang:Forward() * clickOffset
        ang:RotateAroundAxis(ang:Forward(), clickRotation)
    end

    local breathe = math.sin(CurTime() * 2) * 0.1
    pos = pos - ang:Forward() * breathe 
    pos = pos + ang:Up() * breathe

    return pos, ang
end

function SWEP:DrawWorldModel()
    local owner = self:GetOwner()

    if not IsValid(owner) then
        self:DrawModel()
        return
    end

    local boneindex = owner:LookupBone("ValveBiped.Bip01_R_Hand")
    
    if not boneindex then
        self:DrawModel()
        return
    end

    local pos, ang = owner:GetBonePosition(boneindex)
    
    pos = pos + ang:Right() * 2
    pos = pos + ang:Forward() * 2.9
    pos = pos + ang:Up() * -1.6
    
    ang:RotateAroundAxis(ang:Right(), 165)
    
    self:SetRenderOrigin(pos)
    self:SetRenderAngles(ang)
    
    local mat = Matrix()
    mat:Scale(Vector(2.7, 2.7, 2.7))
    
    self:EnableMatrix("RenderMultiply", mat)
    self:DrawModel()
    self:DisableMatrix("RenderMultiply")
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end

    self.AnimKeyTime = CurTime() + self.AnimKeyDuration

    self:SetNextPrimaryFire(CurTime() + self.PrimaryFireDelay)
end