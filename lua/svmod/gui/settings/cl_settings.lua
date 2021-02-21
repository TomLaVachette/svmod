net.Receive("SV_Settings", function()
	local data = {}

	data.HasAccess = net.ReadBool()

	data.Status = net.ReadBool()
	data.LastVehicleUpdate = net.ReadString()
	data.ConflictList = net.ReadString()

	if data.HasAccess then
		data.IsSwitchEnabled = net.ReadBool()
		data.IsKickEnabled = net.ReadBool()
		data.IsLockEnabled = net.ReadBool()

		data.AreHeadlightsEnabled = net.ReadBool()
		data.TurnOffHeadlightsOnExit = net.ReadBool()
		data.TimeTurnOffHeadlights = net.ReadFloat()
		data.AreHazardLightsEnabled = net.ReadBool()
		data.TurnOffHazardOnExit = net.ReadBool()
		data.TimeTurnOffHazard = net.ReadFloat()
		data.AreReverseLightsEnabled = net.ReadBool()

		data.AreFlashingLightsEnabled = net.ReadBool()
		data.TurnOffLightsOnExit = net.ReadBool()
		data.TimeTurnOffLights = net.ReadFloat()
		data.TurnOffSoundOnExit = net.ReadBool()
		data.TimeTurnOffSound = net.ReadFloat()

		data.HornIsEnabled = net.ReadBool()

		data.PhysicsMultiplier = math.Round(net.ReadFloat(), 2)
		data.BulletMultiplier = math.Round(net.ReadFloat(), 2)
		data.CarbonisedChance = math.Round(net.ReadFloat(), 2)
		data.SmokePercent = math.Round(net.ReadFloat(), 2)
		data.DriverMultiplier = math.Round(net.ReadFloat(), 2)
		data.PassengerMultiplier = math.Round(net.ReadFloat(), 2)
		data.PlayerExitMultiplier = math.Round(net.ReadFloat(), 2)

		data.FuelIsEnabled = net.ReadBool()
		data.FuelMultiplier = math.Round(net.ReadFloat(), 2)
	end

	local frame = SVMOD:CreateFrame("SVMOD : SIMPLE VEHICLE MOD 1.2")
	frame:SetSize(900, 650)
	frame:MakePopup()

	frame:CreateMenuButton(SVMOD:GetLanguage("HOME"), TOP, function()
		SVMOD:GUI_Home(frame:GetCenterPanel(), data)
	end)

	frame:CreateMenuButton(SVMOD:GetLanguage("SHORTCUTS"), TOP, function()
		SVMOD:GUI_Shortcuts(frame:GetCenterPanel(), data)
	end)

	frame:CreateMenuButton(SVMOD:GetLanguage("OPTIONS"), TOP, function()
		SVMOD:GUI_Options(frame:GetCenterPanel(), data)
	end)

	frame:CreateMenuButton(SVMOD:GetLanguage("VEHICLES"), TOP, function()
		SVMOD:GUI_Vehicles(frame:GetCenterPanel(), data)
	end)

	SVMOD:CreateHorizontalLine(frame:GetLeftPanel())

	if data.HasAccess then
		frame:CreateMenuButton(SVMOD:GetLanguage("SEATS"), TOP, function()
			SVMOD:GUI_Seats(frame:GetCenterPanel(), data)
		end)

		frame:CreateMenuButton(SVMOD:GetLanguage("LIGHTS"), TOP, function()
			SVMOD:GUI_Lights(frame:GetCenterPanel(), data)
		end)

		frame:CreateMenuButton(SVMOD:GetLanguage("ELS"), TOP, function()
			SVMOD:GUI_ELS(frame:GetCenterPanel(), data)
		end)

		frame:CreateMenuButton(SVMOD:GetLanguage("SOUNDS"), TOP, function()
			SVMOD:GUI_Sounds(frame:GetCenterPanel(), data)
		end)

		frame:CreateMenuButton(SVMOD:GetLanguage("DAMAGE"), TOP, function()
			SVMOD:GUI_Damage(frame:GetCenterPanel(), data)
		end)

		frame:CreateMenuButton(SVMOD:GetLanguage("FUEL"), TOP, function()
			SVMOD:GUI_Fuel(frame:GetCenterPanel(), data)
		end)
	end

	frame:CreateMenuButton(SVMOD:GetLanguage("CLOSE"), BOTTOM, function()
		frame:Remove()
	end)

	frame:CreateMenuButton(SVMOD:GetLanguage("CREDITS"), BOTTOM, function()
		SVMOD:GUI_Credits(frame:GetCenterPanel(), data)
	end)

	if not game.IsDedicated() then
		frame:CreateMenuButton(SVMOD:GetLanguage("CONTRIBUTOR"), BOTTOM, function()
			SVMOD:GUI_Contributor(frame:GetCenterPanel(), data)
		end)
	end

	SVMOD:GUI_Home(frame:GetCenterPanel(), data)
end)