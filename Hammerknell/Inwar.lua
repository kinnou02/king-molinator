-- Inwar Darktide Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMID_Settings = nil
chKBMID_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local ID = {
	Enabled = true,
	Counts = {
		Slimes = 0,
		Wranglers = 0,
		Wardens = 0,
	},
	Instance = HK.Name,
	HasPhases = true,
	Phase = 1,
	Lang = {},
	ID = "Inwar",
}

ID.Inwar = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Inwar Darktide",
	Dead = false,
	Available = false,
	UnitID = nil,
	Primary = true,
	Required = 1,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

ID.Denizar = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Denizar",
	Dead = false, 
	Available = false,
	UnitID = nil,
	Primary = false,
	Required = 1,
	Triggers = {},
}

ID.Aqualix = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Denizar",
	CastBar = nil,
	Dead = false, 
	Available = false,
	UnitID = nil,
	Primary = false,
	Required = 1,
	Triggers = {},	
}

ID.Undertow = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Undertow",
	Dead = false, 
	Available = false,
	UnitID = nil,
	Primary = false,
	Required = 1,
	Triggers = {},
}

ID.Rotjaw = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Rot Jaw",
	Dead = false, 
	Available = false,
	UnitID = nil,
	Primary = false,
	Required = 1,
	Triggers = {},
}

