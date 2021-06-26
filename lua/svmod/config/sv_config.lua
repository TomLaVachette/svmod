util.AddNetworkString("SV_WelcomeGUI")

function SVMOD:ResetConfiguration()
	SVMOD.CFG = {}

	SVMOD.CFG.IsEnabled = true

	SVMOD.CFG.Seats = {
		IsSwitchEnabled = true,
		IsKickEnabled = true,
		IsLockEnabled = true,
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

		WheelShotMultiplier = 1,
		WheelCollisionMultiplier = 1,
		TimeBeforeWheelIsPunctured = 60,

		DriverMultiplier = 1,
		PassengerMultiplier = 1,
		PlayerExitMultiplier = 1
	}

	SVMOD.CFG.Fuel = {
		IsEnabled = true,
		Multiplier = 1,
		Pumps = {}
	}

	SVMOD.CFG.Others = {
		IsHUDEnabled = true,
		HUDPositionX = 0.21,
		HUDPositionY = 0.91,
		HUDSize = 100,
		HUDColor = Color(178, 95, 245),
		CustomSuspension = 0
	}

	SVMOD.CFG.Contributor = {
		EnterpriseID = 0
	}
end

if not SVMOD.CFG then
	SVMOD:ResetConfiguration()
end