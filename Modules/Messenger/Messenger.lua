-- King Boss Mods Messenger Systems
-- Written By Paul Snart
-- Copyright 2012
--

local AddonData = Inspect.Addon.Detail("KBMMessenger")
local KBMMSG = AddonData.data

local PI = KBMMSG

local KBMAddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = KBMAddonData.data

KBM.MSG = PI
local KBMLM = KBM.LocaleManager

PI.History = {
	Checked = false,
	Time = 0,
	High = 0,
	Mid = 0,
	Low = 0,
	vType = "R",
	Revision = 0,
	UpdateReq = false,
	NameStore = {},
}

-- Dictionary moved to Locale file.

function PI.VersionAlert(failed, message)
end

function PI.VersionCheck(Data)
	local s, e, High, Mid, Low, Revision
	local Checked = false
	s, e, vType, High, Mid, Low, Revision = string.find(Data, "(%u)(%d+).(%d+).(%d+).(%d+)")
	High = tonumber(High)
	Mid = tonumber(Mid)
	Low = tonumber(Low)
	Revision = tonumber(Revision)
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
		if Revision >= PI.History.Revision or PI.History.Checked == false then
			if Inspect.Time.Real() - PI.History.Time > 900 or PI.History.Checked == false then
				if KBM.Version.Revision < Revision then
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
			Command.Message.Send(From, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low..".r"..KBM.Version.Revision, PI.SendCheck)
		else
			Command.Message.Send(From, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low, PI.SendCheck)
		end
	else
		if KBM.IsAlpha then
			Command.Message.Send(From, "KBMVersion", "A"..KBMAddonData.toc.Version, PI.SendCheck)			
		else
			Command.Message.Send(From, "KBMVersion", "R"..KBMAddonData.toc.Version, PI.SendCheck)		
		end
	end
end

function PI.MessageHandler(From, Type, Channel, Identifier, Data)
	if From ~= KBM.Player.Name and Data ~= nil then
		if Type then
			if Type == "guild" then
				PI.History.NameStore[From] = Data
				if Identifier == "KBMVersion" then
					PI.VersionCheck(Data)
				end
			elseif Type == "raid" then
				PI.History.NameStore[From] = Data
				if Identifier == "KBMVersion" then
					PI.VersionCheck(Data)
				end
			elseif Type == "send" then
				if Identifier == "KBMVerReq" then
					PI.ReplyVersion(From, Data)
				elseif Identifier == "KBMVerInfo" then
					PI.History.NameStore[From] = Data
					print(From.." is using KBM v"..Data)
				elseif Identifier == "KBMVersion" then
					PI.History.NameStore[From] = Data
					local vType = string.sub(Data, 1, 1)
					local Version = string.sub(Data, 2)
					if vType == "A" then
						vType = " Alpha"
					else
						vType = ""
					end
					print(From.." is using KBM v"..Version..vType)
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
				Command.Message.Broadcast("guild", nil, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low..".r"..KBM.Version.Revision, self.VersionAlert)
			else
				Command.Message.Broadcast("raid", nil, "KBMVersion", "A"..KBMAddonData.toc.Version, self.VersionAlert)
				Command.Message.Broadcast("raid", nil, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low..".r"..KBM.Version.Revision, self.VersionAlert)
			end
		else
			if not Group then
				Command.Message.Broadcast("guild", nil, "KBMVersion", "R"..KBMAddonData.toc.Version, self.VersionAlert)
				Command.Message.Broadcast("guild", nil, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low, self.VersionAlert)
			else
				Command.Message.Broadcast("raid", nil, "KBMVersion", "R"..KBMAddonData.toc.Version, self.VersionAlert)
				Command.Message.Broadcast("raid", nil, "KBMVerInfo", KBM.Version.High.."."..KBM.Version.Mid.."."..KBM.Version.Low, self.VersionAlert)
			end
		end
	end
end

function PI.PlayerJoin()
	PI:SendVersion(true)
end

function PI.Start()
	Command.Message.Accept("guild", "KBMVersion")
	Command.Message.Accept("raid", "KBMVersion")
	Command.Message.Accept("send", "KBMVerReq")
	Command.Message.Accept("send", "KBMVersion")
	Command.Message.Accept("send", "KBMVerInfo")
	table.insert(Event.SafesRaidManager.Player.Join, {PI.PlayerJoin, "KBMMessenger", "Player Join"})
	table.insert(Event.Message.Receive, {PI.MessageHandler, "KBMMessenger", "Messenger Handler"})
	PI:SendVersion()
end

PI.SendSilent = false
table.insert(Event.KingMolinator.System.Start, {PI.Start, "KBMMessenger", "Syncronized Start"})