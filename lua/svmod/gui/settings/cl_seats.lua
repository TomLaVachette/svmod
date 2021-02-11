function SVMOD:GUI_Seats(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, SVMOD:GetLanguage("SEATS"))

	SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Enable seat changing from inside the vehicle"), {
		{
			Name = SVMOD:GetLanguage("Enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.IsSwitchEnabled == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Seats")
				net.WriteString("IsSwitchEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = SVMOD:GetLanguage("Disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.IsSwitchEnabled == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Seats")
				net.WriteString("IsSwitchEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})

	SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Enable the ability to exclude passengers as driver"), {
		{
			Name = SVMOD:GetLanguage("Enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.IsKickEnabled == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Seats")
				net.WriteString("IsKickEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = SVMOD:GetLanguage("Disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.IsKickEnabled == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Seats")
				net.WriteString("IsKickEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})

	SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Enable the ability to lock/unlock the vehicle from the inside"), {
		{
			Name = SVMOD:GetLanguage("Enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.IsLockEnabled == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Seats")
				net.WriteString("IsLockEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = SVMOD:GetLanguage("Disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.IsLockEnabled == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Seats")
				net.WriteString("IsLockEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})
end