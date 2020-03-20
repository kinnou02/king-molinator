-- King Boss Mods
-- Written By Paul Snart
-- Copyright 2011

local IBDReserved = Inspect.Buff.Detail

KBM_GlobalOptions = nil
chKBM_GlobalOptions = nil

local KingMol_Main = {}
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBMIni = AddonData
local KBM = AddonData.data
local LocaleManager = Inspect.Addon.Detail("KBMLocaleManager")
local KBMLM = LocaleManager.data

local LibSGui = Inspect.Addon.Detail("SafesGUILib").data
local LibSBuff = Inspect.Addon.Detail("SafesBuffLib").data

local LSUIni = Inspect.Addon.Detail("SafesUnitLib")
local LibSUnit = LSUIni.data

local LSCIni = Inspect.Addon.Detail("SafesCastbarLib")
local LibSCast = LSCIni.data

local LSAIni = Inspect.Addon.Detail("SafesTableLib")
local LibSata = LSAIni.data

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
KBM.Unit = {}
KBM.Layer = {
	ReadyCheck = 11,
	DragActive = 99,
	DragInactive = 90,
	Alerts = 8,
	Timers = 9,
	Castbars = 15,
	Info = 10,
	Menu = 1,
}
KBM.CPU = {}
KBM.Lang = Inspect.System.Language()
KBM.Player = {
	Rezes = {},
	Resume = {},
}
KBM.Raid = {}
KBM.ID = AddonData.id
KBM.ModList = {}
KBM.Testing = false
KBM.ValidTime = false
KBM.IsAlpha = false
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
		Duration = 5, 
	}
}

--KBM.DistanceCalc = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
KBM.Defaults = {}
KBM.Constant = {}
KBM.Buffs = {}
KBM.Buffs.Active = {}
KBM.Buffs.WatchID = {}

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
    if High <= self.High then
        if High < self.High then
            return true
        else
            if Mid <= self.Mid then
                if Mid < self.Mid then
                    return true
                else
                    if Low < self.Low then
                        return true
                    else
                        if Low == self.Low and Revision <= self.Revision then
                            return true
                        else
                            return false
                        end
                    end
                end
            else
                return false
            end
        end
    else
        return false
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
		Default_Color = Color,
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
				Data.Default_Color = Data.Settings.Default_Color
				Data.Settings.Default_Color = nil
				Data.Color = Data.Settings.Color
				Data.Custom = Data.Settings.Custom
			end
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
		Default_Color = Color,
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
				Data.Default_Color = Data.Settings.Default_Color
				Data.Settings.Default_Color = nil
				if KBM.Colors.List[Data.Settings.Color] then
					if Data.Settings.Custom then
						Data.Color = Data.Settings.Color
					else
						Data.Color = Data.Default_Color
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

function KBM.Defaults.Castbar()
	-- local CastBar = {
		-- Override = false,
		-- x = false,
		-- y = false,
		-- Enabled = true,
		-- Style = "rift",
		-- RiftBar = true,
		-- Shadow = true,
		-- Unlocked = true,
		-- Visible = true,
		-- ScaleWidth = false,
		-- wScale = 1,
		-- hScale = 1,
		-- tScale = 1,
		-- Shadow = true,
		-- Texture = true,
		-- TextureAlpha = 0.75,
		-- ScaleHeight = false,
		-- TextScale = false,
		-- Pinned = false,
		-- Color = "red",
		-- Custom = false,
		-- Type = "CastBar",
	-- }
	local Castbar = LibSCast.Default.BarSettings()
	Castbar.override = false
	Castbar.riftBar = true
	Castbar.pinned = false
	Castbar.pack = "Rift"
	Castbar.custom = false
	return Castbar
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
	self.ResMaster = {
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
	self.Button = {
		s = 32,
	}
	self.TankSwap = {
		w = 150,
		h = 40,
		TextSize = 14,
	}
	self.Font = { -- FONTSETTINGS - Legacy, always the first font, will result in no font being applied.
		{"None",""},
		{"Montserrat Bold","font/Montserrat-Bold.otf"},
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
		Renderer = 1,
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

function KBM.Defaults.Menu()
	
	local MenuObj = {
		Collapse = false,
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

local function KBM_DefineVars(handle, AddonID)
	if AddonID == "KingMolinator" then
		KBM.Options = {
			Castbar = {
				Player = {},
				Global = KBM.Defaults.Castbar(),
			},
			Character = false,
			Enabled = true,
			Debug = false,
			MenuState = {},
			MenuExpac = "Rift",
			UnitCache = {
				Raid = {},
				Sliver = {},
				Master = {},
				Expert = {},
				Normal = {},
				List = {},
			},
			UnitTotal = 0,
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
				RelX = false,
				RelY= false,
			},
			Button = KBM.Defaults.Button(),
			Alerts = KBM.Defaults.Alerts(),
			EncTimer = KBM.Defaults.EncTimer(),
			PhaseMon = KBM.Defaults.PhaseMon(),
			MechTimer = KBM.Defaults.MechTimer(),
			MechSpy = KBM.Defaults.MechSpy(),
			Chat = {
				Enabled = true,
			},
			ResMaster = {
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
				Cascade = true,
			},
			TankSwap = {
				x = false,
				y = false,
				wScale = 1,
				hScale = 1,
				tScale = 1,
				ScaleUnlocked = false,
				ScaleWidth = false,
				ScaleHeight = false,
				TextScale = false,
				Enabled = true,
				Visible = true,
				Unlocked = true,
				Tank = false,
			},
			BestTimes = {
			},
			Sheep = {
				Protect = false,
			},
			Planar = {
				PlanarProtect = false,
			},
			Font = {
				Custom = 2,
			},
		}
		KBM.Marks = {
			Location = {
				[19] = KBMIni.id,
				[20] = KBMIni.id,
				[21] = KBMIni.id,
				[27] = KBMIni.id,
				[28] = KBMIni.id,
				[29] = KBMIni.id,
			},
			LocationFull = {
			},
			File = {
				[1] = "vfx_ui_mob_tag_01_mini.png.dds",
				[2] = "vfx_ui_mob_tag_02_mini.png.dds",
				[3] = "vfx_ui_mob_tag_03_mini.png.dds",
				[4] = "vfx_ui_mob_tag_04_mini.png.dds",
				[5] = "vfx_ui_mob_tag_05_mini.png.dds",
				[6] = "vfx_ui_mob_tag_06_mini.png.dds",
				[7] = "vfx_ui_mob_tag_07_mini.png.dds",
				[8] = "vfx_ui_mob_tag_08_mini.png.dds",
				[9] = "vfx_ui_mob_tag_tank_mini.png.dds",
				[10] = "vfx_ui_mob_tag_heal_mini.png.dds",
				[11] = "vfx_ui_mob_tag_damage_mini.png.dds",
				[12] = "vfx_ui_mob_tag_support_mini.png.dds",
				[13] = "vfx_ui_mob_tag_arrow_mini.png.dds",
				[14] = "vfx_ui_mob_tag_skull_mini.png.dds",
				[15] = "vfx_ui_mob_tag_no_mini.png.dds",
				[16] = "vfx_ui_mob_tag_smile_mini.png.dds",
				[17] = "vfx_ui_mob_tag_squirrel_mini.png.dds",
				[18] = "vfx_ui_mob_tag_crown_mini.png.dds",
				[19] = "media/heal_two_small.png",
				[20] = "media/heal_three_small.png",
				[21] = "media/heal_four_small.png",
				[22] = "vfx_ui_mob_tag_heart_mini.png.dds",
				[23] = "vfx_ui_mob_tag_heart_leftside_mini.png.dds",
				[24] = "vfx_ui_mob_tag_heart_rightside_mini.png.dds",
				[25] = "vfx_ui_mob_tag_radioactive_mini.png.dds",
				[26] = "vfx_ui_mob_tag_sad_mini.png.dds",
				[27] = "media/tank_two_small.png",
				[28] = "media/tank_three_small.png",
				[29] = "media/tank_four_small.png",
				[30] = "vfx_ui_mob_tag_clover_mini.png.dds",
			},
			FileFull = {
				[1] = "vfx_ui_mob_tag_01.png.dds",
				[2] = "vfx_ui_mob_tag_02.png.dds",
				[3] = "vfx_ui_mob_tag_03.png.dds",
				[4] = "vfx_ui_mob_tag_04.png.dds",
				[5] = "vfx_ui_mob_tag_05.png.dds",
				[6] = "vfx_ui_mob_tag_06.png.dds",
				[7] = "vfx_ui_mob_tag_07.png.dds",
				[8] = "vfx_ui_mob_tag_08.png.dds",
				[9] = "vfx_ui_mob_tag_tank.png.dds",
				[10] = "vfx_ui_mob_tag_heal.png.dds",
				[11] = "vfx_ui_mob_tag_damage.png.dds",
				[12] = "vfx_ui_mob_tag_support.png.dds",
				[13] = "vfx_ui_mob_tag_arrow.png.dds",
				[14] = "vfx_ui_mob_tag_skull.png.dds",
				[15] = "vfx_ui_mob_tag_no.png.dds",
				[16] = "vfx_ui_mob_tag_smile.png.dds",
				[17] = "vfx_ui_mob_tag_squirrel.png.dds",
				[18] = "vfx_ui_mob_tag_crown.png.dds",
				[19] = "vfx_ui_mob_tag_heal2.png.dds",
				[20] = "vfx_ui_mob_tag_heal3.png.dds",
				[21] = "vfx_ui_mob_tag_heal4.png.dds",
				[22] = "vfx_ui_mob_tag_heart.png.dds",
				[23] = "vfx_ui_mob_tag_heart_leftside.png.dds",
				[24] = "vfx_ui_mob_tag_heart_rightside.png.dds",
				[25] = "vfx_ui_mob_tag_radioactive.png.dds",
				[26] = "vfx_ui_mob_tag_sad.png.dds",
				[27] = "vfx_ui_mob_tag_tank2.png.dds",
				[28] = "vfx_ui_mob_tag_tank3.png.dds",
				[29] = "vfx_ui_mob_tag_tank4.png.dds",
				[30] = "vfx_ui_mob_tag_clover.png.dds",
			},			
			Icon = {},
			Name = {
				[1] = "1",
				[2] = "2",
				[3] = "3",
				[4] = "4",
				[5] = "5",
				[6] = "6",
				[7] = "7",
				[8] = "8",
				[9] = KBM.Language.Marks.Tank[KBM.Lang],
				[10] = KBM.Language.Marks.Heal[KBM.Lang],
				[11] = KBM.Language.Marks.Damage[KBM.Lang],
				[12] = KBM.Language.Marks.Support[KBM.Lang],
				[13] = KBM.Language.Marks.Arrow[KBM.Lang],
				[14] = KBM.Language.Marks.Skull[KBM.Lang],
				[15] = KBM.Language.Marks.Avoid[KBM.Lang],
				[16] = KBM.Language.Marks.Smile[KBM.Lang],
				[17] = KBM.Language.Marks.Squirrel[KBM.Lang],
				[18] = KBM.Language.Marks.Crown[KBM.Lang],
				[19] = KBM.Language.Marks.HealTwo[KBM.Lang],
				[20] = KBM.Language.Marks.HealThree[KBM.Lang],
				[21] = KBM.Language.Marks.HealFour[KBM.Lang],
				[22] = KBM.Language.Marks.Heart[KBM.Lang],
				[23] = KBM.Language.Marks.HeartLeft[KBM.Lang],
				[24] = KBM.Language.Marks.HeartRight[KBM.Lang],
				[25] = KBM.Language.Marks.Radioactive[KBM.Lang],
				[26] = KBM.Language.Marks.Sad[KBM.Lang],
				[27] = KBM.Language.Marks.TankTwo[KBM.Lang],
				[28] = KBM.Language.Marks.TankThree[KBM.Lang],
				[29] = KBM.Language.Marks.TankFour[KBM.Lang],
				[30] = KBM.Language.Marks.Luck[KBM.Lang],
			},
		}
		KBM_GlobalOptions = KBM.Options
		chKBM_GlobalOptions = KBM.Options
		for ID, Castbar in pairs(KBM.Castbar.Player) do
			KBM.Options.Castbar.Player[ID] = KBM.Defaults.Castbar()
			Castbar.Settings = KBM.Options.Castbar.Player[ID]
			Castbar.Settings.relX = Castbar.relX
			Castbar.Settings.relY = Castbar.relY
		end
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
		KBM.Options.PercentageMon = KBM.PercentageMon.Defaults()
		KBM.PercentageMon.Settings = KBM.Options.PercentageMon
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

local function KBM_LoadVars(handle, AddonID)
	local TargetLoad = nil
	if AddonID == "KingMolinator" then
		if chKBM_GlobalOptions.Character then
			KBM.LoadTable(chKBM_GlobalOptions, KBM.Options)
		else
			KBM.LoadTable(KBM_GlobalOptions, KBM.Options)
		end		

		if KBM_GlobalOptions.UnitCache then
			KBM.Options.UnitCache = KBM_GlobalOptions.UnitCache
			KBM.Options.UnitTotal = KBM_GlobalOptions.UnitTotal
		end
		
		if KBM.Options.Character then
			if chKBM_GlobalOptions.MenuState then
				KBM.Options.MenuState = chKBM_GlobalOptions.MenuState
			end
			chKBM_GlobalOptions = KBM.Options
		else
			if KBM_GlobalOptions.MenuState then
				KBM.Options.MenuState = KBM_GlobalOptions.MenuState
			end
			KBM_GlobalOptions = KBM.Options		
		end
				
		for _, Mod in ipairs(KBM.ModList) do
			Mod:LoadVars()
		end
		
		KBM.Debug = KBM.Options.Debug
		KBM.InitVars()
		KBM.PercentageMon:Init()
	elseif KBM.PlugIn.List[AddonID] then
		KBM.PlugIn.List[AddonID]:LoadVars()
	end
end

local function KBM_SaveVars(handle, AddonID)
	if AddonID == "KingMolinator" then
		KBM_GlobalOptions.UnitCache = KBM.Options.UnitCache
		KBM_GlobalOptions.UnitTotal = KBM.Options.UnitTotal
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
KBM.Boss = {
	Template = {},
	Raid = {},
	Sliver = {},
	Dungeon = {
		List = {},
	},
	Master = {},
	Expert = {},
	Normal = {},
	Chronicle = {},
	Rift = {},
	ExRift = {},
	RaidRift = {},
	World = {},
	Trash = {},
	TypeList = {},
	Name = {},
}

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
KBM.TimeVisual = {}
KBM.TimeVisual.String = "00"
KBM.TimeVisual.Seconds = 0
KBM.TimeVisual.Minutes = 0
KBM.TimeVisual.Hours = 0

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
	Count = 8,
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
			Red = 0.5,
			Green = 0,
			Blue = 0.38,
		},
		pink = {
			Name = KBM.Language.Color.Pink[KBM.Lang],
			Red = 0.93,
			Green = 0.36,
			Blue = 0.65,
		},
		dark_grey = {
			Name = KBM.Language.Color.Dark_Grey[KBM.Lang],
			Red = 0.3,
			Green = 0.3,
			Blue = 0.3,
		},
	}
}

