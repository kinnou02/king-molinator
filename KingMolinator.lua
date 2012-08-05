-- King Boss Mods
-- Written By Paul Snart
-- Copyright 2011

local IBDReserved = Inspect.Buff.Detail

KBM_GlobalOptions = nil
chKBM_GlobalOptions = nil

local KingMol_Main = {}
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local LocaleManager = Inspect.Addon.Detail("KBMLocaleManager")
local KBMLM = LocaleManager.data
KBMLM.Start(KBM)
KBM.BossMod = {}
KBM.Event = {
	Mark = {},
	System = {
		Start = {},
		TankSwap = {
			Start = {},
			End = {},
		},
		Player = {
			Join = {},
			Leave = {},
		},
		Group = {
			Join = {},
			Leave = {},
		},
	},
	Unit = {
		PercentChange = {},
		Available = {},
		Unavailable = {},
		Remove = {},
		Death = {},
		Name = {},
		Relation = {},
		Calling = {},
		Target = {},
		TargetCount = {},
		Offline = {},
		Power = {},
		Combat = {
			Enter = {},
			Leave = {},
		},
		Cast = {
			Start = {},
			End = {},
			Interrupt = {},
		},
	},
	Encounter = {
		Start = {},
		End = {},
	}
}
KBM.Unit = {	
	UIDs = {		
		Available = {},
		Idle = {},
		Flush = {},
		Count = {
			Available = 0,
			Idle = 0,
		},	
	},
	List = {
		UID = {},
		Type = {},
		Name = {},
	},	
	NPC = {
		friendly = {},
		hostile = {},
		neutral = {},
		unknown = {},
		Count = 0,
	},
	Player = {
		friendly = {},
		hostile = {},
		neutral = {},
		unknown = {},
		Count = 0,
	},
	Unknown = {
		List = {},
		neutral = {},
		hostile = {},
		friendly = {},
		unknown = {},
		Count = 0,
	},
	TargetQueue = {},
	TargetRemove = {},
	RaidTargets = {},
	Names = {},
	Dead = {
		Count = 0,
	},
}
KBM.CPU = {}
KBM.Lang = Inspect.System.Language()
KBM.Player = {
	Rezes = {},
	Resume = {},
}
KBM.ID = "KingMolinator"
KBM.ModList = {}
KBM.Testing = false
KBM.ValidTime = false
KBM.IsAlpha = true
KBM.Debug = false
KBM.Aux = {}
KBM.TestFilters = {}
KBM.IgnoreList = {}
KBM.Watchdog = {
	Buffs = {
		Count = 0,
		Total = 0,
		Peak = 0,
		Average = 0,
		wTime = 99,
	},
	Avail = {
		Count = 0,
		Total = 0,
		Peak = 0,
		Average = 0,
		wTime = 99,
	},
	Main = {
		Count = 0,
		Total = 0,
		Peak = 0,
		Averahe = 0,
		wTime = 99,
	},
}
KBM.Idle = {
	Until = 0,
	Duration = 5,
	Wait = false,
	Combat = {
		Until = 0,
		Duration = 5,
		Wait = false,
		StoreTime = 0,
	},
	Trigger = {
		Duration = 0, 
	}
}
KBM.MenuOptions = {
	Timers = {},
	CastBars = {},
	TankSwap = {},
	Alerts = {},
	Phases = {},
	MechSpy = {},
	RezMaster = {},
	Main = {},
	Enabled = true,
	Handler = nil,
	Options = nil,
	Name = "Options",
	ID = "Options",
}

--KBM.DistanceCalc = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
KBM.Defaults = {}
KBM.Constant = {}
KBM.Buffs = {}
KBM.Buffs.Active = {}

function KBM.AlphaComp(Comp, With)
	if type(Comp) == "string" and type(With) == "string" then
		local CompLen = string.len(Comp)
		local WithLen = string.len(With)
		for i = 1, CompLen do
			if i > WithLen then
				return true
			end
			local cByte = string.byte(Comp, i)
			local wByte = string.byte(With, i)
			if cByte ~= wByte then
				if cByte < wByte then
					return true
				else
					return false
				end
			end
		end
	end
end

function KBM.Defaults.EncTimer()
	local EncTimer = {
		Type = "EncTimer",
		Override = false,
		x = false,
		y = false,
		w = 150,
		h = 25,
		wScale = 1,
		hScale = 1,
		tScale = 1,
		Enabled = true,
		Unlocked = true,
		Visible = true,
		ScaleWidth = false,
		ScaleHeight = false,
		TextSize = 15,
		TextScale = false,
		Enrage = true,
		Duration = true,
	}
	return EncTimer
end

KBM.Version = {}
function KBM.Version:Load()
	local s = 0
	local e = 0
	s, e, self.High, self.Mid, self.Low, self.Revision = string.find(AddonData.toc.Version, "(%d+).(%d+).(%d+).(%d+)")
	if self.High then
		self.High = tonumber(self.High)
	else
		self.High = 0
	end
	if self.Mid then
		self.Mid = tonumber(self.Mid)
	else
		self.Mid = 0
	end
	if self.Low then
		self.Low = tonumber(self.Low)
	else
		self.Low = 0
	end
	if self.Revision then
		self.Revision = tonumber(self.Revision)
	else
		self.Revision = 0
	end
end

KBM.Version:Load()

function KBM.VersionToNumber(High, Mid, Low, Rev)
	return Rev
end

function KBM.Version:Check(High, Mid, Low, Revision)
	if Revision then
		if Revision > self.Revision then
			return false
		else
			return true
		end
	else
		if High <= self.High then
			if High < self.High then
				return true
			else
				if Mid <= self.Mid then
					if Mid < self.Mid then
						return true
					else
						if Low <= self.Low then
							return true
						else
							return false
						end
					end
				else
					return
				end
			end
		else
			return false
		end
	end
end

KBM.Defaults.CastFilter = {}
function KBM.Defaults.CastFilter.Create(Color)
	if not Color then
		Color = "red"
	end
	if not KBM.Colors.List[Color] then
		print("Warning: Color error for CastFilter.Create ("..Color..")")
		print("Color does not exist.")
	end
	local FilterObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Custom = false,
	}
	return FilterObj
end
function KBM.Defaults.CastFilter.Assign(BossObj)
	if BossObj.HasCastFilters then
		for ID, Data in pairs(BossObj.Settings.Filters) do
			if type(Data) == "table" then
				Data.ID = ID
			end
		end
		for Name, Data in pairs(BossObj.CastFilters) do
			if type(Data) == "table" then
				Data.Prefix = ""
				Data.Settings = BossObj.Settings.Filters[Data.ID]
				if BossObj.Settings.Filters.Enabled then
					Data.Enabled = Data.Settings.Enabled
				else
					Data.Enabled = false
				end
				Data.Color = Data.Settings.Color
				Data.Custom = Data.Settings.Custom
			end
		end
	end
end

KBM.Defaults.MechObj = {}
function KBM.Defaults.MechObj.Create(Color)
	if not Color then
		Color = "red"
	end
	if not KBM.Colors.List[Color] then
		error("Color error for MechObj.Create ("..tostring(Color)..")\nColor Index does not exist.")
	end
	local TimerObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Default_Color = Color,
		Custom = false,
	}
	return TimerObj
end
function KBM.Defaults.MechObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.MechRef) do
		if BossObj.Settings.MechRef[ID] then
			if type(BossObj.Settings.MechRef[ID]) == "table" then
				Data.ID = ID
				if BossObj.Settings.MechRef.Enabled then
					Data.Enabled = BossObj.Settings.MechRef[ID].Enabled
				else
					Data.Enabled = false
				end
				Data.Settings = BossObj.Settings.MechRef[ID]
				BossObj.Settings.MechRef[ID].ID = ID
				if not Data.HasMenu then
					Data.Enabled = true
					Data.Settings.Enabled = true
				end
				if not KBM.Colors.List[Data.Settings.Color] then
					print("TimerObj Assign Error: "..Data.ID)
					print("Color Index ("..Data.Settings.Color..") does not exist, ignoring settings.")
					print("For: "..BossObj.Name)
					Data.Settings.Color = Data.Settings.Default_Color
				end
				Data.Color = Data.Settings.Default_Color
				Data.Settings.Default_Color = nil
			end
		else
			print("Warning: "..ID.." is undefined in MechRef")
			print("for boss: "..BossObj.Name)
			print("---------------")
		end
	end
end

KBM.Defaults.TimerObj = {}
function KBM.Defaults.TimerObj.Create(Color)
	if not Color then
		Color = "blue"
	end
	if not KBM.Colors.List[Color] then
		error("Color error for TimerObj.Create ("..tostring(Color)..")\nColor Index does not exist.")
	end
	local TimerObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Default_Color = Color,
		Custom = false,
	}
	return TimerObj
end
function KBM.Defaults.TimerObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.TimersRef) do
		if BossObj.Settings.TimersRef[ID] then
			if type(BossObj.Settings.TimersRef[ID]) == "table" then
				Data.ID = ID
				if BossObj.Settings.TimersRef.Enabled then
					Data.Enabled = BossObj.Settings.TimersRef[ID].Enabled
				else
					Data.Enabled = false
				end
				Data.Settings = BossObj.Settings.TimersRef[ID]
				BossObj.Settings.TimersRef[ID].ID = ID
				if not Data.HasMenu then
					Data.Enabled = true
					Data.Settings.Enabled = true
				end
				if not KBM.Colors.List[Data.Settings.Color] then
					print("TimerObj Assign Error: "..Data.ID)
					print("Color Index ("..Data.Settings.Color..") does not exist, ignoring settings.")
					print("For: "..BossObj.Name)
					Data.Settings.Color = Data.Settings.Default_Color
				end
				Data.Color = Data.Settings.Default_Color
				Data.Settings.Default_Color = nil
			end
		else
			print("Warning: "..ID.." is undefined in TimersRef")
			print("for boss: "..BossObj.Name)
			print("---------------")
		end
	end
end	

KBM.Defaults.AlertObj = {}
function KBM.Defaults.AlertObj.Create(Color, OldData)
	if not Color then
		Color = "red"
	end
	if not KBM.Colors.List[Color] then
		print("Warning: Color error for AlertObj.Create ("..Color..")")
		print("Color Index does not exist, setting to Red")
		Color = "red"
	end
	if OldData ~= nil then
		error("Incorrect Format: AlertObj.Create.HasMenu no longer a setting")
	end
	local AlertObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Custom = false,
		Border = true,
		Notify = true,
		Sound = true,
	}
	return AlertObj
end
function KBM.Defaults.AlertObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.AlertsRef) do
		if BossObj.Settings.AlertsRef[ID] then
			if type(BossObj.Settings.AlertsRef[ID]) == "table" then
				Data.ID = ID
				if BossObj.Settings.AlertsRef.Enabled then
					Data.Enabled = BossObj.Settings.AlertsRef[ID].Enabled
				else
					Data.Enabled = false
				end
				Data.Settings = BossObj.Settings.AlertsRef[ID]
				if not Data.HasMenu then
					Data.Enabled = true
					Data.Settings.Enabled = true
				end
				if KBM.Colors.List[Data.Settings.Color] then
					if Data.Settings.Custom then
						Data.Color = Data.Settings.Color
					end
				else
					error(	"AlertObj Assign Error: "..Data.ID..
							"/nColor Index ("..Data.Settings.Color..") does not exist, ignoring settings."..
							"/nFor: "..BossObj.Name)
					Data.Settings.Color = Data.Color
				end
				BossObj.Settings.AlertsRef[ID].ID = ID
			end
		else
			error(	"Warning: "..ID.." is undefined in AlertsRef"..
					"\nfor boss: "..BossObj.Name)
		end
	end
end

KBM.Defaults.ChatObj = {}
function KBM.Defaults.ChatObj.Create(Color)
	if not Color then
		Color = "red"
	end
	if not KBM.Colors.List[Color] then
		print("Warning: Color error for ChatObj.Create ("..Color..")")
		print("Color Index does not exist, setting to Red")
		Color = "red"
	end
	if OldData ~= nil then
		error("Incorrect Format: ChatObj.Create.HasMenu no longer a setting")
	end
	local ChatObj = {
		ID = nil,
		Enabled = true,
		Color = Color,
		Custom = false,
	}
	return ChatObj
end
function KBM.Defaults.ChatObj.Assign(BossObj)
	for ID, Data in pairs(BossObj.ChatRef) do
		if BossObj.Settings.ChatRef[ID] then
			if type(BossObj.Settings.ChatRef[ID]) == "table" then
				Data.ID = ID
				if BossObj.Settings.ChatRef.Enabled then
					Data.Enabled = BossObj.Settings.ChatRef[ID].Enabled
				else
					Data.Enabled = false
				end
				Data.Settings = BossObj.Settings.ChatRef[ID]
				if not Data.HasMenu then
					Data.Enabled = true
					Data.Settings.Enabled = true
				end
				if KBM.Colors.List[Data.Settings.Color] then
					if Data.Settings.Custom then
						Data.Color = Data.Settings.Color
					end
				else
					error(	"ChatObj Assign Error: "..Data.ID..
							"/nColor Index ("..Data.Settings.Color..") does not exist, ignoring settings."..
							"/nFor: "..BossObj.Name)
					Data.Settings.Color = Data.Color
				end
				BossObj.Settings.ChatRef[ID].ID = ID
			end
		else
			error(	"Warning: "..ID.." is undefined in ChatRef"..
					"\nfor boss: "..BossObj.Name)
		end
	end
end

function KBM.Defaults.CastBar()
	local CastBar = {
		Override = false,
		x = false,
		y = false,
		Enabled = true,
		Style = "rift",
		Shadow = true,
		Unlocked = true,
		Visible = true,
		ScaleWidth = false,
		wScale = 1,
		hScale = 1,
		tScale = 1,
		Shadow = true,
		Texture = true,
		TextureAlpha = 0.75,
		ScaleHeight = false,
		TextScale = false,
		Pinned = false,
		Color = "red",
		Custom = false,
		Type = "CastBar",
	}
	return CastBar
end

function KBM.Defaults.PhaseMon()
	local PhaseMon = {
		Override = false,
		x = false,
		y = false,
		w = 225,
		h = 50,
		wScale = 1,
		hScale = 1,
		tScale = 1,
		Enabled = true,
		Unlocked = true,
		Visible = true,
		ScaleWidth = false,
		ScaleHeight = false,
		TextSize = 14,
		TextScale = false,
		Objectives = true,
		PhaseDisplay = true,
		Type = "PhaseMon",
	}
	return PhaseMon
end

function KBM.Constant:Init()
	self.PhaseMon = {
		w = 225,
		h = 50,
		TextSize = 14,
	}
	self.Alerts = {
		TextSize = 32,
	}
	self.MechSpy = {
		w = 275,
		h = 25,
		TextSize = 14,
		TextureAlpha = 0.75,
	}
	self.MechTimer = {
		w = 350,
		h = 32,
	}
	self.RezMaster = {
		w = 250,
		h = 26,
		TextSize = 12,
		TextureAlpha = 0.75,
	}
	self.CastBar = {
		w = 280,
		h = 32,
		TextSize = 14,
	}
end

KBM.Constant:Init()

function KBM.Defaults.MechTimer()
	local MechTimer = {
		Override = false,
		x = false,
		y = false,
		w = 350,
		h = 32,
		wScale = 1,
		hScale = 1,
		tScale = 1,
		Enabled = true,
		Unlocked = true,
		Shadow = true,
		Texture = true,
		TextureAlpha = 0.75,
		Visible = true,
		ScaleWidth = false,
		ScaleHeight = false,
		TextSize = 16,
		TextScale = false,
		Custom = false,
		Color = "blue",
		Type = "MechTimer",
	}
	return MechTimer
end

function KBM.Defaults.Alerts()
	local Alerts = {
		Override = false,
		Enabled = true,
		Flash = true,
		Notify = true,
		Visible = false,
		Unlocked = false,
		FlashUnlocked = false,
		Vertical = true,
		Horizontal = false,
		ScaleText = false,
		fScale = 0.2,
		tScale = 1,
		x = false,
		y = false,
		Type = "Alerts",
	}
	return Alerts
end

function KBM.Defaults.MechSpy()
	local MechSpy = {
		Override = false,
		Enabled = true,
		Visible = true,
		Unlocked = true,
		Show = false,
		Pin = true,
		ScaleText = false,
		ScaleWidth = false,
		ScaleHeight = false,
		tScale = 1,
		wScale = 1,
		hScale = 1,
		x = false, 
		y = false,
		Type = "MechSpy",
	}
	return MechSpy
end

function KBM.Defaults.Records()

	local RecordObj = {
		Attempts = 0,
		Wipes = 0,
		Kills = 0,
		Best = 0,
		Date = "n/a",
	}
	return RecordObj
	
end

function KBM.Defaults.Menu(ID)
	
	local MenuObj = {
		Collapse = false,
		ID = ID,
	}
	return MenuObj

end

function KBM.Defaults.Button()
	local ButtonObj = {
		x = false,
		y = false,
		Unlocked = true,
		Visible = true,
	}
	return ButtonObj
end

local function KBM_DefineVars(AddonID)
	if AddonID == "KingMolinator" then
		KBM.Options = {
			Player = {
				CastBar = KBM.Defaults.CastBar(),
			},
			Character = false,
			Enabled = true,
			Debug = false,
			Menu = {},
			CPU = {
				Enabled = false,
				x = false,
				y = false,
			},
			DebugSettings = {
				x = false,
				y = false,
			},
			Frame = {
				x = false,
				y = false,
			},
			Button = KBM.Defaults.Button(),
			Alerts = KBM.Defaults.Alerts(),
			EncTimer = KBM.Defaults.EncTimer(),
			PhaseMon = KBM.Defaults.PhaseMon(),
			CastBar = KBM.Defaults.CastBar(),
			MechTimer = KBM.Defaults.MechTimer(),
			MechSpy = KBM.Defaults.MechSpy(),
			Chat = {
				Enabled = true,
			},
			RezMaster = {
				Enabled = true,
				x = false,
				y = false,
				ScaleWidth = false,
				ScaleHeight = false,
				ScaleText = false,
				Enabled = true,
				Visible = true,
				Unlocked = true,
				wScale = 1,
				hScale = 1,
				tScale = 1,
			},
			TankSwap = {
				x = false,
				y = false,
				w = 150,
				h = 40,
				wScale = 1,
				hScale = 1,
				ScaleWidth = false,
				ScaleHeight = false,
				TextScale = false,
				TextSize = 14,
				Enabled = true,
				Visible = true,
				Unlocked = true,
			},
			BestTimes = {
			},
		}
		KBM_GlobalOptions = KBM.Options
		chKBM_GlobalOptions = KBM.Options
		KBM.Options.Player.CastBar.Enabled = false
		for _, Mod in ipairs(KBM.ModList) do
			Mod:InitVars()
			if not Mod.IsInstance then
				if Mod.Settings then
					if not Mod.Settings.Records then
						Mod.Settings.Records = KBM.Defaults.Records()
						if Mod.HasChronicle then
							Mod.Settings.Records.Chronicle = KBM.Defaults.Records()
						end
					end
				end
			end
			if not Mod.Descript then
				print("Warning: "..Mod.ID.." has no description.")
			end
		end
	elseif KBM.PlugIn.List[AddonID] then
		KBM.PlugIn.List[AddonID]:InitVars()
	end
end

function KBM.LoadTable(Source, Target)
	if type(Source) == "table" then
		for Setting, Value in pairs(Source) do
			if type(Value) == "table" then
				if Target[Setting] ~= nil then
					if type(Target[Setting]) == "table" then
						KBM.LoadTable(Value, Target[Setting])
					end
				end
			else
				if(Target[Setting]) ~= nil then
					if type(Target[Setting]) ~= "table" then
						Target[Setting] = Value
					end
				end
			end
		end
	end
end

function KBM.InitDiagnostics()
	-- KBM.Watchdog.AreaList = {
		-- ["Buffs"] = true,
		-- ["Avail"] = true,
		-- ["Main"] = true,
	-- }
	-- for diaID, bool in pairs(KBM.Watchdog.AreaList) do
		-- local tCount = 0
		-- local tStart = 1
		-- if chKBM_GlobalOptions.Character then
			-- if chKBM_GlobalOptions.Watchdog then
				-- if chKBM_GlobalOptions.Watchdog[diaID] then
					-- tCount = chKBM_GlobalOptions.Watchdog[diaID].sCount
				-- end
			-- end
		-- else
			-- if KBM_GlobalOptions.Watchdog then
				-- if KBM_GlobalOptions.Watchdog[diaID] then
					-- tCount = KBM_GlobalOptions.Watchdog[diaID].sCount
				-- end
			-- end
		-- end
		-- if tCount > 0 then
			-- if tCount > 10 then
				-- tStart = tCount - 10
			-- end
			-- for Index = tStart, tCount do
				-- KBM.Options.Watchdog[diaID].Sessions[Index] = {
					-- Total = 0,
					-- Average = 0,
					-- Peak = 0,
					-- Count = 0,
					-- wTime = 0,
				-- }
			-- end
		-- end
	-- end
end

local function KBM_LoadVars(AddonID)
	local TargetLoad = nil
	if AddonID == "KingMolinator" then		
		if chKBM_GlobalOptions.Character then
			KBM.LoadTable(chKBM_GlobalOptions, KBM.Options)
		else
			KBM.LoadTable(KBM_GlobalOptions, KBM.Options)
		end		
		
		if KBM.Options.Character then
			if chKBM_GlobalOptions.Menu then
				KBM.Options.Menu = chKBM_GlobalOptions.Menu
			end
			chKBM_GlobalOptions = KBM.Options			
		else
			if KBM_GlobalOptions.Menu then
				KBM.Options.Menu = KBM_GlobalOptions.Menu
			end
			KBM_GlobalOptions = KBM.Options		
		end
		
		for _, Mod in ipairs(KBM.ModList) do
			Mod:LoadVars()
		end
		
		KBM.Debug = KBM.Options.Debug
		KBM.InitVars()
	elseif KBM.PlugIn.List[AddonID] then
		KBM.PlugIn.List[AddonID]:LoadVars()
	end
end

local function KBM_SaveVars(AddonID)
	if AddonID == "KingMolinator" then
		if not KBM.Options.Character then
			KBM_GlobalOptions = KBM.Options
		else
			chKBM_GlobalOptions = KBM.Options
		end
		for _, Mod in ipairs(KBM.ModList) do
			Mod:SaveVars()
		end
	elseif KBM.PlugIn.List[AddonID] then
		KBM.PlugIn.List[AddonID]:SaveVars()
	end
end

function KBM.ToAbilityID(num)
	return string.format("a%016X", num)
end

KBM.MenuGroup = {}
local KBM_Boss = {}
KBM.Boss = {
	Raid = {},
	Sliver = {},
	Dungeon = {
		List = {},
	},
	MasterID = {},
	ExpertID = {},
	Chronicle = {},
	Rift = {},
	ExRift = {},
	RaidRift = {},
	World = {},
}

function KBM.Boss.Dungeon:AddBoss(BossObj)
	local BossID = nil
	if BossObj.Mod.InstanceObj.Type == "Expert" then
		BossID = BossObj.ExpertID
		if BossID ~= "Expert" then
			KBM.Boss.ExpertID[BossID] = BossObj
		end
	elseif BossObj.Mod.InstanceObj.Type == "Master" then
		BossID = BossObj.MasterID
		if BossID ~= "Master" then
			KBM.Boss.MasterID[BossID] = BossObj
		end
	end
	if not BossID then
		print("Instance: "..BossObj.Mod.Instance)
		error("Missing ExpertID or MasterID for "..BossObj.Name)
	end
	if self.List[BossObj.Name] then
		self.List[BossObj.Name][BossID] = BossObj
	else
		self.List[BossObj.Name] = {}
		self.List[BossObj.Name][BossID] = BossObj
	end
end

KBM.SubBoss = {}
KBM.SubBossID = {}
KBM.BossID = {}
KBM.BossLocation = {}
KBM.Encounter = false
KBM.HeaderList = {}
KBM.CurrentBoss = ""
KBM.CurrentMod = nil
local KBM_TestIsCasting = false
local KBM_TestAbility = nil

KBM.HeldTime = Inspect.Time.Real()
KBM.StartTime = 0
KBM.EnrageTime = 0
KBM.EnrageTimer = 0
KBM.TimeElapsed = 0
KBM.UpdateTime = 0
KBM.LastAction = 0
KBM.CastBar = {}
KBM.CastBar.List = {}

-- Addon Primary Context
KBM.Context = UI.CreateContext("KBM_Context")
KBM.Context:SetMouseMasking("limited")
local KM_Name = "King Boss Mods"

-- Addon KBM Primary Frames
KBM.MainWin = {
	Handle = {},
	Border = {},
	Content = {},
}

KBM.TimeVisual = {}
KBM.TimeVisual.String = "00"
KBM.TimeVisual.Seconds = 0
KBM.TimeVisual.Minutes = 0
KBM.TimeVisual.Hours = 0

KBM.FrameStore = {}
KBM.FrameQueue = {}
KBM.CheckStore = {}
KBM.CheckQueue = {}
KBM.SlideStore = {}
KBM.SlideQueue = {}
KBM.TextfStore = {}
KBM.TextfQueue = {}
KBM.TotalTexts = 0
KBM.TotalChecks = 0
KBM.TotalFrames = 0
KBM.TotalSliders = 0

KBM.MechTimer = {}
KBM.MechTimer.testTimerList = {}

KBM.TankSwap = {}
KBM.TankSwap.Triggers = {}

KBM.EncTimer = {}
KBM.Button = {}
KBM.PhaseMonitor = {}
KBM.Trigger = {}
KBM.Alert = {}
KBM.MechSpy = {}
KBM.Chat = {}

function KBM.Numbers.GetPlace(Number)
	local Check = 0
	local Last = 0
	if Number < 4 or Number > 20 then
		Last = tonumber(string.sub(tostring(Number), -1))
		if Last > 0 and Last < 4 then
			Check = Last
		end
	end
	return Number..KBM.Numbers.Place[Check]
end

-- Main Color Library.
-- Colors will remain preset based to avoid ugly videos :)
KBM.Colors = {
	Count = 6,
	List = {
		red = {
			Name = KBM.Language.Color.Red[KBM.Lang],
			Red = 1,
			Green = 0,
			Blue = 0,
		},
		dark_green = {
			Name = KBM.Language.Color.Dark_Green[KBM.Lang],
			Red = 0,
			Green = 0.6,
			Blue = 0,
		},
		orange = {
			Name = KBM.Language.Color.Orange[KBM.Lang],
			Red = 1,
			Green = 0.5,
			Blue = 0,
		},
		blue = {
			Name = KBM.Language.Color.Blue[KBM.Lang],
			Red = 0,
			Green = 0,
			Blue = 1,
		},
		cyan = {
			Name = KBM.Language.Color.Cyan[KBM.Lang],
			Red = 0,
			Green = 1,
			Blue = 1,
		},
		yellow = {
			Name = KBM.Language.Color.Yellow[KBM.Lang],
			Red = 1,
			Green = 1,
			Blue = 0,
		},
		purple = {
			Name = KBM.Language.Color.Purple[KBM.Lang],
			Red = 0.85,
			Green = 0,
			Blue = 0.65,
		},
	}
}
function KBM.MechTimer:ApplySettings()
	self.Anchor:ClearAll()
	if self.Settings.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
	else
		self.Anchor:SetPoint("BOTTOMRIGHT", UIParent, 0.9, 0.5)
	end
	self.Anchor:SetWidth(self.Settings.w * self.Settings.wScale)
	self.Anchor:SetHeight(self.Settings.h * self.Settings.hScale)
	self.Anchor.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
	if KBM.MainWin:GetVisible() then
		self.Anchor:SetVisible(self.Settings.Visible)
		self.Anchor.Drag:SetVisible(self.Settings.Unlocked)
	else
		self.Anchor:SetVisible(false)
		self.Anchor.Drag:SetVisible(false)
	end	
end

function KBM.MechTimer:Init()
	self.TimerList = {}
	self.ActiveTimers = {}
	self.RemoveTimers = {}
	self.RemoveCount = 0
	self.StartTimers = {}
	self.StartCount = 0
	self.LastTimer = nil
	self.Store = {}
	self.Cached = 0
	self.TempGUI = {}
	self.Settings = KBM.Options.MechTimer
	self.Anchor = UI.CreateFrame("Frame", "Timer Anchor", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
		
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.MechTimer.Settings.x = self:GetLeft()
			KBM.MechTimer.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Text = UI.CreateFrame("Text", "Timer Info", self.Anchor)
	self.Anchor.Text:SetText(" 0.0 "..KBM.Language.Anchors.Timers[KBM.Lang])
	self.Anchor.Text:SetPoint("CENTERLEFT", self.Anchor, "CENTERLEFT")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Anchor_Drag", 5)
	
	function self.Anchor.Drag.Event:WheelForward()
		if KBM.MechTimer.Settings.ScaleWidth then
			if KBM.MechTimer.Settings.wScale < 1.5 then
				KBM.MechTimer.Settings.wScale = KBM.MechTimer.Settings.wScale + 0.025
				if KBM.MechTimer.Settings.wScale > 1.5 then
					KBM.MechTimer.Settings.wScale = 1.5
				end
				KBM.MechTimer.Anchor:SetWidth(KBM.MechTimer.Settings.wScale * KBM.MechTimer.Settings.w)
			end
		end
		
		if KBM.MechTimer.Settings.ScaleHeight then
			if KBM.MechTimer.Settings.hScale < 1.5 then
				KBM.MechTimer.Settings.hScale = KBM.MechTimer.Settings.hScale + 0.025
				if KBM.MechTimer.Settings.hScale > 1.5 then
					KBM.MechTimer.Settings.hScale = 1.5
				end
				KBM.MechTimer.Anchor:SetHeight(KBM.MechTimer.Settings.hScale * KBM.MechTimer.Settings.h)
				if #KBM.MechTimer.ActiveTimers > 0 then
					for _, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
						Timer.GUI.Background:SetHeight(KBM.MechTimer.Anchor:GetHeight())
					end
				end
			end
		end
		
		if KBM.MechTimer.Settings.TextScale then
			if KBM.MechTimer.Settings.tScale < 1.5 then
				KBM.MechTimer.Settings.tScale = KBM.MechTimer.Settings.tScale + 0.025
				if KBM.MechTimer.Settings.tScale > 1.5 then
					KBM.MechTimer.Settings.tScale = 1.5
				end
				KBM.MechTimer.Anchor.Text:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
				if #KBM.MechTimer.ActiveTimers > 0 then
					for _, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
						Timer.GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
						Timer.GUI.Shadow:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
					end
				end
			end
		end
	end
	
	function self.Anchor.Drag.Event:WheelBack()		
		if KBM.MechTimer.Settings.ScaleWidth then
			if KBM.MechTimer.Settings.wScale > 0.5 then
				KBM.MechTimer.Settings.wScale = KBM.MechTimer.Settings.wScale - 0.025
				if KBM.MechTimer.Settings.wScale < 0.5 then
					KBM.MechTimer.Settings.wScale = 0.5
				end
				KBM.MechTimer.Anchor:SetWidth(KBM.MechTimer.Settings.wScale * KBM.MechTimer.Settings.w)
			end
		end
		
		if KBM.MechTimer.Settings.ScaleHeight then
			if KBM.MechTimer.Settings.hScale > 0.5 then
				KBM.MechTimer.Settings.hScale = KBM.MechTimer.Settings.hScale - 0.025
				if KBM.MechTimer.Settings.hScale < 0.5 then
					KBM.MechTimer.Settings.hScale = 0.5
				end
				KBM.MechTimer.Anchor:SetHeight(KBM.MechTimer.Settings.hScale * KBM.MechTimer.Settings.h)
				if #KBM.MechTimer.ActiveTimers > 0 then
					for _, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
						Timer.GUI.Background:SetHeight(KBM.MechTimer.Anchor:GetHeight())
					end
				end
			end
		end
		
		if KBM.MechTimer.Settings.TextScale then
			if KBM.MechTimer.Settings.tScale > 0.5 then
				KBM.MechTimer.Settings.tScale = KBM.MechTimer.Settings.tScale - 0.025
				if KBM.MechTimer.Settings.tScale < 0.5 then
					KBM.MechTimer.Settings.tScale = 0.5
				end
				KBM.MechTimer.Anchor.Text:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
				if #KBM.MechTimer.ActiveTimers > 0 then
					for _, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
						Timer.GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
						Timer.GUI.Shadow:SetFontSize(KBM.MechTimer.Settings.tScale * KBM.MechTimer.Settings.TextSize)
					end
				end				
			end
		end
	end
	self:ApplySettings()
end

function KBM.MechTimer:Pull()
	local GUI = {}
	if #self.Store > 0 then
		GUI = table.remove(self.Store)
	else
		GUI.Background = UI.CreateFrame("Frame", "Timer_Frame", KBM.Context)
		GUI.Background:SetPoint("LEFT", KBM.MechTimer.Anchor, "LEFT")
		GUI.Background:SetPoint("RIGHT", KBM.MechTimer.Anchor, "RIGHT")
		GUI.Background:SetHeight(KBM.MechTimer.Anchor:GetHeight())
		GUI.Background:SetBackgroundColor(0,0,0,0.33)
		GUI.Background:SetMouseMasking("limited")
		GUI.TimeBar = UI.CreateFrame("Frame", "Timer_Progress_Frame", GUI.Background)
		--KBM.LoadTexture(GUI.TimeBar, "KingMolinator", "Media/BarTexture2.png")
		GUI.TimeBar:SetWidth(KBM.MechTimer.Anchor:GetWidth())
		GUI.TimeBar:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.TimeBar:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.TimeBar:SetLayer(1)
		GUI.TimeBar:SetBackgroundColor(0,0,1,0.33)
		GUI.TimeBar:SetMouseMasking("limited")
		GUI.CastInfo = UI.CreateFrame("Text", "Timer_Text_Frame", GUI.Background)
		GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
		GUI.CastInfo:SetPoint("CENTERLEFT", GUI.Background, "CENTERLEFT")
		GUI.CastInfo:SetLayer(3)
		GUI.CastInfo:SetFontColor(1,1,1)
		GUI.CastInfo:SetMouseMasking("limited")
		GUI.Shadow = UI.CreateFrame("Text", "Timer_Text_Shadow", GUI.Background)
		GUI.Shadow:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
		GUI.Shadow:SetPoint("CENTER", GUI.CastInfo, "CENTER", 2, 2)
		GUI.Shadow:SetLayer(2)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetMouseMasking("limited")
		GUI.Texture = UI.CreateFrame("Texture", "Timer_Skin", GUI.Background)
		KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/BarSkin.png")
		GUI.Texture:SetAlpha(KBM.MechTimer.Settings.TextureAlpha)
		GUI.Texture:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Background, "BOTTOMRIGHT")
		GUI.Texture:SetLayer(4)
		GUI.Texture:SetMouseMasking("limited")
	end
	return GUI
end

function KBM.MechTimer:Add(Name, Duration, Repeat)
	local Timer = {}
	Timer.Active = false
	Timer.Alerts = {}
	Timer.Timers = {}
	Timer.Triggers = {}
	Timer.TimeStart = nil
	Timer.Removing = false
	Timer.Starting = false
	if not Duration then
		Timer.Time = 2
		Timer.Dynamic = true
	else
		Timer.Time = Duration
		Timer.Dynamic = false
	end
	Timer.Delay = iStart
	Timer.Enabled = true
	Timer.Repeat = Repeat
	Timer.Name = Name
	Timer.Phase = 0
	Timer.PhaseMax = 0
	Timer.Type = "timer"
	Timer.Custom = false
	Timer.Color = KBM.MechTimer.Settings.Color
	Timer.HasMenu = true
	if type(Name) ~= "string" then
		error("Expecting String for Name, got "..type(Name))
	end
	
	function self:AddRemove(Object)
		if not Object.Removing then
			if Object.Active then
				Object.Removing = true
				table.insert(self.RemoveTimers, Object)
				self.RemoveCount = self.RemoveCount + 1
			end
		end
	end
	
	function self:AddStart(Object, Duration)
		if not Object.Starting then
			if Object.Enabled then
				self.Queued = false
				Object.Starting = true
				if Object.Dynamic then
					Object.Time = Duration
				end
				self.StartCount = self.StartCount + 1
				table.insert(self.StartTimers, Object)
				self:AddRemove(Object)
			end
		end
	end
	
	function Timer:Start(CurrentTime, DebugInfo)	
		if self.Enabled then
			if self.Phase > 0 then
				if KBM.CurrentMod then
					if self.Phase < KBM.CurrentMod.Phase then
						return
					end
				end
			end
			if self.Active then
				KBM.MechTimer:AddStart(self)
				return
			end
			local Anchor = KBM.MechTimer.Anchor
			self.GUI = KBM.MechTimer:Pull()
			self.GUI.Background:SetHeight(KBM.MechTimer.Anchor:GetHeight())
			self.GUI.CastInfo:SetFontSize(KBM.MechTimer.Settings.TextSize * KBM.MechTimer.Settings.tScale)
			self.GUI.Shadow:SetFontSize(self.GUI.CastInfo:GetFontSize())
			self.TimeStart = CurrentTime
			self.Remaining = self.Time
			self.GUI.CastInfo:SetText(string.format(" %0.01f : ", self.Remaining)..self.Name)
			
			if KBM.MechTimer.Settings.Shadow then
				self.GUI.Shadow:SetText(self.GUI.CastInfo:GetText())
				self.GUI.Shadow:SetVisible(true)
			else
				self.GUI.Shadow:SetVisible(false)
			end
			
			if KBM.MechTimer.Settings.Texture then
				self.GUI.Texture:SetVisible(true)
			else
				self.GUI.Texture:SetVisible(false)
			end
			
			if self.Delay then
				self.Time = Delay
			end
			
			if self.Settings then
				if self.Settings.Custom then
					self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
				else
					self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Color].Red, KBM.Colors.List[self.Color].Green, KBM.Colors.List[self.Color].Blue, 0.33)
				end
			else
				self.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[KBM.MechTimer.Settings.Color].Red, KBM.Colors.List[KBM.MechTimer.Settings.Color].Green, KBM.Colors.List[KBM.MechTimer.Settings.Color].Blue, 0.33)
			end
			
			if #KBM.MechTimer.ActiveTimers > 0 then
				for i, cTimer in ipairs(KBM.MechTimer.ActiveTimers) do
					if self.Remaining < cTimer.Remaining then
						self.Active = true
						if i == 1 then
							self.GUI.Background:SetPoint("TOPLEFT", Anchor, "TOPLEFT")
							cTimer.GUI.Background:SetPoint("TOPLEFT", self.GUI.Background, "BOTTOMLEFT", 0, 1)
						else
							self.GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.ActiveTimers[i-1].GUI.Background, "BOTTOMLEFT", 0, 1)
							cTimer.GUI.Background:SetPoint("TOPLEFT", self.GUI.Background, "BOTTOMLEFT", 0, 1)
						end
						table.insert(KBM.MechTimer.ActiveTimers, i, self)
						break
					end
				end
				if not self.Active then
					self.GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.LastTimer.GUI.Background, "BOTTOMLEFT", 0, 1)
					table.insert(KBM.MechTimer.ActiveTimers, self)
					KBM.MechTimer.LastTimer = self
					self.Active = true
				end
			else
				self.GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.Anchor, "TOPLEFT")
				table.insert(KBM.MechTimer.ActiveTimers, self)
				self.Active = true
				KBM.MechTimer.LastTimer = self
				if KBM.MechTimer.Settings.Visible then
					KBM.MechTimer.Anchor.Text:SetVisible(false)
				end
			end
			self.GUI.Background:SetVisible(true)
			self.Starting = false
		end		
	end
	
	function Timer:Queue(Duration)
		if self.Enabled then
			KBM.MechTimer:AddStart(self, Duration)
		end
	end
	
	function Timer:Stop()
		if not self.Deleting then
			self.Deleting = true
			for i, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
				if Timer == self then
					if #KBM.MechTimer.ActiveTimers == 1 then
						KBM.MechTimer.LastTimer = nil
						if KBM.MechTimer.Settings.Visible then
							KBM.MechTimer.Anchor.Text:SetVisible(true)
						end
					elseif i == 1 then
						KBM.MechTimer.ActiveTimers[i+1].GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.Anchor, "TOPLEFT")
					elseif i == #KBM.MechTimer.ActiveTimers then
						KBM.MechTimer.LastTimer = KBM.MechTimer.ActiveTimers[i-1]
					else
						KBM.MechTimer.ActiveTimers[i+1].GUI.Background:SetPoint("TOPLEFT", KBM.MechTimer.ActiveTimers[i-1].GUI.Background, "BOTTOMLEFT", 0, 1)
					end
					table.remove(KBM.MechTimer.ActiveTimers, i)
					break
				end
			end
			self.GUI.Background:SetVisible(false)
			self.GUI.Shadow:SetText("")
			table.insert(KBM.MechTimer.Store, self.GUI)
			self.Active = false
			self.Remaining = 0
			self.TimeStart = 0
			for i, AlertObj in pairs(self.Alerts) do
				self.Alerts[i].Triggered = false
			end
			for i, TimerObj in pairs(self.Timers) do
				self.Timers[i].Triggered = false
			end
			self.GUI = nil
			self.Removing = false
			self.Deleting = false
			if KBM.Encounter then
				if self.Repeat then
					if self.Phase >= KBM.CurrentMod.Phase or self.Phase == 0 then
						KBM.MechTimer:AddStart(self)
					end
				end
				if self.TimerAfter then
					for i, TimerObj in ipairs(self.TimerAfter) do
						if TimerObj.Phase >= KBM.CurrentMod.Phase or TimerObj.Phase == 0 then
							KBM.MechTimer:AddStart(TimerObj)
						end
					end
				end
				if self.AlertAfter then
					KBM.Alert:Start(self.AlertAfter, Inspect.Time.Real())
				end
			end
		end
	end
	
	function Timer:AddAlert(AlertObj, Time)
		if type(AlertObj) == "table" then
			if AlertObj.Type ~= "alert" then
				error("Expecting AlertObj got "..tostring(AlertObj.Type))
			else
				if Time == 0 then
					self.AlertAfter = AlertObj
				else
					self.Alerts[Time] = {}
					self.Alerts[Time].Triggered = false
					self.Alerts[Time].AlertObj = AlertObj
				end
			end
		else
			error("Expecting AlertObj got "..type(AlertObj))
		end
	end
	
	function Timer:AddTimer(TimerObj, Time)
		if type(TimerObj) == "table" then
			if TimerObj.Type ~= "timer" then
				error("Expecting TimerObj got "..tostring(TimerObj.Type))
			else
				if Time == 0 then
					if not self.TimerAfter then
						self.TimerAfter = {}
					end
					table.insert(self.TimerAfter, TimerObj)
				else
					self.Timers[Time] = {}
					self.Timers[Time].Triggered = false
					self.Timers[Time].TimerObj = TimerObj
				end
			end
		else
			error("Expecting TimerObj got "..type(TimerObj))
		end
	end
	
	function Timer:AddTrigger(TriggerObj, Time)
		self.Triggers[Time] = {}
		self.Triggers[Time].Triggered = false
		self.Triggers[Time].TriggerObj = TriggerObj
	end
	
	function Timer:SetPhase(Phase)
		self.Phase = Phase
	end
	
	function Timer:Update(CurrentTime)
		local text = ""
		if self.Active then
			if self.Waiting then
			
			else
				self.Remaining = self.Time - (CurrentTime - self.TimeStart)
				if self.Remaining < 10 then
					text = string.format(" %0.01f : ", self.Remaining)..self.Name
				elseif self.Remaining >= 60 then
					text = " "..KBM.ConvertTime(self.Remaining).." : "..self.Name
				else
					text = " "..math.floor(self.Remaining).." : "..self.Name
				end
				if text ~= self.GUI.CastInfo:GetText() then
					self.GUI.CastInfo:SetText(text)
					self.GUI.Shadow:SetText(text)
				end
				newWidth = math.floor(self.GUI.Background:GetWidth() * (self.Remaining/self.Time))
				if self.GUI.TimeBar:GetWidth() ~= newWidth then
					self.GUI.TimeBar:SetWidth(self.GUI.Background:GetWidth() * (self.Remaining/self.Time))
				end
				if self.Remaining <= 0 then
					self.Remaining = 0
					KBM.MechTimer:AddRemove(self)
				end
				if KBM.Encounter then
					TriggerTime = math.ceil(self.Remaining)
					if self.Timers[TriggerTime] then
						if not self.Timers[TriggerTime].Triggered then
							KBM.MechTimer:AddStart(self.Timers[TriggerTime].TimerObj)
							self.Timers[TriggerTime].Triggered = true
						end
					end
					if self.Alerts[TriggerTime] then
						if not self.Alerts[TriggerTime].Triggered then
							KBM.Alert:Start(self.Alerts[TriggerTime].AlertObj, CurrentTime)
							self.Alerts[TriggerTime].Triggered = true
						end
					end
				end
			end
		end
	end
	
	function Timer:NoMenu()
		self.HasMenu = false
		self.Enabled = true
	end
	
	function Timer:SetLink(Timer)
		if type(Timer) == "table" then
			if Timer.Type ~= "timer" then
				error("Supplied Object is not a Timer, got: "..tostring(Timer.Type))
			else
				self.Link = Timer
				self.Link:NoMenu()
				for SettingID, Value in pairs(self.Settings) do
					if SettingID ~= "ID" then
						self.Link.Settings[SettingID] = Value
					end
				end
			end
		else
			error("Expecting at least a table got: "..type(Timer))
		end
	end
	
	return Timer
	
end

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
	self.PersonalCast = {}
	self.Percent = {}
	self.Combat = {}
	self.Start = {}
	self.Death = {}
	self.Buff = {}
	self.PlayerBuff = {}
	self.PlayerDebuff = {}
	self.PlayerIDBuff = {}
	self.BuffRemove = {}
	self.PlayerBuffRemove = {}
	self.PlayerIDBuffRemove = {}
	self.Time = {}
	self.Channel = {}
	self.Interrupt = {}
	self.PersonalInterrupt = {}
	self.NpcDamage = {}
	self.EncStart = {}
	self.Max = {
		Timers = {},
		Spies = {},
	}
	self.High = {
		Timers = 0,
		Spies = 0,
	}

	function self.Queue:Add(TriggerObj, Caster, Target, Duration)	
		if KBM.Encounter or KBM.Testing then
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
			if KBM.Encounter or KBM.Testing then
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
	
	function self:Create(Trigger, Type, Unit, Hook, EncStart)	
		TriggerObj = {}
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
			else
				for i, Timer in ipairs(self.Timers) do
					Timer:Queue(Data)
					Triggered = true
				end
			end
			for i, SpyObj in ipairs(self.Spies) do
				for UID, bool in pairs(self.Target) do
					if KBM.Unit.List.UID[UID] then
						SpyObj:Start(KBM.Unit.List.UID[UID].Name, Data)
					end
				end
			end
			for i, AlertObj in ipairs(self.Alerts) do
				if AlertObj.Player then
					if self.Target[KBM.Player.UnitID] then
						KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
						Triggered = true
					end
				else
					KBM.Alert:Start(AlertObj, Inspect.Time.Real(), Data)
					Triggered = true
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
					for UID, bool in pairs(self.Target) do
						if KBM.Unit.List.UID[UID] then
							Obj:Stop(KBM.Unit.List.UID[UID].Name)
						end
					end
				end
			end
			if KBM.Encounter then
				if self.Phase then
					self.Phase(self.Type)
					Triggered = true
				end
			end
			if Triggered then
				self.LastTrigger = current
				self.Target = {}
			end
		end
		
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
			if not self.Cast[Trigger] then
				self.Cast[Trigger] = {}
			end
			self.Cast[Trigger][Unit.Name] = TriggerObj
		elseif Type == "personalCast" then
			if not self.PersonalCast[Trigger] then
				self.PersonalCast[Trigger] = {}
			end
			self.PersonalCast[Trigger][Unit.Name] = TriggerObj
		elseif Type == "channel" then
			if not self.Channel[Trigger] then
				self.Channel[Trigger] = {}
			end
			self.Channel[Trigger][Unit.Name] = TriggerObj
		elseif Type == "interrupt" then
			if not self.Interrupt[Trigger] then
				self.Interrupt[Trigger] = {}
			end
			self.Interrupt[Trigger][Unit.Name] = TriggerObj
		elseif Type == "personalInterrupt" then
			if not self.PersonalInterrupt[Trigger] then
				self.PersonalInterrupt[Trigger] = {}
			end
			self.PersonalInterrupt[Trigger][Unit.Name] = TriggerObj
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
			self.Death[Trigger] = TriggerObj
		elseif Type == "buff" then
			if not self.Buff[Unit.Mod.ID] then
				self.Buff[Unit.Mod.ID] = {}
			end
			self.Buff[Unit.Mod.ID][Trigger] = TriggerObj
		elseif Type == "buffRemove" then
			if not self.BuffRemove[Unit.Mod.ID] then
				self.BuffRemove[Unit.Mod.ID] = {}
			end
			self.BuffRemove[Unit.Mod.ID][Trigger] = TriggerObj
		elseif Type == "playerBuff" then
			if not self.PlayerBuff[Unit.Mod.ID] then
				self.PlayerBuff[Unit.Mod.ID] = {}
			end
			self.PlayerBuff[Unit.Mod.ID][Trigger] = TriggerObj
		elseif Type == "playerBuffRemove" then
			if not self.PlayerBuffRemove[Unit.Mod.ID] then
				self.PlayerBuffRemove[Unit.Mod.ID] = {}
			end
			self.PlayerBuffRemove[Unit.Mod.ID][Trigger] = TriggerObj
		elseif Type == "playerDebuff" then
			if not self.PlayerDebuff[Unit.Mod.ID] then
				self.PlayerDebuff[Unit.Mod.ID] = {}
			end
			self.PlayerDebuff[Unit.Mod.ID][Trigger] = TriggerObj
		elseif Type == "playerIDBuff" then
			if not self.PlayerIDBuff[Unit.Mod.ID] then
				self.PlayerIDBuff[Unit.Mod.ID] = {}
			end
			self.PlayerIDBuff[Unit.Mod.ID][Trigger] = TriggerObj
		elseif Type == "playerIDBuffRemove" then
			if not self.PlayerDebuff[Unit.Mod.ID] then
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
		
		if EncStart then
			if not self.EncStart[Type] then
				self.EncStart[Type] = {}
			end
			self.EncStart[Type][Trigger] = Unit.Mod
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

local function KBM_Options()
	if KBM.MainWin:GetVisible() then
		KBM.MainWin.Options:Close()
	else
		KBM.MainWin.Options:Open()
	end	
end

function KBM.Button:Init()
	KBM.Button.Texture = UI.CreateFrame("Texture", "Button Texture", KBM.Context)
	KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/Options_Button.png")
	
	function self:ApplySettings()
		self.Texture:ClearPoint("CENTER")
		self.Texture:ClearPoint("TOPLEFT")
		if not KBM.Options.Button.x then
			self.Texture:SetPoint("CENTER", UIParent, "CENTER")
		else
			self.Texture:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.Button.x, KBM.Options.Button.y)
		end
		self.Texture:SetLayer(5)
		self.Drag:SetVisible(KBM.Options.Button.Unlocked)
		self.Texture:SetVisible(KBM.Options.Button.Visible)
	end
	
	function self:UpdateMove(uType)
		if uType == "end" then
			KBM.Options.Button.x = self.Texture:GetLeft()
			KBM.Options.Button.y = self.Texture:GetTop()
		end	
	end
	function self.Texture.Event.MouseIn()
		KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/Options_Button_Over.png")
	end
	function self.Texture.Event.MouseOut()
		KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/Options_Button.png")
	end
	function self.Texture.Event.LeftDown()
		KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/Options_Button_Down.png")
	end
	function self.Texture.Event.LeftUp()
		KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/Options_Button_Over.png")
	end
	function self.Texture.Event.LeftClick()
		KBM_Options()
	end
			
	self.Drag = KBM.AttachDragFrame(self.Texture, function (uType) self:UpdateMove(uType) end, "Button Drag", 6)
	self.Drag.Event.RightDown = self.Drag.Event.LeftDown
	self.Drag.Event.RightUp = self.Drag.Event.LeftUp
	self.Drag.Event.LeftDown = nil
	self.Drag.Event.LeftUp = nil
	self.Drag.Event.MouseIn = self.Texture.Event.MouseIn
	self.Drag.Event.MouseOut = self.Texture.Event.MouseOut
	self.Drag:SetMouseMasking("limited")
	
	self:ApplySettings()
	
end

function KBM.Chat:Init()
	self.Enabled = true
end

function KBM.Chat:Create(Text)
	local ChatObj = {}
	ChatObj.Text = Text
	ChatObj.Enabled = true
	ChatObj.Color = "yellow"
	ChatObj.HasMenu = true
	ChatObj.Custom = false
	function self:Display(ChatObj)
		if ChatObj.Enabled then
			print(tostring(ChatObj.Text))
		end
	end
	return ChatObj
end

function KBM.MechSpy:Pull()
	local GUI = {}
	if #self.Store > 0 then
		GUI = table.remove(self.Store)
	else
		GUI.Background = UI.CreateFrame("Frame", "Spy_Frame", KBM.Context)
		GUI.Background:SetHeight(self.Anchor:GetHeight())
		GUI.Background:SetPoint("LEFT", self.Anchor, "LEFT")
		GUI.Background:SetPoint("RIGHT", self.Anchor, "RIGHT")
		GUI.Background:SetBackgroundColor(0,0,0,0.33)
		GUI.Background:SetMouseMasking("limited")
		GUI.TimeBar = UI.CreateFrame("Frame", "Spy_Progress_Frame", GUI.Background)
		GUI.TimeBar:SetWidth(self.Anchor:GetWidth())
		GUI.TimeBar:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.TimeBar:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.TimeBar:SetLayer(1)
		GUI.TimeBar:SetBackgroundColor(0,0,1,0.33)
		GUI.TimeBar:SetMouseMasking("limited")
		GUI.Shadow = UI.CreateFrame("Text", "Spy_Text_Shadow", GUI.Background)
		GUI.Shadow:SetFontSize(self.Anchor.Text:GetFontSize())
		GUI.Shadow:SetPoint("CENTERLEFT", GUI.Background, "CENTERLEFT", 2, 2)
		GUI.Shadow:SetLayer(2)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetMouseMasking("limited")
		GUI.Text = UI.CreateFrame("Text", "Spy_Text_Frame", GUI.Shadow)
		GUI.Text:SetFontSize(self.Anchor.Text:GetFontSize())
		GUI.Text:SetPoint("TOPLEFT", GUI.Shadow, "TOPLEFT", -1, -1)
		GUI.Text:SetLayer(3)
		GUI.Text:SetFontColor(1,1,1)
		GUI.Text:SetMouseMasking("limited")
		GUI.Texture = UI.CreateFrame("Texture", "Spy_Skin", GUI.Background)
		KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/BarSkin.png")
		GUI.Texture:SetAlpha(KBM.Constant.MechSpy.TextureAlpha)
		GUI.Texture:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Background, "BOTTOMRIGHT")
		GUI.Texture:SetLayer(4)
		GUI.Texture:SetMouseMasking("limited")
		function GUI:SetText(Text)
			self.Text:SetText(Text)
			self.Shadow:SetText(Text)
		end
	end
	return GUI
end

function KBM.MechSpy:PullHeader()
	local GUI = {}
	if #self.HeaderStore > 0 then
		GUI = table.remove(self.HeaderStore)
	else
		GUI.Background = UI.CreateFrame("Frame", "Spy_Frame", KBM.Context)
		GUI.Background:SetPoint("LEFT", self.Anchor, "LEFT")
		GUI.Background:SetPoint("RIGHT", self.Anchor, "RIGHT")
		GUI.Background:SetHeight(self.Anchor:GetHeight())
		GUI.Background:SetBackgroundColor(0,0,0,0.33)
		GUI.Background:SetMouseMasking("limited")
		GUI.Background:SetLayer(6)
		GUI.Cradle = UI.CreateFrame("Frame", "Spy_Cradle", GUI.Background)
		GUI.Cradle:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Cradle:SetPoint("RIGHT", GUI.Background, "RIGHT")
		GUI.Cradle:SetPoint("BOTTOM", GUI.Background, "BOTTOM")
		GUI.Texture = UI.CreateFrame("Texture", "MechSpy_Header_Texture", GUI.Background)
		KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/MSpy_Texture.png")
		GUI.Texture:SetPoint("TOPLEFT", GUI.Background, "TOPLEFT")
		GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Background, "BOTTOMRIGHT")
		GUI.Texture:SetLayer(1)
		GUI.Shadow = UI.CreateFrame("Text", "Mechanic_Spy_Header_Shadow", GUI.Background)
		GUI.Shadow:SetText("")
		GUI.Shadow:SetPoint("CENTERRIGHT", GUI.Background, "CENTERRIGHT", -1, 1)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetLayer(2)
		GUI.Text = UI.CreateFrame("Text", "Mechanic_Spy_Header_Text", GUI.Shadow)
		GUI.Text:SetText("")
		GUI.Text:SetPoint("TOPRIGHT", GUI.Shadow, "TOPRIGHT", -1, -1)
		GUI.Text:SetLayer(3)
		function GUI:SetText(Text)
			self.Text:SetText(Text)
			self.Shadow:SetText(Text)
		end
		function GUI:SetColor(R, G, B, A)
			GUI.Texture:SetBackgroundColor(R, G, B, A)		
		end
	end
	return GUI
end

function KBM.MechSpy:ApplySettings()
	self.Anchor:ClearAll()
	if self.Settings.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
	else
		self.Anchor:SetPoint("BOTTOMRIGHT", UIParent, 0.9, 0.5)
	end
	self.Anchor:SetWidth(math.floor(KBM.Constant.MechSpy.w * self.Settings.wScale))
	self.Anchor:SetHeight(math.floor(KBM.Constant.MechSpy.h * self.Settings.hScale))
	self.Anchor.Text:SetFontSize(math.floor(KBM.Constant.MechSpy.TextSize * self.Settings.tScale))
	self.Anchor.Shadow:SetFontSize(self.Anchor.Text:GetFontSize())
	if KBM.MainWin:GetVisible() then
		self.Anchor:SetVisible(self.Settings.Visible)
		self.Anchor.Drag:SetVisible(self.Settings.Visible)
	else
		self.Anchor:SetVisible(false)
		self.Anchor.Drag:SetVisible(false)
	end
end

function KBM.MechSpy:Init()
	self.List = {
		Mod = {},
		Active = {},
	}
	self.Active = false
	self.Last = nil
	self.StopTimers = {}
	self.Store = {}
	self.HeaderStore = {}
	self.Settings = KBM.Options.MechSpy
	self.Anchor = UI.CreateFrame("Frame", "MechSpy_Anchor", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	self.Texture = UI.CreateFrame("Texture", "MechSpy_Anchor_Texture", self.Anchor)
	KBM.LoadTexture(self.Texture, "KingMolinator", "Media/MSpy_Texture.png")
	self.Texture:SetPoint("TOPLEFT", self.Anchor, "TOPLEFT")
	self.Texture:SetPoint("BOTTOMRIGHT", self.Anchor, "BOTTOMRIGHT")
	self.Texture:SetLayer(1)
	self.Texture:SetBackgroundColor(1,0,0,0.33)
	
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.MechSpy.Settings.x = self:GetLeft()
			KBM.MechSpy.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Shadow = UI.CreateFrame("Text", "Mechanic_Spy_Anchor_Shadow", self.Anchor)
	self.Anchor.Shadow:SetText(KBM.Language.Anchors.MechSpy[KBM.Lang])
	self.Anchor.Shadow:SetPoint("CENTERRIGHT", self.Anchor, "CENTERRIGHT", -1, 1)
	self.Anchor.Shadow:SetFontColor(0,0,0)
	self.Anchor.Shadow:SetLayer(2)
	self.Anchor.Text = UI.CreateFrame("Text", "Mechanic_Spy_Anchor_Text", self.Anchor.Shadow)
	self.Anchor.Text:SetText(KBM.Language.Anchors.MechSpy[KBM.Lang])
	self.Anchor.Text:SetPoint("TOPRIGHT", self.Anchor.Shadow, "TOPRIGHT", -1, -1)
	self.Anchor.Text:SetLayer(3)
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Anchor_Drag", 5)
	
	function self.Anchor.Drag.Event:WheelForward()
		if KBM.MechSpy.Settings.ScaleWidth then
			if KBM.MechSpy.Settings.wScale < 1.5 then
				KBM.MechSpy.Settings.wScale = KBM.MechSpy.Settings.wScale + 0.025
				if KBM.MechSpy.Settings.wScale > 1.5 then
					KBM.MechSpy.Settings.wScale = 1.5
				end
				KBM.MechSpy.Anchor:SetWidth(math.floor(KBM.MechSpy.Settings.wScale * KBM.Constant.MechSpy.w))
			end
		end
		
		if KBM.MechSpy.Settings.ScaleHeight then
			if KBM.MechSpy.Settings.hScale < 1.5 then
				KBM.MechSpy.Settings.hScale = KBM.MechSpy.Settings.hScale + 0.025
				if KBM.MechSpy.Settings.hScale > 1.5 then
					KBM.MechSpy.Settings.hScale = 1.5
				end
				KBM.MechSpy.Anchor:SetHeight(math.floor(KBM.MechSpy.Settings.hScale * KBM.Constant.MechSpy.h))
				if #KBM.MechSpy.List.Active > 0 then
					for _, Mechanic in ipairs(KBM.MechSpy.List.Active) do
						Mechanic.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
						if #Mechanic.Active > 0 then
							for _, Timer in ipairs(Mechanic.Active) do
								Timer.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
							end
						end
					end
				end
			end
		end
		
		if KBM.MechSpy.Settings.ScaleText then
			if KBM.MechSpy.Settings.tScale < 1.5 then
				KBM.MechSpy.Settings.tScale = KBM.MechSpy.Settings.tScale + 0.025
				if KBM.MechSpy.Settings.tScale > 1.5 then
					KBM.MechSpy.Settings.tScale = 1.5
				end
				KBM.MechSpy.Anchor.Text:SetFontSize(math.floor(KBM.Constant.MechSpy.TextSize * KBM.MechSpy.Settings.tScale))
				KBM.MechSpy.Anchor.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
				if #KBM.MechSpy.List.Active > 0 then
					for _, Mechanic in ipairs(KBM.MechSpy.List.Active) do
						Mechanic.GUI.CastInfo:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
						Mechanic.GUI.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
						if #Mechanic.Active > 0 then
							for _, Timer in ipairs(Mechanic.Active) do
								Timer.GUI.CastInfo:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
								Timer.GUI.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
							end
						end
					end
				end
			end
		end
	end
	
	function self.Anchor.Drag.Event:WheelBack()		
		if KBM.MechSpy.Settings.ScaleWidth then
			if KBM.MechSpy.Settings.wScale > 0.5 then
				KBM.MechSpy.Settings.wScale = KBM.MechSpy.Settings.wScale - 0.025
				if KBM.MechSpy.Settings.wScale < 0.5 then
					KBM.MechSpy.Settings.wScale = 0.5
				end
				KBM.MechSpy.Anchor:SetWidth(math.floor(KBM.MechSpy.Settings.wScale * KBM.Constant.MechSpy.w))
			end
		end
		
		if KBM.MechSpy.Settings.ScaleHeight then
			if KBM.MechSpy.Settings.hScale > 0.5 then
				KBM.MechSpy.Settings.hScale = KBM.MechSpy.Settings.hScale - 0.025
				if KBM.MechSpy.Settings.hScale < 0.5 then
					KBM.MechSpy.Settings.hScale = 0.5
				end
				KBM.MechSpy.Anchor:SetHeight(math.floor(KBM.MechSpy.Settings.hScale * KBM.Constant.MechSpy.h))
				if #KBM.MechSpy.List.Active > 0 then
					for _, Mechanic in ipairs(KBM.MechSpy.List.Active) do
						Mechanic.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
						if #Mechanic.Active > 0 then
							for _, Timer in ipairs(Mechanic.Active) do
								Timer.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
							end
						end
					end
				end
			end
		end
		
		if KBM.MechSpy.Settings.ScaleText then
			if KBM.MechSpy.Settings.tScale > 0.5 then
				KBM.MechSpy.Settings.tScale = KBM.MechSpy.Settings.tScale - 0.025
				if KBM.MechSpy.Settings.tScale < 0.5 then
					KBM.MechSpy.Settings.tScale = 0.5
				end
				KBM.MechSpy.Anchor.Text:SetFontSize(math.floor(KBM.MechSpy.Settings.tScale * KBM.Constant.MechSpy.TextSize))
				KBM.MechSpy.Anchor.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
				if #KBM.MechSpy.List.Active > 0 then
					for _, Mechanic in ipairs(KBM.MechSpy.List.Active) do
						Mechanic.GUI.CastInfo:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
						Mechanic.GUI.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
						if #Mechanic.Active > 0 then
							for _, Timer in ipairs(Mechanic.Active) do
								Timer.GUI.CastInfo:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
								Timer.GUI.Shadow:SetFontSize(KBM.MechSpy.Anchor.Text:GetFontSize())
							end
						end
					end
				end
			end
		end
	end
	self:ApplySettings()
	
	function self:Begin()
		if self.Settings.Enabled then
			self.Active = true
			for Name, BossObj in pairs(KBM.CurrentMod.Bosses) do
				if BossObj.MechRef then
					for ID, SpyObj in pairs(BossObj.MechRef) do
						SpyObj:Begin()
					end
				end
			end
		end
	end
	
	function self:Update(CurrentTime)
		if self.Active then
			for i, SpyObj in ipairs(self.List.Active) do
				for Name, TimerObj in pairs(SpyObj.Timers) do
					TimerObj:Update(CurrentTime)
				end
				for i, TimerObj in ipairs(SpyObj.StopTimers) do
					TimerObj:Stop()
				end
				SpyObj.StopTimers = {}
			end
		end
	end
	
	function self:End()
		self.Active = false
		for i, SpyObj in ipairs(self.List.Active) do
			SpyObj.StopTimers = {}
			SpyObj:End()
		end
		self.List.Active = {}
	end	
	
end

function KBM.MechSpy:Add(Name, Duration, Type, BossObj)

	local Mechanic = {}
	Mechanic.Active = false
	Mechanic.Visible = false
	Mechanic.Timers = {}
	Mechanic.StopTimers = {}
	Mechanic.Names = {}
	Mechanic.Removing = false
	Mechanic.Boss = BossObj
	Mechanic.Starting = false
	Mechanic.RemoveCount = 0
	Mechanic.StartCount = 0
	if not Duration then
		Mechanic.Time = 2
		Mechanic.Dynamic = true
		Mechanic.Duration = 2
	else
		Mechanic.Time = Duration
		Mechanic.Dynamic = false
		Mechanic.Duration = Duration
		if Duration == -1 then
			Mechanic.Static = true
		end
	end
	Mechanic.Enabled = true
	Mechanic.Name = Name
	Mechanic.Phase = 0
	Mechanic.PhaseMax = 0
	Mechanic.Type = "spy"
	Mechanic.Custom = false
	Mechanic.HasMenu = true
	Mechanic.Color = KBM.MechSpy.Settings.Color
	if type(Name) ~= "string" then
		error("Expecting String for Name, got "..type(Name))
	end
	
	function Mechanic:Show()
		if not self.Visible then
			if not KBM.MechSpy.FirstHeader then
				KBM.MechSpy.FirstHeader = self
				KBM.MechSpy.LastHeader = self
				self.HeaderBefore = nil
				self.HeaderAfter = nil
				self.GUI.Background:SetPoint("TOP", KBM.MechSpy.Anchor, "TOP")
			else
				self.HeaderBefore = KBM.MechSpy.LastHeader
				self.HeaderBefore.HeaderAfter = self
				self.HeaderAfter = nil
				KBM.MechSpy.LastHeader = self
				self.GUI.Background:SetPoint("TOP", self.HeaderBefore.GUI.Cradle, "BOTTOM")
			end
			self.Visible = true
		end
		self.GUI.Background:SetVisible(true)
	end
	
	function Mechanic:Hide()
		self.GUI.Background:SetVisible(false)
		if self.Visible then
			if KBM.MechSpy.FirstHeader == self then
				KBM.MechSpy.FirstHeader = self.HeaderAfter
				if self.HeaderAfter then
					self.HeaderAfter.HeaderBefore = nil
					self.HeaderAfter.GUI.Background:SetPoint("TOP", KBM.MechSpy.Anchor, "TOP")
				end
			elseif KBM.MechSpy.LastHeader == self then
				KBM.MechSpy.LastHeader = self.HeaderBefore
				if self.HeaderBefore then
					self.HeaderBefore.HeaderAfter = nil
				end
			else
				self.HeaderBefore.HeaderAfter = self.HeaderAfter
				self.HeaderAfter.HeaderBefore = self.HeaderBefore
				self.HeaderAfter.GUI.Background:SetPoint("TOP", self.HeaderBefore.GUI.Cradle, "BOTTOM")
			end
			self.HeaderBefore = nil
			self.HeaderAfter = nil
			self.GUI.Cradle:SetPoint("BOTTOM", self.GUI.Background, "BOTTOM")
			self.GUI.Background:SetPoint("TOP", KBM.MechSpy.Anchor, "TOP")
			self.Visible = false
		end
	end
	
	function Mechanic:Begin()
		if KBM.MechSpy.Settings.Enabled then
			self.Active = true
			self.Visible = false
			self.GUI = KBM.MechSpy:PullHeader()
			if self.Settings then
				if self.Settings.Custom then
					self.GUI:SetColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
				else
					self.GUI:SetColor(KBM.Colors.List[self.Color].Red, KBM.Colors.List[self.Color].Green, KBM.Colors.List[self.Color].Blue, 0.33)
				end
			else
				self.GUI:SetColor(KBM.Colors.List[KBM.MechSpy.Settings.Color].Red, KBM.Colors.List[KBM.MechSpy.Settings.Color].Green, KBM.Colors.List[KBM.MechSpy.Settings.Color].Blue, 0.33)
			end
			self.GUI:SetText(self.Name)
			table.insert(KBM.MechSpy.List.Active, self)
			if KBM.MechSpy.Settings.Show then
				self:Show()
			else
				self:Hide()
			end
		end
	end
	
	function Mechanic:End()
		self.Active = false
		for Name, Timer in pairs(self.Names) do
			Timer:Stop()
		end
		self.Timers = {}
		self:Hide()
		table.insert(KBM.MechSpy.HeaderStore, self.GUI)
		self.GUI = nil
	end
	
	function Mechanic:SpyAfter(SpyObj)
		if not self.SpyAfterList then
			self.SpyAfterList = {}
		end
		table.insert(self.SpyAfterList, SpyObj)
	end
	
	function Mechanic:Stop(Name)
		if Name then
			if self.Names[Name] then
				if KBM.Debug then
					print("Mechanic Spy stopping: "..Name)
				end
				self.Names[Name]:Stop()
			end
		end
	end
		
	function Mechanic:Start(Name, Duration)
		if KBM.Debug then
			print("Mechanic Spy Called")
		end
		if KBM.Encounter then
			if KBM.MechSpy.Settings.Enabled then
				if self.Enabled == true and type(Name) == "string" then
					if KBM.Debug then
						print("Mechanic Spy launching Timer: "..Name)
					end
					if self.Names[Name] then
						self.Names[Name]:Stop()
					end
					local CurrentTime = Inspect.Time.Real()
					local Anchor = self.GUI.Background
					if not self.Visible then
						self:Show()
					end
					Timer = {}
					Timer.Name = Name
					Timer.GUI = KBM.MechSpy:Pull()
					Timer.GUI.Background:SetHeight(KBM.MechSpy.Anchor:GetHeight())
					Timer.TimeStart = CurrentTime
					if self.Static then
						Duration = 0
						Timer.Time = 0
						Timer.Static = true
						Timer.GUI.TimeBar:SetWidth(math.ceil(Timer.GUI.Background:GetWidth()))
					else
						Timer.Static = false
						if not self.Dynamic then
							Duration = self.Duration
							Timer.Time = self.Time
						else
							if Duration == nil or Duration < 1 then
								Duration = self.Duration
							end
							Timer.Time = Duration
						end
					end
					Timer.Remaining = Duration
					Timer.GUI:SetText(string.format(" %0.01f : ", Timer.Remaining)..Timer.Name)
								
					if self.Settings then
						if self.Settings.Custom then
							Timer.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
						else
							Timer.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[self.Color].Red, KBM.Colors.List[self.Color].Green, KBM.Colors.List[self.Color].Blue, 0.33)
						end
					else
						Timer.GUI.TimeBar:SetBackgroundColor(KBM.Colors.List[KBM.MechSpy.Settings.Color].Red, KBM.Colors.List[KBM.MechSpy.Settings.Color].Green, KBM.Colors.List[KBM.MechSpy.Settings.Color].Blue, 0.33)
					end
					
					if #self.Timers > 0 then
						for i, cTimer in ipairs(self.Timers) do
							if Timer.Remaining < cTimer.Remaining then
								Timer.Active = true
								if i == 1 then
									Timer.GUI.Background:SetPoint("TOP", self.GUI.Background, "BOTTOM", nil, 1)
									cTimer.GUI.Background:SetPoint("TOP", Timer.GUI.Background, "BOTTOM", nil, 1)
									self.FirstTimer = Timer
								else
									Timer.GUI.Background:SetPoint("TOP", self.Timers[i-1].GUI.Background, "BOTTOM", nil, 1)
									cTimer.GUI.Background:SetPoint("TOP", Timer.GUI.Background, "BOTTOM", nil, 1)
								end
								table.insert(self.Timers, i, Timer)
								break
							end
						end
						if not Timer.Active then
							Timer.GUI.Background:SetPoint("TOP", self.LastTimer.GUI.Background, "BOTTOM", nil, 1)
							table.insert(self.Timers, Timer)
							self.LastTimer = Timer
							Timer.Active = true
						end
					else
						Timer.GUI.Background:SetPoint("TOP", self.GUI.Background, "BOTTOM", nil, 1)
						table.insert(self.Timers, Timer)
						Timer.Active = true
						self.LastTimer = Timer
						self.FirstTimer = Timer
					end
					self.Names[Name] = Timer
					Timer.GUI.Background:SetVisible(true)
					Timer.Starting = false
					Timer.Parent = self
					self.GUI.Cradle:SetPoint("BOTTOM", self.LastTimer.GUI.Background, "BOTTOM")
					function Timer:Stop()
						if not self.Deleting then
							if self.Active then
								self.Active = false
								self.Deleting = true
								self.GUI.Background:SetVisible(false)
								for i, Timer in ipairs(self.Parent.Timers) do
									if Timer == self then
										if #self.Parent.Timers == 1 then
											self.Parent.LastTimer = nil
											self.Parent.GUI.Cradle:SetPoint("BOTTOM", self.Parent.GUI.Background, "BOTTOM")
											if not KBM.MechSpy.Settings.Show then
												self.Parent:Hide()
											end
										elseif i == 1 then
											self.Parent.Timers[i+1].GUI.Background:SetPoint("TOP", self.Parent.GUI.Background, "BOTTOM", nil, 1)
										elseif i == #self.Parent.Timers then
											self.Parent.LastTimer = self.Parent.Timers[i-1]
											self.Parent.GUI.Cradle:SetPoint("BOTTOM", self.Parent.LastTimer.GUI.Background, "BOTTOM")
										else
											self.Parent.Timers[i+1].GUI.Background:SetPoint("TOP", self.Parent.Timers[i-1].GUI.Background, "BOTTOM", nil, 1)
										end
										table.remove(self.Parent.Timers, i)
										break
									end
								end
								table.insert(KBM.MechSpy.Store, self.GUI)
								self.Remaining = 0
								self.TimeStart = 0
								self.GUI = nil
								self.Removing = false
								self.Deleting = false
								self.Parent.Names[self.Name] = nil
								if KBM.Encounter then
									if self.Parent.SpyAfterList then
										for i, SpyObj in ipairs(self.Parent.SpyAfterList) do
											SpyObj:Start(self.Name)
										end
									end
								end
							end
						end
					end
					function Timer:Update(CurrentTime)
						local text = ""
						if self.Active then
							if self.Waiting then
							
							else
								if self.Static == false then
									self.Remaining = self.Time - (CurrentTime - self.TimeStart)
								else
									self.Remaining = CurrentTime - self.TimeStart
								end
								if self.Remaining < 10 then
									text = string.format(" %0.01f : ", self.Remaining)..self.Name
								elseif self.Remaining >= 60 then
									text = " "..KBM.ConvertTime(self.Remaining).." : "..self.Name
								else
									text = " "..math.floor(self.Remaining).." : "..self.Name
								end
								self.GUI:SetText(text)
								if self.Static == false then
									self.GUI.TimeBar:SetWidth(math.ceil(self.GUI.Background:GetWidth() * (self.Remaining/self.Time)))
									if self.Remaining <= 0 then
										self.Remaining = 0
										table.insert(self.Parent.StopTimers, self)
									end
								end
							end
						end
					end
					Timer:Update(Inspect.Time.Real())
				end
			end
		end		
	end
	
	function Mechanic:Queue(Duration)
		if KBM.MechSpy.Settings.Enabled then
			if self.Enabled then
				self:AddStart(self, Duration)
			end
		end
	end
	
	function Mechanic:NoMenu()
		self.Enabled = true
		self.NoMenu = true
		self.HasMenu = false
	end
			
	function Mechanic:SetPhase(Phase)
		self.Phase = Phase
	end
	
	if not self.List[BossObj.Mod] then
		self.List[BossObj.Mod] = {}
	end
	table.insert(self.List[BossObj.Mod], Mechanic)
	
	return Mechanic
end

function KBM.PhaseMonitor:PullObjective()
	local GUI  = {}
	if #self.ObjectiveStore > 0 then
		GUI = table.remove(self.ObjectiveStore)
	else
		GUI.Frame = UI.CreateFrame("Frame", "Objective_Base", KBM.Context)
		GUI.Frame:SetBackgroundColor(0,0,0,0.33)
		GUI.Frame:SetHeight(self.Anchor:GetHeight() * 0.5)
		GUI.Frame:SetPoint("LEFT", self.Anchor, "LEFT")
		GUI.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
		GUI.Progress = UI.CreateFrame("Texture", "Percentage_Progress", GUI.Frame)
		GUI.Progress:SetPoint("TOPRIGHT", GUI.Frame, "TOPRIGHT")
		GUI.Progress:SetPoint("BOTTOM", GUI.Frame, "BOTTOM")
		KBM.LoadTexture(GUI.Progress, "KingMolinator", "Media/BarTexture.png")
		GUI.Progress:SetWidth(GUI.Frame:GetWidth())
		GUI.Progress:SetBackgroundColor(0, 0.5, 0, 0.33)
		GUI.Progress:SetVisible(false)
		GUI.Progress:SetLayer(1)
		GUI.Shadow = UI.CreateFrame("Text", "Objective_Shadow", GUI.Frame)
		GUI.Shadow:SetFontColor(0,0,0,1)
		GUI.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.Shadow:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT", 1, 1)
		GUI.Shadow:SetLayer(2)
		GUI.Text = UI.CreateFrame("Text", "Objective_Text", GUI.Frame)
		GUI.Text:SetPoint("CENTERLEFT", GUI.Frame, "CENTERLEFT")
		GUI.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.Text:SetLayer(3)
		GUI.ObShadow = UI.CreateFrame("Text", "Objectives_Shadow", GUI.Frame)
		GUI.ObShadow:SetFontColor(0,0,0,1)
		GUI.ObShadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.ObShadow:SetPoint("CENTERRIGHT", GUI.Frame, "CENTERRIGHT", 1, 1)
		GUI.ObShadow:SetLayer(4)
		GUI.Objective = UI.CreateFrame("Text", "Objective_Tracker", GUI.Frame)
		GUI.Objective:SetPoint("CENTERRIGHT", GUI.Frame, "CENTERRIGHT")
		GUI.Objective:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		GUI.Objective:SetLayer(5)
		GUI.Frame:SetVisible(self.Settings.Enabled)
		function GUI:SetName(Text)
			self.Shadow:SetText(Text)
			self.Text:SetText(Text)
		end
		function GUI:SetObjective(Text)
			self.ObShadow:SetText(Text)
			self.Objective:SetText(Text)
		end
	end
	return GUI
end

function KBM.PhaseMonitor:Init()

	self.Settings = KBM.Options.PhaseMon
	if self.Settings.Type ~= "PhaseMon" then
		print("Error: Incorrect Settings for Phase Monintor")
	end
	self.Anchor = UI.CreateFrame("Frame", "Phase_Anchor", KBM.Context)
	self.Anchor:SetLayer(5)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	self.Anchor.Shadow = UI.CreateFrame("Text", "Phase_Anchor_Shadow", self.Anchor)
	self.Anchor.Shadow:SetFontColor(0,0,0,1)
	self.Anchor.Shadow:SetText(KBM.Language.Anchors.Phases[KBM.Lang])
	self.Anchor.Shadow:SetPoint("CENTER", self.Anchor, "CENTER", 1, 1)
	self.Anchor.Shadow:SetLayer(1)
	self.Anchor.Text = UI.CreateFrame("Text", "Phase_Anchor_Text", self.Anchor)
	self.Anchor.Text:SetText(KBM.Language.Anchors.Phases[KBM.Lang])
	self.Anchor.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Anchor.Text:SetLayer(2)

	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.PhaseMonitor.Settings.x = self:GetLeft()
			KBM.PhaseMonitor.Settings.y = self:GetTop()
		end
	end
		
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Phase Anchor Drag", 2)

	self.Frame = UI.CreateFrame("Texture", "Phase Monitor", KBM.Context)
	self.Frame:SetLayer(5)
	KBM.LoadTexture(self.Frame, "KingMolinator", "Media/BarTexture.png")
	self.Frame:SetBackgroundColor(0,0,0.9,0.33)
	self.Frame:SetPoint("LEFT", self.Anchor, "LEFT")
	self.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
	self.Frame:SetPoint("TOP", self.Anchor, "TOP")
	self.Frame:SetPoint("BOTTOM", self.Anchor, "CENTERY")
	self.Frame.Shadow = UI.CreateFrame("Text", "Phase_Monitor_Shadow", self.Frame)
	self.Frame.Shadow:SetText("Phase: 1")
	self.Frame.Shadow:SetFontColor(0,0,0,1)
	self.Frame.Shadow:SetPoint("CENTER", self.Frame, "CENTER", 1,1)
	self.Frame.Shadow:SetLayer(1)
	self.Frame.Text = UI.CreateFrame("Text", "Phase_Monitor_Text", self.Frame)
	self.Frame.Text:SetText("Phase: 1")
	self.Frame.Text:SetPoint("CENTER", self.Frame, "CENTER")
	self.Frame.Text:SetLayer(2)
	
	self.Frame:SetVisible(false)
	
	self.Objectives = {}
	self.ObjectiveStore = {}
	self.Phase = {}
	self.Phase.Object = nil
	self.Active = false
	
	self.Objectives.Lists = {}
	self.Objectives.Lists.Meta = {}
	self.Objectives.Lists.Death = {}
	self.Objectives.Lists.Percent = {}
	self.Objectives.Lists.Time = {}
	self.Objectives.Lists.All = {}
	self.Objectives.Lists.LastObjective = nil
	self.Objectives.Lists.Count = 0
	
	function self:ApplySettings()
	
		if self.Settings.Type ~= "PhaseMon" then
			error("Error (Apply Settings): Incorrect Settings for Phase Monitor")
		end
	
		self.Anchor:ClearAll()
		if not self.Settings.x then
			self.Anchor:SetPoint("CENTERTOP", UIParent, 0.65, 0)
		else
			self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
		end
		self.Anchor:SetWidth(self.Settings.w * self.Settings.wScale)
		self.Anchor:SetHeight(self.Settings.h * self.Settings.hScale)
		self.Anchor.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Anchor.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Frame.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Frame.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		if self.Settings.Enabled and KBM.MainWin:GetVisible() then
			self.Anchor:SetVisible(self.Settings.Visible)
			self.Anchor:SetBackgroundColor(0,0,0,0.33)
			self.Anchor.Drag:SetVisible(self.Settings.Unlocked)
		else
			self.Anchor:SetVisible(false)
		end
		if #self.ObjectiveStore > 0 then
			for _, GUI in ipairs(self.ObjectiveStore) do
				GUI.ObShadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				GUI.Objective:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				GUI.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				GUI.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				GUI.Frame:SetHeight(self.Anchor:GetHeight() * 0.5)
			end
		end
		if self.Objectives.Lists.Count > 0 then
			for _, Object in ipairs(self.Objectives.Lists.All) do
				Object.GUI.ObShadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				Object.GUI.Objective:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				Object.GUI.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				Object.GUI.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
				Object.GUI.Frame:SetHeight(self.Anchor:GetHeight() * 0.5)
			end
		end	
	end
	
	function self.Objectives.Lists:Add(Object)	
		if self.Count > 0 then
			Object.Previous = self.LastObjective
		end
		self.Count = self.Count + 1
		self.LastObjective = Object
		self.All[self.Count] = Object
		if Object.Previous then
			-- Appended to current List
			Object.GUI.Frame:SetPoint("TOP", Object.Previous.GUI.Frame, "BOTTOM")
			Object.Previous.Next = Object
			Object.Next = nil
		else
			-- First in the list
			Object.GUI.Frame:SetPoint("TOP", KBM.PhaseMonitor.Frame, "BOTTOM")
			Object.Previous = nil
			Object.Next = nil
		end
		Object.Index = self.Count
	end
	
	function self.Objectives.Lists:Remove(Object)
		if not Object then
			if KBM.Debug then
				print("Error: Unknown Object")
			end
			return
		end
		if self.Count == 1 then
			Object.GUI.Progress:SetVisible(false)
			Object.GUI.Frame:SetVisible(false)
			table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
			self[Object.Type][Object.Name] = nil
			self[Object.Type] = {}
			self.All = {}
			Object = nil
			self.Count = 0
		else
			Object.GUI.Progress:SetVisible(false)
			Object.GUI.Frame:SetVisible(false)
			table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
			if Object.Next then
				if Object.Previous then
					-- Next Object is now after this objects previous in the list.
					Object.Previous.Next = Object.Next
					Object.Next.GUI.Frame:SetPoint("TOP", Object.Previous.GUI.Frame, "BOTTOM")
				else
					-- Next Object is now First in the list
					Object.Next.Previous = nil
					Object.Next.GUI.Frame:SetPoint("TOP", KBM.PhaseMonitor.Frame, "BOTTOM")
				end
			else
				-- This object was the last object in the list, and now the previous object is.
				Object.Previous.Next = nil
				self.LastObjective = Object.Previous
			end
			self[Object.Type][Object.Name] = nil
			table.remove(self.All, Object.Index)
			-- Re-Index list
			for Index, Object in ipairs(self.All) do
				Object.Index = Index
			end
			self.Count = self.Count - 1
		end		
	end
	
	function self:SetPhase(Phase)
		self.Phase = Phase
		self.Frame.Shadow:SetText("Phase: "..Phase)
		self.Frame.Text:SetText("Phase: "..Phase)
	end
	
	function self.Phase:Create(Phase)
		local PhaseObj = {}
		PhaseObj.StartTime = 0
		PhaseObj.Phase = Phase
		PhaseObj.DefaultPhase = Phase
		PhaseObj.Objectives = {}
		PhaseObj.LastObjective = KBM.PhaseMonitor.Frame
		PhaseObj.Type = "PhaseMon"
		
		function PhaseObj:Update(Time)
			Time = math.floor(Time)
		end
		
		function PhaseObj:SetPhase(Phase)
			self.Phase = Phase
			KBM.PhaseMonitor:SetPhase(Phase)
		end
		
		function PhaseObj.Objectives:AddMeta(Name, Target, Total)		
			local MetaObj = {}
			MetaObj.Count = Total
			MetaObj.Target = Target
			MetaObj.Name = Name
			MetaObj.GUI = KBM.PhaseMonitor:PullObjective()
			MetaObj.GUI:SetName(Name)
			MetaObj.GUI:SetObjective(MetaObj.Count.."/"..MetaObj.Target)
			MetaObj.GUI.Progress:SetVisible(false)
			MetaObj.Type = "Meta"
			
			function MetaObj:Update(Total)
				if self.Target >= Total then
					self.Count = Total
					self.GUI:SetObjective(self.Count.."/"..self.Target)
				end
			end
			function MetaObj:Remove()
				KBM.PhaseMonitor.Objectives.Lists:Remove(self)
			end
			
			KBM.PhaseMonitor.Objectives.Lists.Meta[Name] = MetaObj
			KBM.PhaseMonitor.Objectives.Lists:Add(MetaObj)
			
			if KBM.PhaseMonitor.Settings.Enabled then
				MetaObj.GUI.Frame:SetVisible(KBM.PhaseMonitor.Settings.Objectives)
			else
				MetaObj.GUI.Frame:SetVisible(false)
			end
			return MetaObj
		end
		
		function PhaseObj.Objectives:AddDeath(Name, Total, Type)		
			local DeathObj = {}
			DeathObj.Count = 0
			DeathObj.Total = Total
			DeathObj.Name = Name
			DeathObj.uType = Type
			DeathObj.Boss = BossObj
			DeathObj.GUI = KBM.PhaseMonitor:PullObjective()
			DeathObj.GUI:SetName(Name)
			DeathObj.GUI:SetObjective(DeathObj.Count.."/"..DeathObj.Total)
			DeathObj.GUI.Progress:SetVisible(false)
			DeathObj.Type = "Death"
			
			function DeathObj:Kill(UnitObj)
				if self.Count < Total then
					if self.uType == nil then
						self.Count = self.Count + 1
						self.GUI:SetObjective(self.Count.."/"..self.Total)
					elseif UnitObj.Details then
						if self.uType == UnitObj.Details.type then
							self.Count = self.Count + 1
							self.GUI:SetObjective(self.Count.."/"..self.Total)
						end
					end
				end
			end
			
			function DeathObj:Remove()
				KBM.PhaseMonitor.Objectives.Lists:Remove(self)
			end
			
			KBM.PhaseMonitor.Objectives.Lists.Death[Name] = DeathObj
			KBM.PhaseMonitor.Objectives.Lists:Add(DeathObj)
			
			if KBM.PhaseMonitor.Settings.Enabled then
				DeathObj.GUI.Frame:SetVisible(KBM.PhaseMonitor.Settings.Objectives)
			else
				DeathObj.GUI.Frame:SetVisible(false)
			end
			return DeathObj
		end
		
		function PhaseObj.Objectives:AddPercent(Name, Target, Current)		
			local PercentObj = {}
			PercentObj.Name = Name
			PercentObj.Target = Target
			PercentObj.PercentRaw = Current
			PercentObj.Percent = math.ceil(Current)
			if KBM.CurrentMod then
				if KBM.CurrentMod.Bosses[PercentObj.Name] then
					if KBM.CurrentMod.Bosses[PercentObj.Name].UnitID then
						if KBM.BossID[KBM.CurrentMod.Bosses[PercentObj.Name].UnitID] then
							PercentObj.PercentRaw = KBM.BossID[KBM.CurrentMod.Bosses[PercentObj.Name].UnitID].PercentRaw
							PercentObj.Percent = KBM.BossID[KBM.CurrentMod.Bosses[PercentObj.Name].UnitID].Percent
							Current = PercentObj.Percent
						end
					end
				end
			end
			PercentObj.Dead = false
			PercentObj.GUI = KBM.PhaseMonitor:PullObjective()
			PercentObj.GUI.Progress:SetWidth(PercentObj.GUI.Frame:GetWidth() * (PercentObj.PercentRaw * 0.01))
			PercentObj.GUI.Progress:SetVisible(true)
			PercentObj.GUI:SetName(Name)
			if Target == 0 then
				PercentObj.GUI:SetObjective(PercentObj.Percent.."%")
			else
				PercentObj.GUI:SetObjective(PercentObj.Percent.."%/"..PercentObj.Target.."%")
			end	
			PercentObj.Type = "Percent"
			
			function PercentObj:Update(PercentRaw)
				if self.Dead then
					return
				end
				self.PercentRaw = PercentRaw
				self.Percent = math.ceil(PercentRaw)
				if self.Percent == 0 then
					self.GUI:SetObjective(KBM.Language.Options.Dead[KBM.Lang])
					self.GUI.Progress:SetVisible(false)
					self.Dead = true
				else
					if self.Percent >= self.Target then
						if self.Target == 0 then
							if self.PercentRaw < 3 then
								self.GUI:SetObjective(string.format("%0.02f", self.PercentRaw).."%")
							else
								self.GUI:SetObjective(self.Percent.."%")
							end
						else
							self.GUI:SetObjective(self.Percent.."%/"..self.Target.."%")
						end
						self.GUI.Progress:SetWidth(self.GUI.Frame:GetWidth() * (self.PercentRaw * 0.01))
					end
				end
			end
			function PercentObj:Remove()
				KBM.PhaseMonitor.Objectives.Lists:Remove(self)
			end
			
			KBM.PhaseMonitor.Objectives.Lists.Percent[Name] = PercentObj
			KBM.PhaseMonitor.Objectives.Lists:Add(PercentObj)
			
			if KBM.PhaseMonitor.Settings.Enabled then
				PercentObj.GUI.Frame:SetVisible(KBM.PhaseMonitor.Settings.Objectives)
			else
				PercentObj.GUI.Frame:SetVisible(false)
			end
			return PercentObj
		end
		
		function PhaseObj.Objectives:AddTime(Time)
		end
		
		function PhaseObj.Objectives:Remove(Index)		
			if type(Index) == "number" then
				KBM.PhaseMonitor.Objectives.Lists:Remove(KBM.PhaseMonitor.Objectives.Lists.All[Index])
			else
				for _, Object in ipairs(KBM.PhaseMonitor.Objectives.Lists.All) do
					Object.GUI.Frame:SetVisible(false)
					table.insert(KBM.PhaseMonitor.ObjectiveStore, Object.GUI)
				end
				for ListName, List in pairs(KBM.PhaseMonitor.Objectives.Lists) do
					if type(List) == "table" then
						KBM.PhaseMonitor.Objectives.Lists[ListName] = {}
					end
				end
				KBM.PhaseMonitor.Objectives.Lists.Count = 0
			end			
		end
		
		function PhaseObj:Start(Time)
			self.StartTime = math.floor(Time)
			self.Phase = self.DefaultPhase
			if KBM.PhaseMonitor.Settings.Enabled then
				if KBM.PhaseMonitor.Settings.PhaseDisplay then
					KBM.PhaseMonitor.Frame:SetVisible(true)
				end
			end
			KBM.PhaseMonitor.Active = true
			self:SetPhase(self.Phase)
			if KBM.PhaseMonitor.Anchor:GetVisible() then
				if KBM.PhaseMonitor.Settings.Enabled then
					KBM.PhaseMonitor.Anchor:SetVisible(false)
				else
					KBM.PhaseMonitor.Anchor.Shadow:SetVisible(false)
					KBM.PhaseMonitor.Anchor.Text:SetVisible(false)
					KBM.PhaseMonitor.Anchor:SetBackgroundColor(0,0,0,0)
				end
			end
		end
		
		function PhaseObj:End(Time)
			self.Objectives:Remove()
			KBM.PhaseMonitor.Frame:SetVisible(false)
			KBM.PhaseMonitor.Active = false
			if KBM.PhaseMonitor.Anchor:GetVisible() then
				KBM.PhaseMonitor.Anchor.Shadow:SetVisible(true)
				KBM.PhaseMonitor.Anchor.Text:SetVisible(true)
				KBM.PhaseMonitor.Anchor:SetBackgroundColor(0,0,0,0.33)
			else
				if KBM.PhaseMonitor.Settings.Visible then
					KBM.PhaseMonitor.Anchor:SetVisible(true)
				end
			end
		end
	
		self.Object = PhaseObj
		return PhaseObj
	end
	
	function self.Phase:Remove()	
	end
	
	function self.Anchor.Drag.Event:WheelForward()	
		local Change = false
		if KBM.PhaseMonitor.Settings.ScaleWidth then
			if KBM.PhaseMonitor.Settings.wScale < 1.6 then
				KBM.PhaseMonitor.Settings.wScale = KBM.PhaseMonitor.Settings.wScale + 0.02
				if KBM.PhaseMonitor.Settings.wScale > 1.6 then
					KBM.PhaseMonitor.Settings.wScale = 1.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.ScaleHeight then
			if KBM.PhaseMonitor.Settings.hScale < 1.6 then
				KBM.PhaseMonitor.Settings.hScale = KBM.PhaseMonitor.Settings.hScale + 0.02
				if KBM.PhaseMonitor.Settings.hScale > 1.6 then
					KBM.PhaseMonitor.Settings.hScale = 1.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.TextScale then
			if KBM.PhaseMonitor.Settings.tScale < 1.6 then
				KBM.PhaseMonitor.Settings.tScale = KBM.PhaseMonitor.Settings.tScale + 0.02
				if KBM.PhaseMonitor.Settings.tScale > 1.6 then
					KBM.PhaseMonitor.Settings.tScale = 1.6
				end
				Change = true
			end
		end
		
		if Change then
			KBM.PhaseMonitor:ApplySettings()
		end		
	end
	
	function self.Anchor.Drag.Event:WheelBack()	
		local Change = false
		if KBM.PhaseMonitor.Settings.ScaleWidth then
			if KBM.PhaseMonitor.Settings.wScale > 0.6 then
				KBM.PhaseMonitor.Settings.wScale = KBM.PhaseMonitor.Settings.wScale - 0.02
				if KBM.PhaseMonitor.Settings.wScale < 0.6 then
					KBM.PhaseMonitor.Settings.wScale = 0.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.ScaleHeight then
			if KBM.PhaseMonitor.Settings.hScale > 0.6 then
				KBM.PhaseMonitor.Settings.hScale = KBM.PhaseMonitor.Settings.hScale - 0.02
				if KBM.PhaseMonitor.Settings.hScale < 0.6 then
					KBM.PhaseMonitor.Settings.hScale = 0.6
				end
				Change = true
			end
		end
		
		if KBM.PhaseMonitor.Settings.TextScale then
			if KBM.PhaseMonitor.Settings.tScale > 0.6 then
				KBM.PhaseMonitor.Settings.tScale = KBM.PhaseMonitor.Settings.tScale - 0.02
				if KBM.PhaseMonitor.Settings.tScale < 0.6 then
					KBM.PhaseMonitor.Settings.tScale = 0.6
				end
				Change = true
			end
		end
		
		if Change then 
			KBM.PhaseMonitor:ApplySettings()
		end
	end
	self:ApplySettings()	
end

function KBM.EncTimer:Init()	
	self.TestMode = false
	self.Settings = KBM.Options.EncTimer
	self.Frame = UI.CreateFrame("Frame", "Encounter_Timer", KBM.Context)
	self.Frame:SetLayer(5)
	self.Frame:SetBackgroundColor(0,0,0,0.33)
	self.Frame.Shadow = UI.CreateFrame("Text", "Time_Shadow", self.Frame)
	self.Frame.Shadow:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
	self.Frame.Shadow:SetPoint("CENTER", self.Frame, "CENTER", 1, 1)
	self.Frame.Shadow:SetLayer(1)
	self.Frame.Shadow:SetFontColor(0,0,0,1)
	self.Frame.Text = UI.CreateFrame("Text", "Encounter_Text", self.Frame)
	self.Frame.Text:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
	self.Frame.Text:SetPoint("CENTER", self.Frame, "CENTER")
	self.Frame.Text:SetLayer(2)
	self.Enrage = {}
	self.Enrage.Frame = UI.CreateFrame("Frame", "Enrage Timer", KBM.Context)
	self.Enrage.Frame:SetPoint("TOPLEFT", self.Frame, "BOTTOMLEFT")
	self.Enrage.Frame:SetPoint("RIGHT", self.Frame, "RIGHT")
	self.Enrage.Frame:SetBackgroundColor(0,0,0,0.33)
	self.Enrage.Frame:SetLayer(5)
	self.Enrage.Shadow = UI.CreateFrame("Text", "Time_Shadow", self.Enrage.Frame)
	self.Enrage.Shadow:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
	self.Enrage.Shadow:SetPoint("CENTER", self.Enrage.Frame, "CENTER", 1, 1)
	self.Enrage.Shadow:SetLayer(2)
	self.Enrage.Shadow:SetFontColor(0,0,0,1)
	self.Enrage.Text = UI.CreateFrame("Text", "Enrage Text", self.Enrage.Frame)
	self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
	self.Enrage.Text:SetPoint("CENTER", self.Enrage.Frame, "CENTER")
	self.Enrage.Text:SetLayer(3)
	self.Enrage.Progress = UI.CreateFrame("Texture", "Enrage Progress", self.Enrage.Frame)
	KBM.LoadTexture(self.Enrage.Progress, "KingMolinator", "Media/BarTexture.png")
	self.Enrage.Progress:SetPoint("TOPLEFT", self.Enrage.Frame, "TOPLEFT")
	self.Enrage.Progress:SetPoint("BOTTOM", self.Enrage.Frame, "BOTTOM")
	self.Enrage.Progress:SetWidth(0)
	self.Enrage.Progress:SetBackgroundColor(0.9,0,0,0.33)
	self.Enrage.Progress:SetLayer(1)
	
	function self:ApplySettings()
		self.Frame:ClearAll()
		if not self.Settings.x then
			self.Frame:SetPoint("CENTERTOP", UIParent, "CENTERTOP")
		else
			self.Frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
		end
		self.Frame:SetWidth(self.Settings.w * self.Settings.wScale)
		self.Frame:SetHeight(self.Settings.h * self.Settings.hScale)
		self.Enrage.Frame:SetHeight(self.Frame:GetHeight())
		self.Frame.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Frame.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Enrage.Shadow:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		self.Enrage.Text:SetFontSize(self.Settings.TextSize * self.Settings.tScale)
		if KBM.MainWin:GetVisible() then
			self.Frame:SetVisible(self.Settings.Visible)
			self.Enrage.Frame:SetVisible(self.Settings.Visible)
			self.Frame.Drag:SetVisible(self.Settings.Unlocked)
		else
			if self.Active then
				self.Frame:SetVisible(self.Settings.Enabled)
				if KBM.CurrentMod.Enrage then
					self.Enrage.Frame:SetVisible(self.Settings.Enrage)
				else
					self.Enrage.Frame:SetVisible(false)
				end
				self.Frame.Drag:SetVisible(false)
			else
				self.Frame:SetVisible(false)
				self.Enrage.Frame:SetVisible(false)
				self.Frame.Drag:SetVisible(false)
			end
		end
	end
	
	function self:UpdateMove(uType)	
		if uType == "end" then
			self.Settings.x = self.Frame:GetLeft()
			self.Settings.y = self.Frame:GetTop()
		end		
	end
	
	function self:Update(current)	
		local EnrageString = ""
		if self.Settings.Duration then
			self.Frame.Shadow:SetText(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
			self.Frame.Text:SetText(self.Frame.Shadow:GetText())
		end
		
		if self.Settings.Enrage then
			if KBM.CurrentMod.Enrage then
				if self.Paused then
					EnrageString = KBM.ConvertTime(KBM.CurrentMod.Enrage)
				else
					if current < KBM.EnrageTime then
						EnrageString = KBM.ConvertTime(KBM.EnrageTime - current + 1)
						self.Enrage.Shadow:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." "..EnrageString)
						self.Enrage.Text:SetText(self.Enrage.Shadow:GetText())
						self.Enrage.Progress:SetWidth(math.floor(self.Enrage.Frame:GetWidth()*((KBM.TimeElapsed - self.EnrageStart)/KBM.CurrentMod.Enrage)))
					else
						self.Enrage.Shadow:SetText(KBM.Language.Timers.Enraged[KBM.Lang])
						self.Enrage.Text:SetText(KBM.Language.Timers.Enraged[KBM.Lang])
						self.Enrage.Progress:SetWidth(self.Enrage.Frame:GetWidth())
					end
				end
			end
		end		
	end
	
	function self:Unpause()
		self.EnrageStart = KBM.TimeElapsed
		KBM.EnrageTime = Inspect.Time.Real() + KBM.CurrentMod.Enrage
		self.Paused = false
	end
	
	function self:Start(Time)
		self.IsEnraged = false
		self.EnrageStart = 0
		if self.Settings.Enabled then
			if self.Settings.Duration then
				self.Frame:SetVisible(true)
				self.Active = true
			end
			if self.Settings.Enrage then
				if KBM.CurrentMod.Enrage then
					if KBM.CurrentMod.EnragePaused then
						self.Paused = true
					end
					self.Enrage.Frame:SetVisible(true)
					self.Enrage.Progress:SetWidth(0)
					self.Enrage.Progress:SetVisible(true)
					self.Active = true
				end
			end
			if self.Active then
				self:Update(Time)
			end
		end		
	end
	
	function self:TestUpdate()	
	end
	
	function self:End()	
		self.Active = false
		self.IsEnraged = false
		self.Enrage.Shadow:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
		self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
		self.Frame.Shadow:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
		self.Frame.Text:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
		self.Enrage.Progress:SetVisible(false)
		self.Enrage.Progress:SetWidth(0)
	end
	
	function self:SetTest(bool)	
		if bool then
			self.Enrage.Shadow:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
			self.Enrage.Text:SetText(KBM.Language.Timers.Enrage[KBM.Lang].." 00:00")
			self.Frame.Shadow:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
			self.Frame.Text:SetText(KBM.Language.Timers.Time[KBM.Lang].." 00:00")
		end
		self.Frame:SetVisible(bool)
		self.Enrange:SetVisible(bool)		
	end
	
	self.Frame.Drag = KBM.AttachDragFrame(self.Frame, function (uType) self:UpdateMove(uType) end, "Enc Timer Drag", 2)
	function self.Frame.Drag.Event:WheelForward()	
		if KBM.EncTimer.Settings.ScaleWidth then
			if KBM.EncTimer.Settings.wScale < 1.6 then
				KBM.EncTimer.Settings.wScale = KBM.EncTimer.Settings.wScale + 0.02
				if KBM.EncTimer.Settings.wScale > 1.6 then
					KBM.EncTimer.Settings.wScale = 1.6
				end
				KBM.EncTimer.Frame:SetWidth(KBM.EncTimer.Settings.wScale * KBM.EncTimer.Settings.w)
			end
		end
		
		if KBM.EncTimer.Settings.ScaleHeight then
			if KBM.EncTimer.Settings.hScale < 1.6 then
				KBM.EncTimer.Settings.hScale = KBM.EncTimer.Settings.hScale + 0.02
				if KBM.EncTimer.Settings.hScale > 1.6 then
					KBM.EncTimer.Settings.hScale = 1.6
				end
				KBM.EncTimer.Frame:SetHeight(KBM.EncTimer.Settings.hScale * KBM.EncTimer.Settings.h)
				KBM.EncTimer.Enrage.Frame:SetHeight(KBM.EncTimer.Frame:GetHeight())
			end
		end
		
		if KBM.EncTimer.Settings.TextScale then
			if KBM.EncTimer.Settings.tScale < 1.6 then
				KBM.EncTimer.Settings.tScale = KBM.EncTimer.Settings.tScale + 0.02
				if KBM.EncTimer.Settings.tScale > 1.6 then
					KBM.EncTimer.Settings.tScale = 1.6
				end
				KBM.EncTimer.Frame.Shadow:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Frame.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)	
				KBM.EncTimer.Enrage.Shadow:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Enrage.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
			end
		end		
	end
	
	function self.Frame.Drag.Event:WheelBack()	
		if KBM.EncTimer.Settings.ScaleWidth then
			if KBM.EncTimer.Settings.wScale > 0.6 then
				KBM.EncTimer.Settings.wScale = KBM.EncTimer.Settings.wScale - 0.02
				if KBM.EncTimer.Settings.wScale < 0.6 then
					KBM.EncTimer.Settings.wScale = 0.6
				end
				KBM.EncTimer.Frame:SetWidth(KBM.EncTimer.Settings.wScale * KBM.EncTimer.Settings.w)
			end
		end
		
		if KBM.EncTimer.Settings.ScaleHeight then
			if KBM.EncTimer.Settings.hScale > 0.6 then
				KBM.EncTimer.Settings.hScale = KBM.EncTimer.Settings.hScale - 0.02
				if KBM.EncTimer.Settings.hScale < 0.6 then
					KBM.EncTimer.Settings.hScale = 0.6
				end
				KBM.EncTimer.Frame:SetHeight(KBM.EncTimer.Settings.hScale * KBM.EncTimer.Settings.h)
				KBM.EncTimer.Enrage.Frame:SetHeight(KBM.EncTimer.Frame:GetHeight())
			end
		end
		
		if KBM.EncTimer.Settings.TextScale then
			if KBM.EncTimer.Settings.tScale > 0.6 then
				KBM.EncTimer.Settings.tScale = KBM.EncTimer.Settings.tScale - 0.02
				if KBM.EncTimer.Settings.tScale < 0.6 then
					KBM.EncTimer.Settings.tScale = 0.6
				end
				KBM.EncTimer.Frame.Shadow:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Frame.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)	
				KBM.EncTimer.Enrage.Shadow:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
				KBM.EncTimer.Enrage.Text:SetFontSize(KBM.EncTimer.Settings.tScale * KBM.EncTimer.Settings.TextSize)
			end
		end
	end
	self:ApplySettings()	
end

function KBM.MatchType(uDetails, BossObj)
	if not BossObj then
		return false
	end
	if KBM.Encounter then
		-- Already established type
		if KBM.DungeonMode then
			if not BossObj[uDetails.type] then
				if KBM.Debug then
					print("Unique ID not set: "..uDetails.name)
					print("Unique ID: "..uDetails.type)
				end
				if KBM.DungeonMode == "expert" then
					return BossObj.Expert
				else
					return BossObj.Master
				end
			else
				return BossObj[uDetails.type]
			end
		else
			return BossObj
		end
	else
		if not BossObj.Mod then
			if BossObj[uDetails.type] then
				BossObj = BossObj[uDetails.type]
			else
				if BossObj.Expert then
					BossObj = BossObj.Expert
				elseif BossObj.Master then
					BossObj = BossObj.Master
				else
					if KBM.Debug then
						print("Unhandled Unit: "..uDetails.name)
						print("Unique ID: "..uDetails.type)
					end
					return false
				end
			end
			if BossObj.Mod.InstanceObj then
				if BossObj.Mod.InstanceObj.Type == "Expert" then
					if uDetails.level == 52 or uDetails.level == "??" then
						if KBM.Debug then 
							print("Expert Dungeon mode active")
						end
						KBM.EncounterMode = "normal"
						KBM.DungeonMode = "expert"
						return BossObj
					else
						return false
					end
				elseif BossObj.Mod.InstanceObj.Type == "Master" then
					if uDetails.level == 52 or uDetails.level == "??" then
						if KBM.Debug then
							print("Master Mode Dungeon mode active")
						end
						KBM.EncounterMode = "normal"
						KBM.DungeonMode = "master"
						return BossObj
					else
						return false
					end
				end
			end
		else
			KBM.DungeonMode = false
			if BossObj.Mod.HasChronicle then
				if BossObj.ChronicleID then
					if uDetails.type == BossObj.ChronicleID then
						KBM.EncounterMode = "chronicle"
						if KBM.Debug then
							print("Chronicle mode active via ID")
						end
						return BossObj
					else
						KBM.EncounterMode = "normal"
						if KBM.Debug then
							print("Normal mode active via ID")
						end
						return BossObj
					end
				else
					if KBM.Debug then
						print("Undefined Chronicle ID, using HP checking method")
					end
					if uDetails.healthMax < 1500000 then
						KBM.EncounterMode = "chronicle"
						if KBM.Debug then
							print("Chronicle mode active via HP")
						end
						return BossObj
					else
						KBM.EncounterMode = "normal"
						if KBM.Debug then
							print("Normal mode active via HP")
						end
						return BossObj
					end
				end
			else
				KBM.EncounterMode = "normal"
				return BossObj
			end
		end
		return false
	end
end

function KBM.CheckActiveBoss(uDetails, UnitID)
	local current = Inspect.Time.Real()
	if KBM.IgnoreList[UnitID] then
		return
	end
	if KBM.Options.Enabled then
		if (not KBM.Idle.Wait or (KBM.Idle.Wait == true and KBM.Idle.Until < current)) or KBM.Encounter then
			local BossObj = nil
			KBM.Idle.Wait = false
			if not KBM.BossID[UnitID] then
				if uDetails then
					if uDetails.type then
						if KBM.SubBossID[uDetails.type] then
							BossObj = KBM.SubBossID[uDetails.type]
						elseif KBM.Boss.MasterID[uDetails.type] then
							BossObj = KBM.Boss.Dungeon.List[uDetails.name]
						elseif KBM.Boss.ExpertID[uDetails.type] then
							BossObj = KBM.Boss.Dungeon.List[uDetails.name]
						end
					end
					if not BossObj then
						if KBM_Boss[uDetails.name] then
							BossObj = KBM_Boss[uDetails.name]
							if BossObj.IgnoreID == uDetails.type then
								BossObj = nil
								KBM.IgnoreList[UnitID] = true
							end
						elseif KBM.SubBoss[uDetails.name] then
							BossObj = KBM.SubBoss[uDetails.name]
						elseif KBM.Boss.Dungeon.List[uDetails.name] then
							BossObj = KBM.Boss.Dungeon.List[uDetails.name]
						end
					end
					BossObj = KBM.MatchType(uDetails, BossObj)
					local ModBossObj = nil
					if BossObj then
						if BossObj.Mod then
							if KBM.Encounter then
								if BossObj.Mod.ID == KBM.CurrentMod.ID then
									ModBossObj = KBM.CurrentMod:UnitHPCheck(uDetails, UnitID)
								else
									if KBM.CurrentMod.Bosses then
										if KBM.CurrentMod.Bosses[uDetails.name] then
											ModBossObj = KBM.CurrentMod:UnitHPCheck(uDetails, UnitID)
											BossObj = KBM.CurrentMod.Bosses[uDetails.name]
										end
									end
								end
							else
								if not BossObj.Ignore then
									ModBossObj = BossObj.Mod:UnitHPCheck(uDetails, UnitID)
								end
							end
							if ModBossObj then
								if (BossObj.Ignore == nil and KBM.Encounter == false) or KBM.Encounter == true then
									if KBM.Debug then
										print("Boss found Checking: Tier = "..tostring(uDetails.tier).." "..tostring(uDetails.level).." ("..type(uDetails.level)..")")
										print("Players location: "..tostring(KBM.Player.Location))
										print("Unit Type: "..tostring(uDetails.type))
										print("Unit Name: "..tostring(uDetails.name))
										print("Unit X: "..tostring(uDetails.coordX))
										print("Unit Y: "..tostring(uDetails.coordY))
										print("Unit Z: "..tostring(uDetails.coordZ))
										print("------------------------------------")
									end
									if uDetails.combat then
										-- if KBM.Debug then
											-- print("Boss matched checking encounter start")
										-- end
										if KBM.EncounterMode == "normal" or (KBM.EncounterMode == "chronicle" and BossObj.Mod.Settings.Chronicle) then
											KBM.BossID[UnitID] = {}
											KBM.BossID[UnitID].name = uDetails.name
											KBM.BossID[UnitID].monitor = true
											KBM.BossID[UnitID].Mod = BossObj.Mod
											KBM.BossID[UnitID].IdleSince = false
											KBM.BossID[UnitID].Boss = ModBossObj
											if uDetails.health > 0 then
												if KBM.Debug then
													print("Boss is alive and in combat, activating.")
												end
												KBM.BossID[UnitID].Combat = true
												KBM.BossID[UnitID].dead = false
												KBM.BossID[UnitID].available = true
												KBM.BossID[UnitID].Health = uDetails.health
												KBM.BossID[UnitID].HealthLast = uDetails.health
												KBM.BossID[UnitID].HealthMax = uDetails.healthMax
												KBM.BossID[UnitID].PercentRaw = (uDetails.health/uDetails.healthMax)*100
												KBM.BossID[UnitID].Percent = math.ceil(KBM.BossID[UnitID].PercentRaw)
												KBM.BossID[UnitID].PercentLast = KBM.BossID[UnitID].Percent
												if not KBM.Encounter then
													-- if KBM.Debug then
														-- print("New encounter, starting")
													-- end
													KBM.Encounter = true
													KBM.CurrentBoss = UnitID
													KBM_CurrentBossName = uDetails.name
													KBM.CurrentMod = KBM.BossID[UnitID].Mod
													local PercentOver = 99
													if KBM.EncounterMode == "chronicle" then
														if KBM.CurrentMod.ChroniclePOver then
															PercentOver = KBM.CurrentMod.ChroniclePOver
														end
														print(KBM.Language.Encounter.Start[KBM.Lang].." "..KBM.CurrentMod.Descript.." (Chronicles)")
														if KBM.BossID[UnitID].Percent >= PercentOver then 
															KBM.CurrentMod.Settings.Records.Chronicle.Attempts = KBM.CurrentMod.Settings.Records.Chronicle.Attempts + 1
														end
													else
														print(KBM.Language.Encounter.Start[KBM.Lang].." "..KBM.CurrentMod.Descript)
														if KBM.BossID[UnitID].Percent >= PercentOver then
															KBM.CurrentMod.Settings.Records.Attempts = KBM.CurrentMod.Settings.Records.Attempts + 1
														end
													end
													if KBM.BossID[UnitID].Percent < PercentOver then
														KBM.ValidTime = false
													else
														KBM.ValidTime = true
													end
													print(KBM.Language.Encounter.GLuck[KBM.Lang])
													KBM.TimeElapsed = 0
													KBM.StartTime = math.floor(current)
													KBM.CurrentMod.Phase = 1
													KBM.Phase = 1
													if KBM.CurrentMod.Settings.EncTimer then
														if KBM.CurrentMod.Settings.EncTimer.Override then
															KBM.EncTimer.Settings = KBM.CurrentMod.Settings.EncTimer
														else
															KBM.EncTimer.Settings = KBM.Options.EncTimer
														end
													else
														KBM.EncTimer.Settings = KBM.Options.EncTimer
													end
													if KBM.CurrentMod.Settings.PhaseMon then
														if KBM.CurrentMod.Settings.PhaseMon.Override then
															KBM.PhaseMonitor.Settings = KBM.CurrentMod.Settings.PhaseMon
														else
															KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
														end
													else
														KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
													end
													if KBM.CurrentMod.Settings.MechTimer then
														if KBM.CurrentMod.Settings.MechTimer.Override then
															KBM.MechTimer.Settings = KBM.CurrentMod.Settings.MechTimer
														else
															KBM.MechTimer.Settings = KBM.Options.MechTimer
														end
													else
														KBM.MechTimer.Setting = KBM.Options.MechTimer
													end
													if KBM.CurrentMod.Settings.Alerts then
														if KBM.CurrentMod.Settings.Alerts.Override then
															KBM.Alert.Settings = KBM.CurrentMod.Settings.Alerts
														else
															KBM.Alert.Settings = KBM.Options.Alerts
														end
													else
														KBM.Alert.Settings = KBM.Options.Alerts
													end
													if KBM.CurrentMod.Settings.MechSpy then
														if KBM.CurrentMod.Settings.MechSpy.Override then
															KBM.MechSpy.Settings = KBM.CurrentMod.Settings.MechSpy
														else
															KBM.MechSpy.Settings = KBM.Options.MechSpy
														end
													else
														KBM.MechSpy.Settings = KBM.Options.MechSpy
													end
													KBM.EncTimer:ApplySettings()
													KBM.PhaseMonitor:ApplySettings()
													KBM.MechTimer:ApplySettings()
													KBM.Alert:ApplySettings()
													KBM.MechSpy:ApplySettings()
													if KBM.CurrentMod.Enrage then
														KBM.EnrageTime = KBM.StartTime + KBM.CurrentMod.Enrage
													end
													KBM.EncTimer:Start(KBM.StartTime)
													KBM.MechSpy:Begin()
													KBM.Event.Encounter.Start({Type = "start"})
												end
											else
												KBM.BossID[UnitID].Combat = false
												KBM.BossID[UnitID].dead = true
												KBM.BossID[UnitID].available = true
											end
										end
									else
										--print("Not in combat!")
									end
								end
							end
						end
					else
						if uDetails.availability == "full" then
							if uDetails.type then
								if KBM.Debug then
									if not KBM.IgnoreList[UnitID] then
										print("New Unit Added to Ignore:")
										dump(uDetails)
										print("----------")
									end
								end
								KBM.IgnoreList[UnitID] = true
							end
						end
					end
				end
			else
				if uDetails then
					if uDetails.health == 0 then
						KBM.BossID[UnitID].Combat = false
						KBM.BossID[UnitID].available = true
						if not KBM.BossID[UnitID].dead then
							KBM.BossID[UnitID].dead = true
						end
					end
				end
			end
		else
			-- if KBM.Debug then
				-- print("Encounter idle wait, skipping start.")
			-- end
			if KBM.Idle.Until < current then
				KBM.Idle.Wait = false
			end
		end
	end	
end

function KBM.CombatEnter(UnitID)
	if KBM.Options.Enabled then
		uDetails = Inspect.Unit.Detail(UnitID)
		if uDetails then
			KBM.Unit:Update(uDetails, UnitID)
			if not uDetails.player then
				KBM.CheckActiveBoss(uDetails, UnitID)
			end
			KBM.Unit.List.UID[UnitID]:CheckTarget()
		end
	end	
end

function KBM.CombatLeave(UnitID)
	if KBM.Options.Enabled then
		uDetails = Inspect.Unit.Detail(UnitID)
		if uDetails then
			KBM.Unit:Update(uDetails, UnitID)
			KBM.Unit.List.UID[UnitID]:CheckTarget()
		end
	end	
end

function KBM.MobDamage(info)
	-- Damage done by a Non Raid Member to Anything.
	if KBM.Options.Enabled then
		local tUnitID = info.target
		local UnitObj = KBM.Unit.List.UID[tUnitID]
		if not UnitObj then
			tDetails = Inspect.Unit.Detail(tUnitID)
			UnitObj = KBM.Unit:Idle(tUnitID, tDetails)
		else
			tDetails = Inspect.Unit.Detail(tUnitID)
		end
		local cUnitID = info.caster
		local cDetails = nil
		if cUnitID then
			cDetails = Inspect.Unit.Detail(cUnitID)
			if not KBM.Unit.List.UID[cUnitID] then
				KBM.Unit:Idle(cUnitID, cDetails)
			else
				if cDetails then
					KBM.Unit.List.UID[cUnitID]:Update(cDetails.health, cDetails)
				end
			end
		end	
		if UnitObj then
			UnitObj:DamageHandler(info, tDetails)
		end
		if KBM.Encounter then
			-- Check for damage done to the raid by Bosses
			if tUnitID then
				if tDetails then
					if KBM.CurrentMod then
						if info.abilityName then
							if KBM.Trigger.Damage[info.abilityName] then
								TriggerObj = KBM.Trigger.Damage[info.abilityName]
								KBM.Trigger.Queue:Add(TriggerObj, cUnitID, tUnitID)
							end
						end
						if KBM.BossID[tUnitID] then
							-- Update Phase Monitor accordingly.
							if KBM.PhaseMonitor.Active then
								if KBM.PhaseMonitor.Objectives.Lists.Percent[tDetails.name] then
									KBM.PhaseMonitor.Objectives.Lists.Percent[tDetails.name]:Update(KBM.BossID[tUnitID].PercentRaw)
								end
							end
							-- Check for Npc Based Triggers (Usually Dynamic: Eg - Failsafe for P4 start Akylios)
							if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID] then
								if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][tDetails.name] then
									local TriggerObj = KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][tDetails.name]
									if TriggerObj.Enabled then
										KBM.Trigger.Queue:Add(TriggerObj, nil, tUnitID)
									end
								end
							end
						end
					end	
				else
					if KBM.BossID[tUnitID] then
						if not KBM.BossID[tUnitID].Dead then
							if info.damage then
								KBM.BossID[tUnitID].Health = KBM.BossID[tUnitID].HealthLast - info.damage
								if info.Overkill then
									KBM.BossID[tUnitID].Health = 0
								end
								KBM.BossID[tUnitID].HealthLast = KBM.BossID[tUnitID].Health
								KBM.BossID[tUnitID].PercentRaw = (KBM.BossID[tUnitID].Health/KBM.BossID[tUnitID].HealthMax)*100
								KBM.BossID[tUnitID].Percent = math.ceil(KBM.BossID[tUnitID].PercentRaw)
								if KBM.CurrentMod then
									KBM.BossID[tUnitID].PercentLast = KBM.BossID[tUnitID].Percent
									-- Update Phase Monitor accordingly.
									if KBM.PhaseMonitor.Active then
										if KBM.PhaseMonitor.Objectives.Lists.Percent[KBM.BossID[tUnitID].name] then
											KBM.PhaseMonitor.Objectives.Lists.Percent[KBM.BossID[tUnitID].name]:Update(KBM.BossID[tUnitID].PercentRaw)
										end
									end
									-- Check for Npc Based Triggers (Usually Dynamic: Eg - Failsafe for P4 start Akylios)
									if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID] then
										if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][KBM.BossID[tUnitID].name] then
											local TriggerObj = KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][KBM.BossID[tUnitID].name]
											if TriggerObj.Enabled then
												KBM.Trigger.Queue:Add(TriggerObj, nil, tUnitID)
											end
										end
									end
								end
							end
						end
					end
				end
			end			
		else
			-- Encounter state is idle, check triggering methods.
			-- This is a fail-safe, and not usually used for Encounter starts.
			if cDetails then
				if not cDetails.player then
					if cDetails.combat then
						if cDetails.health > 0 then
							KBM.CheckActiveBoss(cDetails, cUnitID)
						end
					end
				end
			end		
		end
	end
end

function KBM.MobHeal(info)
	local tUnitID = info.target
	local tDetails = nil
	local cUnitID = info.caster
	local cDetails = nil
	local UnitObj = nil
	if cUnitID then
		if not KBM.Unit.List.UID[cUnitID] then
			KBM.Unit:Idle(cUnitID)
		end
	end
	if tUnitID then
		tDetails = Inspect.Unit.Detail(tUnitID)
		UnitObj = KBM.Unit.List.UID[tUnitID]
		if not UnitObj then
			UnitObj = KBM.Unit:Idle(tUnitID, tDetails)
		end
		UnitObj:HealHandler(info, tDetails)
	end
end

function KBM.RaidDamage(info)
	-- Will be used for DPS Monitoring
	-- Damage done by a Raid member to a Unit
	if KBM.Options.Enabled then
		local tUnitID = info.target
		local tDetails = nil
		local cUnitID = info.caster
		local cDetails = nil
		local UnitObj = nil
		if cUnitID then
			cDetails = Inspect.Unit.Detail(cUnitID)
			if KBM.Unit.List.UID[cUnitID] then
				if cDetails then
					KBM.Unit.List.UID[cUnitID]:Update(cDetails.health, cDetails)
				end
			else
				KBM.Unit:Idle(cUnitID, cDetails)
			end
		end
		if tUnitID then
			UnitObj = KBM.Unit.List.UID[tUnitID]
			tDetails = Inspect.Unit.Detail(tUnitID)
			if not UnitObj then
				UnitObj = KBM.Unit:Idle(tUnitID, tDetails)
			end
			UnitObj:DamageHandler(info, tDetails)
		else
			return
		end
		if KBM.Encounter then
			if KBM.BossID[tUnitID] then
				-- Damage inflicted to a Boss Unit by the Raid.
				-- Update Health etc, checks done to bypass Unit.Health requiring available state.
				-- ********************************************************************
				-- *** TO BE CHANGED DUE TO UNIT TRACKER NOW MONITORING HEALTH DATA ***
				-- ********************************************************************
				if KBM.CurrentMod.ID then
					-- Update Phase Monitor accordingly.
					if KBM.PhaseMonitor.Active then
						if KBM.PhaseMonitor.Objectives.Lists.Percent[UnitObj.Name] then
							KBM.PhaseMonitor.Objectives.Lists.Percent[UnitObj.Name]:Update(KBM.BossID[tUnitID].PercentRaw)
						end
					end
					-- Check for Npc Based Triggers (Usually Dynamic: Eg - Failsafe for P4 start Akylios)
					if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID] then
						if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][UnitObj.Name] then
							local TriggerObj = KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][UnitObj.Name]
							if TriggerObj.Enabled then
								KBM.Trigger.Queue:Add(TriggerObj, nil, tUnitID)
							end
						end
					end
				end
			else
				if tDetails then
					if not tDetails.player then
						if tDetails.combat then
							if tDetails.health > 0 then
								KBM.CheckActiveBoss(tDetails, tUnitID)
							end
						end
					end
				end
			end
		else
			if tDetails then
				if not tDetails.player then
					if tDetails.combat then
						if tDetails.health > 0 then
							KBM.CheckActiveBoss(tDetails, tUnitID)
						end
					end
				end
			end
		end
	end	
end

function KBM.RaidHeal(info)
	local tUnitID = info.target
	local tDetails = nil
	local cUnitID = info.caster
	local cDetails = nil
	local UnitObj = nil
	if cUnitID then
		if not KBM.Unit.List.UID[cUnitID] then
			KBM.Unit:Idle(cUnitID)
		end
	end
	if tUnitID then
		UnitObj = KBM.Unit.List.UID[tUnitID]
		if not UnitObj then
			UnitObj = KBM.Unit:Idle(tUnitID)
		end
		UnitObj:HealHandler(info)
	end
end

function KBM.CPU:Init()
	self.Constant = {
		Width = 150,
		Height = 20,
		Text = 12,
	}
	self.Callbacks = {}
	function self.Callbacks.Position(Type)
		if Type == "end" then
			KBM.Options.CPU.x = KBM.CPU.GUI.Header:GetLeft()
			KBM.Options.CPU.y = KBM.CPU.GUI.Header:GetTop()
		end
	end
	self.GUI = {}
	self.GUI.Header = UI.CreateFrame("Texture", "CPU_Monitor_Header", KBM.Context)
	self.GUI.Header:SetWidth(self.Constant.Width)
	self.GUI.Header:SetHeight(self.Constant.Height)
	KBM.LoadTexture(self.GUI.Header, "KingMolinator", "Media/BarTexture.png")
	self.GUI.Header:SetBackgroundColor(0, 0.35, 0, 0.75)
	if not KBM.Options.CPU.x then
		self.GUI.Header:SetPoint("CENTER", UIParent, "CENTER")
	else
		self.GUI.Header:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.CPU.x, KBM.Options.CPU.y)
	end
	self.GUI.HeadText = UI.CreateFrame("Text", "CPU_Monitor_HText", self.GUI.Header)
	self.GUI.HeadText:SetFontSize(self.Constant.Text)
	self.GUI.HeadText:SetText("KBM CPU Monitor")
	self.GUI.HeadText:SetPoint("CENTER", self.GUI.Header, "CENTER")
	self.GUI.DragFrame = KBM.AttachDragFrame(self.GUI.Header, self.Callbacks.Position, 5)
	self.GUI.Trackers = {}
	self.GUI.LastTracker = self.GUI.Header
	function self:CreateTrack(ID, Name, R, G, B)
		local TrackObj = {
			GUI = {},
			Current = "",
		}
		TrackObj.GUI.Frame = UI.CreateFrame("Frame", Name, self.GUI.Header)
		TrackObj.GUI.Frame:SetBackgroundColor(0,0,0,0.33)
		TrackObj.GUI.Frame:SetPoint("TOPLEFT", self.GUI.LastTracker, "BOTTOMLEFT")
		TrackObj.GUI.Frame:SetPoint("RIGHT", self.GUI.LastTracker, "RIGHT")
		TrackObj.GUI.Frame:SetHeight(self.Constant.Height)
		TrackObj.GUI.Text = UI.CreateFrame("Text", Name.."_Text", TrackObj.GUI.Frame)
		TrackObj.GUI.Text:SetText(Name)
		TrackObj.GUI.Text:SetFontSize(self.Constant.Text)
		TrackObj.GUI.Text:SetPoint("CENTERLEFT", TrackObj.GUI.Frame, "CENTERLEFT", 2, 0)
		TrackObj.GUI.Data = UI.CreateFrame("Text", Name.."_Data", TrackObj.GUI.Frame)
		TrackObj.GUI.Data:SetText("0")
		TrackObj.GUI.Data:SetFontColor(R, G, B)
		TrackObj.GUI.Data:SetFontSize(self.Constant.Text)
		TrackObj.GUI.Data:SetPoint("CENTERRIGHT", TrackObj.GUI.Frame, "CENTERRIGHT", -2, 0)
		function TrackObj:UpdateDisplay(New)
			New = tonumber(New) or 0
			NewString = string.format("%0.1f%%", New)
			if NewString ~= self.Current then
				if New < 10 then
					self.GUI.Data:SetFontColor(0.2, 0.9, 0.2)
				elseif New < 30 then
					self.GUI.Data:SetFontColor(0.9, 0.5, 0.35)
				else
					self.GUI.Data:SetFontColor(0.9, 0.2, 0.2)
				end
				self.GUI.Data:SetText(NewString)
				self.Current = NewString
			end
		end
		self.GUI.Trackers[ID] = TrackObj
		self.GUI.LastTracker = TrackObj.GUI.Frame
	end
	self:CreateTrack("KingMolinator", "KBM", 0.9, 0.5, 0.35)
	self:CreateTrack("Rift", "Rift", 0.9, 0.5, 0.35)
	self:CreateTrack("SafesRaidManager", "SRM", 0.9, 0.5, 0.35)
	if KBM.PlugIn.List["KBMMarkIt"] then
		self:CreateTrack("KBMMarkIt", "KBM: Mark-It", 0.9, 0.5, 0.35)
	end
	if KBM.PlugIn.List["KBMAddWatch"] then
		self:CreateTrack("KBMAddWatch", "KBM: AddWatch", 0.9, 0.5, 0.35)
	end
	self:CreateTrack("NonKBM", "Other Addons", 0.9, 0.5, 0.35)
	function self:UpdateAll()
		local CPUTable = Inspect.Addon.Cpu()
		local Others = 0
		for AddonID, SubTable in pairs(CPUTable) do
			if self.GUI.Trackers[AddonID] then
				local Total = 0
				for ID, Data in pairs(SubTable) do
					if type(Data) == "number" then
						Total = Total + Data
					elseif type(Data) == "table" then
						for ID, SubData in pairs(Data) do
							if type(SubData) == "number" then
								Total = Total + SubData
							end
						end
					end
				end
				self.GUI.Trackers[AddonID]:UpdateDisplay(Total * 100)
			else
				for ID, Data in pairs(SubTable) do
					if type(Data) == "number" then
						Others = Others + Data
					end
				end
			end
		end
		self.GUI.Trackers["NonKBM"]:UpdateDisplay(Others * 100)
	end
	local CPUTable = Inspect.Addon.Cpu()
end

function KBM.CPU:Toggle(Silent)
	if not Silent then
		if KBM.Options.CPU.Enabled then
			KBM.Options.CPU.Enabled = false
		else
			KBM.Options.CPU.Enabled = true
		end
	end
	if KBM.Options.CPU.Enabled then
		if not self.GUI then
			self:Init()
		end
		self.GUI.Header:SetVisible(true)
	else
		if self.GUI then
			self.GUI.Header:SetVisible(false)
		end
	end
end

function KBM.Unit:GetObject(UnitID)
	return KBM.Unit.List.UID[UnitID]
end

function KBM.Unit:Create(uDetails, UnitID)
	if type(UnitID) == "string" then
		local UnitObj = {
			Available = false,
			Loaded = false,
			UnitID = UnitID,
			Name = "< Unknown >",
			Details = uDetails,
			Percent = 100,
			PercentRaw = 100.0,
			UsedBy = {},
			TargetCount = 0,
			TargetList = {},
			Type = "Unit",
		}
		function UnitObj:UpdateIdle(mode)
			if self.Time then
				if KBM.Unit.UIDs.Flush[self.Time][self.UnitID] then
					KBM.Unit.UIDs.Flush[self.Time][self.UnitID] = nil
				end
				self.Time = nil
			end
			if not mode then
				local Number = math.ceil(Inspect.Time.Real() / 15) + 1
				self.Time = Number
				if not KBM.Unit.UIDs.Flush[Number] then
					KBM.Unit.UIDs.Flush[Number] = {}
				end
				KBM.Unit.UIDs.Flush[Number][UnitID] = self
			end
		end
		function UnitObj:Update(NewHP, uDetails)
			self:CheckTarget()
			if self.Loaded then
				self.Health = NewHP
				if NewHP then
					if self.HealthMax then
						self.PercentFlat = (self.Health/self.HealthMax)
						self.PercentRaw = self.PercentFlat*100
						if self.PercentRaw ~= self.LastPercentRaw then
							self.Percent = math.ceil(self.PercentRaw)
							self.LastPercentRaw = self.PercentRaw
							KBM.Event.Unit.PercentChange(self.UnitID)
							KBM.UpdateHP(self)
						end
					end
				end
				if uDetails then
					self.Details = uDetails
					if self.Mark ~= uDetails.mark then
						self.Mark = uDetails.mark
						KBM.Event.Mark(self.Mark, self.UnitID)
					end
					if self.Relation ~= uDetails.relation then
						self:SetRelation(uDetails.relation)
					end
					if self.Calling ~= uDetails.calling then
						if uDetails.calling then
							self.Calling = uDetails.calling
							KBM.Event.Unit.Calling(self.UnitID, uDetails.calling)
						end
					end
				end
				if KBM.Encounter then
					if KBM.BossID[self.UnitID] then
						KBM.BossID[self.UnitID].Health = self.Health
						KBM.BossID[self.UnitID].HealthLast = self.Health
						KBM.BossID[self.UnitID].PercentRaw = self.PercentRaw
						KBM.BossID[self.UnitID].Percent = self.Percent
						if KBM.BossID[self.UnitID].Percent ~= KBM.BossID[self.UnitID].PercentLast then
							if KBM.Trigger.Percent[KBM.CurrentMod.ID] then
								if KBM.Trigger.Percent[KBM.CurrentMod.ID][self.Name] then
									if KBM.BossID[self.UnitID].PercentLast - KBM.BossID[self.UnitID].Percent > 1 then
										for PCycle = KBM.BossID[self.UnitID].PercentLast, KBM.BossID[self.UnitID].Percent, -1 do
											if KBM.Trigger.Percent[KBM.CurrentMod.ID][self.Name][PCycle] then
												TriggerObj = KBM.Trigger.Percent[KBM.CurrentMod.ID][self.Name][PCycle]
												KBM.Trigger.Queue:Add(TriggerObj, nil, self.UnitID)
											end
										end
									else
										if KBM.Trigger.Percent[KBM.CurrentMod.ID][self.Name][self.Percent] then
											TriggerObj = KBM.Trigger.Percent[KBM.CurrentMod.ID][self.Name][self.Percent]
											KBM.Trigger.Queue:Add(TriggerObj, nil, self.UnitID)
										end
									end
								end
							end
							KBM.BossID[self.UnitID].PercentLast = KBM.BossID[self.UnitID].Percent
						end
					end
				end
			end
		end
		function UnitObj:SetHealthMax(NewMHP)
			if NewMHP then
				if NewMHP == true then
					NewMHP = self.Health
				end
				self.HealthMax = NewMHP
				if (self.Name and self.Health and self.HealthMax) ~= nil then
					self.Loaded = true
					self:Update(self.Health)
				end
			end
		end
		function UnitObj:DamageHandler(DamageObj, uDetails)
			if self.Loaded then
				if self.Available == true then
					if uDetails then
						self.Details = uDetails
						if uDetails.healthMax then
							self.HealthMax = uDetails.healthMax
						end
						if uDetails.health then
							self:Update(uDetails.health, uDetails)
							return
						end
					end
				elseif self.Time then
					self:UpdateIdle()
				end
				-- if self.Health then
					-- if self.HealthMax then
						-- if DamageObj.damage then
							-- self.Health = self.Health - DamageObj.damage
							-- if self.Health < 0 then
								-- self.Health = 0
							-- end
						-- end
						-- if DamageObj.overkill then
							-- self.Health = 0
						-- end
						-- self.PercentFlat = (self.Health/self.HealthMax)
						-- self.PercentRaw = self.PercentFlat*100
						-- if self.PercentRaw ~= self.LastPercentRaw then
							-- self.Percent = math.ceil(self.PercentRaw)
							-- self.LastPercentRaw = self.PercentRaw
							-- KBM.Event.Unit.PercentChange(self.UnitID)
							-- KBM.UpdateHP(self)
						-- end
					-- end
				-- end
			elseif self.Time then
				self:UpdateIdle()
			end
		end
		function UnitObj:HealHandler(HealObj, uDetails)
			if self.Loaded then
				if self.Available == true then
					if uDetails then
						self.Details = uDetails
						if uDetails.healthMax then
							self.HealthMax = uDetails.healthMax
						end
						if uDetails.health then
							self:Update(uDetails.health, uDetails)
							return
						end
					end
				elseif self.Time then
					self:UpdateIdle()
				end
				-- if self.Health then
					-- if self.HealthMax then
						-- if not HealObj.heal then
							-- HealObj.heal = 0
							-- self.Health = self.Health + HealObj.heal
							-- if self.Health > self.HealthMax then
								-- self.Health = self.HealthMax
							-- end
						-- end
						-- if self.Dead then
							-- self.Dead = false
						-- end
						-- self.PercentFlat = (self.Health/self.HealthMax)
						-- self.PercentRaw = self.PercentFlat*100
						-- if self.PercentRaw ~= self.LastPercentRaw then
							-- self.Percent = math.ceil(self.PercentRaw)
							-- self.LastPercentRaw = self.PercentRaw
							-- KBM.Event.Unit.PercentChange(self.UnitID)
							-- KBM.UpdateHP(self)
						-- end
					-- end
				-- end
			elseif self.Time then
				self:UpdateIdle()
			end
		end
		function UnitObj:SetRelation(Relation)
			if (self.Relation ~= Relation) and Relation ~= nil then
				if self.Group ~= nil then
					if KBM.Unit[self.Group] then
						if KBM.Unit[self.Group][self.Relation] then
							KBM.Unit[self.Group][self.Relation][UnitID] = nil
						end
					end
				end
				self.Relation = Relation
				KBM.Event.Unit.Relation(UnitID, self.Relation)
			elseif self.Relation == nil then
				if LibSRM.Group.UnitExists(self.UnitID) then
					self.Relation = "friendly"
					KBM.Event.Unit.Relation(UnitID, self.Relation)
				else
					self.Relation = "unknown"			
				end
			end
		end
		function UnitObj:CheckTarget()
			if self.UnitID ~= KBM.Player.UnitID then
				local cTarget = Inspect.Unit.Lookup(self.UnitID..".target")
				if cTarget ~= self.Target then
					self.Target = cTarget
					KBM.Event.Unit.Target(self.UnitID, self.Target)
				end
			end
		end
		function UnitObj:UpdateData(uDetails)
			if uDetails then
				self:SetRelation(uDetails.relation)
				if uDetails.player then
					self:SetGroup("Player")
					self.Player = true
				else
					self:SetGroup("NPC")
					self.Player = false
				end
				self.Offline = uDetails.offline
				self.Details = uDetails
				self.HealthMax = uDetails.healthMax
				self.Health = uDetails.health
				self.Availability = uDetails.availability
				self.Available = true
				self.Loaded = true
				if self.HealthMax ~= nil and self.Health ~= nil and self.Name ~= nil then
					if self.Health > 0 then
						self.Dead = false
					else
						self.Dead = true
					end
					self.PercentFlat = (self.Health/self.HealthMax)
					self.PercentRaw = self.PercentFlat*100
					self.Percent = math.ceil(self.PercentRaw)
				else
					self.Dead = true
					self.PercentFlat = 0
					self.PercentRaw = 0
					self.Percent = 0
				end
				self.Mark = uDetails.mark
				KBM.Event.Mark(uDetails.mark, UnitID)
				if self.Calling ~= uDetails.calling then
					if uDetails.calling then
						self.Calling = uDetails.calling
						KBM.Event.Unit.Calling(self.UnitID, self.Calling)
					end
				end
				self:CheckTarget()
				self:SetName(uDetails.name)
			else
				if not self.Group then
					if self.Relation ~= "unknown" then
						if self.Relation == nil then
							self.Relation = "unknown"
						end
					end
					self:SetGroup()
					self:SetName()
				end
			end
		end
		function UnitObj:SetGroup(Group)
			if not Group then
				Group = "Unknown"
			end
			if self.Group ~= Group then
				if self.Group ~= nil then
					KBM.Unit[self.Group].Count = KBM.Unit[self.Group].Count - 1
					KBM.Unit[self.Group][self.Relation][self.UnitID] = nil					
					KBM.Unit[self.Group][self.UnitID] = nil
				end
				self.Group = Group
				KBM.Unit[Group][self.Relation][self.UnitID] = self				
				KBM.Unit[Group][self.UnitID] = self
				KBM.Unit[Group].Count = KBM.Unit[Group].Count + 1
			end
		end
		function UnitObj:SetName(Name)
			if type(Name) == "string" and Name ~= "" then
				if self.Name ~= Name then
					if self.Name ~= nil then
						if KBM.Unit.List.Name[self.Name] then
							if KBM.Unit.List.Name[self.Name][self.UnitID] then
								KBM.Unit.List.Name[self.Name][self.UnitID] = nil
							end
						end
					end
					self.Name = Name
					if not KBM.Unit.List.Name[Name] then
						KBM.Unit.List.Name[Name] = {}
					end
					KBM.Unit.List.Name[Name][self.UnitID] = self
					if not self.Loaded then
						self.Loaded = true
					end
					KBM.Event.Unit.Name(self.UnitID, Name)
				end
			else
				if self.Name == nil then
					self.Name = "<Unknown>"
					Name = "< Unknown >"
					if not KBM.Unit.List.Name[Name] then
						KBM.Unit.List.Name[Name] = {}
					end
					KBM.Unit.List.Name[Name][self.UnitID] = self
				end
			end
		end
		self.List.UID[UnitID] = UnitObj
		UnitObj:UpdateData(uDetails)
		return UnitObj
	end
end

KBM.Unit.Debug = {}
function KBM.Unit.Debug:Init()
	self.Constant = {
		Width = 150,
		Height = 20,
		Text = 12,
	}
	self.Callbacks = {}
	function self.Callbacks.Position(Type)
		if Type == "end" then
			KBM.Options.DebugSettings.x = KBM.Unit.Debug.GUI.Header:GetLeft()
			KBM.Options.DebugSettings.y = KBM.Unit.Debug.GUI.Header:GetTop()
		end
	end
	self.GUI = {}
	self.GUI.Header = UI.CreateFrame("Texture", "Unit_Tracking_Debug_Header", KBM.Context)
	self.GUI.Header:SetWidth(self.Constant.Width)
	self.GUI.Header:SetHeight(self.Constant.Height)
	KBM.LoadTexture(self.GUI.Header, "KingMolinator", "Media/BarTexture.png")
	self.GUI.Header:SetBackgroundColor(0.5, 0, 0, 0.75)
	if not KBM.Options.DebugSettings.x then
		self.GUI.Header:SetPoint("CENTER", UIParent, "CENTER")
	else
		self.GUI.Header:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.DebugSettings.x, KBM.Options.DebugSettings.y)
	end
	self.GUI.HeadText = UI.CreateFrame("Text", "Unit_Tracking_Debug_HText", self.GUI.Header)
	self.GUI.HeadText:SetFontSize(self.Constant.Text)
	self.GUI.HeadText:SetText("Unit Tracker")
	self.GUI.HeadText:SetPoint("CENTER", self.GUI.Header, "CENTER")
	self.GUI.DragFrame = KBM.AttachDragFrame(self.GUI.Header, self.Callbacks.Position, 5)
	self.GUI.Trackers = {}
	self.GUI.LastTracker = self.GUI.Header
	function self:CreateTrack(Name, R, G, B)
		local TrackObj = {
			GUI = {},
		}
		TrackObj.GUI.Frame = UI.CreateFrame("Frame", Name, self.GUI.Header)
		TrackObj.GUI.Frame:SetBackgroundColor(0,0,0,0.33)
		TrackObj.GUI.Frame:SetPoint("TOPLEFT", self.GUI.LastTracker, "BOTTOMLEFT")
		TrackObj.GUI.Frame:SetPoint("RIGHT", self.GUI.LastTracker, "RIGHT")
		TrackObj.GUI.Frame:SetHeight(self.Constant.Height)
		TrackObj.GUI.Text = UI.CreateFrame("Text", Name.."_Text", TrackObj.GUI.Frame)
		TrackObj.GUI.Text:SetText(Name)
		TrackObj.GUI.Text:SetFontSize(self.Constant.Text)
		TrackObj.GUI.Text:SetPoint("CENTERLEFT", TrackObj.GUI.Frame, "CENTERLEFT", 2, 0)
		TrackObj.GUI.Data = UI.CreateFrame("Text", Name.."_Data", TrackObj.GUI.Frame)
		TrackObj.GUI.Data:SetText("0")
		TrackObj.GUI.Data:SetFontColor(R, G, B)
		TrackObj.GUI.Data:SetFontSize(self.Constant.Text)
		TrackObj.GUI.Data:SetPoint("CENTERRIGHT", TrackObj.GUI.Frame, "CENTERRIGHT", -2, 0)
		function TrackObj:UpdateDisplay(New)
			self.GUI.Data:SetText(tostring(New))
		end
		self.GUI.Trackers[Name] = TrackObj
		self.GUI.LastTracker = TrackObj.GUI.Frame
	end
	self:CreateTrack("Idle", 0.9, 0.5, 0.35)
	self:CreateTrack("Available", 0, 0.9, 0)
	self:CreateTrack("Total States", 1, 1, 1)
	self:CreateTrack("Unknown", 1, 0.7, 0.7)
	self:CreateTrack("Players", 0.7, 1, 0.7)
	self:CreateTrack("NPCs", 0.7, 0.7, 1)
	self:CreateTrack("Total Groups", 1, 1, 1)
	self:CreateTrack("Raid Size", 0, 0.9, 0)
	function self:UpdateAll()
		self.GUI.Trackers["Idle"]:UpdateDisplay(KBM.Unit.UIDs.Count.Idle)
		self.GUI.Trackers["Available"]:UpdateDisplay(KBM.Unit.UIDs.Count.Available)		
		self.GUI.Trackers["Total States"]:UpdateDisplay(KBM.Unit.UIDs.Count.Idle + KBM.Unit.UIDs.Count.Available)
		self.GUI.Trackers["Unknown"]:UpdateDisplay(KBM.Unit.Unknown.Count)
		self.GUI.Trackers["Players"]:UpdateDisplay(KBM.Unit.Player.Count)
		self.GUI.Trackers["NPCs"]:UpdateDisplay(KBM.Unit.NPC.Count)		
		self.GUI.Trackers["Total Groups"]:UpdateDisplay(KBM.Unit.Unknown.Count + KBM.Unit.Player.Count + KBM.Unit.NPC.Count)
		self.GUI.Trackers["Raid Size"]:UpdateDisplay(tostring(LibSRM.GroupCount()) or 0)
	end
end

function KBM.Unit.Debug:DumpAvail()
	for UnitID, UnitObj in pairs(KBM.Unit.UIDs.Available) do
		print(tostring(UnitID)..": "..tostring(UnitObj.Name))
		dump(UnitObj.Details.name)
	end
end

function KBM.Unit:Available(uDetails, UnitID)
	if uDetails then
		if not self.List.UID[UnitID] then
			UnitObj = self:Create(uDetails, UnitID)
		else
			UnitObj = self.List.UID[UnitID]
			UnitObj:UpdateData(uDetails)
		end		
		if self.TargetQueue[UnitID] then
			KBM.GroupTarget(self.TargetQueue[UnitID], UnitID)
			self.TargetQueue[UnitID] = nil
		end
		if (self.UIDs.Available[UnitID] == nil) and (self.UIDs.Idle[UnitID] == nil) then
			self.UIDs.Available[UnitID] = UnitObj
			self.UIDs.Count.Available = self.UIDs.Count.Available + 1
			if uDetails.type then
				if not self.List.Type[uDetails.type] then
					self.List.Type[uDetails.type] = {}
				end
				self.List.Type[uDetails.type][UnitID] = UnitObj
			end
			if KBM.Debug then
				self.Debug:UpdateAll()
			end
			self.UIDs.Available[UnitID].Available = true
			KBM.Event.Unit.Available(UnitObj)
			return UnitObj		
		else
			if self.UIDs.Idle[UnitID] then
				self.UIDs.Available[UnitID] = self.List.UID[UnitID]
				self.UIDs.Idle[UnitID] = nil
				self.UIDs.Count.Idle = self.UIDs.Count.Idle - 1
				self.UIDs.Count.Available = self.UIDs.Count.Available + 1
				self.UIDs.Available[UnitID]:UpdateIdle(true)
				self.UIDs.Available[UnitID].Time = nil
				self.UIDs.Available[UnitID].Available = true
				KBM.Event.Unit.Available(UnitObj)
			end
			if KBM.Debug then
				self.Debug:UpdateAll()
			end
			return UnitObj		
		end	
	else
		UnitObj = self:Idle(UnitID)
		if KBM.Debug then
			self.Debug:UpdateAll()
		end
		return UnitObj
	end

end

function KBM.Unit:Update(uDetails, UnitID)
	if self.List.UID[UnitID] then
		self.List.UID[UnitID]:UpdateData(uDetails)
		return self.List.UID[UnitID]
	else
		if not uDetails then
			uDetails = Inspect.Unit.Detail(UnitID)
		end
		return self:Idle(UnitID, uDetails)
	end
end

function KBM.Unit:Idle(UnitID, Details)
	local Number = 0
	if UnitID then
		if self.List.UID[UnitID] then
			self.List.UID[UnitID]:CheckTarget()
		end
	end
	if self.UIDs.Available[UnitID] then
		self.UIDs.Idle[UnitID] = self.List.UID[UnitID]
		self.UIDs.Available[UnitID] = nil
		self.UIDs.Idle[UnitID].Available = false
		self.UIDs.Count.Idle = self.UIDs.Count.Idle + 1
		self.UIDs.Count.Available = self.UIDs.Count.Available - 1
		if KBM.Debug then
			self.Debug:UpdateAll()
		end
		self.UIDs.Idle[UnitID]:UpdateIdle()
		KBM.Event.Mark(false, UnitID)
		KBM.Event.Unit.Unavailable(UnitID)
		return self.List.UID[UnitID]
	else
		if self.List.UID[UnitID] == nil then
			self:Create(Details, UnitID)
			if not self.UIDs.Idle[UnitID] then
				self.UIDs.Idle[UnitID] = self.List.UID[UnitID]
				self.UIDs.Count.Idle = self.UIDs.Count.Idle + 1
			end
			self.UIDs.Idle[UnitID]:UpdateIdle()
			self.UIDs.Idle[UnitID].Available = false
			KBM.Event.Mark(false, UnitID)
			KBM.Event.Unit.Unavailable(UnitID)
			return self.List.UID[UnitID]
		else
			if not self.UIDs.Idle[UnitID] then
				self.UIDs.Idle[UnitID] = self.List.UID[UnitID]
				self.UIDs.Count.Idle = self.UIDs.Count.Idle + 1				
			end
			self.UIDs.Idle[UnitID].Available = false
			self.UIDs.Idle[UnitID]:UpdateIdle()
			KBM.Event.Mark(false, UnitID)
			KBM.Event.Unit.Unavailable(UnitID)
			return self.List.UID[UnitID]
		end
	end
end

function KBM.Unit:CheckIdle(CurrentTime)
	local CompTime = math.floor(CurrentTime / 15)
	if self.UIDs.Flush[CompTime] then
		for UnitID, UnitObj in pairs(self.UIDs.Flush[CompTime]) do
			if not self.RaidTargets[UnitID] then
				if self.UIDs.Idle[UnitID] then
						self.UIDs.Idle[UnitID] = nil
						self.UIDs.Count.Idle = self.UIDs.Count.Idle - 1
				end
				self[UnitObj.Group].Count = self[UnitObj.Group].Count - 1
				self[UnitObj.Group][UnitObj.Relation][UnitID] = nil				
				self[UnitObj.Group][UnitID] = nil
				KBM.IgnoreList[UnitID] = nil
				if self.List.Name[UnitObj.Name] then
					self.List.Name[UnitObj.Name][UnitID] = nil
				end
				if UnitObj.Type then
					if self.List.Type[UnitObj.Type] then
						self.List.Type[UnitObj.Type][UnitID] = nil
					end
				end
				self.List.UID[UnitID] = nil
				KBM.Event.Unit.Remove(UnitID)
			else
				self.List.UID[UnitID]:UpdateIdle()
			end
		end
		self.UIDs.Flush[CompTime] = nil
		if KBM.Debug then
			self.Debug:UpdateAll()
		end
	end
end

function KBM.Unit:Death(UnitID)
	if self.List.UID[UnitID] then
		if not self.List.UID[UnitID].Dead then
			self.List.UID[UnitID].Dead = true
			self.List.UID[UnitID].Health = 0
			self.List.UID[UnitID].PercentRaw = 0
			self.List.UID[UnitID].Percent = 0
		end
	else
		self:Idle(UnitID)
		self.List.UID[UnitID].Dead = true
		self.List.UID[UnitID].Health = 0
		self.List.UID[UnitID].PercentRaw = 0
		self.List.UID[UnitID].Percent = 0
	end
	self.List.UID[UnitID]:CheckTarget()
	KBM.Event.Unit.Death(UnitID)
end

local function KBM_UnitAvailable(units)
	-- local TimeStore = Inspect.Time.Real()
	if KBM.Encounter then
		for UnitID, Specifier in pairs(units) do
			if Specifier then
				local uDetails = Inspect.Unit.Detail(UnitID)
				local UnitObj = KBM.Unit:Available(uDetails, UnitID)
				if uDetails then
					if not uDetails.player then					
						KBM.CheckActiveBoss(uDetails, UnitID)
					end
				end
			end
		end
	else
		for UnitID, Specifier in pairs(units) do
			if Specifier then
				local uDetails = Inspect.Unit.Detail(UnitID)
				local UnitObj = KBM.Unit:Available(uDetails, UnitID)
			end
		end	
	end
	-- local TimeEllapsed = tonumber(string.format("%0.5f", Inspect.Time.Real() - TimeStore))
	-- KBM.Watchdog.Avail.Count = KBM.Watchdog.Avail.Count + 1
	-- KBM.Watchdog.Avail.Total = KBM.Watchdog.Avail.Total + TimeEllapsed
	-- if KBM.Watchdog.Avail.Peak < TimeEllapsed then
		-- KBM.Watchdog.Avail.Peak = TimeEllapsed
	-- end	
	-- local TimeLeft = Inspect.System.Watchdog()
	-- if KBM.Watchdog.Avail.wTime > TimeLeft then
		-- KBM.Watchdog.Avail.wTime = TimeLeft
	-- end
end

function KBM.AttachDragFrame(parent, hook, name, layer)
	if not name then name = "" end
	if not layer then layer = 0 end
	
	local Drag = {}
	Drag.Frame = UI.CreateFrame("Frame", "Drag Frame", parent)
	Drag.Frame:SetPoint("TOPLEFT", parent, "TOPLEFT")
	Drag.Frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT")
	Drag.Frame.parent = parent
	Drag.Frame.MouseDown = false
	Drag.Frame:SetLayer(layer)
	Drag.hook = hook
	
	function Drag.Frame.Event:LeftDown()
		self.MouseDown = true
		mouseData = Inspect.Mouse()
		self.MyStartX = self.parent:GetLeft()
		self.MyStartY = self.parent:GetTop()
		self.StartX = mouseData.x - self.MyStartX
		self.StartY = mouseData.y - self.MyStartY
		tempX = self.parent:GetLeft()
		tempY = self.parent:GetTop()
		tempW = self.parent:GetWidth()
		tempH =	self.parent:GetHeight()
		self.parent:ClearAll()
		self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", tempX, tempY)
		self.parent:SetWidth(tempW)
		self.parent:SetHeight(tempH)
		self:SetBackgroundColor(0,0,0,0.5)
		Drag.hook("start")
	end
	
	function Drag.Frame.Event:MouseMove(mouseX, mouseY)
		if self.MouseDown then
			self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", (mouseX - self.StartX), (mouseY - self.StartY))
		end
	end
	
	function Drag.Frame.Event:LeftUp()
		if self.MouseDown then
			self.MouseDown = false
			self:SetBackgroundColor(0,0,0,0)
			Drag.hook("end")
		end
	end
	
	function Drag.Frame:Remove()	
		self.Event.LeftDown = nil
		self.Event.MouseMove = nil
		self.Event.LeftUp = nil
		Drag.hook = nil
		self:sRemove()
		self.Remove = nil		
	end	
	return Drag.Frame
end

function KBM.TankSwap:Pull()
	local GUI = {}
	if #self.TankStore > 0 then
		GUI = table.remove(self.TankStore)
		GUI.TankAggro.Texture:SetVisible(false)
		for i = 1, 2 do
			GUI.DebuffFrame[i].Texture:SetVisible(false)
			KBM.LoadTexture(GUI.DebuffFrame[i].Texture, "Rift", self.DefaultTexture)
			GUI.DeCoolFrame[i]:SetVisible(false)
		end
	else
		GUI.Frame = UI.CreateFrame("Frame", "TankSwap_Frame", KBM.Context)
		GUI.Frame:SetLayer(1)
		GUI.Frame:SetHeight(KBM.Options.TankSwap.h)
		GUI.Frame:SetBackgroundColor(0,0,0,0.33)
		GUI.TankAggro = UI.CreateFrame("Frame", "TankSwap_Aggro_Frame", GUI.Frame)
		GUI.TankAggro:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
		GUI.TankAggro:SetHeight(math.floor(GUI.Frame:GetHeight() * 0.5))
		GUI.TankAggro:SetWidth(GUI.TankAggro:GetHeight())
		GUI.TankAggro:SetBackgroundColor(0,0,0,0)
		GUI.TankAggro.Texture = UI.CreateFrame("Texture", "TankSwap_Aggro_Texture", GUI.TankAggro)
		GUI.TankAggro.Texture:SetPoint("TOPLEFT", GUI.TankAggro, "TOPLEFT", 1, 1)
		GUI.TankAggro.Texture:SetPoint("BOTTOMRIGHT", GUI.TankAggro, "BOTTOMRIGHT", -1, -1)
		KBM.LoadTexture(GUI.TankAggro.Texture, "Rift", self.AggroTexture)
		GUI.TankAggro.Texture:SetAlpha(0.66)
		GUI.TankAggro.Texture:SetVisible(false)
		GUI.Dead = UI.CreateFrame("Texture", "TankSwap_Dead", GUI.TankAggro)
		KBM.LoadTexture(GUI.Dead, "KingMolinator", "Media/KBM_Death.png")
		GUI.Dead:SetLayer(1)
		GUI.Dead:SetPoint("TOPLEFT", GUI.TankAggro, "TOPLEFT", 1, 1)
		GUI.Dead:SetPoint("BOTTOMRIGHT", GUI.TankAggro, "BOTTOMRIGHT", -1, -1)
		GUI.Dead:SetAlpha(0.8)
		GUI.TankFrame = UI.CreateFrame("Frame", "TankSwap_Tank_Frame", GUI.Frame)
		GUI.TankFrame:SetPoint("TOPLEFT", GUI.TankAggro, "TOPRIGHT")
		GUI.TankFrame:SetPoint("BOTTOM", GUI.TankAggro, "BOTTOM")
		GUI.TankFrame:SetPoint("RIGHT", GUI.Frame, "RIGHT")
		GUI.TankHP = UI.CreateFrame("Texture", "TankSwap_Tank_HPFrame", GUI.TankFrame)
		KBM.LoadTexture(GUI.TankHP, "KingMolinator", "Media/BarTexture.png")
		GUI.TankHP:SetLayer(1)
		GUI.TankHP:SetBackgroundColor(0,0.8,0,0.33)
		GUI.TankHP:SetPoint("TOP", GUI.TankFrame, "TOP")
		GUI.TankHP:SetPoint("LEFT", GUI.TankFrame, "LEFT")
		GUI.TankHP:SetPoint("BOTTOM", GUI.TankFrame, "BOTTOM")
		GUI.TankHP:SetWidth(GUI.TankFrame:GetWidth())
		GUI.TankShadow = UI.CreateFrame("Text", "TankSwap_Tank_Shadow", GUI.TankFrame)
		GUI.TankShadow:SetFontSize(KBM.Options.TankSwap.TextSize)
		GUI.TankShadow:SetLayer(2)
		GUI.TankShadow:SetFontColor(0,0,0)
		GUI.TankText = UI.CreateFrame("Text", "TankSwap_Tank_Text", GUI.TankFrame)
		GUI.TankText:SetLayer(3)
		GUI.TankText:SetFontSize(KBM.Options.TankSwap.TextSize)
		GUI.TankShadow:SetPoint("TOPLEFT", GUI.TankText, "TOPLEFT", 1, 1)
		GUI.TankText:SetPoint("CENTERLEFT", GUI.TankFrame, "CENTERLEFT", 2, 0)
		GUI.DebuffFrame = {}
		GUI.DeCoolFrame = {}
		GUI.DeCool = {}
		for i = 1, 2 do
			GUI.DebuffFrame[i] = UI.CreateFrame("Frame", "TankSwap_Debuff_Frame_"..i, GUI.Frame)
			GUI.DebuffFrame[i]:SetPoint("BOTTOMLEFT", GUI.Frame, "BOTTOMLEFT")
			GUI.DebuffFrame[i]:SetWidth(math.floor(GUI.Frame:GetHeight() * 0.5))
			GUI.DebuffFrame[i]:SetHeight(GUI.DebuffFrame[i]:GetWidth())
			GUI.DebuffFrame[i]:SetBackgroundColor(0,0,0,0)
			GUI.DebuffFrame[i]:SetLayer(1)
			GUI.DebuffFrame[i].Texture = UI.CreateFrame("Texture", "TankSwap_Debuff_Texture_"..i, GUI.DebuffFrame[i])
			GUI.DebuffFrame[i].Texture:SetPoint("TOPLEFT", GUI.DebuffFrame[i], "TOPLEFT")
			GUI.DebuffFrame[i].Texture:SetPoint("BOTTOMRIGHT", GUI.DebuffFrame[i], "BOTTOMRIGHT")
			GUI.DebuffFrame[i].Texture:SetAlpha(0.33)
			KBM.LoadTexture(GUI.DebuffFrame[i].Texture, "Rift", self.DefaultTexture)
			GUI.DebuffFrame[i].Texture:SetVisible(false)
			GUI.DebuffFrame[i].Shadow = UI.CreateFrame("Text", "TankSwap_Debuff_Shadow_"..i, GUI.DebuffFrame[i])
			GUI.DebuffFrame[i].Shadow:SetFontSize(KBM.Options.TankSwap.TextSize)
			GUI.DebuffFrame[i].Shadow:SetFontColor(0,0,0)
			GUI.DebuffFrame[i].Shadow:SetLayer(2)
			GUI.DebuffFrame[i].Text = UI.CreateFrame("Text", "TankSwap_Debuff_Text_"..i, GUI.DebuffFrame[i])
			GUI.DebuffFrame[i].Text:SetFontSize(KBM.Options.TankSwap.TextSize)
			GUI.DebuffFrame[i].Text:SetLayer(3)
			GUI.DebuffFrame[i].Shadow:SetPoint("TOPLEFT", GUI.DebuffFrame[i].Text, "TOPLEFT", 1, 1)
			GUI.DebuffFrame[i].Text:SetPoint("CENTER", GUI.DebuffFrame[i], "CENTER")
			GUI.DeCoolFrame[i] = UI.CreateFrame("Texture", "TankSwap_CDFrame", GUI.Frame)
			GUI.DeCoolFrame[i]:SetPoint("TOPLEFT", GUI.DebuffFrame[i], "TOPRIGHT")
			GUI.DeCoolFrame[i]:SetPoint("BOTTOM", GUI.DebuffFrame[i], "BOTTOM")
			GUI.DeCoolFrame[i]:SetPoint("RIGHT", GUI.Frame, "RIGHT")
			GUI.DeCoolFrame[i]:SetBackgroundColor(0,0,0,0.33)
			GUI.DeCool[i] = UI.CreateFrame("Texture", "TankSwap_CD_Progress_"..i, GUI.DeCoolFrame[i])
			KBM.LoadTexture(GUI.DeCool[i], "KingMolinator", "Media/BarTexture.png")
			GUI.DeCool[i]:SetPoint("TOPLEFT", GUI.DeCoolFrame[i], "TOPLEFT")
			GUI.DeCool[i]:SetPoint("BOTTOM", GUI.DeCoolFrame[i], "BOTTOM")
			GUI.DeCool[i]:SetWidth(0)
			GUI.DeCool[i]:SetBackgroundColor(0.5,0,8,0.33)
			GUI.DeCool[i].Shadow = UI.CreateFrame("Text", "TankSwap_CD_Shadow_"..i, GUI.DeCoolFrame[i])
			GUI.DeCool[i].Shadow:SetFontSize(KBM.Options.TankSwap.TextSize)
			GUI.DeCool[i].Shadow:SetFontColor(0,0,0)
			GUI.DeCool[i].Shadow:SetLayer(2)
			GUI.DeCool[i].Text = UI.CreateFrame("Text", "TankSwap_CD_Text_"..i, GUI.DeCoolFrame[i])
			GUI.DeCool[i].Text:SetFontSize(KBM.Options.TankSwap.TextSize)
			GUI.DeCool[i].Shadow:SetPoint("TOPLEFT", GUI.DeCool[i].Text, "TOPLEFT", 1, 1)
			GUI.DeCool[i].Text:SetPoint("CENTER", GUI.DeCoolFrame[i], "CENTER")
			GUI.DeCool[i].Text:SetLayer(3)
		end
		function GUI:SetTank(Text)
			self.TankShadow:SetText(Text)
			self.TankText:SetText(Text)
		end
		function GUI:SetDeCool(Text, iBuff)
			self.DeCool[iBuff].Shadow:SetText(Text)
			self.DeCool[iBuff].Text:SetText(Text)
		end
		function GUI:SetStack(Text, iBuff)
			self.DebuffFrame[iBuff].Shadow:SetText(Text)
			self.DebuffFrame[iBuff].Text:SetText(Text)
		end
		function GUI:SetDeath(bool)
			if bool then
				self.TankText:SetAlpha(0.5)
				for i = 1, 2 do
					self.DebuffFrame[i].Shadow:SetVisible(false)
					self.DebuffFrame[i].Text:SetVisible(false)
					self.DebuffFrame[i].Texture:SetVisible(false)
					self.DeCoolFrame[i]:SetVisible(false)
				end
				self.Dead:SetVisible(true)
				self.TankAggro.Texture:SetVisible(false)
				self.TankHP:SetVisible(false)
			else
				self.TankText:SetAlpha(1)
				self.Dead:SetVisible(false)
				self.TankHP:SetVisible(true)
				for i = 1, 2 do
					self.DebuffFrame[i].Shadow:SetVisible(true)
					self.DebuffFrame[i].Text:SetVisible(true)
					self.DeCoolFrame[i]:SetVisible(false)
				end
			end			
		end
	end
	return GUI
end

function KBM.TankSwap:Init()
	self.Tanks = {}
	self.TankCount = 0
	self.DefaultTexture = "Data/\\UI\\ability_icons\\generic_ability_001.dds"
	self.AggroTexture = "Data/\\UI\\ability_icons\\weaponsmith1a.dds"
	self.Active = false
	self.DebuffID = {}
	self.Debuffs = 0
	self.DebuffName = {}
	self.LastTank = nil
	self.Test = false
	self.TankStore = {}
	self.Enabled = KBM.Options.TankSwap.Enabled
	self.Settings = KBM.Options.TankSwap
	self.Anchor = UI.CreateFrame("Frame", "Tank-Swap_Anchor", KBM.Context)
	self.Anchor:SetWidth(KBM.Options.TankSwap.w * KBM.Options.TankSwap.wScale)
	self.Anchor:SetHeight(KBM.Options.TankSwap.h * KBM.Options.TankSwap.hScale)
	self.Anchor:SetBackgroundColor(0,0,0,0.33)
	self.Anchor:SetLayer(5)
	
	if KBM.Options.TankSwap.x then
		self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.TankSwap.x, KBM.Options.TankSwap.y)
	else
		self.Anchor:SetPoint("CENTER", UIParent, "CENTER")
	end
	
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.Options.TankSwap.x = self:GetLeft()
			KBM.Options.TankSwap.y = self:GetTop()
		end
	end
	
	self.Anchor.Text = UI.CreateFrame("Text", "TankSwap info", self.Anchor)
	self.Anchor.Text:SetText(KBM.Language.Anchors.TankSwap[KBM.Lang])
	self.Anchor.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
	self.Anchor.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "TS Anchor Drag", 2)
	
	if KBM.MainWin:GetVisible() then
		self.Anchor:SetVisible(KBM.Options.TankSwap.Visible)
		self.Anchor.Drag:SetVisible(KBM.Options.TankSwap.Unlocked)
	else
		self.Anchor:SetVisible(false)
		self.Anchor.Drag:SetVisible(false)
	end
			
	function self:Add(UnitID, Test)		
		if self.Test and not Test then
			self:Remove()
			self.Anchor:SetVisible(false)
		end
		local TankObj = {}
		TankObj.UnitID = UnitID
		TankObj.DebuffList = {}
		TankObj.DebuffName = {}
		TankObj.Test = Test
		for i = 1, self.Debuffs do
			TankObj.DebuffList[i] = {
				ID = nil,
				Stacks = 0,
				Remaining = 0,
			}
			TankObj.DebuffName[self.DebuffList[i].Name] = TankObj.DebuffList[i]
		end
		self.Active = true
		TankObj.Dead = false
		
		if Test then
			TankObj.Name = Test
			TankObj.UnitID = Test
			self.Test = true
			TankObj.Dead = false
		else
			TankObj.Unit = KBM.Unit.List.UID[UnitID]
			if TankObj.Unit then
				TankObj.Name = TankObj.Unit.Name
				if TankObj.Unit.Dead and TankObj.Unit.Health then
					if TankObj.Unit.Health > 0 then
						TankObj.Dead = false
					else
						TankObj.Dead = true
					end
				else
					TankObj.Dead = true
				end
			end
		end
		
		TankObj.GUI = KBM.TankSwap:Pull()
		TankObj.GUI:SetTank(TankObj.Name)
		
		if self.TankCount == 0 then
			TankObj.GUI.Frame:SetPoint("TOPLEFT", self.Anchor, "TOPLEFT")
			TankObj.GUI.Frame:SetPoint("RIGHT", self.Anchor, "RIGHT")
		else
			TankObj.GUI.Frame:SetPoint("TOPLEFT", self.LastTank.GUI.Frame, "BOTTOMLEFT", 0, 2)
			TankObj.GUI.Frame:SetPoint("RIGHT", self.LastTank.GUI.Frame, "RIGHT")
		end
		
		self.LastTank = TankObj
		self.Tanks[TankObj.UnitID] = TankObj
		self.TankCount = self.TankCount + 1
		
		function TankObj:BuffUpdate(DebuffID, DebuffName)
			self.DebuffName[DebuffName].ID = DebuffID
		end
		
		function TankObj:Death()
			self.Dead = true
			self.GUI:SetDeath(true)
		end
		
		function TankObj:UpdateHP()
			if self.Unit.Health then
				if self.Unit.Health > 0 then
					if self.Dead then
						self.GUI:SetDeath(false)
						self.Dead = false
					end
					self.GUI.TankHP:SetWidth(math.ceil(self.GUI.TankFrame:GetWidth() * self.Unit.PercentFlat))
				elseif not self.Dead then
					self:Death()
				end
			elseif not self.Dead then
				self:Death()
			end
		end
		
		TankObj.GUI:SetDeath(TankObj.Dead)
		if self.Test then
			for i = 1, 2 do
				local Visible = true
				if i > 1 then
					Visible = false
				end
				TankObj.GUI:SetStack("2", i)
				TankObj.GUI:SetDeCool("99.9", i)
				TankObj.GUI.DeCoolFrame[i]:SetVisible(Visible)
				TankObj.GUI.DeCool[i]:SetWidth(TankObj.GUI.DeCoolFrame[1]:GetWidth())
				TankObj.GUI.DebuffFrame[i].Texture:SetVisible(Visible)
			end
			TankObj.GUI.TankHP:SetWidth(TankObj.GUI.TankFrame:GetWidth())
		else
			for i = 1, 2 do
				TankObj.GUI:SetStack("", i)
				TankObj.GUI:SetDeCool("", i)
				TankObj.GUI.DeCoolFrame[i]:SetVisible(false)
				TankObj.GUI.DeCool[i]:SetWidth(TankObj.GUI.DeCoolFrame[1]:GetWidth())
				TankObj.GUI.DebuffFrame[i].Texture:SetVisible(false)				
			end
			if self.Debuffs > 1 then
				TankObj.GUI.DeCoolFrame[1]:SetPoint("RIGHT", TankObj.GUI.Frame, "CENTERX")
				TankObj.GUI.DebuffFrame[2]:SetPoint("LEFT", TankObj.GUI.Frame, "CENTERX")
			else
				TankObj.GUI.DeCoolFrame[1]:SetPoint("RIGHT", TankObj.GUI.Frame, "RIGHT")
			end
		end
		TankObj.GUI.Frame:SetVisible(true)
		return TankObj		
	end
	
	function self:Start(DebuffName, BossID, Debuffs)
		if KBM.Options.TankSwap.Enabled then
			local Spec = ""
			local UnitID = ""
			local uDetails = nil
			self.Boss = KBM.Unit.List.UID[BossID]
			if not self.Boss then
				return
			end
			self.CurrentTarget = nil
			self.CurrentIcon = nil
			self.DebuffList = {}
			self.DebuffName = {}
			if type(DebuffName) == "table" then
				for i, DebuffName in ipairs(DebuffName) do
					self:AddDebuff(DebuffName, i)
				end
			else
				self:AddDebuff(DebuffName, 1)
			end
			self.Debuffs = Debuffs or 1
			if LibSRM.Grouped() then
				for i = 1, 20 do
					Spec, UnitID = LibSRM.Group.Inspect(i)
					if UnitID then
						uDetails = Inspect.Unit.Detail(UnitID)
						if uDetails then
							if uDetails.role == "tank" then
								self:Add(UnitID)
							end
						end
					end
				end
			end
		end
		local EventData = {
			DebuffList = self.DebuffName,
			Enabled = KBM.Options.TankSwap.Enabled,
		}
		KBM.Event.System.TankSwap.Start(EventData)
	end
	
	function self:AddDebuff(DebuffName, Index)
		self.DebuffList[Index] = {
			Name = DebuffName,
			Index = Index,
		}
		self.DebuffName[DebuffName] = self.DebuffList[Index]
	end
		
	function self:Update()	
		local uDetails = ""
		for UnitID, TankObj in pairs(self.Tanks) do
			for i = 1, self.Debuffs do
				if TankObj.DebuffList[i].ID then
					local DebuffObj = TankObj.DebuffList[i]
					local bDetails = Inspect.Buff.Detail(UnitID, TankObj.DebuffList[i].ID)
					if bDetails then
						if bDetails.stack then
							DebuffObj.Stacks = bDetails.stack
						else
							DebuffObj.Stacks = 1
						end
						DebuffObj.Remaining = bDetails.remaining
						DebuffObj.Duration = bDetails.duration
						if bDetails.icon then
							DebuffObj.Icon = bDetails.icon
						else
							DebuffObj.Icon = self.DefaultTexture
						end
						if DebuffObj.Remaining > 9.94 then
							TankObj.GUI:SetDeCool(KBM.ConvertTime(DebuffObj.Remaining), i)
						else
							TankObj.GUI:SetDeCool(string.format("%0.01f", DebuffObj.Remaining), i)
						end
						TankObj.GUI.DeCool[i]:SetWidth(math.ceil(TankObj.GUI.DeCoolFrame[i]:GetWidth() * (DebuffObj.Remaining/DebuffObj.Duration)))
						TankObj.GUI:SetStack(tostring(DebuffObj.Stacks), i)
						KBM.LoadTexture(TankObj.GUI.DebuffFrame[i].Texture, "Rift", DebuffObj.Icon)
						TankObj.GUI.DebuffFrame[i].Texture:SetVisible(true)
						TankObj.GUI.DeCoolFrame[i]:SetVisible(true)
					else
						TankObj.GUI.DeCoolFrame[i]:SetVisible(false)
						TankObj.GUI.DeCool[i]:SetWidth(0)
						TankObj.GUI:SetDeCool("", i)
						TankObj.GUI:SetStack("", i)
						TankObj.GUI.DebuffFrame[i].Texture:SetVisible(false)
						TankObj.DebuffList[i].ID = nil
					end
				end
			end
			TankObj:UpdateHP()
			if self.Boss then
				if self.Boss.Target then
					if self.Tanks[self.Boss.Target] then
						if self.Tanks[self.Boss.Target] ~= self.CurrentTarget then
							if self.CurrentTarget then
								self.CurrentTarget.GUI.TankAggro.Texture:SetVisible(false)
							end
							self.CurrentTarget = self.Tanks[self.Boss.Target]
							self.CurrentTarget.GUI.TankAggro.Texture:SetVisible(true)
						end
					end
				end
			end
		end	
	end
	
	function self:Remove()
		for UnitID, TankObj in pairs(self.Tanks) do
			table.insert(self.TankStore, TankObj.GUI)
			TankObj.GUI.Frame:SetVisible(false)
			TankObj.GUI = nil
		end
		self.Active = false
		self.DebuffName = {}
		self.DebuffID = {}
		self.Tanks = {}
		self.LastTank = nil
		self.TankCount = 0
		if not self.Test then
			KBM.Event.System.TankSwap.End()
		end
		self.Test = false
	end	
end

function KBM.Alert:Init()
	function self:ApplySettings()
		self.Anchor:ClearAll()
		self.Text:SetFontSize(KBM.Constant.Alerts.TextSize * self.Settings.tScale)
		self.Shadow:SetFontSize(self.Text:GetFontSize())
		if self.Settings.x then
			self.Anchor:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
		else
			self.Anchor:SetPoint("CENTERX", UIParent, "CENTERX")
			self.Anchor:SetPoint("CENTERY", UIParent, nil, 0.25)
		end	
		self.Notify = self.Settings.Notify
		self.Flash = self.Settings.Flash
		self.Enabled = self.Settings.Enabled
		self.AlertControl.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
		self.AlertControl.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
		self.AlertControl.Top:SetPoint("BOTTOM", UIParent, nil, 0.2 * KBM.Alert.Settings.fScale)
		self.AlertControl.Bottom:SetPoint("TOP", UIParent, nil, 1 - (0.2 * KBM.Alert.Settings.fScale))
		if KBM.MainWin:GetVisible() then
			self.Anchor:SetVisible(self.Settings.Visible)
			self.Anchor.Drag:SetVisible(self.Settings.Visible)
			if self.Settings.Vertical then
				self.Left.red:SetVisible(self.Settings.Visible)
				self.Right.red:SetVisible(self.Settings.Visible)
			else
				self.Left.red:SetVisible(false)
				self.Right.red:SetVisible(false)
			end
			if self.Settings.Horizontal then
				self.Top.red:SetVisible(self.Settings.Visible)
				self.Bottom.red:SetVisible(self.Settings.Visible)
			else
				self.Top.red:SetVisible(false)
				self.Bottom.red:SetVisible(false)
			end
			if self.Settings.Visible then
				if self.Settings.Vertical then
					self.AlertControl.Left:SetVisible(self.Settings.FlashUnlocked)
					self.AlertControl.Right:SetVisible(self.Settings.FlashUnlocked)
				end
				if self.Settings.Horizontal then
					self.AlertControl.Top:SetVisible(self.Settings.FlashUnlocked)
					self.AlertControl.Bottom:SetVisible(self.Settings.FlashUnlocked)
				end
			end
		else
			self.Anchor:SetVisible(false)
			self.Anchor.Drag:SetVisible(false)
			self.Left.red:SetVisible(false)
			self.Right.red:SetVisible(false)
			self.Top.red:SetVisible(false)
			self.Bottom.red:SetVisible(false)
			self.AlertControl.Left:SetVisible(false)
			self.AlertControl.Right:SetVisible(false)
			self.AlertControl.Top:SetVisible(false)
			self.AlertControl.Bottom:SetVisible(false)
		end
	end

	self.List = {}
	self.Settings = KBM.Options.Alerts
	self.Anchor = UI.CreateFrame("Frame", "Alert Text Anchor", KBM.Context)
	self.Anchor:SetBackgroundColor(0,0,0,0)
	self.Anchor:SetLayer(5)
	self.Shadow = UI.CreateFrame("Text", "Alert Text Outline", self.Anchor)
	self.Shadow:SetFontColor(0,0,0)
	self.Shadow:SetLayer(1)
	self.Text = UI.CreateFrame("Text", "Alert Text", self.Anchor)
	self.Shadow:SetPoint("CENTER", self.Text, "CENTER", 2, 2)
	self.Text:SetText(KBM.Language.Anchors.AlertText[KBM.Lang])
	self.Shadow:SetText(self.Text:GetText())
	self.Shadow:SetFontSize(self.Text:GetFontSize())
	self.Text:SetFontColor(1,1,1)
	self.Text:SetPoint("CENTER", self.Anchor, "CENTER")
	self.Text:SetLayer(2)
	self.Anchor:SetVisible(self.Settings.Visible)
	self.ColorList = {"red", "blue", "cyan", "yellow", "orange", "purple", "dark_green"}
	self.Left = {}
	self.Right = {}
	self.Top = {}
	self.Bottom = {}
	self.Count = 0
	self.AlertControl = {}
	self.AlertControl.Left = UI.CreateFrame("Frame", "Left_Alert_Controller", KBM.Context)
	self.AlertControl.Left:SetVisible(false)
	self.AlertControl.Left:SetLayer(2)
	self.AlertControl.Left:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
	self.AlertControl.Left:SetPoint("BOTTOM", UIParent, "BOTTOM")
	self.AlertControl.Right = UI.CreateFrame("Frame", "Right_Alert_Controller", KBM.Context)
	self.AlertControl.Right:SetVisible(false)
	self.AlertControl.Right:SetLayer(2)
	self.AlertControl.Right:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT")
	self.AlertControl.Right:SetPoint("BOTTOM", UIParent, "BOTTOM")
	self.AlertControl.Top = UI.CreateFrame("Frame", "Top_Alert_Controller", KBM.Context)
	self.AlertControl.Top:SetVisible(false)
	self.AlertControl.Top:SetLayer(2)
	self.AlertControl.Top:SetPoint("TOPLEFT", UIParent, "TOPLEFT")
	self.AlertControl.Top:SetPoint("RIGHT", UIParent, "RIGHT")
	self.AlertControl.Bottom = UI.CreateFrame("Frame", "Bottom_Alert_Controller", KBM.Context)
	self.AlertControl.Bottom:SetVisible(false)
	self.AlertControl.Bottom:SetLayer(2)
	self.AlertControl.Bottom:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT")
	self.AlertControl.Bottom:SetPoint("RIGHT", UIParent, "RIGHT")
	
	for _t, Color in ipairs(self.ColorList) do
		self.Left[Color] = UI.CreateFrame("Texture", "Left_Alert "..Color, KBM.Context)
		KBM.LoadTexture(self.Left[Color], "KingMolinator", "Media/Alert_Left_"..Color..".png")
		self.Left[Color]:SetPoint("TOPLEFT", self.AlertControl.Left, "TOPLEFT")
		self.Left[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Left, "BOTTOMRIGHT")
		self.Left[Color]:SetVisible(false)
		self.Right[Color] = UI.CreateFrame("Texture", "Right_Alert"..Color, KBM.Context)
		KBM.LoadTexture(self.Right[Color], "KingMolinator", "Media/Alert_Right_"..Color..".png")
		self.Right[Color]:SetPoint("TOPLEFT", self.AlertControl.Right, "TOPLEFT")
		self.Right[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Right, "BOTTOMRIGHT")
		self.Right[Color]:SetVisible(false)
		self.Top[Color] = UI.CreateFrame("Texture", "Top_Alert "..Color, KBM.Context)
		KBM.LoadTexture(self.Top[Color], "KingMolinator", "Media/Alert_Top_"..Color..".png")
		self.Top[Color]:SetPoint("TOPLEFT", self.AlertControl.Top, "TOPLEFT")
		self.Top[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Top, "BOTTOMRIGHT")
		self.Top[Color]:SetVisible(false)
		self.Bottom[Color] = UI.CreateFrame("Texture", "Bottom_Alert "..Color, KBM.Context)
		KBM.LoadTexture(self.Bottom[Color], "KingMolinator", "Media/Alert_Bottom_"..Color..".png")
		self.Bottom[Color]:SetPoint("TOPLEFT", self.AlertControl.Bottom, "TOPLEFT")
		self.Bottom[Color]:SetPoint("BOTTOMRIGHT", self.AlertControl.Bottom, "BOTTOMRIGHT")
		self.Bottom[Color]:SetVisible(false)
	end
	
	self.AlertControl.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
	self.AlertControl.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
	self.AlertControl.Top:SetPoint("BOTTOM", UIParent, nil, 0.2 * KBM.Alert.Settings.fScale)
	self.AlertControl.Bottom:SetPoint("TOP", UIParent, nil, 1 - (0.2 * KBM.Alert.Settings.fScale))
	
	function self.AlertControl:WheelBack()
		if KBM.Alert.Settings.fScale < 1.5 then
			KBM.Alert.Settings.fScale = KBM.Alert.Settings.fScale + 0.05
			if KBM.Alert.Settings.fScale > 1.5 then
				KBM.Alert.Settings.fScale = 1.5
			end
			self.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
			self.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
			self.Top:SetPoint("BOTTOM", UIParent, nil, 0.2 * KBM.Alert.Settings.fScale)
			self.Bottom:SetPoint("TOP", UIParent, nil, 1 - (0.2 * KBM.Alert.Settings.fScale))
		end
	end
	
	function self.AlertControl:WheelForward()
		if KBM.Alert.Settings.fScale > 0.15 then
			KBM.Alert.Settings.fScale = KBM.Alert.Settings.fScale - 0.05
			if KBM.Alert.Settings.fScale < 0.15 then
				KBM.Alert.Settings.fScale = 0.15
			end
			self.Left:SetPoint("RIGHT", UIParent, 0.2 * KBM.Alert.Settings.fScale, nil)
			self.Right:SetPoint("LEFT", UIParent, 1 - (0.2 * KBM.Alert.Settings.fScale), nil)
			self.Top:SetPoint("BOTTOM", UIParent, nil, 0.2 * KBM.Alert.Settings.fScale)
			self.Bottom:SetPoint("TOP", UIParent, nil, 1 - (0.2 * KBM.Alert.Settings.fScale))
		end	
	end
	
	function self.AlertControl.Left.Event:WheelBack()
		KBM.Alert.AlertControl:WheelBack()
	end
	
	function self.AlertControl.Left.Event:WheelForward()
		KBM.Alert.AlertControl:WheelForward()
	end
	
	function self.AlertControl.Right.Event:WheelBack()
		KBM.Alert.AlertControl:WheelBack()
	end
	
	function self.AlertControl.Right.Event:WheelForward()
		KBM.Alert.AlertControl:WheelForward()
	end
	
	function self.AlertControl.Top.Event:WheelBack()
		KBM.Alert.AlertControl:WheelBack()
	end
	
	function self.AlertControl.Top.Event:WheelForward()
		KBM.Alert.AlertControl:WheelForward()
	end
	
	function self.AlertControl.Bottom.Event:WheelBack()
		KBM.Alert.AlertControl:WheelBack()
	end
	
	function self.AlertControl.Bottom.Event:WheelForward()
		KBM.Alert.AlertControl:WheelForward()
	end
	
	self.Current = nil
	self.StopTime = 0
	self.Remaining = 0
	self.Alpha = 1
	self.Queue = {}
	self.Speed = 0.025
	self.Direction = -self.Speed
	self.Color = "red"
	
	function self.Anchor:Update(uType)
		if uType == "end" then
			KBM.Alert.Settings.x = self:GetLeft()
			KBM.Alert.Settings.y = self:GetTop()
		end
	end
	
	self.Anchor.Drag = KBM.AttachDragFrame(self.Anchor, function(uType) self.Anchor:Update(uType) end, "Alert Anchor Drag", 2)
	self.Anchor.Drag:SetLayer(3)
	self.Anchor.Drag:ClearAll()
	self.Anchor.Drag:SetPoint("TOPRIGHT", self.Text, "TOPRIGHT")
	self.Anchor.Drag:SetPoint("BOTTOMLEFT", self.Text, "BOTTOMLEFT")
	function self.Anchor.Drag.Event:WheelForward()
		if KBM.Alert.Settings.ScaleText then
			if KBM.Alert.Settings.tScale < 2 then
				KBM.Alert.Settings.tScale = KBM.Alert.Settings.tScale + 0.02
				if KBM.Alert.Settings.tScale > 2 then
					KBM.Alert.Settings.tScale = 2
				end
				KBM.Alert.Shadow:SetFontSize(KBM.Constant.Alerts.TextSize * KBM.Alert.Settings.tScale)
				KBM.Alert.Text:SetFontSize(KBM.Constant.Alerts.TextSize * KBM.Alert.Settings.tScale)	
			end
		end		
	end
	
	function self.Anchor.Drag.Event:WheelBack()	
		if KBM.Alert.Settings.ScaleText then
			if KBM.Alert.Settings.tScale > 0.8 then
				KBM.Alert.Settings.tScale = KBM.Alert.Settings.tScale - 0.02
				if KBM.Alert.Settings.tScale < 0.8 then
					KBM.Alert.Settings.tScale = 0.8
				end
				KBM.Alert.Shadow:SetFontSize(KBM.Constant.Alerts.TextSize * KBM.Alert.Settings.tScale)
				KBM.Alert.Text:SetFontSize(KBM.Constant.Alerts.TextSize * KBM.Alert.Settings.tScale)	
			end
		end
	end
	
	function self:Create(Text, Duration, Flash, Countdown, Color)
		AlertObj = {}
		AlertObj.DefDuration = Duration
		AlertObj.Duration = Duration
		AlertObj.Flash = Flash
		if not Color then
			AlertObj.Color = self.Color
		else
			AlertObj.Color = Color
		end
		AlertObj.Text = Text
		AlertObj.Countdown = Countdown
		AlertObj.Enabled = true
		AlertObj.AlertAfter = nil
		AlertObj.isImportant = false
		AlertObj.HasMenu = true
		AlertObj.Type = "alert"
		if type(Text) ~= "string" then
			error("Expecting String for Text, got: "..type(Text))
		end
		if not self.Left[AlertObj.Color] then
			error("Alert:Create() Invalid color supplied:- "..AlertObj.Color)
		end
		
		function AlertObj:AlertEnd(endAlertObj)
			if type(endAlertObj) == "table" then
				if endAlertObj.Type == "alert" then
					self.AlertAfter = endAlertObj
				else
					error("KBM.Alert:AlertEnd - Expecting Alert Object: Got "..tostring(endAlertObj.Type))
				end
			else
				error("KBM.Alert:AlertEnd - Expecting at least table: Got "..tostring(type(endAlertObj)))
			end
		end
		
		function AlertObj:TimerEnd(endTimerObj)
			if type(endTimerObj) == "table" then
				if endTimerObj.Type == "timer" then
					self.TimerAfter = endTimerObj
				else
					error("KBM.Alert:TimerEnd - Expecting Timer Object: Got "..tostring(endTimerObj.Type))
				end
			else
				error("KBM.Alert:TimerEnd - Expecting at least table: Got "..tostring(type(endTimerObj)))
			end
		end

		function AlertObj:Important()
			self.isImportant = true
		end
		
		function AlertObj:NoMenu()
			self.HasMenu = false
			self.Enabled = true
		end
		
		self.Count = self.Count + 1
		table.insert(self.List, AlertObj)
		return AlertObj		
	end
	
	function self:Start(AlertObj, CurrentTime, Duration)
		local CurrentTime = Inspect.Time.Real()
		if self.Settings.Enabled then
			if AlertObj.Enabled then
				if self.Starting and not AlertObj.isImportant then
					if KBM.Debug then
						print("Alert starting overlap: Aborting")
					end
					return
				end
				if self.Active then
					if self.Current.Active then
						if not AlertObj.isImportant then
							if self.Current.isImportant then
								if not self.Current.Stopping then
									return
								end
							end
						end
						self.Starting = true
						self:Stop()
					end
				end
				self.Starting = true
				AlertObj.Active = true
				self.Duration = AlertObj.Duration
				if Duration then
					if not AlertObj.DefDuration then
						self.Duration = Duration
					end
				else
					if not AlertObj.DefDuration then
						self.Duration = 2
					else
						self.Duration = AlertObj.DefDuration
					end
				end
				self.Current = AlertObj
				AlertObj.Duration = self.Duration
				self.Alpha = 1.0
				if self.Settings.Flash then
					if not AlertObj.Settings then
						self.Color = AlertObj.Color
						AlertObj.Settings = KBM.Defaults.AlertObj()
					else
						if AlertObj.Settings.Custom then
							self.Color = AlertObj.Settings.Color
						else
							self.Color = AlertObj.Color
						end
					end
					if AlertObj.Settings.Border then
						if self.Settings.Vertical then
							self.Left[self.Color]:SetAlpha(1.0)
							self.Left[self.Color]:SetVisible(true)
							self.Right[self.Color]:SetAlpha(1.0)
							self.Right[self.Color]:SetVisible(true)
						end
						if self.Settings.Horizontal then
							self.Top[self.Color]:SetAlpha(1.0)
							self.Top[self.Color]:SetVisible(true)
							self.Bottom[self.Color]:SetAlpha(1.0)
							self.Bottom[self.Color]:SetVisible(true)						
						end
						self.Direction = false
						self.FadeStart = CurrentTime
					end
				end
				if self.Settings.Notify then
					if AlertObj.Text then
						if AlertObj.Settings.Notify then
							self.Shadow:SetText(AlertObj.Text)
							self.Text:SetText(AlertObj.Text)
							self.Anchor:SetVisible(true)
							self.Anchor:SetAlpha(1.0)
						end
					end
				end
				if self.Duration then
					self.StopTime = CurrentTime + AlertObj.Duration
					self.Remaining = self.StopTime - CurrentTime
				else
					self.StopTime = 0
				end
				self.Active = true
				self.Starting = false
				self:Update(CurrentTime)
			end
		end
	end
	
	function self:Stop(SpecObj)
		if (self.Current and not SpecObj) or (self.Current and SpecObj == self.Current) then
			if self.Current.Active then
				self.Current.Stopping = true
				self.Left[self.Color]:SetVisible(false)
				self.Right[self.Color]:SetVisible(false)
				self.Top[self.Color]:SetVisible(false)
				self.Bottom[self.Color]:SetVisible(false)
				self.Anchor:SetVisible(false)
				self.Shadow:SetText(" Alert Anchor ")
				self.Text:SetText(" Alert Anchor ")
				self.StopTime = 0
				self.Current.Active = false
				self.Current.Stopping = false
				self.Active = false
				if self.Current.AlertAfter and not self.Starting then
					if KBM.Encounter then
						KBM.Alert:Start(self.Current.AlertAfter, Inspect.Time.Real())
					end
				end
				if self.Current.TimerAfter then
					if KBM.Encounter then
						if not self.Current.TAStarted then
							KBM.MechTimer:AddStart(self.Current.TimerAfter)
							self.Current.TAStart = false
						end
					end
				end
			end
		end
	end	
	
	function self:Update(CurrentTime)
		local CurrentTime = Inspect.Time.Real()
		if self.Current.Stopping then
			if self.Alpha == 0 then
				self:Stop()
			else
				local TimeDiff = CurrentTime - self.FadeStart
				self.Alpha = 1.0 - (TimeDiff * 1.25)
				if self.Alpha < 0 then
					self.Alpha = 0.0
				end
				if self.Settings.Flash then
					if self.Current.Settings.Border then
						if self.Settings.Vertical then
							self.Left[self.Color]:SetAlpha(self.Alpha)
							self.Right[self.Color]:SetAlpha(self.Alpha)
						end
						if self.Settings.Horizontal then
							self.Top[self.Color]:SetAlpha(self.Alpha)
							self.Bottom[self.Color]:SetAlpha(self.Alpha)
						end
					end
				end
				if self.Settings.Notify then
					if self.Current.Settings.Notify then
						self.Anchor:SetAlpha(self.Alpha)
					end
				end
			end
		else
			if self.Settings.Flash then
				if self.Current.Flash then
					if self.Current.Settings.Border then
						local TimeDiff = CurrentTime - self.FadeStart
						if self.Direction then
							if TimeDiff > 0.5 then
								self.Alpha = 1.0
								self.Direction = false
								self.FadeStart = CurrentTime
							else
								self.Alpha = TimeDiff * 2
							end
						else
							if TimeDiff > 0.5 then
								self.Alpha = 0.0
								self.Direction = true
								self.FadeStart = CurrentTime
							else
								self.Alpha = 1.0 - (TimeDiff * 2)
							end
						end
						if self.Settings.Vertical then
							self.Left[self.Color]:SetAlpha(self.Alpha)
							self.Right[self.Color]:SetAlpha(self.Alpha)
						end
						if self.Settings.Horizontal then
							self.Top[self.Color]:SetAlpha(self.Alpha)
							self.Bottom[self.Color]:SetAlpha(self.Alpha)
						end
					end
				end
			end
			if self.Current.Countdown then
				if self.Remaining then
					self.Remaining = self.StopTime - CurrentTime
					if self.Current.Settings.Notify then
						if self.Remaining <= 0 then
							self.Remaining = 0
							self.Shadow:SetText(self.Current.Text)
							self.Text:SetText(self.Current.Text)
						else
							CDText = string.format("%0.1f - "..self.Current.Text, self.Remaining)
							self.Shadow:SetText(CDText)
							self.Text:SetText(CDText)
						end
					end
				end
			end
			if self.StopTime then
				if self.StopTime <= CurrentTime then
					self.Direction = false
					self.FadeStart = (CurrentTime - (1.0 - self.Alpha))
					self.Current.Stopping = true
					if self.Current.AlertAfter and not self.Starting then
						self:Stop()
					elseif self.Current.TimerAfter then
						if KBM.Encounter then
							KBM.MechTimer:AddStart(self.Current.TimerAfter)
							self.Current.TAStarted = true
						end
					end
				end
			end
		end
	end
	self:ApplySettings()	
end

function KBM.CastBar:Init()
	self.Settings = KBM.Options.CastBar
	self.CastBarList = {}
	self.ActiveCastBars = {}
	self.RemoveCastBars = {}
	self.WaitCastBars = {}
	self.StartCastBars = {}
	self.Stores = {
		Rift = {},
		Boss = {},
		KBM = {},
	}	
	self.ActiveCount = 0

	function self:Pull(Style, IsBoss)
		-- First try and pull existing Castbar Objects from GUI Stores
		if Style == "rift" then
			if IsBoss then
				GUI = table.remove(self.Stores.Boss)
			else
				GUI = table.remove(self.Stores.Rift)
			end
		else
			GUI = table.remove(self.Stores.KBM)
		end
		-- Return existing Castbar Object if successful
		if GUI then
			return GUI
		end
		
		-- Otherwise create a new Castbar Object
		local GUI = {}
		GUI.Style = Style
		GUI.IsBoss = IsBoss
		
		-- Create Base frame for this Castbar Object
		GUI.Frame = UI.CreateFrame("Frame", "CastBar Frame", KBM.Context)
		GUI.Frame:SetWidth(math.ceil(KBM.Constant.CastBar.w * self.Settings.wScale))
		GUI.Frame:SetHeight(math.ceil(KBM.Constant.CastBar.h * self.Settings.hScale))
		GUI.Frame:SetLayer(2)
		
		-- Handle Style types to account for API Texture issues	for the Progress Mask
		GUI.Mask = UI.CreateFrame("Mask", "CastBar_Mask", GUI.Frame)
		if Style == "rift" then
			GUI.Mask:SetPoint("TOPLEFT", GUI.Frame, 0.03, 0.2)
			GUI.Mask:SetPoint("BOTTOM", GUI.Frame, nil, 0.8)
		else
			GUI.Mask:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
			GUI.Mask:SetPoint("BOTTOM", GUI.Frame, "BOTTOM")
		end
		
		-- Handle Style types to account for API Texture issues	for the Progress Texture/Frame	
		if Style == "rift" then
			GUI.Progress = UI.CreateFrame("Texture", "CastBar_Progress_Texture", GUI.Mask)
			KBM.LoadTexture(GUI.Progress, "KingMolinator", "Media/Castbar_Cyan.png")
			GUI.Progress:SetPoint("TOPLEFT", GUI.Frame, 0.03, 0.2)
			GUI.Progress:SetPoint("BOTTOMRIGHT", GUI.Frame, 0.97, 0.8)
		else
			GUI.Progress = UI.CreateFrame("Frame", "Castbar_Progress_Frame", GUI.Mask)
			GUI.Progress:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
			GUI.Progress:SetPoint("BOTTOMRIGHT", GUI.Frame, "BOTTOMRIGHT")
			GUI.Progress:SetBackgroundColor(1,0,0,0.33)
		end
		GUI.Progress:SetLayer(1)
		
		GUI.Shadow = UI.CreateFrame("Text", "Timer_Text_Shadow", GUI.Frame)
		GUI.Shadow:SetFontSize(math.ceil(KBM.Constant.CastBar.TextSize * self.Settings.tScale))
		GUI.Shadow:SetPoint("CENTER", GUI.Frame, "CENTER", 2, 2)
		GUI.Shadow:SetLayer(2)
		GUI.Shadow:SetFontColor(0,0,0)
		GUI.Shadow:SetMouseMasking("limited")
		GUI.Text = UI.CreateFrame("Text", "Castbar Text", GUI.Frame)
		GUI.Text:SetFontSize(GUI.Shadow:GetFontSize())
		GUI.Text:SetPoint("CENTER", GUI.Frame, "CENTER")
		GUI.Text:SetLayer(3)
		GUI.Mask:SetWidth(0)
		GUI.Mask:SetLayer(1)
		GUI.Frame:SetBackgroundColor(0,0,0,0)
		GUI.Frame:SetVisible(false)
		GUI.Texture = UI.CreateFrame("Texture", "Timer_Skin", GUI.Frame)
		-- Handle Style types to account for API Texture issues
		if Style == "rift" then
			if IsBoss then
				KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/Castbar_Boss.png")
				GUI.Texture:SetPoint("TOPLEFT", GUI.Frame, -0.075, -0.5)
				GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Frame, 1.075, 1.5)
			else
				KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/Castbar_Outline.png")
				GUI.Texture:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
				GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Frame, "BOTTOMRIGHT")
			end
			GUI.Highlight = UI.CreateFrame("Texture", "Completion_Highlight", GUI.Texture)
			KBM.LoadTexture(GUI.Highlight, "KingMolinator", "Media/Castbar_Complete.png")
			GUI.Highlight:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
			GUI.Highlight:SetPoint("BOTTOMRIGHT", GUI.Frame, "BOTTOMRIGHT")
			GUI.Highlight:SetAlpha(0)
		else
			KBM.LoadTexture(GUI.Texture, "KingMolinator", "Media/BarSkin.png")
			GUI.Texture:SetPoint("TOPLEFT", GUI.Frame, "TOPLEFT")
			GUI.Texture:SetPoint("BOTTOMRIGHT", GUI.Frame, "BOTTOMRIGHT")
		end
		
		GUI.Texture:SetLayer(4)
		GUI.Texture:SetMouseMasking("limited")
		
		function GUI:Update(uType)
			if uType == "end" then
				self.CastBarObj.Settings.x = self.Drag:GetLeft()
				self.CastBarObj.Settings.y = self.Drag:GetTop()
			end
		end			
		GUI.Drag = KBM.AttachDragFrame(GUI.Frame, function(uType) GUI:Update(uType) end , "CB Live Drag", 2)
		GUI.Drag.GUI = GUI
		
		function GUI:SetText(Text)
			self.Shadow:SetText(Text)
			self.Text:SetText(Text)
		end
		
		function GUI.Drag.Event:WheelForward()	
			if self.GUI.CastBarObj.Settings.ScaleWidth then
				if self.GUI.CastBarObj.Settings.wScale < 1.5 then
					self.GUI.CastBarObj.Settings.wScale = self.GUI.CastBarObj.Settings.wScale + 0.025
					if self.GUI.CastBarObj.Settings.wScale > 1.5 then
						self.GUI.CastBarObj.Settings.wScale = 1.5
					end
					self.GUI.Frame:SetWidth(math.ceil(self.GUI.CastBarObj.Settings.wScale * KBM.Constant.CastBar.w))
				end
			end
			
			if self.GUI.CastBarObj.Settings.ScaleHeight then
				if self.GUI.CastBarObj.Settings.hScale < 1.5 then
					self.GUI.CastBarObj.Settings.hScale =self.GUI.CastBarObj.Settings.hScale + 0.025
					if self.GUI.CastBarObj.Settings.hScale > 1.5 then
						self.GUI.CastBarObj.Settings.hScale = 1.5
					end
					self.GUI.Frame:SetHeight(math.ceil(self.GUI.CastBarObj.Settings.hScale * KBM.Constant.CastBar.h))
				end
			end
			
			if self.GUI.CastBarObj.Settings.TextScale then
				if self.GUI.CastBarObj.Settings.tScale < 1.5 then
					self.GUI.CastBarObj.Settings.tScale = self.GUI.CastBarObj.Settings.tScale + 0.025
					if self.GUI.CastBarObj.Settings.tScale > 1.5 then
						self.GUI.CastBarObj.Settings.tScale = 1.5
					end
					self.GUI.Text:SetFontSize(KBM.Constant.CastBar.TextSize * self.GUI.CastBarObj.Settings.tScale)
					self.GUI.Shadow:SetFontSize(KBM.Constant.CastBar.TextSize * self.GUI.CastBarObj.Settings.tScale)
				end
			end				
		end
		
		function GUI.Drag.Event:WheelBack()				
			if self.GUI.CastBarObj.Settings.ScaleWidth then
				if self.GUI.CastBarObj.Settings.wScale > 0.5 then
					self.GUI.CastBarObj.Settings.wScale = self.GUI.CastBarObj.Settings.wScale - 0.025
					if self.GUI.CastBarObj.Settings.wScale < 0.5 then
						self.GUI.CastBarObj.Settings.wScale = 0.5
					end
					self.GUI.Frame:SetWidth(math.ceil(self.GUI.CastBarObj.Settings.wScale * KBM.Constant.CastBar.w))
				end
			end
			
			if self.GUI.CastBarObj.Settings.ScaleHeight then
				if self.GUI.CastBarObj.Settings.hScale > 0.5 then
					self.GUI.CastBarObj.Settings.hScale = self.GUI.CastBarObj.Settings.hScale - 0.025
					if self.GUI.CastBarObj.Settings.hScale < 0.5 then
						self.GUI.CastBarObj.Settings.hScale = 0.5
					end
					self.GUI.Frame:SetHeight(math.ceil(self.GUI.CastBarObj.Settings.hScale * KBM.Constant.CastBar.h))
				end
			end
			
			if self.GUI.CastBarObj.Settings.TextScale then
				if self.GUI.CastBarObj.Settings.tScale > 0.5 then
					self.GUI.CastBarObj.Settings.tScale = self.GUI.CastBarObj.Settings.tScale - 0.025
					if self.GUI.CastBarObj.Settings.tScale < 0.5 then
						self.GUI.CastBarObj.Settings.tScale = 0.5
					end
					self.GUI.Text:SetFontSize(self.GUI.CastBarObj.Settings.tScale * KBM.Constant.CastBar.TextSize)
					self.GUI.Shadow:SetFontSize(self.GUI.CastBarObj.Settings.tScale * KBM.Constant.CastBar.TextSize)
				end
			end
		end
		return GUI
	end
	
	function self:Push(GUI)
		if GUI then
			GUI.CastBarObj = nil
			GUI.Frame:SetVisible(false)
			GUI.Drag:SetVisible(false)
			if GUI.Style == "rift" then
				if GUI.IsBoss then
					table.insert(self.Stores.Boss, GUI)
				else
					table.insert(self.Stores.Rift, GUI)
				end
			else
				table.insert(self.Stores.KBM, GUI)
			end
		end
	end
	
	self.Anchor = self:Add(KBM, {Name = KBM.Language.Anchors.Castbars[KBM.Lang]}, true)
	self.Anchor.Anchor = true	
end

function KBM.CastBar:Add(Mod, Boss, Enabled, Dynamic)
	local CastBarObj = {}
	CastBarObj.UnitID = nil
	CastBarObj.Boss = Boss
	CastBarObj.Dynamic = Dynamic
	CastBarObj.Name = Boss.Name
	CastBarObj.ID = Boss.Name
	CastBarObj.Filters = Boss.CastFilters
	CastBarObj.HasFilters = Boss.HasCastFilters
	CastBarObj.IsBoss = true
	if Dynamic then
		CastBarObj.Settings = KBM.Defaults.CastBar()
	else
		if Boss.Settings then
			CastBarObj.Settings = Boss.Settings.CastBar
		end
	end
	
	if not CastBarObj.Settings then
		if Mod.Settings then
			if Mod.Settings.CastBar then
				if Mod.Settings.CastBar.Override then
					CastBarObj.Settings = Mod.Settings.CastBar
				else
					CastBarObj.Settings = self.Settings
				end
			else
				CastBarObj.Settings = self.Settings
			end
		else
			CastBarObj.Settings = self.Settings
		end
	end
	
	CastBarObj.Casting = false
	CastBarObj.LastCast = ""
	if not Dynamic then
		CastBarObj.Enabled = CastBarObj.Settings.Enabled
	else
		CastBarObj.Enabled = false
	end
	CastBarObj.Mod = Mod
	CastBarObj.Active = false
	CastBarObj.Anchor = false
	
	function CastBarObj:SetBoss(bool)
		self.IsBoss = bool
	end
	
	function CastBarObj:ManageSettings()
		if not self.Anchor then
			if not self.Dynamic then
				if self.Boss.Settings then
					if self.Boss.Settings.CastBar then
						if self.Boss.Settings.CastBar.Override then
							self.Settings = self.Boss.Settings.CastBar
						else
							self.Settings = KBM.Options.CastBar
						end
					else
						self.Settings = KBM.Options.CastBar
					end
				else
					self.Settings = KBM.Options.CastBar
				end
			end
		else
			self.Settings = KBM.Options.CastBar
		end
	end
	
	function CastBarObj:ApplySettings()
		if self.GUI then
			self.GUI.Frame:ClearAll()
			if not self.Settings.x then
				self.GUI.Frame:SetPoint("CENTER", UIParent, 0.5, 0.7)
			else
				self.GUI.Frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.x, self.Settings.y)
			end
			
			self.GUI.Frame:SetWidth(math.ceil(KBM.Constant.CastBar.w * self.Settings.wScale))
			self.GUI.Frame:SetHeight(math.ceil(KBM.Constant.CastBar.h * self.Settings.hScale))
			self.GUI.Text:SetFontSize(KBM.Constant.CastBar.TextSize * self.Settings.tScale)
			self.GUI.Shadow:SetFontSize(KBM.Constant.CastBar.TextSize * self.Settings.tScale)
			self.GUI.Shadow:SetVisible(self.Settings.Shadow)
			self.GUI.Texture:SetVisible(self.Settings.Texture)
			self.GUI.Mask:SetWidth(0)
			self.GUI:SetText(self.Boss.Name)
			
			if self.Settings.Enabled then
				if KBM.MainWin:GetVisible() then
					if not self.Dynamic then
						self.GUI.Frame:SetVisible(self.Settings.Visible)
					end
				else
					self.GUI.Frame:SetVisible(false)
				end
			end
			
			if not self.Settings.Pinned then
				if KBM.MainWin:GetVisible() then
					if not self.Dynamic then
						self.GUI.Drag:SetVisible(self.Settings.Unlocked)
					end
				else
					self.GUI.Drag:SetVisible(false)
				end
			else
				self.GUI.Drag:SetVisible(false)
				if self.Boss.PinCastBar then
					self.Boss:PinCastBar()
				end
			end
		end
	end
	
	function CastBarObj:Display()	
		self:ManageSettings()
		if KBM.MainWin:GetVisible() then
			self.Visible = self.Settings.Visible
			if self.Settings.Visible and self.Settings.Enabled then
				if not self.GUI then
					self.GUI = KBM.CastBar:Pull(self.Settings.Style, self.IsBoss)
					self.GUI.CastBarObj = self
					self:ApplySettings()
					self.GUI.Frame:SetVisible(true)
				else
					self:ApplySettings()
					self.GUI.Frame:SetVisible(true)
				end
				self.GUI.Shadow:SetAlpha(1)
				self.GUI.Text:SetAlpha(1)
				self.GUI.Texture:SetAlpha(1)
				if self.Settings.Style == "rift" then
					self.GUI.Highlight:SetAlpha(0)
				end
			end
		end
	end
	
	function CastBarObj:Create(UnitID)	
		self:ManageSettings()
		self.UnitID = UnitID
		self.LastCast = ""
		self.Interrupted = false
		self.LastStart = nil
		self.InterruptEnd = nil
		if not self.GUI then
			self.GUI = KBM.CastBar:Pull(self.Settings.Style, self.IsBoss)
			self.GUI.CastBarObj = self
			self:ApplySettings()
		end
		
		if not KBM.CastBar.ActiveCastBars[UnitID] then
			KBM.CastBar.ActiveCastBars[UnitID] = {
				List = {},
				Count = 0,
			}
		end
		KBM.CastBar.ActiveCastBars[UnitID].List[self.ID] = self
		KBM.CastBar.ActiveCastBars[UnitID].Count = KBM.CastBar.ActiveCastBars[UnitID].Count + 1
		self.Active = true		
	end
	
	function CastBarObj:Start()
		self.Casting = true
		self.CastMod = 1
		self.Interrupted = false
		self.InterruptEnd = nil
		self.Complete = false
		self.CompleteEnd = nil
		self.CompleteFade = false
		if self.Enabled then
			if self.Settings.Style == "rift" then
				if self.Uninterruptible then
					KBM.LoadTexture(self.GUI.Progress, "KingMolinator", "Media/Castbar_Yellow.png")
				else
					KBM.LoadTexture(self.GUI.Progress, "KingMolinator", "Media/Castbar_Cyan.png")
				end
				self.GUI.Progress:SetAlpha(0.75)
				self.GUI.Highlight:SetAlpha(0)
			else
				self.GUI.Progress:SetAlpha(1)
			end
			self.GUI.Shadow:SetAlpha(1)
			self.GUI.Text:SetAlpha(1)
			self.GUI.Texture:SetAlpha(1)
			self.GUI.Frame:SetVisible(true)
			self.GUI.Progress:SetVisible(true)
		end
		KBM.Event.Unit.Cast.Start(self.UnitID)
	end
	
	function CastBarObj:Update(Trigger)	
		if self.UnitID then
			bDetails = Inspect.Unit.Castbar(self.UnitID)
			if bDetails then
				if bDetails.abilityName then
					if self.Settings.Enabled then
						if self.HasFilters then
							if self.Filters[bDetails.abilityName] then
								FilterObj = self.Filters[bDetails.abilityName]
								if FilterObj.Enabled then
									if not self.Casting then
										self.Uninterruptible = bDetails.uninterruptible
										self:Start()
										if self.Settings.Style == "kbm" then
											if FilterObj.Custom then
												self.GUI.Progress:SetBackgroundColor(KBM.Colors.List[FilterObj.Color].Red, KBM.Colors.List[FilterObj.Color].Green, KBM.Colors.List[FilterObj.Color].Blue, 0.33)
											else
												if self.Settings.Custom then
													self.GUI.Progress:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
												else
													self.GUI.Progress:SetBackgroundColor(1, 0, 0, 0.33)
												end
											end
										end
										if FilterObj.Count then
											FilterObj.Prefix = KBM.Numbers.GetPlace(FilterObj.Current).." "
											if not bDetails.channeled then
												if FilterObj.Current < FilterObj.Count then
													FilterObj.Current = FilterObj.Current + 1
												else
													FilterObj.Current = 1
												end
											end
										else
											FilterObj.Prefix = ""
										end
										self.CastTime = bDetails.duration
										self.Progress = bDetails.remaining
										if self.Settings.Style == "rift" then
											if bDetails.remaining <= 0.5 then
												self.CompleteAlpha = 0.5 - bDetails.remaining
												self.GUI.Highlight:SetAlpha(self.CompleteAlpha)
											end
										end
										if bDetails.channeled then
											local newWidth = math.ceil(self.GUI.Progress:GetWidth() * (self.Progress/self.CastTime))
											if newWidth ~= self.GUI.Mask:GetWidth() then
												self.GUI.Mask:SetWidth(newWidth)
											end
										else
											local newWidth = math.floor(self.GUI.Progress:GetWidth() * (1-(self.Progress/self.CastTime)))
											if newWidth ~= self.GUI.Mask:GetWidth() then
												self.GUI.Mask:SetWidth(newWidth)
											end
										end
										self.GUI:SetText(string.format("%0.01f", self.Progress).." - "..FilterObj.Prefix..bDetails.abilityName)
									else
										self.CastTime = bDetails.duration
										self.Progress = bDetails.remaining
										if bDetails.channeled then										
											self.GUI.Mask:SetWidth(math.ceil(self.GUI.Progress:GetWidth() * (self.Progress/self.CastTime)))
										else
											self.GUI.Mask:SetWidth(math.floor(self.GUI.Progress:GetWidth() * (1-(self.Progress/self.CastTime))))
										end
										self.GUI:SetText(string.format("%0.01f", self.Progress).." - "..FilterObj.Prefix..bDetails.abilityName)	
									end
								elseif self.Casting then
									if not self.Interrupted and not self.Complete then
										self:Stop()
									end
								end
							else
								if not self.Casting then
									self.Uninterruptible = bDetails.uninterruptible
									self:Start()
									if self.Settings.Style == "kbm" then
										if self.Custom then
											self.GUI.Progress:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
										else
											self.GUI.Progress:SetBackgroundColor(1, 0, 0, 0.33)
										end
									end
								end
								self.CastTime = bDetails.duration
								self.Progress = bDetails.remaining
								if self.Settings.Style == "rift" then
									if bDetails.remaining <= 0.5 then
										self.CompleteAlpha = 0.5 - bDetails.remaining
										self.GUI.Highlight:SetAlpha(self.CompleteAlpha)
									end
								end
								if bDetails.channeled then
									local newWidth = math.ceil(self.GUI.Progress:GetWidth() * (self.Progress/self.CastTime))
									if newWidth ~= self.GUI.Mask:GetWidth() then
										self.GUI.Mask:SetWidth(newWidth)
									end
								else
									local newWidth = math.floor(self.GUI.Progress:GetWidth() * (1-(self.Progress/self.CastTime)))
									if newWidth ~= self.GUI.Mask:GetWidth() then
										self.GUI.Mask:SetWidth(newWidth)
									end
								end
								self.GUI:SetText(string.format("%0.01f", self.Progress).." - "..bDetails.abilityName)
							end
						else
							if not self.Casting then
								self.Uninterruptible = bDetails.uninterruptible
								self:Start()
								if self.Settings.Style == "kbm" then
									if self.Custom then
										self.GUI.Progress:SetBackgroundColor(KBM.Colors.List[self.Settings.Color].Red, KBM.Colors.List[self.Settings.Color].Green, KBM.Colors.List[self.Settings.Color].Blue, 0.33)
									else
										self.GUI.Progress:SetBackgroundColor(1, 0, 0, 0.33)
									end
								end
							end
							self.CastTime = bDetails.duration
							self.Progress = bDetails.remaining
							if self.Settings.Style == "rift" then
								if bDetails.remaining <= 0.5 then
									self.CompleteAlpha = 0.5 - bDetails.remaining
									self.GUI.Highlight:SetAlpha(self.CompleteAlpha)
								end
							end
							if bDetails.channeled then
								local newWidth = math.ceil(self.GUI.Progress:GetWidth() * (self.Progress/self.CastTime))
								if newWidth ~= self.GUI.Mask:GetWidth() then
									self.GUI.Mask:SetWidth(newWidth)
								end
							else
								local newWidth = math.floor(self.GUI.Progress:GetWidth() * (1-(self.Progress/self.CastTime)))
								if newWidth ~= self.GUI.Mask:GetWidth() then
									self.GUI.Mask:SetWidth(newWidth)
								end
							end
							local newText = string.format("%0.01f", self.Progress).." - "..bDetails.abilityName
							if newText ~= self.GUI.Text:GetText() then
								self.GUI:SetText(string.format("%0.01f", self.Progress).." - "..bDetails.abilityName)
							end
						end
					end
					self.CastObject = bDetails
					if self.LastStart ~= bDetails.begin then
						self.LastStart = bDetails.begin
						if not bDetails.channeled then	
							if KBM.Trigger.Cast[bDetails.abilityName] then
								if KBM.Trigger.Cast[bDetails.abilityName][self.Boss.Name] then
									local TriggerObj = KBM.Trigger.Cast[bDetails.abilityName][self.Boss.Name]
									local TargetID = ""
									if self.Boss.UnitID then
										TargetID = Inspect.Unit.Lookup(self.Boss.UnitID..".target")
									end
									KBM.Trigger.Queue:Add(TriggerObj, TargetID, TargetID, bDetails.remaining)
								end
							elseif KBM.Trigger.PersonalCast[bDetails.abilityName] then
								if KBM.Trigger.PersonalCast[bDetails.abilityName][self.Boss.Name] then
									local TriggerObj = KBM.Trigger.PersonalCast[bDetails.abilityName][self.Boss.Name]
									if self.UnitID then
										local playerTarget = Inspect.Unit.Lookup("player.target")
										local playerFocus = Inspect.Unit.Lookup("focus")
										if self.UnitID == playerTarget or self.UnitID == playerFocus then
											KBM.Trigger.Queue:Add(TriggerObj, self.UnitID, self.UnitID, bDetails.remaining)
										end
									end
								end
							end
						else
							if not self.Channeled then
								self.Channeled = true
								if KBM.Trigger.Channel[bDetails.abilityName] then
									if KBM.Trigger.Channel[bDetails.abilityName][self.Boss.Name] then
										local TriggerObj = KBM.Trigger.Channel[bDetails.abilityName][self.Boss.Name]
										local TargetID = ""
										if self.Boss.UnitID then
											TargetID = Inspect.Unit.Lookup(self.Boss.UnitID..".target")
										end
										KBM.Trigger.Queue:Add(TriggerObj, TargetID, TargetID, bDetails.remaining)
									end
								end
							end
						end
					end
				else
					if self.Casting then
						self:Stop()
					end
				end
			else
				if self.LastStart then
					if Inspect.Unit.Lookup(self.UnitID) then
						if self.CastObject then
							local Scope = 0.05
							if self.Channeled then
								Scope = 0.1
							end
							if self.CastObject.remaining > Scope and not self.CastObject.uninterruptible then
								--- Do Cast Interrupt Triggers (if any)
								if KBM.Trigger.Interrupt[self.CastObject.abilityName] then
									if KBM.Trigger.Interrupt[self.CastObject.abilityName][self.Boss.Name] then
										local TriggerObj = KBM.Trigger.Interrupt[self.CastObject.abilityName][self.Boss.Name]
										KBM.Trigger.Queue:Add(TriggerObj, self.Boss.UnitID, "interruptTarget", self.CastObject.remaining)
									end
								elseif KBM.Trigger.PersonalInterrupt[self.CastObject.abilityName] then
									if KBM.Trigger.PersonalInterrupt[self.CastObject.abilityName][self.Boss.Name] then
										local TriggerObj = KBM.Trigger.PersonalInterrupt[self.CastObject.abilityName][self.Boss.Name]
										if self.UnitID then
											local playerTarget = Inspect.Unit.Lookup("player.target")
											local playerFocus = Inspect.Unit.Lookup("focus")
											if self.UnitID == playerTarget or self.UnitID == playerFocus then
												KBM.Trigger.Queue:Add(TriggerObj, self.UnitID, "interruptTarget", self.CastObject.remaining)
											end
										end
									end
								end
								self.Interrupted = true
							else
								--- Do Cast End Triggers (if any)
								if self.Settings.Style == "rift" then
									self.Complete = true
									self.GUI:SetText(self.CastObject.abilityName)
								end
							end
							self.CastObject = nil
						end
						self.LastStart = nil
					end
					self:Stop()
				end
			end
		end
		if self.Interrupted then
			if self.InterruptEnd < Inspect.Time.Real() then
				self.Interrupted = false
				self.InterruptEnd = nil
				if self.GUI then
					self.GUI:SetText(self.Boss.Name)
					if KBM.MainWin:GetVisible() then
						self.GUI.Frame:SetVisible(self.Settings.Visible)
					else
						self.GUI.Frame:SetVisible(false)
					end
					self.GUI.Shadow:SetAlpha(1)
					self.GUI.Text:SetAlpha(1)
					self.GUI.Texture:SetAlpha(1)
					self.GUI.Mask:SetWidth(0)
					if self.Settings.Style == "rift" then
						self.GUI.Highlight:SetAlpha(0)
					end
				KBM.Event.Unit.Cast.End(self.UnitID)
				end
			else
				local AlphaVal = self.InterruptEnd - Inspect.Time.Real()
				if self.GUI then
					self.GUI.Progress:SetAlpha(AlphaVal)
					self.GUI.Shadow:SetAlpha(AlphaVal)
					self.GUI.Text:SetAlpha(AlphaVal)
					if AlphaVal < 0.25 then
						self.GUI.Texture:SetAlpha(AlphaVal * 4)
					end
				end
			end
		elseif self.Complete then
			if self.CompleteEnd < Inspect.Time.Real() and self.CompleteFade == true then
				self.Complete = false
				self.CompleteEnd = nil
				self.CompleteFade = false
				if self.GUI then
					if KBM.MainWin:GetVisible() then
						self.GUI.Frame:SetVisible(self.Settings.Visible)
					else
						self.GUI.Frame:SetVisible(false)
					end
					self.GUI:SetText(self.Boss.Name)
					self.GUI.Shadow:SetAlpha(1)
					self.GUI.Text:SetAlpha(1)
					self.GUI.Texture:SetAlpha(1)
					self.GUI.Mask:SetWidth(0)
					if self.Settings.Style == "rift" then
						self.GUI.Highlight:SetAlpha(0)
					end
				end
				KBM.Event.Unit.Cast.End(self.UnitID)
			else
				if not self.CompleteFade then
					self.CompleteAlpha = 1 - (self.CompleteEnd - Inspect.Time.Real())
					if self.CompleteAlpha < 1 then
						if self.GUI then
							self.GUI.Highlight:SetAlpha(self.CompleteAlpha * 4)
						end
					else
						self.CompleteFade = true
						self.CompleteEnd = Inspect.Time.Real() + 0.5
					end
				else
					self.CompleteAlpha = (self.CompleteEnd - Inspect.Time.Real()) * 2
					if self.GUI then
						self.GUI.Texture:SetAlpha(self.CompleteAlpha)
						self.GUI.Progress:SetAlpha(self.CompleteAlpha)
						self.GUI.Shadow:SetAlpha(self.CompleteAlpha)
						self.GUI.Text:SetAlpha(self.CompleteAlpha)
					end
				end
			end
		end			
	end
	
	function CastBarObj:Stop()
		self.Casting = false
		self.LastCast = ""
		if not self.Interrupted and not self.Complete then
			if self.GUI then
				if KBM.MainWin:GetVisible() then
					self.GUI.Frame:SetVisible(self.Settings.Visible)
				else
					self.GUI.Frame:SetVisible(false)
				end
				self.GUI:SetText(self.Boss.Name)
				self.GUI.Shadow:SetAlpha(1)
				self.GUI.Text:SetAlpha(1)
				self.GUI.Texture:SetAlpha(1)
				self.GUI.Mask:SetWidth(0)
				if self.Settings.Style == "rift" then
					self.GUI.Highlight:SetAlpha(0)
				end
			end
			KBM.Event.Unit.Cast.End(self.UnitID)
		else
			if not self.InterruptEnd and self.Interrupted then
				if self.GUI then
					self.GUI:SetText(KBM.Language.CastBar.Interrupt[KBM.Lang])
					self.InterruptEnd = Inspect.Time.Real() + 1
					if self.Settings.Style == "kbm" then
						self.GUI.Progress:SetBackgroundColor(0,7,7,0.33)
					else
						KBM.LoadTexture(self.GUI.Progress, "KingMolinator", "Media/Castbar_Red.png")
					end
					self.GUI.Mask:SetWidth(self.GUI.Progress:GetWidth())
				end
			elseif not self.CompleteEnd and self.Complete then
				self.CompleteEnd = Inspect.Time.Real() + 0.5
				self.CompleteFade = false
			end
		end
		self.Duration = 0
		self.CastTime = 0
		self.CastStart = 0
		self.Channeled = false	
	end
	
	function CastBarObj:Hide(Force)	
		if self.Visible then
			self.Visible = false
			if not self.Active or Force then
				if self.GUI then
					self.GUI = KBM.CastBar:Push(self.GUI)
				end
			elseif not self.Casting then
				if self.GUI then
					self.GUI.Frame:SetVisible(false)
					self.GUI.Drag:SetVisible(false)
				end
			end
		end	
	end
	
	function CastBarObj:Remove()
		self.InterruptEnd = nil
		self.Interrupted = false
		self:Stop()
		if self.UnitID then
			KBM.CastBar.ActiveCastBars[self.UnitID].List[self.ID] = nil
			KBM.CastBar.ActiveCastBars[self.UnitID].Count = KBM.CastBar.ActiveCastBars[self.UnitID].Count - 1
			if KBM.CastBar.ActiveCastBars[self.UnitID].Count == 0 then
				KBM.CastBar.ActiveCastBars[self.UnitID] = nil
			end
		end
		self.UnitID = nil
		self.Active = false
		if self.Dynamic then
			if self.GUI then
				self.GUI = KBM.CastBar:Push(self.GUI)
			end
		else
			if not self.Settings.Visible or not KBM.MainWin:GetVisible() then
				if self.GUI then
					self.GUI = KBM.CastBar:Push(self.GUI)
				end
			end
		end
	end
		
	if not self.Dynamic then
		if not self.CastBarList[Mod.ID] then
			self.CastBarList[Mod.ID] = {}
		end
		table.insert(self.CastBarList[Mod.ID], CastBarObj)
	end
	return CastBarObj
end

local function KBM_Reset()
	if KBM.Encounter then
		KBM.Idle.Wait = true
		KBM.Idle.Until = Inspect.Time.Real() + KBM.Idle.Duration
		KBM.Idle.Combat.Wait = false
		KBM.Encounter = false
		if KBM.CurrentMod then
			KBM.CurrentMod:Reset()
			KBM.CurrentMod = nil
			KBM.CurrentBoss = ""
			KBM_CurrentBossName = ""
		end
		KBM.BossID = {}
		KBM.TimeElapsed = 0
		KBM.TimeStart = 0
		KBM.EnrageTime = 0
		KBM.EnrageTimer = 0
		if KBM.EncTimer.Active then
			KBM.EncTimer:End()
		end
		if KBM.TankSwap.Active then
			KBM.TankSwap:Remove()
		end
		if KBM.Alert.Current then
			KBM.Alert:Stop()
		end
		KBM.MechSpy:End()	
		if #KBM.MechTimer.ActiveTimers > 0 then
			for i, Timer in ipairs(KBM.MechTimer.ActiveTimers) do
				KBM.MechTimer:AddRemove(Timer)
			end
			if #KBM.MechTimer.RemoveTimers > 0 then
				for i, Timer in ipairs(KBM.MechTimer.RemoveTimers) do
					Timer:Stop()
				end
			end
			KBM.MechTimer.RemoveTimers = {}
			KBM.MechTimer.ActiveTimers = {}
			KBM.MechTimer.StartTimers = {}
		end
		KBM.Trigger.Queue:Remove()
		KBM.EncTimer.Settings = KBM.Options.EncTimer
		KBM.EncTimer:ApplySettings()
		KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
		KBM.PhaseMonitor:ApplySettings()
		KBM.MechTimer.Settings = KBM.Options.MechTimer
		KBM.MechTimer:ApplySettings()
		KBM.MechSpy.Settings = KBM.Options.MechSpy
		KBM.MechSpy:ApplySettings()
		KBM.Alert.Settings = KBM.Options.Alerts
		KBM.Alert:ApplySettings()
		KBM.Buffs.Active = {}
		KBM.IgnoreList = {}
	else
		print("No encounter to reset.")
	end
end

function KBM.ConvertTime(Time)
	Time = math.floor(Time)
	local TimeString = "00"
	local TimeSeconds = 0
	local TimeMinutes = 0
	local TimeHours = 0
	if Time > 59 then
		TimeMinutes = math.floor(Time / 60)
		TimeSeconds = Time - (TimeMinutes * 60)
		if TimeMinutes > 59 then
			TimeHours = math.floor(TimeMinutes / 60)
			TimeMinutes = TimeMinutes - (TimeHours * 60)
			TimeString = string.format("%d:%02d:%02d", TimeHours, TimeMinutes, TimeSeconds)
		else
			TimeString = string.format("%02d:%02d", TimeMinutes, TimeSeconds)
		end
	else
		TimeString = string.format("%02d", Time)
	end
	return TimeString
end

function KBM:RaidCombatEnter()

	if KBM.Debug then
		print("Raid has entered combat: Number in combat = "..LibSRM.Group.Combat)
	end
	if KBM.Idle.Combat.Wait then
		KBM.Idle.Combat.Wait = false
	end
	for UnitID, UnitObj in pairs(KBM.Unit.UIDs.Available) do
		UnitObj:CheckTarget()
	end
	
end

function KBM.WipeIt(Force)

	KBM.Idle.Combat.Wait = false
	if KBM.Encounter then
		KBM.TimeElapsed = KBM.Idle.Combat.StoreTime
		if Force then
			print("Encounter ended. Wiped.")
		else
			print(KBM.Language.Encounter.Wipe[KBM.Lang])
		end
		print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
		if KBM.EncounterMode == "chronicle" then
			KBM.CurrentMod.Settings.Records.Chronicle.Wipes = KBM.CurrentMod.Settings.Records.Chronicle.Wipes + 1
		else
			KBM.CurrentMod.Settings.Records.Wipes = KBM.CurrentMod.Settings.Records.Wipes + 1
		end
		KBM_Reset()
		KBM.Event.Encounter.End({Type = "wipe"})
	end
	
end

function KBM:RaidCombatLeave()

	if KBM.Debug then
		print("Raid has left combat")
	end
	if KBM.Options.Enabled then
		if KBM.Encounter then
			if KBM.Debug then
				print("Possible Wipe, waiting raid out of combat")
			end
			KBM.Idle.Combat.Wait = true
			if KBM.CurrentMod.TimeoutOverride then
				KBM.Idle.Combat.Until = Inspect.Time.Real() + KBM.CurrentMod.Timeout
			else
				KBM.Idle.Combat.Until = Inspect.Time.Real() + KBM.Idle.Combat.Duration
			end
			KBM.Idle.Combat.StoreTime = KBM.TimeElapsed
		end
		for UnitID, UnitObj in pairs(KBM.Unit.UIDs.Available) do
			UnitObj:CheckTarget()
		end
	end
	
end

function KBM:UpdateHP(UnitObj)
	if KBM.Encounter then
		if UnitObj then
			if KBM.PhaseMonitor.Active then
				if KBM.PhaseMonitor.Objectives.Lists.Percent[UnitObj.Name] then
					KBM.PhaseMonitor.Objectives.Lists.Percent[UnitObj.Name]:Update(UnitObj.PercentRaw)
				end
			end
		end
	end
end

KBM.ClearBuffers = 0
function KBM:Timer()

	local current = Inspect.Time.Real()
	local diff = (current - self.HeldTime)
	local udiff = (current - self.UpdateTime)
	
	if not KBM.Updating then
		KBM.Updating = true
		if KBM.QueuePage then
			if KBM.MainWin.CurrentPage then
				if KBM.MainWin.CurrentPage.Type == "encounter" then
					KBM.MainWin.CurrentPage:ClearPage()
				else
					KBM.MainWin.CurrentPage:Remove()
				end
			end
		end
		
		if KBM.Options.Enabled then			
			if diff >= 1 then				
				if KBM.Options.CPU.Enabled then
					KBM.CPU:UpdateAll()
				end
				for i, Timer in ipairs(self.RezMaster.Rezes.ActiveTimers) do
					Timer:Update(current)
				end
				self.HeldTime = current
			end
			if KBM.Encounter then
				if KBM.CurrentMod then
					KBM.CurrentMod:Timer(current, diff)
				end
				if diff >= 1 then
					self.LastElapsed = self.TimeElapsed
					self.TimeElapsed = math.floor(current) - self.StartTime
					if not KBM.Testing then
						if KBM.CurrentMod.Enrage then
							self.EnrageTimer = self.EnrageTime - math.floor(current)
						end
						if self.Options.EncTimer.Enabled then
							self.EncTimer:Update(current)
						end
					end
					self.HeldTime = current - (diff - math.floor(diff))
					self.UpdateTime = current
					if not KBM.Testing then
						if self.Trigger.Time[KBM.CurrentMod.ID] then
							for TimeCheck = (self.LastElapsed + 1), self.TimeElapsed do
								if self.Trigger.Time[KBM.CurrentMod.ID][TimeCheck] then
									self.Trigger.Time[KBM.CurrentMod.ID][TimeCheck]:Activate(current)
								end
							end
						end
					end
				end
				for ID, PlugIn in pairs(self.PlugIn.List) do
					PlugIn:Timer(current)
				end	
				for UnitID, CastCheck in pairs(KBM.CastBar.ActiveCastBars) do
					local Trigger = true
					for ID, CastBarObj in pairs(CastCheck.List) do
						CastBarObj:Update(Trigger)
						Trigger = false
					end
				end
				if udiff >= 0.075 then
					for i, Timer in ipairs(self.MechTimer.ActiveTimers) do
						Timer:Update(current)
					end
					KBM.MechSpy:Update(current)
					self.UpdateTime = current
					if not KBM.TankSwap.Test then
						if KBM.TankSwap.Active then
							KBM.TankSwap:Update()
						end
					end
					-- for UnitID, BossObj in pairs(self.BossID) do
						-- if BossObj.available then
							-- self:UpdateHP(UnitID)
						-- end
					-- end
				end
				self.Trigger.Queue:Activate()
				if self.MechTimer.RemoveCount > 0 then
					for i, Timer in ipairs(self.MechTimer.RemoveTimers) do
						Timer:Stop()
					end
					self.MechTimer.RemoveTimers = {}
					self.MechTimer.RemoveCount = 0
				end
				if self.MechTimer.StartCount > 0 then
					for i, Timer in ipairs(self.MechTimer.StartTimers) do
						Timer:Start(current)
					end
					self.MechTimer.StartTimers = {}
					self.MechTimer.StartCount = 0
				end
				if self.Alert.Active then
					self.Alert:Update(current)
				end
				if KBM.Idle.Combat.Wait then
					if KBM.Idle.Combat.Until < current then
						KBM.WipeIt()
					end
				end	
			else
				for ID, PlugIn in pairs(self.PlugIn.List) do
					PlugIn:Timer(current)
				end
				for UnitID, CastCheck in pairs(KBM.CastBar.ActiveCastBars) do
					local Trigger = true
					for ID, CastBarObj in pairs(CastCheck.List) do
						CastBarObj:Update(Trigger)
						Trigger = false
					end
				end
			end
		end
		if KBM.QueuePage then
			if KBM.QueuePage.Type == "encounter" then
				KBM.QueuePage:SetPage()
			else
				KBM.QueuePage:Open()
			end
			KBM.QueuePage = nil
		end		
		if (current - KBM.ClearBuffers) > 15 then
			KBM.ClearBuffers = current
			KBM.Unit:CheckIdle(current)
		end
		KBM.Updating = false
	end
	
	-- local TimeEllapsed = tonumber(string.format("%0.5f", Inspect.Time.Real() - current))
	-- KBM.Watchdog.Main.Count = KBM.Watchdog.Main.Count + 1
	-- KBM.Watchdog.Main.Total = KBM.Watchdog.Main.Total + TimeEllapsed
	-- if KBM.Watchdog.Main.Peak < TimeEllapsed then
		-- KBM.Watchdog.Main.Peak = TimeEllapsed
	-- end	
	
end

function KBM:AuxTimer()
end

local function KBM_CastBar(units)
	-- for UnitID, Status in pairs(units) do
		-- if KBM.CastBar.ActiveCastBars[UnitID] then
			-- local Trigger = true
			-- for ID, CastBarObj in pairs(KBM.CastBar.ActiveCastBars[UnitID].List) do
				-- CastBarObj:Update(Trigger)
				-- Trigger = false
			-- end
		-- end
	-- end
end

local function KM_ToggleEnabled(result)
	
end

local function KBM_UnitRemoved(units)
	if KBM.Encounter then
		for UnitID, Specifier in pairs(units) do
			KBM.Unit:Idle(UnitID)
			if KBM.BossID[UnitID] then
				KBM.BossID[UnitID].available = false
			end
		end
	else
		for UnitID, Specifier in pairs(units) do
			KBM.Unit:Idle(UnitID)
		end	
	end	
end

function KBM.GroupDeath(DeathObj)
	if KBM.Options.Enabled then
		KBM.Unit:Death(DeathObj.target)
		if KBM.Encounter then
			if KBM.TankSwap.Active then
				if KBM.TankSwap.Tanks[DeathObj.target] then
					KBM.TankSwap.Tanks[DeathObj.target]:Death()
				end
			end
			if LibSRM.Dead == LibSRM.GroupCount() then
				if KBM.Debug then
					print("All dead, definate wipe")
					KBM.Idle.Combat.StoreTime = KBM.TimeElapsed
					KBM.WipeIt(true)
				end
			end
		end
	end
end

function KBM.Victory()
	print(KBM.Language.Encounter.Victory[KBM.Lang])
	if KBM.EncounterMode == "normal" then
		if KBM.ValidTime then
			if KBM.CurrentMod.Settings.Records.Best == 0 or (KBM.TimeElapsed < KBM.CurrentMod.Settings.Records.Best) then
				print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
				if KBM.CurrentMod.Settings.Records.Best ~= 0 then
					print(KBM.Language.Records.Previous[KBM.Lang]..KBM.ConvertTime(KBM.CurrentMod.Settings.Records.Best))
					print(KBM.Language.Records.BeatRecord[KBM.Lang])
				else
					print(KBM.Language.Records.NewRecord[KBM.Lang])
				end
				KBM.CurrentMod.Settings.Records.Best = KBM.TimeElapsed
				KBM.CurrentMod.Settings.Records.Date = tostring(os.date())
				KBM.CurrentMod.Settings.Records.Kills = KBM.CurrentMod.Settings.Records.Kills + 1
			else
				print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
				print(KBM.Language.Records.Current[KBM.Lang]..KBM.ConvertTime(KBM.CurrentMod.Settings.Records.Best))
				KBM.CurrentMod.Settings.Records.Kills = KBM.CurrentMod.Settings.Records.Kills + 1
			end
		else
			print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
			print(KBM.Language.Records.Invalid[KBM.Lang])
			KBM.CurrentMod.Settings.Records.Kills = KBM.CurrentMod.Settings.Records.Kills + 1
		end
	elseif KBM.EncounterMode == "chronicle" then
		if KBM.ValidTime then
			if KBM.CurrentMod.Settings.Records.Chronicle.Best == 0 or KBM.TimeElapsed < KBM.CurrentMod.Settings.Records.Chronicle.Best then
				print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
				if KBM.CurrentMod.Settings.Records.Chronicle.Best ~= 0 then
					print(KBM.Language.Records.Previous[KBM.Lang]..KBM.ConvertTime(KBM.CurrentMod.Settings.Records.Chronicle.Best))
					print(KBM.Language.Records.BeatChrRecord[KBM.Lang])
				else
					print(KBM.Language.Records.NewChrRecord[KBM.Lang])
				end
				KBM.CurrentMod.Settings.Records.Chronicle.Best = KBM.TimeElapsed
				KBM.CurrentMod.Settings.Records.Chronicle.Date = tostring(os.date())
				KBM.CurrentMod.Settings.Records.Chronicle.Kills = KBM.CurrentMod.Settings.Records.Chronicle.Kills + 1
			else
				print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))								
				print(KBM.Language.Records.Current[KBM.Lang]..KBM.ConvertTime(KBM.CurrentMod.Settings.Records.Chronicle.Best))
				KBM.CurrentMod.Settings.Records.Kills = KBM.CurrentMod.Settings.Records.Kills + 1
			end
		else
			print(KBM.Language.Timers.Time[KBM.Lang].." "..KBM.ConvertTime(KBM.TimeElapsed))
			print(KBM.Language.Records.Invalid[KBM.Lang])
			KBM.CurrentMod.Settings.Records.Chronicle.Kills = KBM.CurrentMod.Settings.Records.Kills + 1
		end
	end
	KBM_Reset()
	KBM.Event.Encounter.End({Type = "victory"})
end

local function KBM_Death(UnitID)	
	if KBM.Options.Enabled then	
		KBM.Unit:Death(UnitID)
		if KBM.Encounter then
			if UnitID then
				if KBM.BossID[UnitID] then
					KBM.BossID[UnitID].dead = true
					if KBM.PhaseMonitor.Active then
						if KBM.PhaseMonitor.Objectives.Lists.Death[KBM.BossID[UnitID].name] then
							KBM.PhaseMonitor.Objectives.Lists.Death[KBM.BossID[UnitID].name]:Kill(KBM.Unit.List.UID[UnitID])
						end
					end
					if KBM.CurrentMod:Death(UnitID) then
						KBM:Victory()
					end
				end
			end
		end
	end	
end

local function KBM_Help()
	print(KBM.Language.Command.Title[KBM.Lang])
	print(KBM.Language.Command.On[KBM.Lang])
	print(KBM.Language.Command.Off[KBM.Lang])
	print(KBM.Language.Command.Reset[KBM.Lang])
	print(KBM.Language.Command.Version[KBM.Lang])
	print(KBM.Language.Command.Options[KBM.Lang])
	print(KBM.Language.Command.Help[KBM.Lang])
end

function KBM.Notify(data)
	if KBM.Debug then
		print("Notify Capture;")
		dump(data)
	end

	if KBM.Options.Enabled then
		if KBM.Encounter then
			if data.message then
				if KBM.CurrentMod then
					if KBM.Trigger.Notify[KBM.CurrentMod.ID] then
						for i, TriggerObj in ipairs(KBM.Trigger.Notify[KBM.CurrentMod.ID]) do
							sStart, sEnd, Target = string.find(data.message, TriggerObj.Phrase)
							if sStart then
								local unitID = nil
								if Target then
									if KBM.Unit.List.Name[Target] then
										for UnitID, UnitObj in pairs (KBM.Unit.List.Name[Target]) do
											if UnitObj.Player then
												unitID = UnitID
												break
											end
										end
									end
								end
								KBM.Trigger.Queue:Add(TriggerObj, nil, unitID)
								break
							end
						end
					end
				end
			end
		end
	end	
end

function KBM.NPCChat(data)
	if KBM.Debug then
		--print("Chat Capture;")
		--dump(data)
	end

	if KBM.Options.Enabled then
		if KBM.Encounter then
			if data.fromName then
				if KBM.CurrentMod then
					if KBM.Trigger.Say[KBM.CurrentMod.ID] then
						for i, TriggerObj in ipairs(KBM.Trigger.Say[KBM.CurrentMod.ID]) do
							if TriggerObj.Unit.Name == data.fromName then
								sStart, sEnd, Target = string.find(data.message, TriggerObj.Phrase)
								if sStart then
									KBM.Trigger.Queue:Add(TriggerObj, nil, "NotifyObject")
									break
								end
							end
						end
					end
				end
			end
		end
	end
end

function KBM:BuffAdd(unitID, Buffs)
	-- Used to manage Triggers and soon Tank-Swap managing.
	-- local TimeStore = Inspect.Time.Real()
	
	if KBM.Options.Enabled then
		if KBM.Encounter then
			if unitID then
				for BuffID, bool in pairs(Buffs) do
					local bDetails = Inspect.Buff.Detail(unitID, BuffID)
					if bDetails then
						if not KBM.Buffs.Active[unitID] then
							KBM.Buffs.Active[unitID] = {
								Buff_Count = 1,
							}
						else
							KBM.Buffs.Active[unitID].Buff_Count = KBM.Buffs.Active[unitID].Buff_Count + 1
						end
						KBM.Buffs.Active[unitID][BuffID] = bDetails
						if KBM.Trigger.Buff[KBM.CurrentMod.ID] then
							if KBM.Trigger.Buff[KBM.CurrentMod.ID][bDetails.name] then
								TriggerObj = KBM.Trigger.Buff[KBM.CurrentMod.ID][bDetails.name]
								if TriggerObj.Unit.UnitID == unitID then
									KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
								end
							end
						end
						if KBM.Trigger.PlayerDebuff[KBM.CurrentMod.ID] ~= nil and bDetails.debuff == true then
							if KBM.Trigger.PlayerDebuff[KBM.CurrentMod.ID][bDetails.name] then
								TriggerObj = KBM.Trigger.PlayerDebuff[KBM.CurrentMod.ID][bDetails.name]
								if LibSRM.Group.UnitExists(unitID) ~= nil or unitID == KBM.Player.UnitID then
									if KBM.Debug then
										print("Debuff Trigger matched: "..bDetails.name)
										if LibSRM.Grouped() then
											print("LibSRM Match: "..tostring(LibSRM.Group.UnitExists(unitID)))
										end
										print("Player Match: "..KBM.Player.UnitID.." - "..unitID)
										print("---------------")
										dump(bDetails)
									end
									KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
								end
							end
						end
						if KBM.Trigger.PlayerIDBuff[KBM.CurrentMod.ID] then
							if KBM.Trigger.PlayerIDBuff[KBM.CurrentMod.ID][bDetails.type] then
								TriggerObj = KBM.Trigger.PlayerIDBuff[KBM.CurrentMod.ID][bDetails.type]
								if LibSRM.Group.UnitExists(unitID) ~= nil or unitID == KBM.Player.UnitID then
									if KBM.Debug then
										print("Debuff Trigger matched: "..bDetails.name)
										if LibSRM.Grouped() then
											print("LibSRM Match: "..tostring(LibSRM.Group.UnitExists(unitID)))
										end
										print("Player Match: "..KBM.Player.UnitID.." - "..unitID)
										print("---------------")
										dump(bDetails)
									end
									KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
								end
							end
						end
						if KBM.Trigger.PlayerBuff[KBM.CurrentMod.ID] then
							if KBM.Trigger.PlayerBuff[KBM.CurrentMod.ID][bDetails.name] then
								TriggerObj = KBM.Trigger.PlayerBuff[KBM.CurrentMod.ID][bDetails.name]
								if LibSRM.Group.UnitExists(unitID) ~= nil or unitID == KBM.Player.UnitID then
									if KBM.Debug then
										print("Buff Trigger matched: "..bDetails.name)
										if LibSRM.Grouped() then
											print("LibSRM Match: "..tostring(LibSRM.Group.UnitExists(unitID)))
										end
										print("Player Match: "..KBM.Player.UnitID.." - "..unitID)
										print("---------------")
										dump(bDetails)
									end
									KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
								end
							end
						end
						if KBM.TankSwap.Active then
							if KBM.TankSwap.Tanks[unitID] then
								if KBM.TankSwap.DebuffName[bDetails.name] then
									KBM.TankSwap.Tanks[unitID]:BuffUpdate(BuffID, bDetails.name)
								end
							end
						end
					end
				end
			end
		else
			if unitID then
				for BuffID, bool in pairs(Buffs) do
					local bDetails = Inspect.Buff.Detail(unitID, BuffID)
					if bDetails then
						if not KBM.Buffs.Active[unitID] then
							KBM.Buffs.Active[unitID] = {
								Buff_Count = 1,
							}
						else
							KBM.Buffs.Active[unitID].Buff_Count = KBM.Buffs.Active[unitID].Buff_Count + 1
						end
						KBM.Buffs.Active[unitID][BuffID] = bDetails
						if KBM.Trigger.EncStart["playerBuff"] then
							if KBM.Trigger.EncStart["playerBuff"][bDetails.name] then
								TriggerMod = KBM.Trigger.EncStart["playerBuff"][bDetails.name]
								if TriggerMod.Dummy then
									KBM.CheckActiveBoss(TriggerMod.Dummy.Details, "Dummy")
								end
							end
						end
					end
				end
			end
		end
	end
	-- local TimeEllapsed = tonumber(string.format("%0.05f", Inspect.Time.Real() - TimeStore))
	-- local TimeLeft = Inspect.System.Watchdog()
	-- KBM.Watchdog.Buffs.Count = KBM.Watchdog.Buffs.Count + 1
	-- KBM.Watchdog.Buffs.Total = KBM.Watchdog.Buffs.Total + TimeEllapsed
	-- if KBM.Watchdog.Buffs.Peak < TimeEllapsed then
		-- KBM.Watchdog.Buffs.Peak = TimeEllapsed
	-- end
	-- if KBM.Watchdog.Buffs.wTime > TimeLeft then
		-- KBM.Watchdog.Buffs.wTime = TimeLeft
	-- end
	
end

function KBM:BuffRemove(unitID, Buffs)
	
	if KBM.Options.Enabled then
		if KBM.Encounter then
			if unitID then
				if KBM.Buffs.Active[unitID] then
					for BuffID, bool in pairs(Buffs) do
						if BuffID then
							if KBM.Buffs.Active[unitID][BuffID] then
								bDetails = KBM.Buffs.Active[unitID][BuffID]
								if KBM.Trigger.BuffRemove[KBM.CurrentMod.ID] then
									if KBM.Trigger.BuffRemove[KBM.CurrentMod.ID][bDetails.name] then
										TriggerObj = KBM.Trigger.BuffRemove[KBM.CurrentMod.ID][bDetails.name]
										if TriggerObj.Unit.UnitID == unitID then
											KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, nil)
										end
									end
								end
								if KBM.Trigger.PlayerBuffRemove[KBM.CurrentMod.ID] then
									if KBM.Trigger.PlayerBuffRemove[KBM.CurrentMod.ID][bDetails.name] then
										TriggerObj = KBM.Trigger.PlayerBuffRemove[KBM.CurrentMod.ID][bDetails.name]
										if LibSRM.Group.UnitExists(unitID) or unitID == KBM.Player.UnitID then
											KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, nil)
										end
									end
								end
								if KBM.Trigger.PlayerIDBuffRemove[KBM.CurrentMod.ID] then
									if KBM.Trigger.PlayerIDBuffRemove[KBM.CurrentMod.ID][bDetails.type] then
										TriggerObj = KBM.Trigger.PlayerIDBuffRemove[KBM.CurrentMod.ID][bDetails.type]
										if LibSRM.Group.UnitExists(unitID) or unitID == KBM.Player.UnitID then
											KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, nil)
										end
									end
								end
								KBM.Buffs.Active[unitID][BuffID] = nil
								KBM.Buffs.Active[unitID].Buff_Count = KBM.Buffs.Active[unitID].Buff_Count - 1
								if KBM.Buffs.Active[unitID].Buff_Count == 0 then
									KBM.Buffs.Active[unitID] = nil
								end
							end
						end
					end
				end
			end
		else
			if unitID then
				if KBM.Buffs.Active[unitID] then
					for BuffID, bool in pairs(Buffs) do
						if BuffID then
							if KBM.Buffs.Active[unitID][BuffID] then
								bDetails = KBM.Buffs.Active[unitID][BuffID]
								KBM.Buffs.Active[unitID][BuffID] = nil
								KBM.Buffs.Active[unitID].Buff_Count = KBM.Buffs.Active[unitID].Buff_Count - 1
								if KBM.Buffs.Active[unitID].Buff_Count == 0 then
									KBM.Buffs.Active[unitID] = nil
								end
							end
						end
					end
				end
			end
		end
	end

end

function KBM.FormatPrecision(Val)
	if Val < 0.000001 or Val == nil then
		return "Too Low"
	else
		return string.format("%0.6fs", Val)
	end
end

function KBM.Watchdog.Display(Type, Var)
	-- if Var == "all" then
		-- for Index, wdObj in pairs(KBM.Options.Watchdog[Type].Sessions) do
			-- wdObj.Average = tonumber(string.format("%0.6f", wdObj.Total / wdObj.Count)) or 0
			-- print("Session Index: "..tostring(Index))
			-- print("Total Time: "..KBM.FormatPrecision(wdObj.Total))
			-- print("Average Execution Time: "..KBM.FormatPrecision(wdObj.Average))
			-- print("Peak Execution Time: "..KBM.FormatPrecision(wdObj.Peak))
			-- print("Lowest Remaining Watching Time: "..KBM.FormatPrecision(wdObj.wTime))
			-- print("Total Calls: "..wdObj.Count)	
			-- print("--------------------------------")
		-- end
	-- elseif Var == "clear" then
		-- print("Clearing Session History")
		-- KBM.Watchdog.Clear(Type)
	-- else
		-- KBM.Watchdog[Type].Average = tonumber(string.format("%0.6f", KBM.Watchdog[Type].Total / KBM.Watchdog[Type].Count)) or 0	
		-- print("Total Time: "..KBM.FormatPrecision(KBM.Watchdog[Type].Total))
		-- print("Average Execution Time: "..KBM.FormatPrecision(KBM.Watchdog[Type].Average))
		-- print("Peak Execution Time: "..KBM.FormatPrecision(KBM.Watchdog[Type].Peak))
		-- print("Lowest Remaining Watching Time: "..KBM.FormatPrecision(KBM.Watchdog[Type].wTime))
		-- print("Total Calls: "..KBM.Watchdog[Type].Count)
	-- end
end

function KBM.Watchdog.Clear(Type)
	KBM.Options.Watchdog[Type].sCount = 1
	KBM.Options.Watchdog[Type].Sessions = {}
	KBM.Options.Watchdog[Type].Sessions[1] = {
		Total = 0,
		Average = 0,
		Peak = 0,
		Count = 0,
	}
	KBM.Watchdog[Type] = KBM.Options.Watchdog[Type].Sessions[1]
end

function KBM.VersionReqCheckb(name, failed, message)
	if not failed then
		print("Version request sent successfully for "..name.."!")
	else
		print("Version request failed for: "..tostring(name))
	end
end

function KBM.VersionReqCheck(name, failed, message)
	if not failed then
		print("Version request sent successfully for "..name.."!")
	else
		Command.Message.Broadcast("tell", name, "KBMVerReq", "V", function (failed, message) KBM.VersionReqCheckb(name, failed, message) end)
	end
end

local function KBM_Version(name)
	if string.find(name, "%t") then
		local nameLU = Inspect.Unit.Lookup("player.target")
		if nameLU then
			nameLU_Details = Inspect.Unit.Detail(nameLU)
			if nameLU_Details then
				name = nameLU_Details.name
			end
		end
	end
	if type(name) == "string" and name ~= "" then
		Command.Message.Send(name, "KBMVerReq", "V", function (failed, message) KBM.VersionReqCheck(name, failed, message) end)
	else
		print(KBM.Language.Version.Title[KBM.Lang])
		if KBM.IsAlpha then
			print("King Boss Mods v"..AddonData.toc.Version.." Alpha")
		else
			print("King Boss Mods v"..AddonData.toc.Version)
		end
	end
end

function KBM.StateSwitch(bool)
	KBM.Options.Enabled = bool
	if KBM.Options.Enabled then
		print("King Boss Mods is now Enabled.")
	else
		print("King Boss Mods is now Disabled.")
		if KBM.Encounter then
			print("Stopping running Encounter.")
			KBM_Reset()
		end
	end
end

---------------------------------------------
-----          Menu Options            ------
---------------------------------------------
-- Phase Monitor options.
function KBM.MenuOptions.Phases:Options()
	
	-- Phase Monitor Callbacks.
	function self:Enabled(bool)
		KBM.Options.PhaseMon.Enabled = bool
		if KBM.Options.PhaseMon.Visible then
			if bool then
				KBM.PhaseMonitor.Anchor:SetVisible(true)
			else
				KBM.PhaseMonitor.Anchor:SetVisible(false)
			end
		end
	end
	function self:Visible(bool)
		KBM.Options.PhaseMon.Visible = bool
		KBM.PhaseMonitor.Anchor:SetVisible(bool)
		KBM.Options.PhaseMon.Unlocked = bool
		KBM.PhaseMonitor.Anchor.Drag:SetVisible(bool)
	end
	function self:PhaseDisplay(bool)
		KBM.Options.PhaseMon.PhaseDisplay = bool
	end
	function self:Objectives(bool)
		KBM.Options.PhaseMon.Objectives = bool
	end
	function self:ScaleWidth(bool)
		KBM.Options.PhaseMon.ScaleWidth = bool
	end
	function self:ScaleHeight(bool)
		KBM.Options.PhaseMon.ScaleHeight = bool
	end
	function self:TextScale(bool)
		KBM.Options.PhaseMon.TextScale = bool
	end
	
	local Options = self.MenuItem.Options
	Options:SetTitle()
	
	-- Timer Options
	local PhaseMon = Options:AddHeader(KBM.Language.Options.PhaseEnabled[KBM.Lang], self.Enabled, KBM.Options.PhaseMon.Enabled)
	PhaseMon:AddCheck(KBM.Language.Options.Phases[KBM.Lang], self.PhaseDisplay, KBM.Options.PhaseMon.PhaseDisplay)
	PhaseMon:AddCheck(KBM.Language.Options.Objectives[KBM.Lang], self.Objectives, KBM.Options.PhaseMon.Objectives)
	PhaseMon:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.Visible, KBM.Options.PhaseMon.Visible)
	PhaseMon:AddCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], self.ScaleWidth, KBM.Options.PhaseMon.ScaleWidth)
	PhaseMon:AddCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], self.ScaleHeight, KBM.Options.PhaseMon.ScaleHeight)
	PhaseMon:AddCheck(KBM.Language.Options.UnlockText[KBM.Lang], self.TextScale, KBM.Options.PhaseMon.TextScale)
	
end

-- Timer options.
function KBM.MenuOptions.Timers:Options()
	
	-- Encounter Timer callbacks.
	function self:EncTimersEnabled(bool)
		KBM.Options.EncTimer.Enabled = bool
	end
	function self:ShowEncTimer(bool)
		KBM.Options.EncTimer.Visible = bool
		KBM.EncTimer.Frame:SetVisible(bool)
		KBM.EncTimer.Enrage.Frame:SetVisible(bool)
		KBM.Options.EncTimer.Unlocked = bool
		KBM.EncTimer.Frame.Drag:SetVisible(bool)
	end
	function self:EncDuration(bool)
		KBM.Options.EncTimer.Duration = bool
	end
	function self:EncEnrage(bool)
		KBM.Options.EncTimer.Enrage = bool
	end
	function self:EncScaleHeight(bool, Check)
		KBM.Options.EncTimer.ScaleHeight = bool
	end
	function self:EncScaleWidth(bool, Check)
		KBM.Options.EncTimer.ScaleWidth = bool
	end
	function self:EncTextSize(bool, Check)
		KBM.Options.EncTimer.TextScale = bool
	end
	
	-- Timer Callbacks
	function self:MechEnabled(bool)
		KBM.Options.MechTimer.Enabled = bool
	end
	function self:MechShadow(bool)
		KBM.Options.MechTimer.Shadow = bool
	end
	function self:MechTexture(bool)
		KBM.Options.MechTimer.Texture = bool
	end
	function self:ShowMechAnchor(bool)
		KBM.Options.MechTimer.Visible = bool
		KBM.MechTimer.Anchor:SetVisible(bool)
		KBM.Options.MechTimer.Unlocked = bool
		KBM.MechTimer.Anchor.Drag:SetVisible(bool)
		if #KBM.MechTimer.ActiveTimers > 0 then
			KBM.MechTimer.Anchor.Text:SetVisible(false)
		else
			if bool then
				KBM.MechTimer.Anchor.Text:SetVisible(true)
			end
		end
	end
	function self:MechScaleHeight(bool, Check)
		KBM.Options.MechTimer.ScaleHeight = bool
	end
	function self:MechScaleWidth(bool, Check)
		KBM.Options.MechTimer.ScaleWidth = bool
	end
	function self:MechTextSize(bool, Check)
		KBM.Options.MechTimer.TextScale = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	
	-- Timer Options
	local Timers = Options:AddHeader(KBM.Language.Options.EncTimers[KBM.Lang], self.EncTimersEnabled, KBM.Options.EncTimer.Enabled)
	Timers:AddCheck(KBM.Language.Options.Timer[KBM.Lang], self.EncDuration, KBM.Options.EncTimer.Duration)
	Timers:AddCheck(KBM.Language.Options.Enrage[KBM.Lang], self.EncEnrage, KBM.Options.EncTimer.Enrage)
	Timers:AddCheck(KBM.Language.Options.ShowTimer[KBM.Lang], self.ShowEncTimer, KBM.Options.EncTimer.Visible)
	Timers:AddCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], self.EncScaleWidth, KBM.Options.EncTimer.ScaleWidth)
	Timers:AddCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], self.EncScaleHeight, KBM.Options.EncTimer.ScaleHeight)
	Timers:AddCheck(KBM.Language.Options.UnlockText[KBM.Lang], self.EncTextSize, KBM.Options.EncTimer.TextScale)
	local MechTimers = Options:AddHeader(KBM.Language.Options.MechanicTimers[KBM.Lang], self.MechEnabled, true)
	MechTimers.GUI.Check:SetEnabled(false)
	KBM.Options.MechTimer.Enabled = true
	MechTimers:AddCheck(KBM.Language.Options.Texture[KBM.Lang], self.MechTexture, KBM.Options.MechTimer.Texture)
	MechTimers:AddCheck(KBM.Language.Options.Shadow[KBM.Lang], self.MechShadow, KBM.Options.MechTimer.Shadow)
	MechTimers:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowMechAnchor, KBM.Options.MechTimer.Visible)
	MechTimers:AddCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], self.MechScaleWidth, KBM.Options.MechTimer.ScaleWidth)
	MechTimers:AddCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], self.MechScaleHeight, KBM.Options.MechTimer.ScaleHeight)
	MechTimers:AddCheck(KBM.Language.Options.UnlockText[KBM.Lang], self.MechTextSize, KBM.Options.MechTimer.TextScale)
	
end

-- Tank-Swap Close link.
function KBM.MenuOptions.TankSwap:Close()
	if KBM.TankSwap.Active then
		if KBM.TankSwap.Test then
			self.TestCheck.GUI.Check:SetChecked(false)
		end
	end
end

-- Tank Swap options.
function KBM.MenuOptions.TankSwap:Options()

	function self:Enabled(bool)
		KBM.Options.TankSwap.Enabled = bool
		KBM.TankSwap.Enabled = bool
	end
	function self:ShowAnchor(bool)
		KBM.Options.TankSwap.Visible = bool
		if not KBM.TankSwap.Active then
			KBM.TankSwap.Anchor:SetVisible(bool)
		end
	end
	function self:LockAnchor(bool)
		KBM.Options.TankSwap.Unlocked = bool
		KBM.TankSwap.Anchor.Drag:SetVisible(bool)
	end
	function self:ScaleWidth(bool, Check)
		KBM.Options.TankSwap.ScaleWidth = bool
		if not bool then
			KBM.Options.TankSwap.wScale = 1
			--Check.SliderObj.Bar.Frame:SetPosition(100)
			KBM.TankSwap.Anchor:SetWidth(KBM.Options.TankSwap.w)
		end
	end
	function self:wScaleChange(value)
		KBM.Options.TankSwap.wScale = value * 0.01
		KBM.TankSwap.Anchor:SetWidth(KBM.Options.TankSwap.w * KBM.Options.TankSwap.wScale)
	end
	function self:ScaleHeight(bool, Check)
		KBM.Options.TankSwap.ScaleHeight = bool
		if not bool then
			KBM.Options.TankSwap.hScale = 1
			--Check.SliderObj.Bar.Frame:SetPosition(100)
			KBM.TankSwap.Anchor:SetHeight(KBM.Options.TankSwap.h)
		end
	end
	function self:hScaleChange(value)
		KBM.Options.TankSwap.hScale = value * 0.01
		KBM.TankSwap.Anchor:SetHeight(KBM.Options.TankSwap.h * KBM.Options.TankSwap.hScale)
	end
	function self:TextSize(bool, Check)
		KBM.Options.TankSwap.TextScale = bool
		if not bool then
			KBM.Options.TankSwap.TextSize = 16
			--Check.Slider.Bar:SetPosition(KBM.Options.CastBar.TextSize)
			KBM.TankSwap.Anchor.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
		end
	end
	function self:TextChange(value)
		KBM.Options.TankSwap.TextSize = value
		KBM.CastBar.Anchor.Text:SetFontSize(KBM.Options.TankSwap.TextSize)
	end
	function self:ShowTest(bool)
		if bool then
			KBM.TankSwap:Add("Dummy", "Tank A")
			KBM.TankSwap:Add("Dummy", "Tank B")
			KBM.TankSwap:Add("Dummy", "Tank C")
			KBM.TankSwap.Anchor:SetVisible(false)
		else
			KBM.TankSwap:Remove()
			KBM.TankSwap.Anchor:SetVisible(KBM.Options.TankSwap.Visible)
		end
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()

	-- Tank-Swap Options. 
	local TankSwap = Options:AddHeader(KBM.Language.Options.TankSwapEnabled[KBM.Lang], self.Enabled, KBM.Options.TankSwap.Enabled)
	TankSwap:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowAnchor, KBM.Options.TankSwap.Visible)
	TankSwap:AddCheck(KBM.Language.Options.LockAnchor[KBM.Lang], self.LockAnchor, KBM.Options.TankSwap.Unlocked)
	self.TestCheck = TankSwap:AddCheck(KBM.Language.Options.Tank[KBM.Lang], self.ShowTest, false)

end

-- Castbar options
function KBM.MenuOptions.CastBars:Options()

	-- Castbar Callbacks
	function self:Enabled(bool)
		KBM.Options.CastBar.Enabled = bool
	end
	function self:Texture(bool)
		KBM.Options.CastBar.Texture = bool
		if KBM.CastBar.Anchor.GUI then
			KBM.CastBar.Anchor.GUI.Texture:SetVisible(bool)
		end
	end
	function self:Shadow(bool)
		KBM.Options.CastBar.Shadow = bool
		if KBM.CastBar.Anchor.GUI then
			KBM.CastBar.Anchor.GUI.Shadow:SetVisible(bool)
		end
	end
	function self:Visible(bool)
		KBM.Options.CastBar.Visible = bool
		KBM.Options.CastBar.Unlocked = bool
		if bool then
			KBM.CastBar.Anchor:Display()
		else
			KBM.CastBar.Anchor:Hide()
		end
	end
	function self:Width(bool)
		KBM.Options.CastBar.ScaleWidth = bool
	end
	function self:Height(bool)
		KBM.Options.CastBar.ScaleHeight = bool
	end
	function self:Text(bool)
		KBM.Options.CastBar.TextScale = bool
	end
	function self:Style(bool)
		KBM.CastBar.Anchor:Hide(true)
		if bool then
			KBM.Options.CastBar.Style = "rift"
		else
			KBM.Options.CastBar.Style = "kbm"
		end
		KBM.CastBar.Anchor:Display()
	end
	function self:Player(bool)
		KBM.Player.CastBar.Settings.CastBar.Enabled = bool
		if bool then
			KBM.Player.CastBar.CastObj:Create(KBM.Player.UnitID)
		else
			KBM.Player.CastBar.CastObj:Remove()
		end
	end
	function self:Player_Style(bool)
		KBM.Player.CastBar.CastObj:Hide(true)
		if bool then
			KBM.Player.CastBar.Settings.CastBar.Style = "rift"
		else
			KBM.Player.CastBar.Settings.CastBar.Style = "kbm"
		end
		KBM.Player.CastBar.CastObj:Display()
	end
	function self:Mimic(bool)
		KBM.Player.CastBar.Settings.CastBar.Pinned = bool
		KBM.Player.CastBar.CastObj:ApplySettings()
	end
	function self:Player_Texture(bool)
		KBM.Player.CastBar.Settings.CastBar.Texture = bool
		KBM.Player.CastBar.CastObj:ApplySettings()
	end
	function self:Player_Shadow(bool)
		KBM.Player.CastBar.Settings.CastBar.Shadow = bool
		KBM.Player.CastBar.CastObj:ApplySettings()
	end
	function self:Player_Visible(bool)
		KBM.Player.CastBar.Settings.CastBar.Visible = bool
		KBM.Player.CastBar.Settings.CastBar.Unlocked = bool
		if bool then
			KBM.Player.CastBar.CastObj:Display()
		else
			KBM.Player.CastBar.CastObj:Hide()
		end
	end
	function self:Player_Width(bool)
		KBM.Player.CastBar.Settings.CastBar.ScaleWidth = bool
	end
	function self:Player_Height(bool)
		KBM.Player.CastBar.Settings.CastBar.ScaleHeight = bool
	end
	function self:Player_Text(bool)
		KBM.Player.CastBar.Settings.CastBar.TextScale = bool
	end
		
	local Options = self.MenuItem.Options
	Options:SetTitle()

	-- CastBar Options. 
	local CastBars = Options:AddHeader(KBM.Language.Options.CastbarEnabled[KBM.Lang], self.Enabled, KBM.Options.CastBar.Enabled)
	if KBM.Options.CastBar.Style == "rift" then
		CastBars:AddCheck(KBM.Language.Options.CastbarStyle[KBM.Lang], self.Style, true)
	else
		CastBars:AddCheck(KBM.Language.Options.CastbarStyle[KBM.Lang], self.Style, false)
	end
	CastBars:AddCheck(KBM.Language.Options.Texture[KBM.Lang], self.Texture, KBM.Options.CastBar.Texture)
	CastBars:AddCheck(KBM.Language.Options.Shadow[KBM.Lang], self.Shadow, KBM.Options.CastBar.Shadow)
	CastBars:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.Visible, KBM.Options.CastBar.Visible)
	CastBars:AddCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], self.Width, KBM.Options.CastBar.ScaleWidth)
	CastBars:AddCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], self.Height, KBM.Options.CastBar.ScaleHeight)
	CastBars:AddCheck(KBM.Language.Options.UnlockText[KBM.Lang], self.Text, KBM.Options.CastBar.TextScale)
	local PlayerBar = Options:AddHeader(KBM.Language.CastBar.Player[KBM.Lang], self.Player, KBM.Player.CastBar.Settings.CastBar.Enabled)
	if KBM.Player.CastBar.Settings.CastBar.Style == "rift" then
		PlayerBar:AddCheck(KBM.Language.Options.CastbarStyle[KBM.Lang], self.Player_Style, true)
	else
		PlayerBar:AddCheck(KBM.Language.Options.CastbarStyle[KBM.Lang], self.Player_Style, false)
	end
	PlayerBar:AddCheck(KBM.Language.CastBar.Mimic[KBM.Lang], self.Mimic, KBM.Player.CastBar.Settings.CastBar.Pinned)
	PlayerBar:AddCheck(KBM.Language.Options.Texture[KBM.Lang], self.Player_Texture, KBM.Player.CastBar.Settings.CastBar.Texture)
	PlayerBar:AddCheck(KBM.Language.Options.Shadow[KBM.Lang], self.Player_Shadow, KBM.Player.CastBar.Settings.CastBar.Shadow)
	PlayerBar:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.Player_Visible, KBM.Player.CastBar.Settings.CastBar.Visible)
	PlayerBar:AddCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], self.Player_Width, KBM.Player.CastBar.Settings.CastBar.ScaleWidth)
	PlayerBar:AddCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], self.Player_Height, KBM.Player.CastBar.Settings.CastBar.ScaleHeight)
	PlayerBar:AddCheck(KBM.Language.Options.UnlockText[KBM.Lang], self.Player_Text, KBM.Player.CastBar.Settings.CastBar.TextScale)

end

-- Alert options.
function KBM.MenuOptions.Alerts:Options()

	function self:AlertEnabled(bool)
		KBM.Options.Alerts.Enabled = bool
	end
	function self:ShowAnchor(bool)
		KBM.Options.Alerts.Visible = bool
		if bool then
			KBM.Alert.Anchor:SetAlpha(1)
			KBM.Alert.Left.red:SetAlpha(1)
			KBM.Alert.Right.red:SetAlpha(1)
			KBM.Alert.Top.red:SetAlpha(1)
			KBM.Alert.Bottom.red:SetAlpha(1)
		end
		KBM.Alert:ApplySettings()
	end
	function self:ScaleText(bool)
		KBM.Options.Alerts.ScaleText = bool
	end
	function self:UnlockFlash(bool)
		KBM.Options.Alerts.FlashUnlocked = bool
		-- if KBM.Options.Alerts.Visible then
			-- KBM.Alert.AlertControl.Left:SetVisible(bool)
			-- KBM.Alert.AlertControl.Right:SetVisible(bool)
			-- KBM.Alert.AlertControl.Top:SetVisible(bool)
			-- KBM.Alert.AlertControl.Bottom:SetVisible(bool)
		-- end
		KBM.Alert:ApplySettings()
	end
	function self:FlashEnabled(bool)
		KBM.Options.Alerts.Flash = bool
	end
	function self:VertEnabled(bool)
		KBM.Options.Alerts.Vertical = bool
		KBM.Alert:ApplySettings()
	end
	function self:HorzEnabled(bool)
		KBM.Options.Alerts.Horizontal = bool
		KBM.Alert:ApplySettings()
	end
	function self:TextEnabled(bool)
		KBM.Options.Alerts.Notify = bool
	end
	
	local Options = self.MenuItem.Options
	Options:SetTitle()

	local Alert = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.AlertEnabled, KBM.Options.Alerts.Enabled)
	Alert:AddCheck(KBM.Language.Options.AlertText[KBM.Lang], self.TextEnabled, KBM.Options.Alerts.Notify)
	Alert:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.ShowAnchor, KBM.Options.Alerts.Visible)
	Alert:AddCheck(KBM.Language.Options.UnlockText[KBM.Lang], self.ScaleText, KBM.Options.Alerts.ScaleText)
	Alert:AddCheck(KBM.Language.Options.UnlockFlash[KBM.Lang], self.UnlockFlash, KBM.Options.Alerts.FlashUnlocked)
	local AlertBars = Options:AddHeader(KBM.Language.Options.AlertFlash[KBM.Lang], self.FlashEnabled, KBM.Options.Alerts.Flash)
	AlertBars:AddCheck(KBM.Language.Options.AlertVert[KBM.Lang], self.VertEnabled, KBM.Options.Alerts.Vertical)
	AlertBars:AddCheck(KBM.Language.Options.AlertHorz[KBM.Lang], self.HorzEnabled, KBM.Options.Alerts.Horizontal)	
end

-- Mechanic Spy Options
function KBM.MenuOptions.MechSpy:Options()
	function self:Enabled(bool)
		KBM.Options.MechSpy.Enabled = bool
		KBM.MechSpy:ApplySettings()
	end
	function self:Show(bool)
		KBM.Options.MechSpy.Show = bool
		KBM.MechSpy:ApplySettings()
	end
	function self:Anchor(bool)
		KBM.Options.MechSpy.Visible = bool
		KBM.MechSpy:ApplySettings()		
	end
	function self:Width(bool)
		KBM.Options.MechSpy.ScaleWidth = bool
	end
	function self:Height(bool)
		KBM.Options.MechSpy.ScaleHeight = bool
	end
	function self:Text(bool)
		KBM.Options.MechSpy.ScaleText = bool
	end
	
	local Options = self.MenuItem.Options
	Options:SetTitle()
	
	local MechSpy = Options:AddHeader(KBM.Language.MechSpy.Enabled[KBM.Lang], self.Enabled, KBM.Options.MechSpy.Enabled)
	MechSpy:AddCheck(KBM.Language.MechSpy.Show[KBM.Lang], self.Show, KBM.Options.MechSpy.Show)
	MechSpy:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.Anchor, KBM.Options.MechSpy.Visible)
	MechSpy:AddCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], self.Width, KBM.Options.MechSpy.ScaleWidth)
	MechSpy:AddCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], self.Height, KBM.Options.MechSpy.ScaleHeight)
	MechSpy:AddCheck(KBM.Language.Options.UnlockText[KBM.Lang], self.Text, KBM.Options.MechSpy.ScaleText)
end

-- Main options.
function KBM.MenuOptions.Main:Options()
	function self:Character(bool)
		KBM.Options.Character = bool
		if bool then
			KBM_GlobalOptions = KBM.Options
			KBM.Options = chKBM_GlobalOptions
			KBM.Options.Character = true
			for _, Mod in ipairs(KBM.ModList) do
				if Mod.SwapSettings then
					Mod:SwapSettings(bool)
				end
			end
		else
			chKBM_GlobalOptions = KBM.Options
			KBM.Options = KBM_GlobalOptions
			KBM.Options.Character = false
			for _, Mod in ipairs(KBM.ModList) do
				if Mod.SwapSettings then
					Mod:SwapSettings(bool)
				end
			end
		end
	end

	function self:Enabled(bool)
		KBM.StateSwitch(bool)
	end

	function self:ButtonVisible(bool)
		KBM.Options.Button.Visible = bool
		KBM.Button.Texture:SetVisible(bool)
	end

	function self:LockButton(bool)
		KBM.Options.Button.Unlocked = bool
		KBM.Button.Drag:SetVisible(bool)
	end

	local Options = self.MenuItem.Options
	Options:SetTitle()
	Options:AddHeader(KBM.Language.Options.Character[KBM.Lang], self.Character, KBM.Options.Character)
	if KBM.IsAlpha then
		Options:AddHeader(KBM.Language.Options.ModEnabled[KBM.Lang].." Alpha", self.Enabled, KBM.Options.Enabled)
	else
		Options:AddHeader(KBM.Language.Options.ModEnabled[KBM.Lang], self.Enabled, KBM.Options.Enabled)
	end
	local Button = Options:AddHeader(KBM.Language.Options.Button[KBM.Lang], self.ButtonVisible, KBM.Options.Button.Visible)
	Button:AddCheck(KBM.Language.Options.LockButton[KBM.Lang], self.LockButton, KBM.Options.Button.Unlocked)
end

-- Rez Master Options
function KBM.MenuOptions.RezMaster:Options()
	function self:Enabled(bool)
		KBM.Options.RezMaster.Enabled = bool
		if bool then
			KBM.PlayerControl:GatherAbilities(true)
			KBM.PlayerControl:GatherRaidInfo()
		else
			KBM.RezMaster.Rezes:Clear()
		end
	end
	function self:Visible(bool)
		KBM.Options.RezMaster.Visible = bool
		KBM.Options.RezMaster.Unlocked = bool
		KBM.RezMaster.GUI:ApplySettings()
	end
	function self:Width(bool)
		KBM.Options.RezMaster.ScaleWidth = bool
	end
	function self:Height(bool)
		KBM.Options.RezMaster.ScaleHeight = bool
	end
	function self:Text(bool)
		KBM.Options.RezMaster.ScaleText = bool
	end
	
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local RezMaster = Options:AddHeader(KBM.Language.RezMaster.Enabled[KBM.Lang], self.Enabled, KBM.Options.RezMaster.Enabled)
	RezMaster:AddCheck(KBM.Language.Options.ShowAnchor[KBM.Lang], self.Visible, KBM.Options.RezMaster.Visible)
	RezMaster:AddCheck(KBM.Language.Options.UnlockWidth[KBM.Lang], self.Width, KBM.Options.RezMaster.ScaleWidth)
	RezMaster:AddCheck(KBM.Language.Options.UnlockHeight[KBM.Lang], self.Height, KBM.Options.RezMaster.ScaleHeight)
	RezMaster:AddCheck(KBM.Language.Options.UnlockText[KBM.Lang], self.Text, KBM.Options.RezMaster.ScaleText)
end

function KBM.ApplySettings()
	KBM.TankSwap.Enabled = KBM.Options.TankSwap.Enabled
end

function KBM_Debug()
	if KBM.Debug then
		print("Debugging disabled")
		KBM.Debug = false
		KBM.Options.Debug = false
		if KBM.Unit.Debug.GUI.Header then
			KBM.Unit.Debug.GUI.Header:SetVisible(false)
		end
	else
		print("Debugging enabled")
		KBM.Debug = true
		KBM.Options.Debug = true
		if KBM.Unit.Debug.GUI then
			KBM.Unit.Debug.GUI.Header:SetVisible(true)
			KBM.Unit.Debug:UpdateAll()
		else
			KBM.Unit.Debug:Init()
			KBM.Unit.Debug:UpdateAll()
		end
	end
end

function KBM.SecureEnter()
end

function KBM.SecureLeave()
end

function KBM.LocationChange(LocationList)
	if LocationList then
		for UnitID, Location in pairs(LocationList) do
			if UnitID == KBM.Player.UnitID then
				if not Location then
					if KBM.Debug then
						print("Location unavailable")
					end
				else
					if KBM.Debug then
						print("New location: "..Location)
					end
					KBM.Player.Location = Location
				end
			end
		end
	end
end

function KBM.ZoneChange(ZoneList)
	if ZoneList then
		for UnitID, ZoneID in pairs(ZoneList) do
			if UnitID == KBM.Player.UnitID then
				if not ZoneID then
					if KBM.Debug then
						print("Zone unavailable")
					end
				else
					if KBM.Debug then
						dump(Inspect.Zone.Detail(ZoneID))
					end
				end
			end
		end
	end
end

function KBM.PlayerJoin()
	KBM.Player.Grouped = true
	KBM.Unit:Available(Inspect.Unit.Detail(KBM.Player.UnitID), KBM.Player.UnitID)
	KBM.Event.System.Player.Join()
	--print("You have joined a group")
end

function KBM.PlayerLeave()
	KBM.Player.Grouped = false
	KBM.Event.System.Player.Leave()
	--print("You have left a group")
end

function KBM.GroupJoin(UnitID, Specifier)
	KBM.Unit:Available(Inspect.Unit.Detail(UnitID), UnitID)
	KBM.Event.System.Group.Join(UnitID)
end

function KBM.GroupLeave(UnitID, Specifier)
	KBM.Unit:Idle(UnitID)
	KBM.Event.System.Group.Leave(UnitID)
end

function KBM.GroupTarget(UnitID, TargetID)
	if KBM.Unit.List.UID[UnitID] then
		local TargetStore = KBM.Unit.List.UID[UnitID].TargetID
		if TargetStore ~= TargetID then
			if TargetStore then
				if KBM.Unit.List.UID[TargetStore] then
					if KBM.Unit.List.UID[TargetStore].TargetList[UnitID] then
						KBM.Unit.List.UID[TargetStore].TargetCount = KBM.Unit.List.UID[TargetStore].TargetCount - 1
					end
				else
					KBM.Unit:Idle(TargetStore)
				end
				KBM.Unit.List.UID[UnitID].TargetID = false
				KBM.Unit.List.UID[TargetStore].TargetList[UnitID] = nil
				KBM.Event.Unit.TargetCount(TargetStore, KBM.Unit.List.UID[TargetStore].TargetCount)
				if KBM.Unit.List.UID[TargetStore].TargetCount == 0 then
					KBM.Unit.RaidTargets[TargetStore] = nil
				end
			end
			if TargetID then
				if not KBM.Unit.List.UID[TargetID] then
					KBM.Unit:Idle(TargetID)
				end
				if not KBM.Unit.List.UID[TargetID].TargetList[UnitID] then
					KBM.Unit.List.UID[TargetID].TargetCount = KBM.Unit.List.UID[TargetID].TargetCount + 1
					KBM.Unit.List.UID[TargetID].TargetList[UnitID] = KBM.Unit.List.UID[UnitID]
					KBM.Event.Unit.TargetCount(TargetID, KBM.Unit.List.UID[TargetID].TargetCount)
					KBM.Unit.List.UID[UnitID].TargetID = TargetID
				end
				if not KBM.Unit.RaidTargets[TargetID] then
					KBM.Unit.RaidTargets[TargetID] = {}
				end
				KBM.Unit.RaidTargets[TargetID][UnitID] = true
			end
		end
	end
end

function KBM.RaidRes(data)
	if KBM.Debug then
		print("Raid Ressurect")
		dump(data)
		print("Total Dead: "..tostring(LibSRM.Dead).."/"..tostring(LibSRM.GroupCount()))
		print("--------------")
	end
end

function KBM.NameChange(data)
	for UnitID, Name in pairs(data) do
		if KBM.Unit.List.UID[UnitID] then
			KBM.Unit.List.UID[UnitID]:SetName(Name)
		end
	end
end

function KBM.HealthChange(data)
	for UnitID, Value in pairs(data) do
		if KBM.Unit.List.UID[UnitID] then
			if type(Value) == "number" then
				KBM.Unit.List.UID[UnitID]:Update(Value)
			end
		end
	end
end

function KBM.HealthMaxChange(data)
	for UnitID, Value in pairs(data) do
		if KBM.Unit.List.UID[UnitID] then
			if type(Value) == "number" then
				KBM.Unit.List.UID[UnitID]:SetHealthMax(Value)
			end
		end
	end
end

function KBM.MarkChange(data)
	for UnitID, Value in pairs(data) do
		if KBM.Unit.List.UID[UnitID] then
			KBM.Unit.List.UID[UnitID].Mark = Value
			KBM.Event.Mark(Value, UnitID)
		end
	end
end

function KBM.RoleChange(data)
end

function KBM.PowerChange(data, PowerMode)
	for UnitID, Value in pairs(data) do
		if KBM.Unit.List.UID[UnitID] then
			if type(Value) == "number" then
				-- if not KBM.Unit.List.UID[UnitID].Details then
					-- KBM.Unit.List.UID[UnitID]:UpdateData(Inspect.Unit.Detail(UnitID))
				-- end
				if KBM.Unit.List.UID[UnitID].Details then
					KBM.Unit.List.UID[UnitID].Details[PowerMode] = Value
					KBM.Event.Unit.Power(UnitID, Value)
				end
			end
		end
	end
end

function KBM.Offline(UnitID, Value)
	if KBM.Unit.List.UID[UnitID] then
		KBM.Unit.List.UID[UnitID].Offline = Value
		KBM.Event.Unit.Offline(Value)
	end
end

-- Define KBM Custom Event System
-- System Related
KBM.Event.System.Start, KBM.Event.System.Start.EventTable = Utility.Event.Create("KingMolinator", "System.Start")
-- Unit Related
KBM.Event.Mark, KBM.Event.Mark.EventTable = Utility.Event.Create("KingMolinator", "Mark")
KBM.Event.Unit.PercentChange, KBM.Event.Unit.PercentChange.EventTable = Utility.Event.Create("KingMolinator", "Unit.PercentChange")
KBM.Event.Unit.Available, KBM.Event.Unit.Available.EventTable = Utility.Event.Create("KingMolinator", "Unit.Available")
KBM.Event.Unit.Unavailable, KBM.Event.Unit.Unavailable.EventTable = Utility.Event.Create("KingMolinator", "Unit.Unavailable")
KBM.Event.Unit.Remove, KBM.Event.Unit.Remove.EventTable = Utility.Event.Create("KingMolinator", "Unit.Remove")
KBM.Event.Unit.Offline, KBM.Event.Unit.Offline.EventTable = Utility.Event.Create("KingMolinator", "Unit.Offline")
KBM.Event.Unit.Death, KBM.Event.Unit.Death.EventTable = Utility.Event.Create("KingMolinator", "Unit.Death")
KBM.Event.Unit.Name, KBM.Event.Unit.Name.EventTable = Utility.Event.Create("KingMolinator", "Unit.Name")
KBM.Event.Unit.Relation, KBM.Event.Unit.Relation.EventTable = Utility.Event.Create("KingMolinator", "Unit.Relation")
KBM.Event.Unit.Calling, KBM.Event.Unit.Calling.EventTable = Utility.Event.Create("KingMolinator", "Unit.Calling")
KBM.Event.Unit.Target, KBM.Event.Unit.Target.EventTable = Utility.Event.Create("KingMolinator", "Unit.Target")
KBM.Event.Unit.TargetCount, KBM.Event.Unit.TargetCount.EventTable = Utility.Event.Create("KingMolinator", "Unit.TargetCount")
KBM.Event.Unit.Cast.Start, KBM.Event.Unit.Cast.Start.EventTable = Utility.Event.Create("KingMolinator", "Unit.Cast.Start")
KBM.Event.Unit.Cast.End, KBM.Event.Unit.Cast.End.EventTable = Utility.Event.Create("KingMolinator", "Unit.Cast.End")
KBM.Event.Unit.Combat.Enter, KBM.Event.Unit.Combat.Enter.EventTable = Utility.Event.Create("KingMolinator", "Unit.Combat.Enter")
KBM.Event.Unit.Combat.Leave, KBM.Event.Unit.Combat.Leave.EventTable = Utility.Event.Create("KingMolinator", "Unit.Combat.Leave")
KBM.Event.Unit.Power, KBM.Event.Unit.Power.EventTable = Utility.Event.Create("KingMolinator", "Unit.Power")
KBM.Event.System.TankSwap.Start, KBM.Event.System.TankSwap.Start.EventTable = Utility.Event.Create("KingMolinator", "System.TankSwap.Start")
KBM.Event.System.TankSwap.End, KBM.Event.System.TankSwap.End.EventTable = Utility.Event.Create("KingMolinator", "System.TankSwap.End")
KBM.Event.System.Player.Join, KBM.Event.System.Player.Join.EventTable = Utility.Event.Create("KingMolinator", "System.Player.Join")
KBM.Event.System.Player.Leave, KBM.Event.System.Player.Leave.EventTable = Utility.Event.Create("KingMolinator", "System.Player.Leave")
KBM.Event.System.Group.Join, KBM.Event.System.Group.Join.EventTable = Utility.Event.Create("KingMolinator", "System.Group.Join")
KBM.Event.System.Group.Leave, KBM.Event.System.Group.Leave.EventTable = Utility.Event.Create("KingMolinator", "System.Group.Leave")
-- Encounter Related
KBM.Event.Encounter.Start, KBM.Event.Encounter.Start.EventTable = Utility.Event.Create("KingMolinator", "Encounter.Start")
KBM.Event.Encounter.End, KBM.Event.Encounter.End.EventTable = Utility.Event.Create("KingMolinator", "Encounter.End")

function KBM.InitVars()
	KBM.InitOptions()
	KBM.Button:Init()
	KBM.TankSwap:Init()
	KBM.Alert:Init()
	KBM.MechTimer:Init()
	KBM.CastBar:Init()
	KBM.EncTimer:Init()
	KBM.PhaseMonitor:Init()
	KBM.Trigger:Init()
	KBM.MechSpy:Init()
	if KBM.Debug then
		KBM.Unit.Debug:Init()
	end
	KBM.InitMenus()
end

KBM.SetDefault = {}
function KBM.SetDefault.Button()
	KBM.Options.Button = KBM.Defaults.Button()
	KBM.Options.Frame.x = false
	KBM.Options.Frame.y = false
	KBM.Button:ApplySettings()
	KBM.MainWin:ApplySettings()
	KBM.QueuePage = KBM.MenuOptions.Main.MenuItem
end

function KBM.SlashDefault(Args)
	-- Will eventually have different options that will link to default buttons in UI
	-- For now it'll reset the Options Menu Button to its default settings. (Central, Visible and Unlocked)
	Args = string.upper(Args)
	if Args == "BUTTON" then
	
	else
	
	end
	KBM.SetDefault.Button()
end

function KBM.InitMenus()
	local Header = KBM.MainWin.Menu:CreateHeader(KBM.Language.Menu.Global[KBM.Lang], nil, nil, nil, "Main")
	KBM.MenuOptions.Main.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.Settings[KBM.Lang], KBM.MenuOptions.Main, nil, Header)
	KBM.MenuOptions.Main.MenuItem.Check:SetEnabled(false)
	KBM.MenuOptions.Timers.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Menu.Timers[KBM.Lang], KBM.MenuOptions.Timers, true, Header)
	KBM.MenuOptions.Timers.MenuItem.Check:SetEnabled(false)
	KBM.MenuOptions.Phases.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.PhaseMonitor[KBM.Lang], KBM.MenuOptions.Phases, true, Header) 
	KBM.MenuOptions.Phases.MenuItem.Check:SetEnabled(false)
	KBM.MenuOptions.CastBars.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.Castbar[KBM.Lang], KBM.MenuOptions.CastBars, true, Header)
	KBM.MenuOptions.CastBars.MenuItem.Check:SetEnabled(false)
	KBM.MenuOptions.Alerts.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.Alert[KBM.Lang], KBM.MenuOptions.Alerts, true, Header)
	KBM.MenuOptions.Alerts.MenuItem.Check:SetEnabled(false)
	KBM.MenuOptions.TankSwap.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.Options.TankSwap[KBM.Lang], KBM.MenuOptions.TankSwap, true, Header)	
	KBM.MenuOptions.TankSwap.MenuItem.Check:SetEnabled(false)
	KBM.MenuOptions.MechSpy.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.MechSpy.Name[KBM.Lang], KBM.MenuOptions.MechSpy, true, Header)
	KBM.MenuOptions.MechSpy.MenuItem.Check:SetEnabled(false)
	KBM.MenuOptions.RezMaster.MenuItem = KBM.MainWin.Menu:CreateEncounter(KBM.Language.RezMaster.Name[KBM.Lang], KBM.MenuOptions.RezMaster, true, Header)
	KBM.MenuOptions.RezMaster.MenuItem.Check:SetEnabled(false)
	
	-- Compile Boss Menus
	for _, Mod in ipairs(KBM.ModList) do
		Mod:AddBosses(KBM_Boss)
		if Mod.InstanceObj then
			for BossName, BossObj in pairs(Mod.Bosses) do
				KBM.Boss.Dungeon:AddBoss(BossObj)
				if BossObj.AltBossList then
					for i, aBossObj in pairs(BossObj.AltBossList) do
						KBM.Boss.Dungeon:AddBoss(aBossObj)
					end
				end
			end
		end
		Mod:Start(KBM_MainWin)
	end
	
	KBM.MainWin.Scroller.Instance:SetPosition(0)
	for MenuID, MenuObj in pairs(KBM.MenuIDList) do
		if MenuObj.Settings then
			if MenuObj.Settings.Collapse then
				if MenuObj.Type == "instance" then
					MenuObj.GUI.Check:SetChecked(false)
				else
					MenuObj.Check:SetChecked(false)
				end
			end
		end
	end
end

local function KBM_Start()
	if KBM.PlugIn.Count > 0 then
		for ID, PlugIn in pairs(KBM.PlugIn.List) do
			if PlugIn.Start then
				PlugIn:Start()
			end
		end
	end		
	KBM.MenuOptions.Main:Options()
end

function KBM.InitEvents()
	table.insert(Event.Chat.Notify, {KBM.Notify, "KingMolinator", "Notify Event"})
	table.insert(Event.Chat.Npc, {KBM.NPCChat, "KingMolinator", "NPC Chat"})
	table.insert(Event.Buff.Add, {function (unitID, Buffs) KBM:BuffAdd(unitID, Buffs) end, "KingMolinator", "Buff Monitor (Add)"})
	--table.insert(Event.Buff.Change, {function (unitID, Buffs) KBM:BuffMonitor(unitID, Buffs, "change") end, "KingMolinator", "Buff Monitor (change)"})
	table.insert(Event.Buff.Remove, {function (unitID, Buffs) KBM:BuffRemove(unitID, Buffs) end, "KingMolinator", "Buff Monitor (remove)"})
	table.insert(Event.Unit.Availability.None, {KBM_UnitRemoved, "KingMolinator", "Unit Unavailable"})
	table.insert(Event.Unit.Availability.Partial, {KBM_UnitAvailable, "KingMolinator", "Unit Available"})
	table.insert(Event.Unit.Availability.Full, {KBM_UnitAvailable, "KingMolinator", "Unit Available"})
	table.insert(Event.Unit.Detail.LocationName, {KBM.LocationChange, "KingMolinator", "Location Change"})
	table.insert(Event.Unit.Detail.Zone, {KBM.ZoneChange, "KingMolinator", "Zone Change"})
	table.insert(Event.Unit.Detail.Health, {KBM.HealthChange, "KingMolinator", "Health Update"})
	table.insert(Event.Unit.Detail.Name, {KBM.NameChange, "KingMolinator", "Name Update"})
	table.insert(Event.Unit.Detail.HealthMax, {KBM.HealthMaxChange, "KingMolinator", "Health Max Update"})
	table.insert(Event.Unit.Detail.Mark, {KBM.MarkChange, "KingMolinator", "Mark Change Update"})
	table.insert(Event.Unit.Detail.Role, {KBM.RoleChange, "KingMolinator", "Role changed"})
	table.insert(Event.Unit.Castbar, {KBM_CastBar, "KingMolinator", "Cast Bar Event"})
	table.insert(Event.Unit.Detail.Power, {function (List) KBM.PowerChange(List, "power") end, "KingMolinator", "Power Change"})
	table.insert(Event.Unit.Detail.Energy, {function (List) KBM.PowerChange(List, "energy") end, "KingMolinator", "Energy Change"})
	table.insert(Event.Unit.Detail.Mana, {function (List) KBM.PowerChange(List, "mana") end, "KingMolinator", "Mana Change"})
	-- **
	-- Safes Raid Manager Events
	table.insert(Event.SafesRaidManager.Player.Join, {KBM.PlayerJoin, "KingMolinator", "Joined Group"})
	table.insert(Event.SafesRaidManager.Player.Leave, {KBM.PlayerLeave, "KingMolinator", "Left Group"})
	table.insert(Event.SafesRaidManager.Combat.Heal, {KBM.MobHeal, "KingMolinator", "Combat Heal"})
	table.insert(Event.SafesRaidManager.Combat.Death, {KBM_Death, "KingMolinator", "Combat Death"})
	table.insert(Event.SafesRaidManager.Combat.Enter, {KBM.CombatEnter, "KingMolinator", "Non raid combat enter"})
	table.insert(Event.SafesRaidManager.Combat.Leave, {KBM.CombatLeave, "KingMolinator", "Non raid combat leave"})
	table.insert(Event.SafesRaidManager.Combat.Damage, {KBM.MobDamage, "KingMolinator", "Combat Damage"})
	table.insert(Event.SafesRaidManager.Group.Combat.Death, {KBM.GroupDeath, "KingMolinator", "Group Death"})
	table.insert(Event.SafesRaidManager.Group.Combat.End, {KBM.RaidCombatLeave, "KingMolinator", "Raid Combat Leave"})
	table.insert(Event.SafesRaidManager.Group.Combat.Start, {KBM.RaidCombatEnter, "KingMolinator", "Raid Combat Enter"})
	table.insert(Event.SafesRaidManager.Group.Combat.Res, {KBM.RaidRes, "KingMolinator", "Raid Res"})
	table.insert(Event.SafesRaidManager.Group.Combat.Damage, {KBM.RaidDamage, "KingMolinator", "Raid Damage"})
	table.insert(Event.SafesRaidManager.Group.Join, {KBM.GroupJoin, "KingMolinator", "Raid_Member_Joins"})
	table.insert(Event.SafesRaidManager.Group.Leave, {KBM.GroupLeave, "KingMolinator", "Raid_Member_Leave"})
	table.insert(Event.SafesRaidManager.Group.Target, {KBM.GroupTarget, "KingMolinator", "Raid_Member_Target"})
	table.insert(Event.SafesRaidManager.Group.Offline, {KBM.Offline, "KingMolinator", "Offline Status Change"})
	-- **
	table.insert(Event.System.Update.Begin, {function () KBM:Timer() end, "KingMolinator", "System Update Begin"})
	table.insert(Event.System.Update.End, {function () KBM:AuxTimer() end, "KingMolinator", "System Update End"})
	table.insert(Event.System.Secure.Enter, {KBM.SecureEnter, "KingMolinator", "Secure Enter"})
	table.insert(Event.System.Secure.Leave, {KBM.SecureLeave, "KingMolinator", "Secure Leave"})
	
	-- Slash Commands
	table.insert(Command.Slash.Register("kbmreset"), {KBM_Reset, "KingMolinator", "KBM Reset"})
	table.insert(Command.Slash.Register("kbmhelp"), {KBM_Help, "KingMolinator", "KBM Help"})
	table.insert(Command.Slash.Register("kbmversion"), {KBM_Version, "KingMolinator", "KBM Version Info"})
	table.insert(Command.Slash.Register("kbmoptions"), {KBM_Options, "KingMolinator", "KBM Open Options"})
	table.insert(Command.Slash.Register("kbmdebug"), {KBM_Debug, "KingMolinator", "KBM Debug on/off"})
	table.insert(Command.Slash.Register("kbmlocale"), {KBMLM.FindMissing, "KBMLocaleManager", "KBM Locale Finder"})
	table.insert(Command.Slash.Register("kbmcpu"), {function () KBM.CPU:Toggle() end, "KingMolinator", "KBM CPU Monitor"})
	table.insert(Command.Slash.Register("kbmdumpavail"), {KBM.Unit.Debug.DumpAvail, "KingMolinator", "KBM Debug Avail"})
	--table.insert(Command.Slash.Register("kbmwdbuffs"), {function (...) KBM.Watchdog.Display("Buffs", ...) end, "KingMolinator", "Watchdog Tracking: Buff Add Remove Display"})
	--table.insert(Command.Slash.Register("kbmwdavail"), {function (...) KBM.Watchdog.Display("Avail", ...) end, "KingMolinator", "Watchdog Tracking: Unit Available"})
	--table.insert(Command.Slash.Register("kbmwdmain"), {function (...) KBM.Watchdog.Display("Main", ...) end, "KingMolinator", "Watchdog Tracking: System Update Begin"})
	table.insert(Command.Slash.Register("kbmon"), {function() KBM.StateSwitch(true) end, "KingMolinator", "KBM On"})
	table.insert(Command.Slash.Register("kbmoff"), {function() KBM.StateSwitch(false) end, "KingMolinator", "KBM Off"})
	table.insert(Command.Slash.Register("kbmdefault"), {KBM.SlashDefault, "KingMolinator", "Default settings handler"})
end

local function KBM_WaitReady(unitID, uDetails)
	KBM.Player.UnitID = unitID
	KBM.Player.ID = "KBM_Player"
	KBM.Player.Name = uDetails.name
	KBM.Player.Details = uDetails
	KBM.Player.Calling = uDetails.calling
	KBM.Player.Settings = {
		CastBar = {
			Override = true,
			Multi = true,
		},
	}
	KBM.Player.Rezes = {
		List = {},
		Resume = {},
		Count = 0,
	}
	KBM_Start()
	KBM.RezMaster:Start()
	KBM.PlayerControl:Start()	
	KBM.Player.Level = uDetails.level
	KBM.Player.Grouped = LibSRM.Grouped()
	KBM.Player.Mode = LibSRM.Player.Mode
	KBM.Event.System.Start(self)
	if KBM.Player.Grouped then
		KBM.PlayerJoin()
	end
	UnitList = Inspect.Unit.List()
	if UnitList then
		for UnitID, Specifier in pairs(UnitList) do
			local uDetails = Inspect.Unit.Detail(UnitID)
			if uDetails then
				UnitObj = KBM.Unit:Available(uDetails, UnitID)
				if UnitObj.Mark then
					KBM.Event.Mark(UnitObj.Mark, UnitID)
				end
			end
			local Spec = LibSRM.Group.UnitExists(UnitID)
			if Spec then
				local Target = LibSRM.Group.Target(UnitID)
				if Target then
					if KBM.Unit.List.UID[UnitID] then
						KBM.GroupTarget(UnitID, Target)
					end
				end
				KBM.GroupJoin(UnitID, Spec)
			end
		end
	end
	KBM.Player.CastBar = {
		Mod = KBM.Player,
		ID = "KBM_Player",
		Name = "Your Castbar",
		Settings = {
			CastBar = KBM.Options.Player.CastBar,
		},
		Target = {
			ID = "KBM_Player_Target",
			Name = "Target Castbar",
			Settings = {
				CastBar = KBM.Defaults.CastBar(),
			},
		},
		Focus = {
			ID = "KBM_Player_Focus",
			Name = "Focus Castbar",
			Settings = {
				CastBar = KBM.Defaults.CastBar(),
			},
		},
	}
	function KBM.Player.CastBar.PinCastBar()
		KBM.Player.CastBar.CastObj.GUI.Frame:ClearPoint("TOPLEFT")
		KBM.Player.CastBar.CastObj.GUI.Frame:SetPoint("CENTER", UI.Native.Castbar, "CENTER")
	end
	KBM.Player.CastBar.Settings.CastBar.Override = true
	KBM.Player.CastBar.Settings.CastBar.Multi = true
	KBM.Player.CastBar.CastObj = KBM.CastBar:Add(KBM.Player, KBM.Player.CastBar)
	KBM.Player.CastBar.CastObj:SetBoss(false)
	KBM.Player.CastBar.Target.CastObj = KBM.CastBar:Add(KBM.Player.CastBar.Target, KBM.Player.CastBar.Target)
	KBM.Player.CastBar.Focus.CastObj = KBM.CastBar:Add(KBM.Player.CastBar.Focus, KBM.Player.CastBar.Focus)
	KBM.Player.CastBar.CastObj:Create(KBM.Player.UnitID)
	
	KBM.InitEvents()
end

KBM.PlugIn = {}
KBM.PlugIn.List = {}
KBM.PlugIn.Count = 0
function KBM.PlugIn.Register(PlugIn)
	if PlugIn then
		if KBM.PlugIn.List[PlugIn.ID] then
			print("<Plug-In ID Conflict> The Plug-In ID: "..PlugIn.ID.." already exists.")
			print("Plug-In will not be registered.")
		else
			KBM.PlugIn.List[PlugIn.ID] = PlugIn
			KBM.PlugIn.Count = KBM.PlugIn.Count + 1
		end
	else
		print("Attempted Plug-In load failed. Incorrect parameters <PlugIn>")
		print("Expecting Plug-In Table Object.")
	end
end

function KBM.RegisterMod(ModID, Mod)
	if KBM.BossMod[ModID] then
		error("<Mod ID Conflict> The Mod ID: "..ModID.." already exists.") 
	else
		KBM.BossMod[ModID] = Mod
		table.insert(KBM.ModList, Mod)
	end
end

function KBM.InitKBM(ModID)	
	if ModID == "KingMolinator" then
		KBM.ApplySettings()
		local TempGUIList = {}
		for Cached = 1, KBM.Trigger.High.Timers do
			local TempGUI = KBM.MechTimer:Pull()
			TempGUI.Background:SetVisible(false)
			table.insert(TempGUIList, TempGUI)
		end
		for n, GUIObj in ipairs(TempGUIList) do
			table.insert(KBM.MechTimer.Store, GUIObj)
		end
		TempGUIList = {}
		TempCastBarList = {}
		TempCastBarBoss = {}
		for Cached = 1, 20 do
			local TempGUI = KBM.CastBar:Pull("kbm")
			TempGUI.Frame:SetVisible(false)
			table.insert(TempGUIList, TempGUI)
		end
		for n, GUIObj in ipairs(TempGUIList) do
			table.insert(KBM.CastBar.Stores.KBM, GUIObj)
		end
		TempGUIList = {}
		for Cached = 1, 20 do
			local TempGUICB = KBM.CastBar:Pull("rift")
			TempGUICB.Frame:SetVisible(false)
			table.insert(TempCastBarList, TempGUICB)		
		end
		for n, GUIObj in ipairs(TempCastBarList) do
			table.insert(KBM.CastBar.Stores.Rift, GUIObj)
		end
		TempCastBarList = {}
		for Cached = 1, 20 do
			local TempGUICBB = KBM.CastBar:Pull("rift", true)
			TempGUICBB.Frame:SetVisible(false)
			table.insert(TempCastBarBoss, TempGUICBB)		
		end
		for n, GUIObj in ipairs(TempCastBarBoss) do
			table.insert(KBM.CastBar.Stores.Boss, GUIObj)
		end
		TempCastBarBoss = {}
		KBM.CPU:Toggle(true)

		if KBM.IsAlpha then
			print(KBM.Language.Welcome.Welcome[KBM.Lang]..AddonData.toc.Version.." Alpha")
		else
			print(KBM.Language.Welcome.Welcome[KBM.Lang]..AddonData.toc.Version)
		end
		print(KBM.Language.Welcome.Commands[KBM.Lang])
		print(KBM.Language.Welcome.Options[KBM.Lang])
	else
		if Inspect.Buff.Detail ~= IBDReserved then
			print(tostring(ModID).." changed internal command: Restoring Inspect.Buff.Detail")
			Inspect.Buff.Detail = IBDReserved
		end
	end
end

table.insert(Event.Addon.SavedVariables.Load.Begin, {KBM_DefineVars, "KingMolinator", "Load Begin"})
table.insert(Event.Addon.SavedVariables.Load.End, {KBM_LoadVars, "KingMolinator", "Load End"})
table.insert(Event.Addon.SavedVariables.Save.Begin, {KBM_SaveVars, "KingMolinator", "Save Begin"})
table.insert(Event.Addon.Load.End, {KBM.InitKBM, "KingMolinator", "Begin Init Sequence"})
table.insert(Event.SafesRaidManager.Player.Ready, {KBM_WaitReady, "KingMolinator", "Sync Wait"})

local AddonDetails = Inspect.Addon.Detail("KBMTextureHandler")
KBM.LoadTexture = AddonDetails.data.LoadTexture
