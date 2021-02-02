function SVMOD:GUI_Sounds(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, SVMOD:GetLanguage("SOUNDS"))

	SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Enable the vehicle horn"), {
		{
			Name = SVMOD:GetLanguage("Enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.HornIsEnabled == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Horn")
				net.WriteString("IsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = SVMOD:GetLanguage("Disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.HornIsEnabled == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Horn")
				net.WriteString("IsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})
end