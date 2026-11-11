local addonName = ...

local frame = CreateFrame("Frame")

frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(self, event)
    print("Hello World! " .. addonName .. " loaded.")
end)