local function KBM_Options()
	if KBM.Menu.Active then
		KBM.Menu:Close()
	else
		KBM.Menu:Open()
	end	
end

function KBM.Button:Init()
	KBM.Button.Texture = UI.CreateFrame("Texture", "Button Texture", KBM.Context)
	KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/New_Options_Button.png")
	KBM.Button.Texture:SetWidth(KBM.Constant.Button.s)
	KBM.Button.Texture:SetHeight(KBM.Button.Texture:GetWidth())
	KBM.Button.Highlight = UI.CreateFrame("Texture", "Button Texture Highlight", KBM.Context)
	KBM.LoadTexture(KBM.Button.Highlight, "KingMolinator", "Media/New_Options_Button_Over.png")
	KBM.Button.Highlight:SetPoint("TOPLEFT", KBM.Button.Texture, "TOPLEFT")
	KBM.Button.Highlight:SetPoint("BOTTOMRIGHT", KBM.Button.Texture, "BOTTOMRIGHT")
	KBM.Button.Highlight:SetVisible(false)
	
	function self:ApplySettings()
		self.Texture:ClearPoint("CENTER")
		self.Texture:ClearPoint("TOPLEFT")
		if not KBM.Options.Button.x then
			self.Texture:SetPoint("CENTER", UIParent, "CENTER")
		else
			self.Texture:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.Button.x, KBM.Options.Button.y)
		end
		self.Texture:SetLayer(5)
		self.Highlight:SetLayer(6)
		self.Texture:SetVisible(KBM.Options.Button.Visible)
	end
	
	function self:UpdateMove(uType)
		if uType == "end" then
			KBM.Options.Button.x = self.Texture:GetLeft()
			KBM.Options.Button.y = self.Texture:GetTop()
		end	
	end
	function self:MouseInHandler()
		KBM.Button.Highlight:SetVisible(true)
	end
	function self:MouseOutHandler()
		KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/New_Options_Button.png")
		KBM.Button.Highlight:SetVisible(false)
	end
	function self:LeftDownHandler()
		KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/New_Options_Button_Down.png")
		KBM.Button.Highlight:SetVisible(false)
	end
	function self:LeftUpHandler()
		KBM.LoadTexture(KBM.Button.Texture, "KingMolinator", "Media/New_Options_Button.png")
		KBM.Button.Highlight:SetVisible(true)
	end
	function self:LeftClickHandler()
		KBM_Options()
	end

	function self:SetUnlocked(bool)
		if bool then
			self.Drag:EventAttach(Event.UI.Input.Mouse.Right.Down, self.Drag.FrameEvents.LeftDownHandler, "KBM Main Button Right Down")
			self.Drag:EventAttach(Event.UI.Input.Mouse.Right.Up, self.Drag.FrameEvents.LeftUpHandler, "KBM Main Button Right Up")
		else
			self.Drag:EventDetach(Event.UI.Input.Mouse.Right.Down, self.Drag.FrameEvents.LeftDownHandler)
			self.Drag:EventDetach(Event.UI.Input.Mouse.Right.Up, self.Drag.FrameEvents.LeftUpHandler)		
		end
	end
	
	self.Drag = KBM.AttachDragFrame(self.Texture, function (uType) self:UpdateMove(uType) end, "Button Drag", 6)
	self.Drag:EventDetach(Event.UI.Input.Mouse.Left.Down, self.Drag.FrameEvents.LeftDownHandler)
	self.Drag:EventDetach(Event.UI.Input.Mouse.Left.Up, self.Drag.FrameEvents.LeftUpHandler)
	self.Drag:EventAttach(Event.UI.Input.Mouse.Cursor.In, self.MouseInHandler, "KBM Main Button Mouse In")
	self.Drag:EventAttach(Event.UI.Input.Mouse.Cursor.Out, self.MouseOutHandler, "KBM Main Button Mouse Out")
	self.Drag:EventAttach(Event.UI.Input.Mouse.Left.Down, self.LeftDownHandler, "KBM Main Button Left Down")
	self.Drag:EventAttach(Event.UI.Input.Mouse.Left.Up, self.LeftUpHandler, "KBM Main Button Left Up")
	self.Drag:EventAttach(Event.UI.Input.Mouse.Left.Click, self.LeftClickHandler, "KBM Main Button Left Click")
	self.Drag:SetMouseMasking("limited")
	
	if KBM.Options.Button.Unlocked then
		self:SetUnlocked(true)
	end
		
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
	ChatObj.Html = false
	function self:Display(ChatObj)
		if ChatObj.Enabled then
			Command.Console.Display("general", false, tostring(ChatObj.Text), ChatObj.Html)
		end
	end
	return ChatObj
end

function KBM.Chat.Out(Text, Html, prefix)
	prefix = prefix or false
	Html = Html or false
	Command.Console.Display("general", prefix, Text, Html)
end

