util.AddNetworkString("SV_Settings")

concommand.Add("svmod", function(ply)
	CAMI.PlayerHasAccess(ply, "SV_EditOptions", function(hasAccess)
		if not IsValid(ply) then
			return
		end

		net.Start("SV_Settings")

		net.WriteBool(hasAccess)

		net.WriteBool(SVMOD.CFG.IsEnabled)
		net.WriteString(SVMOD.CFG.VehicleDataUpdateTime or "")
		net.WriteString(SVMOD:GetConflictList())

		if hasAccess then
			net.WriteBool(SVMOD.CFG["Seats"]["IsSwitchEnabled"])
			net.WriteBool(SVMOD.CFG["Seats"]["IsKickEnabled"])
			net.WriteBool(SVMOD.CFG["Seats"]["IsLockEnabled"])
		
			net.WriteBool(SVMOD.CFG["Lights"]["AreHeadlightsEnabled"])
			net.WriteBool(SVMOD.CFG["Lights"]["TurnOffHeadlightsOnExit"])
			net.WriteFloat(SVMOD.CFG["Lights"]["TimeTurnOffHeadlights"])
			net.WriteBool(SVMOD.CFG["Lights"]["AreHazardLightsEnabled"])
			net.WriteBool(SVMOD.CFG["Lights"]["TurnOffHazardOnExit"])
			net.WriteFloat(SVMOD.CFG["Lights"]["TimeTurnOffHazard"])
			net.WriteBool(SVMOD.CFG["Lights"]["AreReverseLightsEnabled"])
		
			net.WriteBool(SVMOD.CFG["ELS"]["AreFlashingLightsEnabled"])
			net.WriteBool(SVMOD.CFG["ELS"]["TurnOffFlashingLightsOnExit"])
			net.WriteFloat(SVMOD.CFG["ELS"]["TimeTurnOffFlashingLights"])
		
			net.WriteBool(SVMOD.CFG["Horn"]["IsEnabled"])
		
			net.WriteFloat(SVMOD.CFG["Damage"]["PhysicsMultiplier"])
			net.WriteFloat(SVMOD.CFG["Damage"]["BulletMultiplier"])
			net.WriteFloat(SVMOD.CFG["Damage"]["CarbonisedChance"])
			net.WriteFloat(SVMOD.CFG["Damage"]["SmokePercent"])
			net.WriteFloat(SVMOD.CFG["Damage"]["DriverMultiplier"])
			net.WriteFloat(SVMOD.CFG["Damage"]["PassengerMultiplier"])
			net.WriteFloat(SVMOD.CFG["Damage"]["PlayerExitMultiplier"])
		
			net.WriteBool(SVMOD.CFG["Fuel"]["IsEnabled"])
			net.WriteFloat(SVMOD.CFG["Fuel"]["Multiplier"])
		end
	
		net.Send(ply)
	end)
end)

local readTypes = {
	[0] = net.ReadBool,
	[1] = net.ReadFloat
}

net.Receive("SV_Settings", function(_, ply)
	local category = net.ReadString()
	local name = net.ReadString()
	local type = net.ReadUInt(2)

	CAMI.PlayerHasAccess(ply, "SV_EditOptions", function(hasAccess)
		if hasAccess then
			if type == 0 then
				SVMOD.CFG[category][name] = net.ReadBool()
			else
				SVMOD.CFG[category][name] = math.Round(net.ReadFloat(), 2)
			end
		
			SVMOD:Save()
		end
	end)
end)