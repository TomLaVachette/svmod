-- Model 3D : "Electronic Car Key" (https://skfb.ly/6UYyH) by neeb17 CC BY 4.0

AddCSLuaFile()

SWEP.PrintName = "Remote Key"
SWEP.Author = "TomLaVachette (Model 3D: neeb17 - CC BY 4.0)"
SWEP.Category = "SVMod"
SWEP.Instructions = "Left click to lock/unlock vehicles."

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/svmod/sv_key/sv_key.mdl"
SWEP.WorldModel = "models/svmod/sv_key/sv_key.mdl"
SWEP.UseHands = false

SWEP.Primary = {
    ClipSize = -1,
    DefaultClip = -1,
    Automatic = false,
    Ammo = "none"
}

SWEP.Secondary = {
    ClipSize = -1,
    DefaultClip = -1,
    Automatic = false,
    Ammo = "none"
}

SWEP.ViewModelPos = Vector(8, 3, -3)
SWEP.ViewModelAng = Angle(70, 180, 0)

SWEP.AnimKeyDuration = 0.75
SWEP.PrimaryFireDelay = 0.75

SWEP.MaxUseDistance = 450
SWEP.MaxUseDistanceSqr = SWEP.MaxUseDistance * SWEP.MaxUseDistance

function SWEP:Initialize()
    self:SetHoldType("slam")
    self.AnimKeyTime = 0
end