function KBM.CheckActiveBoss(UnitObj)
	local current = Inspect.Time.Real()
	local style = "new"
	local UnitID = UnitObj.UnitID
	local uDetails = UnitObj.Details
	if KBM.IgnoreList[UnitID] or KBM.BossID[UnitID] then
		return
	end
	if KBM.Options.Enabled then
		if (not KBM.Idle.Wait or (KBM.Idle.Wait == true and KBM.Idle.Until < current)) or KBM.Encounter then
			local BossObj = nil
			KBM.Idle.Wait = false
			--if not KBM.BossID[UnitID] then
				if UnitObj.Loaded  and UnitObj.Combat then
					local skipCache = false
					if UnitObj.Type then
						if KBM.Boss.TypeList[UnitObj.Type] then
							BossObj = KBM.Boss.TypeList[UnitObj.Type]
							if KBM.Boss.Chronicle[UnitObj.Type] then
								if not KBM.Encounter then
									KBM.EncounterMode = "Chronicle"
								end
							else
								if not KBM.Encounter then
									KBM.EncounterMode = BossObj.Mod.InstanceObj.Type
								end
							end
						end
					end
					if not BossObj then
						-- Check if Unit is currently in Template form.
						BossObj = KBM.Boss.Template[UnitObj.Name]
						if BossObj then
							if not KBM.Encounter then
								KBM.EncounterMode = "Template"
							end
						end
					else
						skipCache = true
					end
					local ModBossObj = nil
					if BossObj then
						if BossObj.Mod then
							local ModAttempt = nil
							if KBM.Encounter then
								if BossObj.Mod.ID == KBM.CurrentMod.ID then
									ModBossObj = KBM.CurrentMod:UnitHPCheck(uDetails, UnitID)
									ModAttempt = BossObj.Mod
								end
							else
								if not BossObj.Ignore then
									ModBossObj = BossObj.Mod:UnitHPCheck(uDetails, UnitID)
									ModAttempt = BossObj.Mod
								end
							end
							if ModBossObj then
								local hasUTID = false
								if skipCache == false then
									if UnitObj.Type then
										if type(BossObj.UTID) == "string" then
											if BossObj.UTID == UnitObj.Type then
												hasUTID = true
											end
										elseif type(BossObj.UTID) == "table" then
											for i, UTID in pairs(BossObj.UTID) do
												if UTID == UnitObj.Type then
													hasUTID = true
													break
												end
											end
										end
									end
								else
									hasUTID = true
								end
								if hasUTID == false then
									if UnitObj.Type then
										if not KBM.Options.UnitCache.List then
											KBM.Options.UnitCache.List = {}
										end
										if not KBM.Options.UnitCache.List[UnitObj.Name] then
											KBM.Options.UnitCache.List[UnitObj.Name] = {}
										end
										if not KBM.Options.UnitCache.List[UnitObj.Name][UnitObj.Type] then
											print("--------------------------------------")
											print("Template Unit/Encounter found.")
											print("Boss Name: "..tostring(UnitObj.Name).." added to Cache")
											local Zone = {
												id = "n/a",
												name = "unavailable",
												["type"] = "n/a",
											}
											if not UnitObj.Zone then
												if LibSUnit.Player.Zone then
													Zone = Inspect.Zone.Detail(LibSUnit.Player.Zone)
												end
											else
												Zone = Inspect.Zone.Detail(uDetails.zone)
											end
											KBM.Options.UnitCache.List[UnitObj.Name][UnitObj.Type] = {
												Location = tostring(KBM.Player.Location),
												Tier = tostring(UnitObj.Tier),
												Level = tostring(UnitObj.Level).." ("..type(UnitObj.Level)..")",
												XYZ = tostring(UnitObj.Position.X)..","..tostring(UnitObj.Position.Y)..","..tostring(UnitObj.Position.Z),
												Zone = Zone,
												Mod = BossObj.Mod.Descript,
												Time = "Start",
												System = tostring(os.date()),
											}
											if KBM.Encounter then
												KBM.Options.UnitCache.List[UnitObj.Name][UnitObj.Type].Time = KBM.ConvertTime(KBM.TimeElapsed)
											end
											KBM.Options.UnitTotal = KBM.Options.UnitTotal + 1
										end
									end
								end
								if (BossObj.Ignore ~= true and KBM.Encounter ~= true) or KBM.Encounter == true then
									if KBM.Debug then
										print("Boss found Checking: Tier = "..tostring(UnitObj.Tier).." "..tostring(UnitObj.Level).." ("..type(UnitObj.Level)..")")
										print("Players location: "..tostring(LibSUnit.Player.Location))
										print("Unit Type: "..tostring(UnitObj.Type))
										print("Unit Name: "..tostring(UnitObj.Name))
										print("Unit X: "..tostring(UnitObj.Position.X))
										print("Unit Y: "..tostring(UnitObj.Position.Y))
										print("Unit Z: "..tostring(UnitObj.Position.Z))
										print("------------------------------------")
									end
									-- if KBM.Debug then
										-- print("Boss matched checking encounter start")
									-- end
									if KBM.EncounterMode ~= "Chronicle" or (KBM.EncounterMode == "Chronicle" and BossObj.Mod.Settings.Chronicle) then
										KBM.BossID[UnitID] = {}
										KBM.BossID[UnitID].UnitObj = UnitObj
										KBM.BossID[UnitID].Monitor = true
										KBM.BossID[UnitID].Mod = BossObj.Mod
										KBM.BossID[UnitID].IdleSince = false
										KBM.BossID[UnitID].Boss = ModBossObj
										KBM.BossID[UnitID].PhaseObj = ModBossObj.PhaseObj
										ModBossObj.UnitObj = UnitObj
										if UnitObj.Health > 0 then
											if KBM.Debug then
												print("Boss is alive and in combat, activating.")
											end
											KBM.BossID[UnitID].Dead = false
											KBM.BossID[UnitID].Available = true
											if not KBM.Encounter then
												-- if KBM.Debug then
													-- print("New encounter, starting")
												-- end
												KBM.Encounter = true
												KBM.CurrentMod = KBM.BossID[UnitID].Mod
												local PercentOver = 99
												if KBM.EncounterMode == "Chronicle" then
													if KBM.CurrentMod.ChroniclePOver then
														PercentOver = KBM.CurrentMod.ChroniclePOver
													end
													print(KBM.Language.Encounter.Start[KBM.Lang].." "..KBM.CurrentMod.Descript.." (Chronicles)")
													if UnitObj.PercentFlat >= PercentOver then 
														KBM.CurrentMod.Settings.Records.Chronicle.Attempts = KBM.CurrentMod.Settings.Records.Chronicle.Attempts + 1
													end
												elseif KBM.EncounterMode == "Template" then
													print("Template Mode actived, no record tracking available.")
												else
													print(KBM.Language.Encounter.Start[KBM.Lang].." "..KBM.CurrentMod.Descript)
													if UnitObj.PercentFlat >= PercentOver then
														KBM.CurrentMod.Settings.Records.Attempts = KBM.CurrentMod.Settings.Records.Attempts + 1
													end
												end
												if UnitObj.PercentFlat < PercentOver then
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
												KBM.Event.Encounter.Start({Type = "start", Mod = KBM.CurrentMod})
												KBM.PercentageMon:Start(KBM.CurrentMod.ID)
											else
												if KBM.PercentageMon.Active then
													if KBM.PercentageMon.Current then
														if UnitObj == KBM.PercentageMon.Current.BossL.UnitObj then
															KBM.PercentageMon:SetPercentL()
															KBM.PercentageMon:SetMarkL()
														elseif UnitObj == KBM.PercentageMon.Current.BossR.UnitObj then
															KBM.PercentageMon:SetPercentR()
															KBM.PercentageMon:SetMarkR()
														end
													end
												end
											end
											if ModBossObj.PhaseObj then
												KBM.BossID[UnitID].PhaseObj = ModBossObj.PhaseObj
												ModBossObj.PhaseObj:UpdateID(UnitID)
												ModBossObj.PhaseObj:Update()
											elseif KBM.PhaseMonitor.Objectives.Lists.Percent[UnitObj.Name] then
												local PhaseObj = table.remove(KBM.PhaseMonitor.Objectives.Lists.Percent[UnitObj.Name])
												if PhaseObj then
													KBM.BossID[UnitID].PhaseObj = PhaseObj
													PhaseObj.BossObj = ModBossObj
													PhaseObj.UnitObj = UnitObj
													PhaseObj:UpdateID(UnitID)
													PhaseObj:Update()
												end
											elseif KBM.PhaseMonitor.Objectives.Lists.Percent[UnitID] then
												KBM.BossID[UnitID].PhaseObj = KBM.PhaseMonitor.Objectives.Lists.Percent[UnitID]
												KBM.BossID[UnitID].PhaseObj.UnitObj = UnitObj
												KBM.BossID[UnitID].PhaseObj:Update()
											elseif KBM.BossID[UnitID].PhaseObj then
												KBM.BossID[UnitID].PhaseObj:UpdateID(UnitID)
												KBM.BossID[UnitID].PhaseObj:Update()
											end
										else
											KBM.BossID[UnitID].Dead = true
											KBM.BossID[UnitID].Available = true
										end
									end
								end
							elseif not KBM.Encounter then
								if ModAttempt then
									if ModAttempt.EncounterRunning then
										ModAttempt:Reset()
									else
										if KBM.PhaseMonitor.ActiveObjects._count > 0 then
											KBM.PhaseMonitor:Remove()
										end
									end
								end
							end
						end
					else
						-- if UnitObj.CurrentKey == "Avail" then
							-- if UnitObj.Type then
								-- if not KBM.Boss.TypeList[UnitObj.Type] then
									-- if UnitObj.Relation == "hostile" then
										-- if KBM.Debug then
											-- if not KBM.IgnoreList[UnitID] then
												-- -- print("New Unit Added to Ignore:")
												-- -- dump(uDetails)
												-- -- print("----------")
											-- end
										-- end
										-- --KBM.IgnoreList[UnitID] = true
									-- end
								-- end
							-- end
						-- end
					end
				end
			--else
				-- if uDetails then
					-- if uDetails.health == 0 then
						-- KBM.BossID[UnitID].Combat = false
						-- KBM.BossID[UnitID].available = true
						-- if not KBM.BossID[UnitID].dead then
							-- KBM.BossID[UnitID].dead = true
						-- end
					-- end
				-- end
			--end
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

function KBM.CombatEnter(handle, uList)
	if KBM.Options.Enabled then
		for UnitID, UnitObj in pairs(uList) do
			if not UnitObj.Player then
				KBM.CheckActiveBoss(UnitObj)
			end
		end
	end	
end

