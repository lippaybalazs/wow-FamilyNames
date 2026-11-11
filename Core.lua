local addonName = ...
local addon = _G.FamilyNamesAddon or {}
_G.FamilyNamesAddon = addon

local MESSAGE_PREFIX = "FamilyNames"
local EMPTY_FAMILY_NAME = ""
local DEFAULT_PATTERN = "{family} {character}"
local BROADCAST_INTERVAL = 300

local knownFamilyNames = {}
local onlineMembers = {}
local previousOnlineMembers = {}
local localCharacterKey
local currentGuildName
local hasGuildRosterSnapshot = false
local initialized = false
local periodicBroadcastScheduled = false

local function characterKey(name)
    if type(name) ~= "string" or name == "" then
        return nil
    end
    local shortName = name:match("^([^%-]+)")
    return shortName and string.lower(shortName) or nil
end

local function cacheFamilyName(name, value)
    local key = characterKey(name)
    if not key then
        return
    end
    local characterName = name:match("^([^%-]+)") or name
    for cachedName in pairs(FamilyNamesDB.familyNameCache) do
        if characterKey(cachedName) == key then
            FamilyNamesDB.familyNameCache[cachedName] = nil
        end
    end
    FamilyNamesDB.familyNameCache[characterName] = value
    knownFamilyNames[key] = {value = value, name = characterName}
end

local function getCurrentGuildName()
    if not IsInGuild or not IsInGuild() then
        return nil
    end
    local guildName = GetGuildInfo and GetGuildInfo("player")
    return guildName ~= "" and guildName or nil
end

local function showError(message)
    if UIErrorsFrame and UIErrorsFrame.AddMessage then
        UIErrorsFrame:AddMessage(message, 1, 0.15, 0.15, 1, 5)
    elseif DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(message)
    end
end

local function sendGuildMessage(message)
    if not initialized or not currentGuildName or not SendAddonMessage then
        return false
    end
    SendAddonMessage(MESSAGE_PREFIX, message, "GUILD")
    return true
end

local function getFamilyName(name)
    local key = characterKey(name)
    if not key then
        return nil, false
    end
    local entry = knownFamilyNames[key]
    if entry then
        return entry.value, true
    end
    return nil, false
end

local function isOnlineGuildMember(name)
    local key = characterKey(name)
    return key ~= nil and (onlineMembers[key] ~= nil or (key == localCharacterKey and currentGuildName ~= nil))
end

local function sendFamilyName()
    if currentGuildName then
        sendGuildMessage("V:" .. FamilyNamesDB.familyName)
    end
end

local function schedulePeriodicBroadcast()
    if periodicBroadcastScheduled or not C_Timer or not C_Timer.After then
        return
    end
    periodicBroadcastScheduled = true
    C_Timer.After(BROADCAST_INTERVAL, function()
        periodicBroadcastScheduled = false
        if initialized then
            sendFamilyName()
            schedulePeriodicBroadcast()
        end
    end)
end

local function announceToGuild()
    if not currentGuildName then
        return
    end
    sendFamilyName()
    if GuildRoster then
        GuildRoster()
    end
end

local function updateGuildRoster()
    local members = {}
    if currentGuildName and GetNumGuildMembers and GetGuildRosterInfo then
        local count = GetNumGuildMembers()
        for index = 1, count do
            local name, _, _, _, _, _, _, _, isOnline = GetGuildRosterInfo(index)
            local key = characterKey(name)
            if key then
                members[key] = {name = name:match("^([^%-]+)"), online = not not isOnline}
            end
        end
    end

    previousOnlineMembers = onlineMembers
    onlineMembers = {}
    for key, member in pairs(members) do
        if member.online then
            onlineMembers[key] = member
            if not previousOnlineMembers[key] then
                if hasGuildRosterSnapshot and key ~= localCharacterKey and addon.OnGuildMemberOnline then
                    addon.OnGuildMemberOnline(member.name)
                end
            end
        elseif previousOnlineMembers[key] and previousOnlineMembers[key].online then
            if hasGuildRosterSnapshot and addon.OnGuildMemberOffline then
                addon.OnGuildMemberOffline(member.name, knownFamilyNames[key] and knownFamilyNames[key].value)
            end
        end
    end
    hasGuildRosterSnapshot = true

    if addon.OnGuildRosterUpdated then
        addon.OnGuildRosterUpdated()
    end
