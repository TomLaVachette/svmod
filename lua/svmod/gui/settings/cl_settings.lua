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
		data.TurnOffFlashingLightsOnExit = net.ReadBool()
		data.TimeTurnOffFlashingLights = net.ReadFloat()
		data.TimeTurnOffSound = net.ReadFloat()

		data.HornIsEnabled = net.ReadBool()

		data.PhysicsMultiplier = math.Round(net.ReadFloat(), 2)
		data.BulletMultiplier = math.Round(net.ReadFloat(), 2)
		data.CarbonisedChance = math.Round(net.ReadFloat(), 2)
		data.SmokePercent = math.Round(net.ReadFloat(), 2)
		data.WheelShotMultiplier = math.Round(net.ReadFloat(), 2)
		data.WheelCollisionMultiplier = math.Round(net.ReadFloat(), 2)
		data.TimeBeforeWheelIsPunctured = math.Round(net.ReadFloat(), 2)
		data.DriverMultiplier = math.Round(net.ReadFloat(), 2)
		data.PassengerMultiplier = math.Round(net.ReadFloat(), 2)
		data.PlayerExitMultiplier = math.Round(net.ReadFloat(), 2)

		data.FuelIsEnabled = net.ReadBool()
		data.FuelMultiplier = math.Round(net.ReadFloat(), 2)

		data.IsHUDEnabled = net.ReadBool()
		data.HUDPositionX = net.ReadFloat()
		data.HUDPositionY = net.ReadFloat()
		data.HUDSize = net.ReadUInt(9) -- max: 511
		data.HUDColor = net.ReadColor()
		data.CustomSuspension = math.Round(net.ReadFloat(), 2)

		data.EnterpriseID = net.ReadFloat()
	end

	local frame = SVMOD:CreateFrame("SVMOD : SIMPLE VEHICLE MOD " .. SVMOD.FCFG.Version)
	frame:SetSize(900, 650)
	frame:MakePopup()

	frame:CreateMenuButton(language.GetPhrase("svmod.home.home"), TOP, function()
		SVMOD:GUI_Home(frame:GetCenterPanel(), data)
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.shortcuts.shortcuts"), TOP, function()
		SVMOD:GUI_Shortcuts(frame:GetCenterPanel(), data)
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.options.options"), TOP, function()
		SVMOD:GUI_Options(frame:GetCenterPanel(), data)
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.vehicles.vehicles"), TOP, function()
		SVMOD:GUI_Vehicles(frame:GetCenterPanel(), data)
	end)

	SVMOD:CreateHorizontalLine(frame:GetLeftPanel())

	if data.HasAccess then
		frame:CreateMenuButton(language.GetPhrase("svmod.seats.seats"), TOP, function()
			SVMOD:GUI_Seats(frame:GetCenterPanel(), data)
		end)

		frame:CreateMenuButton(language.GetPhrase("svmod.lights.lights"), TOP, function()
			SVMOD:GUI_Lights(frame:GetCenterPanel(), data)
		end)

		frame:CreateMenuButton(language.GetPhrase("svmod.els.els"), TOP, function()
			SVMOD:GUI_ELS(frame:GetCenterPanel(), data)
		end)

		frame:CreateMenuButton(language.GetPhrase("svmod.sounds.sounds"), TOP, function()
			SVMOD:GUI_Sounds(frame:GetCenterPanel(), data)
		end)

		frame:CreateMenuButton(language.GetPhrase("svmod.damage.damage"), TOP, function()
			SVMOD:GUI_Damage(frame:GetCenterPanel(), data)
		end)

		frame:CreateMenuButton(language.GetPhrase("svmod.fuel.fuel"), TOP, function()
			SVMOD:GUI_Fuel(frame:GetCenterPanel(), data)
		end)

		frame:CreateMenuButton(language.GetPhrase("svmod.others.others"), TOP, function()
			SVMOD:GUI_Others(frame:GetCenterPanel(), data)
		end)
	end

	frame:CreateMenuButton(language.GetPhrase("svmod.credits"), BOTTOM, function()
		SVMOD:GUI_Credits(frame:GetCenterPanel(), data)
	end)

	if not game.IsDedicated() then
		frame:CreateMenuButton(language.GetPhrase("svmod.contributor.contributor"), BOTTOM, function()
			SVMOD:GUI_Contributor(frame:GetCenterPanel(), data)
		end)
	end

	SVMOD:GUI_Home(frame:GetCenterPanel(), data)
end)