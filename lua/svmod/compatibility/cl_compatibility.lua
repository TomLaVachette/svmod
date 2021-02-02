hook.Add("InitPostEntity", "SV_VCModCommand", function()
	timer.Simple(10, function()
		if not VC then
			concommand.Add("vcmod", function()
				SVMOD:PrintConsole(SVMOD.LOG.Error, SVMOD:GetLanguage("VCMod does not exist on this server. Please type « svmod » instead."))
			end)
		end
	end)
end)