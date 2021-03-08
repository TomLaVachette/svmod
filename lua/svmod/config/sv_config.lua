function SVMOD:ResetConfiguration()
	SVMOD.CFG = {}

	SVMOD.CFG.IsEnabled = true

	SVMOD.CFG.AddWorkshop = true

	SVMOD.CFG.Seats = {
		IsSwitchEnabled = true,
		IsKickEnabled = true,
		IsLockEnabled = true
	}

	SVMOD.CFG.Lights = {
		AreHeadlightsEnabled = true,
		TurnOffHeadlightsOnExit = true,
		TimeTurnOffHeadlights = 10,

		AreHazardLightsEnabled = true,
		TurnOffHazardOnExit = true,
		TimeTurnOffHazard = 120,

		AreReverseLightsEnabled = true
	}

	SVMOD.CFG.ELS = {
		AreFlashingLightsEnabled = true,
		TurnOffFlashingLightsOnExit = true,
		TimeTurnOffFlashingLights = 120,
		TimeTurnOffSound = 120
	}

	SVMOD.CFG.Horn = {
		IsEnabled = true
	}

	SVMOD.CFG.Damage = {
		PhysicsMultiplier = 1,
		BulletMultiplier = 1,
		CarbonisedChance = 0.1,
		SmokePercent = 0.25,
		DriverMultiplier = 1,
		PassengerMultiplier = 1,
		PlayerExitMultiplier = 1
	}

	SVMOD.CFG.Fuel = {
		IsEnabled = true,
		Multiplier = 1,
		Pumps = {}
	}
end

if not SVMOD.CFG then
	SVMOD:ResetConfiguration()
end

function SVMOD:GetFuelPumpByEnt(ent)
	for _, pump in ipairs(SVMOD.CFG.Fuel.Pumps) do
		if pump.Entity == ent then
			return pump
		end
	end

	return nil
end