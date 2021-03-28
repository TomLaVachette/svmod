include("shared.lua")

SWEP.pViewModel = ClientsideModel("models/props_equipment/gas_pump_p13.mdl", RENDERGROUP_OPAQUE)
SWEP.pViewModel:SetNoDraw(true)

-- local cable = Material( "cable/cable2" )

-- local function bezier(p0, p1, p2, p3, t)
-- 	local e = p0 + t * (p1 - p0)
-- 	local f = p1 + t * (p2 - p1)
-- 	local g = p2 + t * (p3 - p2)

-- 	local h = e + t * (f - e)
-- 	local i = f + t * (g - f)

-- 	local p = h + t * (i - h)

-- 	return p
-- end

function SWEP:PrimaryAttack()

end

function SWEP:StartFilling(veh)
	net.Start("SV_StartFilling")
	net.WriteEntity(veh)
	net.SendToServer()
end

function SWEP:StopFilling(veh)
	net.Start("SV_StopFilling")
	net.WriteEntity(veh)
	net.SendToServer()

	hook.Remove("Think", "SV_FillerPistol_" .. self:EntIndex())
end

function SWEP:DrawCable()
	-- local ply = self:GetOwner()

	-- local fuelPump = self:GetNWEntity("SV_FuelPump")
	-- if not IsValid(fuelPump) then
	-- 	return
	-- end

	-- local id = ply:LookupAttachment("anim_attachment_rh")
	-- local attachment = ply:GetAttachment( id )

	-- if not attachment then return end

	-- local a, b = self:GetModelBounds()

	-- local startPos = fuelPump:LocalToWorld((b + a) / 2 + Vector(0, 0, 50))
	-- local p2 = fuelPump:LocalToWorld((b + a) / 2)
	-- local endPos = (attachment.Pos + attachment.Ang:Forward() * -3 + attachment.Ang:Right() * 2 + attachment.Ang:Up() * -3.5)
	-- local p3 = endPos + attachment.Ang:Right() * 5 - attachment.Ang:Up() * 20

	-- for i = 1,10 do
	-- 	local active = IsValid( ply )

	-- 	local de = active and 1 or 2

	-- 	if (not active and i > 1) or active then

	-- 		local sp = bezier(startPos, p2, p3, endPos, (i - de) / 10)
	-- 		local ep = bezier(startPos, p2, p3, endPos, i / 10)

	-- 		render.SetMaterial( cable )
	-- 		render.DrawBeam( sp, ep, 2, 1, 1, Color( 100, 100, 100, 255 ) )
	-- 	end
	-- end
end

-- function SWEP:ViewModelDrawn()
-- 	if IsValid(self.Owner) then

-- 		local ZOOM = self.Owner:KeyDown( IN_ZOOM )

-- 		self.ViewModelFOV = ZOOM and 30 or 10

-- 		if ZOOM then return end

-- 		local vm = self.Owner:GetViewModel()
-- 		local bm = vm:GetBoneMatrix(0)
-- 		local pos =  bm:GetTranslation()
-- 		local ang =  bm:GetAngles()

-- 		pos = pos + ang:Up() * 220
-- 		pos = pos + ang:Right() * 2
-- 		pos = pos + ang:Forward() * -12

-- 		ang:RotateAroundAxis(ang:Forward(), -85)
-- 		ang:RotateAroundAxis(ang:Right(), -20)
-- 		ang:RotateAroundAxis(ang:Up(), -70)

-- 		self.pViewModel:SetPos(pos)
-- 		self.pViewModel:SetAngles(ang)
-- 		self.pViewModel:DrawModel()

-- 		self:DrawCable()
-- 	end
-- end

-- function SWEP:DrawWorldModel()
-- 	if not IsValid(self.Owner) then return end

-- 	local id = self.Owner:LookupAttachment("anim_attachment_rh")
-- 	local attachment = self.Owner:GetAttachment( id )

-- 	if not attachment then return end

-- 	local pos = attachment.Pos + attachment.Ang:Forward() * 6 + attachment.Ang:Right() * -1.5 + attachment.Ang:Up() * 2.2
-- 	local ang = attachment.Ang
-- 	ang:RotateAroundAxis(attachment.Ang:Up(), 20)
-- 	ang:RotateAroundAxis(attachment.Ang:Right(), -30)
-- 	ang:RotateAroundAxis(attachment.Ang:Forward(), 0)

-- 	self:SetRenderOrigin( pos )
-- 	self:SetRenderAngles( ang )

-- 	self:DrawModel()

-- 	self:DrawCable()
-- end