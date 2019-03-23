local AddonIni, KBM = ...

local LSUIni = Inspect.Addon.Detail("SafesUnitLib")
local LibSUnit = LSUIni.data

function KBM.Trigger:Init()
	self.Queue = {}
	self.Queue.Locked = false
	self.Queue.Removing = false
	self.Queue.List = {}
	self.List = {}
	self.Notify = {}
	self.Say = {}
	self.Damage = {}
	self.Cast = {}
	self.CastID = {}
	self.PersonalCast = {}
	self.PersonalCastID = {}
	self.Percent = {}
	self.Combat = {}
	self.Start = {}
	self.Death = {}
	self.Buff = {}
	self.BuffID = {}
	self.PlayerBuff = {}
	self.PlayerDebuff = {}
	self.PlayerIDBuff = {}
	self.BuffRemove = {}
	self.BuffIDRemove = {}
	self.PlayerBuffRemove = {}
	self.PlayerIDBuffRemove = {}
	self.Time = {}
	self.Channel = {}
	self.ChannelID = {}
	self.PersonalChannel = {}
	self.PersonalChannelID = {}
	self.Interrupt = {}
	self.InterruptID = {}
	self.PersonalInterrupt = {}
	self.PersonalInterruptID = {}
	self.NpcDamage = {}
	self.EncStart = {}
	self.CustomBuffRemove = {}
	self.Seq = {}
	self.Max = {
		Timers = {},
		Spies = {},
	}
	self.High = {
		Timers = 0,
		Spies = 0,
	}

	function self.Queue:Add(TriggerObj, Caster, Target, Duration)	
		if KBM.Encounter then
			if TriggerObj.Queued then
				TriggerObj.Target[Target] = true
				return
			elseif self.Removing then
				return
			end
			TriggerObj.Queued = true
			table.insert(self.List, TriggerObj)
			TriggerObj.Caster = Caster
			if Target then
				TriggerObj.Target = {[Target] = true}
			else
				TriggerObj.Target = {}
			end
			TriggerObj.Duration = Duration
			self.Queued = true
		end		
	end
	
	function self.Queue:Activate()	
		if self.Queued then
			if KBM.Encounter then
				if self.Removing then
					return
				end
				for i, TriggerObj in ipairs(self.List) do
					TriggerObj:Activate(TriggerObj.Caster, TriggerObj.Target, TriggerObj.Duration)
					TriggerObj.Queued = false
				end
				self.List = {}
				self.Queued = false
			end
		end		
	end
	
	function self.Queue:Remove()		
		self.Removing = true
		self.List = {}
		self.Removing = false
		self.Queued = false		
	end
	
	function self:Create(Trigger, Type, Unit, Hook, NonEncounter)	
		local TriggerObj = {}
		TriggerObj.Timers = {}
		TriggerObj.Alerts = {}
		TriggerObj.Spies = {}
		TriggerObj.Stop = {}
		TriggerObj.Hook = Hook
		TriggerObj.Unit = Unit
		TriggerObj.Type = Type
		TriggerObj.Caster = nil
		TriggerObj.Target = {}
		TriggerObj.Queued = false
		TriggerObj.Phase = nil
		TriggerObj.Trigger = Trigger
		TriggerObj.LastTrigger = 0
		TriggerObj.Enabled = true
		TriggerObj.Extended = NonEncounter
		TriggerObj.Seq = {
			Alerts = {},
			TotalAlerts = 0,
			CurrentAlert = 1,
			Timers = {},
			TotalTimers = 0,
			CurrentTimer = 1,
			Stored = false,
		}
		
		function TriggerObj:AddTimer(TimerObj)
			if not TimerObj then
				error("Timer object does not exist!")
			end
			if type(TimerObj) ~= "table" then
				error("TimerObj: Expecting Table, got "..tostring(type(TimerObj)))
			elseif TimerObj.Type ~= "timer" then
				error("TimerObj: Expecting timer, got "..tostring(TimerObj.Type))
			end
			table.insert(self.Timers, TimerObj)
			if not KBM.Trigger.Max.Timers[self.Unit.Mod.ID] then
				KBM.Trigger.Max.Timers[self.Unit.Mod.ID] = 1
			else
				KBM.Trigger.Max.Timers[self.Unit.Mod.ID] = KBM.Trigger.Max.Timers[self.Unit.Mod.ID] + 1
			end
			if KBM.Trigger.High.Timers < KBM.Trigger.Max.Timers[self.Unit.Mod.ID] then
				KBM.Trigger.High.Timers = KBM.Trigger.Max.Timers[self.Unit.Mod.ID]
			end
		end
		
		function TriggerObj:AddTimerSeq(TimerObj, Player)
			if not TimerObj then
				error("Timer object does not exist!")
			end
			if type(TimerObj) ~= "table" then
				error("TimerObj: Expecting Table, got "..tostring(type(TimerObj)))
			elseif TimerObj.Type ~= "timer" then
				error("TimerObj: Expecting timer, got "..tostring(TimerObj.Type))
			end
			table.insert(self.Seq.Timers, TimerObj)
			self.Seq.TotalTimers = self.Seq.TotalTimers + 1
			if not KBM.Trigger.Max.Timers[self.Unit.Mod.ID] then
				KBM.Trigger.Max.Timers[self.Unit.Mod.ID] = 1
			else
				KBM.Trigger.Max.Timers[self.Unit.Mod.ID] = KBM.Trigger.Max.Timers[self.Unit.Mod.ID] + 1
			end
			if KBM.Trigger.High.Timers < KBM.Trigger.Max.Timers[self.Unit.Mod.ID] then
				KBM.Trigger.High.Timers = KBM.Trigger.Max.Timers[self.Unit.Mod.ID]
			end
			if not KBM.Trigger.Seq[self.Unit.Mod.ID] then
				KBM.Trigger.Seq[self.Unit.Mod.ID] = {}
			end
			if not self.Seq.Stored then
				table.insert(KBM.Trigger.Seq[self.Unit.Mod.ID], self)
				self.Seq.Stored = true
			end
		end
		
		function TriggerObj:AddSpy(SpyObj)
			if not SpyObj then
				error("Mechanic Spy object does not exist!")
			end
			if type(SpyObj) ~= "table" then
				error("SpyObj: Expecting Table, got "..tostring(type(SpyObj)))
			elseif SpyObj.Type ~= "spy" then
				error("SpyObj: Expecting Mechanic Spy, go "..tostring(SpyObj.Type))
			end
			table.insert(self.Spies, SpyObj)
		end
		
		function TriggerObj:AddAlert(AlertObj, Player)
			if not AlertObj then
				error("Alert Object does not exist!")
			end
			if type(AlertObj) ~= "table" then
				error("AlertObj: Expecting Table, got "..tostring(type(AlertObj)))
			elseif AlertObj.Type ~= "alert" then
				error("AlertObj: Expecting alert, got "..tostring(AlertObj.Type))
			end
			AlertObj.Player = Player
			table.insert(self.Alerts, AlertObj)
		end
		
		function TriggerObj:AddAlertSeq(AlertObj, Player)
			if not AlertObj then
				error("Alert Object does not exist!")
			end
			if type(AlertObj) ~= "table" then
				error("AlertObj: Expecting Table, got "..tostring(type(AlertObj)))
			elseif AlertObj.Type ~= "alert" then
				error("AlertObj: Expecting alert, got "..tostring(AlertObj.Type))
			end
			AlertObj.Player = Player
			table.insert(self.Seq.Alerts, AlertObj)
			self.Seq.TotalAlerts = self.Seq.TotalAlerts + 1
			if not KBM.Trigger.Seq[self.Unit.Mod.ID] then
				KBM.Trigger.Seq[self.Unit.Mod.ID] = {}
			end
			if not self.Seq.Stored then
				table.insert(KBM.Trigger.Seq[self.Unit.Mod.ID], self)
				self.Seq.Stored = true
			end
		end
		
		function TriggerObj:AddPhase(PhaseObj)
			if not PhaseObj then
				error("Phase Object does not exist!")
			end
			self.Phase = PhaseObj 
		end
		
		function TriggerObj:AddStart(Mod)
			self.ModStart = Mod
		end
		
		function TriggerObj:SetVictory()
			self.Victory = true
		end
		
		function TriggerObj:ResetSeq()
			self.Seq.CurrentTimer = 1
			self.Seq.CurrentAlert = 1
		end
		
		function TriggerObj:ResetAlertSeq()
			self.Seq.CurrentAlert = 1
		end
		
		function TriggerObj:SetMinStack(stacks)
			self.MinStack = stacks
		end
		
		function TriggerObj:ResetTimerSeq()
			self.Seq.CurrentTimer = 1
		end
		
		function TriggerObj:AddStop(Object, Player)
			if type(Object) ~= "table" then
				error("Expecting at least table: Got "..tostring(type(Object)))
			elseif Object.Type ~= "timer" and Object.Type ~= "alert" and Object.Type ~= "spy" then
				error("Expecting at least timer, alert or spy: Got "..tostring(Object.Type))
			end
			table.insert(self.Stop, Object)
		end
		
		function TriggerObj:Activate(Caster, Target, Data)
			local Triggered = false
			local current = Inspect.Time.Real()
			if self.Victory == true then
				KBM:Victory()
				return
			end
			if self.Type == "damage" then
				for i, Timer in ipairs(self.Timers) do
					if Timer.Active then
						if current - self.LastTrigger > KBM.Idle.Trigger.Duration then
							Timer:Queue(Data)
							Triggered = true
						end
					else
						Timer:Queue(Data)
						Triggered = true
					end
				end
				if self.Seq.TotalTimers > 0 then
					local Timer = self.Seq.Timers[self.Seq.CurrentTimer]
					if Timer.Active then
						if current - self.LastTrigger > KBM.Idle.Trigger.Duration then
							Timer:Queue(Data)
							Triggered = true
							self.Seq.CurrentTimer = self.Seq.CurrentTimer + 1
							if self.Seq.CurrentTimer > self.Seq.TotalTimers then
								self.Seq.CurrentTimer = 1
							end
						end
					else
						Timer:Queue(Data)
						Triggered = true
						self.Seq.CurrentTimer = self.Seq.CurrentTimer + 1
						if self.Seq.CurrentTimer > self.Seq.TotalTimers then
							self.Seq.CurrentTimer = 1
						end
					end
				end
			else
				for i, Timer in ipairs(self.Timers) do
					Timer:Queue(Data)
					Triggered = true
				end
				if self.Seq.TotalTimers > 0 then
					local Timer = self.Seq.Timers[self.Seq.CurrentTimer]
					if Timer.Active then
						if current - self.LastTrigger > KBM.Idle.Trigger.Duration then
							Timer:Queue(Data)
							Triggered = true
							self.Seq.CurrentTimer = self.Seq.CurrentTimer + 1
							if self.Seq.CurrentTimer > self.Seq.TotalTimers then
								self.Seq.CurrentTimer = 1
							end
						end
					else
						Timer:Queue(Data)
						Triggered = true
						self.Seq.CurrentTimer = self.Seq.CurrentTimer + 1
						if self.Seq.CurrentTimer > self.Seq.TotalTimers then
							self.Seq.CurrentTimer = 1
						end
					end
				end
			end
			for i, SpyObj in ipairs(self.Spies) do
				if SpyObj.Source then
					if self.Caster then
						if LibSUnit.Lookup.UID[self.Caster] then
							SpyObj:Start(LibSUnit.Lookup.UID[self.Caster].Name, Data)
						end
					end
				else
					for UID, bool in pairs(self.Target) do
						if LibSUnit.Lookup.UID[UID] then
							SpyObj:Start(LibSUnit.Lookup.UID[UID].Name, Data)
						end
					end
				end
			end
			
			for i, AlertObj in ipairs(self.Alerts) do
				if AlertObj.Player then
					if self.Target[LibSUnit.Player.UnitID] then
						KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
						Triggered = true
					end
				else
					KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
					Triggered = true
				end
			end
			
			if self.Seq.TotalAlerts > 0 then
				local AlertObj = self.Seq.Alerts[self.Seq.CurrentAlert]
				if AlertObj.Player then
					if self.Target[LibSUnit.Player.UnitID] then
						KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
						Triggered = true
					end
				else
					KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
					Triggered = true
				end
				self.Seq.CurrentAlert = self.Seq.CurrentAlert + 1
				if self.Seq.CurrentAlert > self.Seq.TotalAlerts then
					self.Seq.CurrentAlert = 1
				end
			end
			
			for i, Obj in ipairs(self.Stop) do
				if Obj.Type == "timer" then
					KBM.MechTimer:AddRemove(Obj)
					Triggered = true
				elseif Obj.Type == "alert" then
					KBM.Alert:Stop(Obj)
					Triggered = true
				elseif Obj.Type == "spy" then
					if self.Type == "death" then
						Obj:Stop()
					else
						if self.Source then
							if LibSUnit.Lookup.UID[self.Caster] then
								Obj:Stop(LibSUnit.Lookup.UID[self.Caster].Name)
							end
						else
							for UID, bool in pairs(self.Target) do
								if LibSUnit.Lookup.UID[UID] then
									Obj:Stop(LibSUnit.Lookup.UID[UID].Name)
								end
							end
						end
					end
				end
			end
			
			if self.Extended == "CustomBuffRemove" then
				if self.Phase then
					self.Phase(Data, Target)
					Triggered = true
				end
			else
				if KBM.Encounter then
					if self.Phase then
						self.Phase(self.Type)
						Triggered = true
					end
				end
			end
			
			if Triggered then
				self.LastTrigger = current
				self.Target = {}
			end
		end
		
		if not NonEncounter then
			if Type == "notify" then
				TriggerObj.Phrase = Trigger
				if not self.Notify[Unit.Mod.ID] then
					self.Notify[Unit.Mod.ID] = {}
				end
				table.insert(self.Notify[Unit.Mod.ID], TriggerObj)
			elseif Type == "say" then
				TriggerObj.Phrase = Trigger
				if not self.Say[Unit.Mod.ID] then
					self.Say[Unit.Mod.ID] = {}
				end
				table.insert(self.Say[Unit.Mod.ID], TriggerObj)
			elseif Type == "npcDamage" then
				if not self.NpcDamage[Unit.Mod.ID] then
					self.NpcDamage[Unit.Mod.ID] = {}
				end
				self.NpcDamage[Unit.Mod.ID][Unit.Name] = TriggerObj
			elseif Type == "damage" then
				self.Damage[Trigger] = TriggerObj
			elseif Type == "cast" then
				if not self.Cast[Unit.Mod.ID] then
					self.Cast[Unit.Mod.ID] = {}
				end
				if not self.Cast[Unit.Mod.ID][Unit.Name] then
					self.Cast[Unit.Mod.ID][Unit.Name] = {}
				end
				self.Cast[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "castID" then
				if not self.CastID[Unit.Mod.ID] then
					self.CastID[Unit.Mod.ID] = {}
				end
				if not self.CastID[Unit.Mod.ID][Unit.Name] then
					self.CastID[Unit.Mod.ID][Unit.Name] = {}
				end
				self.CastID[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "personalCast" then
				if not self.PersonalCast[Unit.Mod.ID] then
					self.PersonalCast[Unit.Mod.ID] = {}
				end
				if not self.PersonalCast[Unit.Mod.ID][Unit.Name] then
					self.PersonalCast[Unit.Mod.ID][Unit.Name] = {}
				end
				self.PersonalCast[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "personalCastID" then
				if not self.PersonalCastID[Unit.Mod.ID] then
					self.PersonalCastID[Unit.Mod.ID] = {}
				end
				if not self.PersonalCastID[Unit.Mod.ID][Unit.Name] then
					self.PersonalCastID[Unit.Mod.ID][Unit.Name] = {}
				end
				self.PersonalCastID[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "channel" then
				if not self.Channel[Unit.Mod.ID] then
					self.Channel[Unit.Mod.ID] = {}
				end
				if not self.Channel[Unit.Mod.ID][Unit.Name] then
					self.Channel[Unit.Mod.ID][Unit.Name] = {}
				end
				self.Channel[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "channelID" then
				if not self.ChannelID[Unit.Mod.ID] then
					self.ChannelID[Unit.Mod.ID] = {}
				end
				if not self.ChannelID[Unit.Mod.ID][Unit.Name] then
					self.ChannelID[Unit.Mod.ID][Unit.Name] = {}
				end
				self.ChannelID[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "personalChannel" then
				if not self.PersonalChannel[Unit.Mod.ID] then
					self.PersonalChannel[Unit.Mod.ID] = {}
				end
				if not self.PersonalChannel[Unit.Mod.ID][Unit.Name] then
					self.PersonalChannel[Unit.Mod.ID][Unit.Name] = {}
				end
				self.PersonalChannel[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "personalChannelID" then
				if not self.PersonalChannelID[Unit.Mod.ID] then
					self.PersonalChannelID[Unit.Mod.ID] = {}
				end
				if not self.PersonalChannelID[Unit.Mod.ID][Unit.Name] then
					self.PersonalChannelID[Unit.Mod.ID][Unit.Name] = {}
				end
				self.PersonalChannelID[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj			
			elseif Type == "interrupt" then
				if not self.Interrupt[Unit.Mod.ID] then
					self.Interrupt[Unit.Mod.ID] = {}
				end
				if not self.Interrupt[Unit.Mod.ID][Unit.Name] then
					self.Interrupt[Unit.Mod.ID][Unit.Name] = {}
				end
				self.Interrupt[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "interruptID" then
				if not self.InterruptID[Unit.Mod.ID] then
					self.InterruptID[Unit.Mod.ID] = {}
				end
				if not self.InterruptID[Unit.Mod.ID][Unit.Name] then
					self.InterruptID[Unit.Mod.ID][Unit.Name] = {}
				end
				self.Interrupt[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "personalInterrupt" then
				if not self.PersonalInterrupt[Unit.Mod.ID] then
					self.PersonalInterrupt[Unit.Mod.ID] = {}
				end
				if not self.PersonalInterrupt[Unit.Mod.ID][Unit.Name] then
					self.PersonalInterrupt[Unit.Mod.ID][Unit.Name] = {}
				end
				self.PersonalInterrupt[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "personalInterruptID" then
				if not self.PersonalInterruptID[Unit.Mod.ID] then
					self.PersonalInterruptID[Unit.Mod.ID] = {}
				end
				if not self.PersonalInterruptID[Unit.Mod.ID][Unit.Name] then
					self.PersonalInterruptID[Unit.Mod.ID][Unit.Name] = {}
				end
				self.PersonalInterruptID[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "percent" then
				if not self.Percent[Unit.Mod.ID] then
					self.Percent[Unit.Mod.ID] = {}
				end
				if not self.Percent[Unit.Mod.ID][Unit.Name] then
					self.Percent[Unit.Mod.ID][Unit.Name] = {}
				end
				self.Percent[Unit.Mod.ID][Unit.Name][Trigger] = TriggerObj
			elseif Type == "combat" then
				self.Combat[Trigger] = TriggerObj
			elseif Type == "start" then
				if not self.Start[Unit.Mod.ID] then
					self.Start[Unit.Mod.ID] = {}
				end
				table.insert(self.Start[Unit.Mod.ID], TriggerObj)
			elseif Type == "death" then
				if not self.Death[Unit.Mod.ID] then
					self.Death[Unit.Mod.ID] = {}
				end
				self.Death[Unit.Mod.ID][Trigger] = TriggerObj
			elseif Type == "buff" then
				if not self.Buff[Unit.Mod.ID] then
					self.Buff[Unit.Mod.ID] = {}
				end
				if not self.Buff[Unit.Mod.ID][Trigger] then
					self.Buff[Unit.Mod.ID][Trigger] = {}
				end
				self.Buff[Unit.Mod.ID][Trigger][Unit.Name] = TriggerObj
			elseif Type == "buffID" then
				if not self.BuffID[Unit.Mod.ID] then
					self.BuffID[Unit.Mod.ID] = {}
				end
				if not self.BuffID[Unit.Mod.ID][Trigger] then
					self.BuffID[Unit.Mod.ID][Trigger] = {}
				end
				self.BuffID[Unit.Mod.ID][Trigger][Unit.Name] = TriggerObj
			elseif Type == "buffRemove" then
				if not self.BuffRemove[Unit.Mod.ID] then
					self.BuffRemove[Unit.Mod.ID] = {}
				end
				if not self.BuffRemove[Unit.Mod.ID][Trigger] then
					self.BuffRemove[Unit.Mod.ID][Trigger] = {}
				end
				self.BuffRemove[Unit.Mod.ID][Trigger][Unit.Name] = TriggerObj
			elseif Type == "buffIDRemove" then
				if not self.BuffIDRemove[Unit.Mod.ID] then
					self.BuffIDRemove[Unit.Mod.ID] = {}
				end
				if not self.BuffIDRemove[Unit.Mod.ID][Trigger] then
					self.BuffIDRemove[Unit.Mod.ID][Trigger] = {}
				end
				self.BuffIDRemove[Unit.Mod.ID][Trigger][Unit.Name] = TriggerObj
			elseif Type == "playerBuff" or Type == "playerDebuff" then
				if not self.PlayerBuff[Unit.Mod.ID] then
					self.PlayerBuff[Unit.Mod.ID] = {}
				end
				self.PlayerBuff[Unit.Mod.ID][Trigger] = TriggerObj
			elseif Type == "playerBuffRemove" then
				if not self.PlayerBuffRemove[Unit.Mod.ID] then
					self.PlayerBuffRemove[Unit.Mod.ID] = {}
				end
				self.PlayerBuffRemove[Unit.Mod.ID][Trigger] = TriggerObj
			-- elseif Type == "playerDebuff" then
				-- if not self.PlayerDebuff[Unit.Mod.ID] then
					-- self.PlayerDebuff[Unit.Mod.ID] = {}
				-- end
				-- self.PlayerDebuff[Unit.Mod.ID][Trigger] = TriggerObj
			elseif Type == "playerIDBuff" then
				if not self.PlayerIDBuff[Unit.Mod.ID] then
					self.PlayerIDBuff[Unit.Mod.ID] = {}
				end
				self.PlayerIDBuff[Unit.Mod.ID][Trigger] = TriggerObj
			elseif Type == "playerIDBuffRemove" then
				if not self.PlayerIDBuffRemove[Unit.Mod.ID] then
					self.PlayerIDBuffRemove[Unit.Mod.ID] = {}
				end
				self.PlayerIDBuffRemove[Unit.Mod.ID][Trigger] = TriggerObj			
			elseif Type == "time" then
				if not self.Time[Unit.Mod.ID] then
					self.Time[Unit.Mod.ID] = {}
				end
				self.Time[Unit.Mod.ID][Trigger] = TriggerObj
			else
				error("Unknown trigger type: "..tostring(Type))
			end
		else
			if not self[NonEncounter][Type] then
				self[NonEncounter][Type] = {}
			end
			if NonEncounter == "EncStart" then
				self[NonEncounter][Type][Trigger] = Unit.Mod
			elseif NonEncounter == "CustomBuffRemove" then
				self[NonEncounter][Type][Trigger] = TriggerObj
				KBM.Buffs.WatchID[Trigger] = true
			end
		end
		
		table.insert(self.List, TriggerObj)
		return TriggerObj		
	end
	
	function self:Unload()
		self.Notify = {}
		self.Say = {}
		self.Damage = {}
		self.Cast = {}
		self.Percent = {}
		self.Combat = {}
		self.Start = {}
		self.Death = {}
		self.Buff = {}		
	end
end