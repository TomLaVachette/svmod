function SVMOD:GUI_Home(panel, data)
	panel:Clear()

	local function createStatus(status, text)
		if not status then
			status = false
		end

		local statusPanel = vgui.Create("DPanel", panel)
		statusPanel:Dock(TOP)
		statusPanel:DockMargin(0, 2, 0, 0)
		statusPanel:SetSize(0, 30)
		statusPanel:SetPaintBackground(false)

		local checkedPanel = vgui.Create("DImage", statusPanel)
		checkedPanel:SetPos(0, 0)
		checkedPanel:SetSize(24, 24)
		if status then
			checkedPanel:SetImageColor(Color(112, 255, 117))
			checkedPanel:SetImage("vgui/svmod/checked.png")
		else
			checkedPanel:SetImageColor(Color(255, 112, 112))
			checkedPanel:SetImage("vgui/svmod/invalid.png")
		end

		local statusLabel = vgui.Create("DLabel", statusPanel)
		statusLabel:SetPos(35, 2)
		statusLabel:SetFont("SV_Calibri18")
		if status then
			statusLabel:SetColor(Color(112, 255, 117))
		else
			statusLabel:SetColor(Color(255, 112, 112))
		end
		statusLabel:SetText(text)
		statusLabel:SizeToContents()
	end

	local headerPanel = vgui.Create("DPanel", panel)
	headerPanel:Dock(TOP)
	headerPanel:SetSize(0, 20)
	headerPanel:SetPaintBackground(false)

	local titleLabel = vgui.Create("DLabel", headerPanel)
	titleLabel:SetPos(0, 0)
	titleLabel:SetFont("SV_CalibriLight22")
	titleLabel:SetColor(Color(178, 95, 245))
	titleLabel:SetText(language.GetPhrase("svmod.home.home"))
	titleLabel:SizeToContents()

	SVMOD:CreateHorizontalLine(panel)

	if data.Status then
		createStatus(true, language.GetPhrase("svmod.enabled"))
	else
		createStatus(false, language.GetPhrase("svmod.disabled"))
	end

	if SVMOD.FCFG.Version == SVMOD.FCFG.LastVersion then
		createStatus(true, language.GetPhrase("svmod.home.addon_up_to_date"))
	else
		createStatus(false, language.GetPhrase("svmod.home.addon_not_up_to_date") .. " (" .. SVMOD.FCFG.Version .. " - " .. SVMOD.FCFG.LastVersion .. ")")
	end

	if SVMOD.Data and #data.LastVehicleUpdate > 0 then
		createStatus(true, language.GetPhrase("svmod.home.vehicle_up_to_date"))
	else
		createStatus(false, language.GetPhrase("svmod.home.vehicle_not_up_to_date"))
	end

	if #data.ConflictList == 0 then
		createStatus(true, language.GetPhrase("svmod.home.no_conflict"))
	else
		createStatus(false, language.GetPhrase("svmod.home.conflict_detected") .. " : " .. data.ConflictList)
	end

	local vehicleLoadedCount = 0
	if SVMOD.Data then
		vehicleLoadedCount = table.Count(SVMOD.Data)
	end
	local vehicleIncompatibleCount = table.Count(SVMOD:GetVehicleList()) - vehicleLoadedCount

	local loadedText
	if vehicleLoadedCount > 1 then
		loadedText = string.format(language.GetPhrase("svmod.home.vehicle_plurial_loaded"), vehicleLoadedCount)
	else
		loadedText = string.format(language.GetPhrase("svmod.home.vehicle_loaded"), vehicleLoadedCount)
	end

	local incompatibleText
	if vehicleIncompatibleCount > 1 then
		incompatibleText = string.format(language.GetPhrase("svmod.home.vehicle_plurial_incompatible"), vehicleIncompatibleCount)
	else
		incompatibleText = string.format(language.GetPhrase("svmod.home.vehicle_incompatible"), vehicleIncompatibleCount)
	end

	if vehicleIncompatibleCount == 0 then
		createStatus(true, loadedText .. ", " .. incompatibleText)
	else
		createStatus(false, loadedText .. ", " .. incompatibleText)
	end

	SVMOD:CreateHorizontalLine(panel)

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.home.enable_svmod"), {
		{
			Name = language.GetPhrase("svmod.enable"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (data.Status == true),
			DoClick = function()
				SVMOD:SetAddonState(true)
				panel:GetParent():Remove()
			end
		},
		{
			Name = language.GetPhrase("svmod.disable"),
			Color = Color(173, 48, 43),
			HoverColor = Color(224, 62, 56),
			IsSelected = (data.Status == false),
			DoClick = function()
				SVMOD:SetAddonState(false)
				panel:GetParent():Remove()
			end
		}
	})

	local perfMode = 0
	if SVMOD.CFG.Lights.DrawProjectedLights then
		if not SVMOD.CFG.Lights.DrawShadows then
			perfMode = 1
		else
			perfMode = 2
		end
	end

	SVMOD:CreateSettingPanel(panel, language.GetPhrase("svmod.home.performance"), {
		{
			Name = language.GetPhrase("svmod.home.high"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (perfMode == 2),
			DoClick = function()
				SVMOD.CFG.Lights.DrawProjectedLights = true
				SVMOD.CFG.Lights.DrawShadows = true
				SVMOD.CFG.Damage.DrawSmoke = true

				SVMOD:Save()
			end
		},
		{
			Name = language.GetPhrase("svmod.home.normal"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (perfMode == 1),
			DoClick = function()
				SVMOD.CFG.Lights.DrawProjectedLights = true
				SVMOD.CFG.Lights.DrawShadows = false
				SVMOD.CFG.Damage.DrawSmoke = true

				SVMOD:Save()
			end
		},
		{
			Name = language.GetPhrase("svmod.home.low"),
			Color = Color(59, 217, 85),
			HoverColor = Color(156, 255, 161),
			IsSelected = (perfMode == 0),
			DoClick = function()
				SVMOD.CFG.Lights.DrawProjectedLights = false
				SVMOD.CFG.Lights.DrawShadows = false
				SVMOD.CFG.Damage.DrawSmoke = false

				SVMOD:Save()
			end
		}
	})

	SVMOD:CreateHorizontalLine(panel)

	local bottomPanel = vgui.Create("DPanel", panel)
	bottomPanel:Dock(TOP)
	bottomPanel:DockMargin(0, 4, 0, 4)
	bottomPanel:SetSize(0, 30)
	bottomPanel:SetPaintBackground(false)

	SVMOD:CreateButton(bottomPanel, language.GetPhrase("svmod.home.support"), function()
		gui.OpenURL("https://discord.svmod.com")
	end)

	local resetButton = SVMOD:CreateButton(bottomPanel, language.GetPhrase("svmod.reset"), function(self)
		if self:GetText() == language.GetPhrase("svmod.home.confirm") then
			net.Start("SV_Settings_HardReset")
			net.WriteBool(true) -- anti netscan
			net.SendToServer()

			panel:GetParent():Remove()
		else
			self:SetText(language.GetPhrase("svmod.home.confirm"))
		end
	end)
	resetButton:DockMargin(6, 0, 0, 0)

	surface.SetFont("SV_Calibri18")
	local firstWidth = surface.GetTextSize(language.GetPhrase("svmod.home.developped_with"))
	local secondWidth = surface.GetTextSize(language.GetPhrase("svmod.home.by"))

	local firstLabel = vgui.Create("DLabel", bottomPanel)
	firstLabel:SetFont("SV_Calibri18")
	firstLabel:SetText(language.GetPhrase("svmod.home.developped_with"))
	firstLabel:SizeToContents()

	local secondLabel = vgui.Create("DLabel", bottomPanel)
	secondLabel:SetFont("SV_Calibri18")
	secondLabel:SetColor(Color(173, 48, 43))
	secondLabel:SetText("♥")
	secondLabel:SizeToContents()

	local thirdLabel = vgui.Create("DLabel", bottomPanel)
	thirdLabel:SetFont("SV_Calibri18")
	thirdLabel:SetText(language.GetPhrase("svmod.home.by"))
	thirdLabel:SizeToContents()

	timer.Simple(FrameTime(), function()
		if IsValid(firstLabel) and IsValid(secondLabel) and IsValid(thirdLabel) and IsValid(bottomPanel) then
			firstLabel:SetPos(bottomPanel:GetSize() - firstWidth - 20 - secondWidth - 5, 4)
			secondLabel:SetPos(bottomPanel:GetSize() - 14 - secondWidth - 5, 4)
			thirdLabel:SetPos(bottomPanel:GetSize() - secondWidth - 5, 4)
		end
	end)
end