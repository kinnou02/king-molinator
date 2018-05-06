-- King Boss Mods Messenger Systems
-- Written By Paul Snart
-- Copyright 2012
--

local AddonData = Inspect.Addon.Detail("KBMMessenger")
local KBMMSG = AddonData.data

local PI = KBMMSG

local KBMAddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = KBMAddonData.data
if not KBM.BossMod then
	return
end

local LSUIni = Inspect.Addon.Detail("SafesUnitLib")
local LibSUnit = LSUIni.data

local KBMLM = KBM.LocaleManager

PI.History = {
	Checked = false,
	Time = 0,
	High = 0,
	Mid = 0,
	Low = 0,
	vType = "R",
	LastQuery = 0,
	Revision = 0,
	UpdateReq = false,
	NameStore = {
	},
	Create = function(self, Name)
		self.NameStore[Name] = {
			Sent = false,
		}
		--print("Created new Name-Store Entry for: "..Name)
	end,
	SetFull = function(self, Name, vFull)
		if not self.NameStore[Name] then
			self:Create(Name)
		end
		self.NameStore[Name].Full = vFull
		if vFull then
			self.NameStore[Name].None = nil
		end
	end,
	SetSent = function(self, Name, bool)
		if not self.NameStore[Name] then
			self:Create(Name)
		end
		self.NameStore[Name].Sent = bool
		if not bool then
			self.NameStore[Name].Queued = true
		else
			PI.Events.Version(Name)		
		end
	end,
	SetReceived = function(self, Name)
		if not self.NameStore[Name] then
			self:Create(Name)
		end
		self.NameStore[Name].Sent = true
		self.NameStore[Name].Received = true
	end,
	SetNone = function(self, Name)
		if not self.NameStore[Name] then
			self:Create(Name)
		end
		self.NameStore[Name].None = true
		PI.Events.Version(Name)
	end,
	Queue = {},
}
KBM.MSG = PI

PI.Events = {
	Version = {},
}
PI.Mode = "party"

-- Dictionary moved to Locale file.

function PI.VersionAlert(failed, message)
end

function PI.ParseVersion(Data)
	local s, e, vType, High, Mid, Low, Revision
	local Checked = false
	s, e, vType, High, Mid, Low, Revision = string.find(Data, "(%u)(%d+).(%d+).(%d+).(%d+)")
	High = tonumber(High) or 0
	Mid = tonumber(Mid) or 0
	Low = tonumber(Low) or 0
	Revision = tonumber(Revision) or 0
	return vType, High, Mid, Low, Revision
end

function PI.VersionCheck(Data)
	local vType, High, Mid, Low, Revision
	local Checked = false
	vType, High, Mid, Low, Revision = PI.ParseVersion(Data)
	if vType == "A" then
		if KBM.IsAlpha then
			if Revision >= PI.History.Revision or PI.History.Checked == false then
				if Inspect.Time.Real() - PI.History.Time > 900 or PI.History.Checked == false then
					if KBM.Version.Revision < Revision then
						print(KBM.Language.Version.Alpha[KBM.Lang])
						print(string.format(KBM.Language.Version.AlphaInfo[KBM.Lang], KBM.Version.Revision, Revision))
						PI.History.Checked = true
						PI.History.Time = Inspect.Time.Real()
						PI.History.High = High
						PI.History.Mid = Mid
						PI.History.Low = Low
						PI.History.Revision = Revision
						PI.History.Type = vType
					end
				end
			end
		end
		Checked = true	
	end
	if not Checked then
        if Inspect.Time.Real() - PI.History.Time > 900 or PI.History.Checked == false then
            if not KBM.Version:Check(High, Mid, Low, Revision) then
                print(KBM.Language.Version.Old[KBM.Lang])
                print(KBM.Language.Version.OldInfo[KBM.Lang]..High.."."..Mid.."."..Low.."."..Revision)
                Checked = true
                PI.History.Checked = true
                PI.History.Time = Inspect.Time.Real()
                PI.History.High = High
                PI.History.Mid = Mid
                PI.History.Low = Low
                PI.History.Revision = Revision
                PI.History.Type = vType
            end
        end
		Checked = true
	end
end

function PI.SendCheck(failed, message)
	if not failed then
	
	else
		
	end
end

function PI.ReplyVersion(From, rType)
	if rType == "v" then
		if KBM.IsAlpha then
			Command.Message.Broadcast("tell", From, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low..".r"..KBM.Version.Revision, PI.SendCheck)
			--Command.Message.Send(From, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low..".r"..KBM.Version.Revision, PI.SendCheck)
		else
			Command.Message.Broadcast("tell", From, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low, PI.SendCheck)
			--Command.Message.Send(From, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low, PI.SendCheck)
		end
	else
		if KBM.IsAlpha then
			Command.Message.Broadcast("tell", From, "KBMVersion", "A"..KBMAddonData.toc.Version, PI.SendCheck)			
			--Command.Message.Send(From, "KBMVersion", "A"..KBMAddonData.toc.Version, PI.SendCheck)			
		else
			Command.Message.Broadcast("tell", From, "KBMVersion", "R"..KBMAddonData.toc.Version, PI.SendCheck)		
			--Command.Message.Send(From, "KBMVersion", "R"..KBMAddonData.toc.Version, PI.SendCheck)		
		end
	end
end

