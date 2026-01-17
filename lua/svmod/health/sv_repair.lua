-- @class SV_Vehicle
-- @serverside

util.AddNetworkString("SV_StartRepair")
net.Receive("SV_StartRepair", function(_, ply)
	local veh = net.ReadEntity()
	if not SVMOD:IsVehicle(veh) then return end

	local weapon = ply:GetActiveWeapon()
	if not IsValid(weapon) then return end
	if weapon:GetClass() ~= "sv_wrench" then return end

	local index = net.ReadUInt(4)

	veh:SV_StartRepair(ply, index)
end)

util.AddNetworkString("SV_StopRepair")
net.Receive("SV_StopRepair", function(_, ply)
	local Vehicle = net.ReadEntity()
	if not SVMOD:IsVehicle(Vehicle) then return end

	local weapon = ply:GetActiveWeapon()
	if not IsValid(weapon) then return end
	if weapon:GetClass() ~= "sv_wrench" then return end

	Vehicle:SV_StopRepair(ply)
end)

local function getTimerName(veh, ply)
	return "SV_RepairVehicle_" .. veh:EntIndex() .. "_" .. ply:UserID()
end

-- Starts the repair of the vehicle by a player.
-- @tparam Player ply Player who starts the repair
-- @internal
function SVMOD.Metatable:SV_StartRepair(ply, partIndex)
	local partCount = #self.SV_Data.Parts
	if partCount < partIndex then return end

	local part = self.SV_Data.Parts[partIndex]

	net.Start("SV_StartRepair")
	net.WriteEntity(self)
	net.WriteEntity(ply)
	net.SendPVS(ply:GetPos())

	local veh = self
	local timerName = getTimerName(self, ply)

	hook.Run("SV_PlayerStartedRepair", self, ply)

	timer.Create(timerName, 1, 0, function()
		if not SVMOD:IsVehicle(veh) then
			net.Start("SV_StopRepair")
			net.WriteEntity(ply)
			net.SendPVS(ply:GetPos())

			timer.Remove(timerName)
			return
		end

		if ply:GetPos():DistToSqr(self:GetPos()) > 50000 then
			-- Too far to repair
			self:SV_StopRepair(ply)
		else
			local oldHealth = part:GetHealth()
			local newHealth = math.floor(oldHealth + (2.5 * partCount))
			
			if hook.Run("SV_CanRepairPart", self, partIndex, ply, newHealth - oldHealth) == false then
				self:SV_StopRepair(ply)
				return
			end

			part:SetHealth(newHealth)
			
			hook.Run("SV_PartHealthChanged", self, partIndex, oldHealth, newHealth, ply)
			
			if part:GetHealth() >= 100 then
				hook.Run("SV_PartRepaired", self, ply)
				self:SV_StopRepair(ply)
			end
			self:GetPhysicsObject():ApplyForceCenter(Vector(20000, 20000, 20000))
			if part.WheelID ~= nil then
				self:SV_StopPunctureWheel(part.WheelID)
			end
		end
	end)
end

-- Stops the repair of the vehicle by a player.
-- @tparam Player ply Player who stops the repair
-- @internal
function SVMOD.Metatable:SV_StopRepair(ply)
	net.Start("SV_StopRepair")
	net.WriteEntity(ply)
	net.SendPVS(ply:GetPos())

	timer.Remove(getTimerName(self, ply))
	hook.Run("SV_PlayerStoppedRepair", self, ply)
end