--[[---------------------------------------------------------
   Name: SVMOD:Enable()
   Type: Server
   Desc: Enables SVMod. The next vehicles that appear will be
         affected by the addon.
-----------------------------------------------------------]]
function SVMOD:Enable()
    -- Do not start SVMod if conflict detected
    if #self:GetConflictList() > 0 then
        self:PrintConsole(SVMOD.LOG.Error, SVMOD:GetLanguage("Unable to start SVMod: conflict detected."))
        self.CFG.IsEnabled = false
        return false
    end

    self.CFG.IsEnabled = true

    hook.Run("SV_Enabled")

    -- Send to clients
    net.Start("SV_SetAddonState")
    net.WriteBool(true)
    net.Broadcast()

    return true
end

--[[---------------------------------------------------------
   Name: SVMOD:Disable()
   Type: Server
   Desc: Disables SVMod. The next vehicles that appear will no
         longer be affected by the addon.
-----------------------------------------------------------]]
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
    net.Start("SV_SetAddonState")
    net.WriteBool(SVMOD:GetAddonState())
    net.Send(ply)
end)

util.AddNetworkString("SV_SetAddonState")
net.Receive("SV_SetAddonState", function(_, ply)
    if not ply:IsSuperAdmin() then
        return
    end

    local State = net.ReadBool()
    if State then
        SVMOD:Enable()
    else
        SVMOD:Disable()
    end
end)

hook.Add("PlayerConnect", "SV_EnableAddon", function()
    if SVMOD.CFG.IsEnabled then
        SVMOD:Enable()
    end
    hook.Remove("PlayerConnect", "SV_EnableAddon")
end)