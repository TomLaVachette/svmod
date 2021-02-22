function SVMOD:EDITOR_General(panel, veh)
	panel:Clear()

    local bottomPanel = vgui.Create("DPanel", panel)
    bottomPanel:Dock(BOTTOM)
    bottomPanel:SetSize(0, 30)
    bottomPanel:SetDrawBackground(false)

    local authorTextBox

    local addButton = SVMOD:CreateButton(bottomPanel, "SAVE", function()
        local tab = table.Copy(veh.SV_Data)

		tab.Timestamp = nil

		for _, v in ipairs(tab.FlashingLights) do
			if v.Sprite then
				v.Sprite.CurrentAngle = nil
			end

			if v.SpriteCircle then
				v.SpriteCircle.CurrentAngle = nil
			end
		end

		HTTP({
			url = "https://api.svmod.com/add_vehicle.php",
			method = "POST",
			parameters = {
				model = veh:GetModel(),
				json = util.TableToJSON(tab),
				version = tostring(SVMOD.FCFG.DataVersion),
				serial = SVMOD.CFG.Contributor.Key
			},
			success = function(code, body)
				if code == 200 then
					notification.AddLegacy("Data was sent successfully.", NOTIFY_GENERIC, 5)

					SVMOD:Data_Update()
				else
					print(body)
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

    local authorPanel = vgui.Create("DPanel", panel)
	authorPanel:Dock(TOP)
	authorPanel:DockMargin(0, 4, 0, 4)
	authorPanel:SetSize(0, 30)
	authorPanel:SetDrawBackground(false)

	local label = vgui.Create("DLabel", authorPanel)
	label:SetPos(2, 4)
	label:SetFont("SV_Calibri18")
	label:SetText(language.GetPhrase("svmod.vehicles.author"))
	label:SizeToContents()

	authorTextBox = SVMOD:CreateTextboxPanel(authorPanel, language.GetPhrase("svmod.vehicles.author"))
	authorTextBox:SetValue(veh.SV_Data.Author.Name or "")
	authorTextBox.OnValueChange = function(self, val)
		veh.SV_Data.Author.Name = val
		veh.SV_Data.Author.SteamID64 = LocalPlayer():SteamID64()
	end

	local title = SVMOD:CreateTitle(panel, "TOOLS")
	title:DockMargin(0, 30, 0, 0)

	local blinkerPanel = vgui.Create("DPanel", panel)
	blinkerPanel:Dock(TOP)
	blinkerPanel:SetSize(0, 35)
	blinkerPanel:SetDrawBackground(false)

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
    end)
	blinkerButton:SetSize(0, 35)
    blinkerButton:Dock(TOP)
	blinkerButton:DockMargin(0, 10, 0, 0)
end