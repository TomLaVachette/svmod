SWEP.PrintName = "Filler pistol"
SWEP.Category = "SVMod"
SWEP.Author = "TomLaVachette"
SWEP.Contact = "From workshop page only!"
SWEP.Instructions = ""

SWEP.ViewModel = "models/weapons/v_slam.mdl"
SWEP.ViewModelFOV = 50
SWEP.WorldModel = "models/props_equipment/gas_pump_p13.mdl"
SWEP.UseHands = true
SWEP.HoldType = "slam"

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
	self.Weapon:SetHoldType(self.HoldType)
	if IsValid(self.Owner) then
		self.Owner.usedFuel = 0
	end
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end