function KBM.Damage(handle, info)
	-- Damage done by a Non Raid Member to Anything.
	if KBM.Options.Enabled then
		if info.targetObj and info.sourceObj then
			local tarObj = info.targetObj
			local srcObj = info.sourceObj
			if KBM.Encounter then
				-- Damage done by a Boss Object to the Raid [DURING ENCOUNTER]
				local PlayerObj = LibSUnit.Raid.UID[tarObj.UnitID]
				if PlayerObj then
					local BossObj = KBM.BossID[srcObj.UnitID]
					if KBM.CurrentMod then
						if BossObj then
							if info.abilityName then
								if KBM.Trigger.Damage[info.abilityName] then
									TriggerObj = KBM.Trigger.Damage[info.abilityName]
									KBM.Trigger.Queue:Add(TriggerObj, srcObj.UnitID, PlayerObj.UnitID)
								end
							end
							-- Check for Npc Based Triggers (Usually Dynamic: Eg - Failsafe for P4 start Akylios)
							if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID] then
								if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][BossObj.Name] then
									local TriggerObj = KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][BossObj.Name]
									if TriggerObj.Enabled then
										KBM.Trigger.Queue:Add(TriggerObj, srcObj.UnitID, PlayerObj.UnitID)
									end
								end
							end
						else
							if not LibSUnit.Raid.UID[srcObj.UnitID] then
								if srcObj.Combat then
									if not srcObj.Dead then
										KBM.CheckActiveBoss(srcObj)
									end
								end
							end
						end
					end
				else
					-- Damage by the Raid to a Boss Object [DURING ENCOUNTER]
					local PlayerObj = LibSUnit.Raid.UID[srcObj.UnitID]
					if PlayerObj then
						local BossObj = KBM.BossID[tarObj.UnitID]
						if BossObj then
							if not BossObj.Dead then
								if KBM.CurrentMod then
									-- Check for Npc Based Triggers (Usually Dynamic: Eg - Failsafe for P4 start Akylios)
									if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID] then
										if KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][BossObj.Name] then
											local TriggerObj = KBM.Trigger.NpcDamage[KBM.CurrentMod.ID][BossObj.Name]
											if TriggerObj.Enabled then
												KBM.Trigger.Queue:Add(TriggerObj, srcObj.UnitID, tarObj.UnitID)
											end
										end
									end
								end
							end
						else
							if not LibSUnit.Raid.UID[tarObj.UnitID] then
								if tarObj.Combat then
									if not tarObj.Dead then
										KBM.CheckActiveBoss(tarObj)
									end
								end
							end
						end
					end
				end			
			else
				-- Encounter state is idle, check triggering methods.
				-- This is a fail-safe, and not usually used for Encounter starts.
				local PlayerObj = LibSUnit.Raid.UID[srcObj.UnitID]
				if PlayerObj then
					if not LibSUnit.Raid.UID[tarObj.UnitID] then
						if tarObj.Combat then
							if not tarObj.Dead then
								KBM.CheckActiveBoss(tarObj)
							end
						end
					end
				else
					PlayerObj = LibSUnit.Raid.UID[tarObj.UnitID]
					if PlayerObj then
						if not LibSUnit.Raid.UID[srcObj.UnitID] then
							if srcObj.Combat then
								if not srcObj.Dead then
									KBM.CheckActiveBoss(srcObj)
								end
							end
						end
					end
				end
			end
		end
	end
end

function KBM.Heal(handle, info)
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
	self:CreateTrack("KBMReadyCheck", "KBM:RC", 0.9, 0.5, 0.35)
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

function KBM.Unit.Percent(handle, UnitObj)
	if KBM.Encounter then
		local BossObj = KBM.BossID[UnitObj.UnitID]
		if BossObj then
			if UnitObj.PercentFlat ~= UnitObj.PercentFlatLast then
				if KBM.Trigger.Percent[KBM.CurrentMod.ID] then
					if KBM.Trigger.Percent[KBM.CurrentMod.ID][UnitObj.Name] then
						if UnitObj.PercentFlatLast - UnitObj.PercentFlat > 1 then
							for PCycle = UnitObj.PercentFlatLast, UnitObj.PercentFlat, -1 do
								if KBM.Trigger.Percent[KBM.CurrentMod.ID][UnitObj.Name][PCycle] then
									TriggerObj = KBM.Trigger.Percent[KBM.CurrentMod.ID][UnitObj.Name][PCycle]
									KBM.Trigger.Queue:Add(TriggerObj, nil, UnitObj.UnitID)
								end
							end
						else
							if KBM.Trigger.Percent[KBM.CurrentMod.ID][UnitObj.Name][UnitObj.PercentFlat] then
								TriggerObj = KBM.Trigger.Percent[KBM.CurrentMod.ID][UnitObj.Name][UnitObj.PercentFlat]
								KBM.Trigger.Queue:Add(TriggerObj, nil, UnitObj.UnitID)
							end
						end
					end
				end
			end
			if KBM.PhaseMonitor.Active then
				if KBM.PhaseMonitor.Objectives.Lists.Percent[UnitObj.UnitID] then
					KBM.PhaseMonitor.Objectives.Lists.Percent[UnitObj.UnitID]:Update()
				end
			end
			if KBM.PercentageMon.Active then
				if KBM.PercentageMon.Current then
					if KBM.PercentageMon.Current.BossL.UnitObj == UnitObj then
						KBM.PercentageMon:SetPercentL()
					elseif KBM.PercentageMon.Current.BossR.UnitObj == UnitObj then	
						KBM.PercentageMon:SetPercentR()
					end
				end
			end
		end
	end
end

function KBM.Unit.Available(handle, UnitObj)
	if KBM.Encounter then
		if UnitObj.Loaded then
			if not UnitObj.Player then
				if not KBM.BossID[UnitObj.UnitID] then
					KBM.CheckActiveBoss(UnitObj)
				else
					KBM.BossID[UnitObj.UnitID].Boss.UnitObj = UnitObj
				end
			end
		end
	end
end

function KBM.Unit.Removed(handle, Units)
	for UnitID, UnitObj in pairs(Units) do
		KBM.IgnoreList[UnitID] = nil
	end
end

function KBM.Unit.Mark(handle, Units)
	if KBM.PercentageMon.Active then
		if KBM.PercentageMon.Settings.Marks then
			if KBM.PercentageMon.Current then
				for UnitID, UnitObj in pairs(Units) do
					if KBM.PercentageMon.Current.BossL.UnitObj == UnitObj then
						KBM.PercentageMon:SetMarkL()
					elseif KBM.PercentageMon.Current.BossR.UnitObj == UnitObj then	
						KBM.PercentageMon:SetMarkR()
					end
				end
			end
		end
	end
end

function KBM.CreateEditFrame(parent, hook, layer)
	local df = UI.CreateFrame("Frame", parent:GetName().."_DragFrame", parent)	
	df:SetLayer(layer or 10)
	df:SetAllPoints(parent)
	df:SetVisible(false)
	df._hook = hook
	
	local EventFunc = {}
	function EventFunc:HandleMouseDown()
		local Mouse = Inspect.Mouse()
		
		self:SetBackgroundColor(0,0,0,0.5)
		self._offset = {
			x = (Mouse.x - (self:GetLeft() + (self:GetWidth() * 0.5))) or 0,
			y = (Mouse.y - (self:GetTop() + (self:GetHeight() * 0.5))) or 0,
		}
		if self._hook then
			self._hook("start")
		end
		
		self:EventAttach(Event.UI.Input.Mouse.Cursor.Move, EventFunc.HandleMouseMove, "KBM-EditFrame-MouseMoveHandler_"..parent:GetName())
		self._moving = true
	end
	
	function EventFunc:HandleMouseMove(handle, x, y)
		if self._moving then
			self:GetParent():SetPoint("CENTER", UIParent, "TOPLEFT", x - self._offset.x, y - self._offset.y)
		end
	end
	
	function EventFunc:HandleMouseUp()
		if self._moving then
			local Mouse = Inspect.Mouse()
			
			self:SetBackgroundColor(0,0,0,0)
			self:EventDetach(Event.UI.Input.Mouse.Cursor.Move, EventFunc.HandleMouseMove)
			local relX = (Mouse.x - self._offset.x) / UIParent:GetWidth()
			local relY = (Mouse.y - self._offset.y) / UIParent:GetHeight()
			self._offset = nil
			
			if self._hook then
				self._hook("end", relX, relY)
			end
			self:GetParent():SetPoint("CENTER", UIParent, relX, relY)
			self._moving = false
		end
	end
		
	-- function BarObj:unlockSize(bool)
		-- if bool then
			-- ui.editFrame:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, EventFunc.HandleMouseWheelForward, "LibSCast-EditFrame-MouseWheelForwardHandler_"..ui.cradle:GetName())
			-- ui.editFrame:EventAttach(Event.UI.Input.Mouse.Wheel.Back, EventFunc.HandleMouseWheelBack, "LibSCast-EditFrame-MouseWheelBackHandler_"..ui.cradle:GetName())
			-- ui.editFrame:EventAttach(Event.UI.Input.Mouse.Middle.Click, EventFunc.HandleMouseWheelClick, "LibSCast-EditFrame-MouseMiddleClickHandler_"..ui.cradle:GetName())
		-- else
			-- ui.editFrame:EventDetach(Event.UI.Input.Mouse.Wheel.Forward, EventFunc.HandleMouseWheelForward)
			-- ui.editFrame:EventDetach(Event.UI.Input.Mouse.Wheel.Back, EventFunc.HandleMouseWheelBack)
			-- ui.editFrame:EventDetach(Event.UI.Input.Mouse.Middle.Click, EventFunc.HandleMouseWheelClick)		
		-- end
	-- end
	
	df:EventAttach(Event.UI.Input.Mouse.Left.Down, EventFunc.HandleMouseDown, "KBM-EditFrame-MouseDownHandler_"..parent:GetName())
	df:EventAttach(Event.UI.Input.Mouse.Left.Up, EventFunc.HandleMouseUp, "KBM-EditFrame-MouseUpHandler_"..parent:GetName())
	df:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, EventFunc.HandleMouseUp, "KBM-EditFrame-MouseUpoutsideHandler_"..parent:GetName())
	
	return df
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
	Drag.Layer = parent:GetLayer()
	Drag.Parent = parent
	Drag.FrameEvents = {}
	Drag.Frame.FrameEvents = Drag.FrameEvents
	
	function Drag.FrameEvents:LeftDownHandler()
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
		Drag.Parent:SetLayer(KBM.Layer.DragActive)
	end
	
	function Drag.FrameEvents:MouseMoveHandler(handle, mouseX, mouseY)
		if self.MouseDown then
			self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", (mouseX - self.StartX), (mouseY - self.StartY))
		end
	end
	
	function Drag.FrameEvents:LeftUpHandler()
		if self.MouseDown then
			self.MouseDown = false
			self:SetBackgroundColor(0,0,0,0)
			Drag.hook("end")
			Drag.Parent:SetLayer(Drag.Layer)
		end
	end
	
	function Drag.Frame:Remove()	
		Drag.Frame:EventDettach(Event.UI.Input.Mouse.Left.Down, Drag.FrameEvents.LeftDownHandler)
		Drag.Frame:EventDettach(Event.UI.Input.Mouse.Cursor.Move, Drag.FrameEvents.MouseMoveHandler)
		Drag.Frame:EventDettach(Event.UI.Input.Mouse.Left.Up, Drag.FrameEvents.LeftUpHandler)
		Drag.hook = nil
		self:sRemove()
		self.Remove = nil		
	end
	
	Drag.Frame:EventAttach(Event.UI.Input.Mouse.Left.Down, Drag.FrameEvents.LeftDownHandler, "Drag Frame Left Down Handler: "..Drag.Parent:GetName())
	Drag.Frame:EventAttach(Event.UI.Input.Mouse.Cursor.Move, Drag.FrameEvents.MouseMoveHandler, "Drag Frame Mouse Move Handler: "..Drag.Parent:GetName())
	Drag.Frame:EventAttach(Event.UI.Input.Mouse.Left.Up, Drag.FrameEvents.LeftUpHandler, "Drag Frame Left Up Handler: "..Drag.Parent:GetName())
	return Drag.Frame
