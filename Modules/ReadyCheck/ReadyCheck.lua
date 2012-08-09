-- King Boss Mods Ready Check Module
-- Written By Paul Snart
-- Copyright 2012
--

local AddonData = Inspect.Addon.Detail("KBMReadyCheck")
local KBMRC = AddonData.data

local PI = KBMRC

local KBMAddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = KBMAddonData.data
if not KBM.BossMod then
	return
end

KBM.Ready = PI

PI = {
	GUI = {},
	Settings = {
		Enabled = true,
	},
}

-- Dictionary in Global Locale file.

function PI:InitGUI()
	self.GUI.Header = UI.CreateFrame("Frame", "ReadyCheck Header", KBM.Context)
	self.GUI.HeaderText = UI.CreateFrame("Text", "ReadyCheck Text", self.GUI.Header)
	self.GUI.HeaderText:SetText(KBM.Language.ReadyCheck.Name[KBM.Lang])
end

function PI.Start(ModID)
	if ModID == "KBMReadyCheck" then
		PI:InitGUI()
	end
end

table.insert(Event.Addon.Load.End, {PI.Start, "KBMReadyCheck", "Syncronized Start"})