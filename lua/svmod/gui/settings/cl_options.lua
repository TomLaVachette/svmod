function SVMOD:GUI_Options(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.options.performance"))

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.options.projected"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (SVMOD.CFG.Lights.DrawProjectedLights == true),
			DoClick = function()
				SVMOD.CFG.Lights.DrawProjectedLights = true
				SVMOD:Save()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (SVMOD.CFG.Lights.DrawProjectedLights == false),
			DoClick = function()
				SVMOD.CFG.Lights.DrawProjectedLights = false
				SVMOD:Save()
			end
		}
	})

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.options.shadow"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (SVMOD.CFG.Lights.DrawShadows == true),
			DoClick = function()
				SVMOD.CFG.Lights.DrawShadows = true
				SVMOD:Save()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (SVMOD.CFG.Lights.DrawShadows == false),
			DoClick = function()
				SVMOD.CFG.Lights.DrawShadows = false
				SVMOD:Save()
			end
		}
	})

	local settingPanel = SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.options.smoke"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (SVMOD.CFG.Damage.DrawSmoke == true),
			DoClick = function()
				SVMOD.CFG.Damage.DrawSmoke = true
				SVMOD:Save()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (SVMOD.CFG.Damage.DrawSmoke == false),
			DoClick = function()
				SVMOD.CFG.Damage.DrawSmoke = false
				SVMOD:Save()
			end
		}
	})
	settingPanel:DockMargin(0, 4, 0, 30)

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.options.gameplay"))

	local gameplayPanel = SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.options.disable_blinkers"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (SVMOD.CFG.Lights.DisableBlinkersOnTurn == true),
			DoClick = function()
			   SVMOD.CFG.Lights.DisableBlinkersOnTurn = true
			   SVMOD:Save()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (SVMOD.CFG.Lights.DisableBlinkersOnTurn == false),
			DoClick = function()
				SVMOD.CFG.Lights.DisableBlinkersOnTurn = false
				SVMOD:Save()
			end
		}
	})
	gameplayPanel:DockMargin(0, 4, 0, 30)

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.options.sounds"))

	local slide = SVMOD:CreateNumSlidePanel(panel, language.GetPhrase("svmod.options.horn"), function(val)
		SVMOD.CFG.Sounds.Horn = val / 100
		SVMOD:Save()
	end)
	slide:SetValue(SVMOD.CFG.Sounds.Horn * 100)
	slide:SetMaxValue(100)

	local slide = SVMOD:CreateNumSlidePanel(panel, language.GetPhrase("svmod.options.siren"), function(val)
		SVMOD.CFG.Sounds.Siren = val / 100
		SVMOD:Save()
	end)
	slide:SetValue(SVMOD.CFG.Sounds.Siren * 100)
	slide:SetMaxValue(100)
end