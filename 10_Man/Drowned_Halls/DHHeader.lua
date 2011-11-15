-- Drowned Halls Header for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDH_Settings = {}

local DH = {
	Header = nil,
	Enabled = true,
	IsInstance = true,
	Name = "Drowned Halls",
	Type = "10man",
	ID = "DH",
}

local KBM = KBM_RegisterMod("Drowned Halls", DH)

KBM.Language:Add(DH.Name)
KBM.Language[DH.Name]:SetGerman("Überflutete Hallen")

DH.Name = KBM.Language[DH.Name][KBM.Lang]

function DH:AddBosses(KBM_Boss)
end

function DH:InitVars()
end

function DH:LoadVars()
end

function DH:SaveVars()
end

function DH:Start()
	function self:Enabled(bool)
	
	end
	DH.Header = KBM.MainWin.Menu:CreateHeader(self.Name, self.Enabled, true)
	DH.Header.Check:SetEnabled(false)
end

function KBMDH_Register()
	return DH
end