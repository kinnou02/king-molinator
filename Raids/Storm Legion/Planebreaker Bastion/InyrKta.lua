-- Inyr'Kta Boss Mod for King Boss Mods
-- Written by Noshei
-- Copyright 2013
--
 
KBMSLRDPBIK_Settings = nil
chKBMSLRDPBIK_Settings = nil
 
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
        return
end
local PB = KBM.BossMod["RPlanebreaker_Bastion"]
 
local INY = {
        Enabled = true,
        Directory = PB.Directory,
        File = "Inyrkta.lua",
        Instance = PB.Name,
        InstanceObj = PB,
        HasPhases = true,
        Lang = {},
        ID = "Inyrkta",
        Object = "INY",
        TimeoutOverride = true,
        Timeout = 5,
        Enrage = 9 * 60,
}
 
KBM.RegisterMod(INY.ID, INY)
 
-- Main Unit Dictionary
INY.Lang.Unit = {}
INY.Lang.Unit.Inyrkta = KBM.Language:Add("Inyr'Kta") -- ???
INY.Lang.Unit.Inyrkta:SetFrench("Inyr'Kta")
 
-- Ability Dictionary
INY.Lang.Ability = {}
--INY.Lang.Ability.Rampage = KBM.Language:Add("Unstoppable Rampage")
 
-- Description Dictionary
INY.Lang.Main = {}
INY.Lang.Main.Encounter = KBM.Language:Add("Inyr'Kta")
 
-- Debuff Dictionary
INY.Lang.Debuff = {}
INY.Lang.Debuff.Infection = KBM.Language:Add("Aggressive Infection")
INY.Lang.Debuff.Infection:SetFrench("Infection agressive")
INY.Lang.Debuff.InfectionID = "B78C037C29FD9F6BC"
INY.Lang.Debuff.Anguish = KBM.Language:Add("Intensifying Anguish")
INY.Lang.Debuff.Anguish:SetFrench("Angoisse intensifiante")
INY.Lang.Debuff.AnguishID = "B667CABE56C6FA3CD"
 
-- Notify Dictionary
INY.Lang.Notify = {}
INY.Lang.Notify.Fissure = KBM.Language:Add('Inyr\'Kta screams, "You cannot stop an avalanche!"')
INY.Lang.Notify.Fissure:SetFrench('Inyr\'Kta hurle : "Vous ne pouvez pas arrêter une avalanche*!"')
INY.Lang.Notify.Phase = KBM.Language:Add('Inyr\'Kta roars, "The Architects will rule once more."')
INY.Lang.Notify.Phase:SetFrench('Inyr\'Kta rugit : "Les Architectes régneront à jamais."')
 
-- Messages Dictionary
INY.Lang.Messages = {}
INY.Lang.Messages.Fissure = KBM.Language:Add("Earthen Fissures")
INY.Lang.Messages.Fissure:SetFrench("Fissure terrestre")
INY.Lang.Messages.Infection = KBM.Language:Add("Infection on YOU!")
INY.Lang.Messages.Infection:SetFrench ("Infection sur TOI!")
INY.Lang.Messages.WavesEnd = KBM.Language:Add("End of Wave Phase")
INY.Lang.Messages.WavesEnd:SetFrench("Fin de la phase vagues")
 
 
INY.Descript = INY.Lang.Main.Encounter[KBM.Lang]
 
INY.Inyrkta = {
        Mod = INY,
        Level = "??",
        Active = false,
        Name = INY.Lang.Unit.Inyrkta[KBM.Lang],
        Dead = false,
        Available = false,
        Menu = {},
        UTID = "U07EBE61A2DA90D1D",
        UnitID = nil,
        TimeOut = 5,
        Castbar = nil,
        TimersRef = {},
        AlertsRef = {},
        MechRef = {},
        Triggers = {},
        Settings = {
                CastBar = KBM.Defaults.Castbar(),
                TimersRef = {
                        Enabled = true,
                        WaveEnd = KBM.Defaults.TimerObj.Create("yellow"),
                        Infection = KBM.Defaults.TimerObj.Create("red"),
                        Fissure = KBM.Defaults.TimerObj.Create("orange"),
                },
                AlertsRef = {
                        Enabled = true,
                        Infection = KBM.Defaults.AlertObj.Create("red"),
                },
                MechRef = {
                        Enabled = true,
                        Infection = KBM.Defaults.MechObj.Create("red"),
                },
        }
}
 
