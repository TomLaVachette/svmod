hook.Add("InitPostEntity", "SV_VCModCommand", function()
	timer.Simple(10, function()
		if not VC then
			concommand.Add("vcmod", function()
				SVMOD:PrintConsole(SVMOD.LOG.Error, language.GetPhrase("svmod.vcmod"))
			end)
		end
	end)
end)