local addonName, ns, _ = ...

local ImportPlugin = ns.class(ns.Plugin)
ns.ImportPlugin = ImportPlugin

-- creates a new ImportPlugin object
function ImportPlugin:Initialize()
    self:SetName(TopFit.locale.Utilities)
    self:SetTooltipText(TopFit.locale.UtilitiesTooltip)
    self:SetButtonTexture("Interface\\Icons\\INV_Pet_RatCage")
    self:RegisterConfigPanel()
end

-- initializes this plugin's UI elements
function ImportPlugin:InitializeUI()
    local frame = self:GetConfigPanel()

    local function FocusGained(self)
        self:HighlightText()
    end
    local function Reset(self)
        self:SetText(TopFit.locale.UtilitiesDefaultText)
        self:ClearFocus()
    end
    local function Accept(self)
        local text = self:GetText()
        if text and text ~= "" and text ~= TopFit.locale.UtilitiesDefaultText then
            -- try importing this string
            ImportString(text)
        end
        self:SetText(TopFit.locale.UtilitiesDefaultText)
        self:ClearFocus()
    end

    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -4)
    title:SetText(TopFit.locale.Utilities)

    local explain = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    explain:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -10, -8)
    explain:SetPoint("RIGHT", frame, -4, 0)
    explain:SetHeight(55)
    explain:SetNonSpaceWrap(true)
    explain:SetJustifyH("LEFT")
    explain:SetJustifyV("TOP")
    explain:SetText(TopFit.locale.UtilitiesTooltip)     -- TODO: offer more useful text

    local importBox = CreateFrame("EditBox", "TopFitUtilities_importBox", frame)
    importBox:SetPoint("TOPLEFT", explain, "BOTTOMLEFT", 0, -4)
    importBox:SetPoint("BOTTOMRIGHT", explain, "RIGHT", 0, -80)
    importBox:SetFontObject(GameFontNormalSmall)
    importBox:SetTextInsets(8, 8, 8, 8)
    importBox:SetMultiLine(true)
    importBox:SetAutoFocus(false)
    importBox:SetText(TopFit.locale.UtilitiesDefaultText)
    importBox:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4}
    })
    importBox:SetBackdropColor(.1, .1, .1, .8)
    importBox:SetBackdropBorderColor(.5, .5, .5)
    local importBoxLabel = importBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    importBoxLabel:SetPoint("BOTTOMLEFT", importBox, "TOPLEFT", 16, 0)
    importBoxLabel:SetText("Import")

    importBox:SetScript("OnEditFocusGained", FocusGained)
    importBox:SetScript("OnEnterPressed", Accept)
    importBox:SetScript("OnEscapePressed", Reset)

    local exportBox = CreateFrame("EditBox", "TopFitUtilities_exportBox", frame)
    self.exportBox = exportBox
    exportBox:SetPoint("TOPLEFT", importBox, "BOTTOMLEFT", 0, -10)
    exportBox:SetPoint("BOTTOMRIGHT", explain, "RIGHT", 0, -200)
    exportBox:SetFontObject(GameFontNormalSmall)
    exportBox:SetTextInsets(8, 8, 8, 8)
    exportBox:SetMultiLine(true)
    exportBox:SetAutoFocus(false)
    exportBox:SetText(TopFit.locale.UtilitiesDefaultText)
    exportBox:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4}
    })
    exportBox:SetBackdropColor(.1, .1, .1, .8)
    exportBox:SetBackdropBorderColor(.5, .5, .5)
    local exportBoxLabel = exportBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    exportBoxLabel:SetPoint("BOTTOMLEFT", exportBox, "TOPLEFT", 16, 0)
    exportBoxLabel:SetText("Export")

    exportBox:SetScript("OnEditFocusGained", FocusGained)
    exportBox:SetScript("OnEnterPressed", Accept)
    exportBox:SetScript("OnEscapePressed", Reset)

    local pwned = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    self.pwned = pwned
    pwned:SetPoint("TOPLEFT", exportBox, "BOTTOMLEFT", 0, -10)
    pwned:SetPoint("RIGHT", frame, -4, 0)
    pwned:SetHeight(55)
    pwned:SetNonSpaceWrap(true)
    pwned:SetJustifyH("LEFT")
    pwned:SetJustifyV("TOP")

    -- register events
    TopFit.RegisterCallback("TopFit_utilities", "OnShow", function(event, id)
        if (id == pluginId) then
        end
    end)

    TopFit.RegisterCallback("TopFit_utilities", "OnSetChanged", function(event, setId)
        if (setId) then
            exportBox:SetText(GenerateExportString("TopFit", "1"))
            pwned:SetText(string.format(TopFit.locale.GearScore, TopFit:CalculateGearScore() or "?"))
        else
            -- no set selected, disable inputs
        end
    end)
end

function ImportPlugin:OnShow()
    self.exportBox:SetText(GenerateExportString("TopFit", "1"))
    self.pwned:SetText(string.format(TopFit.locale.GearScore, TopFit:CalculateGearScore() or "?"))
end

function ImportPlugin:OnSetChanged()
    self.exportBox:SetText(GenerateExportString("TopFit", "1"))
    self.pwned:SetText(string.format(TopFit.locale.GearScore, TopFit:CalculateGearScore() or "?"))
end

-- create plugin and register with TopFit
ImportPlugin()