end

local function receiveFamilyName(sender, value)
    local key = characterKey(sender)
    if not key or key == localCharacterKey then
        return
    end
    local normalized = FamilyNamesNameRules.ValidateFamilyName(value)
    if not normalized then
        return
    end
    cacheFamilyName(sender, normalized)
end

local function handleAddonMessage(prefix, message, distribution, sender)
    if prefix ~= MESSAGE_PREFIX or distribution ~= "GUILD" or not currentGuildName then
        return
    end
    local senderKey = characterKey(sender)
    if not senderKey or senderKey == localCharacterKey then
        return
    end

    if message:sub(1, 2) == "V:" then
        receiveFamilyName(sender, message:sub(3))
    end
end

local function initializeDatabase()
    if type(FamilyNamesDB) ~= "table" then
        FamilyNamesDB = {}
    end
    local familyName = FamilyNamesDB.familyName
    if familyName == nil then
        familyName = EMPTY_FAMILY_NAME
    end
    local normalized, validationError = FamilyNamesNameRules.ValidateFamilyName(familyName)
    if not normalized then
        showError("Family Names: saved family name is invalid. Using an empty name.")
        normalized = EMPTY_FAMILY_NAME
    end
    FamilyNamesDB.familyName = normalized

    local savedCache = FamilyNamesDB.familyNameCache
    if type(savedCache) ~= "table" then
        savedCache = {}
    end
    local normalizedCache = {}
    knownFamilyNames = {}
    for savedCharacterName, cachedValue in pairs(savedCache) do
        local key = characterKey(savedCharacterName)
        local cachedFamilyName = FamilyNamesNameRules.ValidateFamilyName(cachedValue)
        if key and cachedFamilyName then
            local characterName = savedCharacterName:match("^([^%-]+)") or savedCharacterName
            normalizedCache[characterName] = cachedFamilyName
            knownFamilyNames[key] = {
                value = cachedFamilyName,
                name = characterName,
            }
        end
    end
    FamilyNamesDB.familyNameCache = normalizedCache

    local pattern = FamilyNamesDB.displayPattern
    if type(pattern) ~= "string" or not string.find(pattern, "{family}", 1, true)
        or not string.find(pattern, "{character}", 1, true) then
        if pattern ~= nil then
            showError("Family Names: saved display pattern is invalid. Using the default format.")
        end
        pattern = DEFAULT_PATTERN
    end
    FamilyNamesDB.displayPattern = pattern
    FamilyNamesDB.lastValidationError = nil
    localCharacterKey = characterKey(UnitName("player"))
    if localCharacterKey then
        cacheFamilyName(UnitName("player"), normalized)
    end
end

function addon.GetFamilyName(name)
    return getFamilyName(name)
end

function addon.GetFamilyNameKey(name)
    return characterKey(name)
end

function addon.IsOnlineGuildMember(name)
    return isOnlineGuildMember(name)
end

function addon.GetDisplayPattern()
    return FamilyNamesDB and FamilyNamesDB.displayPattern or DEFAULT_PATTERN
end

function addon.FormatDisplayName(name, familyName)
    if type(name) == "string" and type(familyName) == "string"
        and string.lower(name) == string.lower(familyName) then
        return name
    end
    local pattern = addon.GetDisplayPattern()
    local family = familyName
    return (pattern:gsub("{family}", function() return family end)
        :gsub("{character}", function() return name end))
end

function addon.SaveFamilyName(value)
    local normalized, validationError = FamilyNamesNameRules.ValidateFamilyName(value)
    if not normalized then
        showError("Family Names: " .. (validationError or "invalid family name"))
        return false
    end
    FamilyNamesDB.familyName = normalized
    if localCharacterKey then
        cacheFamilyName(UnitName("player"), normalized)
    end
    sendFamilyName()
    return true
