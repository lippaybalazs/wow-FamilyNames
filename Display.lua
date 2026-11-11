local addon = _G.FamilyNamesAddon

local presenceChanges = {}
local displayNameToOriginalName = {}
local rosterSnapshot
local rosterFrameHooked
local guildUIEventFrame
local playerLinkWrapped

local chatEvents = {
    "CHAT_MSG_SAY",
    "CHAT_MSG_YELL",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_WHISPER_INFORM",
    "CHAT_MSG_GUILD",
    "CHAT_MSG_OFFICER",
    "CHAT_MSG_PARTY",
    "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_RAID",
    "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_RAID_WARNING",
    "CHAT_MSG_INSTANCE_CHAT",
    "CHAT_MSG_INSTANCE_CHAT_LEADER",
    "CHAT_MSG_CHANNEL",
    "CHAT_MSG_EMOTE",
    "CHAT_MSG_TEXT_EMOTE",
}

local function ensurePlayerLinkTargetMapping()
    if playerLinkWrapped or type(GetPlayerLink) ~= "function" then
        return
    end

    local originalGetPlayerLink = GetPlayerLink
    GetPlayerLink = function(characterName, linkDisplayText, lineID, chatType, chatTarget, ...)
        local originalName = type(characterName) == "string"
            and displayNameToOriginalName[string.lower(characterName)]
        local originalTarget = type(chatTarget) == "string"
            and displayNameToOriginalName[string.lower(chatTarget)]
        return originalGetPlayerLink(
            originalName or characterName,
            linkDisplayText,
            lineID,
            chatType,
            originalTarget or chatTarget,
            ...
        )
    end
    playerLinkWrapped = true
end

local function filterPlayerMessage(_, _, message, author, ...)
    if type(message) ~= "string" or type(author) ~= "string" or author == "" then
        return false
    end
    local familyName, isKnown = addon.GetFamilyName(author)
    if not isKnown then
        return false
    end
    if familyName == "" then
        return false
    end

    local characterName = author:match("^([^%-]+)")
    local label = addon.FormatDisplayName(characterName, familyName)
    displayNameToOriginalName[string.lower(label)] = author
    ensurePlayerLinkTargetMapping()
    local trailingArguments = {...}
    return false, message, label, unpack(trailingArguments, 1, select("#", ...))
end

local function stripPlayerLinks(message)
    message = message:gsub("|Hplayer:.-|h(.-)|h", "%1")
    message = message:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    return message
end

local function matchesMessageTemplate(message, template)
    if type(template) ~= "string" or template == "" then
        return false
    end
    local marker = "\1"
    local pattern = template:gsub("%%s", marker)
    pattern = pattern:gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
    pattern = pattern:gsub(marker, ".-")
    return message:match("^" .. pattern .. "$") ~= nil
end

local function isPresenceNotification(message)
    local plainMessage = stripPlayerLinks(message)
    if matchesMessageTemplate(plainMessage, ERR_FRIEND_ONLINE_SS)
        or matchesMessageTemplate(plainMessage, ERR_FRIEND_OFFLINE_S) then
        return true
    end
    return plainMessage:find("has come online", 1, true) ~= nil
        or plainMessage:find("has gone offline", 1, true) ~= nil
end

local function findVisiblePlayerName(message, characterName, expectedKey)
    local linkStart = 1
    while true do
        local hyperlinkStart = message:find("|Hplayer:", linkStart, true)
        if not hyperlinkStart then
            break
        end
        local targetStart = hyperlinkStart + #"|Hplayer:"
        local targetEnd = message:find("|h", targetStart, true)
        if not targetEnd then
            break
        end
        local target = message:sub(targetStart, targetEnd - 1)
        local visibleStart = targetEnd + 2
        local visibleEnd = message:find("|h", visibleStart, true)
        if not visibleEnd then
            break
        end
        if addon.GetFamilyNameKey(target) == expectedKey then
            return visibleStart, visibleEnd - 1, message:sub(visibleStart, visibleEnd - 1)
        end
        linkStart = visibleEnd + 2
    end

    local startPosition, endPosition = message:find(characterName, 1, true)
    if startPosition then
        return startPosition, endPosition, message:sub(startPosition, endPosition)
    end
end

