------------------------------------------------------------------------------------------
-- Tukui TrackingMenu
-- Constants.lua
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- SETUP
------------------------------------------------------------------------------------------
local AddOnName, AddOn = ...
local T, C, L = Tukui:unpack()
local Constants = {}
AddOn.Constants = Constants


------------------------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------------------------
Constants.AddOnName = AddOnName
Constants.TrackingSpells = {
	1494,	-- Track Beasts (Hunter)
	2383,	-- Find Herbs (Herbalism)
	2481,	-- Find Treasure (Dwarf racial)
	2580,	-- Find Minerals (Mining)
	5225,	-- Track Humanoids (Druid)
	5500,	-- Sense Demons (Warlock)
	5502,	-- Sense Undead (Paladin)
	19878,	-- Track Demons (Hunter)
	19879,	-- Track Dragonkin (Hunter)
	19880,	-- Track Elementals (Hunter)
	19882,	-- Track Giants (Hunter)
	19883,	-- Track Humanoids (Hunter)
	19884,	-- Track Undead (Hunter)
	19885	-- Track Hidden (Hunter)
}
