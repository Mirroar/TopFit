local addonName, ns, _ = ...

local Plugin = ns.class()
ns.Plugin = Plugin

-- creates a new, empty plugin object
-- not advised, this class is meant to be inherited from by different plugins
function Plugin:construct(name)
    self.hasConfigPanel = false
    self.configButton = nil
    self.configPanel = nil
    self:SetName(name or 'Unnamed Plugin')
    self.tooltipText = nil
    self.buttonTexture = nil
    self.roleIdentifier = nil
    self.panelHeaderText = nil
    self.panelIconTexture = nil
    self.panelDescription = nil

    if not ns.currentPlugins then
        ns.currentPlugins = {}
    end
    tinsert(ns.currentPlugins, self)
    if ns.IsInitialized() then
        self:Initialize()
    end
end

-- initialize plugin data - called on plugin creation
function Plugin:Initialize()
    -- empty by default, should be overridden if the plugin needs initialization
    -- this function exists mostly so plugin authors don't have to worry about calling the default plugin constructor
    -- and to make sure TopFit is fully initialized by the time any plugins get initialized
end

-- register a tab in TopFit's config frame for use by this plugin
function Plugin:RegisterConfigPanel()
    self.hasConfigPanel = true
    if ns.ui.IsConfigFrameInitialized() then
        self:CreateConfigPanel()
    end
end

function Plugin:CreateConfigPanel()
    if self.hasConfigPanel then
        self.configButton, self.configPanel = ns.ui.CreateConfigPanel()

        self.configPanel.OnUpdate = function(frame)
            if self.OnShow then
                self:OnShow()
            end
        end

        if self.configButton then
            self:UpdateConfigButton()
            self:UpdateConfigPanel()

            self:InitializeUI()
        end
    end
end

-- refreshes data on this plugin's config button
function Plugin:UpdateConfigButton()
    if self.configButton then
        ns.ui.SetSidebarButtonData(self.configButton, self.name, self.tooltipText, self.buttonTexture, self.roleIdentifier)
    end
end

-- refreshes data on this plugin's config panel
function Plugin:UpdateConfigPanel()
    if self.configPanel then
        ns.ui.SetHeaderTitle(self.configPanel, self.panelHeaderText or self.name)
        ns.ui.SetHeaderIcon(self.configPanel, self.panelIconTexture or self.buttonTexture)
        ns.ui.SetHeaderDescription(self.configPanel, self.panelDescription or self.tooltipText)
    end
end

-- set the name of this plugin
function Plugin:SetName(name)
    self.AssertArgumentType(name, 'string')

    self.name = name
    if self.hasConfigPanel then
        self:UpdateConfigButton()
    end
end

-- get the name of this plugin
function Plugin:GetName()
    return self.name
end

-- set this plugin's tooltip text
function Plugin:SetTooltipText(text)
    self.AssertArgumentType(text, 'string')

    self.tooltipText = text
    if self.hasConfigPanel then
        self:UpdateConfigButton()
    end
end

-- initialize this plugin's UI elements
function Plugin:InitializeUI()
    -- empty by default, should be overridden if the plugin registers a config panel
end

-- returns this plugin's config panel frame, if a config panel has been registered
function Plugin:GetConfigPanel()
    return self.configPanel
end

-- set this plugin's config button texture
function Plugin:SetButtonTexture(texture)
    self.AssertArgumentType(texture, 'string')

    self.buttonTexture = texture
end