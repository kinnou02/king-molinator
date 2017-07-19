-- King Boss Mods Ready Check Module
-- Written By Paul Snart
-- Copyright 2012
--

local AddonData = ...
local KBMRC = AddonData.data
local LibSBuff = Inspect.Addon.Detail("SafesBuffLib").data
local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local PI = KBMRC

local KBMAddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = KBMAddonData.data
if not KBM.BossMod then
	return
end

local LSUIni = Inspect.Addon.Detail("SafesUnitLib")
local LibSUnit = LSUIni.data

KBM.Ready = PI

PI.Enabled = true
PI.Ready = {
	Replied = 0,
	Yes = 0,
	No = 0, 
	State = false,
	Units = {},
}
PI.Displayed = true
PI.GUI = {}
PI.Button = {}
PI.Context = UI.CreateContext("KBMReadyCheck")
PI.DetailUpdates = {}
PI.Buffs = {}
PI.Queue = {
	List = {},
	Adding = {},
	Removing = {},
	Buffer = {},
	Total = 0,
}
function PI.Queue:Add(UnitID, qType, Specifier)
	local qObject = {
		UnitID = UnitID,
		Type = qType,
	}
	table.insert(self.List, qObject)
end
PI.Icons = {
	Planar = {
		--Type = "Rift",
		--File = "titan_shards_d.dds",
		Type = "KingMolinator",
		File = "Media/Planar_Icon.png",
	},
	Vitality = {
		Type = "KingMolinator",
		File = "Media/KBM_Death.png",
	},
	KBM = {
		Type = "KingMolinator",
		File = "Media/KBMLogo_Icon.png",
	},
	Stone = {
		Type = "KingMolinator",
		File = "Media/Weap_Stones.png",
	},
	Potion = {
		Type = "KingMolinator",
		File = "Media/RC_PotionIcon.png",
	},
	PP = {
		Type = "Rift",
		File = "Data/\\UI\\ability_icons\\resolve1.dds",
	},
	Food = {
		Type = "KingMolinator",
		File = "Media/RC_FoodIcon.png",
	},
	Insoles = {
		Type = "Rift",
		File = "Data/\\UI\\item_icons\\insoles_04_b.dds",
	},
	-- Armor = {
		-- Type = "KingMolinator",
		-- File = "Media/RC_ArmorIcon.png",
	-- },
}

PI.Settings = {
	Enabled = true,
	Unlocked = true,
	Combat = true,
	Hidden = true,
	Solo = true,
	Flash = true,
	x = false,
	y = false,
	wScale = 1,
	hScale = 1,
	Scale = true,
	fScale = 1,
	Alpha = 1,
	Tracking = {},
	Button = {
		x = false,
		y = false,
		Unlocked = true,
		Visible = true,
	},
	Columns = {
		Planar = {
			Enabled = true,
			wScale = 1,
		},
		Stone = {
			Enabled = true,
			Flash = 600,
			wScale = 1,
		},
		Food = {
			Enabled = true,
			Flash = 600,
			wScale = 1,
		},
		Potion = {
			Enabled = true,
			Flash = 600,
			wScale = 1,
		},
		Vitality = {
			Enabled = true,
			wScale = 1,
		},
		PP = {
			Enabled = true,
			Flash = 900,
			wScale = 1,
		},
		Insoles = {
			Enabled = true,
			Flash = 900,
			wScale = 1,
		},
		KBM = {
			Enabled = true,
			wScale = 1,
		},
	},
	Rows = {
		hScale = 1,
	},
}