function PI.MessageHandler(handle, From, Type, Channel, Identifier, Data)
	if From ~= LibSUnit.Player.Name and Data ~= nil then
		if Type then
			if Type == "guild" then
				if Identifier == "KBMVersion" then
					PI.History:SetFull(From, Data)
					PI.History:SetReceived(From)
					PI.VersionCheck(Data)
					PI.Events.Version(From)
				end
			elseif Type == "raid" or Type == "party" then
				if Identifier == "KBMVersion" then
					PI.History:SetFull(From, Data)
					PI.History:SetReceived(From)
					PI.VersionCheck(Data)
					PI.Events.Version(From)
				end
			elseif Type == "send" or Type == "tell" then
				if Identifier == "KBMVerReq" then
					PI.ReplyVersion(From, Data)
				elseif Identifier == "KBMVerInfo" then
					local Silent = false
					if PI.History.NameStore[From] then
						if PI.History.NameStore[From].Queued then
							Silent = true
						end
					end
					PI.History:SetFull(From, "R"..Data)
					PI.History:SetReceived(From)
					if not Silent then
						print(From.." is using KBM v"..Data)
					end
					PI.Events.Version(From)
				elseif Identifier == "KBMVersion" then
					local Silent = false
					if PI.History.NameStore[From] then
						if PI.History.NameStore[From].Queued then
							Silent = true
						end
					end
					PI.History:SetFull(From, Data)
					PI.History:SetReceived(From)
					local vType = string.sub(Data, 1, 1)
					local Version = string.sub(Data, 2)
					if vType == "A" then
						vType = " Alpha"
					else
						vType = ""
					end
					if not Silent then
						print(From.." is using KBM v"..Version..vType)
					end
					PI.Events.Version(From)
				end
			end
		end
	end
end

function PI:SendVersion(Group)
	if not PI.SendSilent then
		if KBM.IsAlpha then
			if not Group then
				Command.Message.Broadcast("guild", nil, "KBMVersion", "A"..KBMAddonData.toc.Version, self.VersionAlert)
				--Command.Message.Broadcast("guild", nil, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low..".r"..KBM.Version.Revision, self.VersionAlert)
			else
				Command.Message.Broadcast(PI.Mode, nil, "KBMVersion", "A"..KBMAddonData.toc.Version, self.VersionAlert)
				--Command.Message.Broadcast("raid", nil, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low..".r"..KBM.Version.Revision, self.VersionAlert)
			end
		else
			if not Group then
				Command.Message.Broadcast("guild", nil, "KBMVersion", "R"..KBMAddonData.toc.Version, self.VersionAlert)
				--Command.Message.Broadcast("guild", nil, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low, self.VersionAlert)
			else
				Command.Message.Broadcast(PI.Mode, nil, "KBMVersion", "R"..KBMAddonData.toc.Version, self.VersionAlert)
				--Command.Message.Broadcast("raid", nil, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low, self.VersionAlert)
			end
		end
	end
end

function PI.PlayerJoin()
	PI:SendVersion(true)
end

function PI.GroupJoin(handle, UnitObj, Specificer)
	if UnitObj.Name then
		if not PI.History.NameStore[UnitObj.Name] then
			if KBM.Debug then
				--print("Player joined without Version info Queuing: "..uDetails.name)
			end
			PI.History:SetSent(UnitObj.Name, false)
			PI.History.Queue[UnitObj.Name] = true
		end
	end
end

function PI.GroupMode()
	PI.Mode = LibSUnit.Raid.Mode
end

function PI.VersionReqCheck(name, failed, message)
end

function PI.ManageQueues()
	local current = Inspect.Time.Real()
	if PI.History.LastQuery < current then
		if PI.History.Current then
			PI.History.Queue[PI.History.Current] = nil
			if not PI.History.NameStore[PI.History.Current].Received then
				PI.History:SetNone(PI.History.Current)
			end
			if KBM.Debug then
				print("Removing from Queue: "..PI.History.Current)
			end
			PI.History.NameStore[PI.History.Current].Queued = nil
			PI.History.Current = nil
			PI.Events.Version(From)
		else
			if next(PI.History.Queue) then
				PI.History.Current = next(PI.History.Queue)
				if KBM.Debug then
					print("Current set to: "..PI.History.Current)
				end
				PI.History.LastQuery = current + 5
				PI.History:SetSent(PI.History.Current, true)
				Command.Message.Send(PI.History.Current, "KBMVerReq", "V", function (failed, message) PI.VersionReqCheck(PI.History.Current, failed, message) end)
			end
		end
	end
end

function PI.Start()
	Command.Message.Accept(nil, "KBMVersion")
	Command.Message.Accept(nil, "KBMVerReq")
	Command.Message.Accept(nil, "KBMVerInfo")
	Command.Event.Attach(Event.SafesUnitLib.Raid.Join, PI.PlayerJoin, "KBM Messenger Player Join")
	Command.Event.Attach(Event.SafesUnitLib.Raid.Mode, PI.GroupMode, "KBM Messenger Group Mode Changed")
	Command.Event.Attach(Event.SafesUnitLib.Raid.Member.Join, PI.GroupJoin, "KBM Messenger Group Member Joins")
	Command.Event.Attach(Event.Message.Receive, PI.MessageHandler, "KBM Messenger Messenger Handler")
	Command.Event.Attach(Event.System.Update.End, PI.ManageQueues, "KBM Messenger Cycle Version Queue")
	PI.History:SetFull(LibSUnit.Player.Name, "P"..KBMAddonData.toc.Version)
	PI.History:SetReceived(LibSUnit.Player.Name)
	PI:SendVersion()
end

PI.SendSilent = false
PI.Events.Version, PI.Events.Version.EventTable = Utility.Event.Create("KBMMessenger", "Version")
Command.Event.Attach(Event.KingMolinator.System.Start, PI.Start, "KBM Messenger Syncronized Start")