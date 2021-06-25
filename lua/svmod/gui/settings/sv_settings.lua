util.AddNetworkString("SV_Settings")
util.AddNetworkString("SV_Settings_GetFuelPump")
util.AddNetworkString("SV_Settings_HardReset")

util.AddNetworkString("SV_Settings_GetFuelPumpCreatorPistol")

concommand.Add("svmod", function(ply)
	CAMI.PlayerHasAccess(ply, "SV_EditOptions", function(hasAccess)
		if not IsValid(ply) then
			return
		end

		net.Start("SV_Settings")

		net.WriteBool(hasAccess)

		net.WriteBool(SVMOD.CFG.IsEnabled)
		net.WriteString(SVMOD.VehicleDataUpdateTime or "")
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
			net.WriteFloat(SVMOD.CFG["ELS"]["TimeTurnOffSound"])

			net.WriteBool(SVMOD.CFG["Horn"]["IsEnabled"])

			net.WriteFloat(SVMOD.CFG["Damage"]["PhysicsMultiplier"])
			net.WriteFloat(SVMOD.CFG["Damage"]["BulletMultiplier"])
			net.WriteFloat(SVMOD.CFG["Damage"]["CarbonisedChance"])
			net.WriteFloat(SVMOD.CFG["Damage"]["SmokePercent"])
			net.WriteFloat(SVMOD.CFG["Damage"]["WheelShotMultiplier"])
			net.WriteFloat(SVMOD.CFG["Damage"]["WheelCollisionMultiplier"])
			net.WriteFloat(SVMOD.CFG["Damage"]["TimeBeforeWheelIsPunctured"])
			net.WriteFloat(SVMOD.CFG["Damage"]["DriverMultiplier"])
			net.WriteFloat(SVMOD.CFG["Damage"]["PassengerMultiplier"])
			net.WriteFloat(SVMOD.CFG["Damage"]["PlayerExitMultiplier"])

			net.WriteBool(SVMOD.CFG["Fuel"]["IsEnabled"])
			net.WriteFloat(SVMOD.CFG["Fuel"]["Multiplier"])

			net.WriteBool(SVMOD.CFG["Others"]["IsHUDEnabled"])
			net.WriteFloat(SVMOD.CFG["Others"]["HUDPositionX"])
			net.WriteFloat(SVMOD.CFG["Others"]["HUDPositionY"])
			net.WriteUInt(SVMOD.CFG["Others"]["HUDSize"], 9) -- max: 511
			net.WriteColor(SVMOD.CFG["Others"]["HUDColor"])
			net.WriteFloat(SVMOD.CFG["Others"]["CustomSuspension"])

			net.WriteFloat(SVMOD.CFG["Contributor"]["EnterpriseID"])
		end

		net.Send(ply)
	end)
end)

net.Receive("SV_Settings_GetFuelPump", function(_, ply)
	net.Start("SV_Settings_GetFuelPump")

	net.WriteUInt(#SVMOD.CFG["Fuel"]["Pumps"], 5) -- max: 31

	for _, v in ipairs(SVMOD.CFG["Fuel"]["Pumps"]) do
		net.WriteString(v.Model)
		net.WriteBool(v.MapCreationID >= 0)
		net.WriteUInt(v.MapCreationID, 16) -- max: 65535
		net.WriteVector(v.Position)
		net.WriteAngle(v.Angles)
		net.WriteUInt(v.Price, 16) -- max: 65535
	end

	net.Send(ply)
end)

net.Receive("SV_Settings_GetFuelPumpCreatorPistol", function(_, ply)
	CAMI.PlayerHasAccess(ply, "SV_EditOptions", function(hasAccess)
		if hasAccess then
			ply:Give("weapon_fuelpumpcreator")
		end
	end)
end)

net.Receive("SV_Settings_HardReset", function(_, ply)
	local bool = net.ReadBool()
	if not bool then
		-- anti netscan
		return
	end

	CAMI.PlayerHasAccess(ply, "SV_EditOptions", function(hasAccess)
		if hasAccess then
			SVMOD:Disable()
			SVMOD:ResetConfiguration()
			SVMOD:Save()
			SVMOD:Enable()
		end
	end)
end)

net.Receive("SV_Settings", function(_, ply)
	local category = net.ReadString()
	local name = net.ReadString()
	local type = net.ReadUInt(2)

	CAMI.PlayerHasAccess(ply, "SV_EditOptions", function(hasAccess)
		if hasAccess then
			if type == 0 then
				SVMOD.CFG[category][name] = net.ReadBool()
			elseif type == 1 then
				SVMOD.CFG[category][name] = math.Round(net.ReadFloat(), 2)
			else
				-- 2
				SVMOD.CFG[category][name] = net.ReadColor()
			end

			-- Realtime HUD update
			if name == "IsHUDEnabled" or string.StartWith(name, "HUD") then
				SVMOD:SendHUDConfiguration()
			end

			SVMOD:Save()
		end
	end)
end)