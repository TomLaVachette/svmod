function SVMOD:GUI_Damage(panel, data)
	panel:Clear()

	-- create scroll panel
	local scroll = vgui.Create("DScrollPanel", panel)
	scroll:Dock(FILL)
	scroll:SetPaintBackground(false)
	scroll:DockPadding(0, 0, -5, 0)
	local scrollBar = scroll:GetVBar()
	scrollBar:SetHideButtons(true)
	scrollBar:SetScroll(0)

	SVMOD:CreateTitle(scroll, language.GetPhrase("svmod.damage.vehicle_damage"))

	local slide = SVMOD:CreateNumSlidePanel(scroll, language.GetPhrase("svmod.damage.physics_multiplier"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Damage")
		net.WriteString("PhysicsMultiplier")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.PhysicsMultiplier * 100)
	slide:SetMaxValue(200)
	slide:SetUnit("%")

	local slide = SVMOD:CreateNumSlidePanel(scroll, language.GetPhrase("svmod.damage.physics_damage"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Damage")
		net.WriteString("BulletMultiplier")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.BulletMultiplier * 100)
	slide:SetMaxValue(200)
	slide:SetUnit("%")

	local slide = SVMOD:CreateNumSlidePanel(scroll, language.GetPhrase("svmod.damage.chance_carbonise"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Damage")
		net.WriteString("CarbonisedChance")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.CarbonisedChance * 100)
	slide:SetMaxValue(100)
	slide:SetUnit("%")

	local slide = SVMOD:CreateNumSlidePanel(scroll, language.GetPhrase("svmod.damage.percent_life"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Damage")
		net.WriteString("SmokePercent")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.SmokePercent * 100)
	slide:SetMaxValue(100)
	slide:SetUnit("%")

	SVMOD:CreateSettingPanel(scroll, language.GetPhrase("svmod.damage.enable_engine_stop"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.StopEngineAfterCrash == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Damage")
				net.WriteString("StopEngineAfterCrash")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.StopEngineAfterCrash == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Damage")
				net.WriteString("StopEngineAfterCrash")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})

	local slide = SVMOD:CreateNumSlidePanel(scroll, language.GetPhrase("svmod.damage.enable_engine_stop_duration"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Damage")
		net.WriteString("StopEngineAfterCrashTime")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val)
		net.SendToServer()
	end)
	slide:SetValue(data.StopEngineAfterCrashTime)
	slide:SetMaxValue(10)
	slide:SetUnit(language.GetPhrase("svmod.seconds"))

	local slide = SVMOD:CreateNumSlidePanel(scroll, language.GetPhrase("svmod.damage.enable_engine_stop_damage_multiplier"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Damage")
		net.WriteString("StopEngineAfterCrashDamageMultiplier")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.StopEngineAfterCrashDamageMultiplier * 100)
	slide:SetMaxValue(200)
	slide:SetUnit("%")

	local title = SVMOD:CreateTitle(scroll, language.GetPhrase("svmod.damage.wheels"))
	title:DockMargin(0, 30, 0, 0)

	local slide = SVMOD:CreateNumSlidePanel(scroll, language.GetPhrase("svmod.damage.wheel_shot_multiplier"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Damage")
		net.WriteString("WheelShotMultiplier")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.WheelShotMultiplier * 100)
	slide:SetMaxValue(200)
	slide:SetUnit("%")

	local slide = SVMOD:CreateNumSlidePanel(scroll, language.GetPhrase("svmod.damage.wheel_collision_multiplier"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Damage")
		net.WriteString("WheelCollisionMultiplier")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.WheelCollisionMultiplier * 100)
	slide:SetMaxValue(200)
	slide:SetUnit("%")

	local slide = SVMOD:CreateNumSlidePanel(scroll, language.GetPhrase("svmod.damage.wheel_time_punctured"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Damage")
		net.WriteString("TimeBeforeWheelIsPunctured")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val)
		net.SendToServer()
	end)
	slide:SetValue(data.TimeBeforeWheelIsPunctured)
	slide:SetMaxValue(300)
	slide:SetUnit(language.GetPhrase("svmod.seconds"))

	local title = SVMOD:CreateTitle(scroll, language.GetPhrase("svmod.damage.player_damage"))
	title:DockMargin(0, 30, 0, 0)

	local slide = SVMOD:CreateNumSlidePanel(scroll, language.GetPhrase("svmod.damage.driver_multiplier"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Damage")
		net.WriteString("DriverMultiplier")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.DriverMultiplier * 100)
	slide:SetMaxValue(200)
	slide:SetUnit("%")

	local slide = SVMOD:CreateNumSlidePanel(scroll, language.GetPhrase("svmod.damage.passenger_multiplier"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Damage")
		net.WriteString("PassengerMultiplier")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.PassengerMultiplier * 100)
	slide:SetMaxValue(200)
	slide:SetUnit("%")

	local slide = SVMOD:CreateNumSlidePanel(scroll, language.GetPhrase("svmod.damage.exit_multiplier"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Damage")
		net.WriteString("PlayerExitMultiplier")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.PlayerExitMultiplier * 100)
	slide:SetMaxValue(200)
	slide:SetUnit("%")
end