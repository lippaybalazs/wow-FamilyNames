local addon = _G.FamilyNamesAddon

local panel
local familyNameInput
local familyNameSaveButton
local displayPatternInput
local displayPatternSaveButton

local function createLabel(parent, text, point, x, y, template)
    local label = parent:CreateFontString(nil, "ARTWORK", template or "GameFontNormal")
    label:SetText(text)
    label:SetPoint(point, x, y)
    return label
end

local function createInput(parent, width, maxLetters)
    local input = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    input:SetSize(width, 20)
    input:SetAutoFocus(false)
    if maxLetters then
        input:SetMaxLetters(maxLetters)
    end
    input:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
    end)
    input:SetScript("OnEscapePressed", function(self)
        self:SetText("")
        self:ClearFocus()
        if self == familyNameInput then
            self:SetText(addon.GetSavedFamilyName())
            if familyNameSaveButton then
                familyNameSaveButton:Disable()
            end
        elseif self == displayPatternInput then
            self:SetText(addon.GetDisplayPattern())
            if displayPatternSaveButton then
                displayPatternSaveButton:Disable()
            end
        end
    end)
    return input
end

local function createSaveButton(parent, text, anchor, callback)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(110, 22)
    button:SetText(text)
    button:SetPoint("LEFT", anchor, "RIGHT", 12, 0)
    button:SetScript("OnClick", callback)
    return button
end

function addon.InitializeOptions()
    if panel or not InterfaceOptions_AddCategory then
        return
    end

    panel = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
    panel.name = "Family Names"
    panel:Hide()

    createLabel(panel, "Family Names", "TOPLEFT", 16, -16, "GameFontNormalLarge")
    createLabel(panel, "Account-wide family name", "TOPLEFT", 16, -58)
    familyNameInput = createInput(panel, 250, 512)
    familyNameInput:SetPoint("TOPLEFT", 16, -78)
    familyNameSaveButton = createSaveButton(panel, "Save", familyNameInput, function()
        if addon.SaveFamilyName(familyNameInput:GetText()) then
            familyNameInput:SetText(addon.GetSavedFamilyName())
            familyNameSaveButton:Disable()
        else
            familyNameSaveButton:Enable()
        end
    end)
    familyNameSaveButton:Disable()
    familyNameInput:SetScript("OnTextChanged", function(self)
        if self:GetText() == addon.GetSavedFamilyName() then
            familyNameSaveButton:Disable()
        else
            familyNameSaveButton:Enable()
        end
    end)

    createLabel(panel, "Display pattern", "TOPLEFT", 16, -132)
    createLabel(panel, "Must include {family} and {character}.", "TOPLEFT", 16, -150, "GameFontHighlightSmall")
    displayPatternInput = createInput(panel, 350)
    displayPatternInput:SetPoint("TOPLEFT", 16, -170)
    displayPatternSaveButton = createSaveButton(panel, "Save", displayPatternInput, function()
        if addon.SaveDisplayPattern(displayPatternInput:GetText()) then
            displayPatternInput:SetText(addon.GetDisplayPattern())
            displayPatternSaveButton:Disable()
        else
            displayPatternSaveButton:Enable()
        end
    end)
    displayPatternSaveButton:Disable()
    displayPatternInput:SetScript("OnTextChanged", function(self)
        if self:GetText() == addon.GetDisplayPattern() then
            displayPatternSaveButton:Disable()
        else
            displayPatternSaveButton:Enable()
        end
    end)

    local resetButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    resetButton:SetSize(140, 22)
    resetButton:SetPoint("TOPLEFT", 16, -218)
    resetButton:SetText("Reset Local Data")
    resetButton:SetScript("OnClick", function()
        StaticPopup_Show("FAMILY_NAMES_RESET_LOCAL_DATA")
    end)

    if StaticPopupDialogs then
        StaticPopupDialogs.FAMILY_NAMES_RESET_LOCAL_DATA = {
            text = "Reset the saved family name, display pattern, and cached guild character names on this client?",
            button1 = ACCEPT,
            button2 = CANCEL,
            OnAccept = function()
                addon.ResetLocalData()
            end,
            timeout = 0,
            whileDead = 1,
            hideOnEscape = 1,
        }
    end

    panel:SetScript("OnShow", function()
        familyNameInput:SetText(addon.GetSavedFamilyName())
        familyNameSaveButton:Disable()
        displayPatternInput:SetText(addon.GetDisplayPattern())
        displayPatternSaveButton:Disable()
    end)
    InterfaceOptions_AddCategory(panel)
end

function addon.OnLocalDataResetUI()
    if familyNameInput then
        familyNameInput:SetText(addon.GetSavedFamilyName())
        familyNameSaveButton:Disable()
    end
    if displayPatternInput then
        displayPatternInput:SetText(addon.GetDisplayPattern())
        displayPatternSaveButton:Disable()
    end
end
