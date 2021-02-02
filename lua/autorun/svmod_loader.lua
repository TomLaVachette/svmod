SVMOD = {}
SVMOD.Metatable = {}

local function RecursiveLoad(path)
	local Files, Directories = file.Find(path .. "*", "LUA")

	for _, f in ipairs(Files) do
		if string.match(f, "^sv") then
			if SERVER then
				include(path .. f)
			end
		elseif string.match(f, "^sh") then
			AddCSLuaFile(path .. f)
			include(path .. f)
		elseif string.match(f, "^cl") then
			AddCSLuaFile(path .. f)
			if CLIENT then
				include(path .. f)
			end
		end
	end

	for _, d in ipairs(Directories) do
		RecursiveLoad(path .. d .. "/")
	end
end

RecursiveLoad("svmod/")