-- @class SV_Vehicle
-- @serverside

util.AddNetworkString("SV_StartRepair")
net.Receive("SV_StartRepair", function(_, ply)
	local veh = net.ReadEntity()
	if not SVMOD:IsVehicle(veh) then return end

	local index = net.ReadUInt(4)

	veh:SV_StartRepair(ply, index)
end)

util.AddNetworkString("SV_StopRepair")
net.Receive("SV_StopRepair", function(_, ply)
	local Vehicle = net.ReadEntity()
	if not SVMOD:IsVehicle(Vehicle) then return end

	Vehicle:SV_StopRepair(ply)
end)

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
	local timerName = "SV_RepairVehicle_" .. self:EntIndex() .. "_" .. ply:UserID()

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
		elseif part:GetHealth() >= 100 then
			-- Full health
			self:SV_StopRepair(ply)
			hook.Run("SV_PartRepaired", self, ply)
		else
			part:SetHealth(math.floor(part:GetHealth() + (2.5 * partCount)))
			self:GetPhysicsObject():ApplyForceCenter(Vector(20000, 20000, 20000))
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

	timer.Remove("SV_RepairVehicle_" .. self:EntIndex() .. "_" .. ply:UserID())
end