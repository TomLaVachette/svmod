function SVMOD:EDITOR_Sounds(panel, data)
	panel:Clear()

	local bottomPanel = vgui.Create("DPanel", panel)
	bottomPanel:Dock(BOTTOM)
	bottomPanel:SetSize(0, 30)
	bottomPanel:SetPaintBackground(false)

	local function createComboBoxPanel(text, choices, fun)
		local comboBoxPanel = vgui.Create("DPanel", panel)
		comboBoxPanel:Dock(TOP)
		comboBoxPanel:DockMargin(0, 4, 0, 4)
		comboBoxPanel:SetSize(0, 30)
		comboBoxPanel:SetPaintBackground(false)

		local label = vgui.Create("DLabel", comboBoxPanel)
		label:SetPos(2, 4)
		label:SetFont("SV_Calibri18")
		label:SetText(text)
		label:SizeToContents()

		local comboBox = vgui.Create("DComboBox", comboBoxPanel)
		comboBox:Dock(RIGHT)
		comboBox:DockMargin(8, 0, 0, 0)
		comboBox:SetSize(300, 0)
		comboBox:SetText("")
		comboBox.OnSelect = function(self, _, val)
			fun(val)
		end

		for _, c in ipairs(choices) do
			comboBox:AddChoice(c)
		end

		return comboBox
	end

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.sounds.sounds"))

	local blinkersComboBox = createComboBoxPanel("Blinkers", { "light", "normal" }, function(val)
		data.Blinkers = val
	end)
	blinkersComboBox:SetValue(data.Blinkers or "normal")

	local hornComboBox = createComboBoxPanel("Horn", { "light", "normal", "heavy" }, function(val)
		data.Horn = val
	end)
	hornComboBox:SetValue(data.Horn or "normal")

	local reversingComboBox = createComboBoxPanel("Reversing", { "" }, function(val)
		data.Reversing = val
	end)
	reversingComboBox:SetValue(data.Reversing or "")

	local sirenComboBox = createComboBoxPanel("Siren", {
		"",
		"american_police", "american_firetruck", "american_ambulance",
		"french_police", "french_gendarmerie", "french_firetruck", "french_ambulance"
	}, function(val)
		data.Siren = val
	end)
	sirenComboBox:SetValue(data.Siren or "")
end