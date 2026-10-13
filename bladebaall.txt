-- Roblox Luau Script: Blade Ball Integrated into Pasta/Nursultan Interface
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local CUSTOM_LOGO_ID = "rbxassetid://139568612294283"

if CoreGui:FindFirstChild("PastaCompleteUI") then
    CoreGui.PastaCompleteUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PastaCompleteUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local targetParent = (gethui and gethui()) or (run_secure and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = targetParent

local THEME = {
    Background    = Color3.fromRGB(12, 9, 11),
    CardBg        = Color3.fromRGB(18, 13, 16),
    PillBg        = Color3.fromRGB(16, 12, 14),
    SidebarActive = Color3.fromRGB(27, 16, 19),
    Border        = Color3.fromRGB(36, 24, 28),
    BorderActive  = Color3.fromRGB(90, 36, 42),
    Accent        = Color3.fromRGB(246, 92, 82),
    AccentSoft    = Color3.fromRGB(255, 165, 155),
    AccentDark    = Color3.fromRGB(130, 40, 42),
    TextPrimary   = Color3.fromRGB(235, 235, 235),
    TextMuted     = Color3.fromRGB(120, 110, 115),
    TextDim       = Color3.fromRGB(72, 64, 68),
    Divider       = Color3.fromRGB(48, 36, 40),
    BadgeBg       = Color3.fromRGB(25, 18, 22),
    ToggleOff     = Color3.fromRGB(36, 28, 32),
    KnobOff       = Color3.fromRGB(78, 68, 73),
    KnobOn        = Color3.fromRGB(255, 255, 255)
}

local ICONS = {
    Search   = "rbxassetid://7733911828",
    Chevron  = "rbxassetid://7733717447",
    More     = "rbxassetid://7734021300",
    Menu     = "rbxassetid://7733993211",
    Combat   = "rbxassetid://7734053426",
    Movement = "rbxassetid://7733799901",
    Visuals  = "rbxassetid://7733774602",
    Player   = "rbxassetid://7733954760",
    Misc     = "rbxassetid://7734056411",
    Presets  = "rbxassetid://7733964719",
    AutoBuy  = "rbxassetid://7733942651",
    Accounts = "rbxassetid://7733765307",
    User     = "rbxassetid://7733954760",
    Chart    = "rbxassetid://7733749837",
    Clock    = "rbxassetid://7733734762",
    Compass  = "rbxassetid://7733720755",
    Signal   = "rbxassetid://7734058495",
    Radar    = "rbxassetid://7734053426",
    Speed    = "rbxassetid://7733799901"
}

-- HUD Watermark setup
local HudContainer = Instance.new("Frame")
HudContainer.Name = "HudContainer"
HudContainer.Size = UDim2.new(0, 600, 0, 50)
HudContainer.Position = UDim2.new(0, 16, 0, 48)
HudContainer.BackgroundTransparency = 1
HudContainer.Parent = ScreenGui

local HudVerticalLayout = Instance.new("UIListLayout")
HudVerticalLayout.SortOrder = Enum.SortOrder.LayoutOrder
HudVerticalLayout.Padding = UDim.new(0, 4)
HudVerticalLayout.Parent = HudContainer

local function createHudRow(name, height, order)
    local row = Instance.new("Frame")
    row.Name = name
    row.Size = UDim2.new(1, 0, 0, height)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.Parent = HudContainer

    local hLayout = Instance.new("UIListLayout")
    hLayout.FillDirection = Enum.FillDirection.Horizontal
    hLayout.SortOrder = Enum.SortOrder.LayoutOrder
    hLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    hLayout.Padding = UDim.new(0, 5)
    hLayout.Parent = row
    return row
end

local TopHudRow = createHudRow("TopRow", 22, 1)
local BottomHudRow = createHudRow("BottomRow", 22, 2)

local function createHudPill(parent, order)
    local pill = Instance.new("Frame")
    pill.AutomaticSize = Enum.AutomaticSize.X
    pill.Size = UDim2.new(0, 0, 1, 0)
    pill.BackgroundColor3 = THEME.PillBg
    pill.BorderSizePixel = 0
    pill.LayoutOrder = order
    pill.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = pill

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.Border
    stroke.Thickness = 1
    stroke.Parent = pill

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
    pad.Parent = pill

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 5)
    layout.Parent = pill
    return pill
end

local function addHudDivider(parent, order)
    local div = Instance.new("Frame")
    div.Size = UDim2.new(0, 1, 0, 10)
    div.BackgroundColor3 = THEME.Divider
    div.BorderSizePixel = 0
    div.LayoutOrder = order
    div.Parent = parent
end

local function addHudText(parent, text, isMuted, order)
    local lbl = Instance.new("TextLabel")
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.Size = UDim2.new(0, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 10.5
    lbl.TextColor3 = isMuted and THEME.TextMuted or THEME.TextPrimary
    lbl.LayoutOrder = order
    lbl.Parent = parent
    return lbl
end

local function addHudSmallIcon(parent, iconId, order)
    