function INY:AddBosses(KBM_Boss)
        self.MenuName = self.Descript
        self.Bosses = {
                [self.Inyrkta.Name] = self.Inyrkta,
        }
 
        for BossName, BossObj in pairs(self.Bosses) do
                if BossObj.Settings then
                        if BossObj.Settings.CastBar then
                                BossObj.Settings.CastBar.Override = true
                                BossObj.Settings.CastBar.Multi = true
                        end
                end
        end    
end
 
function INY:InitVars()
        self.Settings = {
                Enabled = true,
                CastBar = {
                        Override = true,
                        Multi = true,
                },
                EncTimer = KBM.Defaults.EncTimer(),
                PhaseMon = KBM.Defaults.PhaseMon(),
                MechSpy = KBM.Defaults.MechSpy(),
                Inyrkta = {
                        CastBar = self.Inyrkta.Settings.CastBar,
                        TimersRef = self.Inyrkta.Settings.TimersRef,
                        AlertsRef = self.Inyrkta.Settings.AlertsRef,
                        MechRef = self.Inyrkta.Settings.MechRef,
                },
                MechTimer = KBM.Defaults.MechTimer(),
                Alerts = KBM.Defaults.Alerts(),
        }
        KBMSLRDPBIK_Settings = self.Settings
        chKBMSLRDPBIK_Settings = self.Settings
       
end
 
function INY:SwapSettings(bool)
 
        if bool then
                KBMSLRDPBIK_Settings = self.Settings
                self.Settings = chKBMSLRDPBIK_Settings
        else
                chKBMSLRDPBIK_Settings = self.Settings
                self.Settings = KBMSLRDPBIK_Settings
        end
 
end
 
function INY:LoadVars()
        if KBM.Options.Character then
                KBM.LoadTable(chKBMSLRDPBIK_Settings, self.Settings)
        else
                KBM.LoadTable(KBMSLRDPBIK_Settings, self.Settings)
        end
       
        if KBM.Options.Character then
                chKBMSLRDPBIK_Settings = self.Settings
        else
                KBMSLRDPBIK_Settings = self.Settings
        end    
       
        self.Settings.Enabled = true
end
 
function INY:SaveVars()
        self.Enabled = true
        if KBM.Options.Character then
                chKBMSLRDPBIK_Settings = self.Settings
        else
                KBMSLRDPBIK_Settings = self.Settings
        end    
end
 
function INY.Phase()
        if INY.Phase == 1 then
                INY.Phase = 2
                INY.PhaseObj.Objectives:Remove()
                INY.PhaseObj.Objectives:AddPercent(INY.Inyrkta, 55, 80)
                INY.PhaseObj:SetPhase("2")
        elseif INY.Phase == 2 then
                INY.Phase = 3
                INY.PhaseObj.Objectives:Remove()
                INY.PhaseObj.Objectives:AddPercent(INY.Inyrkta, 30, 55)
                INY.PhaseObj:SetPhase("3")
        elseif INY.Phase == 3 then
                INY.Phase = 4
                INY.PhaseObj.Objectives:Remove()
                INY.PhaseObj.Objectives:AddPercent(INY.Inyrkta, 0, 30)
                INY.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
        end
end
 
function INY:Castbar(units)
end
 
function INY:RemoveUnits(UnitID)
        if self.Inyrkta.UnitID == UnitID then
                self.Inyrkta.Available = false
                return true
        end
        return false
end
 
function INY:Death(UnitID)
        if self.Inyrkta.UnitID == UnitID then
                self.Inyrkta.Dead = true
                return true
        end
        return false
end
 