end

function addon.SaveDisplayPattern(pattern)
    if type(pattern) ~= "string" or not string.find(pattern, "{family}", 1, true)
        or not string.find(pattern, "{character}", 1, true) then
        showError("Family Names: display format must contain {family} and {character}.")
        return false
    end
    FamilyNamesDB.displayPattern = pattern
    return true
end

function addon.ResetLocalData()
    for key in pairs(FamilyNamesDB) do
        FamilyNamesDB[key] = nil
    end
    FamilyNamesDB.familyName = EMPTY_FAMILY_NAME
    FamilyNamesDB.familyNameCache = {}
    FamilyNamesDB.displayPattern = DEFAULT_PATTERN
    knownFamilyNames = {}
    if localCharacterKey then
        cacheFamilyName(UnitName("player"), EMPTY_FAMILY_NAME)
    end
    sendFamilyName()
    if addon.OnLocalDataResetUI then
        addon.OnLocalDataResetUI()
    end
    if addon.OnLocalDataResetDisplay then
        addon.OnLocalDataResetDisplay()
    end
end

function addon.GetSavedFamilyName()
    return FamilyNamesDB and FamilyNamesDB.familyName or EMPTY_FAMILY_NAME
end

function addon.Initialize()
    if initialized then
        return
    end
    initializeDatabase()
    initialized = true
    if RegisterAddonMessagePrefix then
        RegisterAddonMessagePrefix(MESSAGE_PREFIX)
    end
    if addon.InitializeDisplay then
        addon.InitializeDisplay()
    end
    if addon.InitializeOptions then
        addon.InitializeOptions()
    end
end

local function onPlayerLogin()
    localCharacterKey = characterKey(UnitName("player"))
    currentGuildName = getCurrentGuildName()
    if localCharacterKey then
        cacheFamilyName(UnitName("player"), FamilyNamesDB.familyName)
        if currentGuildName then
            onlineMembers[localCharacterKey] = {name = UnitName("player"), online = true}
        end
    end
    announceToGuild()
    schedulePeriodicBroadcast()
end

local function onPlayerGuildUpdate()
    local guildName = getCurrentGuildName()
    if guildName ~= currentGuildName then
        currentGuildName = guildName
        onlineMembers = {}
        previousOnlineMembers = {}
        hasGuildRosterSnapshot = false
        if localCharacterKey then
            cacheFamilyName(UnitName("player"), FamilyNamesDB.familyName)
            if currentGuildName then
                onlineMembers[localCharacterKey] = {name = UnitName("player"), online = true}
            end
        end
        announceToGuild()
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_GUILD_UPDATE")
eventFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
eventFrame:RegisterEvent("CHAT_MSG_ADDON")
eventFrame:RegisterEvent("PARTY_INVITE_REQUEST")
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon == addonName then
            addon.Initialize()
        end
    elseif event == "PLAYER_LOGIN" then
        if not initialized then
            addon.Initialize()
        end
        onPlayerLogin()
        if C_Timer and C_Timer.After then
            C_Timer.After(0, onPlayerGuildUpdate)
            C_Timer.After(1, onPlayerGuildUpdate)
        end
    elseif event == "PLAYER_GUILD_UPDATE" then
        onPlayerGuildUpdate()
    elseif event == "GUILD_ROSTER_UPDATE" then
        updateGuildRoster()
    elseif event == "CHAT_MSG_ADDON" then
        handleAddonMessage(...)
    elseif event == "PARTY_INVITE_REQUEST" then
        if addon.OnPartyInviteRequest then
            addon.OnPartyInviteRequest(...)
        end
    end
end)

function addon.GetOnlineGuildMembers()
    return onlineMembers
end

function addon.GetKnownFamilyNames()
    return knownFamilyNames
end

function addon.SendGuildAddonMessage(message)
    return sendGuildMessage(message)
end