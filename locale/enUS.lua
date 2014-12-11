local _, TopFit = ...
local L = {}
TopFit.locale = L

do
	L.SecondaryPercentBonus = "Percent bonus to secondary stats"

	-- ------------------------------------------------------------
	--  Basic Addon
	-- ------------------------------------------------------------
	L.SelectSet = "Select set to calculate:"
	L.Abort = "Abort"
	L.Start = "Calculate"
	L.StartTooltip = "Start Calculation\n|cffffffffClick this button to start calculation for the currently selected set and equip it.\n\n|rShift-Click|cffffffff to calculate all your sets at once."
	L.EditSetNameTooltip = "Click here to edit this set's name!"
	L.SelectSetDropDown = "Select / Modify Set"
	L.AddSetDropDown = "Add New Set"
	L.AddSetTab = "|cFF20FF20Add new set|r|nCreate a new set using a preset or start from scratch."
	L.SetTabTooltip = '%1$s|n|cFF808080Right-Click to delete this set.|r'
	L.ModifySetSelectText = _G.LFG_LIST_SELECT
	L.ModifySetRenameText = _G.RENAME_GUILD
	L.ModifySetDeleteText = _G.DELETE
	L.AddSetTooltip = "Add a new equipment set\n|cffffffffAfterwards, you can adjust this set's weights and caps in the right frame, or force items by clicking on any equipment slots below."
	L.DeleteSetTooltip = "Delete the selected set\n\n|cffff0000WARNING|cffffffff: The associated set in the equipment manager will also be deleted! If you want to keep it, create a copy in Blizzard's equipment manager first!"

	L.Options = "Options"
	L.OpenSetConfigTooltip = "Left-Click: Open set config"
	L.OpenAddonConfigTooltip = "Right-Click: Open addon config"
	L.ForceItem = "Force Item for %s:"
	L.ForceItemNone = "Do not force"
	L.EmptySet = "Empty Set"
	L.SetName = "Set Name"
	L.HeadingStats = "Statistics"
	L.HeadingCaps = "Caps"
	L.SetScore = "Total Score: %.2f"
	L.SetHeader = "Item Sets"
	L.FlyoutTooltip = "Force Items\n|cffffffffClick items in this flyout menu and TopFit will only use those items for calculation in that slot. Click them again to remove their selection."
	L.missingForcedItemTooltip = "Forced Item missing\n|cffffffffThis item is still forced for this slot, but could not be found in your inventory."
	L.capActiveTooltip = "When checked, TopFit will try everything it can to reach this cap. Otherwise, this value just specifies the point at which the alternate value kicks in."

	L.SlashHelp = "Available Options:\n  show - shows the calculations frame\n  options - shows TopFit's options"

	L.ErrorCapNotReached = "Caps could not be reached, calculating again without caps."
	L.ErrorItemNotFound = "%s could not be found in your inventory for equipping! Did you remove it during calculation?"
	L.ErrorEquipFailure = "  %1$s into Slot %2$d (%3$s)"    -- itemLink, slotID, slotName
	L.NoticeVirtualItemsUsed = "No items will be equipped because virtual items were included in the set calculation."
	L.NoticeEquipFailure = "Oh. I am sorry, but I must have made a mistake. I cannot equip all the items I chose:"
	L.WelcomeText = "Welcome back, my master!\nIn order to present your equipment as fitting as possible, please select which set I shall look at:"

	L.unknownEnhancementsNotification = "unknown enhancements"
	L.unknownGemNotification = "Unknown gem: %s"
	L.unknownEnchantNotification = "Unknown enchant: %s on %s"

	-- ------------------------------------------------------------
	--  Options
	-- ------------------------------------------------------------
	L.SubTitle = "Basic options"
	L.ShowMinimapIcon = "Show minimap icon"
	L.ShowMinimapIconTooltip = "|cffffffffCheck to show an icon on the border of your minimap for quick access to TopFit's settings."
	L.ShowTooltipScores = "Show set values in tooltip"
	L.ShowTooltipScoresTooltip = "|cffffffffCheck to show your sets' scores for an item in the item's tooltip."
	L.ShowTooltipComparison = "Show item comparison values in tooltip"
	L.ShowTooltipComparisonTooltip = "|cffffffffCheck to show values in your tooltip which indicate how much of an improvement an item is in comparison with your equipped items for each set."
	L.AutoUpdateSet = "Automatic update set"
	L.AutoUpdateSetTooltip = "|cffffffffThe set you choose here will be updated automatically whenever you loot an equippable item.\n\n|cffffff00Warning: |cffffffffThis option is intended to be used while levelling. If you have a character with dualspec, it might suddenly equip the set you specify here even if you activated your other specialization."
	L.None = "None"
	L.AutoUpdateOnRespec = "Update Set automatically when you change spec"
	L.AutoUpdateOnRespecTooltip = "|cffffffffThis will automatically calculate your selected auto-update set when you change specializations. Effectively, this will provide you with your correct gear whenever you respec."
	L.Debug = "Debug mode"
	L.DebugTooltip = "|cffffffffCheck to enable debug messages.\n\n|cffffff00Caution: |cffffffffThis will spam your chatframe, a lot!"

	-- ------------------------------------------------------------
	--  Plugins
	-- ------------------------------------------------------------
	-- setup
	L.NoSetTitle = "No sets available"
	L.SetupWizardIntro = "|cffffffffIn order for TopFit to do anything for you, stat weights need to be set. You can start off by creating some default sets."
	L.SetupWizardSpec0 = "|cffffffffYou don't have any specialization yet."
	L.SetupWizardSpec1 = "|cffffffffYour current specialization is \""..NORMAL_FONT_COLOR_CODE.."%s".."|cffffffff".."\"."
	L.SetupWizardSpec2 = "|cffffffffYour current specializations are \""..NORMAL_FONT_COLOR_CODE.."%s".."|cffffffff".."\" and \""..NORMAL_FONT_COLOR_CODE.."%s".."|cffffffff".."\"."
	L.SetupWizardSpecAll = " Choose which sets should be created."
	L.SetupWizardCreateNoSet = "Do nothing"
	L.SetupWizardAutoEquip = "Auto-update and equip these sets"

	-- stats
	L.Stats = "Stats"
	L.StatsTooltip = "See the stats for your currently selected set."
	L.StatsExplanation = "Every stat gets its own value, i.e. "..NORMAL_FONT_COLOR_CODE.."1 point of this stat"..FONT_COLOR_CODE_CLOSE.." is worth this much when calculating.\nA stat may also have a cap that TopFit will try to reach with first priority. It can be either "..NORMAL_FONT_COLOR_CODE.."hard"..FONT_COLOR_CODE_CLOSE.." (more points in this stat are wasted) or "..NORMAL_FONT_COLOR_CODE.."soft"..FONT_COLOR_CODE_CLOSE.." (more points in it are OK)."
	L.StatsUsage = "To change a stat's value, simply click on the stat name or value in the list below.\nTo remove a stat, set its value to "..NORMAL_FONT_COLOR_CODE.."0"..FONT_COLOR_CODE_CLOSE.."."
	L.StatsSetPiece = "Set Piece"
	L.StatsHeaderName = "Name"
	L.StatsHeaderValue = "Value"
	L.StatsHeaderCap = "Cap"
	L.StatsPanelLabel = "Stat Weights"
	L.StatsAdd = "Add stat ..."
	L.StatsSet = "Set: "
	L.StatsCapSoft = "Soft"
	L.StatsCapHard = "Hard"
	L.StatsCategoryBasic = "Basic Attributes"
	L.StatsCategoryMelee = "Physical"
	L.StatsCategoryCaster = "Caster"
	L.StatsCategoryDefensive = "Defensive"
	L.StatsCategoryHybrid = "Hybrid"
	L.StatsCategoryMisc = "Misc"
	L.StatsCategoryResistances = "Resistances"
	L.StatsCategoryArmorTypes = "Armor Types"

	L.SelectSpecHeader = "Assign Specialization"
	L.NoSpecSelected = "No Specialization"

	-- virtual items
	L.VirtualItems = "Virtual Items"
	L.VirtualItemsTooltip = "Virtual Items are used to calculate your optimal gear with items you do not currently have in your inventory."
	L.IncludeVI = "Include virtual items in calculation"
	L.IncludeVITooltip = "Check this to use your virtual items when calculating."
	L.VIExplanation = "This is useful e.g. if you intend to buy a certain item and want to see what your gear will be once you can use it.\n\nWhen virtual items are included in the calculation, a set may not be saved with the Blizzard Gear Manager.\nIf you want to be able to save your set, disable the checkbox below."
	L.VIUsage = "Paste an item link or an item ID in the edit box below and press <Enter> to add that item to your virtual items.\nTo remove an item, simply right-click on its icon in the list."
	L.VIAddItem = "Add an item to the list"
	L.VIItemNotFound = "Item not found."
	L.VIErrorNotEquippable = "%s could not be added as it seems to be no equippable item."
	L.VIErrorNoSet = "Please select or create a set before adding virtual items to it."

	-- options
	L.OptionsPanelTitle = "Options"
	L.OptionsPanelTooltip = "Adjust set-specific options here."
	L.StatsShowTooltip = "Include set in tooltip"
	L.StatsShowTooltipTooltip = "Check to show this set in item comparison tooltips when that option is enabled."
	L.StatsEnableDualWield = "Calculate with dual-wield"
	L.StatsEnableDualWieldTooltip = "Check to calculate this set with dualwielding in mind even if your current spec does not allow you to. If left off, the set will be calculated with your current spec in mind."
	L.StatsEnableTitansGrip = "Calculate with Titan's Grip"
	L.StatsEnableTitansGripTooltip = "Check to calculate this set with Titan's Grip in mind even if your current spec does not include it. If left off, the set will be calculated with your current spec in mind."
	L.StatsForceArmorType = "Force Armor Type"
	L.StatsForceArmorTypeTooltip = "After reaching character level 50, only armor that counts towards your armor specialization will be equipped in the appropriate slots."

	-- utilities
	L.Utilities = "Import / Export"
	L.UtilitiesTooltip = "Click here to import or export your TopFit or Pawn gear sets."
	L.ImportLabel = "Import from string"
	L.UtilitiesDefaultText = "Paste your import string from Pawn or TopFit here:"
	L.UtilitiesErrorStringParse = "Error! String could not be parsed."
	L.UtilitiesErrorSetExists = "Error! A set with this name already exists."
	L.UtilitiesNoticeImported = "Import of %s succeeded."

	-- help system
	L.HelpSetTabs = "You can find your available TopFit sets here.\n\nClick the plus button to add a new set, optionally using presets or importing from Pawn, AskMrRobot or TopFit."
	L.HelpSidebarPlugins = "Select a plugin from this list.\n\nEvery plugin has a unique panel that is directly tied to your currently selected set."
	L.HelpSidebarCalculate = "Click the calculate button to update the currently selected set."
	L.HelpContentPanel = "This is the main configuration area.\n\nPlugins display their data and options here."

	L.ItemScan = {}
	L.ItemScan.PercentBonusTrigger = "Equip: Amplifies your Critical Strike damage and healing, Haste, Mastery, and Spirit by "
end

if GetLocale() == "deDE" then
	L.ItemScan.PercentBonusTrigger = "Anlegen: Erhöht Euren kritischen Schaden und Eure kritische Heilung, Euer Tempo, Eure Meisterschaft und Eure Willenskraft um "
end
