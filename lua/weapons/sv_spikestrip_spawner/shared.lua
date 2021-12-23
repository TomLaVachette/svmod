SWEP.Category 		= "SVMod"
SWEP.Instructions   = "Left click to deploy spike strips, USE to collect them."
SWEP.ViewModel      = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel 	= "models/weapons/w_package.mdl"
SWEP.HoldType 		= "normal"
SWEP.Spawnable		= true
SWEP.UseHands 		= true

SWEP.Primary.Recoil		= 5
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 1.5

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"
SWEP.ShellDelay			= 0

SWEP.Sequence			= 0

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false


function SWEP:PrimaryAttack()
	local tr = {}
		tr.start = self.Owner:GetShootPos()
		tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
		tr.filter = {self.Owner}
		local trace = util.TraceLine(tr)
		if trace.Hit and trace.HitNormal.z > 0.95 then
			local spikestrip = ents.Create("sv_spikestrip")
			spikestrip:SetPos(trace.HitPos)
			spikestrip:SetAngles( Angle(0,90 + self:GetAngles().y,0) )
			spikestrip:Spawn()
			self:Remove()
			self:SetNextPrimaryFire(CurTime() + 1)
		end

end
