function SVMOD:GUI_Lights(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.lights.headlights"))

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.lights.enable_headlights"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.AreHeadlightsEnabled == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Lights")
				net.WriteString("AreHeadlightsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.AreHeadlightsEnabled == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Lights")
				net.WriteString("AreHeadlightsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.lights.disable_headlights"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.TurnOffHeadlightsOnExit == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Lights")
				net.WriteString("TurnOffHeadlightsOnExit")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.TurnOffHeadlightsOnExit == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Lights")
				net.WriteString("TurnOffHeadlightsOnExit")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})

	local slide = SVMOD:CreateNumSlidePanel(panel, language.GetPhrase("svmod.lights.time_headlights"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Lights")
		net.WriteString("TimeTurnOffHeadlights")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val)
		net.SendToServer()
	end)
	slide:SetValue(data.TimeTurnOffHeadlights)
	slide:SetMaxValue(300)
	slide:SetUnit(language.GetPhrase("svmod.seconds"))

	local title = SVMOD:CreateTitle(panel, language.GetPhrase("svmod.lights.blinkers"))
	title:DockMargin(0, 30, 0, 0)

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.lights.enable_blinkers"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.AreHazardLightsEnabled == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Lights")
				net.WriteString("AreHazardLightsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.AreHazardLightsEnabled == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Lights")
				net.WriteString("AreHazardLightsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.lights.disable_blinkers"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.TurnOffHazardOnExit == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Lights")
				net.WriteString("TurnOffHazardOnExit")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.TurnOffHazardOnExit == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Lights")
				net.WriteString("TurnOffHazardOnExit")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})

	local slide = SVMOD:CreateNumSlidePanel(panel, language.GetPhrase("svmod.lights.time_blinkers"), function(val)
		net.Start("SV_Settings")
		net.WriteString("Lights")
		net.WriteString("TimeTurnOffHazard")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(val)
		net.SendToServer()
	end)
	slide:SetValue(data.TimeTurnOffHazard)
	slide:SetMaxValue(300)
	slide:SetUnit(language.GetPhrase("svmod.seconds"))

	local title = SVMOD:CreateTitle(panel, language.GetPhrase("svmod.lights.reverse"))
	title:DockMargin(0, 30, 0, 0)

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.lights.enable_reverse"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.AreReverseLightsEnabled == true),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Lights")
				net.WriteString("AreReverseLightsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(true)
				net.SendToServer()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.AreReverseLightsEnabled == false),
			DoClick = function()
				net.Start("SV_Settings")
				net.WriteString("Lights")
				net.WriteString("AreReverseLightsEnabled")
				net.WriteUInt(0, 2) -- bool
				net.WriteBool(false)
				net.SendToServer()
			end
		}
	})
end