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

PI.History = {
	Checked = false,
	Time = 0,
	High = 0,
	Mid = 0,
	Low = 0,
	nVersion = 0,
	Alpha = 0,
	UpdateReq = false,
}

-- Messenger Dictionary
PI.Lang = {}
-- Version related Dictionary
PI.Lang.Version = {}
PI.Lang.Version.Old = KBM.Language:Add("There is a newer version of KBM available, please update!")
PI.Lang.Version.OldInfo = KBM.Language:Add("The most recent version seen is v")
PI.Lang.Version.Alpha = KBM.Language:Add("There is a newer Alpha build of KBM available, please update!")
PI.Lang.Version.AlphaInfo = KBM.Language:Add("You are running r%d, there is at least build r%d in circulation.")

function PI.VersionAlert(failed, message)
end

function PI.VersionCheck(Data)
	local s, e, High, Mid, Low, Alpha
	local Checked = false
	s, e, High, Mid, Low, Alpha = string.find(Data, "(%d+).(%d+).(%d+)[[.r]*(%d*)]*")
	High = tonumber(High)
	Mid = tonumber(Mid)
	Low = tonumber(Low)
	Alpha = tonumber(Alpha)
	if Alpha then
		if KBM.Alpha then
			local l_Alpha
			s, e, l_Alpha = string.find(KBM.Alpha, "[.r](%d+)")
			l_Alpha = tonumber(l_Alpha)
			if Alpha > PI.History.Alpha or PI.History.Checked == false then
				if Inspect.Time.Real() - PI.History.Alpha > 900 or PI.History.Checked == false then
					if KBM.Version:Check(High, Mid, Low) then
						if l_Alpha < Alpha then
							print(PI.Lang.Version.Alpha[KBM.Lang])
							print(string.format(PI.Lang.Version.AlphaInfo[KBM.Lang], l_Alpha, Alpha))
							Checked = true
							PI.History.Checked = true
							PI.History.Time = Inspect.Time.Real()
							PI.History.High = High
							PI.History.Mid = Mid
							PI.History.Low = Low
							PI.History.nVersion = KBM.VersionToNumber(High, Mid, Low)
							PI.History.Alpha = Alpha
						end
					end
				end
			end
		else
			Checked = true
		end
	end
	if not Checked then
		if KBM.VersionToNumber(High, Mid, Low) > PI.History.nVersion or PI.History.Checked == false then
			if Inspect.Time.Real() - PI.History.Time  > 900 or PI.History.Checked == false then
				if not KBM.Version:Check(High, Mid, Low) then
					print(PI.Lang.Version.Old[KBM.Lang])
					print(PI.Lang.Version.OldInfo[KBM.Lang]..High.."."..Mid.."."..Low)
					PI.History.Checked = true
					PI.History.Time = Inspect.Time.Real()
					PI.History.High = High
					PI.History.Mid = Mid
					PI.History.Low = Low
					PI.History.nVersion = KBM.VersionToNumber(High, Mid, Low)
					PI.History.Alpha = 0
				end
			end
		end
	end
end

function PI.SendCheck(failed, message)
	if not failed then
	
	else
		
	end
end

function PI.ReplyVersion(From)
	if not PI.SendSilent then
		if KBM.Alpha then
			Command.Message.Send(From, "KBMVerInfo", KBMAddonData.toc.Version..KBM.Alpha, PI.SendCheck)
		else
			Command.Message.Send(From, "KBMVerInfo", KBMAddonData.toc.Version, PI.SendCheck)
		end
	end
end

function PI.MessageHandler(From, Type, Channel, Identifier, Data)
	if From ~= KBM.Player.Name and Data ~= nil then
		if Type then
			if Type == "guild" then
				if Identifier == "KBMVerInfo" then
					PI.VersionCheck(Data)
				end
			elseif Type == "raid" then
				if Identifier == "KBMVerInfo" then
					PI.VersionCheck(Data)
				end
			elseif Type == "send" then
				if Identifier == "KBMVerReq" then
					PI.ReplyVersion(From)
				elseif Identifier == "KBMVerInfo" then
					print(From.." is using KBM v"..Data)
				end
			end
		end
	end
end

function PI:SendVersion(Group)
	if not PI.SendSilent then
		if KBM.Alpha then
			if not Group then
				Command.Message.Broadcast("guild", nil, "KBMVerInfo", KBMAddonData.toc.Version..KBM.Alpha, self.VersionAlert)
			else
				Command.Message.Broadcast("raid", nil, "KBMVerInfo", KBMAddonData.toc.Version..KBM.Alpha, self.VersionAlert)
			end
		else
			if not Group then
				Command.Message.Broadcast("guild", nil, "KBMVerInfo", KBMAddonData.toc.Version, self.VersionAlert)
			else
				Command.Message.Broadcast("raid", nil, "KBMVerInfo", KBMAddonData.toc.Version, self.VersionAlert)
			end
		end
	end
end

function PI.PlayerJoin()
	PI:SendVersion(true)
end

function PI.Start()
	Command.Message.Accept("guild", "KBMVerInfo")
	Command.Message.Accept("raid", "KBMVerInfo")
	Command.Message.Accept("send", "KBMVerReq")
	Command.Message.Accept("send", "KBMVerInfo")
	table.insert(Event.SafesRaidManager.Player.Join, {PI.PlayerJoin, "KBMMessenger", "Player Join"})
	table.insert(Event.Message.Receive, {PI.MessageHandler, "KBMMessenger", "Messenger Handler"})
	PI:SendVersion()
end

PI.SendSilent = false
table.insert(Event.KingMolinator.System.Start, {PI.Start, "KBMMessenger", "Syncronized Start"})