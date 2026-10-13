-- Roblox Luau Script: Complete Integrated GUI + Blade Ball Core Logic
task.spawn(function()
    repeat task.wait(0.5) until game:IsLoaded()

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

    local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local TWEEN_SLOW = TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

    -- HUD Watermark
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
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 11, 0, 11)
        icon.BackgroundTransparency = 1
        icon.Image = iconId
        icon.ScaleType = Enum.ScaleType.Fit
        icon.ImageColor3 = THEME.Accent
        icon.LayoutOrder = order
        icon.Parent = parent
        return icon
    end

    local BrandPill = createHudPill(TopHudRow, 1)
    local HudLogoWrap = Instance.new("Frame")
    HudLogoWrap.Size = UDim2.new(0, 20, 0, 20)
    HudLogoWrap.BackgroundTransparency = 1
    HudLogoWrap.LayoutOrder = 1
    HudLogoWrap.Parent = BrandPill

    local HudBrandLogo = Instance.new("ImageLabel")
    HudBrandLogo.Size = UDim2.new(1.35, 0, 1.35, 0)
    HudBrandLogo.Position = UDim2.new(-0.175, 0, -0.175, 0)
    HudBrandLogo.BackgroundTransparency = 1
    HudBrandLogo.Image = CUSTOM_LOGO_ID
    HudBrandLogo.ScaleType = Enum.ScaleType.Fit
    HudBrandLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
    HudBrandLogo.ZIndex = 2
    HudBrandLogo.Parent = HudLogoWrap

    addHudDivider(BrandPill, 2)
    local HudBrandText = addHudText(BrandPill, "pasta", false, 3)

    local StatsPill = createHudPill(TopHudRow, 2)
    addHudSmallIcon(StatsPill, ICONS.User, 1)
    addHudText(StatsPill, string.lower(LocalPlayer.Name), false, 2)
    addHudDivider(StatsPill, 3)
    addHudSmallIcon(StatsPill, ICONS.Chart, 4)
    local FpsLabel = addHudText(StatsPill, "0 Fps", false, 5)
    addHudDivider(StatsPill, 6)
    addHudSmallIcon(StatsPill, ICONS.Clock, 7)
    local TimeLabel = addHudText(StatsPill, "00:00:00", false, 8)

    local PosPill = createHudPill(BottomHudRow, 1)
    addHudSmallIcon(PosPill, ICONS.Compass, 1)
    addHudDivider(PosPill, 2)
    local PosLabel = addHudText(PosPill, "0, 0, 0", false, 3)

    local PingPill = createHudPill(BottomHudRow, 2)
    addHudSmallIcon(PingPill, ICONS.Signal, 1)
    addHudDivider(PingPill, 2)
    local PingLabel = addHudText(PingPill, "0 Ping", false, 3)

    local TickPill = createHudPill(BottomHudRow, 3)
    addHudSmallIcon(TickPill, ICONS.Radar, 1)
    addHudDivider(TickPill, 2)
    local TickLabel = addHudText(TickPill, "20.0 Ticks", false, 3)

    local SpeedPill = createHudPill(BottomHudRow, 4)
    addHudSmallIcon(SpeedPill, ICONS.Speed, 1)
    addHudDivider(SpeedPill, 2)
    local SpeedLabel = addHudText(SpeedPill, "0.0 Bps", false, 3)

    -- Runtime HUD Updates Loop
    local fpsCounter, lastFpsCheck = 0, os.clock()
    local lastPosition = Vector3.zero
    local lastPosTime = os.clock()

    RunService.RenderStepped:Connect(function()
        fpsCounter = fpsCounter + 1
        local now = os.clock()

        if now - lastFpsCheck >= 1 then
            FpsLabel.Text = string.format("%d Fps", fpsCounter)
            fpsCounter = 0
            lastFpsCheck = now
        end

        TimeLabel.Text = os.date("%H:%M:%S")
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        PingLabel.Text = string.format("%d Ping", ping)

        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local currentPos = hrp.Position
            PosLabel.Text = string.format("%d, %d, %d", math.floor(currentPos.X), math.floor(currentPos.Y), math.floor(currentPos.Z))

            local deltaTime = now - lastPosTime
            if deltaTime >= 0.1 then
                local dist = (Vector3.new(currentPos.X, 0, currentPos.Z) - Vector3.new(lastPosition.X, 0, lastPosition.Z)).Magnitude
                SpeedLabel.Text = string.format("%.1f Bps", dist / deltaTime)
                lastPosition = currentPos
                lastPosTime = now
            end
        end
    end)

    -- Main UI Window
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 790, 0, 490)
    Main.Position = UDim2.new(0.5, -395, 0.5, -245)
    Main.BackgroundColor3 = THEME.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = THEME.Border
    MainStroke.Thickness = 1.2
    MainStroke.Parent = Main

    local GlowBackdrop = Instance.new("ImageLabel")
    GlowBackdrop.Name = "GlowBackdrop"
    GlowBackdrop.BackgroundTransparency = 1
    GlowBackdrop.Position = UDim2.new(0, -45, 0, -45)
    GlowBackdrop.Size = UDim2.new(1, 90, 1, 90)
    GlowBackdrop.ZIndex = 0
    GlowBackdrop.Image = "rbxassetid://5028857084"
    GlowBackdrop.ImageColor3 = THEME.AccentDark
    GlowBackdrop.ImageTransparency = 0.83
    GlowBackdrop.ScaleType = Enum.ScaleType.Slice
    GlowBackdrop.SliceCenter = Rect.new(24, 24, 276, 276)
    GlowBackdrop.Parent = Main

    -- Dragging Logic
    do
        local dragging, dragStart, startPos
        Main.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Main.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                TweenService:Create(Main, TweenInfo.new(0.04), {
                    Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                }):Play()
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end

    -- TopBar & Logo
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 56)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = Main

    local MainLogoHolder = Instance.new("Frame")
    MainLogoHolder.Size = UDim2.new(0, 64, 0, 64)
    MainLogoHolder.Position = UDim2.new(0, 52, 0, -4)
    MainLogoHolder.BackgroundTransparency = 1
    MainLogoHolder.Parent = TopBar

    local MainLogoImg = Instance.new("ImageLabel")
    MainLogoImg.Size = UDim2.new(1, 0, 1, 0)
    MainLogoImg.BackgroundTransparency = 1
    MainLogoImg.Image = CUSTOM_LOGO_ID
    MainLogoImg.ScaleType = Enum.ScaleType.Fit
    MainLogoImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    MainLogoImg.Parent = MainLogoHolder

    -- Search Bar
    local SearchBox = Instance.new("Frame")
    SearchBox.Size = UDim2.new(0, 250, 0, 26)
    SearchBox.Position = UDim2.new(0, 185, 0, 15)
    SearchBox.BackgroundColor3 = THEME.CardBg
    SearchBox.BorderSizePixel = 0
    SearchBox.Parent = TopBar

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchBox

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = THEME.Border
    SearchStroke.Thickness = 0.8
    SearchStroke.Parent = SearchBox

    local SearchInput = Instance.new("TextBox")
    SearchInput.PlaceholderText = "Search features..."
    SearchInput.PlaceholderColor3 = THEME.TextMuted
    SearchInput.TextColor3 = THEME.TextPrimary
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.TextSize = 11
    SearchInput.Position = UDim2.new(0, 30, 0, 0)
    SearchInput.Size = UDim2.new(1, -36, 1, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.Parent = SearchBox

    -- Blade Ball Backend Hook & Bypass Setup
    local Alive = Workspace:FindFirstChild("Alive") or Workspace:WaitForChild("Alive")
    local Runtime = Workspace:FindFirstChild("Runtime") or Workspace:WaitForChild("Runtime")

    local _token
    local _tokenFound = false
    for _, Function in getgc(true) do
        if type(Function) ~= 'function' or not debug.info(Function, 's'):find('PRY', 1, true) then
            continue
        end
        for _, value in debug.getupvalues(Function) do
            if type(value) == 'function' then
                _token = value
                _tokenFound = true
                break
            end
        end
        if _token then break end
    end

    local function _tokenize(_remote_uid)
        if not _token then return "" end
        local time = tostring(math.floor(workspace:GetServerTimeNow() * 100))
        local key = _token(_remote_uid, 'TIME')
        local characters = table.create(#time)
        for index = 1, #time do
            characters[index] = string.char(bit32.bxor(
                (string.byte(time, index) + index) % 256,
                string.byte(key, (index - 1) % #key + 1)
            ))
        end
        return table.concat(characters)
    end

    local _capturedRemote = nil
    local _capturedArgs = nil
    local _reverted = {}
    local _original = {}

    local function _hook(remote)
        if not remote or _reverted[remote] then return end
        local meta = getrawmetatable(remote)
        if not meta or _original[meta] then return end
        _original[meta] = true
        setreadonly(meta, false)
        local _old = meta.__index
        meta.__index = function(self, key)
            if (key == 'FireServer' and self:IsA('RemoteEvent')) or (key == 'InvokeServer' and self:IsA('RemoteFunction')) then
                return function(_, ...)
                    local args = {...}
                    if args and #args >= 8 then
                        if not _reverted[self] then
                            _reverted[self] = args
                            _capturedRemote = self
                            _capturedArgs = args
                        end
                    end
                    return _old(self, key)(_, unpack(args))
                end
            end
            return _old(self, key)
        end
        setreadonly(meta, true)
    end

    for _, r in pairs(ReplicatedStorage:GetDescendants()) do
        if r:IsA('RemoteEvent') or r:IsA('RemoteFunction') then
            _hook(r)
        end
    end

    local function fireParryRemote()
        if not _capturedRemote or not _capturedArgs then return end
        local cam = Workspace.CurrentCamera
        local mouseLoc = UserInputService:GetMouseLocation()
        local packet = {
            _capturedArgs[1],
            _capturedArgs[2],
            _tokenize(_capturedArgs[2]),
            0.5,
            cam.CFrame,
            {},
            {math.floor(mouseLoc.X), math.floor(mouseLoc.Y)},
            false
        }
        pcall(function()
            if _capturedRemote:IsA('RemoteEvent') then
                _capturedRemote:FireServer(unpack(packet))
            else
                _capturedRemote:InvokeServer(unpack(packet))
            end
        end)
    end

    local AutoParryActive = false
    local AutoSpamActive = false
    local TriggerBotActive = false

    RunService.PreSimulation:Connect(function()
        if AutoParryActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local balls = Workspace:FindFirstChild("Balls")
            if balls then
                for _, ball in pairs(balls:GetChildren()) do
                    if ball:GetAttribute("realBall") then
                        local zoomies = ball:FindFirstChild("zoomies")
                        if zoomies then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - ball.Position).Magnitude
                            if ball:GetAttribute("target") == LocalPlayer.Name and dist <= 25 then
                                fireParryRemote()
                            end
                        end
                    end
                end
            end
        end

        if AutoSpamActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local balls = Workspace:FindFirstChild("Balls")
            if balls then
                for _, ball in pairs(balls:GetChildren()) do
                    if ball:GetAttribute("realBall") then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - ball.Position).Magnitude
                        if dist <= 35 then
                            fireParryRemote()
                        end
                    end
                end
            end
        end
    end)

    -- Sidebar & Content Frame Setup
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 155, 1, -58)
    Sidebar.Position = UDim2.new(0, 14, 0, 54)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = Main

    local SideList = Instance.new("UIListLayout")
    SideList.Padding = UDim.new(0, 2)
    SideList.SortOrder = Enum.SortOrder.LayoutOrder
    SideList.Parent = Sidebar

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -195, 1, -62)
    ContentArea.Position = UDim2.new(0, 182, 0, 54)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = Main

    local Col1 = Instance.new("ScrollingFrame")
    Col1.Size = UDim2.new(0.485, 0, 1, 0)
    Col1.BackgroundTransparency = 1
    Col1.ScrollBarThickness = 0
    Col1.Parent = ContentArea

    local Col2 = Instance.new("ScrollingFrame")
    Col2.Size = UDim2.new(0.485, 0, 1, 0)
    Col2.Position = UDim2.new(0.515, 0, 0, 0)
    Col2.BackgroundTransparency = 1
    Col2.ScrollBarThickness = 0
    Col2.Parent = ContentArea

    for _, col in ipairs({Col1, Col2}) do
        local l = Instance.new("UIListLayout")
        l.Padding = UDim.new(0, 12)
        l.SortOrder = Enum.SortOrder.LayoutOrder
        l.Parent = col
    end

    local function createCard(parent, titleText, order)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 0)
        card.AutomaticSize = Enum.AutomaticSize.Y
        card.BackgroundColor3 = THEME.CardBg
        card.BorderSizePixel = 0
        card.LayoutOrder = order
        card.Parent = parent

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = card

        local s = Instance.new("UIStroke")
        s.Color = THEME.Border
        s.Thickness = 0.8
        s.Parent = card

        local p = Instance.new("UIPadding")
        p.PaddingTop = UDim.new(0, 11)
        p.PaddingBottom = UDim.new(0, 13)
        p.PaddingLeft = UDim.new(0, 12)
        p.PaddingRight = UDim.new(0, 12)
        p.Parent = card

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 10)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = card

        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, 0, 0, 18)
        header.BackgroundTransparency = 1
        header.LayoutOrder = 0
        header.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 1, 0)
        title.BackgroundTransparency = 1
        title.Text = titleText
        title.Font = Enum.Font.GothamBold
        title.TextSize = 12
        title.TextColor3 = THEME.TextPrimary
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = header

        return card
    end

    local registeredRows = {}

    local function addToggle(card, name, description, defaultState, callback)
        local row = Instance.new("Frame")
        row.Name = name
        row.Size = UDim2.new(1, 0, 0, description and 30 or 21)
        row.BackgroundTransparency = 1
        row.Parent = card

        table.insert(registeredRows, {Frame = row, Name = name:lower()})

        local textContainer = Instance.new("Frame")
        textContainer.Size = UDim2.new(1, -50, 1, 0)
        textContainer.BackgroundTransparency = 1
        textContainer.Parent = row

        local rowTitle = Instance.new("TextLabel")
        rowTitle.Size = UDim2.new(1, 0, 0, 14)
        rowTitle.BackgroundTransparency = 1
        rowTitle.Text = name
        rowTitle.Font = Enum.Font.GothamMedium
        rowTitle.TextSize = 11
        rowTitle.TextColor3 = THEME.TextPrimary
        rowTitle.TextXAlignment = Enum.TextXAlignment.Left
        rowTitle.Parent = textContainer

        if description then
            local rowDesc = Instance.new("TextLabel")
            rowDesc.Size = UDim2.new(1, 0, 0, 12)
            rowDesc.Position = UDim2.new(0, 0, 0, 14)
            rowDesc.BackgroundTransparency = 1
            rowDesc.Text = description
            rowDesc.Font = Enum.Font.Gotham
            rowDesc.TextSize = 9
            rowDesc.TextColor3 = THEME.TextMuted
            rowDesc.TextXAlignment = Enum.TextXAlignment.Left
            rowDesc.Parent = textContainer
        end

        local switch = Instance.new("TextButton")
        switch.Size = UDim2.new(0, 32, 0, 16)
        switch.Position = UDim2.new(1, -32, 0.5, -8)
        switch.BackgroundColor3 = defaultState and THEME.Accent or THEME.ToggleOff
        switch.Text = ""
        switch.AutoButtonColor = false
        switch.Parent = row

        local sCorner = Instance.new("UICorner")
        sCorner.CornerRadius = UDim.new(1, 0)
        sCorner.Parent = switch

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 12, 0, 12)
        knob.Position = defaultState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        knob.BackgroundColor3 = defaultState and THEME.KnobOn or THEME.KnobOff
        knob.BorderSizePixel = 0
        knob.Parent = switch

        local kCorner = Instance.new("UICorner")
        kCorner.CornerRadius = UDim.new(1, 0)
        kCorner.Parent = knob

        local isToggled = defaultState
        switch.MouseButton1Click:Connect(function()
            isToggled = not isToggled
            local targetColor = isToggled and THEME.Accent or THEME.ToggleOff
            local targetKnobColor = isToggled and THEME.KnobOn or THEME.KnobOff
            local targetPos = isToggled and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)

            TweenService:Create(switch, TWEEN_FAST, {BackgroundColor3 = targetColor}):Play()
            TweenService:Create(knob, TWEEN_FAST, {BackgroundColor3 = targetKnobColor, Position = targetPos}):Play()

            if callback then callback(isToggled) end
        end)
    end

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchInput.Text:lower()
        for _, item in ipairs(registeredRows) do
            if query == "" or string.find(item.Name, query, 1, true) then
                item.Frame.Visible = true
            else
                item.Frame.Visible = false
            end
        end
    end)

    -- Populate Cards with Blade Ball Functions
    local cardCombat = createCard(Col1, "Blade Ball Combat", 1)
    addToggle(cardCombat, "Auto Parry", "Automatically parries the ball", false, function(state)
        AutoParryActive = state
    end)
    addToggle(cardCombat, "Auto Spam", "Spams parry near target", false, function(state)
        AutoSpamActive = state
    end)
    addToggle(cardCombat, "Trigger Bot", "Instantly triggers on target", false, function(state)
        TriggerBotActive = state
    end)

    local cardDetections = createCard(Col1, "Detections", 2)
    addToggle(cardDetections, "Infinity Detect", nil, false, function(state) end)
    addToggle(cardDetections, "Death Slash Detect", nil, false, function(state) end)
    addToggle(cardDetections, "Time Hole Detect", nil, false, function(state) end)

    local cardCharacter = createCard(Col2, "Character Mods", 1)
    addToggle(cardCharacter, "Infinite Jump", nil, false, function(state)
        if state then
            UserInputService.JumpRequest:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end)
    addToggle(cardCharacter, "Speed Boost", nil, false, function(state)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = state and 32 or 16
        end
    end)

    -- RightShift GUI Toggle
    local isUIVisible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
            isUIVisible = not isUIVisible
            Main.Visible = isUIVisible
        end
    end)

    print("https://discord.gg/76tHHGBrfz Blade Ball Integrated Successfully into Nursultan UI.")
end)