ID.Slime = {
	Mod = ID,
	Level = "??",
	Name = "Fetid Slime",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

ID.Wrangler = {
	Mod = ID,
	Level = "??",
	Name = "Scuttle Claw Wrangler",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

ID.Warden = {
	Mod = ID,
	Level = "??",
	Name = "Tide Warden",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

KBM.RegisterMod(ID.ID, ID)

-- Initialize Main Unit Dictionary
ID.Lang.Inwar = KBM.Language:Add(ID.Inwar.Name)
ID.Lang.Inwar.German = "Inwar Dunkelflut"
ID.Lang.Inwar.French = "Inwar Noirflux"
ID.Lang.Denizar = KBM.Language:Add(ID.Denizar.Name)
ID.Lang.Aqualix = KBM.Language:Add(ID.Aqualix.Name)
ID.Lang.Undertow = KBM.Language:Add(ID.Undertow.Name)
ID.Lang.Rotjaw = KBM.Language:Add(ID.Rotjaw.Name)

-- Unit Dictionary
ID.Lang.Unit = {}
ID.Lang.Unit.Slime = KBM.Language:Add(ID.Slime.Name)
ID.Lang.Unit.Wrangler = KBM.Language:Add(ID.Wrangler.Name)
ID.Lang.Unit.Warden = KBM.Language:Add(ID.Warden.Name)

-- Adjust Unit Names to match Client
ID.Inwar.Name = ID.Lang.Inwar[KBM.Lang]
ID.Denizar.Name = ID.Lang.Denizar[KBM.Lang]
ID.Aqualix.Name = ID.Lang.Aqualix[KBM.Lang]
ID.Undertow.Name = ID.Lang.Undertow[KBM.Lang]
ID.Rotjaw.Name = ID.Lang.Rotjaw[KBM.Lang]
ID.Slime.Name = ID.Lang.Unit.Slime[KBM.Lang]
ID.Wrangler.Name = ID.Lang.Unit.Wrangler[KBM.Lang]
ID.Warden.Name = ID.Lang.Unit.Warden[KBM.Lang]

function ID:AddBosses(KBM_Boss)

	self.Inwar.Descript = self.Inwar.Name
	self.Denizar.Descript = self.Inwar.Name
	self.Aqualix.Descript = self.Inwar.Name
	self.MenuName = self.Inwar.Descript
	self.Bosses = {
		[self.Inwar.Name] = self.Inwar,
		[self.Denizar.Name] = self.Denizar,
		[self.Aqualix.Name] = self.Aqualix,
		[self.Undertow.Name] = self.Undertow,
		[self.Rotjaw.Name] = self.Rotjaw,
		[self.Slime.Name] = self.Slime,
		[self.Wrangler.Name] = self.Wrangler,
		[self.Warden.Name] = self.Warden,
	}
	KBM_Boss[self.Inwar.Name] = self.Inwar
	KBM.SubBoss[self.Denizar.Name] = self.Denizar
	KBM.SubBoss[self.Aqualix.Name] = self.Aqualix
	KBM.SubBoss[self.Undertow.Name] = self.Undertow
	KBM.SubBoss[self.Rotjaw.Name] = self.Rotjaw
	KBM.SubBoss[self.Slime.Name] = self.Slime
	KBM.SubBoss[self.Wrangler.Name] = self.Wrangler
	KBM.SubBoss[self.Warden.Name] = self.Warden
	
	self.Inwar.Settings.CastBar.Override = true
	self.Inwar.Settings.CastBar.Multi = true
	
end

function ID:InitVars()

	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		CastBar = {
			Override = true,
			Multi = true,
		},
		Inwar = {
			CastBar = self.Inwar.Settings.CastBar,
		}
	}
	KBMID_Settings = self.Settings
	chKBMID_Settings = self.Settings
	
end

function ID:SwapSettings(bool)

	if bool then
		KBMID_Settings = self.Settings
		self.Settings = chKBMID_Settings
	else
		chKBMID_Settings = self.Settings
		self.Settings = KBMID_Settings
	end

end

function ID:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMID_Settings, self.Settings)
	else
		KBM.LoadTable(KBMID_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMID_Settings = self.Settings
	else
		KBMID_Settings = self.Settings
	end

end

function ID:SaveVars()

	if KBM.Options.Character then
		chKBMID_Settings = self.Settings
	else
		KBMID_Settings = self.Settings
	end
	
end

function ID:Castbar(units)
end

function ID:RemoveUnits(UnitID)
	if self.Inwar.UnitID == UnitID then
		self.Inwar.Available = false
		return true
	end
	return false
end

function ID.PhaseTwo()	
	ID.Phase = 2
	ID.PhaseObj.Objectives:Remove()
	print("Phase 2 starting!")
	ID.PhaseObj:SetPhase(2)
	ID.PhaseObj.Objectives:AddDeath(ID.Slime.Name, 3)
	ID.PhaseObj.Objectives:AddDeath(ID.Wrangler.Name, 3)	
end

function ID.PhaseThree()
	ID.Phase = 3
	ID.PhaseObj.Objectives:Remove()
	print("Phase 3 starting!")
	ID.PhaseObj:SetPhase(3)
	ID.PhaseObj.Objectives:AddDeath(ID.Warden.Name, 2)
end

function ID.PhaseFour()
	ID.Phase = 4
	ID.PhaseObj.Objectives:Remove()
	print("Phase 4 starting!")
	ID.PhaseObj:SetPhase(4)
	ID.PhaseObj.Objectives:AddPercent(ID.Undertow.Name, 0, 100)
	ID.PhaseObj.Objectives:AddPercent(ID.Rotjaw.Name, 0, 100)
end

function ID.PhaseFive()
	ID.Phase = 5
	ID.PhaseObj.Objectives:Remove()
	print("Final phase starting!")
	ID.PhaseObj:SetPhase("Final")
	ID.PhaseObj.Objectives:AddPercent(ID.Inwar.Name, 0, 100)
end

function ID:Death(UnitID)
	if self.Inwar.UnitID == UnitID then
		self.Inwar.Dead = true
		return true
	else
		if self.Phase == 1 then
			-- First Pair
			if self.Aqualix.UnitID == UnitID then
				self.Aqualix.Dead = true
				self.Aqualix.CastBar:Remove()
			elseif self.Denizar.UnitID == UnitID then
				self.Denizar.Dead = true
				self.Denizar.CastBar:Remove()
			end
			if self.Aqualix.Dead and self.Denizar.Dead then
				ID.PhaseTwo()
			end
		elseif self.Phase == 2 then
			-- Adds (Slimes and Wranglers)
			if self.Slime.UnitList[UnitID] then
				self.Counts.Slimes = self.Counts.Slimes + 1
				self.Slime.UnitList[UnitID].Dead = true
			elseif self.Wrangler.UnitList[UnitID] then
				self.Counts.Wranglers = self.Counts.Wranglers + 1
				self.Wrangler.UnitList[UnitID].Dead = true
			end
			if self.Counts.Slimes == 3 and self.Counts.Wranglers == 3 then
				ID.PhaseThree()
			end
		elseif self.Phase == 3 then
			-- Wardens
			if self.Warden.UnitList[UnitID] then
				self.Counts.Wardens = self.Counts.Wardens + 1
				self.Warden.UnitList[UnitID].Dead = true
			end
			if self.Counts.Wardens == 2 then
				ID.PhaseFour()
			end
		elseif self.Phase == 4 then
			-- Last Minibosses before Inwar
			if self.Undertow.UnitID == UnitID then
				self.Undertow.Dead = true
				self.Undertow.CastBar:Remove()
			elseif self.Rotjaw.UnitID == UnitID then
				self.Rotjaw.Dead = true
				self.Rotjaw.CastBar:Remove()
			end
			if self.Undertow.Dead and self.Rotjaw.Dead then
				ID.PhaseFive()
			end
		end
	end
	return false
end

function ID:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Phase = 1
					self.Counts.Wardens = 0
					self.Counts.Slimes = 0
					self.Counts.Wranglers = 0
					self.PhaseObj.Objectives:AddPercent(self.Aqualix.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Denizar.Name, 0, 100)
					self.PhaseObj:Start(self.StartTime)
				end
				if self.Type ~= "multi" then
					if self.Bosses[uDetails.name].CastBar then
						if not self.Bosses[uDetails.name].CastBar.Active then
							self.Bosses[uDetails.name].CastBar:Create(unitID)			
						end
					end
					self.Bosses[uDetails.name].Dead = false
					self.Bosses[uDetails.name].Casting = false
					self.Bosses[uDetails.name].UnitID = unitID
					self.Bosses[uDetails.name].Available = true
					return self.Bosses[uDetails.name]
				else
					if not self.Bosses[uDetails.name].UnitList[unitID] then
						SubBossObj = {
							Mod = ID,
							Level = "??",
							Name = uDetails.name,
							Dead = false,
							Casting = false,
							UnitID = unitID,
							Available = true,
						}
						self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
					else
						self.Bosses[uDetails.name].UnitList[unitID].Dead = false
						self.Bosses[uDetails.name].UnitList[unitID].Available = true
						self.Bosses[uDetails.name].UnitList[unitID].UnitID = UnitID
					end
					return self.Bosses[uDetails.name].UnitList[unitID]				
				end
			end
		end
	end
end

function ID:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Type == "multi" then
			for SubID, SubBoss in pairs(BossObj.UnitList) do
				SubBoss = nil
			end
			BossObj.UnitList = {}
		else
			BossObj.Available = false
			BossObj.UnitID = nil
			BossObj.Dead = false
			if BossObj.CastBar then
				if BossObj.CastBar.Active then
					BossObj.CastBar:Remove()
				end
			end
		end
	end
	self.Counts.Slimes = 0
	self.Counts.Wardens = 0
	self.Counts.Wranglers = 0
	self.PhaseObj:End(Inspect.Time.Real())
	self.Phase = 1
end

function ID:Timer()	
end

function ID:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Inwar, self.Enabled)
end

function ID:Start()

	self.Inwar.CastBar = KBM.CastBar:Add(self, self.Inwar, true)
	self.Aqualix.CastBar = KBM.CastBar:Add(self, self.Aqualix, false)
	self.Denizar.CastBar = KBM.CastBar:Add(self, self.Denizar, false)
	self.Undertow.CastBar = KBM.CastBar:Add(self, self.Undertow, false)
	self.Rotjaw.CastBar = KBM.CastBar:Add(self, self.Rotjaw, false)
	
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()

end