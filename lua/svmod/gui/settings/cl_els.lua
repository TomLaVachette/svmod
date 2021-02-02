function SVMOD:GUI_ELS(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, SVMOD:GetLanguage("FLASHING LIGHTS"))

	SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Enable flashing lights"), {
		{
			Name = SVMOD:GetLanguage("Enable"),
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
			Name = SVMOD:GetLanguage("Disable"),
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

	SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Turning off the flashing lights when the driver exits the vehicle"), {
		{
			Name = SVMOD:GetLanguage("Enable"),
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
			Name = SVMOD:GetLanguage("Disable"),
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

	local slide = SVMOD:CreateNumSlidePanel(panel, SVMOD:GetLanguage("Time to deactivate the flashing lights"), function(val)
		net.Start("SV_Settings")
		net.WriteString("ELS")
		net.WriteString("TimeTurnOffFlashingLights")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val)
		net.SendToServer()
	end)
	slide:SetValue(data.TimeTurnOffFlashingLights)
	slide:SetMaxValue(300)
	slide:SetUnit(SVMOD:GetLanguage("seconds"))
end