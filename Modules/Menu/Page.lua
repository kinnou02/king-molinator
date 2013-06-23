-- KBM Menu System: Page
-- Written by Paul Snart
-- Copyright 2013
--

local AddonIni, KBM = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data
local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local Menu = KBM.Menu
Menu.Page = {}
local Page = Menu.Page

function Page:SetStyle()
	Menu.Current.Style = "Page"
	Menu.PageUI.Tabber:SetVisible(false)
	Menu.PageUI.Panel:SetPoint("TOP", Menu.Header.Cradle, "BOTTOM")
	Menu.PageUI.Main:SetPoint("RIGHT", Menu.PageUI.Panel.Content, "RIGHT")
	Menu.PageUI.Side:SetVisible(false)
	Menu.PageUI.Content:SetVisible(true)
	Menu.PageUI.Main:SetContentHeight(10)
end

function Page:CreateHeader(Title, ID, TVID, TABID, Settings, pTable)	
	Title = tostring(Title)
	ID = tostring(ID)
	TVID = tostring(TVID)
	TABID = tostring(TABID)
	Settings = Settings or {}
	pTable = pTable or {}
	
	if type(pTable) ~= "table" then
		error("Menu.Page:Create((String)Title, (Table)pTable) - pTable was not of type Table")
	else
		if not Menu.Tab[TVID] then
			error("Supplied TVID not valid: "..TVID)
		end
		if not Menu.Tab[TVID][TABID] then
			error("Supplied TABID not valid: "..TABID)
		end
		local Header = {}
		Header.Tab = Menu.Tab[TVID]
		Header.TreeView = Header.Tab[TABID].TreeView
		Header.Node = Header.TreeView:Create(Title)
		Header.Tab[TABID].Headers[ID] = Header
		Header.ID = ID
		Header.TABID = TABID
		Header.TVID = TVID
		Header.Items = {}
		Header.Name = Title
		Header.Settings = Settings
		function Header:CreateItem(Title, ID, pTable)
			local Item = {}
			pTable = pTable or {}
			
			Item.Type = "Page"
			Item.Header = self
			Item.Node = self.Node:Create(Title)
			Item.Node.UserData._pageObj = Item
			Item.Name = Title
			Item.ID = self.ID.."."..ID
			Item.Object = LibSata:Create()
			Item.Rendered = LibSata:Create()
			Item.UI = {
				Cradle = Menu.PageUI.Anchor,
				Content = Menu.PageUI.Content,
			}
			Item._root = Item
			Item.Height = 10
			Item.Padding = 0
			Item.ChildState = true
			Item.Enabled = true
						
			for ID, _function in pairs(Menu.Object) do
				Item.UI[ID] = function(Name, Settings, ID, Callback)
					return _function(Menu.Object, Name, Settings, ID, Callback, Item)
				end
			end
			
			self.Items[ID] = Item
			
			function Item:Pad(Spacer)
				self.Padding = self.Padding + Spacer
			end
			
			function Item:Select()
				Item.Node:Select()
				Menu.Current.TreeView = Item.Header.TreeView
				Menu.Current.Page = self
				self:Open()
			end
			
			function Item:LinkY(Object)
				if self.LastObject then
					self.LastObject:LinkY(Object, 10)
				else
					Object:SetPoint("TOP", self.UI.Cradle, "TOP")
				end
			end
			
			function Item:LinkX(Object)
				Object:SetPoint("LEFT", self.UI.Cradle, "LEFT")			
			end
			
			function Item:Open()
				if Menu.Current.Style ~= "Page" then
					Page:SetStyle()
				end
				Menu.Header.MainText:SetText(self.Header.Name)
				Menu.Header.SubText:SetText(self.Name)
				for _, PageObj in LibSata.EachIn(self.Object) do
					PageObj:Queue()
				end
				Menu.Queue.PageEnd(self)
				
				self.Active = true
			end
			
			function Item:Displayed()
				self.Complete = true
				if self.Active then
					Menu.PageUI.Main:SetContentHeight(self.Height + self.Padding)
				end
			end
			
			function Item:SetEnabled(bool)
				self.Node:SetEnabled(bool)
			end
			
			function Item:Close()
				self.Height = 10
				self.Padding = 0
				self.Complete = false
				Menu.RenderHalt()
				for _, RemoveObj in LibSata.EachIn(self.Rendered) do
					RemoveObj:Remove()
				end
				self.Rendered:Clear()
				self.LastObject = nil
				self.Active = false
				Menu.PageUI.Main:SetContentHeight(10)
				if self.CloseLink then
					self:CloseLink()
				end
			end
			
			function Item:SetCloseLink(_function)
				if type(_function) ~= "function" then
					error(":SetCloseLink(Callback) - Expecting Callback = Function() got :"..type(_function))
				end
				self.CloseLink = _function
			end
			
			if pTable.Selected then
				Item:Select()
			end
			
			return Item
		end
		return Header
	end
end
