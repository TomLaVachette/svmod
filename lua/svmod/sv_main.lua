-- @class SVMOD
-- @serverside

-- Enables SVMod. The next vehicles that appear will be
-- affected by the addon.
-- @treturn boolean True if successful, false otherwise
function SVMOD:Enable()
	-- Do not start SVMod if conflict detected
	if #self:GetConflictList() > 0 then
		self:PrintConsole(SVMOD.LOG.Error, "Unable to start SVMod: conflict detected.")
		self.CFG.IsEnabled = false
		return false
	end

	self.CFG.IsEnabled = true

	hook.Run("SV_Enabled")

	-- Send to clients
	net.Start("SV_SetAddonState")
	net.WriteBool(true)
	net.WriteUInt(SVMOD.CFG.Contributor.EnterpriseID, 16) -- max: 65535
	net.Broadcast()

	return true
end

-- Disables SVMod. The next vehicles that appear will no
-- longer be affected by the addon.
-- @treturn boolean True if successful, false otherwise
function SVMOD:Disable()
	self.CFG.IsEnabled = false

	hook.Run("SV_Disabled")

	-- Send to clients
	net.Start("SV_SetAddonState")
	net.WriteBool(false)
	net.Broadcast()
end

util.AddNetworkString("SV_GetAddonState")
net.Receive("SV_GetAddonState", function(_, ply)
	local state = SVMOD:GetAddonState()

	net.Start("SV_SetAddonState")
	net.WriteBool(state)
	if state then
		net.WriteUInt(SVMOD.CFG.Contributor.EnterpriseID, 16) -- max: 65535
	end
	net.Send(ply)
end)

util.AddNetworkString("SV_SetAddonState")
net.Receive("SV_SetAddonState", function(_, ply)
	CAMI.PlayerHasAccess(ply, "SV_EditOptions", function(hasAccess)
		if hasAccess then
			local state = net.ReadBool()

			if state then
				SVMOD:Enable()
			else
				SVMOD:Disable()
			end

			SVMOD:Save()
		end
	end)
end)

hook.Add("PlayerConnect", "SV_EnableAddon", function()
	-- Dirty fix if player join before Initialize hook
	hook.Remove("PlayerConnect", "SV_EnableAddon")
	SVMOD:Load()
	timer.Simple(5, function()
		if SVMOD.CFG.IsEnabled then
			SVMOD:Enable()
		end
	end)
end)

 concommand.Add("temp", function(ply)
 	local ent = ply:GetEyeTrace().Entity

 	--local size = 0
	 --
 	--ent:SetSpringLength(0, 499.95)
 	-- -- ent:SetSpringLength(1, 499.95)
 	-- -- ent:SetSpringLength(2, 499.95)
 	-- -- ent:SetSpringLength(3, 499.95)
	 --
 	--timer.Simple(2, function()
 	--	ent:SetSpringLength(0, 500.12)
 	--	ent:SetSpringLength(1, 500.12)
 	--	ent:SetSpringLength(2, 500.12)
 	--	ent:SetSpringLength(3, 500.12)
 	--end)

	 for i = 1, ent:GetWheelCount() do
		 local tyre = ent:GetWheel(i)

		 if tyre:IsValid() then
			 ent:SetSpringLength(i - 1, 500.08 + 0.1)
		 end
	 end
 end)