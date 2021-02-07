function SVMOD:CreateSettingPanel(panel, text, panels)
	local settingPanel = vgui.Create("DPanel", panel)
	settingPanel:Dock(TOP)
	settingPanel:DockMargin(0, 4, 0, 4)
	settingPanel:SetSize(0, 30)
	settingPanel:SetDrawBackground(false)

	local label = vgui.Create("DLabel", settingPanel)
	label:SetPos(2, 4)
	label:SetFont("SV_Calibri18")
	label:SetText(text)
	label:SizeToContents()

	for _, p in ipairs(panels) do
		local button = vgui.Create("DButton", settingPanel)
		button:Dock(RIGHT)
		button:DockMargin(8, 0, 0, 0)
		button:SetSize(100, 0)
		button:SetText("")
		button.DoClick = function(self)
			p.IsSelected = true

			p.DoClick()

			for _, t in ipairs(panels) do
				if t.Name ~= p.Name then
					t.IsSelected = false
				end
			end
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
	
				if p.IsSelected then
					color = p.HoverColor
				else
					color = Color(237, 197, 255)
				end
			else
				self.soundPlayed = false

				if p.IsSelected then
					color = p.Color
				else
					color = Color(154, 128, 166)
				end
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
	
			draw.SimpleText(p.Name, "SV_CalibriLight18", w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	return settingPanel
end

function SVMOD:CreateButton(panel, text, fun)
	local button = vgui.Create("DButton", panel)
	button:Dock(LEFT)
	button:SetSize(100, 0)
	button:SetText("")
	button.DoClick = function(self)
		fun()
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

		draw.SimpleText(text, "SV_CalibriLight18", w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	return button
end

function SVMOD:CreateNumSlidePanel(panel, text, fun)
	local numSlidePanel = vgui.Create("DPanel", panel)
	numSlidePanel:Dock(TOP)
	numSlidePanel:DockMargin(0, 4, 0, 4)
	numSlidePanel:SetSize(0, 30)
	numSlidePanel:SetDrawBackground(false)

	local label = vgui.Create("DLabel", numSlidePanel)
	label:SetPos(2, 4)
	label:SetFont("SV_Calibri18")
	label:SetText(text)
	label:SizeToContents()

	local numSlider = vgui.Create("DPanel", numSlidePanel)
	numSlider:Dock(RIGHT)
	numSlider:DockMargin(0, 5, 0, 5)
	numSlider:SetSize(205, 0)
	numSlider.SetValue = function(self, val)
		self.Value = val
	end
	numSlider.GetValue = function(self, val)
		return self.Value or 0
	end
	numSlider.SetMaxValue = function(self, val)
		self.MaxValue = val
	end
	numSlider.GetMaxValue = function(self, val)
		return self.MaxValue or 100
	end
	numSlider.SetUnit = function(self, val)
		self.Unit = val
	end
	numSlider.GetUnit = function(self, val)
		return self.Unit or "%"
	end
	numSlider.Paint = function(self, w, h)
		surface.SetDrawColor(18, 25, 31)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(41, 56, 63)
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetDrawColor(132, 84, 202)
		surface.DrawRect(1, 1, (w - 2) * self:GetValue() / self:GetMaxValue(), h - 2)

		draw.SimpleText(self:GetValue() .. " " .. self:GetUnit(), "SV_Calibri18", w / 2, h / 2, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	numSlider.OnMousePressed = function(self, keyCode)
		local width, _ = self:GetSize()

		if keyCode == MOUSE_LEFT then
			hook.Add("Think", "SV_NumSlider", function()
				if not input.IsMouseDown(MOUSE_LEFT) then
					hook.Remove("Think", "SV_NumSlider")

					fun(self:GetValue())
				else
					local cursorX, _ = self:LocalCursorPos()
					local val = math.Clamp(cursorX / width * self:GetMaxValue(), 0, self:GetMaxValue())
					numSlider:SetValue(math.Round(val))
				end
			end)
		end
	end

	return numSlider
end

function SVMOD:CreateHorizontalLine(panel, dock)
	if not dock then
		dock = TOP
	end

	local topHorizontalLine = vgui.Create("DPanel", panel)
	topHorizontalLine:Dock(dock)
	topHorizontalLine:DockMargin(0, 10, 0, 10)
	topHorizontalLine:SetSize(0, 1)
	topHorizontalLine.Paint = function(self, w, h)
		surface.SetDrawColor(39, 52, 58)
		surface.DrawRect(0, 0, w, h)
	end
end

function SVMOD:CreateTitle(panel, name)
	local headerPanel = vgui.Create("DPanel", panel)
	headerPanel:Dock(TOP)
	headerPanel:SetSize(0, 20)
	headerPanel:SetDrawBackground(false)

	local titleLabel = vgui.Create("DLabel", headerPanel)
	titleLabel:SetPos(0, 0)
	titleLabel:SetFont("SV_CalibriLight22")
	titleLabel:SetColor(Color(178, 95, 245))
	titleLabel:SetText(name)
	titleLabel:SizeToContents()

	SVMOD:CreateHorizontalLine(panel)

	return headerPanel
end