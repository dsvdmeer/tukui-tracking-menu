------------------------------------------------------------------------------------------
-- Tukui TrackingMenu
-- Core.lua
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- SETUP
------------------------------------------------------------------------------------------
local AddOn = select(2, ...)
local T, C, L = Tukui:unpack()
local Constants = AddOn.Constants
local TukuiMinimap = T["Maps"].Minimap
local TukuiMiscellaneous = T["Miscellaneous"]


------------------------------------------------------------------------------------------
-- CORE
------------------------------------------------------------------------------------------
local Hook = function(t, functionName, pre, post)
	local OriginalFunction = t[functionName]
	t[functionName] = function(...)
		local Result
		if pre ~= nil then
			pre(...)
		end
		if OriginalFunction ~= nil then
			Result = OriginalFunction(...)
		end
		if post ~= nil then
			post(...)
		end
		return Result
	end
end

local HookScript = function(f, eventName, pre, post)
	local OriginalFunction = f:GetScript(eventName)
	f:SetScript(eventName, function(...)
		if pre ~= nil then
			pre(...)
		end
		if OriginalFunction ~= nil then
			OriginalFunction(...)
		end
		if post ~= nil then
			post(...)
		end
	end)
end

function AddOn:Initialize()
	if MiniMapTrackingFrame == nil then
		return
	end

	self.Button = CreateFrame("Button", "Tukui_TrackingMenu_Button", MiniMapTrackingFrame)
	self.Button:SetAllPoints()

	self.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	self.Button:SetScript("OnClick", function()
		AddOn:OnButtonClick()
	end)

	self.Button:RegisterEvent("MINIMAP_UPDATE_TRACKING")
	self.Button:SetScript("OnEvent", function(_, event)
		if event == "MINIMAP_UPDATE_TRACKING" then
			AddOn:UpdateIcon()
		end
	end)

	self.Menu = CreateFrame("Frame", "Tukui_TrackingMenu_DropDown", UIParent, "UIDropDownMenuTemplate")
	self.Menu:Hide()

	self.MenuButtons = {}
	for i = 1, #Constants.TrackingSpells do
		local SpellID = Constants.TrackingSpells[i]
		table.insert(self.MenuButtons, {
			_spellID = SpellID,
			text = GetSpellInfo(SpellID),
			icon = GetSpellTexture(SpellID),
			func = function()
				CastSpellByID(SpellID)
			end
		})
	end
	table.sort(self.MenuButtons, function(lh, rh)
		return strcmputf8i(lh.text, rh.text) < 0
	end)

	MiniMapTrackingFrame:HookScript("OnHide", function()
		AddOn:ShowIcon()
	end)

	self:UpdateIcon()
	self:ShowIcon()
end

function AddOn:OnButtonClick()
	local MouseButton = GetMouseButtonClicked()
	if MouseButton == "LeftButton" then
		self:OpenMenu()
	elseif MouseButton == "RightButton" then
		self:CancelTracking()
	end
end

function AddOn:OpenMenu()
	local CurrentTexture = GetTrackingTexture()
	local VisibleButtons = {}
	for i = 1, #self.MenuButtons do
		local MenuButton = self.MenuButtons[i]
		if IsPlayerSpell(MenuButton._spellID) then
			MenuButton.checked = MenuButton.icon == CurrentTexture
			table.insert(VisibleButtons, MenuButton)
		end
	end

	TukuiMiscellaneous.DropDown.Open(VisibleButtons, self.Menu, "MiniMapTrackingFrame", 0, 0, "MENU", 2)
end

function AddOn:CancelTracking()
	CancelTrackingBuff()
end

function AddOn:UpdateIcon()
	if GetTrackingTexture() == nil then
		MiniMapTrackingIcon:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent.blp")
	end
end

function AddOn:ShowIcon()
	local HasTrackingSpells = false
	for i = 1, #Constants.TrackingSpells do
		if IsPlayerSpell(Constants.TrackingSpells[i]) then
			HasTrackingSpells = true
			break
		end
	end
	if HasTrackingSpells then
		MiniMapTrackingFrame:Show()
	end
end

Hook(TukuiMinimap, "Enable", nil, function()
	AddOn:Initialize()
end)