function INY:UnitHPCheck(uDetails, unitID)     
        if uDetails and unitID then
                local BossObj = self.UTID[uDetails.type]
                if not BossObj then
                        BossObj = self.Bosses[uDetails.name]
                end
                if BossObj then
                        if not self.EncounterRunning then
                                self.EncounterRunning = true
                                self.StartTime = Inspect.Time.Real()
                                self.HeldTime = self.StartTime
                                self.TimeElapsed = 0
                                BossObj.Dead = false
                                BossObj.Casting = false
                                if BossObj.CastBar then
                                        BossObj.CastBar:Create(unitID)
                                end
                                self.PhaseObj:Start(self.StartTime)
                                self.PhaseObj:SetPhase("1")
                                self.Phase = 1
                                self.PhaseObj.Objectives:AddPercent(self.Inyrkta, 80, 100)
                                KBM.TankSwap:Start(self.Lang.Debuff.AnguishID, unitID)
                        else
                                BossObj.Dead = false
                                BossObj.Casting = false
                                if BossObj.UnitID ~= unitID then
                                        BossObj.CastBar:Remove()
                                        BossObj.CastBar:Create(unitID)
                                end
                        end
                        BossObj.UnitID = unitID
                        BossObj.Available = true
                        return BossObj
                end
        end
end
 
function INY:Reset()
        self.EncounterRunning = false
        for BossName, BossObj in pairs(self.Bosses) do
                BossObj.Available = false
                BossObj.UnitID = nil
                BossObj.Dead = false
                BossObj.Casting = false
                if BossObj.CastBar then
                        BossObj.CastBar:Remove()
                end
        end
        self.PhaseObj:End(Inspect.Time.Real())
end
 
function INY:Timer()   
end
 
function INY:DefineMenu()
        self.Menu = INY.Menu:CreateEncounter(self.Inyrkta, self.Enabled)
end
 
function INY:Start()
        -- Create Timers
        self.Inyrkta.TimersRef.Infection = KBM.MechTimer:Add(self.Lang.Debuff.Infection[KBM.Lang], 15, false)
        self.Inyrkta.TimersRef.WaveEnd = KBM.MechTimer:Add(self.Lang.Messages.WavesEnd[KBM.Lang], 40, false)
        self.Inyrkta.TimersRef.Fissure = KBM.MechTimer:Add(self.Lang.Messages.Fissure[KBM.Lang], 45, false)
       
        KBM.Defaults.TimerObj.Assign(self.Inyrkta)
 
        -- Create Alerts
        self.Inyrkta.AlertsRef.Infection = KBM.Alert:Create(self.Lang.Debuff.Infection[KBM.Lang], 10, true, true, "red")
       
        KBM.Defaults.AlertObj.Assign(self.Inyrkta)
 
        -- Create Mechanic Spies
        self.Inyrkta.MechRef.Infection = KBM.MechSpy:Add(self.Lang.Debuff.Infection[KBM.Lang], 15, "playerDebuff", self.Inyrkta)
       
        KBM.Defaults.MechObj.Assign(self.Inyrkta)
 
        -- Assign Alerts and Timers for Triggers
 
        self.Inyrkta.Triggers.Infection = KBM.Trigger:Create(self.Lang.Debuff.Infection[KBM.Lang], "playerDebuff", self.Inyrkta)
        self.Inyrkta.Triggers.Infection:AddSpy(self.Inyrkta.MechRef.Infection)
        self.Inyrkta.Triggers.Infection:AddAlert(self.Inyrkta.AlertsRef.Infection, true)
        self.Inyrkta.Triggers.Infection:AddTimer(self.Inyrkta.TimersRef.Infection)
        self.Inyrkta.Triggers.InfectionRem = KBM.Trigger:Create(self.Lang.Debuff.Infection[KBM.Lang], "playerBuffRemove", self.Inyrkta)
        self.Inyrkta.Triggers.InfectionRem:AddStop(self.Inyrkta.MechRef.Infection)
       
        self.Inyrkta.Triggers.Fissure = KBM.Trigger:Create(self.Lang.Notify.Fissure[KBM.Lang], "notify", self.Inyrkta)
        self.Inyrkta.Triggers.Fissure:AddTimer(self.Inyrkta.TimersRef.Fissure)
       
        self.Inyrkta.Triggers.Phase = KBM.Trigger:Create(self.Lang.Notify.Phase[KBM.Lang], "notify", self.Inyrkta)
        self.Inyrkta.Triggers.Phase:AddTimer(self.Inyrkta.TimersRef.WaveEnd)
        self.Inyrkta.Triggers.Phase:AddPhase(self.Phase)
 
        self.Inyrkta.CastBar = KBM.Castbar:Add(self, self.Inyrkta)
        self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
end