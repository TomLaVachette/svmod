function SVMOD:AddPlurial(value)
	if value > 1 then
		return "s"
	end
	return ""
end

function SVMOD:RotateAroundAxis(ang1, ang2)
	ang1:RotateAroundAxis(ang1:Forward(), ang2.p)
	ang1:RotateAroundAxis(ang1:Right(), ang2.r)
	ang1:RotateAroundAxis(ang1:Up(), ang2.y)

	return ang1
end

function SVMOD:DeepCopy(tab)
	local result = table.Copy(tab)

	for k, v in pairs(result) do
		if type(v) == "pixelvis_handle_t" or type(v) == "ProjectedTexture" then
			result[k] = nil
		elseif isvector(v) then
			result[k] = Vector(v.x, v.y, v.z)
		elseif isangle(v) then
			result[k] = Angle(v.x, v.y, v.z)
		elseif istable(v) then
			result[k] = SVMOD:DeepCopy(v)
		end
	end

	return result
end

SVMOD.LOG = {
	Info = Color(102, 181, 255),
	Alert = Color(255, 186, 102),
	Error = Color(255, 102, 102)
}

function SVMOD:PrintConsole(type, message)
	MsgC(type, "[SVMod] ", Color(255, 255, 255), message, "\n")
end

function SVMOD:GetVehicleList()
	local result = {}

	for _, veh in pairs(list.Get("Vehicles")) do
		if not table.HasValue(SVMOD.FCFG.BlacklistedModels, string.lower(veh.Model)) then
			table.insert(result, veh)
		end
	end

	return result
end

function SVMOD:GetConflictList()
	local result = ""

	for _, v in ipairs(self.FCFG.ConflictList) do
		if _G[v.Variable] ~= nil then
			result = result .. v.Name .. ", "
		end
	end

	if #result > 0 then
		result = string.sub(result, 1, -3)
	end

	return result
end