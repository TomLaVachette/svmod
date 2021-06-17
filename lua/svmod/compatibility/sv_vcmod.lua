hook.Add("SV_Enabled", function()
	if not SVMOD.IsVCEnabled and VC then
		return
	end

	SVMOD.IsVCEnabled = true
	VC = {}
	VCMOD = {}

	function SVMOD.Metatable:VC_fuelAdd(amount)
		self:SV_SetFuel(self:SV_GetFuel() + amount)
	end
	function SVMOD.Metatable:VC_Fuel_Add(amount)
		self:VC_fuelAdd(amount)
	end

	function SVMOD.Metatable:VC_fuelConsume(amount)
		self:SV_SetFuel(self:SV_GetFuel() - amount)
	end
	function SVMOD.Metatable:VC_Fuel_Consume(amount)
		self:VC_fuelConsume(amount)
	end

	function SVMOD.Metatable:VC_damageHealth(amount)
		return self:SV_SetHealth(self:SV_GetHealth() - amount)
	end
	function SVMOD.Metatable:VC_DamageHealth(amount)
		return self:VC_damageHealth(amount)
	end

	function SVMOD.Metatable:VC_repairFull_Admin()
		return self:SV_SetHealth(self:SV_GetMaxHealth())
	end
	function SVMOD.Metatable:VC_RepairFull_Admin()
		return self:VC_repairFull_Admin()
	end

	function SVMOD.Metatable:VC_setDamagedParts(table)

	end
	function SVMOD.Metatable:VC_SetDamagedParts(table)
		self:VC_setDamagedParts(table)
	end
end)
