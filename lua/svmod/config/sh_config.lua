SVMOD.FCFG = {}

-- FCFG for File Configuration
-- The configurations in this table are not saved to a file.

SVMOD.FCFG.Version = "1.4.0"
SVMOD.FCFG.FileVersion = "1.4.0"
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
	{
		Name = "Novacars",
		Variable = "NOVA_Config"
	}
}

function SVMOD:Load()
	local config
	if SERVER then
		config = file.Read("svmod/server_" .. string.Replace(SVMOD.FCFG.FileVersion, ".", "_") .. ".txt")
	else
		config = file.Read("svmod/client_" .. string.Replace(SVMOD.FCFG.FileVersion, ".", "_") .. ".txt")
	end

	if config then
		config = util.JSONToTable(config)

		if config then
			self.CFG = config

			if SERVER then
				self.CFG.Others.HUDColor = Color(self.CFG.Others.HUDColor.r, self.CFG.Others.HUDColor.g, self.CFG.Others.HUDColor.b)
			elseif self.CFG.Shortcuts then
				-- CLIENT
				for i, s in ipairs(self.CFG.Shortcuts) do
					self.Shortcuts[i].Key = s
				end
			end
		end
	else
		-- Temporary convertor from 1.3 to 1.4
		if SERVER and file.Exists("svmod/server_1_3_2.txt", "DATA") then
			self.CFG = util.JSONToTable(file.Read("svmod/server_1_3_2.txt"))
			self.CFG.Damage.WheelShotMultiplier = 1
			self.CFG.Damage.WheelCollisionMultiplier = 1
			self.CFG.Damage.TimeBeforeWheelIsPunctured = 60
			self.CFG.Others = {
				IsHUDEnabled = true,
				HUDPositionX = 0.21,
				HUDPositionY = 0.92,
				HUDSize = 90,
				HUDColor = Color(178, 95, 245),
				CustomSuspension = 0
			}
			SVMOD:Save()
			SVMOD:PrintConsole(SVMOD.LOG.Info, "Configuration file server-side converted from 1.3 to 1.4.")
			return
		elseif CLIENT and file.Exists("svmod/client_1_3_2.txt", "DATA") then
			self.CFG = util.JSONToTable(file.Read("svmod/client_1_3_2.txt"))
			SVMOD:Save()
			SVMOD:PrintConsole(SVMOD.LOG.Info, "Configuration file client-side converted from 1.3 to 1.4.")
			return
		end

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
	local cfg = table.Copy(self.CFG)

	if SERVER then
		file.Write("svmod/server_" .. string.Replace(SVMOD.FCFG.FileVersion, ".", "_") .. ".txt", util.TableToJSON(cfg))
	else
		-- Save shortcuts
		cfg.Shortcuts = {}
		for i, s in ipairs(self.Shortcuts) do
			cfg.Shortcuts[i] = s.Key
		end

		-- Disable contributor mode
		cfg.Contributor.IsEnabled = false

		-- Do not save enterprise ID client-side
		cfg.Contributor.EnterpriseID = nil

		file.Write("svmod/client_" .. string.Replace(SVMOD.FCFG.FileVersion, ".", "_") .. ".txt", util.TableToJSON(cfg))
	end
end