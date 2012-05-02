-- King Boss Mods Messenger Systems
-- Written By Paul Snart
-- Copyright 2012
--

local AddonData = Inspect.Addon.Detail("KBMMessenger")
local KBMMSG = AddonData.data

local PI = KBMMSG

local KBMAddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = KBMAddonData.data

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

function PI.MessageHandler(From, Type, Channel, Identifier, Data)
	if From ~= KBM.Player.Name and Data ~= nil then
		if Type then
			if Type == "guild" then
				if Identifier == "KBMVerInfo" then
					local s, e, High, Mid, Low, Alpha
					local Checked = false
					s, e, High, Mid, Low, Alpha = string.find(Data, "(%d+).(%d+).(%d+)[[.r]*(%d*)]*")
					Alpha = tonumber(Alpha)
					if Alpha then
						if KBM.Alpha then
							local l_Alpha
							s, e, l_Alpha = string.find(KBM.Alpha, "[.r](%d+)")
							l_Alpha = tonumber(l_Alpha)
							if KBM.Version:Check(tonumber(High), tonumber(Mid), tonumber(Low)) then
								if l_Alpha < Alpha then
									print(PI.Lang.Version.Alpha[KBM.Lang])
									print(string.format(PI.Lang.Version.AlphaInfo[KBM.Lang], l_Alpha, Alpha))
									Checked = true
								end
							end
						else
							Checked = true
						end
					end
					if not Checked then
						if not KBM.Version:Check(tonumber(High), tonumber(Mid), tonumber(Low)) then
							print(PI.Lang.Version.Old[KBM.Lang])
							print(PI.Lang.Version.OldInfo[KBM.Lang]..High.."."..Mid.."."..Low)
						end
					end
				end
			end
		end
	end
end

function PI:SendVersion()
	if KBM.Alpha then
		Command.Message.Broadcast("guild", nil, "KBMVerInfo", KBMAddonData.toc.Version..KBM.Alpha, self.VersionAlert)
	else
		Command.Message.Broadcast("guild", nil, "KBMVerInfo", KBMAddonData.toc.Version, self.VersionAlert)
	end
end

function PI.GroupJoin()
	PI:SendVersion()
end

function PI.Start()
	Command.Message.Accept("guild", "KBMVerInfo")
	table.insert(Event.SafesRaidManager.Player.Join, {PI.GroupJoin, "KBMMessenger", "Group Join Event"})
	table.insert(Event.Message.Receive, {PI.MessageHandler, "KBMMessenger", "Messenger Handler"})
	PI:SendVersion()
end

table.insert(Event.KingMolinator.System.Start, {PI.Start, "KBMMessenger", "Syncronized Start"})