end

local function KBM_Reset(Forced)
	if KBM.Encounter then
		if Forced == true then
			KBM.Event.Encounter.End({Type = "reset", Mod = KBM.CurrentMod})
			KBM.IgnoreList = {}
		else
			KBM.Idle.Wait = true
			KBM.Idle.Until = Inspect.Time.Real() + KBM.Idle.Duration
		end
		KBM.Idle.Combat.Wait = false
		KBM.Encounter = false
		if KBM.CurrentMod then
			if KBM.Trigger.Seq[KBM.CurrentMod.ID] then
				for i, Trigger in ipairs(KBM.Trigger.Seq[KBM.CurrentMod.ID]) do
					Trigger:ResetSeq()
				end
			end
			KBM.CurrentMod:Reset()
			KBM.CurrentMod = nil
			KBM.CurrentBoss = ""
			KBM_CurrentBossName = ""
		end
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
		KBM.PercentageMon:End()
		for UnitID, BossObj in pairs(KBM.BossID) do
			if BossObj.Boss then
				BossObj.Boss.UnitObj = nil
				if Forced == "victory" then
					KBM.IgnoreList[UnitID] = true
				end
			end
		end
		KBM.BossID = {}
	else
		print("No encounter to reset.")
		KBM.IgnoreList = {}
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

function KBM.Raid.CombatEnter(handle)

	if KBM.Debug then
		print("Raid has entered combat: Number in combat = "..LibSUnit.Raid.CombatTotal)
	end
	if KBM.Idle.Combat.Wait then
		KBM.Idle.Combat.Wait = false
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
		if KBM.EncounterMode == "Chronicle" then
			KBM.CurrentMod.Settings.Records.Chronicle.Wipes = KBM.CurrentMod.Settings.Records.Chronicle.Wipes + 1
		elseif KBM.EncounterMode ~= "Template" then
			KBM.CurrentMod.Settings.Records.Wipes = KBM.CurrentMod.Settings.Records.Wipes + 1
		end
		KBM.Event.Encounter.End({Type = "wipe", Mod = KBM.CurrentMod})
		KBM_Reset()
	end
	
end

function KBM.Raid.CombatLeave(handle)

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
	end
	
end

KBM.ClearBuffers = 0

function KBM:Timer(handle)

	local current = Inspect.Time.Real()
	local diff = (current - self.HeldTime)
	local udiff = (current - self.UpdateTime)

	if not KBM.Updating then
		KBM.Updating = true
		
		if KBM.Options.Enabled then			
			if diff >= 1 then				
				if KBM.Options.CPU.Enabled then
					KBM.CPU:UpdateAll()
				end
				KBM.ResMaster:Update()
				self.HeldTime = current								
			end
			
			if KBM.Encounter then
				if KBM.CurrentMod then
					KBM.CurrentMod:Timer(current, diff)
					KBM.PercentageMon:Update(current, diff)
				end
				if diff >= 1 then
					self.LastElapsed = self.TimeElapsed
					self.TimeElapsed = math.floor(current - self.StartTime)
					if KBM.CurrentMod.Enrage then
						self.EnrageTimer = self.EnrageTime - math.floor(current)
					end
					if self.Options.EncTimer.Enabled then
						self.EncTimer:Update(current)
					end
					self.HeldTime = current - (diff - math.floor(diff))
					self.UpdateTime = current
					if self.Trigger.Time[KBM.CurrentMod.ID] then
						for TimeCheck = (self.LastElapsed + 1), self.TimeElapsed do
							if self.Trigger.Time[KBM.CurrentMod.ID][TimeCheck] then
								self.Trigger.Time[KBM.CurrentMod.ID][TimeCheck]:Activate(current)
							end
						end
					end
				end
				for ID, PlugIn in pairs(self.PlugIn.List) do
					PlugIn:Timer(current)
				end	
				-- for UnitID, CastCheck in pairs(KBM.CastBar.ActiveCastBars) do
					-- local Trigger = true
					-- for ID, CastBarObj in pairs(CastCheck.List) do
						-- CastBarObj:Update(Trigger)
						-- Trigger = false
					-- end
				-- end
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
				
				-- for UnitID, CastCheck in pairs(KBM.CastBar.ActiveCastBars) do
					-- local Trigger = true
					-- for ID, CastBarObj in pairs(CastCheck.List) do
						-- CastBarObj:Update(Trigger)
						-- Trigger = false
					-- end
				-- end
			end
		end
		
		KBM.Updating = false
	end	
end

function KBM:AuxTimer(handle)
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

function KBM.Victory()
	print(KBM.Language.Encounter.Victory[KBM.Lang])
	if KBM.EncounterMode == "Chronicle" then
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
	elseif KBM.EncounterMode == "Template" then
		print("Template Mode activated. Recording cancelled.")
	else
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
	end
	KBM.Event.Encounter.End({Type = "victory", KBM.CurrentMod})
	KBM_Reset("victory")
end

function KBM.Unit.Death(handle, info)	
	if KBM.Options.Enabled then	
		if KBM.Encounter then
			local UnitObj = info.targetObj
			if UnitObj then
				if LibSUnit.Raid.UID[UnitObj.UnitID] then
					if KBM.TankSwap.Active then
						if KBM.TankSwap.Tanks[UnitObj.UnitID] then
							KBM.TankSwap.Tanks[UnitObj.UnitID]:Death()
						end
					end
					if LibSUnit.Raid.Wiped then
						if KBM.Debug then
							print("All dead, definite wipe (Experimental)")
							KBM.Idle.Combat.StoreTime = KBM.TimeElapsed
							KBM.WipeIt(true)
						end
					end
				else
					if KBM.CurrentMod then
						if KBM.CurrentMod.ID then
							if KBM.Trigger.Death[KBM.CurrentMod.ID] then
								local TriggerObj = KBM.Trigger.Death[KBM.CurrentMod.ID][UnitObj.Name]
								if TriggerObj then
									KBM.Trigger.Queue:Add(TriggerObj, nil, UnitObj.UnitID)
								end
							end
						end
					end
					if KBM.BossID[UnitObj.UnitID] then
						KBM.BossID[UnitObj.UnitID].Dead = true
						if KBM.PhaseMonitor.Active then
							if KBM.PhaseMonitor.Objectives.Lists.Death[UnitObj.Name] then
								KBM.PhaseMonitor.Objectives.Lists.Death[UnitObj.Name]:Kill(UnitObj)
							end
						end
						if KBM.CurrentMod:Death(UnitObj.UnitID) then
							KBM:Victory()
						end
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

function KBM.Notify(handle, data)
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
							local sStart, sEnd, Target
							sStart, sEnd, Target = string.find(data.message, TriggerObj.Phrase)
							if sStart then
								local unitID = nil
								if Target then
									if LibSUnit.Lookup.Name[Target] then
										for UnitID, UnitObj in pairs (LibSUnit.Lookup.Name[Target]) do
											if UnitObj.Player then
												unitID = UnitID
												break
											end
										end
									end
								else
									unitID = "uNone"
								end
								KBM.Trigger.Queue:Add(TriggerObj, TriggerObj.Unit.Name, unitID)
								break
							end
						end
					end
				end
			end
		end
	end	
end

function KBM.NPCChat(handle, data)
	if KBM.Debug then
		print("Chat Capture;")
		dump(data)
	end

	if KBM.Options.Enabled then
		if KBM.Encounter then
			if data.fromName then
				if KBM.CurrentMod then
					if KBM.Trigger.Say[KBM.CurrentMod.ID] then
						for i, TriggerObj in ipairs(KBM.Trigger.Say[KBM.CurrentMod.ID]) do
							if TriggerObj.Unit.Name == data.fromName then
								local sStart, sEnd, Target
								sStart, sEnd, Target = string.find(data.message, TriggerObj.Phrase)
								if sStart then
									if not Target then
										Target = "NotifyObject"
									end
									KBM.Trigger.Queue:Add(TriggerObj, data.fromName, Target)
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

