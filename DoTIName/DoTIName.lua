local addonName, addon = ...

DoTINameDB = DoTINameDB or {}
DoTINameUsername = DoTINameUsername or ""

local function trim(s)
    return (s and s:match("^%s*(.-)%s*$")) or ""
end

local function GetSpecName()
    local specIndex = GetSpecialization()
    if specIndex then
        local _, name = GetSpecializationInfo(specIndex)
        return name or ""
    end
    return ""
end

local function SaveCharacter()
    local name = UnitName("player") or ""
    local level = UnitLevel("player") or 0
    local ilevel = select(2, GetAverageItemLevel()) or 0
    local class = select(2, UnitClass("player")) or ""
    local spec = GetSpecName()
    local username = DoTINameUsername or ""

    DoTINameDB[name] = {
        level = level,
        ilevel = math.floor(ilevel),
        class = class,
        spec = spec,
        username = username,
    }
end

local function BuildExportText()
    local lines = {}
    for name, data in pairs(DoTINameDB) do
        local line = string.format("%s %d %d %s %s %s", name, data.level or 0, data.ilevel or 0, data.class or "", data.spec or "", data.username or "")
        table.insert(lines, line)
    end
    table.sort(lines)
    return table.concat(lines, "\n")
end

local exportFrame
local function ShowExportWindow()
    if not exportFrame then
        exportFrame = CreateFrame("Frame", "DoTINameExportFrame", UIParent, "BasicFrameTemplateWithInset")
        exportFrame:SetSize(400, 300)
        exportFrame:SetPoint("CENTER")
        exportFrame:SetFrameStrata("DIALOG")

        exportFrame.title = exportFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        exportFrame.title:SetPoint("CENTER", exportFrame.TitleBg, "CENTER", 0, 0)
        exportFrame.title:SetText("DoTIName Export")

        local scrollFrame = CreateFrame("ScrollFrame", nil, exportFrame, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", 10, -30)
        scrollFrame:SetPoint("BOTTOMRIGHT", -30, 40)

        exportFrame.editBox = CreateFrame("EditBox", nil, scrollFrame)
        exportFrame.editBox:SetMultiLine(true)
        exportFrame.editBox:SetFontObject("ChatFontNormal")
        exportFrame.editBox:SetWidth(340)
        exportFrame.editBox:SetAutoFocus(false)
        exportFrame.editBox:SetScript("OnEscapePressed", exportFrame.editBox.ClearFocus)
        scrollFrame:SetScrollChild(exportFrame.editBox)

        exportFrame.close = CreateFrame("Button", nil, exportFrame, "GameMenuButtonTemplate")
        exportFrame.close:SetPoint("BOTTOM", 0, 10)
        exportFrame.close:SetSize(80, 25)
        exportFrame.close:SetText("Close")
        exportFrame.close:SetScript("OnClick", function() exportFrame:Hide() end)
    end

    exportFrame.editBox:SetText(BuildExportText())
    exportFrame.editBox:HighlightText()
    exportFrame:Show()
end

-- Slash command to set username
SLASH_DOTINAME1 = "/dotiname"
SlashCmdList["DOTINAME"] = function(msg)
    msg = trim(msg)
    if msg ~= "" then
        DoTINameUsername = msg
        print("DoTIName username set to:", DoTINameUsername)
        SaveCharacter()
    else
        if DoTINameUsername ~= "" then
            print("Current DoTIName username:", DoTINameUsername)
        else
            print("No DoTIName username set. Use /dotiname <name> to set one.")
        end
    end
end

-- Slash command to show export window
SLASH_DOTIEXPORT1 = "/dotiexport"
SlashCmdList["DOTIEXPORT"] = function()
    ShowExportWindow()
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    SaveCharacter()
end)
