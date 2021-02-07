function SVMOD:GUI_Options(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, SVMOD:GetLanguage("PERFORMANCE"))

	SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Draw the projected lights of the headlights"), {
		{
			Name = SVMOD:GetLanguage("Enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (SVMOD.CFG.Lights.DrawProjectedLights == true),
			DoClick = function()
				SVMOD.CFG.Lights.DrawProjectedLights = true
				SVMOD:Save()
			end
		},
		{
			Name = SVMOD:GetLanguage("Disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (SVMOD.CFG.Lights.DrawProjectedLights == false),
			DoClick = function()
				SVMOD.CFG.Lights.DrawProjectedLights = false
				SVMOD:Save()
			end
		}
	})

	SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Enable shadows cast from the projected lights"), {
		{
			Name = SVMOD:GetLanguage("Enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (SVMOD.CFG.Lights.DrawShadows == true),
			DoClick = function()
				SVMOD.CFG.Lights.DrawShadows = true
				SVMOD:Save()
			end
		},
		{
			Name = SVMOD:GetLanguage("Disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (SVMOD.CFG.Lights.DrawShadows == false),
			DoClick = function()
				SVMOD.CFG.Lights.DrawShadows = false
				SVMOD:Save()
			end
		}
	})

	local settingPanel = SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Draw smoke from damaged vehicles"), {
		{
			Name = SVMOD:GetLanguage("Enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (SVMOD.CFG.Damage.DrawSmoke == true),
			DoClick = function()
				SVMOD.CFG.Damage.DrawSmoke = true
				SVMOD:Save()
			end
		},
		{
			Name = SVMOD:GetLanguage("Disable"),
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

	SVMOD:CreateTitle(panel, SVMOD:GetLanguage("GAMEPLAY"))

	SVMOD:CreateSettingPanel(panel, SVMOD:GetLanguage("Automatically disable the blinkers once the vehicle has been rotated"), {
		{
			Name = SVMOD:GetLanguage("Enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (SVMOD.CFG.Lights.DisableBlinkersOnTurn == true),
			DoClick = function()
			   SVMOD.CFG.Lights.DisableBlinkersOnTurn = true
			   SVMOD:Save()
			end
		},
		{
			Name = SVMOD:GetLanguage("Disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (SVMOD.CFG.Lights.DisableBlinkersOnTurn == false),
			DoClick = function()
				SVMOD.CFG.Lights.DisableBlinkersOnTurn = false
				SVMOD:Save()
			end
		}
	})
end