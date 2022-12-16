ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.PrintName		= "Repair"
ENT.Category		= "SVMod" 
ENT.Author 			= "Seefox"
ENT.Contact	= "From workshop page only!"
ENT.Instructions = "Use to repair the vehicle."

ENT.Spawnable		= true
ENT.AdminSpawnable		= true
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end