local function openEditor(veh)
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

		veh.SV_IsEditMode = true

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

	frame.EnableFocus = function(self)
		hook.Remove("ScoreboardShow", "SV_Editor_Show")
		hook.Remove("ScoreboardHide", "SV_Editor_Hide")

		self:MakePopup()
	end

	frame.DisableFocus = function(self)
		frame:Remove()
		openEditor(veh)
	end

	frame.ManualClose = function(self)
		self:Remove()

		net.Start("SV_Editor_Close")
		net.WriteEntity(veh)
		net.SendToServer()

		gui.EnableScreenClicker(false)

		hook.Remove("ScoreboardShow", "SV_Editor_Show")
		hook.Remove("ScoreboardHide", "SV_Editor_Hide")
	end

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

	frame:CreateMenuButton(language.GetPhrase("svmod.home.home"), TOP, function()
		activeTab("None")
		SVMOD:EDITOR_General(frame:GetCenterPanel(), veh)
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.seats.seats"), TOP, function()
		activeTab("None")
		SVMOD:EDITOR_Seats(frame:GetCenterPanel(), veh)
	end)

	for i, light in ipairs(veh.SV_Data.Headlights) do
		if light.Sprite and light.ProjectedTexture then
			table.insert(veh.SV_Data.Headlights, { Sprite = SVMOD:DeepCopy(light.Sprite) })
			veh.SV_Data.Headlights[i].Sprite = nil
		end
	end

	frame:CreateMenuButton(language.GetPhrase("svmod.lights.headlights"), TOP, function()
		activeTab("Headlights")
		SVMOD:EDITOR_Lights(frame:GetCenterPanel(), veh.SV_Data.Headlights, veh)
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.editor.brake"), TOP, function()
		activeTab("Brake")
		SVMOD:EDITOR_Lights(frame:GetCenterPanel(), veh.SV_Data.Back.BrakeLights, veh)
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.editor.reversing"), TOP, function()
		activeTab("Reversing")
		timer.Simple(0.1, function()
			timer.Remove("SV_DetectReversing_" .. veh:EntIndex())
			veh.SV_IsReversing = true
		end)

		SVMOD:EDITOR_Lights(frame:GetCenterPanel(), veh.SV_Data.Back.ReversingLights, veh)
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.editor.left_blinker"), TOP, function()
		activeTab("Left Blinkers")
		SVMOD:EDITOR_Lights(frame:GetCenterPanel(), veh.SV_Data.Blinkers.LeftLights, veh)
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.editor.right_blinker"), TOP, function()
		activeTab("Right Blinkers")
		SVMOD:EDITOR_Lights(frame:GetCenterPanel(), veh.SV_Data.Blinkers.RightLights, veh)
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.els.els"), TOP, function()
		activeTab("Flashing")
		SVMOD:EDITOR_Lights(frame:GetCenterPanel(), veh.SV_Data.FlashingLights, veh, true)
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.editor.parts"), TOP, function()
		activeTab("None")
		SVMOD:EDITOR_Parts(frame:GetCenterPanel(), veh, veh.SV_Data.Parts)
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.fuel.fuel"), TOP, function()
		activeTab("None")
		SVMOD:EDITOR_Fuel(frame:GetCenterPanel(), veh, veh.SV_Data.Fuel)
	end)

	frame:CreateMenuButton(language.GetPhrase("svmod.sounds.sounds"), TOP, function()
		activeTab("None")
		SVMOD:EDITOR_Sounds(frame:GetCenterPanel(), veh.SV_Data.Sounds)
	end)

	frame.CustomClose = function()
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

		local button = SVMOD:CreateButton(closeFrame, language.GetPhrase("svmod.editor.close_and_lose"), function()
			closeFrame:Close()
			frame:ManualClose()
		end)
		button:Dock(TOP)
		button:SetSize(0, 30)

		local button = SVMOD:CreateButton(closeFrame, language.GetPhrase("svmod.editor.cancel_close"), function()
			closeFrame:Close()
		end)
		button:Dock(TOP)
		button:SetSize(0, 30)
	end

	SVMOD:EDITOR_General(frame:GetCenterPanel(), veh)
end

net.Receive("SV_Editor_Open", function()
	local veh = net.ReadEntity()

	openEditor(veh)
end)