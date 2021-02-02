function SVMOD:GUI_Fuel(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, SVMOD:GetLanguage("FUEL"))

	SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Enable fuel consumption on vehicles"), {
		{
			Name = SVMOD:GetLanguage("Enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.FuelIsEnabled == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Fuel")
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
			IsSelected = (data.FuelIsEnabled == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Fuel")
				net.WriteString("IsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})

	local slide = SVMOD:CreateNumSlidePanel(panel, SVMOD:GetLanguage("Fuel consumption multiplier"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Fuel")
		net.WriteString("Multiplier")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val / 100)
		net.SendToServer()
	end)
	slide:SetValue(data.FuelMultiplier * 100)
	slide:SetMaxValue(200)
	slide:SetUnit("%")
end