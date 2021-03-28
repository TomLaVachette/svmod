util.AddNetworkString("SV_Editor_Open")
net.Receive("SV_Editor_Open", function(_, ply)
	if game.IsDedicated() then
		return
	end

	local model = net.ReadString()

	local vehData
	for _, v in pairs(SVMOD:GetVehicleList()) do
		if v.Model == model then
			vehData = v
			break
		end
	end
	if not vehData then return end

	local veh = ents.Create("prop_vehicle_jeep")
	duplicator.DoGeneric(veh, vehData)

	veh:SetModel(vehData.Model)
	veh:SetPos(ply:GetEyeTrace().HitPos)

	if vehData and vehData["KeyValues"] then
		for k, v in pairs(vehData["KeyValues"]) do
			local kLower = string.lower(k)

			if (kLower == "vehiclescript" or
				kLower == "limitview" or
				kLower == "vehiclelocked" or
				kLower == "cargovisible" or
				kLower == "enablegun")
			then
				veh:SetKeyValue(k, v)
			end
		end

		veh:SetKeyValue("enablegun", "true")
	end

	-- IsEditMode is used for bypassing some tests
	veh.SV_IsEditMode = true

	veh:Spawn()
	veh:Activate()

	hook.Run("PlayerSpawnedVehicle", ply, veh)

	veh:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	SVMOD:LoadVehicle(veh)

	timer.Simple(1, function()
		net.Start("SV_Editor_Open")
		net.WriteEntity(veh)
		net.Send(ply)
	end)
end)

util.AddNetworkString("SV_Editor_ActiveTab")
net.Receive("SV_Editor_ActiveTab", function(_, ply)
	if game.IsDedicated() then
		return
	end

	local veh = net.ReadEntity()
	if not SVMOD:IsVehicle(veh) then
		return
	end

	local name = net.ReadString()

	veh:SV_TurnOffHeadlights()
	veh:SV_TurnOffBackLights()
	veh:SV_TurnOffLeftBlinker()
	veh:SV_TurnOffRightBlinker()
	veh:SV_TurnOffFlashingLights()

	local actions = {
		["Headlights"] = "SV_TurnOnHeadlights",
		["Brake"] = "SV_TurnOnBackLights",
		["Reversing"] = "SV_TurnOnBackLights",
		["Left Blinkers"] = "SV_TurnOnLeftBlinker",
		["Right Blinkers"] = "SV_TurnOnRightBlinker",
		["Flashing"] = "SV_TurnOnFlashingLights"
	}

	if actions[name] then
		veh[actions[name]](veh)
	end
end)

util.AddNetworkString("SV_Editor_Close")
net.Receive("SV_Editor_Close", function(_, ply)
	if game.IsDedicated() then
		return
	end

	local Entity = net.ReadEntity()

	if IsValid(Entity) then
		Entity:Remove()
	end
end)