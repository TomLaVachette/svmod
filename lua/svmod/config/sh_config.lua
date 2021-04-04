SVMOD.FCFG = {}

-- FCFG for File Configuration
-- The configurations in this table are not saved to a file.

SVMOD.FCFG.Version = "1.3.3"
SVMOD.FCFG.FileVersion = "1.3.2"
SVMOD.FCFG.DataVersion = 2
SVMOD.FCFG.LastVersion = "?" -- Do not change

SVMOD.FCFG.ShortcutTime = 0.3

SVMOD.FCFG.BlacklistedModels = {
	"models/nova/airboat_seat.mdl",
	"models/nova/chair_office02.mdl",
	"models/props_phx/carseat2.mdl",
	"models/props_phx/carseat3.mdl",
	"models/props_phx/carseat2.mdl",
	"models/nova/chair_plastic01.mdl",
	"models/nova/jeep_seat.mdl",
	"models/nova/chair_wood01.mdl",
	"models/nova/chair_office01.mdl",
	"models/vehicles/prisoner_pod_inner.mdl",
	"models/nova/jalopy_seat.mdl"
}

SVMOD.FCFG.ConflictList = {
	{
		Name = "VCMod Main",
		Variable = "vcmod_main"
	},
	-- {
	--	 Name = "Photon",
	--	 Variable = "Photon"
	-- }
}

function SVMOD:Load()
	local Config
	if SERVER then
		Config = file.Read("svmod/server_" .. string.Replace(SVMOD.FCFG.FileVersion, ".", "_") .. ".txt")
	else
		Config = file.Read("svmod/client_" .. string.Replace(SVMOD.FCFG.FileVersion, ".", "_") .. ".txt")
	end

	if Config then
		Config = util.JSONToTable(Config)

		if Config then
			self.CFG = Config

			if CLIENT and self.CFG.Shortcuts then
				for i, s in ipairs(self.CFG.Shortcuts) do
					self.Shortcuts[i].Key = s
				end
			end
		end
	else
		if SERVER then
			hook.Add("PlayerInitialSpawn", "SV_SendWelcomeGUI", function(ply)
				timer.Simple(10, function()
					if game.SinglePlayer() or ply:IsSuperAdmin() then
						hook.Remove("PlayerInitialSpawn", "SV_SendWelcomeGUI")
						net.Start("SV_WelcomeGUI")
						net.Send(ply)
					end
				end)
			end)
		end

		SVMOD:Save()
	end
end

function SVMOD:Save()
	local Config = table.Copy(self.CFG)

	if SERVER then
		file.Write("svmod/server_" .. string.Replace(SVMOD.FCFG.FileVersion, ".", "_") .. ".txt", util.TableToJSON(Config))
	else
		-- Save shortcuts
		Config.Shortcuts = {}
		for i, s in ipairs(self.Shortcuts) do
			Config.Shortcuts[i] = s.Key
		end

		-- Disable contributor mode
		Config.Contributor.IsEnabled = false

		-- Do not save enterprise ID client-side
		Config.Contributor.EnterpriseID = nil

		file.Write("svmod/client_" .. string.Replace(SVMOD.FCFG.FileVersion, ".", "_") .. ".txt", util.TableToJSON(Config))
	end
end