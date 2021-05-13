function SVMOD:GUI_Contributor(panel, data)
	panel:Clear()

	SVMOD:CreateTitle(panel, language.GetPhrase("svmod.contributor.contributor"))

	local keyPanel = vgui.Create("DPanel", panel)
	keyPanel:Dock(TOP)
	keyPanel:DockMargin(0, 4, 0, 4)
	keyPanel:SetSize(0, 30)
	keyPanel:SetPaintBackground(false)

	local label = vgui.Create("DLabel", keyPanel)
	label:SetPos(2, 4)
	label:SetFont("SV_Calibri18")
	label:SetText(language.GetPhrase("svmod.contributor.api_key"))
	label:SizeToContents()

	local keyTextEntry = vgui.Create("DTextEntry", keyPanel)
	keyTextEntry:Dock(RIGHT)
	keyTextEntry:DockMargin(8, 0, 0, 0)
	keyTextEntry:SetSize(300, 0)
	keyTextEntry.Paint = function(self, w, h)
		surface.SetDrawColor(18, 25, 31)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(41, 56, 63)
		surface.DrawOutlinedRect(0, 0, w, h)

		draw.SimpleText(self:GetValue(), "SV_Calibri18", 8, h / 2, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	keyTextEntry:SetValue(SVMOD.CFG.Contributor.Key or "")

	local subKeyPanel = vgui.Create("DPanel", panel)
	subKeyPanel:Dock(TOP)
	subKeyPanel:DockMargin(0, 4, 0, 4)
	subKeyPanel:SetSize(0, 30)
	subKeyPanel:SetPaintBackground(false)

	local checkedPanel = vgui.Create("DImage", subKeyPanel)
	checkedPanel:SetPos(5, 5)
	checkedPanel:SetSize(24, 24)

	local label = vgui.Create("DLabel", subKeyPanel)
	label:SetPos(39, 8)
	label:SetFont("SV_Calibri18")

	if SVMOD.CFG.Contributor.IsEnabled then
		checkedPanel:SetImageColor(Color(112, 255, 117))
		checkedPanel:SetImage("vgui/svmod/checked.png")

		label:SetColor(Color(112, 255, 117))
		label:SetText(language.GetPhrase("svmod.contributor.contributor_enabled"))
		label:SizeToContents()
	else
		checkedPanel:SetImageColor(Color(255, 112, 112))
		checkedPanel:SetImage("vgui/svmod/invalid.png")

		label:SetColor(Color(255, 112, 112))
		label:SetText(language.GetPhrase("svmod.contributor.contributor_disabled"))
		label:SizeToContents()
	end

	local validButton = SVMOD:CreateButton(subKeyPanel, language.GetPhrase("svmod.update"), function()
		SVMOD.CFG.Contributor.Key = keyTextEntry:GetValue()

		http.Fetch("https://api.svmod.com/check_serial.php?serial=" .. keyTextEntry:GetValue(), function(_, _, _, code)
			if code == 200 then
				SVMOD.CFG.Contributor.IsEnabled = true

				SVMOD:Save()

				if IsValid(panel) then
					SVMOD:GUI_Contributor(panel, data)
				end
			else
				notification.AddLegacy(language.GetPhrase("svmod.contributor.invalid_key"), NOTIFY_ERROR, 5)
			end
		end, function()
			notification.AddLegacy(language.GetPhrase("svmod.server_not_respond"), NOTIFY_ERROR, 5)
		end)
	end)
	validButton:Dock(RIGHT)

	local title = SVMOD:CreateTitle(panel, "ENTERPRISE")
	title:DockMargin(0, 30, 0, 0)

	local enterprisePanel = vgui.Create("DPanel", panel)
	enterprisePanel:Dock(TOP)
	enterprisePanel:DockMargin(0, 4, 0, 4)
	enterprisePanel:SetSize(0, 30)
	enterprisePanel:SetPaintBackground(false)

	local label = vgui.Create("DLabel", enterprisePanel)
	label:SetPos(2, 4)
	label:SetFont("SV_Calibri18")
	label:SetText("Enterprise ID")
	label:SizeToContents()

	local keyTextEntry = vgui.Create("DTextEntry", enterprisePanel)
	keyTextEntry:Dock(RIGHT)
	keyTextEntry:DockMargin(8, 0, 0, 0)
	keyTextEntry:SetSize(150, 0)
	keyTextEntry.Paint = function(self, w, h)
		surface.SetDrawColor(18, 25, 31)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(41, 56, 63)
		surface.DrawOutlinedRect(0, 0, w, h)

		draw.SimpleText(self:GetValue(), "SV_Calibri18", 8, h / 2, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	keyTextEntry:SetValue(data.EnterpriseID or 0)

	local subKeyPanel = vgui.Create("DPanel", panel)
	subKeyPanel:Dock(TOP)
	subKeyPanel:DockMargin(0, 4, 0, 4)
	subKeyPanel:SetSize(0, 30)
	subKeyPanel:SetPaintBackground(false)

	local validButton = SVMOD:CreateButton(subKeyPanel, language.GetPhrase("svmod.update"), function()
		net.Start("SV_Settings")
		net.WriteString("Contributor")
		net.WriteString("EnterpriseID")
		net.WriteUInt(1, 2) -- float
		net.WriteFloat(math.Clamp(keyTextEntry:GetValue(), 0, 65535))
		net.SendToServer()

		SVMOD:SetAddonState(false)
		panel:GetParent():Remove()
		SVMOD:SetAddonState(true)

		panel:GetParent():Remove()
	end)
	validButton:Dock(RIGHT)
end