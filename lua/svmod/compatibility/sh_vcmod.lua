hook.Add("SV_Enabled", function()
	if VCMOD then
		return
	end

	function SVMOD.Metatable:VC_fuelGet(percent)
		if percent then
			return self:SV_GetPercentFuel()
		else
			return self:SV_GetFuel()
		end
	end
	function SVMOD.Metatable:VC_GetFuel(percent)
		return self:VC_fuelGet(percent)
	end

	function SVMOD.Metatable:VC_getHealth(percent)
		if CLIENT or percent then
			return self:SV_GetPercentHealth()
		else
			return self:SV_GetHealth()
		end
	end
	function SVMOD.Metatable:VC_GetHealth(percent)
		return self:VC_getHealth(percent)
	end

	function SVMOD.Metatable:VC_getHealthMax()
		return self:SV_GetMaxHealth()
	end
	function SVMOD.Metatable:VC_GetMaxHealth()
		return self:VC_getHealthMax()
	end

	function SVMOD.Metatable:VC_getDamagedParts()
		return {}
	end
	function SVMOD.Metatable:VC_GetDamagedParts()
		return self:VC_getDamagedParts()
	end

	function VC_getSettings()
		SVMOD:PrintConsole(SVMOD.LOG.Error, "VC_getSettings called! This may generate errors because the SVMod cannot return the VCMod configuration file.")
	end
end)
