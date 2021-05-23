function SVMOD.Metatable:SV_SetWheelBlowout(wheelID, state)
	if not self.SV_IsTireBlowout then
		self.SV_IsTireBlowout = {}
	end

	if state then
		if self.SV_IsTireBlowout[wheelID] then
			return
		end

		self.SV_IsTireBlowout[wheelID] = true

		if not self.SV_TireBlowoutSound then
			self.SV_TireBlowoutSound = CreateSound(self, "svmod/tire/blowout_a.wav")
			self.SV_TireBlowoutSound:SetSoundLevel(75)
			self.SV_TireBlowoutSound:ChangePitch(100, 0)
			timer.Simple(0.1, function()
				if self.SV_TireBlowoutSound then
					self.SV_TireBlowoutSound:ChangeVolume(SVMOD.CFG.Sounds.Horn * 0.15, 0)
				end
			end)
		end

		self.SV_TireBlowoutSound:Play()

		local veh = self
		timer.Create("SV_WheelBlowout_" .. veh:EntIndex() .. "_" .. wheelID, 0.1, 0, function()
			if not SVMOD:IsVehicle(veh) then
				timer.Remove("SV_WheelBlowout_" .. veh:EntIndex() .. "_" .. wheelID)
				return
			end

			local pos = veh:GetAttachment(wheelID).Pos
			--local ang = veh:GetAttachment(i).Ang
			local height = 28.79
			local effectData = EffectData()
			effectData:SetOrigin(pos - Vector(0, 0, height / 2))
			effectData:SetNormal(veh:GetAngles():Right() * 0.3)
			util.Effect("manhacksparks", effectData)
		end)
	else
		if not self.SV_IsTireBlowout[wheelID] then
			return
		end

		self.SV_IsTireBlowout[wheelID] = false
		self.SV_TireBlowoutSound:Stop()
		timer.Remove("SV_WheelBlowout_" .. self:EntIndex() .. "_" .. wheelID)
	end
end

hook.Add("EntityNetworkedVarChanged", "SV_Wheel", function(veh, name, oldVal, newVal)
	if not SVMOD:IsVehicle(veh) or not oldVal then
		return
	end

	local wheelID
	if name == "SV_WheelFLHealth" then
		wheelID = veh.SV_WheelFrontLeftID
	elseif name == "SV_WheelFRHealth" then
		wheelID = veh.SV_WheelFrontRightID
	elseif name == "SV_WheelRLHealth" then
		wheelID = veh.SV_WheelRearLeftID
	elseif name == "SV_WheelRRHealth" then
		wheelID = veh.SV_WheelRearRightID
	else
		return
	end

	if math.abs(newVal - oldVal) >= 6 then
		if newVal < oldVal then
			veh:StopSound("svmod/tire/composite.wav")
			veh:EmitSound("svmod/tire/composite.wav", 75, 100, 0.5)
		else
			veh:StopSound("svmod/tire/composite_reversed.wav")
			veh:EmitSound("svmod/tire/composite_reversed.wav", 75, 100, 0.5)
		end
	end

	if newVal > 10 then
		timer.Remove("SV_WheelStartBlowout_" .. veh:EntIndex() .. "_" .. wheelID)
		veh:SV_SetWheelBlowout(wheelID, false)
	else
		timer.Create("SV_WheelStartBlowout_" .. veh:EntIndex() .. "_" .. wheelID, 0.5, 0, function()
			if not SVMOD:IsVehicle(veh) then
				timer.Remove("SV_WheelStartBlowout_" .. veh:EntIndex() .. "_" .. wheelID)
				return
			end

			if veh:GetVelocity():Length() > 50 then
				veh:SV_SetWheelBlowout(wheelID, true)
			else
				veh:SV_SetWheelBlowout(wheelID, false)
			end
		end)
	end
end)