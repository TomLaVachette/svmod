local commands = {
	["!Svmod"] = true,
	["!svmod"] = true,
	["/Svmod"] = true,
	["/svmod"] = true
}

hook.Add("OnPlayerChat", "SV_OpenMenu", function(ply, text)
	if commands[text] then
		if ply == LocalPlayer() then
			RunConsoleCommand("svmod")
		end

		return true
	end
end)