function SVMOD:GUI_Shortcuts(panel)
	panel:Clear()

	local headerPanel = vgui.Create("DPanel", panel)
	headerPanel:Dock(TOP)
	headerPanel:SetSize(0, 20)
	headerPanel:SetPaintBackground(false)

	local titleLabel = vgui.Create("DLabel", headerPanel)
	titleLabel:SetPos(0, 0)
	titleLabel:SetFont("SV_CalibriLight22")
	titleLabel:SetColor(Color(178, 95, 245))
	titleLabel:SetText(language.GetPhrase("svmod.shortcuts.shortcuts"))
	titleLabel:SizeToContents()

	SVMOD:CreateHorizontalLine(panel)

	local function createSetting(text, data)
		local settingPanel = vgui.Create("DPanel", panel)
		settingPanel:Dock(TOP)
		settingPanel:DockMargin(0, 4, 0, 4)
		settingPanel:SetSize(0, 30)
		settingPanel:SetPaintBackground(false)

		local label = vgui.Create("DLabel", settingPanel)
		label:SetPos(2, 4)
		label:SetFont("SV_Calibri18")
		label:SetText(text)
		label:SizeToContents()

		local button = vgui.Create("DBinder", settingPanel)
		button:Dock(RIGHT)
		button:DockMargin(8, 0, 0, 0)
		button:SetSize(100, 0)
		button.OnChange = function(self, value)
			self:SetText(string.upper(input.GetKeyName(value) or "NONE"))

			data.Key = self:GetValue() or "NONE"

			SVMOD:Save()
		end
		button.Paint = function(self, w, h)
			surface.SetDrawColor(12, 22, 24)
			surface.DrawRect(0, 0, w, h)

			local color

			if self:IsHovered() then
				if not self.soundPlayed then
					surface.PlaySound("garrysmod/ui_hover.wav")
					self.soundPlayed = true
				end

				color = Color(237, 197, 255)
			else
				self.soundPlayed = false

				color = Color(154, 128, 166)
			end

			surface.SetDrawColor(color.r, color.g, color.b)

			surface.DrawRect(3, 3, 7, 1)
			surface.DrawRect(3, 3, 1, 7)

			surface.DrawRect(w - 3 - 7, 3, 7, 1)
			surface.DrawRect(w - 3, 3, 1, 7)

			surface.DrawRect(3, h - 3, 7, 1)
			surface.DrawRect(3, h - 3 - 7, 1, 7)

			surface.DrawRect(w - 3 - 7, h - 3, 7, 1)
			surface.DrawRect(w - 3, h - 3 - 7, 1, 7)

			draw.SimpleText(self:GetText(), "SV_CalibriLight18", w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end

		return button
	end

	for i, s in ipairs(SVMOD.Shortcuts) do
		local button = createSetting(language.GetPhrase(s.Name), s)
		button:SetValue(s.Key)
	end

	SVMOD:CreateHorizontalLine(panel)

	local bottomPanel = vgui.Create("DPanel", panel)
	bottomPanel:Dock(TOP)
	bottomPanel:DockMargin(0, 4, 0, 4)
	bottomPanel:SetSize(0, 30)
	bottomPanel:SetPaintBackground(false)

	local buttonText = language.GetPhrase("svmod.reset")

	local button = vgui.Create("DButton", bottomPanel)
	button:Dock(RIGHT)
	button:DockMargin(8, 0, 0, 0)
	button:SetSize(100, 0)
	button:SetText("")
	button.DoClick = function(self)
		for i, _ in ipairs(SVMOD.Shortcuts) do
			SVMOD.Shortcuts[i].Key = SVMOD.Shortcuts[i].DefaultKey
		end
		panel:GetParent():Remove()
		LocalPlayer():ConCommand("svmod")
	end
	button.Paint = function(self, w, h)
		surface.SetDrawColor(12, 22, 24)
		surface.DrawRect(0, 0, w, h)

		local color

		if self:IsHovered() then
			if not self.soundPlayed then
				surface.PlaySound("garrysmod/ui_hover.wav")
				self.soundPlayed = true
			end

			color = Color(237, 197, 255)
		else
			self.soundPlayed = false

			color = Color(154, 128, 166)
		end

		surface.SetDrawColor(color.r, color.g, color.b)

		surface.DrawRect(3, 3, 7, 1)
		surface.DrawRect(3, 3, 1, 7)

		surface.DrawRect(w - 3 - 7, 3, 7, 1)
		surface.DrawRect(w - 3, 3, 1, 7)

		surface.DrawRect(3, h - 3, 7, 1)
		surface.DrawRect(3, h - 3 - 7, 1, 7)

		surface.DrawRect(w - 3 - 7, h - 3, 7, 1)
		surface.DrawRect(w - 3, h - 3 - 7, 1, 7)

		draw.SimpleText(buttonText, "SV_CalibriLight18", w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end