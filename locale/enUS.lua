local _, TopFit = ...
--if GetLocale() == "enUS" or GetLocale() == "enGB" then
TopFit.locale = {}
do
    -- ------------------------------------------------------------
    -- Stats used by TopFit for which there are no decent global
    -- strings. Ideally doesn't need to be translated
    -- ------------------------------------------------------------
    TOPFIT_MELEE_WEAPON_SPEED = MELEE.." "..WEAPON_SPEED
    TOPFIT_RANGED_WEAPON_SPEED = RANGED.." "..WEAPON_SPEED
    TOPFIT_MELEE_DPS = MELEE.." "..ITEM_MOD_DAMAGE_PER_SECOND_SHORT
    TOPFIT_RANGED_DPS = RANGED.." "..ITEM_MOD_DAMAGE_PER_SECOND_SHORT
    TOPFIT_SECONDARY_PERCENT = "Percent bonus to secondary stats"

    -- ------------------------------------------------------------
    --  Basic Addon
    -- ------------------------------------------------------------
    TopFit.locale.SelectSet = "Select set to calculate:"
    TopFit.locale.Abort = "Abort"
    TopFit.locale.Start = "Calculate"
    TopFit.locale.StartTooltip = "Start Calculation\n|cffffffffClick this button to start calculation for the currently selected set and equip it.\n\n|rShift-Click|cffffffff to calculate all your sets at once."
    TopFit.locale.EditSetNameTooltip = "Click here to edit this set's name!"
    TopFit.locale.SelectSetDropDown = "Select / Modify Set"
    TopFit.locale.AddSetDropDown = "Add New Set"
    TopFit.locale.AddSetTab = "|cFF20FF20Add new set|r|nCreate a new set using a preset or start from scratch."
    TopFit.locale.SetTabTooltip = '%1$s|n|cFF808080Right-Click to delete this set.|r'
    TopFit.locale.ModifySetSelectText = "Select"
    TopFit.locale.ModifySetRenameText = "Rename"
    TopFit.locale.ModifySetDeleteText = "Delete"
    TopFit.locale.AddSetTooltip = "Add a new equipment set\n|cffffffffAfterwards, you can adjust this set's weights and caps in the right frame, or force items by clicking on any equipment slots below."
    TopFit.locale.DeleteSetTooltip = "Delete the selected set\n\n|cffff0000WARNING|cffffffff: The associated set in the equipment manager will also be deleted! If you want to keep it, create a copy in Blizzard's equipment manager first!"

    TopFit.locale.Options = "Options"
    TopFit.locale.OpenSetConfigTooltip = "Left-Click: Open set config"
    TopFit.locale.OpenAddonConfigTooltip = "Right-Click: Open addon config"
    TopFit.locale.ForceItem = "Force Item for %s:"
    TopFit.locale.ForceItemNone = "Do not force"
    TopFit.locale.EmptySet = "Empty Set"
    TopFit.locale.SetName = "Set Name"
    TopFit.locale.HeadingStats = "Statistics"
    TopFit.locale.HeadingCaps = "Caps"
    TopFit.locale.SetScore = "Total Score: %.2f"
    TopFit.locale.SetHeader = "Item Sets"
    TopFit.locale.FlyoutTooltip = "Force Items\n|cffffffffClick items in this flyout menu and TopFit will only use those items for calculation in that slot. Click them again to remove their selection."
    TopFit.locale.missingForcedItemTooltip = "Forced Item missing\n|cffffffffThis item is still forced for this slot, but could not be found in your inventory."
    TopFit.locale.capActiveTooltip = "When checked, TopFit will try everything it can to reach this cap. Otherwise, this value just specifies the point at which the alternate value kicks in."

    TopFit.locale.SlashHelp = "Available Options:\n  show - shows the calculations frame\n  options - shows TopFit's options"

    TopFit.locale.ErrorCapNotReached = "Caps could not be reached, calculating again without caps."
    TopFit.locale.ErrorItemNotFound = "%s could not be found in your inventory for equipping! Did you remove it during calculation?"
    TopFit.locale.ErrorEquipFailure = "  %1$s into Slot %2$d (%3$s)"    -- itemLink, slotID, slotName
    TopFit.locale.NoticeVirtualItemsUsed = "No items will be equipped because virtual items were included in the set calculation."
    TopFit.locale.NoticeEquipFailure = "Oh. I am sorry, but I must have made a mistake. I cannot equip all the items I chose:"
    TopFit.locale.WelcomeText = "Welcome back, my master!\nIn order to present your equipment as fitting as possible, please select which set I shall look at:"

    TopFit.locale.unknownEnhancementsNotification = "unknown enhancements"
    TopFit.locale.unknownGemNotification = "Unknown gem: %s"
    TopFit.locale.unknownEnchantNotification = "Unknown enchant: %s on %s"

    -- ------------------------------------------------------------
    --  Options
    -- ------------------------------------------------------------
    TopFit.locale.SubTitle = "Basic options"
    TopFit.locale.ShowMinimapIcon = "Show minimap icon"
    TopFit.locale.ShowMinimapIconTooltip = "|cffffffffCheck to show an icon on the border of your minimap for quick access to TopFit's settings."
    TopFit.locale.ShowTooltipScores = "Show set values in tooltip"
    TopFit.locale.ShowTooltipScoresTooltip = "|cffffffffCheck to show your sets' scores for an item in the item's tooltip."
    TopFit.locale.ShowTooltipComparison = "Show item comparison values in tooltip"
    TopFit.locale.ShowTooltipComparisonTooltip = "|cffffffffCheck to show values in your tooltip which indicate how much of an improvement an item is in comparison with your equipped items for each set."
    TopFit.locale.AutoUpdateSet = "Automatic update set"
    TopFit.locale.AutoUpdateSetTooltip = "|cffffffffThe set you choose here will be updated automatically whenever you loot an equippable item.\n\n|cffffff00Warning: |cffffffffThis option is intended to be used while levelling. If you have a character with dualspec, it might suddenly equip the set you specify here even if you activated your other specialization."
    TopFit.locale.None = "None"
    TopFit.locale.AutoUpdateOnRespec = "Update Set automatically when you change spec"
    TopFit.locale.AutoUpdateOnRespecTooltip = "|cffffffffThis will automatically calculate your selected auto-update set when you change specializations. Effectively, this will provide you with your correct gear whenever you respec."
    TopFit.locale.Debug = "Debug mode"
    TopFit.locale.DebugTooltip = "|cffffffffCheck to enable debug messages.\n\n|cffffff00Caution: |cffffffffThis will spam your chatframe, a lot!"

    -- ------------------------------------------------------------
    --  Plugins
    -- ------------------------------------------------------------
    -- setup
    TopFit.locale.NoSetTitle = "No sets available"
    TopFit.locale.NoSetDescription = "Configuration is not available until you have created at least one set."
    TopFit.locale.SetupWizardIntro = "|cffffffffWhat weight sets would you like to optimize your gear for?"
    TopFit.locale.SetupWizardSpec1 = "|cffffffffYour primary specialization is:|r %s"
    TopFit.locale.SetupWizardSpec2 = "|cffffffffYour secondary specialization is:|r %s"
    TopFit.locale.SetupWizardCreateNoSet = "Do nothing"

    -- stats
    TopFit.locale.Stats = "Stats"
    TopFit.locale.StatsTooltip = "See the stats for your currently selected set."
    TopFit.locale.StatsExplanation = "Every stat gets its own value, i.e. "..NORMAL_FONT_COLOR_CODE.."1 point of this stat"..FONT_COLOR_CODE_CLOSE.." is worth this much when calculating.\nA stat may also have a cap that TopFit will try to reach with first priority. It can be either "..NORMAL_FONT_COLOR_CODE.."hard"..FONT_COLOR_CODE_CLOSE.." (more points in this stat are wasted) or "..NORMAL_FONT_COLOR_CODE.."soft"..FONT_COLOR_CODE_CLOSE.." (more points in it are OK)."
    TopFit.locale.StatsUsage = "To change a stat's value, simply click on the stat name or value in the list below.\nTo remove a stat, set its value to "..NORMAL_FONT_COLOR_CODE.."0"..FONT_COLOR_CODE_CLOSE.."."
    TopFit.locale.StatsShowTooltip = "Include set in tooltip"
    TopFit.locale.StatsShowTooltipTooltip = "Check to show this set in item comparison tooltips when that option is enabled."
    TopFit.locale.StatsEnableDualWield = "Calculate with dual-wield"
    TopFit.locale.StatsEnableDualWieldTooltip = "Check to calculate this set with dualwielding in mind even if your current spec does not allow you to. If left off, the set will be calculated with your current spec in mind."
    TopFit.locale.StatsEnableTitansGrip = "Calculate with Titan's Grip"
    TopFit.locale.StatsEnableTitansGripTooltip = "Check to calculate this set with Titan's Grip in mind even if your current spec does not include it. If left off, the set will be calculated with your current spec in mind."
    TopFit.locale.StatsForceArmorType = "Force Armor Type"
    TopFit.locale.StatsForceArmorTypeTooltip = "After reaching character level 50, only armor that counts towards your armor specialization will be equipped in the appropriate slots."
    TopFit.locale.StatsSetPiece = "Set Piece"
    TopFit.locale.StatsHeaderName = "Name"
    TopFit.locale.StatsHeaderValue = "Value"
    TopFit.locale.StatsHeaderCap = "Cap"
    TopFit.locale.StatsPanelLabel = "Weights and Caps"
    TopFit.locale.StatsAdd = "Add stat ..."
    TopFit.locale.StatsSet = "Set: "
    TopFit.locale.StatsCapSoft = "Soft"
    TopFit.locale.StatsCapHard = "Hard"
    TopFit.locale.StatsCategoryBasic = "Basic Attributes"
    TopFit.locale.StatsCategoryMelee = "Physical"
    TopFit.locale.StatsCategoryCaster = "Caster"
    TopFit.locale.StatsCategoryDefensive = "Defensive"
    TopFit.locale.StatsCategoryHybrid = "Hybrid"
    TopFit.locale.StatsCategoryMisc = "Misc"
    TopFit.locale.StatsCategoryResistances = "Resistances"
    TopFit.locale.StatsCategoryArmorTypes = "Armor Types"

    TopFit.locale.SelectSpecHeader = "Assign Specialization"
    TopFit.locale.NoSpecSelected = "No Specialization"

    -- virtual items
    TopFit.locale.VirtualItems = "Virtual Items"
    TopFit.locale.VirtualItemsTooltip = "Virtual Items are used to calculate your optimal gear with items you do not currently have in your inventory."
    TopFit.locale.IncludeVI = "Include virtual items in calculation"
    TopFit.locale.IncludeVITooltip = "Check this to use your virtual items when calculating."
    TopFit.locale.VIExplanation = "This is useful e.g. if you intend to buy a certain item and want to see what your gear will be once you can use it.\n\nWhen virtual items are included in the calculation, a set may not be saved with the Blizzard Gear Manager.\nIf you want to be able to save your set, disable the checkbox below."
    TopFit.locale.VIUsage = "Paste an item link or an item ID in the edit box below and press <Enter> to add that item to your virtual items.\nTo remove an item, simply right-click on its icon in the list."
    TopFit.locale.VIAddItem = "Add an item to the list"
    TopFit.locale.VIItemNotFound = "Item not found."
    TopFit.locale.VIErrorNotEquippable = "%s could not be added as it seems to be no equippable item."
    TopFit.locale.VIErrorNoSet = "Please select or create a set before adding virtual items to it."

    -- utilities
    TopFit.locale.Utilities = "Import / Export"
    TopFit.locale.UtilitiesTooltip = "Click here to import or export your TopFit or Pawn gear sets."
    TopFit.locale.ImportLabel = "Import from string"
    TopFit.locale.UtilitiesDefaultText = "Paste your import string from Pawn or TopFit here:"
    TopFit.locale.UtilitiesErrorStringParse = "Error! String could not be parsed."
    TopFit.locale.UtilitiesErrorSetExists = "Error! A set with this name already exists."
    TopFit.locale.UtilitiesNoticeImported = "Import of %s succeeded."

    -- help system
    TopFit.locale.HelpSetTabs = "You can find your available TopFit sets here.\n\nClick the plus button to add a new set, optionally using presets or importing from Pawn or TopFit."
    TopFit.locale.HelpSidebarPlugins = "Select a plugin from this list.\n\nEvery plugin has a unique panel that is directly tied to your currently selected set."
    TopFit.locale.HelpSidebarCalculate = "Click the calculate button to update the currently selected set."
    TopFit.locale.HelpContentPanel = "This is the main configuration area.\n\nPlugins display their data and options here."

    TopFit.locale.ItemScan = {}
    TopFit.locale.ItemScan.PercentBonusTrigger = "Equip: Amplifies your Critical Strike damage and healing, Haste, Mastery, and Spirit by "
end
