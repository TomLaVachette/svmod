net.Receive("SV_Editor_Open", function()
	local veh = net.ReadEntity()
	
	if not veh.SV_Data then
		SVMOD.Data[string.lower(veh:GetModel())] = {
			Author = {},
			Seats = {},
			Parts = {},
			Sounds = {},
			Headlights = {},
			Back = {
				BrakeLights = {},
				ReversingLights = {}
			},
			Blinkers = {
				LeftLights = {},
				RightLights = {}
			},
			FlashingLights = {},
			Fuel = {
				Capacity = 60,
				Consumption = 5,
				GasTank = {},
				GasolinePistol = {}
			}
		}

		SVMOD:LoadVehicle(veh)
	end

	local function activeTab(name)
		net.Start("SV_Editor_ActiveTab")
		net.WriteEntity(veh)
		net.WriteString(name)
		net.SendToServer()
	end

	local frame = SVMOD:CreateFrame("SVMOD : EDITOR")
	frame:SetSize(900, 930)
    frame:SetPos(10, 10)
    frame:SetAlpha(25)

    hook.Add("ScoreboardShow", "SV_Editor_Show", function()
        frame:SetAlpha(255)
        gui.EnableScreenClicker(true)

        return true
    end)

    hook.Add("ScoreboardHide", "SV_Editor_Hide", function()
        frame:SetAlpha(25)
        gui.EnableScreenClicker(false)

        return true
    end)

    frame:CreateMenuButton("GENERAL", TOP, function()
		activeTab("None")
		SVMOD:EDITOR_General(frame:GetCenterPanel(), veh)
	end)
	
	frame:CreateMenuButton(SVMOD:GetLanguage("SEATS"), TOP, function()
		activeTab("None")
		SVMOD:EDITOR_Seats(frame:GetCenterPanel(), veh)
	end)

	frame:CreateMenuButton(SVMOD:GetLanguage("HEADLIGHTS"), TOP, function()
		activeTab("Headlights")
		SVMOD:EDITOR_Lights(frame:GetCenterPanel(), veh.SV_Data.Headlights)
	end)

	frame:CreateMenuButton(SVMOD:GetLanguage("BRAKE"), TOP, function()
		activeTab("Brake")
		SVMOD:EDITOR_Lights(frame:GetCenterPanel(), veh.SV_Data.Back.BrakeLights)
	end)

	frame:CreateMenuButton(SVMOD:GetLanguage("REVERSING"), TOP, function()
		activeTab("Reversing")
		timer.Simple(0.1, function()
			timer.Remove("SV_DetectReversing_" .. veh:EntIndex())
			veh.SV_IsReversing = true
		end)

		SVMOD:EDITOR_Lights(frame:GetCenterPanel(), veh.SV_Data.Back.ReversingLights)
	end)

	frame:CreateMenuButton(SVMOD:GetLanguage("LEFT BLINKERS"), TOP, function()
		activeTab("Left Blinkers")
		SVMOD:EDITOR_Lights(frame:GetCenterPanel(), veh.SV_Data.Blinkers.LeftLights)
	end)

	frame:CreateMenuButton(SVMOD:GetLanguage("RIGHT BLINKERS"), TOP, function()
		activeTab("Right Blinkers")
		SVMOD:EDITOR_Lights(frame:GetCenterPanel(), veh.SV_Data.Blinkers.RightLights)
	end)

	frame:CreateMenuButton(SVMOD:GetLanguage("FLASHING"), TOP, function()
		activeTab("Flashing")
		SVMOD:EDITOR_Lights(frame:GetCenterPanel(), veh.SV_Data.FlashingLights, true)
	end)

	frame:CreateMenuButton(SVMOD:GetLanguage("FUEL"), TOP, function()
		activeTab("None")
		SVMOD:EDITOR_Fuel(frame:GetCenterPanel(), veh, veh.SV_Data.Fuel)
	end)

	frame:CreateMenuButton(SVMOD:GetLanguage("SOUNDS"), TOP, function()
		activeTab("None")
		SVMOD:EDITOR_Sounds(frame:GetCenterPanel(), veh.SV_Data.Sounds)
	end)

    frame:CreateMenuButton(SVMOD:GetLanguage("CLOSE"), BOTTOM, function()
		local closeFrame = vgui.Create("DFrame")
		closeFrame:SetSize(300, 110)
		closeFrame:Center()
		closeFrame:ShowCloseButton(false)
		closeFrame:SetTitle("")
		closeFrame.Paint = function(self, w, h)
			surface.SetDrawColor(18, 25, 31)
			surface.DrawRect(0, 0, w, h)
	
			surface.SetDrawColor(178, 95, 245)
			surface.DrawRect(0, 0, w, 4)
		end
		closeFrame:MakePopup()

		local button = SVMOD:CreateButton(closeFrame, SVMOD:GetLanguage("CLOSE AND LOSE ALL MODIFICATIONS"), function()
			closeFrame:Close()
			frame:Close()
		end)
		button:Dock(TOP)
		button:SetSize(0, 30)

		local button = SVMOD:CreateButton(closeFrame, SVMOD:GetLanguage("PLEASE NO, CANCEL"), function()
			closeFrame:Close()
		end)
		button:Dock(TOP)
		button:SetSize(0, 30)
	end)

	frame.OnRemove = function()
		net.Start("SV_Editor_Close")
		net.WriteEntity(veh)
		net.SendToServer()

        gui.EnableScreenClicker(false)

        hook.Remove("ScoreboardShow", "SV_Editor_Show")
        hook.Remove("ScoreboardHide", "SV_Editor_Hide")
	end
end)