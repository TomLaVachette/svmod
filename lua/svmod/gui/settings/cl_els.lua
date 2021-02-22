function SVMOD:GUI_ELS(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.els.flashing"))

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.els.enable_flashing"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.AreFlashingLightsEnabled == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("ELS")
				net.WriteString("AreFlashingLightsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.AreFlashingLightsEnabled == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("ELS")
				net.WriteString("AreFlashingLightsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.els.disable_flashing"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.TurnOffFlashingLightsOnExit == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("ELS")
				net.WriteString("TurnOffFlashingLightsOnExit")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.TurnOffFlashingLightsOnExit == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("ELS")
				net.WriteString("TurnOffFlashingLightsOnExit")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})

	local slide = SVMOD:CreateNumSlidePanel(panel, language.GetPhrase("svmod.els.time_flashing"), function(val)
		net.Start("SV_Settings")
		net.WriteString("ELS")
		net.WriteString("TimeTurnOffFlashingLights")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val)
		net.SendToServer()
	end)
	slide:SetValue(data.TimeTurnOffFlashingLights)
	slide:SetMaxValue(300)
	slide:SetUnit(language.GetPhrase("svmod.seconds"))

	local slide = SVMOD:CreateNumSlidePanel(panel, language.GetPhrase("svmod.els.time_sound"), function(val)
		net.Start("SV_Settings")
		net.WriteString("ELS")
		net.WriteString("TimeTurnOffSound")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val)
		net.SendToServer()
	end)
	slide:SetValue(data.TimeTurnOffSound)
	slide:SetMaxValue(300)
	slide:SetUnit(language.GetPhrase("svmod.seconds"))
end