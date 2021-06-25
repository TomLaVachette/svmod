function SVMOD:EDITOR_General(panel, veh)
	panel:Clear()

	local bottomPanel = vgui.Create("DPanel", panel)
	bottomPanel:Dock(BOTTOM)
	bottomPanel:SetSize(0, 30)
	bottomPanel:SetPaintBackground(false)

	local authorTextBox
	local workshopTextBox

	local addButton = SVMOD:CreateButton(bottomPanel, "SAVE", function()
		local tab = table.Copy(veh.SV_Data)

		tab.Timestamp = nil
		tab.Author.Name = authorTextBox:GetValue()
		tab.Author.SteamID64 = LocalPlayer():SteamID64()
		tab.WorkshopID = workshopTextBox:GetValue()

		for _, v in ipairs(tab.FlashingLights) do
			if v.Sprite then
				v.Sprite.CurrentAngle = nil
			end

			if v.SpriteCircle then
				v.SpriteCircle.CurrentAngle = nil
			end
		end

		local name = "Unknown"
		for _, vehData in ipairs(SVMOD:GetVehicleList()) do
			if vehData.Model == veh:GetModel() then
				name = vehData.Name .. " (" .. vehData.Category .. ")"
				break
			end
		end

		HTTP({
			url = "https://api.svmod.com/add_vehicle.php",
			method = "POST",
			body = util.TableToJSON({
				name = name,
				model = veh:GetModel(),
				json = util.TableToJSON(tab),
				version = tostring(SVMOD.FCFG.DataVersion),
				serial = SVMOD.CFG.Contributor.Key,
				enterpriseID = SVMOD.CFG.Contributor.EnterpriseID
			}),
			success = function(code, body)
				if code == 200 then
					notification.AddLegacy("Data was sent successfully.", NOTIFY_GENERIC, 5)

					SVMOD:SetAddonState(false)
					timer.Simple(1, function()
						SVMOD:SetAddonState(true)
					end)
				else
					notification.AddLegacy("Invalid API key.", NOTIFY_ERROR, 5)
				end

				if IsValid(panel:GetParent()) then
					panel:GetParent():ManualClose()
				end
			end,
			failed = function()
				notification.AddLegacy("Server does not respond.", NOTIFY_ERROR, 5)
			end
		})
	end)
	addButton:Dock(RIGHT)

	local focusButton = SVMOD:CreateButton(bottomPanel, "FOCUS", function(btn)
		local frame = panel:GetParent()

		if btn:GetText() == "UNFOCUS" then
			frame:DisableFocus()
			btn:SetText("FOCUS")
		else
			frame:EnableFocus()
			btn:SetText("UNFOCUS")
		end
	end)
	focusButton:Dock(RIGHT)
	focusButton:DockMargin(0, 0, 10, 0)

	SVMOD:CreateTitle(panel, "INFORMATIONS")

	local function createField(name, value)
		local authorPanel = vgui.Create("DPanel", panel)
		authorPanel:Dock(TOP)
		authorPanel:DockMargin(0, 4, 0, 4)
		authorPanel:SetSize(0, 30)
		authorPanel:SetPaintBackground(false)

		local label = vgui.Create("DLabel", authorPanel)
		label:SetPos(2, 4)
		label:SetFont("SV_Calibri18")
		label:SetText(name)
		label:SizeToContents()

		textBox = SVMOD:CreateTextboxPanel(authorPanel, name)
		textBox:SetValue(value or "")

		return textBox
	end

	authorTextBox = createField(language.GetPhrase("svmod.vehicles.author"), veh.SV_Data.Author.Name or "")
	workshopTextBox = createField(language.GetPhrase("svmod.editor.workshop"), veh.SV_Data.WorkshopID or "")

	local label = vgui.Create("DLabel", panel)
	label:Dock(TOP)
	label:DockMargin(0, 5, 0, 0)
	label:SetFont("SV_Calibri18")
	if SVMOD.CFG.Contributor.EnterpriseID == 0 then
		label:SetText(language.GetPhrase("svmod.editor.dbpublic"))
	else
		label:SetText(language.GetPhrase("svmod.editor.dbprivate") .. SVMOD.CFG.Contributor.EnterpriseID .. ").")
	end
	label:SizeToContents()

	local title = SVMOD:CreateTitle(panel, "TOOLS")
	title:DockMargin(0, 30, 0, 0)

	local blinkerPanel = vgui.Create("DPanel", panel)
	blinkerPanel:Dock(TOP)
	blinkerPanel:SetSize(0, 35)
	blinkerPanel:SetPaintBackground(false)

	local function symmetric(tab)
		for k, v in pairs(tab) do
			if istable(v) then
				symmetric(v)
			elseif isvector(v) then
				tab[k].x = -v.x
			end
		end
	end

	local blinkerButton = SVMOD:CreateButton(blinkerPanel, "COPY LEFT BLINKERS TO RIGHT", function()
		for _, l in ipairs(veh.SV_Data.Blinkers.LeftLights) do
			local tab = SVMOD:DeepCopy(l)
			symmetric(tab)
			table.insert(veh.SV_Data.Blinkers.RightLights, tab)
		end
	end)
	blinkerButton:SetSize(340, 0)
	blinkerButton:Dock(LEFT)

	local blinkerButton = SVMOD:CreateButton(blinkerPanel, "COPY RIGHT BLINKERS TO LEFT", function()
		for _, l in ipairs(veh.SV_Data.Blinkers.RightLights) do
			local tab = SVMOD:DeepCopy(l)
			symmetric(tab)
			table.insert(veh.SV_Data.Blinkers.LeftLights, tab)
		end
	end)
	blinkerButton:SetSize(340, 0)
	blinkerButton:Dock(RIGHT)

	local blinkerButton = SVMOD:CreateButton(panel, "COPY BRAKE TO HEADLIGHTS", function()
		for _, l in ipairs(veh.SV_Data.Back.BrakeLights) do
			local tab = SVMOD:DeepCopy(l)
			table.insert(veh.SV_Data.Headlights, tab)
		end
		surface.PlaySound("buttons/button14.wav")
		notification.AddLegacy("Brake lights copied to headlights.", NOTIFY_GENERIC, 3)
	end)
	blinkerButton:SetSize(0, 35)
	blinkerButton:Dock(TOP)
	blinkerButton:DockMargin(0, 10, 0, 0)

	local blinkerButton = SVMOD:CreateButton(panel, "COPY BRAKE TO REVERSING", function()
		for _, l in ipairs(veh.SV_Data.Back.BrakeLights) do
			local tab = SVMOD:DeepCopy(l)
			table.insert(veh.SV_Data.Back.ReversingLights, tab)
		end
		surface.PlaySound("buttons/button14.wav")
		notification.AddLegacy("Brake lights copied to reversing lights.", NOTIFY_GENERIC, 3)
	end)
	blinkerButton:SetSize(0, 35)
	blinkerButton:Dock(TOP)
	blinkerButton:DockMargin(0, 10, 0, 0)
end