PI.Constants = {
	w = 150,
	h = 32,
	FontSize = 14,
	Lookup = {
		Full = {},
	},
	Callings = {
		warrior = true,
		mage = true,
		rogue = true,
		cleric = true,
		primalist = true,
	},
	Role = {
		tank = true,
		support = true,
		heal = true,
		dps = true,
	},
	Columns = {
		Planar = {
			w = 40,
		},
		Stone = {
			w = 36,
			Icons = true,
			List = {
                -- PoA --
                ["r4FF9D622653C3AB5"] = { -- Xarthian Witchstone
                    Grade = "High",
                    Level = 70,
                    Callings = {
                        cleric = true,
                        mage = true,
                    },
                },
                ["r61E2FFAD62EC73A6"] = { -- Bolidium Weaponstone
                    Grade = "High",
                    Level = 70,
                    Callings = {
                        warrior = true,
                        primalist = true,
                    },
                },
                ["rFA65F5184E42C822"] = { -- Atramentium Whetstone
                    Grade = "High",
                    Level = 70,
                    Callings = {
                        warrior = true,
                        rogue = true,
                    },
                },
                ["r143A1D7A79A201D6"] = { -- Faetouched Whetstone
                    Grade = "High",
                    Level = 70,
                    Callings = {
                        cleric = true,
                        mage = true,
                    },
                },
                ["r70B0A3843EC153B8"] = { -- Atramentium Oilstone
                    Grade = "High",
                    Level = 70,
                    Callings = {
                        warrior = true,
                        primalist = true,
                    },
                },

				--//////////////////////--
				-- NT High Grade Stones --
				--//////////////////////--
				["r0C2445386997ECE6"] = { -- Coral Whetstone
					Grade = "High",
					Level = 65,
					Callings = {
						rogue = true,
						warrior = true,
					},
				},
				["r762BD1423747FA3F"] = { -- Coral Oilstone
					Grade = "High",
					Level = 65,
					Callings = {
						warrior = true,
						primalist = true,
					},
				},
				["r54A72A7D7486A939"] = { -- Pelagic Powerstone
					Grade = "High",
					Level = 65,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
				--//////////////////////--
				-- NT PA Stones --
				--//////////////////////--
				["r6F97576F54C8E782"] = { -- Storm Emblem
					Grade = "Medium",
					Level = 65,
					Callings = {
						warrior = true,
						primalist = true,
					},
				},
				["r6B788FB70D2FEA29"] = { -- Primal Edge
					Grade = "Medium",
					Level = 65,
					Callings = {
						warrior = true,
						primalist = true,
					},
				},
				["r082D24455D03DDD8"] = { -- Lightning Emblem
					Grade = "Medium",
					Level = 65,
					Callings = {
						rogue = true,
						primalist = true,
					},
				},
				["r1B3A3BDB5E50AAC7"] = { -- Serrated Edge
					Grade = "Medium",
					Level = 65,
					Callings = {
						rogue = true,
						warrior = true,
						primalist = true,
					},
				},
				["r7273BFB75132FBD6"] = { -- Wind Emblem
					Grade = "Medium",
					Level = 65,
					Callings = {
						cleric = true,
					},
				},
				["r12FE7D95752512F0"] = { -- Thunder Emblem
					Grade = "Medium",
					Level = 65,
					Callings = {
						mage = true,
					},
				},
				["r3BDE026769180CFF"] = { -- Flaring Emblem
					Grade = "Medium",
					Level = 65,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
				--//////////////////////--
				-- SL High Grade Stones --
				--//////////////////////--
				["r7B43F61C22CFA573"] = { -- Coruscating Powerstone 
					Grade = "High",
					Level = 60,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
				["r13849ADC07F98B60"] = { -- Exceptional Whetstone
					Grade = "High",
					Level = 60,
					Callings = {
						rogue = true,
						warrior = true,
						primalist = true,
					},
				},
				["r4C1AD372299AF58E"] = { -- Exceptional Oilstone
					Grade = "High",
					Level = 60,
					Callings = {
						warrior = true,
						primalist = true,
					},
				},
				--////////////////////////--
				-- SL Medium Grade Stones --
				--////////////////////////--
				["r3A5D56170B3171F5"] = { -- Luminescent Powerstone
					Grade = "Medium",
					Level = 60,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
				["r36E23CF74112D284"] = { -- Vampiric Essence
					Grade = "Medium",
					Level = 60,
					Callings = {
						cleric = true,
						warrior = true,
						rogue = true,
						primalist = true,
					},
					Role = {
						tank = true,
					},
				},
				["r5812508956871CF3"] = { -- Remarkable Whetstone
					Grade = "Medium",
					Level = 60,
					Callings = {
						rogue = true,
						warrior = true,
						primalist = true,
					},
				},
                ["r5E26E8C025B2C3BB"] = { -- Remarkable Oilstone
                    Grade = "Medium",
                    Level = 60,
                    Callings = {
                        rogue = true,
                        warrior = true,
						primalist = true,
                    },
                },
				--/////////////////////--
				-- SL Low Grade Stones --
				--/////////////////////--
				["r3C3161FA59C6ECF3"] = { -- Wind Sigil
					Grade = "Low",
					Level = 60,
					Callings = {
						cleric = true,
					},
				},	
				["r712EF6F7297AB9ED"] = { -- Storm Sigil
					Grade = "Low",
					Level = 60,
					Callings = {
						warrior = true,
						primalist = true,
					},
				},
				["r61C14C434DDF615D"] = { -- Flaring Sigil
					Grade = "Low",
					Level = 60,
					Callings = {
						mage = true,
						cleric = true,
					},
				},
				["r0B48C387131E79A8"] = { -- Lightning Sigil
					Grade = "Low",
					Level = 60,
					Callings = {
						rogue = true,
						primalist = true,
					},
				},
				["rFBF770FC7EEEB915"] = { -- Honed Edge
					Grade = "Low",
					Level = 60,
					Callings = {
						rogue = true,
						primalist = true,
					},
				},
				
				["r2FF8E88943EBC5AA"] = { -- Planar Edge
					Grade = "Low",
					Level = 60,
					Callings = {
						warrior = true,
						primalist = true,
					},
				},
				--///////////////////////////--
				-- Classic High Grade Stones --
				--///////////////////////////--
				["r624A5FA52756B277"] = { -- Burning Powerstone
					Grade = "High",
					Level = 50,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
				["r440B155B5AF22AF8"] = { -- Ancient Burning Powerstone
					Grade = "High",
					Level = 50,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
				["r70D23CD31E59DD77"] = { -- Flaring Glyph
					Grade = "Medium",
					Level = 50,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
				["r55A04A4D500636BF"] = { -- Exquisite Oilstone
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["r139805221FB5E557"] = { -- Ancient Exquisite Oilstone
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["r57585B8C3DB1BEF1"] = { -- Ancient Exquisite Whetstone
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["r717189072932CD29"] = { -- Exquisite Whetstone
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["r669DCD997490AEF8"] = { -- Wind Glyph
					Grade = "Medium",
					Level = 50,
					Callings = {
						cleric = true,
						mage = true,
					},
					Role = {
						tank = true,
					},
				},
				["r68FE8ED5065752C2"] = { -- Lightning Glyph
					Grade = "Medium",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["r1F97418336CC3C87"] = { -- Razor Edge
					Grade = "Medium",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["r27FEA7C466DC68EE"] = { -- Keen Edge
					Grade = "Medium",
					Level = 50,
					Callings = {
						warrior = true,
					},
				},
				["r4552DA1F7B7A9D42"] = { -- Storm Glyph
					Grade = "Medium",
					Level = 50,
					Callings = {
						warrior = true,
					},
				},
				["r7521BA00400F6038"] = { -- Fine Whetstone
					Grade = "Medium",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},				
			},
		},
		Food = {
			w = 36,
			Icons = true,
			List = {
				-- PoA --
				["B40C3D8E33D686C51"] = { -- Gedlo Curry Pot (AP)
					Grade = "High",
					Level = 70,
					Callings = {
						warrior = true,
						rogue = true,
						primalist = true,
					},
				},
				["B40C3D8E1646C6DD1"] = { -- Gedlo Curry Pot (SP)
					Grade = "High",
					Level = 70,
					Callings = {
						mage = true,
						cleric = true,
					},
				},
				--////////////////////--
				-- NT High Grade Food --
				--////////////////////--
				["B3CA755E06191712E"] = { -- Feast of the Rhenke (AP)
					Grade = "High",
					Level = 65,
					Callings = {
						warrior = true,
						rogue = true,
						primalist = true,
					},
				},
				["B3CA755DE889572AE"] = { -- Feast of the Rhenke (SP)
					Grade = "High",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
					},
				},
				--////////////////////--
				-- NT Medium Grade Food --
				--////////////////////--
				["B206F8F2F21AE709B"] = { -- Feast of the Ghar (AP)
					Grade = "High",
					Level = 65,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["B206F8F2D48B2721B"] = { -- Feast of the Ghar (SP)
					Grade = "High",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
					},
				},
				["B48C551A2ECED7590"] = { -- Feast of Vengeance
					Grade = "High",
					Level = 57,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
					},
				},
				--//////////////--
				-- NT Tank Food --
				--//////////////--
				["BFA92259849A70D12"] = { -- Sea Lover's Plate
					Grade = "High",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
						primalist = true,
					},
				},
				["B784710B0CBDBC984"] = { -- Grilled Fish Medley
					Grade = "High",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
						primalist = true,
					},
				},
				["B6354CFD531F7FF39"] = { -- Beast Belly
					Grade = "High",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
						primalist = true,
					},
				},
				["B2610A5816845B475"] = { -- Atragarian Remora
					Grade = "Medium",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
					},
				},
				["B552052821F956B42"] = { -- Sea Pea Porridge
					Grade = "Medium",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
					},
				},
				["B7A9114A93DA9099D"] = { -- Zirthan Curry
					Grade = "Medium",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
					},
				},
				--//////////////--
				-- SL Tank Food --
				--//////////////--
                ["BFD2D651A8E22EF55"] = { -- Kraken Hors D'oeuvres
                    Grade = "High",
                    Level = 60,
                    Callings = {
                        warrior = true,
                        cleric = true,
                    },
                    Role = {
                        tank = true,
                    },
                },				
                ["BFA59044E4831FA78"] = { -- Stuffed Mushrooms
                    Grade = "High",
                    Level = 60,
                    Callings = {
                        rogue = true,
                    },
                    Role = {
                        tank = true,
                    },
                },
				--////////////////////--
				-- SL High Grade Food --
				--////////////////////--
				["B0A0A47828BC4BC5E"] = { -- Feast of Domination (SP)
					Grade = "High",
					Level = 60,
					Callings = {
						mage = true,
						cleric = true,
					},
				},
				["B0A0A478464C0BADE"] = { -- Feast of Domination (AP)
					Grade = "High",
					Level = 60,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
                ["BFEEAAD0F359C9FE3"] = { -- Sharpfin Chops
                    Grade = "High",
                    Level = 60,
                    Callings = {
                        mage = true,
                        cleric = true,
                    },
                },
                ["BFCA460CF2B03DDC8"] = { -- Prime Flycatcher
                    Grade = "High",
                    Level = 60,
                    Callings = {
                        warrior = true,
                        rogue = true,
                    },
                },
				--//////////////////////--
				-- SL Medium Grade Food --
				--//////////////////////--
				["B3460FDF62FD0E525"] = { -- Fish Hot Pot
					Grade = "Medium",
					Level = 60,
					Callings = {
						mage = true,
						cleric = true,
					},
				},
                ["BFF5021B4DB472F50"] = { -- Octopus Broth
                    Grade = "Medium",
                    Level = 60,
                    Callings = {
                        warrior = true,
                        rogue = true,
                    },
                },
				--///////////////////--
				-- SL Low Grade Food --
				--///////////////////--
				--///////////--
				-- Tank Food --
				--///////////--
				["B5234CE85DD7FE093"] = { -- Kelari Spicey Pome
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
						cleric = true,
					},
					Role = {
						tank = true,
					},
				},
				["B795C4023DAAEA180"] = { -- Dwarven Goulash
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
						cleric = true,
					},
					Role = {
						tank = true,
					},
				},
				["B15CE4940834B42CB"] = { -- Ember Steak
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
					Role = {
						tank = true,
					},
				},
				--/////////////////--
				-- High Grade Food --
				--/////////////////--
				["B174CBFBAEB6DFCAC"] = { -- Feast of Cooperation (SP)
					Grade = "High",
					Level = 50,
					Callings = {
						mage = true,
						cleric = true,
					},
				},
				["B5182E376478EEE9C"] = { -- Feast of Cooperation (AP)
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["B5658FDFA5532AE4E"] = { -- Feast of Efficiency
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["B54B43DE1D3EC1EB3"] = { -- Feast of Aptitude
					Grade = "High",
					Level = 50,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
				--///////////////////--
				-- Medium Grade Food --
				--///////////////////--
				["B3CD06443A7FD7C18"] = { -- Farclan Cherry Cake
					Grade = "Medium",
					Level = 50,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
				["B2BEA306A6F0C0257"] = { -- Farclan Chocolate Cake
					Grade = "Medium",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["B55D71860C42C1B75"] = { -- Kelari Expedition Chocolate Cake
					Grade = "Medium",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["B358E4BC49852C7E6"] = { -- Kelari Expedition Cherry Cake
					Grade = "Medium",
					Level = 50,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
				--////////////////--
				-- Low Grade Food --
				--////////////////--
			},
		},
		Potion = {
			w = 36,
			Icons = true,
			List = {
                -- PoA --
                ["B4D6232986538AB4E"] = { -- Prophetic Fortified Vial
                    Grade = "High",
                    Level = 70,
                    Callings = {
                        mage = true,
                        cleric = true,
                        warrior = true,
                        rogue = true,
                        primalist = true,
                    },
                    Role = {
                        tank = true,
                    },
                },
                ["B4182E55276C4F486"] = { -- Visionary Fortified Vial
                    Grade = "Medium",
                    Level = 70,
                    Callings = {
                        mage = true,
                        cleric = true,
                        warrior = true,
                        rogue = true,
                        primalist = true,
                    },
                    Role = {
                        tank = true,
                    },
                },
                ["B03ABEAB575CC9A8E"] = { -- Prophetic Powersurge Vial
					Grade = "High",
					Level = 70,
					Callings = {
						warrior = true,
						rogue = true,
						primalist = true,
					},
				},
                ["B6A8C5F8110D4EFBB"] = { -- Visionary Powersurge Vial
					Grade = "High",
					Level = 70,
					Callings = {
						warrior = true,
						rogue = true,
						primalist = true,
					},
				},
                ["B599B39124D958B4F"] = { -- Prophetic Brightsurge Vial
					Grade = "High",
					Level = 70,
					Callings = {
						mage = true,
						cleric = true,
					},
				},
                ["B76F46FAB030D4A53"] = { -- Visionary Brightsurge Vial
					Grade = "High",
					Level = 70,
					Callings = {
						mage = true,
						cleric = true,
					},
				},
                ["B3B22BC4B30D87AC2"] = { -- Prophetic Enduring Vial
					Grade = "High",
					Level = 70,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
						primalist = true,
					},
					Role = {
						tank = true,
					},
				},
                ["B4E2589107D7E8E0F"] = { -- Visionary Enduring Vial
					Grade = "High",
					Level = 70,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
						primalist = true,
					},
					Role = {
						tank = true,
					},
				},
				--//////////////////////--
				-- Nightmare Tide High Potions --
				--//////////////////////--
				["B45441A66942B2875"] = { -- Illustrious Powersurge Vial
					Grade = "High",
					Level = 65,
					Callings = {
						warrior = true,
						rogue = true,
						primalist = true,
					},
				},
				["B5FB47C7B1CE019F8"] = { -- Illustrious Brightsurge Vial
					Grade = "High",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
					},
				},
				["B57196D010E66419C"] = { -- Illustrious Enduring Vial
					Grade = "High",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
						primalist = true,
					},
					Role = {
						tank = true,
					},
				},
				["B391D5227E51E03F4"] = { -- Illustrious Fortified Vial
					Grade = "High",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
						primalist = true,
					},
					Role = {
						tank = true,
					},
				},
				--//////////////////////--
				-- Nightmare Tide Low Potions --
				--//////////////////////--
				["B4E57169B18162520"] = { -- Phenomenal Powersurge Vial
					Grade = "Medium",
					Level = 65,
					Callings = {
						warrior = true,
						rogue = true,
						primalist = true,
					},
				},
				["B2A1357781A34EE07"] = { -- Phenomenal Brightsurge Vial
					Grade = "Medium",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
					},
				},
				["B00FB053AEBE90DDB"] = { -- Phenomenal Enduring Vial
					Grade = "Medium",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
						primalist = true,
					},
					Role = {
						tank = true,
					},
				},
				["B406B67171AED5182"] = { -- Phenomenal Fortified Vial
					Grade = "Medium",
					Level = 65,
					Callings = {
						mage = true,
						cleric = true,
						warrior = true,
						rogue = true,
						primalist = true,
					},
					Role = {
						tank = true,
					},
				},
				--//////////////////////--
				-- Storm Legion Potions --
				--//////////////////////--
				["B130F5F68F80B197B"] = { -- Prime Brightsurge Vial
					Grade = "High",
					Level = 60,
					Callings = {
						mage = true,
						cleric = true,
					},
				},
				["B1800F2A93F1BFFB4"] = { -- Prime Powersurge Vial
					Grade = "High",
					Level = 60,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["B79B52B426ED15E2B"] = { -- Prime Enduring Vial
					Grade = "High",
					Level = 60,
					Callings = {
						rogue = true,
						warrior = true,
						cleric = true,
					},
					Role = {
						tank = true,
					},
				},
				["B4893968F2F9E67E8"] = { -- Prime Fortified Vial
					Grade = "High",
					Level = 60,
					Callings = {
						rogue = true,
						warrior = true,
						cleric = true,
					},
					Role = {
						tank = true,
					},
				},
				["B7BA3D5176EAB3544"] = { -- Stellar Prismatic Wellspring
					Grade = "Medium",
					Level = 60,
					Callings = {
						all = true,
					},
				},
				["BFF3177D56B3A82D6"] = { -- Stellar Powersurge Vial
					Grade = "Medium",
					Level = 60,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["BFBD8A9BDCF3270E6"] = { -- Stellar Brightsurge Vial
					Grade = "Medium",
					Level = 60,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
				["BFAF68C1FC68ED75A"] = { -- Stellar Enduring Vial
					Grade = "Medium",
					Level = 60,
					Callings = {
						rogue = true,
						warrior = true,
						cleric = true,
					},
					Role = {
						tank = true,
					},
				},
				["BFE810316D26BAE95"] = { -- Stellar Fortified Vial
					Grade = "Medium",
					Level = 60,
					Callings = {
						rogue = true,
						warrior = true,
						cleric = true,
					},
					Role = {
						tank = true,
					},
				},
				["BFAE680B5BBA2DB8E"] = { -- Excellent Powersurge Vial
                    Grade = "Low",
                    Level = 60,
                    Callings = {
                        warrior = true,
                        rogue = true,
                    },
                },
                ["BFA86D7A4886FCED5"] = { -- Excellent Brightsurge Vial
                    Grade = "Low",
                    Level = 60,
                    Callings = {
                        cleric = true,
                        mage = true,
                    },
                },
                ["BFB84FF67D7824324"] = { -- Excellent Enduring Vial
                    Grade = "Low",
                    Level = 60,
                    Callings = {
                        rogue = true,
                        warrior = true,
                        cleric = true,
                    },
                    Role = {
                        tank = true,
                    },
                },
				["BFDB9E8A2B27127FD"] = { -- Excellent Fortified Vial
					Grade = "Low",
					Level = 60,
					Callings = {
						rogue = true,
						warrior = true,
						cleric = true,
					},
					Role = {
						tank = true,
					},
				},
				["BFC4556DD58E5F85C"] = { -- Excellent Strength Serum
					Grade = "Very Low",
					Level = 60,
					Callings = {
						warrior = true,
					},
				},
				["BFCCE75C1F3417572"] = { -- Excellent Dexterity Serum
					Grade = "Very Low",
					Level = 60,
					Callings = {
						rogue = true,
					},
				},
				["BFD380B720A80A6D6"] = { -- Excellent Wisdom Serum
					Grade = "Very Low",
					Level = 60,
					Callings = {
						cleric = true,
					},
				},
                ["BFE567F1435D0CC73"] = { -- Excellent Intelligence Serum
					Grade = "Very Low",
					Level = 60,
					Callings = {
						mage = true,
					},
				},
				--/////////////////--
				-- Classic Potions --
				--/////////////////--				
				["B1C51B12CC359AA77"] = { -- Herioc Brightsurge Vial
					Grade = "High",
					Level = 50,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
				["B798FC1E26E38815F"] = { -- Heroic Powersurge Vial
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["B175939E807F0707F"] = { -- Herioc Enduring Vial
					Grade = "High",
					Level = 50,
					Callings = {
						all = true,
					},
				},
				["B3028494ABDF72791"] = { -- Herioc Fortified Vial
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
						cleric = true,
					},
					Role = {
						tank = true,
					},
				},
				["B72807CC529E275FD"] = { -- Mighty Enduring Vial
					Grade = "Medium",
					Level = 50,
					Callings = {
						all = true,
					},
				},
				["B26300F4BDE63286A"] = { -- Mighty Fortified Vial
					Grade = "Medium",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
						cleric = true,
					},
					Role = {
						tank = true,
					},
				},				
				["B2099ACE7DB4C2342"] = { -- Vial of Earth Resistance
					Grade = "High",
					Level = 50,
					Callings = {
						all = true,
					},
				},
				["B1928DC9D0D875B36"] = { -- Vial of Water Resistance
					Grade = "High",
					Level = 50,
					Callings = {
						all = true,
					},
				},
				["B4D75A15E32976412"] = { -- Vial of Fire Resistance
					Grade = "High",
					Level = 50,
					Callings = {
						all = true,
					},
				},
				["B0B554EAC804EE17F"] = { -- Vial of Death Resistance
					Grade = "High",
					Level = 50,
					Callings = {
						all = true,
					},
				},
				["B769F65AA45A72C2B"] = { -- Vial of Air Resistance
					Grade = "High",
					Level = 50,
					Callings = {
						all = true,
					},
				},
				["B5F5153125385DC4E"] = { -- Vial of Life Resistance
					Grade = "High",
					Level = 50,
					Callings = {
						all = true,
					},
				},
				["B0B2B52E09FA082DE"] = { -- Mighty Powersurge Vial
					Grade = "Medium",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
				["B1EE0CFCC0280BE3A"] = { -- Mighty Brightsurge Vial
					Grade = "Medium",
					Level = 50,
					Callings = {
						cleric = true,
						mage = true,
					},
				},
			},
		},
		Insoles = {
			w = 30,
			Icons = true,
			List = {
        -- PoA --
        ["r4DEE42255D06816A"] = { -- Tuath'de Insoles
					Grade = "High",
					Level = 70,
					Callings = {
						all = true,
					},
				},
				--////////////////////////--
				-- Nightmare Tide Insoles --
				--////////////////////////--
				["r12AC495C6CA32B19"] = { -- Spongy Insoles
					Grade = "High",
					Level = 65,
					Callings = {
						all = true,
					},
				},
				["r15E7054C3C42C368"] = { -- Warlord's Insoles
					Grade = "High",
					Level = 65,
					Callings = {
						all = true,
					},
				},
				["rFA1390E570C6AFDD"] = { -- Mercenary's Insoles
					Grade = "High",
					Level = 65,
					Callings = {
						all = true,
					},
				},
				--///////////////////////--
				-- SL High Grade Insoles --
				--///////////////////////--
				["r72B2559A7E58CA1B"] = { -- Exceptional Insoles
					Grade = "High",
					Level = 60,
					Callings = {
						all = true,
					},
				},
				--////////////////////////--
				-- SL Medium Grade Insoles --
				--////////////////////////--
				["r3BD9C00A2128287F"] = { -- Comfortable Insoles
					Grade = "Medium",
					Level = 60,
					Callings = {
						all = true,
					},
				},
				["r0BBA6691632B040C"] = { -- Performance Insoles
					Grade = "High",
					Level = 50,
					Callings = {
						all = true,
					},
				},
				["r4003D6A12E212CFF"] = { -- Cushioned Insoles
					Grade = "High",
					Level = 50,
					Callings = {
						all = true,
					},
				},
			},
		},
		PP = {
			w = 30,
			Icons = true,
			List = {
				["B724E352BBAA3E897"] = { -- Planar Protection
					Grade = "High",
					Level = 50,
					Callings = {
						all = true,
					},
				},
			},
		},
		Other = {
			Icons = true,
			List = {
				["r4057380E26CC6760"] = { -- Thick Armor Plating
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
						cleric = true,
					},
					Role = {
						tank = true,
					},
				},
				["r4C9A818733580794"] = { -- Poisonous Coating
					Grade = "High",
					Level = 50,
					Callings = {
						warrior = true,
						rogue = true,
					},
				},
			},
		},
		Vitality = {
			w = 38,
		},
		KBM = {
			w = 102,
		},
	},
	Rows = {
		h = 26,
		FontSize = 14,
	},
}
-- Generate Lookup
for ID, Obj in pairs(PI.Constants.Columns) do
	if Obj.List then
		for buffID, buffObj in pairs(Obj.List) do
			PI.Constants.Lookup.Full[buffID] = {
				Object = PI.Constants.Columns[ID][buffID],
				Column = ID,
			}
			PI.Settings.Tracking[buffID] = true
		end
	end
end

-- Dictionary in Global Locale file.

function PI.Button:Init()
	self.Texture = UI.CreateFrame("Texture", "Ready Check Button Texture", KBM.Context)
	KBM.LoadTexture(self.Texture, "KingMolinator", "Media/Check_Button.png")
	self.Texture:SetWidth(KBM.Constant.Button.s)
	self.Texture:SetHeight(KBM.Button.Texture:GetWidth())
	self.Highlight = UI.CreateFrame("Texture", "Ready Check Button Highlight", KBM.Context)
	KBM.LoadTexture(self.Highlight, "KingMolinator", "Media/New_Options_Button_Over.png")
	self.Highlight:SetPoint("TOPLEFT", self.Texture, "TOPLEFT")
	self.Highlight:SetPoint("BOTTOMRIGHT", self.Texture, "BOTTOMRIGHT")
	self.Highlight:SetVisible(false)
	
	function self:Defaults()
		PI.Settings.Button.x = false
		PI.Settings.Button.y = false
		if not PI.Settings.Button.Unlocked then
			PI.Settings.Button.Unlocked = true
			PI.Button:SetUnlocked(true)
		end
		PI.Settings.Button.Visible = true
		self:ApplySettings()
	end

	function self:ApplySettings()
		self.Texture:ClearPoint("CENTER")
		self.Texture:ClearPoint("TOPLEFT")
		if not PI.Settings.Button.x then
			self.Texture:SetPoint("CENTER", UIParent, "CENTER")
		else
			self.Texture:SetPoint("TOPLEFT", UIParent, "TOPLEFT", PI.Settings.Button.x, PI.Settings.Button.y)
		end
		self.Texture:SetLayer(5)
		self.Highlight:SetLayer(6)
		if PI.Enabled then
			self.Texture:SetVisible(PI.Settings.Button.Visible)
		else
			self.Texture:SetVisible(false)
		end
	end
	
	function self:UpdateMove(uType)
		if uType == "end" then
			if not PI.Settings.Button then
				PI.Settings.Button = {}
			end
			PI.Settings.Button.x = self.Texture:GetLeft()
			PI.Settings.Button.y = self.Texture:GetTop()
		end	
	end
	
	function self:MouseInHandler()
		PI.Button.Highlight:SetVisible(true)
	end
	
	function self:MouseOutHandler()
		KBM.LoadTexture(PI.Button.Texture, "KingMolinator", "Media/Check_Button.png")
		PI.Button.Highlight:SetVisible(false)
	end
	
	function self:LeftDownHandler()
		KBM.LoadTexture(PI.Button.Texture, "KingMolinator", "Media/Check_Button_Down.png")
		PI.Button.Highlight:SetVisible(false)
	end
	
	function self:LeftUpHandler()
		KBM.LoadTexture(PI.Button.Texture, "KingMolinator", "Media/Check_Button.png")
		PI.Button.Highlight:SetVisible(true)
	end
	
	function self:LeftClickHandler()
		PI.SlashEnable()
	end
	
	function self:SetUnlocked(bool)
		if bool then
			self.Drag:EventAttach(Event.UI.Input.Mouse.Right.Down, self.Drag.FrameEvents.LeftDownHandler, "Ready Check Right Down Handler")
			self.Drag:EventAttach(Event.UI.Input.Mouse.Right.Up, self.Drag.FrameEvents.LeftUpHandler, "Ready Check Right Up Handler")
		else
			self.Drag:EventDetach(Event.UI.Input.Mouse.Right.Down, self.Drag.FrameEvents.LeftDownHandler)
			self.Drag:EventDetach(Event.UI.Input.Mouse.Right.Up, self.Drag.FrameEvents.LeftUpHandler)		
		end
	end
	
	self.Drag = KBM.AttachDragFrame(self.Texture, function (uType) self:UpdateMove(uType) end, "Button Drag", 7)
	self.Drag:EventDetach(Event.UI.Input.Mouse.Left.Down, self.Drag.FrameEvents.LeftDownHandler)
	self.Drag:EventDetach(Event.UI.Input.Mouse.Left.Up, self.Drag.FrameEvents.LeftUpHandler)
	self.Drag:EventAttach(Event.UI.Input.Mouse.Cursor.In, self.MouseInHandler, "Ready Check Mouse In Handler")
	self.Drag:EventAttach(Event.UI.Input.Mouse.Cursor.Out, self.MouseOutHandler, "Ready Check Mouse Out Handler")
	self.Drag:EventAttach(Event.UI.Input.Mouse.Left.Down, self.LeftDownHandler, "Ready Check Left Down Handler")
	self.Drag:EventAttach(Event.UI.Input.Mouse.Left.Up, self.LeftUpHandler, "Ready Check Left Up Handler")
	self.Drag:EventAttach(Event.UI.Input.Mouse.Left.Click, self.LeftClickHandler, "Ready Check Left Click Handler")
	self.Drag:SetMouseMasking("limited")
	
	self:SetUnlocked(PI.Settings.Button.Unlocked)
	
	self:ApplySettings()	
end

function PI:SwapSettings(bool)

	if bool then
		chKBMRCM_Settings = self.Settings
		self.Settings = chKBMRCM_Settings
	else
		chKBMRCM_Settings = self.Settings
		self.Settings = KBMRCM_Settings
	end

end

function PI.LoadVars(handle, ModID)
	if ModID == AddonData.id then
		if KBM.Options.Character then
			if not chKBMRCM_Settings then
				chKBMRCM_Settings = {}
			else
				KBM.LoadTable(chKBMRCM_Settings, PI.Settings)
			end
		else
			if not KBMRCM_Settings then
				KBMRCM_Settings = {}
			else
				KBM.LoadTable(KBMRCM_Settings, PI.Settings)
			end		
		end
		PI.Enabled = PI.Settings.Enabled
		PI.Button:Init()
		PI.GUI:Init()
	end
end

function PI.SaveVars(handle, ModID)
	if ModID == AddonData.id then
		if KBM.Options.Character then
			chKBMRCM_Settings = PI.Settings
		else
			KBMRCM_Settings = PI.Settings
		end
	end
end

function PI.GUI:ApplySettings()
	if PI.Enabled then
		self.Header:ClearAll()
		self.Cradle:SetVisible(PI.Displayed)
		if not PI.Settings.x then
			self.Header:SetPoint("TOPLEFT", UI.Native.PortraitPlayer, "BOTTOMLEFT")
		else
			self.Header:SetPoint("TOPLEFT", UIParent, "TOPLEFT", PI.Settings.x, PI.Settings.y)
		end
		self.Texture:SetWidth(math.ceil(PI.Constants.w * PI.Settings.wScale))
		if self.Columns.Last then
			self.Header:SetPoint("RIGHT", self.Columns.Last.Header, "RIGHT")
		else
			self.Header:SetPoint("RIGHT", self.Texture, "RIGHT")
		end
		self.Header:SetHeight(math.ceil(PI.Constants.h * PI.Settings.hScale))
		self.HeaderText:SetFontSize(math.ceil(PI.Constants.FontSize * PI.Settings.fScale))
		for ID, Object in pairs(self.Columns.List) do
			local Offset = 0
			if ID ~= "KBM" then
				Offset = 5
			end
			Object.Icon:SetWidth(self.Header:GetHeight() - Offset)
			Object.Icon:SetHeight(self.Header:GetHeight() - Offset)
			Object.Header:SetWidth(math.ceil(PI.Constants.Columns[ID].w * PI.Settings.wScale))
		end
		for Index, Object in ipairs(self.Rows) do
			if Index < 21 then
				Object.Cradle:SetHeight(math.ceil(PI.Constants.Rows.h * PI.Settings.Rows.hScale))
				Object.Ready.Cradle:SetWidth(Object.Ready.Cradle:GetHeight())
				Object.HPBar:SetHeight(math.ceil(Object.Cradle:GetHeight() * 0.7))
				Object.Text:SetFontSize(math.ceil(PI.Constants.Rows.FontSize * PI.Settings.fScale))
				for ID, CObject in pairs(Object.Columns) do
					CObject.Text:SetFontSize(math.ceil(PI.Constants.Rows.FontSize * PI.Settings.fScale))
					CObject.Icon:SetHeight(math.ceil(PI.Constants.Rows.h * PI.Settings.hScale) - 4)
					CObject.Icon:SetWidth(CObject.Icon:GetHeight())
				end
				if PI.Ready.State then
					Object.Text:ClearPoint("LEFT")
					Object.Text:SetPoint("LEFT", Object.Ready.Cradle, "RIGHT", -4, nil)
					Object.Ready.Cradle:SetVisible(true)
				else
					Object.Text:ClearPoint("LEFT")
					Object.Text:SetPoint("LEFT", Object.Cradle, "LEFT", 4, nil)
					Object.Ready.Cradle:SetVisible(false)
				end
				self.Rows:Update(Index)
			end
		end
	else
		self.Cradle:SetVisible(false)
	end
end

function PI.GUI:Init()
	self.Cradle = UI.CreateFrame("Frame", "ReadyCheck Cradle", PI.Context)
	self.Cradle:SetLayer(KBM.Layer.ReadyCheck)
	self.Cradle:SetMouseMasking("limited")
	self.Header = UI.CreateFrame("Frame", "ReadyCheck Header", self.Cradle)
	self.Header:SetLayer(1)
	self.Texture = UI.CreateFrame("Texture", "ReadyCheck Texture", self.Header)
	KBM.LoadTexture(self.Texture, "KingMolinator", "Media/MSpy_Texture.png")
	self.Texture:SetBackgroundColor(0,0.38,0,0.5)
	self.Texture:SetPoint("TOPLEFT", self.Header, "TOPLEFT")
	self.Texture:SetPoint("BOTTOM", self.Header, "BOTTOM")
	self.Texture:SetLayer(1)
	self.HeaderText = LibSGui.ShadowText:Create(self.Header, true)
	self.HeaderText:SetPoint("LEFTCENTER", self.Header, "LEFTCENTER", 5, 1)
	self.HeaderText:SetText(KBM.Language.ReadyCheck.Name[KBM.Lang])
	self.HeaderText:SetLayer(4)
	self.Cradle:SetPoint("TOP", self.Header, "TOP")
	self.Cradle:SetPoint("BOTTOM", self.Header, "BOTTOM")
	self.Cradle:SetPoint("LEFT", self.Header, "LEFT")
	self.Cradle:SetPoint("RIGHT", self.Header, "RIGHT")

	function self:WheelForward()
		PI.Settings.wScale = PI.Settings.wScale + 0.025
		if PI.Settings.wScale > 1.5 then
			PI.Settings.wScale = 1.5
		end
		PI.Settings.hScale = PI.Settings.wScale
		PI.Settings.fScale = PI.Settings.wScale
		PI.Settings.Rows.hScale = PI.Settings.wScale
		PI.GUI:ApplySettings()
	end
	
	function self:WheelBack()
		PI.Settings.wScale = PI.Settings.wScale - 0.025
		if PI.Settings.wScale < 0.5 then
			PI.Settings.wScale = 0.5
		end
		PI.Settings.hScale = PI.Settings.wScale
		PI.Settings.fScale = PI.Settings.wScale
		PI.Settings.Rows.hScale = PI.Settings.wScale
		PI.GUI:ApplySettings()
	end
	
	function self:SetScaling(bool)
		if bool then
			PI.GUI.Cradle:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, PI.GUI.WheelForward, "Ready Check Header Wheel Forward")
			PI.GUI.Cradle:EventAttach(Event.UI.Input.Mouse.Wheel.Back, PI.GUI.WheelBack, "Ready Check Header Wheel Back")
		else
			PI.GUI.Cradle:EventDetach(Event.UI.Input.Mouse.Wheel.Forward, PI.GUI.WheelForward)
			PI.GUI.Cradle:EventDetach(Event.UI.Input.Mouse.Wheel.Back, PI.GUI.WheelBack)
		end
	end
	
	self.Columns = {
		List = {
			Planar = {},
			Vitality = {},
			Stone = {},
			Food = {},
			Potion = {},
			PP = {},
			Insoles = {},
			KBM = {},
		},
		First = nil,
		Last = nil,
		Order = {},
	}
	table.insert(self.Columns.Order, "Planar")
	table.insert(self.Columns.Order, "Stone")
	table.insert(self.Columns.Order, "Food")
	table.insert(self.Columns.Order, "Vitality")
	table.insert(self.Columns.Order, "Potion")
	table.insert(self.Columns.Order, "PP")
	table.insert(self.Columns.Order, "Insoles")
	table.insert(self.Columns.Order, "KBM")
	
	function self.Columns:Create(ID)
		self.List[ID].Header = UI.CreateFrame("Frame", ID.." Header", PI.GUI.Cradle)
		self.List[ID].Header:SetBackgroundColor(0,0,0,0.5)
		self.List[ID].Icon = UI.CreateFrame("Texture", ID.." Icon", self.List[ID].Header)
		self.List[ID].Icon:SetTexture(PI.Icons[ID].Type, PI.Icons[ID].File)
		self.List[ID].Icon:SetPoint("CENTER", self.List[ID].Header, "CENTER")
		self.List[ID].Header:SetPoint("BOTTOM", PI.GUI.Texture, "BOTTOM")
		self.List[ID].Header:SetPoint("TOP", PI.GUI.Texture, "TOP")
		if not self.First then
			self.First = self.List[ID]
			self.Last = self.First
			self.List[ID].Header:SetPoint("LEFT", PI.GUI.Texture, "RIGHT")
		else
			self.List[ID].Header:SetPoint("LEFT", self.Last.Header, "RIGHT")
			self.Last = self.List[ID]
		end
	end
	
	for i, ID in pairs(self.Columns.Order) do
		self.Columns:Create(ID)
	end
	
	self.Rows = {
		Populated = 0,
		Units = {},
		Names = {},
		Specifiers = {},
	}
	
	function self.Rows:Update(Index, Force)
		if Index > 20 then 
			return
		end
		if PI.Enabled or Force then
			if self[Index].Enabled then
				if self[Index].Unit then
					local PF = self[Index].Unit.PercentRaw or 1
					self[Index].HPMask:SetWidth(math.ceil(PI.GUI.Texture:GetWidth() * PF))
					self[Index].MPMask:SetWidth(math.ceil(PI.GUI.Texture:GetWidth()))
				end
			else
				self[Index].HPMask:SetWidth(PI.GUI.Texture:GetWidth())
				self[Index].MPMask:SetWidth(PI.GUI.Texture:GetWidth())
			end
		end
	end
	
	function self.Rows:Update_Name(Index, Force)
		if Index > 20 then 
			return
		end
		if PI.Enabled or Force then
			if self[Index].Enabled then
				if self[Index].Unit then
					local Class = self[Index].Unit.Calling
					if self[Index].Unit.Availability == "partial" then
						if self[Index].Unit.Offline then
							self[Index].Text:SetFontColor(0.75,0.75,0.75,1)
						else
							self[Index].Text:SetFontColor(1,1,1,1)
						end
					else
						if Class == "mage" then
							self[Index].Text:SetFontColor(0.8, 0.55, 1, 1)
						elseif Class == "cleric" then
							self[Index].Text:SetFontColor(0.55, 1, 0.55, 1)
						elseif Class == "warrior" then
							self[Index].Text:SetFontColor(1, 0.55, 0.55, 1)
						elseif Class == "rogue" then
							self[Index].Text:SetFontColor(1, 1, 0.55, 1)
						elseif Class == "primalist" then
							self[Index].Text:SetFontColor(0.23, 0.84, 1, 1)
						else
							self[Index].Text:SetFontColor(1,1,1,1)
						end
					end
					self[Index].Text:SetText(tostring(self[Index].Unit.Name))
				end
			end
		end
	end
	
	function self.Rows:Update_Planar(Index, Force)
		if Index > 20 then 
			return
		end
		if PI.Enabled or Force then
			if self[Index].Enabled then
				if self[Index].Unit then
					local Planar = self[Index].Unit.Planar or "-"
					local PlanarMax = self[Index].Unit.PlanarMax or "-"
					self[Index].Columns.Planar.Text:SetText(Planar.."/"..PlanarMax)
				end
			else
				self[Index].Columns.Planar.Text:SetText("n/a")
			end
		end
	end
	
	function self.Rows:Update_Stone(Index, Force)
		if Index > 20 then
			return
		end
		if PI.Enabled or Force then
			if self[Index].Enabled then
				local Object = self[Index].Columns.Stone.Object
				if Object then
					if Object.icon then
						self[Index].Columns.Stone.Icon:SetTexture("Rift", Object.icon)
						self[Index].Columns.Stone.Icon:SetVisible(true)
						self[Index].Columns.Stone.Icon:SetAlpha(1.0)
						self[Index].Columns.Stone.Text:SetVisible(false)
					else
						self[Index].Columns.Stone.Text:SetFontColor(0.15, 0.9, 0.15)
						self[Index].Columns.Stone.Text:SetText("?")
						self[Index].Columns.Stone.Icon:SetVisible(false)
						self[Index].Columns.Stone.Text:SetVisible(true)
					end
				else
					self[Index].Columns.Stone.Text:SetFontColor(0.9, 0.15, 0.15)
					self[Index].Columns.Stone.Text:SetText("x")
					self[Index].Columns.Stone.Icon:SetVisible(false)
					self[Index].Columns.Stone.Text:SetVisible(true)
				end
			else
				self[Index].Columns.Stone.Text:SetFontColor(0.9, 0.15, 0.15)
				self[Index].Columns.Stone.Text:SetText("x")
				self[Index].Columns.Stone.Icon:SetVisible(false)
				self[Index].Columns.Stone.Text:SetVisible(true)
			end
		end
	end
	PI.Constants.Columns.Stone.Hook = function(...) self.Rows:Update_Stone(...) end
	
	function self.Rows:Update_Food(Index, Force)
		if Index > 20 then 
			return
		end
		if PI.Enabled or Force then
			if self[Index].Enabled then
				local Object = self[Index].Columns.Food.Object
				if Object then
					if Object.icon then
						self[Index].Columns.Food.Icon:SetTexture("Rift", Object.icon)
						self[Index].Columns.Food.Icon:SetVisible(true)
						self[Index].Columns.Food.Icon:SetAlpha(1.0)
						self[Index].Columns.Food.Text:SetVisible(false)
					else
						self[Index].Columns.Food.Text:SetFontColor(0.15, 0.9, 0.15)
						self[Index].Columns.Food.Text:SetText("?")
						self[Index].Columns.Food.Icon:SetVisible(false)
						self[Index].Columns.Food.Text:SetVisible(true)
					end
				else
					self[Index].Columns.Food.Text:SetFontColor(0.9, 0.15, 0.15)
					self[Index].Columns.Food.Text:SetText("x")
					self[Index].Columns.Food.Icon:SetVisible(false)
					self[Index].Columns.Food.Text:SetVisible(true)
				end
			else
				self[Index].Columns.Food.Text:SetFontColor(0.9, 0.15, 0.15)
				self[Index].Columns.Food.Text:SetText("x")
				self[Index].Columns.Food.Icon:SetVisible(false)
				self[Index].Columns.Food.Text:SetVisible(true)
			end
		end
	end
	PI.Constants.Columns.Food.Hook = function(...) self.Rows:Update_Food(...) end
	
	function self.Rows:Update_Potion(Index, Force)
		if Index > 20 then 
			return
		end
		if PI.Enabled or Force then
			if self[Index].Enabled then
				local Object = self[Index].Columns.Potion.Object
				if Object then
					if Object.icon then
						self[Index].Columns.Potion.Icon:SetTexture("Rift", Object.icon)
						self[Index].Columns.Potion.Icon:SetVisible(true)
						self[Index].Columns.Potion.Icon:SetAlpha(1.0)
						self[Index].Columns.Potion.Text:SetVisible(false)
					else
						self[Index].Columns.Potion.Text:SetFontColor(0.15, 0.9, 0.15)
						self[Index].Columns.Potion.Text:SetText("?")
						self[Index].Columns.Potion.Icon:SetVisible(false)
						self[Index].Columns.Potion.Text:SetVisible(true)
					end
				else
					self[Index].Columns.Potion.Text:SetFontColor(0.9, 0.15, 0.15)
					self[Index].Columns.Potion.Text:SetText("x")
					self[Index].Columns.Potion.Icon:SetVisible(false)
					self[Index].Columns.Potion.Text:SetVisible(true)
				end
			else
				self[Index].Columns.Potion.Text:SetFontColor(0.9, 0.15, 0.15)
				self[Index].Columns.Potion.Text:SetText("x")
				self[Index].Columns.Potion.Icon:SetVisible(false)
				self[Index].Columns.Potion.Text:SetVisible(true)
			end
		end
	end
	PI.Constants.Columns.Potion.Hook = function(...) self.Rows:Update_Potion(...) end

	function self.Rows:Update_PP(Index, Force)
		if Index > 20 then 
			return
		end
		if PI.Enabled or Force then
			if self[Index].Enabled then
				local Object = self[Index].Columns.PP.Object
				if Object then
					if Object.icon then
						self[Index].Columns.PP.Icon:SetTexture("Rift", Object.icon)
						self[Index].Columns.PP.Icon:SetVisible(true)
						self[Index].Columns.PP.Icon:SetAlpha(1.0)
						self[Index].Columns.PP.Text:SetVisible(false)
					else
						self[Index].Columns.PP.Text:SetFontColor(0.15, 0.9, 0.15)
						self[Index].Columns.PP.Text:SetText("?")
						self[Index].Columns.PP.Icon:SetVisible(false)
						self[Index].Columns.PP.Text:SetVisible(true)
					end
				else
					self[Index].Columns.PP.Text:SetFontColor(0.9, 0.15, 0.15)
					self[Index].Columns.PP.Text:SetText("x")
					self[Index].Columns.PP.Icon:SetVisible(false)
					self[Index].Columns.PP.Text:SetVisible(true)
				end
			else
				self[Index].Columns.PP.Text:SetFontColor(0.9, 0.15, 0.15)
				self[Index].Columns.PP.Text:SetText("x")
				self[Index].Columns.PP.Icon:SetVisible(false)
				self[Index].Columns.PP.Text:SetVisible(true)
			end
		end
	end
	PI.Constants.Columns.PP.Hook = function(...) self.Rows:Update_PP(...) end

	function self.Rows:Update_Insoles(Index, Force)
		if Index > 20 then 
			return
		end
		if PI.Enabled or Force then
			if self[Index].Enabled then
				local Object = self[Index].Columns.Insoles.Object
				if Object then
					if Object.icon then
						self[Index].Columns.Insoles.Icon:SetTexture("Rift", Object.icon)
						self[Index].Columns.Insoles.Icon:SetVisible(true)
						self[Index].Columns.Insoles.Icon:SetAlpha(1.0)
						self[Index].Columns.Insoles.Text:SetVisible(false)
					else
						self[Index].Columns.Insoles.Text:SetFontColor(0.15, 0.9, 0.15)
						self[Index].Columns.Insoles.Text:SetText("?")
						self[Index].Columns.Insoles.Icon:SetVisible(false)
						self[Index].Columns.Insoles.Text:SetVisible(true)
					end
				else
					self[Index].Columns.Insoles.Text:SetFontColor(0.9, 0.15, 0.15)
					self[Index].Columns.Insoles.Text:SetText("x")
					self[Index].Columns.Insoles.Icon:SetVisible(false)
					self[Index].Columns.Insoles.Text:SetVisible(true)
				end
			else
				self[Index].Columns.Insoles.Text:SetFontColor(0.9, 0.15, 0.15)
				self[Index].Columns.Insoles.Text:SetText("x")
				self[Index].Columns.Insoles.Icon:SetVisible(false)
				self[Index].Columns.Insoles.Text:SetVisible(true)
			end
		end
	end
	PI.Constants.Columns.Insoles.Hook = function(...) self.Rows:Update_Insoles(...) end

	function self.Rows:Update_Soul(Index, Force)
		if Index > 20 then
			return
		end
		if PI.Enabled or Force then
			if self[Index].Enabled then
				if self[Index].Unit then
					local Vitality = self[Index].Unit.Vitality
					if Vitality then
						if Vitality > 80 then
							self[Index].Columns.Vitality.Text:SetFontColor(0.1, 0.9, 0.1)
						elseif Vitality > 60 then
							self[Index].Columns.Vitality.Text:SetFontColor(0.5, 0.9, 0.1)					
						elseif Vitality > 40 then
							self[Index].Columns.Vitality.Text:SetFontColor(0.9, 0.9, 0.1)					
						elseif Vitality > 20 then
							self[Index].Columns.Vitality.Text:SetFontColor(0.9, 0.5, 0.1)
						else
							self[Index].Columns.Vitality.Text:SetFontColor(0.9, 0.1, 0.1)
						end
						self[Index].Columns.Vitality.Text:SetText(tostring(Vitality).."%")
					else
						self[Index].Columns.Vitality.Text:SetText("-")
					end
				end
			else
				self[Index].Columns.Vitality.Text:SetText("n/a")
			end
		end
	end
		
	function self.Rows:Update_KBM(Index)
		if Index > 20 then
			return
		end
		if self[Index].Unit then
			if self[Index].Unit.Name then
				if KBM.MSG.History.NameStore[self[Index].Unit.Name] then
					local v
					if KBM.MSG.History.NameStore[self[Index].Unit.Name].None then
						v = "x"
						self[Index].Columns.KBM.Text:SetFontColor(0.9, 0.1, 0.1)
					else
						self[Index].Columns.KBM.Text:SetFontColor(1, 1, 1)
						if KBM.MSG.History.NameStore[self[Index].Unit.Name].Sent then
							if KBM.MSG.History.NameStore[self[Index].Unit.Name].Received then
								v = string.sub(KBM.MSG.History.NameStore[self[Index].Unit.Name].Full, 2)
							else
								self[Index].Columns.KBM.Text:SetFontColor(1, 0.9, 0.5)
								v = ".*.*."
							end
						else
							self[Index].Columns.KBM.Text:SetFontColor(0.9, 0.7, 0.2)
							v = "...."
							if not KBM.MSG.History.Queue[self[Index].Unit.Name] then
								KBM.MSG.History:SetSent(self[Index].Unit.Name, false)
								KBM.MSG.History.Queue[self[Index].Unit.Name] = true
							end
						end
					end
					self[Index].Columns.KBM.Text:SetText(v)						
				else
					self[Index].Columns.KBM.Text:SetFontColor(0.9, 0.5, 0.1)
					self[Index].Columns.KBM.Text:SetText("..*..")
					if not KBM.MSG.History.Queue[self[Index].Unit.Name] then
						KBM.MSG.History:SetSent(self[Index].Unit.Name, false)
						KBM.MSG.History.Queue[self[Index].Unit.Name] = true
					end
				end
			else
				self[Index].Columns.KBM.Text:SetFontColor(0.9, 0.5, 0.1)
				self[Index].Columns.KBM.Text:SetText("*.*.*")				
			end
		end
	end
	
	function self.Rows:Set_Offline(Index)
		if Index > 20 then
			return
		end
		if PI.Enabled then
			if self[Index].Enabled then
				if self[Index].Unit then
					if self[Index].Unit.Offline then
						self:Update_Name(Index)
						self:Update_KBM(Index)
						self[Index].HPBar:SetVisible(false)
						self[Index].MPBar:SetVisible(false)
						self[Index].Columns.Planar.Text:SetText("-/-")
						self[Index].Columns.Vitality.Text:SetText("-")
						self[Index].Columns.Stone.Text:SetText("-")
					else
						self[Index].HPBar:SetVisible(true)
						self[Index].MPBar:SetVisible(true)
						self:Update_All(Index)
					end
				end
			end
		end
	end
	
	function self.Rows:Update_All(Index, Force)
		if Index > 20 then
			return
		end
		if PI.Enabled or Force then
			self:Update_Name(Index, Force)
			self:Update(Index, Force)
			self:Update_Planar(Index, Force)
			self:Update_Soul(Index, Force)
			self:Update_KBM(Index, Force)
			self:Update_Stone(Index, Force)
			self:Update_Potion(Index, Force)
			self:Update_PP(Index, Force)
			self:Update_Insoles(Index, Force)
			self:Update_Food(Index, Force)
		end
	end

	function self.Rows:Update_Buffs(Index)
		if PI.Enabled and PI.Displayed then
			local CurrentTime = Inspect.Time.Real()

			for ID, Object in pairs(PI.GUI.Columns.List) do
				local Object = PI.GUI.Rows[Index].Columns[ID].Object
				if Object and PI.Settings.Columns[ID].Flash then
					if Object.begin and Object.duration then
						if (Object.duration - (CurrentTime - Object.begin)) < (60 * 7) then
							local cell = self[Index].Columns[ID]
							local TimeDiff = CurrentTime
							if cell.FadeStart then
								 TimeDiff = TimeDiff - cell.FadeStart
							end
							if cell.Direction then
								if TimeDiff > 0.5 then
									cell.Alpha = 1.0
									cell.Direction = false
									cell.FadeStart = CurrentTime
								else
									cell.Alpha = TimeDiff * 2
								end
							else
								if TimeDiff > 0.5 then
									cell.Alpha = 0.0
									cell.Direction = true
									cell.FadeStart = CurrentTime
								else
									cell.Alpha = 1.0 - (TimeDiff * 2)
								end
							end
							cell.Icon:SetAlpha(cell.Alpha)
						else
							self[Index].Columns[ID].Icon:SetAlpha(1.0)
						end
					end
				end
			end
		end
	end
	
	function self.Rows:Add(UnitID)
		self.Populated = self.Populated + 1
		local Index = self.Populated
		if self.Populated > 1 then
			for i = 1, self.Populated - 1 do
				if self[i].Unit then
					if KBM.AlphaComp(LibSUnit.Lookup.UID[UnitID].Name, self[i].Unit.Name) then
						Index = i
						break
					end
				else
					Index = i
					break
				end
			end
			if Index < self.Populated then
				if self.Populated < 21 then
					self[self.Populated].Enabled = true
					self[self.Populated].Cradle:SetVisible(true)
				end
				for i = self.Populated, Index + 1, -1 do
					self[i].Unit = self[i - 1].Unit
					self[i].Columns.Stone.Object = self[i - 1].Columns.Stone.Object
					self[i].Columns.Potion.Object = self[i - 1].Columns.Potion.Object
					self[i].Columns.PP.Object = self[i - 1].Columns.PP.Object
					self[i].Columns.Insoles.Object = self[i - 1].Columns.Insoles.Object
					self[i].Columns.Food.Object = self[i - 1].Columns.Food.Object
					if self[i].Unit then
						self.Units[self[i].Unit.UnitID] = self[i]
						self.Names[self[i].Unit.Name] = self[i]
					end
					if i < 21 then
						self:Set_Offline(i)
						self:Update_All(i)
					end
				end
			end
		end
		self[Index].Enabled = true
		self[Index].Unit = LibSUnit.Lookup.UID[UnitID]
		self[Index].Columns.Food.Object = nil
		self[Index].Columns.Potion.Object = nil
		self[Index].Columns.PP.Object = nil
		self[Index].Columns.Insoles.Object = nil
		self[Index].Columns.Stone.Object = nil
		self.Units[UnitID] = self[Index]
		self.Names[self[Index].Unit.Name] = self[Index]
		if Index < 21 then
			self[Index].Cradle:SetVisible(true)
			self:Set_Offline(Index)
			self:Update_All(Index, true)
		end
	end
	
	function self.Rows:Remove(UnitID)
		local Index = self.Units[UnitID].Index
		self.Names[self[Index].Unit.Name] = nil
		self.Units[UnitID] = nil
		if Index < self.Populated then
			for i = Index, self.Populated - 1 do
				self[i].Unit = self[i + 1].Unit
				self[i].Columns.Stone.Object = self[i + 1].Columns.Stone.Object
				self[i].Columns.Food.Object = self[i + 1].Columns.Food.Object
				self[i].Columns.Potion.Object = self[i + 1].Columns.Potion.Object
				self[i].Columns.PP.Object = self[i + 1].Columns.PP.Object
				self[i].Columns.Insoles.Object = self[i + 1].Columns.Insoles.Object
				if self[i].Unit then
					self.Units[self[i].Unit.UnitID] = self[i]
					self.Names[self[i].Unit.Name] = self[i]
					if i < 21 then
						self:Set_Offline(i)
						self:Update_All(i)
					end
				end
			end
		end
		self[self.Populated].Enabled = false
		self[self.Populated].Unit = nil
		self[self.Populated].Columns.Stone.Object = nil
		self[self.Populated].Columns.Food.Object = nil
		self[self.Populated].Columns.Potion.Object = nil
		self[self.Populated].Columns.PP.Object = nil
		self[self.Populated].Columns.Insoles.Object = nil
		if self.Populated < 21 then
			self[self.Populated].Cradle:SetVisible(false)		
		end
		self.Populated = self.Populated - 1
	end
	
	for Row = 1, 40 do
		self.Rows[Row] = {}
		--self.Rows.Units[tostring(Row)] = Row
		self.Rows[Row].Enabled = false
		self.Rows[Row].Index = Row
		self.Rows[Row].Unit = nil
		if Row < 21 then
			self.Rows[Row].Cradle = UI.CreateFrame("Frame", "Row Cradle "..Row, PI.GUI.Cradle)
			self.Rows[Row].Cradle:SetBackgroundColor(0,0,0,0.33)
			if Row > 1 then
				self.Rows[Row].Cradle:SetPoint("TOP", self.Rows[Row - 1].Cradle, "BOTTOM")
			else
				self.Rows[Row].Cradle:SetPoint("TOP", PI.GUI.Texture, "BOTTOM")
			end
			self.Rows[Row].Cradle:SetPoint("LEFT", PI.GUI.Header, "LEFT")
			self.Rows[Row].Cradle:SetPoint("RIGHT", PI.GUI.Header, "RIGHT")
			self.Rows[Row].Ready = {}
			self.Rows[Row].HPMask = UI.CreateFrame("Mask", "Row HP Mask "..Row, self.Rows[Row].Cradle)
			self.Rows[Row].HPMask:SetPoint("TOPLEFT", self.Rows[Row].Cradle, "TOPLEFT")
			self.Rows[Row].HPBar = UI.CreateFrame("Texture", "Row HP Texture "..Row, self.Rows[Row].HPMask)
			self.Rows[Row].HPBar:SetPoint("TOPLEFT", self.Rows[Row].Cradle, "TOPLEFT")
			self.Rows[Row].HPBar:SetPoint("RIGHT", self.Rows[Row].Cradle, "RIGHT")
			self.Rows[Row].HPBar:SetTexture("KingMolinator", "Media/BarTexture.png")
			self.Rows[Row].HPBar:SetBackgroundColor(0,0.5,0,0.5)
			self.Rows[Row].MPMask = UI.CreateFrame("Mask", "Row MP Mask "..Row, self.Rows[Row].Cradle)
			self.Rows[Row].MPMask:SetPoint("TOPLEFT", self.Rows[Row].HPBar, "BOTTOMLEFT")
			self.Rows[Row].MPMask:SetPoint("BOTTOM", self.Rows[Row].Cradle, "BOTTOM")
			self.Rows[Row].MPBar = UI.CreateFrame("Texture", "Row MP Texture "..Row, self.Rows[Row].MPMask)
			self.Rows[Row].MPBar:SetPoint("TOPLEFT", self.Rows[Row].HPBar, "BOTTOMLEFT")
			self.Rows[Row].MPBar:SetPoint("BOTTOMRIGHT", self.Rows[Row].Cradle, "BOTTOMRIGHT")
			self.Rows[Row].MPBar:SetTexture("KingMolinator", "Media/BarTexture.png")
			self.Rows[Row].MPBar:SetBackgroundColor(0, 0, 0.5, 0.5)
			self.Rows[Row].Ready.Cradle = UI.CreateFrame("Frame", "Row "..Row.." Ready Cradle", self.Rows[Row].Cradle)
			self.Rows[Row].Ready.Cradle:SetPoint("TOPLEFT", self.Rows[Row].Cradle, "TOPLEFT", 2, 1)
			self.Rows[Row].Ready.Cradle:SetPoint("BOTTOM", self.Rows[Row].Cradle, "BOTTOM", nil, -1)
			self.Rows[Row].Ready.Cradle:SetLayer(2)
			self.Rows[Row].Ready.Cradle:SetAlpha(0.75)
			self.Rows[Row].Ready.Check = UI.CreateFrame("Texture", "Row "..Row.." Ready Check", self.Rows[Row].Ready.Cradle)
			self.Rows[Row].Ready.Check:SetPoint("TOPLEFT", self.Rows[Row].Ready.Cradle, "TOPLEFT")
			self.Rows[Row].Ready.Check:SetPoint("BOTTOMRIGHT", self.Rows[Row].Ready.Cradle, "BOTTOMRIGHT")
			self.Rows[Row].Ready.Check:SetTexture("KingMolinator", "Media/RC_Check.png")
			self.Rows[Row].Ready.Check:SetVisible(false)
			self.Rows[Row].Ready.Cross = UI.CreateFrame("Texture", "Row "..Row.." Ready Cross", self.Rows[Row].Ready.Cradle)
			self.Rows[Row].Ready.Cross:SetPoint("TOPLEFT", self.Rows[Row].Ready.Cradle, "TOPLEFT")
			self.Rows[Row].Ready.Cross:SetPoint("BOTTOMRIGHT", self.Rows[Row].Ready.Cradle, "BOTTOMRIGHT")
			self.Rows[Row].Ready.Cross:SetTexture("KingMolinator", "Media/RC_Cross.png")
			self.Rows[Row].Ready.Cross:SetVisible(false)
			self.Rows[Row].Ready.Question = UI.CreateFrame("Texture", "Row "..Row.." Ready Question", self.Rows[Row].Ready.Cradle)
			self.Rows[Row].Ready.Question:SetPoint("TOPLEFT", self.Rows[Row].Ready.Cradle, "TOPLEFT")
			self.Rows[Row].Ready.Question:SetPoint("BOTTOMRIGHT", self.Rows[Row].Ready.Cradle, "BOTTOMRIGHT")
			self.Rows[Row].Ready.Question:SetTexture("KingMolinator", "Media/RC_Question.png")
			self.Rows[Row].Text = LibSGui.ShadowText:Create(self.Rows[Row].Cradle, true)
			self.Rows[Row].Text:SetLayer(3)
			self.Rows[Row].Text:SetPoint("CENTERLEFT", self.Rows[Row].Cradle, "CENTERLEFT", 4, -2)
			local DataObject = self.Rows[Row]
			self.Rows[Row].Cradle:SetVisible(false)
		end
		self.Rows[Row].Columns = {}
		for ID, Object in pairs(self.Columns.List) do
			self.Rows[Row].Columns[ID] = {}
			if Row < 21 then
				self.Rows[Row].Columns[ID].Cradle = UI.CreateFrame("Frame", "Row "..Row.." Data for "..ID, self.Rows[Row].Cradle)
				self.Rows[Row].Columns[ID].Cradle:SetPoint("TOP", self.Rows[Row].Cradle, "TOP")
				self.Rows[Row].Columns[ID].Cradle:SetPoint("LEFT", Object.Header, "LEFT")
				self.Rows[Row].Columns[ID].Cradle:SetPoint("RIGHT", Object.Header, "RIGHT")
				self.Rows[Row].Columns[ID].Cradle:SetPoint("BOTTOM", self.Rows[Row].Cradle, "BOTTOM")
				self.Rows[Row].Columns[ID].Text = LibSGui.ShadowText:Create(self.Rows[Row].Columns[ID].Cradle, true)
				self.Rows[Row].Columns[ID].Text:SetPoint("CENTER", self.Rows[Row].Columns[ID].Cradle, "CENTER")
				self.Rows[Row].Columns[ID].Text:SetLayer(2)
				self.Rows[Row].Columns[ID].Icon = UI.CreateFrame("Texture", "Row "..Row.." Icon for "..ID, self.Rows[Row].Columns[ID].Cradle)
				self.Rows[Row].Columns[ID].Icon:SetLayer(1)
				self.Rows[Row].Columns[ID].Icon:SetPoint("CENTER", self.Rows[Row].Columns[ID].Cradle, "CENTER")
				self.Rows[Row].Columns[ID].Icon:SetVisible(false)
				local DataObject = self.Rows[Row].Columns[ID]
				self.Rows[Row].Columns[ID].Text:SetText("n/a")
			end
		end
	end
	
	function self:UpdateDrag(uType)
		if uType == "end" then
			PI.Settings.x = self.Drag:GetLeft()
			PI.Settings.y = self.Drag:GetTop()
		end
	end
	
	self.Drag = KBM.AttachDragFrame(self.Header, function(uType) self:UpdateDrag(uType) end, "ReadyCheck_Drag_Bar")
	if PI.Settings.Scale then
		self:SetScaling(true)
	end
	PI.SetLock()
end

function PI.SetLock()
	PI.GUI.Drag:SetVisible(PI.Settings.Unlocked)
end

function PI.UnitRemove(UnitID)
	if UnitID ~= KBM.Player.UnitID then
		PI.Buffs[UnitID] = nil
		PI.Ready.Units[UnitID] = nil
		if PI.GUI.Rows.Units[UnitID] then
			PI.GUI.Rows:Remove(UnitID)
		end
	end
end

function PI.Update()
	if not PI.GUI.Rows then 
		return
	end
	for _, qObject in pairs(PI.Queue.List) do
		local UnitID = qObject.UnitID
		if qObject.Type == "Add" then
			if UnitID then
				if not PI.GUI.Rows.Units[UnitID] then
					PI.GUI.Rows:Add(UnitID)
					PI.Buffs[UnitID] = {}
					local Buffs = LibSBuff:GetBuffTable(UnitID)
					if Buffs then
						PI.BuffAdd(Event.SafesBuffLib.Buff.Add, {[UnitID] = Buffs})
					end
					if LibSUnit.Lookup.UID[UnitID] then
						if LibSUnit.Lookup.UID[UnitID].Ready ~= "nil" then
							PI.ReadyState(Event.SafesUnitLib.Unit.Detail.Ready, {[UnitID] = LibSUnit.Lookup.Ready})
						else
							PI.ReadyState(Event.SafesUnitLib.Unit.Detail.Ready, {[UnitID] = "nil"})
						end
					end
				end
			end
		else
			PI.UnitRemove(UnitID)
		end
	end
	PI.Queue.List = {}

	if PI.Displayed and PI.Settings.Flash then
		for i = 1, 20 do
			if PI.GUI.Rows[i].Enabled then
				PI.GUI.Rows:Update_Buffs(i)
			else
				break
			end
		end
	end
end

function PI.Update_End()
end

function PI.BuffAdd(handle, Units)
	for UnitID, BuffTable in pairs(Units) do
		if PI.GUI.Rows.Units[UnitID] then
			for BuffID, bDetails in pairs(BuffTable) do
				if bDetails then
					if bDetails.LibSBuffType then
						if PI.Constants.Lookup.Full[bDetails.LibSBuffType] then
							local ID = PI.Constants.Lookup.Full[bDetails.LibSBuffType].Column
							local Index = PI.GUI.Rows.Units[UnitID].Index
							if ID then
								if PI.GUI.Rows[Index] then
									if PI.GUI.Rows[Index].Columns[ID] then
										PI.GUI.Rows[Index].Columns[ID].Object = bDetails
										PI.Buffs[UnitID][BuffID] = bDetails
										if PI.Constants.Columns[ID] then
											PI.Constants.Columns[ID].Hook(Index)
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
end

function PI.BuffRemove(handle, Units)
	for UnitID, BuffTable in pairs(Units) do
		if PI.GUI.Rows.Units[UnitID] then
			if PI.Buffs[UnitID] then
				for BuffID, bDetails in pairs(BuffTable) do
					if PI.Buffs[UnitID][BuffID] then
						if bDetails then
							if bDetails.LibSBuffType then
								if PI.Constants.Lookup.Full[bDetails.LibSBuffType] then
									local ID = PI.Constants.Lookup.Full[bDetails.LibSBuffType].Column
									local Index = PI.GUI.Rows.Units[UnitID].Index
									if ID then
										if PI.GUI.Rows[Index] then
											if PI.GUI.Rows[Index].Columns[ID] then
												PI.GUI.Rows[Index].Columns[ID].Object = nil
												if PI.Constants.Columns[ID] then
													PI.Constants.Columns[ID].Hook(Index)
												end
											end
										end
									end
								end
							end
							PI.Buffs[UnitID][BuffID] = nil
						end
					end
				end
			end
		end
	end
end

function PI.Start()
	PI.Queue:Add(KBM.Player.UnitID, "Add")
	PI.Combat = Inspect.System.Secure()
	-- Rift API Events
	Command.Event.Attach(Event.System.Update.Begin, PI.Update, "Update Loop")
	Command.Event.Attach(Event.System.Update.End, PI.Update_End, "Clean-up Loop")
	Command.Event.Attach(Event.System.Secure.Enter, PI.SecureEnter, "Combat Enter")
	Command.Event.Attach(Event.System.Secure.Leave, PI.SecureLeave, "Combat Leave")
	Command.Event.Attach(Event.SafesUnitLib.Unit.New.Full, PI.DetailUpdates.Availability, "Update Full")
	Command.Event.Attach(Event.SafesUnitLib.Unit.Full, PI.DetailUpdates.Availability, "Update Full")
	--Command.Event.Attach(Event.SafesUnitLib.Unit.New.Partial, PI.DetailUpdates.Availability, "Update Full")
	Command.Event.Attach(Event.SafesBuffLib.Buff.Add, PI.BuffAdd, "Buff Add")
	Command.Event.Attach(Event.SafesBuffLib.Buff.Remove, PI.BuffRemove, "Buff Remove")
	Command.Event.Attach(Event.SafesBuffLib.Buff.Change, PI.BuffAdd, "Buff Change/Add")
end

function PI.UpdateSMode(Silent)
	local function Update(Silent)
		if not Silent then
			PI.GUI:ApplySettings()
		else
			if PI.Enabled then
				PI.GUI.Cradle:SetVisible(PI.Displayed)
			else
				PI.GUI.Cradle:SetVisible(false)
			end
		end
	end
	
	if PI.Settings.Solo then
		if LibSUnit.Raid.Grouped then
			PI.Displayed = true
		else
			PI.Displayed = false
			Update(Silent)
			return
		end
	else
		PI.Displayed = true
	end
	
	if PI.Settings.Combat then
		if PI.Combat then
			PI.Displayed = false
			Update(Silent)
			return
		else
			PI.Displayed = true
		end
	else
		PI.Displayed = true
	end
	
	if PI.Settings.Hidden then
		if PI.Ready.State then
			PI.Displayed = true
		else
			PI.Displayed = false
		end
	end

	Update(Silent)
end

function PI.SecureEnter()
	if PI.Settings.Combat then
		PI.Combat = true
		PI.UpdateSMode(true)
	end
end

function PI.SecureLeave()
	if PI.Settings.Combat then
		PI.Combat = false
		PI.UpdateSMode(true)
	end
end

function PI.PlayerJoin()
	PI.UpdateSMode(true)
end

function PI.PlayerLeave()
	PI.UpdateSMode(true)
end

function PI.GroupJoin(hadnle, UnitObj, Specifier)
	PI.Queue:Add(UnitObj.UnitID, "Add", Specifier)
end

function PI.GroupLeave(handle, UnitObj)
	PI.Queue:Add(UnitObj.UnitID, "Remove")
end

function PI.DetailUpdates.Planar(handle, Units)
	for UnitID, UnitObj in pairs(Units) do
		if PI.GUI.Rows.Units[UnitID] then
			PI.GUI.Rows:Update_Planar(PI.GUI.Rows.Units[UnitID].Index)
		end
	end
end

function PI.DetailUpdates.PlanarMax(handle, Units)
	for UnitID, UnitObj in pairs(Units) do
		if PI.GUI.Rows.Units[UnitID] then
			PI.GUI.Rows:Update_Planar(PI.GUI.Rows.Units[UnitID].Index)
		end
	end
end

function PI.DetailUpdates.Vitality(handle, Units)
	for UnitID, UnitObj in pairs(Units) do
		if PI.GUI.Rows.Units[UnitID] then
			PI.GUI.Rows:Update_Soul(PI.GUI.Rows.Units[UnitID].Index)
		end
	end
end

function PI.DetailUpdates.HPChange(handle, UnitObj)
	if PI.GUI.Rows.Units[UnitObj.UnitID] then
		PI.GUI.Rows:Update(PI.GUI.Rows.Units[UnitObj.UnitID].Index)
	end	
end

function PI.DetailUpdates.Availability(handle, UnitObj)
	if PI.GUI.Rows.Units[UnitObj.UnitID] then
		PI.GUI.Rows.Units[UnitObj.UnitID].Unit = UnitObj
		PI.GUI.Rows:Set_Offline(PI.GUI.Rows.Units[UnitObj.UnitID].Index)
	end
end

function PI.DetailUpdates.Version(handle, From)
	if From then
		if PI.GUI.Rows.Names[From] then
			PI.GUI.Rows:Update_KBM(PI.GUI.Rows.Names[From].Index)
		end
	end
end

function PI.DetailUpdates.Offline(handle, Units)
	for UnitID, UnitObj in pairs(Units) do
		if PI.GUI.Rows.Units[UnitID] then
			if PI.GUI.Rows.Units[UnitID].Unit then
				if UnitObj.Offline then
					PI.GUI.Rows:Set_Offline(PI.GUI.Rows.Units[UnitID].Index)
				end
			end
		end
	end
end

function PI.SlashEnable()
	if PI.Displayed then
		PI.GUI.Cradle:SetVisible(false)
		PI.Displayed = false
	else
		PI.GUI.Cradle:SetVisible(true)
		PI.Displayed = true
	end
end

function PI.Enable(bool)
	PI.Enabled = bool
	PI.Settings.Enabled = bool
	PI.UpdateSMode()
	for i = 1, 20 do
		if PI.GUI.Rows[i].Enabled then
			PI.GUI.Rows:Update_All(i)
		else
			break
		end
	end
end

function PI.ReadyState(handle, Units)
	local HoldState = PI.Ready.State
	for UnitID, UnitObj in pairs(Units) do
		local bool = UnitObj.Ready
		if bool == true then
			if PI.Ready.State == false then
				PI.Ready.Replied = 0
				PI.Ready.Yes = 0
				PI.Ready.No = 0
				PI.Ready.State = true
			end
			PI.Ready.Units[UnitID] = "true"
			if PI.GUI.Rows.Units[UnitID] then
				if PI.GUI.Rows.Units[UnitID].Index < 21 then
					PI.GUI.Rows.Units[UnitID].Ready.Check:SetVisible(true)
					PI.GUI.Rows.Units[UnitID].Ready.Question:SetVisible(false)
					PI.GUI.Rows.Units[UnitID].Ready.Cross:SetVisible(false)
				end
			end
			PI.Ready.Yes = PI.Ready.Yes + 1
			PI.Ready.Replied = PI.Ready.Replied + 1
		else
			if bool == false then
				if PI.Ready.State == false then
					PI.Ready.Replied = 0
					PI.Ready.Yes = 0
					PI.Ready.No = 0
					PI.Ready.State = true
				end
				PI.Ready.Units[UnitID] = "false"
				if PI.GUI.Rows.Units[UnitID] then
					if PI.GUI.Rows.Units[UnitID].Index < 21 then
						PI.GUI.Rows.Units[UnitID].Ready.Check:SetVisible(false)
						PI.GUI.Rows.Units[UnitID].Ready.Question:SetVisible(false)
						PI.GUI.Rows.Units[UnitID].Ready.Cross:SetVisible(true)
					end
				end
				PI.Ready.No = PI.Ready.No + 1
				PI.Ready.Replied = PI.Ready.Replied + 1
			else
				PI.Ready.State = false
				PI.Ready.Units[UnitID] = "nil"
				if PI.GUI.Rows.Units[UnitID] then
					if PI.GUI.Rows.Units[UnitID].Index < 21 then
						PI.GUI.Rows.Units[UnitID].Ready.Check:SetVisible(false)
						PI.GUI.Rows.Units[UnitID].Ready.Question:SetVisible(true)
						PI.GUI.Rows.Units[UnitID].Ready.Cross:SetVisible(false)
					end
				end
			end
		end
	end
	if HoldState ~= PI.Ready.State then
		if PI.Settings.Hidden then
			PI.UpdateSMode()
		end
	end
end

function PI.Init(handle, ModID)
	if ModID == AddonData.id then
		
		-- LibSUnit Events
		Command.Event.Attach(Event.SafesUnitLib.Raid.Join, PI.PlayerJoin, "Ready Check Player Joins")
		Command.Event.Attach(Event.SafesUnitLib.Raid.Leave, PI.PlayerLeave, "Ready Check Player Leaves")
		Command.Event.Attach(Event.SafesUnitLib.Raid.Member.Join, PI.GroupJoin, "Ready Check Group Member joins")
		Command.Event.Attach(Event.SafesUnitLib.Raid.Member.Leave, PI.GroupLeave, "Ready Check Group Member leaves")
		Command.Event.Attach(Event.SafesUnitLib.Unit.Detail.Planar, PI.DetailUpdates.Planar, "Ready Check Update Planar Charges")
		Command.Event.Attach(Event.SafesUnitLib.Unit.Detail.PlanarMax, PI.DetailUpdates.PlanarMax, "Update Planar Max")
		Command.Event.Attach(Event.SafesUnitLib.Unit.Detail.Vitality, PI.DetailUpdates.Vitality, "Update Vitality")
		Command.Event.Attach(Event.SafesUnitLib.Unit.Detail.Percent, PI.DetailUpdates.HPChange, "Update HP")
		Command.Event.Attach(Event.SafesUnitLib.Unit.Detail.Ready, PI.ReadyState, "Ready Check Update HP")
		Command.Event.Attach(Event.SafesUnitLib.Unit.Detail.Offline, PI.DetailUpdates.Offline, "Ready Check Offline Toggle")
		Command.Event.Attach(Event.KBMMessenger.Version, PI.DetailUpdates.Version, "Ready Check Update Version")
		-- Slash Commands
		Command.Event.Attach(Command.Slash.Register("kbmreadycheck"), PI.SlashEnable, "Ready Check Toggle Visible")
		PI.UpdateSMode()
	end
end

Command.Event.Attach(Event.Addon.Load.End, PI.Init, "KBM Ready Check Synchronized Start")
Command.Event.Attach(Event.Addon.SavedVariables.Load.End, PI.LoadVars, "KBM Ready Check Load Settings")
Command.Event.Attach(Event.Addon.SavedVariables.Save.Begin, PI.SaveVars, "KBM Ready Check Save Settings")
Command.Event.Attach(Event.SafesUnitLib.System.Start, PI.Start, "KBM Ready Check Start-up")