function KBM:BuffAdd(handle, Units)
	-- Used to manage Triggers and soon Tank-Swap managing.
	-- local TimeStore = Inspect.Time.Real()
	
	if KBM.Options.Enabled then
		if KBM.Encounter then
			for unitID, BuffTable in pairs(Units) do
				for BuffID, bDetails in pairs(BuffTable) do
					if bDetails then
						if KBM.Trigger.Buff[KBM.CurrentMod.ID] then
							if KBM.Trigger.Buff[KBM.CurrentMod.ID][bDetails.name] then
								local uDetails = LibSUnit.Lookup.UID[unitID]
								if uDetails then
									local TriggerObj = KBM.Trigger.Buff[KBM.CurrentMod.ID][bDetails.name][uDetails.Name]
									if TriggerObj then
										if TriggerObj.Unit.UnitID == unitID then
											if KBM.Debug then
												print("Bossbuff Trigger matched: "..bDetails.name)
												dump(bDetails)
											end
											if TriggerObj.MinStack then
												if bDetails.stack then
													if bDetails.stack < TriggerObj.MinStack then
														return
													end
												else 
													return
												end
											end
											KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
										end
									end
								end
							end
						end
						if KBM.Trigger.BuffID[KBM.CurrentMod.ID] then
							if KBM.Trigger.BuffID[KBM.CurrentMod.ID][bDetails.type] then
								local uDetails = LibSUnit.Lookup.UID[unitID]
								if uDetails then
									local TriggerObj = KBM.Trigger.BuffID[KBM.CurrentMod.ID][bDetails.type][uDetails.Name]
									if TriggerObj then
										if TriggerObj.Unit.UnitID == unitID then
											if KBM.Debug then
												print("Bossbuff Trigger matched by id: "..bDetails.name)
												dump(bDetails)
											end
											if TriggerObj.MinStack then
												if bDetails.stack then
													if bDetails.stack < TriggerObj.MinStack then
														return
													end
												else 
													return
												end
											end
											KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
										end
									end
								end
							end
						end
						-- if KBM.Trigger.PlayerDebuff[KBM.CurrentMod.ID] ~= nil and bDetails.debuff == true then
							-- if KBM.Trigger.PlayerDebuff[KBM.CurrentMod.ID][bDetails.name] then
								-- local TriggerObj = KBM.Trigger.PlayerDebuff[KBM.CurrentMod.ID][bDetails.name]
								-- if LibSUnit.Raid.UID[unitID] ~= nil or unitID == LibSUnit.Player.UnitID then
									-- if KBM.Debug then
										-- print("Debuff Trigger matched: "..bDetails.name)
										-- if LibSUnit.Raid.Grouped then
											-- print("LibSUnit Match: "..tostring(LibSUnit.Raid.UID[unitID]))
										-- end
										-- print("Player Match: "..LibSUnit.Player.UnitID.." - "..unitID)
										-- print("---------------")
										-- dump(bDetails)
									-- end
									-- KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
								-- end
							-- end
						-- end
						if KBM.Trigger.PlayerIDBuff[KBM.CurrentMod.ID] then
							if KBM.Trigger.PlayerIDBuff[KBM.CurrentMod.ID][bDetails.type] then
								local TriggerObj = KBM.Trigger.PlayerIDBuff[KBM.CurrentMod.ID][bDetails.type]
								if LibSUnit.Raid.UID[unitID] ~= nil or unitID == LibSUnit.Player.UnitID then
									if KBM.Debug then
										print("Debuff Trigger matched by id: "..bDetails.name)
										if LibSUnit.Raid.Grouped then
											print("LibSUnit Match: "..tostring(LibSUnit.Raid.UID[unitID]))
										end
										print("Player Match: "..LibSUnit.Player.UnitID.." - "..unitID)
										print("---------------")
										dump(bDetails)
									end
									if TriggerObj.MinStack then
										if bDetails.stack then
											if bDetails.stack < TriggerObj.MinStack then
												return
											end
										else
											return
										end
									end
									KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
								end
							end
						end
						if KBM.Trigger.PlayerBuff[KBM.CurrentMod.ID] then
							if KBM.Trigger.PlayerBuff[KBM.CurrentMod.ID][bDetails.name] then
								local TriggerObj = KBM.Trigger.PlayerBuff[KBM.CurrentMod.ID][bDetails.name]
								if LibSUnit.Raid.UID[unitID] ~= nil or unitID == LibSUnit.Player.UnitID then
									if KBM.Debug then
										print("Buff Trigger matched: "..bDetails.name)
										if LibSUnit.Raid.Grouped then
											print("LibSUnit Match: "..tostring(LibSUnit.Raid.UID[unitID]))
										end
										print("Player Match: "..LibSUnit.Player.UnitID.." - "..unitID)
										print("---------------")
										dump(bDetails)
									end
									if TriggerObj.MinStack then
										if bDetails.stack then
											if bDetails.stack < TriggerObj.MinStack then
												return
											end
										else
											return
										end
									end
									KBM.Trigger.Queue:Add(TriggerObj, unitID, unitID, bDetails.remaining)
								end
							end
						end
						if unitID == LibSUnit.Player.UnitID then
							if KBM.Buffs.WatchID[bDetails.LibSBuffType] then
								if KBM.Trigger.CustomBuffRemove["playerBuffID"] then
									if KBM.Trigger.CustomBuffRemove["playerBuffID"][bDetails.LibSBuffType] then
										local Trigger = KBM.Trigger.CustomBuffRemove["playerBuffID"][bDetails.LibSBuffType]
										Trigger:Activate(unitID, bDetails.caster, BuffID)
									end
								end
							end
						end
						if KBM.TankSwap.Active then
							if KBM.TankSwap.Tanks[unitID] then
								if KBM.TankSwap.DebuffName[bDetails.name] then
									KBM.TankSwap.Tanks[unitID]:BuffUpdate(BuffID, bDetails.name)
								elseif KBM.TankSwap.DebuffName[bDetails.LibSBuffType] then
									KBM.TankSwap.Tanks[unitID]:BuffUpdate(BuffID, bDetails.LibSBuffType)
								end
							end
						end
					end
				end
			end
		else
			for unitID, BuffTable in pairs(Units) do
				for BuffID, bDetails in pairs(BuffTable) do
					if bDetails then
						if KBM.Trigger.EncStart["playerBuff"] then
							if KBM.Trigger.EncStart["playerBuff"][bDetails.name] then
								local TriggerMod = KBM.Trigger.EncStart["playerBuff"][bDetails.name]
								if TriggerMod.Dummy then
									KBM.CheckActiveBoss(TriggerMod.Dummy.Details, "Dummy")
								end
							end
						end
						if unitID == KBM.Player.UnitID then
							if KBM.Buffs.WatchID[bDetails.LibSBuffType] then
								if KBM.Trigger.CustomBuffRemove["playerBuffID"] then
									if KBM.Trigger.CustomBuffRemove["playerBuffID"][bDetails.LibSBuffType] then
										local Trigger = KBM.Trigger.CustomBuffRemove["playerBuffID"][bDetails.LibSBuffType]
										Trigger:Activate(unitID, bDetails.caster, BuffID)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function KBM:BuffRemove(handle, Units)
	if KBM.Options.Enabled then
		if KBM.Encounter then
			for unitID, BuffTable in pairs(Units) do
				for BuffID, bDetails in pairs(BuffTable) do
					if bDetails then
						if KBM.Trigger.BuffRemove[KBM.CurrentMod.ID] then
							if KBM.Trigger.BuffRemove[KBM.CurrentMod.ID][bDetails.name] then
								local uDetails = LibSUnit.Lookup.UID[unitID]
								if uDetails then
									local TriggerObj = KBM.Trigger.BuffRemove[KBM.CurrentMod.ID][bDetails.name][uDetails.Name]
									if TriggerObj then
										if TriggerObj.Unit.UnitID == unitID then
											if KBM.Debug then
												print("BossbuffRemove Trigger matched: "..bDetails.name)
												dump(bDetails)
											end
											KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, nil)
										end
									end
								end
							end
						end
						if KBM.Trigger.BuffIDRemove[KBM.CurrentMod.ID] then
							if KBM.Trigger.BuffIDRemove[KBM.CurrentMod.ID][bDetails.type] then
								local uDetails = LibSUnit.Lookup.UID[unitID]
								if uDetails then
									local TriggerObj = KBM.Trigger.BuffIDRemove[KBM.CurrentMod.ID][bDetails.type][uDetails.Name]
									if TriggerObj then
										if TriggerObj.Unit.UnitID == unitID then
											if KBM.Debug then
												print("BossbuffRemove Trigger matched by id: "..bDetails.name)
												dump(bDetails)
											end
											KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, nil)
										end
									end
								end
							end
						end
						if KBM.Trigger.PlayerBuffRemove[KBM.CurrentMod.ID] then
							if KBM.Trigger.PlayerBuffRemove[KBM.CurrentMod.ID][bDetails.name] then
								local TriggerObj = KBM.Trigger.PlayerBuffRemove[KBM.CurrentMod.ID][bDetails.name]
								if LibSUnit.Raid.UID[unitID] or unitID == LibSUnit.Player.UnitID then
									KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, nil)
								end
							end
						end
						if KBM.Trigger.PlayerIDBuffRemove[KBM.CurrentMod.ID] then
							if KBM.Trigger.PlayerIDBuffRemove[KBM.CurrentMod.ID][bDetails.type] then
								local TriggerObj = KBM.Trigger.PlayerIDBuffRemove[KBM.CurrentMod.ID][bDetails.type]
								if LibSUnit.Raid.UID[unitID] or unitID == LibSUnit.Player.UnitID then
									KBM.Trigger.Queue:Add(TriggerObj, nil, unitID, nil)
								end
							end
						end
					end
				end
			end
		end
	end
end

function KBM.SlashInspectBuffs(handle, Name)
	local UnitID = ""
	if Name == "" then
		Name = KBM.Player.Name
		UnitID = KBM.Player.UnitID
	elseif Name == "%t" then
		local tDetails = Inspect.Unit.Detail("player.target")
		if tDetails then
			if tDetails.id then
				Name = tDetails.name
				UnitID = tDetails.id 
			end
		else
			Name = KBM.Player.Name
			UnitID = KBM.Player.UnitID
		end
	else
		if LibSUnit.Lookup.Name[Name] then
			for lUnitID, Object in pairs(LibSUnit.Lookup.Name[Name]) do
				UnitID = lUnitID
			end
		end
	end
	if UnitID ~= "" then
		print("----------------")
		print("Inspecting Buffs for: "..tostring(Name))
		if UnitID then
			if LibSBuff.Cache[UnitID] then
				for buffID, bDetails in pairs(LibSBuff.Cache[UnitID].BuffID or {}) do
					if bDetails then
						if type(bDetails) == "table" then
							print(tostring(bDetails.name).." : "..tostring(bDetails.LibSBuffType))
						end
					end
				end
				print("----------------")
			end
		end
	else
		print("No Buff data available for: "..tostring(Name))
	end
end

function KBM.FormatPrecision(Val)
	if Val < 0.000001 or Val == nil then
		return "Too Low"
	else
		return string.format("%0.6fs", Val)
	end
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
		else
			name = ""
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

function KBM.ApplySettings()
	KBM.TankSwap.Enabled = KBM.Options.TankSwap.Enabled
end

local function KBM_Debug()
	if KBM.Debug then
		print("Debugging disabled")
		KBM.Debug = false
		KBM.Options.Debug = false
	else
		print("Debugging enabled")
		KBM.Debug = true
		KBM.Options.Debug = true
	end
end

function KBM.SecureEnter()
end

function KBM.SecureLeave()
	if not LibSUnit.Raid.Grouped then
		KBM.Raid.CombatLeave()
	end
end

function KBM.RaidRes(data)
	if KBM.Debug then
		print("Raid Ressurect")
		dump(data)
		print("Total Dead: "..tostring(LibSUnit.Raid.DeadTotal).."/"..tostring(LibSUnit.Raid.Members))
		print("--------------")
	end
end

