hook.Add("SV_Enabled", "SV_FixWCD", function()
	if not WCD then return end

	local function enterWCDVehicle(ply, ent, customize)
		if (ent.keysUnLock and ent.Fire) then
			ent:keysUnLock(ply)
		end

		if (ent.keysOwn) then
			ent:keysOwn(ply)
		end

		ply:EnterVehicle(ent)

		if (not IsValid(ply:GetVehicle())) then
			ent:Use(ply, ply, USE_ON, 1)
		end

		if (customize) then
			net.Start("WCD::SpawnAndCustomize")
			net.WriteFloat(ent:WCD_GetId())
			net.WriteTable(ply:WCD_GetSpecifics(ent:WCD_GetId()) or {})
			net.WriteFloat(ent:EntIndex())
			net.Send(ply)
			ply.__wcdSpawnedLatest = ent
		end
	end

	local waitingSVLoad = {}

	hook.Add("SV_VehicleLoaded", "WCD", function(ent)
		if not waitingSVLoad[ent] then return end

		local data = waitingSVLoad[ent]

		WCD:ApplySpecifics(ent)

		enterWCDVehicle(data[1], ent, data[2])

		waitingSVLoad[ent] = nil
	end)

	function WCD:PostSpawnedVehicle(_p, _e, customize, isEnt)
		if (not isEnt) then
			if (LPlates) then
				LPlates.SetupVehiclePlates(_p, _e)
			end

			if (LL_PLATES_SYSTEM) then
				LL_PLATES_SYSTEM:PrepareVehicle(_p, _e)
			end

			if (Photon) then
				Photon:EntityCreated(_e)
			end
		else
			if (_e.simfphys and simfphys and simfphys.RegisterEquipment) then
				timer.Simple(3, function()
					if (IsValid(_e)) then
						simfphys.RegisterEquipment(_e)
					end
				end)
			end
		end

		if (self.Settings.autoEnter or customize) then
			if SVMOD:IsVehicle(_e) then
				enterWCDVehicle(_p, _e, customize)
			else
				waitingSVLoad[_e] = {_p, customize}
			end
		end

		if (_e.keysOwn) then
			_e:keysOwn(_p)
		end

		if (self.Settings.autoLock and _e.Fire) then
			if (_e.keysLock) then
				_e:keysLock(_p)
			end
		else
			if (_e.keysUnLock) then
				_e:keysUnLock(_p)
			end
		end
	end
end)