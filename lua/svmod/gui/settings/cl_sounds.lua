function SVMOD:GUI_Sounds(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.sounds.horn"))

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.sounds.enable_horn"), {
		{
			Name = language.GetPhrase("svmod.enable"),
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
			Name = language.GetPhrase("svmod.disable"),
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