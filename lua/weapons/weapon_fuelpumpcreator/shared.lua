SWEP.PrintName = "Fuel Pump Creator"
SWEP.Category = "SVMod"
SWEP.Author = "TomLaVachette"
SWEP.Contact = "From workshop page only!"
SWEP.Instructions = "?"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.ViewModelFOV = 50
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true

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

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:DrawWorldModel()
	return true
end