-- Define KBM Custom Event System
-- System Related
KBM.Event.System.Start, KBM.Event.System.Start.EventTable = Utility.Event.Create("KingMolinator", "System.Start")
-- Unit Related
KBM.Event.Unit.Cast.Start, KBM.Event.Unit.Cast.Start.EventTable = Utility.Event.Create("KingMolinator", "Unit.Cast.Start")
KBM.Event.Unit.Cast.End, KBM.Event.Unit.Cast.End.EventTable = Utility.Event.Create("KingMolinator", "Unit.Cast.End")
KBM.Event.System.TankSwap.Start, KBM.Event.System.TankSwap.Start.EventTable = Utility.Event.Create("KingMolinator", "System.TankSwap.Start")
KBM.Event.System.TankSwap.End, KBM.Event.System.TankSwap.End.EventTable = Utility.Event.Create("KingMolinator", "System.TankSwap.End")
-- Encounter Related
KBM.Event.Encounter.Start, KBM.Event.Encounter.Start.EventTable = Utility.Event.Create("KingMolinator", "Encounter.Start")
KBM.Event.Encounter.End, KBM.Event.Encounter.End.EventTable = Utility.Event.Create("KingMolinator", "Encounter.End")

function KBM.InitVars()
	KBM.Button:Init()
	KBM.TankSwap:Init()
	KBM.Alert:Init()
	KBM.MechTimer:Init()
	KBM.Castbar:Init()
	KBM.EncTimer:Init()
	KBM.PhaseMonitor:Init()
	KBM.Trigger:Init()
	KBM.MechSpy:Init()
	KBM.SheepProtection:Init()
end

KBM.SetDefault = {}
function KBM.SetDefault.menu()
	KBM.Menu.Window:SetPoint("TOPLEFT", UIParent, 0.25, 0.2)
	KBM.Options.Frame.RelX = false
	KBM.Options.Frame.RelY = false
end

function KBM.SetDefault.button()
	KBM.Options.Button = KBM.Defaults.Button()
	KBM.Button:ApplySettings()
end

function KBM.SetDefault.rcbutton()
	KBM.Ready.Button:Defaults()
end

function KBM.SetDefault.playercastbar()
	local tempCastObj = KBM.Castbar:DefaultSelf()
	local Castbar = KBM.Castbar.Player.Self
	Castbar.Settings.relX = tempCastObj.relX
	Castbar.Settings.relY = tempCastObj.relY
	if Castbar.Settings.pinned then
		Castbar.Settings.pinned = false
		Castbar.CastObj:Unpin()
		Castbar.CastObj:Unlocked(Castbar.Settings.visible)
		Castbar.Settings.unlocked = Castbar.Settings.visible
		UI.Native.Castbar:EventDetach(Event.UI.Layout.Size, KBM.Castbar.HandlePinScale, "KBMCastbar-Mimic-PinScale-Handler")
	end
	Castbar.CastObj:UpdateSettings()
end

function KBM.SetDefault.targetcastbar()
	local tempCastObj = KBM.Castbar:DefaultTarget()
	local Castbar = KBM.Castbar.Player.Target
	Castbar.Settings.relX = tempCastObj.relX
	Castbar.Settings.relY = tempCastObj.relY
	Castbar.CastObj:UpdateSettings()
end

function KBM.SetDefault.focuscastbar()
	local tempCastObj = KBM.Castbar:DefaultFocus()
	local Castbar = KBM.Castbar.Player.Focus
	Castbar.Settings.relX = tempCastObj.relX
	Castbar.Settings.relY = tempCastObj.relY
	Castbar.CastObj:UpdateSettings()
end

function KBM.SetDefault.bosscastbar()
	local tempCastObj = KBM.Castbar:DefaultGlobal()
	KBM.Options.Castbar.Global.relX = tempCastObj.relX
	KBM.Options.Castbar.Global.relY = tempCastObj.relY
	KBM.Castbar.Anchor.cradle:SetPoint("CENTER", UIParent, KBM.Options.Castbar.Global.relX, KBM.Options.Castbar.Global.relY)
end

function KBM.SetDefault.resmaster()
	KBM.ResMaster.GUI:SetDefault()
end

function KBM.SetDefault.castbars()
	KBM.SetDefault.playercastbar()
	KBM.SetDefault.targetcastbar()
	KBM.SetDefault.focuscastbar()
	KBM.SetDefault.bosscastbar()
end

function KBM.SlashDefault(handle, Args)
	-- Will eventually have different options that will link to default buttons in UI
	-- For now it'll reset the Options Menu Button to its default settings. (Central, Visible and Unlocked)
	Args = string.lower(Args or "")
	if Args == "all" then
		for ID, _function in pairs(KBM.SetDefault) do
			_function()
		end
	elseif KBM.SetDefault[Args] then
		KBM.SetDefault[Args]()
	else 
		print("Bellow are a list of commands for: /kbmdefault")
		print("All\t\t: Will reset all of the below.")
		print("Button\t: Resets KBM's Mini-map button.")
		print("RCButton\t: Resets Ready Check's mini-map button.")
		print("Menu\t: Resets KBM's Menu Option window.")
		print("PlayerCastbar\t: Resets the Player's Castbar position.")
		print("TargetCastbar\t: Resets the Player's Target Castbar position.")
		print("FocusCastbar\t: Resets the Player's Focus Castbar position.")
		print("BossCastbar\t: Resets the Global Boss Castbar position.")
		print("Castbars\t: Resets all Global and Player castbar positions.")
		print("ResMaster\t: Resets the size and position for ResMaster.")
		print("For exmaple: /kbmdefault button.")
	end
end

function KBM.SlashUnitCache(handle, arg)
	if type(arg) == "string" then
		arg = string.upper(arg)
	end
	if arg == "CLEAR" then
		print("Unit Cache has been cleared. /reloadui to save changes.")
		KBM.Options.UnitCache.List = {}
		KBM.Options.UnitTotal = 0
	elseif arg == "TOTAL" then
		print("You have found "..KBM.Options.UnitTotal.." missing UTIDs")
	elseif KBM.Options.UnitTotal > 0 then
		print("You have found "..KBM.Options.UnitTotal.." missing UTIDs")
		print("----------------")
		for UnitName, TypeList in pairs(KBM.Options.UnitCache.List) do
			print("Matches for: "..UnitName)
			for TypeID, Details in pairs(TypeList) do
				print("----------------")
				print("UTID: "..tostring(TypeID))
				for ID, Value in pairs(Details) do
					if ID ~= "Zone" then
						print(tostring(ID).." : "..tostring(Value))
					else
						if type(Value) == "table" then
							print("Zone ID: "..tostring(Value.id))
							print("Zone Name: "..tostring(Value.name))
							print("Zone Type: "..tostring(Value.type))
						else
							print("Zone: Malformed Data")
						end
					end
				end
			end
			print("----------------")
		end
	else
		print("You have not found any missing UTIDs")
	end
end

function KBM.SlashZone()
	zDetails = Inspect.Zone.Detail(LibSUnit.Player.Zone)
	print(zDetails.name)
	print(zDetails.id)
end

function KBM.AllocateBoss(Mod, BossObj, UTID, tableIndex)
	local iType = Mod.InstanceObj.Type
	if UTID ~= "none" then
		if string.len(UTID) == 17 then
			KBM.Boss[iType][UTID] = BossObj
			KBM.Boss.TypeList[UTID] = BossObj
			if KBM.Options.UnitCache.List[BossObj.Name] then
				if KBM.Options.UnitCache.List[BossObj.Name][BossObj.UTID] then
					KBM.Options.UnitCache.List[BossObj.Name][BossObj.UTID] = nil
					KBM.Options.UnitTotal = KBM.Options.UnitTotal - 1
					if not next(KBM.Options.UnitCache.List[BossObj.Name]) then
						KBM.Options.UnitCache.List[BossObj.Name] = nil
					end
				end
			end
			if KBM.Options.UnitCache[iType][Mod.Instance] then
				if KBM.Options.UnitCache[iType][Mod.Instance][BossObj.Name] then
					if tableIndex then
						if tableIndex == KBM.Options.UnitCache[iType][Mod.Instance][BossObj.Name] then
							KBM.Options.UnitCache[iType][Mod.Instance][BossObj.Name] = nil
						end
					else
						KBM.Options.UnitCache[iType][Mod.Instance][BossObj.Name] = nil
					end
				end
				if not next(KBM.Options.UnitCache[iType][Mod.Instance]) then
					KBM.Options.UnitCache[iType][Mod.Instance] = nil
				end
			end
			--print("Raid Boss: "..BossObj.Name.." initizialized successfully: "..BossObj.RaidID)
		else
			print("WARNING: "..BossObj.Name.." ID Length not correct, required Length 17")
			print("Instance: "..BossObj.Mod.Instance)
			print("ID: "..BossObj.UTID)
			print("Instance Type: "..iType)
		end
	else
		if not KBM.Options.UnitCache[iType][Mod.Instance] then
			KBM.Options.UnitCache[iType][Mod.Instance] = {}
		end
		if not KBM.Options.UnitCache[iType][Mod.Instance][BossObj.Name] then
			KBM.Options.UnitCache[iType][Mod.Instance][BossObj.Name] = tableIndex or true
		end
		KBM.Boss.Template[BossObj.Name] = BossObj
	end
end

local function KBM_Start()
	local MinVer = {
		["KBMAddWatch"] = {
			High = 0,
			Mid = 2,
			Low = 9,
			Rev = 74,
		},
		["KBMMarkIt"] = {
			High = 0,
			Mid = 2,
			Low = 0,
			Rev = 43,
		},
	}

	if KBM.PlugIn.Count > 0 then
		for ID, PlugIn in pairs(KBM.PlugIn.List) do
			if type(PlugIn.Version) == "table" then
				if PlugIn.Version.Check then
					local Comp = true
					local VerString = "0.0.0.0"
					if MinVer[ID] then
						Comp = PlugIn.Version:Check(MinVer[ID].Rev)
						VerString = string.format("%d.%d.%d.%d", MinVer[ID].High, MinVer[ID].Mid, MinVer[ID].Low, MinVer[ID].Rev)
					end
					if Comp then
						if PlugIn.Start then
							PlugIn:Start()
						end
					else
						KBM.Chat.Out(string.format(KBM.Language.Chat.PlugVer[KBM.Lang], ID, VerString), true)
					end
				else
					KBM.Chat.Out(string.format(KBM.Language.Chat.PlugInc[KBM.Lang], ID), true)
				end
			else
				KBM.Chat.Out(string.format(KBM.Language.Chat.PlugInc[KBM.Lang], ID), true)
			end
		end
	end		
end