local function filterPresenceMessage(_, _, message, ...)
    if type(message) ~= "string" or not isPresenceNotification(message) then
        return false
    end
    local candidateByKey = {}
    local knownNames = addon.GetKnownFamilyNames and addon.GetKnownFamilyNames() or {}
    for key, entry in pairs(knownNames) do
        if entry.name and entry.value and entry.value ~= "" then
            candidateByKey[key] = {name = entry.name, familyName = entry.value}
        end
    end
    for key, change in pairs(presenceChanges) do
        candidateByKey[key] = change
    end
    local candidates = {}
    for key, change in pairs(candidateByKey) do
        candidates[#candidates + 1] = {key = key, change = change}
    end
    table.sort(candidates, function(left, right)
        return #left.change.name > #right.change.name
    end)

    for index = 1, #candidates do
        local candidate = candidates[index]
        local change = candidate.change
        local startPosition, endPosition, visibleName = findVisiblePlayerName(message, change.name, candidate.key)
        if startPosition then
            presenceChanges[candidate.key] = nil
            local familyName = change.familyName
            if change.online then
                familyName = select(1, addon.GetFamilyName(change.name))
            end
            if familyName and familyName ~= "" then
                local label = addon.FormatDisplayName(change.name, familyName)
                local plainVisibleName = visibleName:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                if plainVisibleName:sub(1, 1) == "[" and plainVisibleName:sub(-1) == "]" then
                    label = "[" .. label .. "]"
                end
                message = message:sub(1, startPosition - 1) .. label .. message:sub(endPosition + 1)
                return false, message, ...
            end
            return false
        end
    end
    return false
end

local function markPresenceChange(name, isOnline, familyName)
    local key = addon.GetFamilyNameKey(name)
    if not key then
        return
    end
    local change = {name = name, online = isOnline, familyName = familyName}
    presenceChanges[key] = change
    C_Timer.After(5, function()
        if presenceChanges[key] == change then
            presenceChanges[key] = nil
        end
    end)
end

local function captureRosterSnapshot()
    rosterSnapshot = {}
    local knownNames = addon.GetKnownFamilyNames()
    for key, entry in pairs(knownNames) do
        rosterSnapshot[key] = entry.value
    end
end

local function findRosterNameText(button, fullName)
    local shortName = fullName:match("^([^%-]+)")
    local displayedName = Ambiguate and Ambiguate(fullName, "guild") or shortName
    local candidates = {displayedName, shortName, fullName}
    for column = 1, 4 do
        local fontString = button["string" .. column]
        if fontString and fontString.GetText then
            local text = fontString:GetText()
            for index = 1, #candidates do
                if text == candidates[index] then
                    return fontString
                end
            end
        end
    end
    return button.name
end

local function updateVisibleRosterRows()
    if not rosterSnapshot or not GuildRosterFrame or not GuildRosterFrame:IsShown()
        or not GetGuildRosterInfo then
        return
    end

    local rosterContainer = GuildRosterContainer or GuildRosterFrameScrollFrame
    local buttons = rosterContainer and rosterContainer.buttons
    if not buttons then
        return
    end

    for _, button in ipairs(buttons) do
        local guildIndex = button.guildIndex
        local memberName
        if guildIndex then
            memberName = GetGuildRosterInfo(guildIndex)
        end
        local nameText = memberName and findRosterNameText(button, memberName)
        if nameText and nameText.SetText and memberName then
            local shortName = memberName:match("^([^%-]+)")
            local key = addon.GetFamilyNameKey(shortName)
            local familyName = key and rosterSnapshot[key]
            if familyName and familyName ~= "" then
                nameText:SetText(addon.FormatDisplayName(shortName, familyName))
            else
                nameText:SetText(shortName)
            end
        end
    end

    if GuildMemberDetailFrame and GuildMemberDetailFrame.IsShown and GuildMemberDetailFrame:IsShown()
        and GuildMemberDetailName and GuildMemberDetailName.SetText and GetGuildRosterSelection then
        local selectedIndex = GetGuildRosterSelection()
        if selectedIndex and selectedIndex > 0 then
            local memberName = GetGuildRosterInfo(selectedIndex)
            if memberName then
                local shortName = memberName:match("^([^%-]+)")
                local key = addon.GetFamilyNameKey(shortName)
                local familyName = key and rosterSnapshot[key]
                if familyName and familyName ~= "" then
                    GuildMemberDetailName:SetText(addon.FormatDisplayName(shortName, familyName))
                else
                    GuildMemberDetailName:SetText(shortName)
                end
            end
        end
    end
end

local function applyRosterSnapshotAfterLayout()
    if C_Timer and C_Timer.After then
        C_Timer.After(0, updateVisibleRosterRows)
    else
        updateVisibleRosterRows()
    end
end

local function hookGuildRosterFrame()
    if rosterFrameHooked or not GuildRosterFrame or not GuildRosterFrame.HookScript then
        return
    end
    rosterFrameHooked = true
    GuildRosterFrame:HookScript("OnShow", function()
        captureRosterSnapshot()
        applyRosterSnapshotAfterLayout()
    end)
    GuildRosterFrame:HookScript("OnHide", function()
        rosterSnapshot = nil
    end)

    local rosterContainer = GuildRosterContainer or GuildRosterFrameScrollFrame
    if rosterContainer and rosterContainer.HookScript then
        rosterContainer:HookScript("OnVerticalScroll", applyRosterSnapshotAfterLayout)
    end
    if hooksecurefunc then
        for _, functionName in ipairs({"GuildRoster_Update", "GuildRosterFrame_Update"}) do
            if type(_G[functionName]) == "function" then
                hooksecurefunc(functionName, function()
                    if rosterSnapshot then
                        updateVisibleRosterRows()
                    end
                end)
            end
        end
    end
end

local function replaceFirstPlainText(value, target, replacement)
    local startPosition, endPosition = value:find(target, 1, true)
    if not startPosition then
        return value
    end
    return value:sub(1, startPosition - 1) .. replacement .. value:sub(endPosition + 1)
end

local function getVisibleGroupInvitePopup()
    if StaticPopup_FindVisible then
        local dialog = StaticPopup_FindVisible("PARTY_INVITE")
        if dialog then
            return dialog
        end
    end
    for index = 1, STATICPOPUP_NUMDIALOGS or 4 do
        local dialog = _G["StaticPopup" .. index]
        if dialog and dialog.IsShown and dialog:IsShown() and dialog.which == "PARTY_INVITE" then
            return dialog
        end
    end
end

local function replaceGroupInviteName(inviterName, familyName)
    C_Timer.After(0, function()
        local dialog = getVisibleGroupInvitePopup()
        if not dialog or not dialog.GetName then
            return
        end
        local text = _G[dialog:GetName() .. "Text"] or dialog.text
        if not text or not text.GetText or not text.SetText then
            return
        end
        local currentText = text:GetText()
        if type(currentText) ~= "string" then
            return
        end

        local characterName = inviterName:match("^([^%-]+)")
        local label = addon.FormatDisplayName(characterName, familyName)
        local updatedText = replaceFirstPlainText(currentText, inviterName, label)
        if updatedText == currentText then
            updatedText = replaceFirstPlainText(currentText, characterName, label)
        end
        if updatedText ~= currentText then
            text:SetText(updatedText)
            if StaticPopup_Resize then
                StaticPopup_Resize(dialog, "PARTY_INVITE")
            end
        end
    end)
end

function addon.OnGuildMemberOnline(name)
    markPresenceChange(name, true)
end

function addon.OnGuildMemberOffline(name, familyName)
    markPresenceChange(name, false, familyName)
end

function addon.OnLocalDataResetDisplay()
    presenceChanges = {}
    rosterSnapshot = nil
end

function addon.OnPartyInviteRequest(inviterName)
    local familyName, isKnown = addon.GetFamilyName(inviterName)
    if not isKnown then
        return
    end
    if familyName ~= "" then
        replaceGroupInviteName(inviterName, familyName)
    end
end

function addon.InitializeDisplay()
    if ChatFrame_AddMessageEventFilter then
        for index = 1, #chatEvents do
            ChatFrame_AddMessageEventFilter(chatEvents[index], filterPlayerMessage)
        end
        ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filterPresenceMessage)
    end

    hookGuildRosterFrame()
    if not guildUIEventFrame then
        guildUIEventFrame = CreateFrame("Frame")
        guildUIEventFrame:RegisterEvent("ADDON_LOADED")
        guildUIEventFrame:SetScript("OnEvent", function(_, _, loadedAddon)
            if loadedAddon == "Blizzard_GuildUI" then
                hookGuildRosterFrame()
            end
        end)
    end
end