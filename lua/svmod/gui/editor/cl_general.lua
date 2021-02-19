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
                    panel:GetParent():Remove()
                end
			end,
			failed = function()
				notification.AddLegacy("Server does not respond.", NOTIFY_ERROR, 5)
			end
		})
    end)
    addButton:Dock(RIGHT)

    local focusButton = SVMOD:CreateButton(bottomPanel, "FOCUS", function()
        panel:GetParent():MakePopup()
        hook.Remove("ScoreboardHide", "SV_Editor_Hide")
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
	label:SetText(SVMOD:GetLanguage("Author"))
	label:SizeToContents()

	authorTextBox = SVMOD:CreateTextboxPanel(authorPanel, "Author")
	authorTextBox:SetValue(veh.SV_Data.Author.Name or "")
	authorTextBox.OnValueChange = function(self, val)
		veh.SV_Data.Author.Name = val
		veh.SV_Data.Author.SteamID64 = LocalPlayer():SteamID64()
	end
end