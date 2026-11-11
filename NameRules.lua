local function validateFamilyName(value)
    if type(value) ~= "string" then
        return nil, "Family name must be text."
    end
    if #value > 50 then
        return nil, "Family name must be 50 characters or fewer."
    end
    if value == "" then
        return value
    end

    local firstCharacter = string.byte(value, 1)
    if firstCharacter < 65 or firstCharacter > 90 then
        return nil, "Family name must start with an uppercase ASCII letter."
    end
    for index = 2, #value do
        local character = string.byte(value, index)
        local isLetter = (character >= 65 and character <= 90)
            or (character >= 97 and character <= 122)
        if not isLetter then
            return nil, "Family names may contain ASCII letters only."
        end
    end
    return value
end

FamilyNamesNameRules = {
    ValidateFamilyName = validateFamilyName,
}