KBM.SheepProtection = {}
function KBM.SheepProtection:Init()
	self.SheepList = {
        ["B2C7F2ABFDAD20E1D"] = "Shambler",
        ["B69270855B9A593AC"] = "Sheep",
        ["B3F04AB1FD601EC35"] = "Love Bug",
        ["B7E9514D567B0BCE4"] = "Wand of Mechanization",
        ["B1E7569A887D9C5C9"] = "Wand of Mechanization",
        ["B0E4E7143CE686BDB"] = "Wand of Mechanization",
        ["B5B2A6080D48E8E9E"] = "Wand of Mechanization",
        ["B5E8A366FF335ECC3"] = "Summerfest Shambler",
        ["B797392B39EBC5AD3"] = "Squirrelexplosion",
        ["B33D22E2E8B7DFF5A"] = "Squirrelexplosion",
        ["B797392B49EBCDE22"] = "Squirrelexplosion", 
        ["B4D5CDC2B645241A1"] = "Squirrelexplosion", 
        ["B797392B19EBB5435"] = "Squirrelexplosion", 
        ["B797392B29EBBD784"] = "Squirrelexplosion", 
        ["B674C1E97D4251F8F"] = "Squirrelexplosion",
        ["B1A82BCFA150C5A56"] = "Corgi Confusion",
        ["B1A82BCF41509467C"] = "Corgi Confusion",
        ["B1A82BCF51509C9CB"] = "Corgi Confusion",
        ["B1A82BCF6150A4D1A"] = "Corgi Confusion",
        ["B7870725BB53856A1"] = "Schafizierung", -- from RR
		["B72D63A680FFFB3E4"] = "Dwarf Party", -- from Brasse
		["B72D63A6C1001C120"] = "Dwarf Party", -- from Brasse
		["B72D63A6A1000BA82"] = "Dwarf Party", -- from Brasse
		["B72D63A6910003733"] = "Dwarf Party", -- from Brasse
		["B72D63A6D1002446F"] = "Dwarf Party", -- from Brasse
	}
	self.PlanarList = {
		["B7A3E8D86DEF1F32F"] = "Prismatic Eyes", -- from Carnival Earring
		["B15F2FB0F4AAC5DD5"] = "Prismatic Eyes", -- from Carnival Earring
		["B19C595C332C5A56F"] = "Prismatic Eyes", -- from Carnival Earring
		["BFBC9A23D1576EB52"] = "Prismatic Eyes", -- from Carnival Earring
	}
	function self.Remove(BuffID, CasterID)
		if KBM.Options.Sheep.Protect then
			local Name
			if CasterID then
				if LibSUnit.Lookup.UID[CasterID] then
					Name = LibSUnit.Lookup.UID[CasterID].Name
				end
			end
			if Name then
				print("Auto removing Polymorph effects cast by "..Name.."!")
			else
				print("Auto removing Polymorph effects!")
			end
			Command.Buff.Cancel(BuffID)
		end
	end
	
	function self.RemovePlanar(BuffID, CasterID)
		if KBM.Options.Planar.PlanarProtect then
			local Name
			if CasterID then
				if LibSUnit.Lookup.UID[CasterID] then
					Name = LibSUnit.Lookup.UID[CasterID].Name
				end
			end
			print("Auto removing Planar effects!")
			Command.Buff.Cancel(BuffID)
		end
	end
	
	for ID, bool in pairs(self.SheepList) do
		local Trigger = KBM.Trigger:Create(ID, "playerBuffID", nil, nil, "CustomBuffRemove")
		Trigger:AddPhase(self.Remove)
	end
	
	for ID, bool in pairs(self.PlanarList) do
		local Trigger = KBM.Trigger:Create(ID, "playerBuffID", nil, nil, "CustomBuffRemove")
		Trigger:AddPhase(self.RemovePlanar)
	end
end

function KBM.InitEvents()
	-- Addon API Events
	-- Chat
	Command.Event.Attach(Event.Chat.Notify, KBM.Notify, "Notify Event")
	Command.Event.Attach(Event.Chat.Npc, KBM.NPCChat, "NPC Chat")
	-- Units
	-- System
	Command.Event.Attach(Event.System.Update.Begin, function () KBM:Timer() end, "System Update Begin")
	--Command.Event.Attach(Event.System.Update.End, function () KBM:AuxTimer() end, "System Update End")
	Command.Event.Attach(Event.System.Secure.Enter, KBM.SecureEnter, "Secure Enter")
	Command.Event.Attach(Event.System.Secure.Leave, KBM.SecureLeave, "Secure Leave")
	
	-- Safe's Buff Library Events
	Command.Event.Attach(Event.SafesBuffLib.Buff.Add, function (...) KBM:BuffAdd(...) end, "Buff Monitor (Add)")
	Command.Event.Attach(Event.SafesBuffLib.Buff.Change, function (...) KBM:BuffAdd(...) end, "Buff Monitor (Change)")
	Command.Event.Attach(Event.SafesBuffLib.Buff.Remove, function (...) KBM:BuffRemove(...) end, "Buff Monitor (Remove)")
	
	-- Safe's Unit Library Events
	Command.Event.Attach(Event.SafesUnitLib.Unit.New.Full, KBM.Unit.Available, "Unit Available")
	Command.Event.Attach(Event.SafesUnitLib.Unit.Full, KBM.Unit.Available, "Unit Available")
	Command.Event.Attach(Event.SafesUnitLib.Unit.Removed, KBM.Unit.Removed, "Unit Removed")
	Command.Event.Attach(Event.SafesUnitLib.Unit.Detail.Combat, KBM.CombatEnter, "Unit Combat Enter")
	Command.Event.Attach(Event.SafesUnitLib.Raid.Combat.Enter, KBM.Raid.CombatEnter, "Raid Combat Enter")
	Command.Event.Attach(Event.SafesUnitLib.Raid.Combat.Leave, KBM.Raid.CombatLeave, "Raid Combat Leave")
	--Command.Event.Attach(Event.SafesUnitLib.Raid.Wipe, 
	Command.Event.Attach(Event.SafesUnitLib.Unit.Detail.Percent, KBM.Unit.Percent, "Unit Percent Change")
	Command.Event.Attach(Event.SafesUnitLib.Unit.Mark, KBM.Unit.Mark, "Unit Mark Change")
	Command.Event.Attach(Event.SafesUnitLib.Combat.Damage, KBM.Damage, "Unit Damage")
	Command.Event.Attach(Event.SafesUnitLib.Combat.Heal, KBM.Heal, "Unit Heal")
	Command.Event.Attach(Event.SafesUnitLib.Combat.Death, KBM.Unit.Death, "Unit Death")
	
	-- Slash Commands
	Command.Event.Attach(Command.Slash.Register("kbmreset"), function(handle) KBM_Reset(true) end, "KBM Reset")
	Command.Event.Attach(Command.Slash.Register("kbmhelp"), KBM_Help, "KBM Help")
	Command.Event.Attach(Command.Slash.Register("kbmversion"), function(handle, ...) KBM_Version(...) end, "KBM Version Info")
	Command.Event.Attach(Command.Slash.Register("kbmoptions"), KBM_Options, "KBM Open Options")
	Command.Event.Attach(Command.Slash.Register("kbmdebug"), KBM_Debug, "KBM Debug on/off")
	Command.Event.Attach(Command.Slash.Register("kbmlocale"), KBMLM.FindMissing, "KBM Locale Finder")
	Command.Event.Attach(Command.Slash.Register("kbmcpu"), function() KBM.CPU:Toggle() end, "KBM CPU Monitor")
	Command.Event.Attach(Command.Slash.Register("kbmbuffs"), KBM.SlashInspectBuffs, "Slash Command for Buff Listing")
	Command.Event.Attach(Command.Slash.Register("kbmon"), function(handle) KBM.StateSwitch(true) end, "KBM On")
	Command.Event.Attach(Command.Slash.Register("kbmoff"), function(handle) KBM.StateSwitch(false) end, "KBM Off")
	Command.Event.Attach(Command.Slash.Register("kbmdefault"), KBM.SlashDefault, "Default settings handler")
	Command.Event.Attach(Command.Slash.Register("kbmunitcache"), KBM.SlashUnitCache, "Unit Data mining output")
	Command.Event.Attach(Command.Slash.Register("kbmzone"), KBM.SlashZone, "KBM Zone Info")
end

function KBM.WaitReady()
	KBM.Player.UnitObj = LibSUnit.Player
	KBM.Player.ID = "KBM_Player"
	KBM.Player.Name = LibSUnit.Player.Name
	KBM.Player.UnitID = LibSUnit.Player.UnitID
	KBM_Start()
	KBM.InitEvents()
	KBM.Event.System.Start(self)
	
	KBM.Castbar:LoadPlayerBars()
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
			if KBM.CPU.CreateTrack then
				if KBM.PlugIn.List["KBMMarkIt"] then
					if PlugIn.ID == "KBMMarkIt" then
						KBM.CPU:CreateTrack("KBMMarkIt", "KBM: Mark-It", 0.9, 0.5, 0.35)
					end
				end
				if KBM.PlugIn.List["KBMAddWatch"] then
					if PlugIn.ID == "KBMAddWatch" then
						KBM.CPU:CreateTrack("KBMAddWatch", "KBM: AddWatch", 0.9, 0.5, 0.35)
					end
				end
			end
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

function KBM.InitKBM(handle, ModID)	
	if ModID == "KBMReadyCheck" then
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
		KBM.CPU:Toggle(true)
		
		KBM.ResMaster:Start()
		KBM.Player.Rezes = {
			List = {},
			Resume = {},
			Count = 0,
		}
		KBM.PlayerControl:Start()	
		for i, File in pairs(KBM.Marks.File) do
			KBM.Marks.Icon[i] = UI.CreateFrame("Texture", File, KBM.Context)
			KBM.Marks.Icon[i]:SetTexture("Rift", File)
			KBM.Marks.Icon[i]:SetVisible(false)
		end
		
		-- Finalize Menu's
		KBM.InitMenus()
			
		-- Start
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

Command.Event.Attach(Event.Addon.SavedVariables.Load.Begin, KBM_DefineVars, "KBM_Main_Load_Begin")
Command.Event.Attach(Event.Addon.SavedVariables.Load.End, KBM_LoadVars, "KBM_Main_Load_End")
Command.Event.Attach(Event.Addon.SavedVariables.Save.Begin, KBM_SaveVars, "KBM_Main_Save_Begin")
Command.Event.Attach(Event.Addon.Load.End, KBM.InitKBM, "KBM Begin Init Sequence")
Command.Event.Attach(Event.SafesUnitLib.System.Start, KBM.WaitReady, "KBM Sync Wait")

local AddonDetails = Inspect.Addon.Detail("KBMTextureHandler")
KBM.LoadTexture = AddonDetails.data.LoadTexture
