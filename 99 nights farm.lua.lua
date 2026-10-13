-- 99 Nights in the Forest - Combined Script
-- Anti-AFK & Auto-Load
repeat task.wait() until game:IsLoaded()

local VirtualUser = game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
    warn("anti-afk")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Fishing Helper (from first script)
game:GetService("Players").LocalPlayer.PlayerGui.Interface.FishingCatchFrame.TimingBar.SuccessArea:GetPropertyChangedSignal("Size"):Connect(function()
    game:GetService("Players").LocalPlayer.PlayerGui.Interface.FishingCatchFrame.TimingBar.SuccessArea.Position = UDim2.new(0.5,0,0,0)
    game:GetService("Players").LocalPlayer.PlayerGui.Interface.FishingCatchFrame.TimingBar.SuccessArea.Size = UDim2.new(1,0,1,0)
end)

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- Lighting Setup
Lighting.ClockTime = 14
Lighting.GlobalShadows = false

-- Utility Functions
local function fireproximityprompt(ProximityPrompt, Amount, Skip)
    assert(ProximityPrompt, "Argument #1 Missing or nil")
    assert(
        typeof(ProximityPrompt) == "Instance" and ProximityPrompt:IsA("ProximityPrompt"),
        "Attempted to fire a Value that is not a ProximityPrompt"
    )
    local HoldDuration = ProximityPrompt.HoldDuration
    if Skip then
        ProximityPrompt.HoldDuration = 0
    end
    for i = 1, Amount or 1 do
        ProximityPrompt:InputHoldBegin()
        if Skip then
            wait(HoldDuration)
        end
        ProximityPrompt:InputHoldEnd()
    end
    ProximityPrompt.HoldDuration = HoldDuration
end

function toTarget(pos, targetPos, targetCFrame)
    local tween_s = game:service"TweenService"
    local info = TweenInfo.new((targetPos - pos).Magnitude/getgenv().speed, Enum.EasingStyle.Linear)
    local tween, err = pcall(function()
        local tween = tween_s:Create(LocalPlayer.Character["HumanoidRootPart"], info, {CFrame = targetCFrame * CFrame.fromAxisAngle(Vector3.new(1,0,0), math.rad(90))})
        tween:Play()
    end)
    if not tween then return err end
end

getgenv().speed = 1600

function CTRLCLICKTP()
    local UIS = game:GetService("UserInputService")
    local Mouse = LocalPlayer:GetMouse()

    function Teleport(pos)
        local Char = LocalPlayer.Character
        if Char then
            Char:MoveTo(pos)
        end
    end

    UIS.InputBegan:Connect(function(input)
        if getgenv().CtrlClickTeePee == true then
            if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                Teleport(Mouse.Hit.p)
            end
        end
    end)
end

function UPPERFORMANCE()
    local decalsyeeted = true
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"
    for i,v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") and decalsyeeted then 
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then 
            v.Lifetime = NumberRange.new(0)
        end
    end
end

if _G.dAAcG3fvBqVoPzVnAFk == nil then 
    _G.dAAcG3fvBqVoPzVnAFk = "" 
end 

function notify(a,b,c)
    local d=c or function()return end
    local e=b or false
    if a==_G.dAAcG3fvBqVoPzVnAFk and e==false then return end
    spawn(function()
        for f,g in pairs(game.CoreGui:GetChildren())do 
            spawn(function()
                if g.Name=="MNotify"then 
                    pcall(function()
                        g.ImageButton.ZIndex=58
                        g.ImageButton.TextLabel.ZIndex=59
                        g.ImageButton:TweenPosition(UDim2.new(0.01,0,1,0),"Out","Quint",.7,true)
                        game:GetService("TweenService"):Create(g.ImageButton.TextLabel,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),{TextTransparency=1})
                        wait(1)
                        g:Destroy()
                    end)
                end 
            end)
        end
        _G.dAAcG3fvBqVoPzVnAFk=a
        local d=c or function()return end
        local function h(i,j)
            local k=Instance.new(i)
            for f,g in pairs(j)do 
                k[f]=g 
            end
            return k 
        end
        local l=h('ScreenGui',{DisplayOrder=0,Enabled=true,ResetOnSpawn=true,Name='MNotify',Parent=game.CoreGui})
        local m=h('ImageButton',{Image='rbxassetid://1051186612',ImageColor3=Color3.new(0.129412,0.129412,0.129412),ImageRectOffset=Vector2.new(0,0),ImageRectSize=Vector2.new(0,0),ImageTransparency=0,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(20,20,20,20),AutoButtonColor=true,Modal=false,Selected=false,Style=Enum.ButtonStyle.Custom,Active=true,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.105882,0.164706,0.207843),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.00999999978,0,1,0),Rotation=0,Selectable=true,Size=UDim2.new(0,234,0,40),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=60,Name='ImageButton',Parent=l})
        local n=h('TextLabel',{Font=Enum.Font.TitilliumWeb,FontSize=Enum.FontSize.Size24,Text=a,TextColor3=Color3.new(0.807843,0.807843,0.807843),TextScaled=false,TextSize=24,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=false,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Active=false,AnchorPoint=Vector2.new(0,0),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderColor3=Color3.new(0.105882,0.164706,0.207843),BorderSizePixel=1,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.132478639,0,0,0),Rotation=0,Selectable=false,Size=UDim2.new(0,174,0,40),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=61,Name='TextLabel',Parent=m})
        local o=h('UIListLayout',{Padding=UDim.new(0,0),FillDirection=Enum.FillDirection.Vertical,HorizontalAlignment=Enum.HorizontalAlignment.Center,SortOrder=Enum.SortOrder.Name,VerticalAlignment=Enum.VerticalAlignment.Top,Name='UIListLayout',Parent=m})
        local p=1
        if string.len(a)<=49 then 
            m.Size=UDim2.new(0,game:GetService("TextService"):GetTextSize(a,24,Enum.Font.TitilliumWeb,Vector2.new(500,900)).X+35,0,40)
        elseif string.len(a)>49 then 
            p=math.ceil(string.len(string.sub(a,49))/9)
            m.Size=UDim2.new(0,game:GetService("TextService"):GetTextSize(a,24,Enum.Font.TitilliumWeb,Vector2.new(500+p*100,900)).X+35,0,40)
        end
        m:TweenPosition(UDim2.new(0.01,0,.97,-60),"Out","Quint",.7,true)
        spawn(function()
            wait(4)
            pcall(function()
                m.ZIndex=58
                n.ZIndex=59
                m:TweenPosition(UDim2.new(0.01,0,1,0),"Out","Quint",.7,true)
                _G.dAAcG3fvBqVoPzVnAFk=""
                wait(.3)
                l:Destroy()
            end)
        end)
        m.MouseButton1Up:Connect(function()
            if c==nil then return end
            spawn(function()
                pcall(function()
                    m.ZIndex=58
                    n.ZIndex=59
                    m:TweenPosition(UDim2.new(0.01,0,1,0),"Out","Quint",.7,true)
                    _G.dAAcG3fvBqVoPzVnAFk=""
                    wait(1)
                    l:Destroy()
                end)
            end)
            d()
        end)
    end)
end

function roundNumber(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

notify("Script Loaded Successfully!")

-- Load WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Add Themes
WindUI:AddTheme({
    Name = "Dark",
    Accent = "#18181b",
    Dialog = "#18181b", 
    Outline = "#FFFFFF",
    Text = "#FFFFFF",
    Placeholder = "#999999",
    Background = "#0e0e10",
    Button = "#52525b",
    Icon = "#a1a1aa",
})

WindUI:AddTheme({
    Name = "Light",
    Accent = "#f4f4f5",
    Dialog = "#f4f4f5",
    Outline = "#000000", 
    Text = "#000000",
    Placeholder = "#666666",
    Background = "#ffffff",
    Button = "#e4e4e7",
    Icon = "#52525b",
})

WindUI:AddTheme({
    Name = "Gray",
    Accent = "#374151",
    Dialog = "#374151",
    Outline = "#d1d5db", 
    Text = "#f9fafb",
    Placeholder = "#9ca3af",
    Background = "#1f2937",
    Button = "#4b5563",
    Icon = "#d1d5db",
})

WindUI:AddTheme({
    Name = "Blue",
    Accent = "#1e40af",
    Dialog = "#1e3a8a",
    Outline = "#93c5fd", 
    Text = "#f0f9ff",
    Placeholder = "#60a5fa",
    Background = "#1e293b",
    Button = "#3b82f6",
    Icon = "#93c5fd",
})

WindUI:AddTheme({
    Name = "Green",
    Accent = "#059669",
    Dialog = "#047857",
    Outline = "#6ee7b7", 
    Text = "#ecfdf5",
    Placeholder = "#34d399",
    Background = "#064e3b",
    Button = "#10b981",
    Icon = "#6ee7b7",
})

WindUI:AddTheme({
    Name = "Purple",
    Accent = "#7c3aed",
    Dialog = "#6d28d9",
    Outline = "#c4b5fd", 
    Text = "#faf5ff",
    Placeholder = "#a78bfa",
    Background = "#581c87",
    Button = "#8b5cf6",
    Icon = "#c4b5fd",
})

WindUI:SetNotificationLower(true)

local themes = {"Dark", "Light", "Gray", "Blue", "Green", "Purple"}
local currentThemeIndex = 1

if not getgenv().TransparencyEnabled then
    getgenv().TransparencyEnabled = true
end

-- Variables
local killAuraToggle = false
local chopAuraToggle = false
local auraRadius = 50
local currentammount = 0

local toolsDamageIDs = {
    ["Old Axe"] = "3_7367831688",
    ["Good Axe"] = "112_7367831688",
    ["Strong Axe"] = "116_7367831688",
    ["Chainsaw"] = "647_8992824875",
    ["Infernal Sword"] = "2_4340578793",
    ["Spear"] = "196_8999010016"
}

-- Auto Food Variables
local autoFeedToggle = false
local selectedFood = {}
local hungerThreshold = 75
local alimentos = {
    "Apple",
    "Berry",
    "Carrot",
    "Cake",
    "Chili",
    "Cooked Ribs",
    "Cooked Mackerel",
    "Cooked Salmon",
    "Cooked Morsel",
    "Cooked Steak"
}

-- ESP Variables
local ie = {
    "Bandage", "Bolt", "Broken Fan", "Broken Microwave", "Cake", "Carrot", "Chair", "Coal", "Coin Stack",
    "Cooked Morsel", "Cooked Steak", "Fuel Canister", "Iron Body", "Leather Armor", "Log", "MadKit", "Metal Chair",
    "MedKit", "Old Car Engine", "Old Flashlight", "Old Radio", "Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo",
    "Morsel", "Sheet Metal", "Steak", "Tyre", "Washing Machine", "Cultist Gem", "Gem of the Forest Fragment"
}
local me = {"Bunny", "Wolf", "Alpha Wolf", "Bear", "Cultist", "Crossbow Cultist", "Alien", "Alien Elite"}

-- Bring Items Variables
local junkItems = {"Tyre", "Bolt", "Broken Fan", "Broken Microwave", "Sheet Metal", "Old Radio", "Washing Machine", "Old Car Engine"}
local selectedJunkItems = {}
local fuelItems = {"Log", "Chair", "Coal", "Fuel Canister", "Oil Barrel"}
local selectedFuelItems = {}
local foodItems = {"Cake", "Cooked Steak", "Cooked Morsel", "Ribs", "Salmon", "Cooked Salmon", "Cooked Ribs", "Mackerel", "Cooked Mackerel", "Steak", "Morsel", "Berry", "Carrot"}
local selectedFoodItems = {}
local medicalItems = {"Bandage", "MedKit"}
local selectedMedicalItems = {}
local equipmentItems = {"Revolver", "Rifle", "Leather Body", "Iron Body", "Revolver Ammo", "Rifle Ammo", "Giant Sack", "Good Sack", "Strong Axe", "Good Axe"}
local selectedEquipmentItems = {}

local isCollecting = false
local originalPosition = nil

local junkToggleEnabled = false
local fuelToggleEnabled = false
local foodToggleEnabled = false
local medicalToggleEnabled = false
local equipmentToggleEnabled = false

local junkLoopRunning = false
local fuelLoopRunning = false
local foodLoopRunning = false
local medicalLoopRunning = false
local equipmentLoopRunning = false

-- Auto Upgrade Variables
local campfireFuelItems = {"Log", "Coal", "Chair", "Fuel Canister", "Oil Barrel", "Biofuel"}
local campfireDropPos = Vector3.new(0, 19, 0)
local selectedCampfireItem = nil
local autoUpgradeCampfireEnabled = false

local scrapjunkItems = {"Log", "Chair", "Tyre", "Bolt", "Broken Fan", "Broken Microwave", "Sheet Metal", "Old Radio", "Washing Machine", "Old Car Engine"}
local autoScrapPos = Vector3.new(21, 20, -5)
local selectedScrapItem = nil
local autoScrapItemsEnabled = false

local autocookItems = {"Morsel", "Steak", "Ribs", "Salmon", "Mackerel"}
local autoCookEnabledItems = {}
local autoCookEnabled = false

-- Helper Functions
local function getAnyToolWithDamageID(isChopAura)
    for toolName, damageID in pairs(toolsDamageIDs) do
        if isChopAura and toolName ~= "Old Axe" and toolName ~= "Good Axe" and toolName ~= "Strong Axe" and toolName ~= "Chainsaw" then
            continue
        end
        local tool = LocalPlayer:FindFirstChild("Inventory") and LocalPlayer.Inventory:FindFirstChild(toolName)
        if tool then
            return tool, damageID
        end
    end
    return nil, nil
end

local function equipTool(tool)
    if tool then
        ReplicatedStorage:WaitForChild("RemoteEvents").EquipItemHandle:FireServer("FireAllClients", tool)
    end
end

local function unequipTool(tool)
    if tool then
        ReplicatedStorage:WaitForChild("RemoteEvents").UnequipItemHandle:FireServer("FireAllClients", tool)
    end
end

-- Kill Aura Loop
local function killAuraLoop()
    while killAuraToggle do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, damageID = getAnyToolWithDamageID(false)
            if tool and damageID then
                equipTool(tool)
                for _, mob in ipairs(Workspace.Characters:GetChildren()) do
                    if mob:IsA("Model") then
                        local part = mob:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude <= auraRadius then
                            pcall(function()
                                ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                    mob,
                                    tool,
                                    damageID,
                                    CFrame.new(part.Position)
                                )
                            end)
                        end
                    end
                end
                task.wait(0.1)
            else
                task.wait(1)
            end
        else
            task.wait(0.5)
        end
    end
end

-- Auto Plant
local AutoPlantToggle = false

local function autoplant()
    while AutoPlantToggle do
        local args = {
            Instance.new("Model"),
            Vector3.new(-41.2053, 1.0633, 29.2236)
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("RemoteEvents")
            :WaitForChild("RequestPlantItem")
            :InvokeServer(unpack(args))
        task.wait(1)
    end
end

-- Chop Aura Loop
local function chopAuraLoop()
    while chopAuraToggle do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, baseDamageID = getAnyToolWithDamageID(true)
            if tool and baseDamageID then
                equipTool(tool)
                currentammount = currentammount + 1
                local trees = {}
                local map = Workspace:FindFirstChild("Map")
                if map then
                    if map:FindFirstChild("Foliage") then
                        for _, obj in ipairs(map.Foliage:GetChildren()) do
                            if obj:IsA("Model") and (obj.Name == "Small Tree" or obj.Name == "Snowy Small Tree") then
                                table.insert(trees, obj)
                            end
                        end
                    end
                    if map:FindFirstChild("Landmarks") then
                        for _, obj in ipairs(map.Landmarks:GetChildren()) do
                            if obj:IsA("Model") and obj.Name == "Small Tree" then
                                table.insert(trees, obj)
                            end
                        end
                    end
                end
                for _, tree in ipairs(trees) do
                    local trunk = tree:FindFirstChild("Trunk")
                    if trunk and trunk:IsA("BasePart") and (trunk.Position - hrp.Position).Magnitude <= auraRadius then
                        local alreadyammount = false
                        task.spawn(function()
                            while chopAuraToggle and tree and tree.Parent and not alreadyammount do
                                alreadyammount = true
                                currentammount = currentammount + 1
                                pcall(function()
                                    ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                        tree,
                                        tool,
                                        tostring(currentammount) .. "_7367831688",
                                        CFrame.new(-2.962610244751, 4.5547881126404, -75.950843811035, 0.89621275663376, -1.3894891459643e-08, 0.44362446665764, -7.994568895775e-10, 1, 3.293635941759e-08, -0.44362446665764, -2.9872644802253e-08, 0.89621275663376)
                                    )
                                end)
                                task.wait(0.5)
                            end
                        end)
                    end
                end
                task.wait(0.1)
            else
                task.wait(1)
            end
        else
            task.wait(0.5)
        end
    end
end

-- Auto Food Functions
function wiki(nome)
    local c = 0
    for _, i in ipairs(Workspace.Items:GetChildren()) do
        if i.Name == nome then
            c = c + 1
        end
    end
    return c
end

function ghn()
    return math.floor(LocalPlayer.PlayerGui.Interface.StatBars.HungerBar.Bar.Size.X.Scale * 100)
end

function feed(nome)
    for _, item in ipairs(Workspace.Items:GetChildren()) do
        if item.Name == nome then
            ReplicatedStorage.RemoteEvents.RequestConsumeItem:InvokeServer(item)
            break
        end
    end
end

function notifeed(nome)
    WindUI:Notify({
        Title = "Auto Food Paused",
        Content = "The food is gone",
        Duration = 3
    })
end

-- Move Item Function
local function moveItemToPos(item, position)
    if not item or not item:IsDescendantOf(workspace) or not item:IsA("BasePart") and not item:IsA("Model") then return end
    local part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")) or item
    if not part or not part:IsA("BasePart") then return end

    if item:IsA("Model") and not item.PrimaryPart then
        pcall(function() item.PrimaryPart = part end)
    end

    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents").RequestStartDraggingItem:FireServer(item)
        if item:IsA("Model") then
            item:SetPrimaryPartCFrame(CFrame.new(position))
        else
            part.CFrame = CFrame.new(position)
        end
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents").StopDraggingItem:FireServer(item)
    end)
end

-- Smooth Pull Functions (from first script)
local function smoothPullToItem(startPos, endPos, targetCFrame)
    local player = game.Players.LocalPlayer
    local hrp = player.Character.HumanoidRootPart
    
    local startTime = tick()
    
    spawn(function()
        while tick() - startTime < 1.2 do
            local elapsed = tick() - startTime
            local progress = elapsed / 1.2
            
            local easedProgress = progress < 0.5 
                and 2 * progress * progress 
                or 1 - math.pow(-2 * progress + 2, 2) / 2
            
            local currentPos = startPos.Position:lerp(endPos.Position, easedProgress)
            local lookDirection = endPos.Position - currentPos
            
            if lookDirection.Magnitude > 0 then
                hrp.CFrame = CFrame.lookAt(currentPos, currentPos + lookDirection.Unit)
            else
                hrp.CFrame = CFrame.new(currentPos)
            end
            
            wait()
        end
        
        hrp.CFrame = endPos
    end)
    
    wait(1.2)
end

local function createItemPullEffect(itemPart, targetPos, duration)
    if not itemPart or not itemPart.Parent then return end
    
    local startPos = itemPart.Position
    local startTime = tick()
    
    spawn(function()
        while tick() - startTime < duration do
            if not itemPart or not itemPart.Parent then break end
            
            local elapsed = tick() - startTime
            local progress = elapsed / duration
            
            local easedProgress = 1 - math.pow(1 - progress, 3)
            
            local currentPos = Vector3.new(
                startPos.X + (targetPos.X - startPos.X) * easedProgress,
                startPos.Y + (targetPos.Y - startPos.Y) * easedProgress,
                startPos.Z + (targetPos.Z - startPos.Z) * easedProgress
            )
            
            pcall(function()
                itemPart.CFrame = CFrame.new(currentPos)
                itemPart.Velocity = Vector3.new(0, 0, 0)
                itemPart.AngularVelocity = Vector3.new(0, 0, 0)
            end)
            
            wait()
        end
        
        pcall(function()
            itemPart.CFrame = CFrame.new(targetPos)
            itemPart.Velocity = Vector3.new(0, 0, 0)
            itemPart.AngularVelocity = Vector3.new(0, 0, 0)
        end)
    end)
    
    wait(duration)
end

-- Bypass Bring System
local function bypassBringSystem(items, stopFlag)
    if isCollecting then 
        return 
    end
    
    isCollecting = true
    local player = game.Players.LocalPlayer
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then 
        isCollecting = false
        return 
    end
    
    local hrp = player.Character.HumanoidRootPart
    originalPosition = hrp.CFrame
    
    for _, itemName in ipairs(items) do
        if stopFlag and not stopFlag() then
            break
        end
        
        local itemsFound = {}
        
        for _, item in ipairs(workspace:GetDescendants()) do
            if item.Name == itemName and (item:IsA("BasePart") or item:IsA("Model")) then
                local itemPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
                if itemPart and itemPart.Parent ~= player.Character then
                    table.insert(itemsFound, {item = item, part = itemPart})
                end
            end
        end
        
        for _, itemData in ipairs(itemsFound) do
            if stopFlag and not stopFlag() then
                break
            end
            
            local item = itemData.item
            local itemPart = itemData.part
            
            if itemPart and itemPart.Parent then
                local itemPos = itemPart.CFrame + Vector3.new(0, 5, 0)
                smoothPullToItem(hrp.CFrame, itemPos, itemPos)
                
                local playerPos = hrp.Position + Vector3.new(0, -1, 0)
                createItemPullEffect(itemPart, playerPos, 0.8)
                
                local keepAttached = true
                spawn(function()
                    while keepAttached do
                        if stopFlag and not stopFlag() then
                            keepAttached = false
                            break
                        end
                        
                        if itemPart and itemPart.Parent and hrp and hrp.Parent then
                            pcall(function()
                                local offset = Vector3.new(
                                    math.sin(tick() * 2) * 0.5,
                                    -1 + math.cos(tick() * 3) * 0.2,
                                    math.cos(tick() * 2) * 0.5
                                )
                                itemPart.CFrame = CFrame.new(hrp.Position + offset)
                                itemPart.Velocity = Vector3.new(0, 0, 0)
                                itemPart.AngularVelocity = Vector3.new(0, 0, 0)
                            end)
                        end
                        wait(0.03)
                    end
                end)
                
                smoothPullToItem(hrp.CFrame, originalPosition, originalPosition)
                
                keepAttached = false
                wait(0.1)
                
                pcall(function()
                    local landingPos = originalPosition.Position + Vector3.new(
                        math.random(-4, 4), 
                        2, 
                        math.random(-4, 4)
                    )
                    
                    createItemPullEffect(itemPart, landingPos, 0.5)
                end)
            end
            
            wait(0.5)
        end
    end
    
    if originalPosition then
        hrp.CFrame = originalPosition
    end
    
    isCollecting = false
end

-- Now continue with the rest from document 3 starting with Teleport Functions
function tp1()
    (game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart").CFrame =
    CFrame.new(0.43132782, 15.77634621, -1.88620758, -0.270917892, 0.102997094, 0.957076371, 0.639657021, 0.762253821, 0.0990355015, -0.719334781, 0.639031112, -0.272391081)
end

local function tp2()
    local targetPart = workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Landmarks")
        and workspace.Map.Landmarks:FindFirstChild("Stronghold")
        and workspace.Map.Landmarks.Stronghold:FindFirstChild("Functional")
        and workspace.Map.Landmarks.Stronghold.Functional:FindFirstChild("EntryDoors")
        and workspace.Map.Landmarks.Stronghold.Functional.EntryDoors:FindFirstChild("DoorRight")
        and workspace.Map.Landmarks.Stronghold.Functional.EntryDoors.DoorRight:FindFirstChild("Model")
    if targetPart then
        local children = targetPart:GetChildren()
        local destination = children[5]
        if destination and destination:IsA("BasePart") then
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = destination.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end

-- Fly Functions
local flyToggle = false
local flySpeed = 1
local FLYING = false
local flyKeyDown, flyKeyUp, mfly1, mfly2
local IYMouse = game:GetService("UserInputService")

local function sFLY()
    repeat task.wait() until Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    repeat task.wait() until IYMouse
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect(); flyKeyUp:Disconnect() end

    local T = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = flySpeed

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while FLYING do
                task.wait()
                if not flyToggle and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                    Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
                end
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = flySpeed
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                else
                    BV.Velocity = Vector3.new(0, 0, 0)
                end
                BG.CFrame = workspace.CurrentCamera.CoordinateFrame
            end
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()
            if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
            end
        end)
    end
    flyKeyDown = IYMouse.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local KEY = input.KeyCode.Name
            if KEY == "W" then
                CONTROL.F = flySpeed
            elseif KEY == "S" then
                CONTROL.B = -flySpeed
            elseif KEY == "A" then
                CONTROL.L = -flySpeed
            elseif KEY == "D" then 
                CONTROL.R = flySpeed
            elseif KEY == "E" then
                CONTROL.Q = flySpeed * 2
            elseif KEY == "Q" then
                CONTROL.E = -flySpeed * 2
            end
            pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
        end
    end)
    flyKeyUp = IYMouse.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local KEY = input.KeyCode.Name
            if KEY == "W" then
                CONTROL.F = 0
            elseif KEY == "S" then
                CONTROL.B = 0
            elseif KEY == "A" then
                CONTROL.L = 0
            elseif KEY == "D" then
                CONTROL.R = 0
            elseif KEY == "E" then
                CONTROL.Q = 0
            elseif KEY == "Q" then
                CONTROL.E = 0
            end
        end
    end)
    FLY()
end

local function NOFLY()
    FLYING = false
    if flyKeyDown then flyKeyDown:Disconnect() end
    if flyKeyUp then flyKeyUp:Disconnect() end
    if mfly1 then mfly1:Disconnect() end
    if mfly2 then mfly2:Disconnect() end
    if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
    end
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local function UnMobileFly()
    pcall(function()
        FLYING = false
        local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        if root:FindFirstChild("BodyVelocity") then root:FindFirstChild("BodyVelocity"):Destroy() end
        if root:FindFirstChild("BodyGyro") then root:FindFirstChild("BodyGyro"):Destroy() end
        if Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
            Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
        end
        if mfly1 then mfly1:Disconnect() end
        if mfly2 then mfly2:Disconnect() end
    end)
end

local function MobileFly()
    UnMobileFly()
    FLYING = true

    local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera
    local v3none = Vector3.new()
    local v3zero = Vector3.new(0, 0, 0)
    local v3inf = Vector3.new(9e9, 9e9, 9e9)

    local controlModule = require(Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    local bv = Instance.new("BodyVelocity")
    bv.Name = "BodyVelocity"
    bv.Parent = root
    bv.MaxForce = v3zero
    bv.Velocity = v3zero

    local bg = Instance.new("BodyGyro")
    bg.Name = "BodyGyro"
    bg.Parent = root
    bg.MaxTorque = v3inf
    bg.P = 1000
    bg.D = 50

    mfly1 = Players.LocalPlayer.CharacterAdded:Connect(function()
        local newRoot = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        local newBv = Instance.new("BodyVelocity")
        newBv.Name = "BodyVelocity"
        newBv.Parent = newRoot
        newBv.MaxForce = v3zero
        newBv.Velocity = v3zero

        local newBg = Instance.new("BodyGyro")
        newBg.Name = "BodyGyro"
        newBg.Parent = newRoot
        newBg.MaxTorque = v3inf
        newBg.P = 1000
        newBg.D = 50
    end)

    mfly2 = game:GetService("RunService").RenderStepped:Connect(function()
        root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        camera = workspace.CurrentCamera
        if Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild("BodyVelocity") and root:FindFirstChild("BodyGyro") then
            local humanoid = Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            local VelocityHandler = root:FindFirstChild("BodyVelocity")
            local GyroHandler = root:FindFirstChild("BodyGyro")

            VelocityHandler.MaxForce = v3inf
            GyroHandler.MaxTorque = v3inf
            humanoid.PlatformStand = true
            GyroHandler.CFrame = camera.CoordinateFrame
            VelocityHandler.Velocity = v3none

            local direction = controlModule:GetMoveVector()
            if direction.X > 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * (flySpeed * 50))
            end
            if direction.X < 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * (flySpeed * 50))
            end
            if direction.Z > 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * (flySpeed * 50))
            end
            if direction.Z < 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * (flySpeed * 50))
            end
        end
    end)
end

-- ESP Functions
function createESPText(part, text, color)
    if part:FindFirstChild("ESPTexto") then return end

    local esp = Instance.new("BillboardGui")
    esp.Name = "ESPTexto"
    esp.Adornee = part
    esp.Size = UDim2.new(0, 100, 0, 20)
    esp.StudsOffset = Vector3.new(0, 2.5, 0)
    esp.AlwaysOnTop = true
    esp.MaxDistance = 300

    local label = Instance.new("TextLabel")
    label.Parent = esp
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255,255,0)
    label.TextStrokeTransparency = 0.2
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold

    esp.Parent = part
end

local function Aesp(nome, tipo)
    local container
    local color
    if tipo == "item" then
        container = workspace:FindFirstChild("Items")
        color = Color3.fromRGB(0, 255, 0)
    elseif tipo == "mob" then
        container = workspace:FindFirstChild("Characters")
        color = Color3.fromRGB(255, 255, 0)
    else
        return
    end
    if not container then return end

    for _, obj in ipairs(container:GetChildren()) do
        if obj.Name == nome then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                createESPText(part, obj.Name, color)
            end
        end
    end
end

local function Desp(nome, tipo)
    local container
    if tipo == "item" then
        container = workspace:FindFirstChild("Items")
    elseif tipo == "mob" then
        container = workspace:FindFirstChild("Characters")
    else
        return
    end
    if not container then return end

    for _, obj in ipairs(container:GetChildren()) do
        if obj.Name == nome then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                for _, gui in ipairs(part:GetChildren()) do
                    if gui:IsA("BillboardGui") and gui.Name == "ESPTexto" then
                        gui:Destroy()
                    end
                end
            end
        end
    end
end

-- Create Window
local Window = WindUI:CreateWindow({
    Title = "GalacticScripts Hub",
    Icon = "rbxassetid://838383883838", 
    Author = "GalacticScripts",
    Folder = "GalacticScripts Hub",
    Size = UDim2.fromOffset(500, 350),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
           
            WindUI:Notify({
                Title = "Theme Changed",
                Content = "Switched to " .. newTheme .. " theme!",
                Duration = 2,
                Icon = "palette"
            })
        end,
    },
})

Window:SetToggleKey(Enum.KeyCode.V)

-- Transparency Toggle
pcall(function()
    Window:CreateTopbarButton("TransparencyToggle", "eye", function()
        if getgenv().TransparencyEnabled then
            getgenv().TransparencyEnabled = false
            pcall(function() Window:ToggleTransparency(false) end)
            
            WindUI:Notify({
                Title = "Transparency", 
                Content = "Transparency disabled",
                Duration = 3,
                Icon = "eye"
            })
        else
            getgenv().TransparencyEnabled = true
            pcall(function() Window:ToggleTransparency(true) end)
            
            WindUI:Notify({
                Title = "Transparency",
                Content = "Transparency enabled", 
                Duration = 3,
                Icon = "eye-off"
            })
        end
    end, 990)
end)

Window:EditOpenButton({
    Title = "GalacticScripts Hub - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

-- Create Tabs
local Tabs = {}

Tabs.Info = Window:Tab({
    Title = "Information",
    Icon = "badge-info",
    Desc = "GalacticScripts Hub"
})

Tabs.Main = Window:Tab({
    Title = "Main",
    Icon = "rocket",
    Desc = "GalacticScripts Hub"
})

Tabs.Auto = Window:Tab({
    Title = "Auto",
    Icon = "wrench",
    Desc = "GalacticScripts Hub"
})

Tabs.Bring = Window:Tab({
    Title = "Bring",
    Icon = "package",
    Desc = "GalacticScripts Hub"
})

Tabs.Combat = Window:Tab({
    Title = "Combat",
    Icon = "sword",
    Desc = "GalacticScripts Hub"
})

Tabs.Player = Window:Tab({
    Title = "Player",
    Icon = "user",
    Desc = "GalacticScripts Hub"
})

Tabs.ESP = Window:Tab({
    Title = "Esp",
    Icon = "eye",
    Desc = "GalacticScripts Hub"
})

Tabs.Teleport = Window:Tab({
    Title = "Teleport",
    Icon = "map",
    Desc = "GalacticScripts Hub"
})

Tabs.Farm = Window:Tab({
    Title = "Farm",
    Icon = "crown",
    Desc = "GalacticScripts Hub"
})

Tabs.Anti = Window:Tab({
    Title = "Anti",
    Icon = "shield",
    Desc = "GalacticScripts Hub"
})

Tabs.Vision = Window:Tab({
    Title = "Settings",
    Icon = "settings",
    Desc = "GalacticScripts Hub"
})

Window:SelectTab(1)

-- COMBAT TAB
Tabs.Combat:Section({ Title = "Aura", Icon = "star" })

Tabs.Combat:Toggle({
    Title = "Kill Aura",
    Value = false,
    Callback = function(state)
        killAuraToggle = state
        if state then
            task.spawn(killAuraLoop)
        else
            local tool, _ = getAnyToolWithDamageID(false)
            unequipTool(tool)
        end
    end
})

Tabs.Combat:Toggle({
    Title = "Chop Aura",
    Value = false,
    Callback = function(state)
        chopAuraToggle = state
        if state then
            task.spawn(chopAuraLoop)
        else
            local tool, _ = getAnyToolWithDamageID(true)
            unequipTool(tool)
        end
    end
})

Tabs.Combat:Section({ Title = "Plant Settings", Icon = "axe" })

Tabs.Combat:Toggle({
    Title = "Auto Plant",
    Value = false,
    Callback = function(state)
        AutoPlantToggle = state
        if state then
            task.spawn(autoplant)
        end
    end
})

Tabs.Combat:Section({ Title = "Settings", Icon = "settings" })

Tabs.Combat:Slider({
    Title = "Aura Radius",
    Value = { Min = 20, Max = 800, Default = 50 },
    Callback = function(value)
        auraRadius = math.clamp(value, 10, 800)
    end
})

-- MAIN TAB
Tabs.Main:Section({ Title = "Auto Feed", Icon = "utensils" })

Tabs.Main:Dropdown({
    Title = "Select Food",
    Desc = "Choose the food",
    Values = alimentos,
    Value = selectedFood,
    Multi = true,
    Callback = function(value)
        selectedFood = value
    end
})

Tabs.Main:Input({
    Title = "Feed Amount",
    Desc = "Eat when hunger reaches this %",
    Value = tostring(hungerThreshold),
    Placeholder = "Ex: 50",
    Numeric = true,
    Callback = function(value)
        local n = tonumber(value)
        if n then
            hungerThreshold = math.clamp(n, 0, 100)
        end
    end
})

Tabs.Main:Toggle({
    Title = "Auto Feed",
    Value = false,
    Callback = function(state)
        autoFeedToggle = state
        if state then
            task.spawn(function()
                while autoFeedToggle do
                    task.wait(0.075)
                    for _, foodName in ipairs(selectedFood) do
                        if wiki(foodName) == 0 then
                            autoFeedToggle = false
                            notifeed(foodName)
                            break
                        end
                        if ghn() <= hungerThreshold then
                            feed(foodName)
                        end
                    end
                end
            end)
        end
    end
})

Tabs.Main:Section({ Title = "Misc", Icon = "settings" })

local instantInteractEnabled = false
local instantInteractConnection
local originalHoldDurations = {}

Tabs.Main:Toggle({
    Title = "Instant Interact",
    Value = false,
    Callback = function(state)
        instantInteractEnabled = state

        if state then
            originalHoldDurations = {}
            instantInteractConnection = task.spawn(function()
                while instantInteractEnabled do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            if originalHoldDurations[obj] == nil then
                                originalHoldDurations[obj] = obj.HoldDuration
                            end
                            obj.HoldDuration = 0
                        end
                    end
                    task.wait(5)
                end
            end)
        else
            if instantInteractConnection then
                instantInteractEnabled = false
            end
            for obj, value in pairs(originalHoldDurations) do
                if obj and obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = value
                end
            end
            originalHoldDurations = {}
        end
    end
})

-- AUTO TAB
Tabs.Auto:Section({ Title = "Auto Upgrade Campfire", Icon = "flame" })

Tabs.Auto:Dropdown({
    Title = "Auto Upgrade Campfire",
    Desc = "Choose the items",
    Values = campfireFuelItems,
    Multi = false,
    AllowNone = true,
    Callback = function(option)
        selectedCampfireItem = option
    end
})

Tabs.Auto:Toggle({
    Title = "Auto Upgrade Campfire",
    Value = false,
    Callback = function(checked)
        autoUpgradeCampfireEnabled = checked
        if checked then
            task.spawn(function()
                while autoUpgradeCampfireEnabled do
                    if selectedCampfireItem then
                        for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
                            if item.Name == selectedCampfireItem then
                                moveItemToPos(item, campfireDropPos)
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

Tabs.Auto:Section({ Title = "Auto Scrap Items", Icon = "cog" })

Tabs.Auto:Dropdown({
    Title = "Auto Scrap Items",
    Desc = "Choose the items",
    Values = scrapjunkItems,
    Multi = false,
    AllowNone = true,
    Callback = function(option)
        selectedScrapItem = option
    end
})

Tabs.Auto:Toggle({
    Title = "Auto Scrap Item",
    Value = false,
    Callback = function(checked)
        autoScrapItemsEnabled = checked
        if checked then
            task.spawn(function()
                while autoScrapItemsEnabled do
                    if selectedScrapItem then
                        for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
                            if item.Name == selectedScrapItem then
                                moveItemToPos(item, autoScrapPos)
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

Tabs.Auto:Section({ Title = "Auto Cook Food", Icon = "flame" })

Tabs.Auto:Dropdown({
    Title = "Auto Cook Food",
    Values = autocookItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        for _, itemName in ipairs(autocookItems) do
            autoCookEnabledItems[itemName] = table.find(options, itemName) ~= nil
        end
    end
})

Tabs.Auto:Toggle({
    Title = "Auto Cook Food",
    Value = false,
    Callback = function(state)
        autoCookEnabled = state
    end
})

coroutine.wrap(function()
    while true do
        if autoCookEnabled then
            for itemName, enabled in pairs(autoCookEnabledItems) do
                if enabled then
                    for _, item in ipairs(Workspace:WaitForChild("Items"):GetChildren()) do
                        if item.Name == itemName then
                            moveItemToPos(item, campfireDropPos)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)()

-- BRING TAB
Tabs.Bring:Section({ Title = "Junk", Icon = "box" })

Tabs.Bring:Dropdown({
    Title = "Select Junk Items",
    Desc = "Choose items to bring",
    Values = junkItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedJunkItems = options
    end
})

Tabs.Bring:Toggle({
    Title = "Bring Junk Items",
    Desc = "Before you Bring Unlocked 1 zone first!",
    Default = false,
    Callback = function(value)
        junkToggleEnabled = value
        
        if value then
            if #selectedJunkItems > 0 then
                junkLoopRunning = true
                spawn(function()
                    while junkLoopRunning and junkToggleEnabled do
                        if #selectedJunkItems > 0 and junkToggleEnabled then
                            bypassBringSystem(selectedJunkItems, function() return junkToggleEnabled end)
                        end
                        
                        local waitTime = 0
                        while waitTime < 3 and junkToggleEnabled and junkLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    junkLoopRunning = false
                end)
            else
                junkToggleEnabled = false
            end
        else
            junkLoopRunning = false
        end
    end
})

Tabs.Bring:Section({ Title = "Fuel", Icon = "flame" })

Tabs.Bring:Dropdown({
    Title = "Select Fuel Items",
    Desc = "Choose items to bring",
    Values = fuelItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedFuelItems = options
    end
})

Tabs.Bring:Toggle({
    Title = "Bring Fuel Items",
    Desc = "Before you Bring Unlocked 1 Zone First!",
    Default = false,
    Callback = function(value)
        fuelToggleEnabled = value
        
        if value then
            if #selectedFuelItems > 0 then
                fuelLoopRunning = true
                spawn(function()
                    while fuelLoopRunning and fuelToggleEnabled do
                        if #selectedFuelItems > 0 and fuelToggleEnabled then
                            bypassBringSystem(selectedFuelItems, function() return fuelToggleEnabled end)
                        end
                        
                        local waitTime = 0
                        while waitTime < 3 and fuelToggleEnabled and fuelLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    fuelLoopRunning = false
                end)
            else
                fuelToggleEnabled = false
            end
        else
            fuelLoopRunning = false
        end
    end
})

Tabs.Bring:Section({ Title = "Food", Icon = "utensils" })

Tabs.Bring:Dropdown({
    Title = "Select Food Items",
    Desc = "Choose items to bring",
    Values = foodItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedFoodItems = options
    end
})

Tabs.Bring:Toggle({
    Title = "Bring Food items",
    Desc = "Before you Bring Unlocked 1 Zone First!",
    Default = false,
    Callback = function(value)
        foodToggleEnabled = value
        
        if value then
            if #selectedFoodItems > 0 then
                foodLoopRunning = true
                spawn(function()
                    while foodLoopRunning and foodToggleEnabled do
                        if #selectedFoodItems > 0 and foodToggleEnabled then
                            bypassBringSystem(selectedFoodItems, function() return foodToggleEnabled end)
                        end
                        
                        local waitTime = 0
                        while waitTime < 3 and foodToggleEnabled and foodLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    foodLoopRunning = false                 
                end)
            else                
                foodToggleEnabled = false
            end
        else
            foodLoopRunning = false          
        end
    end
})

Tabs.Bring:Section({ Title = "Medicine", Icon = "bandage" })

Tabs.Bring:Dropdown({
    Title = "Select Medical Items",
    Desc = "Choose items to bring",
    Values = medicalItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedMedicalItems = options
    end
})

Tabs.Bring:Toggle({
    Title = "Bring Medical Items",
    Desc = "Before you Bring Unlocked 1 Zone First!",
    Default = false,
    Callback = function(value)
        medicalToggleEnabled = value
        
        if value then
            if #selectedMedicalItems > 0 then
                medicalLoopRunning = true
                spawn(function()
                    while medicalLoopRunning and medicalToggleEnabled do
                        if #selectedMedicalItems > 0 and medicalToggleEnabled then
                            bypassBringSystem(selectedMedicalItems, function() return medicalToggleEnabled end)
                        end
                        
                        local waitTime = 0
                        while waitTime < 3 and medicalToggleEnabled and medicalLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    medicalLoopRunning = false
                end)
            else
                medicalToggleEnabled = false
            end
        else
            medicalLoopRunning = false
        end
    end
})

Tabs.Bring:Section({ Title = "Equipment", Icon = "sword" })

Tabs.Bring:Dropdown({
    Title = "Select Equipment Items",
    Desc = "Choose items to bring",
    Values = equipmentItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedEquipmentItems = options
    end
})

Tabs.Bring:Toggle({
    Title = "Bring Equipment Items",
    Desc = "Before you Bring Unlocked 1 Zone First!",
    Default = false,
    Callback = function(value)
        equipmentToggleEnabled = value
        
        if value then
            if #selectedEquipmentItems > 0 then
                equipmentLoopRunning = true
                spawn(function()
                    while equipmentLoopRunning and equipmentToggleEnabled do
                        if #selectedEquipmentItems > 0 and equipmentToggleEnabled then
                            bypassBringSystem(selectedEquipmentItems, function() return equipmentToggleEnabled end)
                        end
                        
                        local waitTime = 0
                        while waitTime < 3 and equipmentToggleEnabled and equipmentLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    equipmentLoopRunning = false
                end)
            else
                equipmentToggleEnabled = false
            end
        else
            equipmentLoopRunning = false
        end
    end
})

-- PLAYER TAB
Tabs.Player:Section({ Title = "Player Settings", Icon = "user" })

Tabs.Player:Slider({
    Title = "Fly Speed",
    Value = { Min = 1, Max = 20, Default = 1 },
    Callback = function(value)
        flySpeed = value
        if FLYING then
            task.spawn(function()
                while FLYING do
                    task.wait(0.1)
                    if game:GetService("UserInputService").TouchEnabled then
                        local root = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root and root:FindFirstChild("BodyVelocity") then
                            local bv = root:FindFirstChild("BodyVelocity")
                            bv.Velocity = bv.Velocity.Unit * (flySpeed * 50)
                        end
                    end
                end
            end)
        end
    end
})

Tabs.Player:Toggle({
    Title = "Enable Fly",
    Value = false,
    Callback = function(state)
        flyToggle = state
        if flyToggle then
            if game:GetService("UserInputService").TouchEnabled then
                MobileFly()
            else
                sFLY()
            end
        else
            NOFLY()
            UnMobileFly()
        end
    end
})

local speed = 16

local function setSpeed(val)
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = val end
end

Tabs.Player:Slider({
    Title = "Speed",
    Value = { Min = 16, Max = 150, Default = 16 },
    Callback = function(value)
        speed = value
    end
})

Tabs.Player:Toggle({
    Title = "Enable Speed",
    Value = false,
    Callback = function(state)
        setSpeed(state and speed or 16)
    end
})

Tabs.Player:Section({ Title = "Power Settings", Icon = "flame" })

local noclipConnection

Tabs.Player:Toggle({
    Title = "No Clip",
    Value = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = Players.LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
    end
})

local UserInputService = game:GetService("UserInputService")
local infJumpConnection

Tabs.Player:Toggle({
    Title = "Inf Jump",
    Value = false,
    Callback = function(state)
        if state then
            infJumpConnection = UserInputService.JumpRequest:Connect(function()
                local char = Players.LocalPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infJumpConnection then
                infJumpConnection:Disconnect()
                infJumpConnection = nil
            end
        end
    end
})

-- ESP TAB
Tabs.ESP:Section({ Title = "Esp Items", Icon = "package" })

local selectedItems = {}
local selectedMobs = {}
local espItemsEnabled = false
local espMobsEnabled = false
local espConnections = {}

Tabs.ESP:Dropdown({
    Title = "Esp Items",
    Values = ie,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedItems = options
        if espItemsEnabled then
            for _, name in ipairs(ie) do
                if table.find(selectedItems, name) then
                    Aesp(name, "item")
                else
                    Desp(name, "item")
                end
            end
        else
            for _, name in ipairs(ie) do
                Desp(name, "item")
            end
        end
    end
})

Tabs.ESP:Toggle({
    Title = "Enable Esp",
    Value = false,
    Callback = function(state)
        espItemsEnabled = state
        for _, name in ipairs(ie) do
            if state and table.find(selectedItems, name) then
                Aesp(name, "item")
            else
                Desp(name, "item")
            end
        end

        if state then
            if not espConnections["Items"] then
                local container = workspace:FindFirstChild("Items")
                if container then
                    espConnections["Items"] = container.ChildAdded:Connect(function(obj)
                        if table.find(selectedItems, obj.Name) then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                createESPText(part, obj.Name, Color3.fromRGB(0, 255, 0))
                            end
                        end
                    end)
                end
            end
        else
            if espConnections["Items"] then
                espConnections["Items"]:Disconnect()
                espConnections["Items"] = nil
            end
        end
    end
})

Tabs.ESP:Section({ Title = "Esp Entity", Icon = "user" })

Tabs.ESP:Dropdown({
    Title = "Esp Entity",
    Values = me,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedMobs = options
        if espMobsEnabled then
            for _, name in ipairs(me) do
                if table.find(selectedMobs, name) then
                    Aesp(name, "mob")
                else
                    Desp(name, "mob")
                end
            end
        else
            for _, name in ipairs(me) do
                Desp(name, "mob")
            end
        end
    end
})

Tabs.ESP:Toggle({
    Title = "Enable Esp",
    Value = false,
    Callback = function(state)
        espMobsEnabled = state
        for _, name in ipairs(me) do
            if state and table.find(selectedMobs, name) then
                Aesp(name, "mob")
            else
                Desp(name, "mob")
            end
        end

        if state then
            if not espConnections["Mobs"] then
                local container = workspace:FindFirstChild("Characters")
                if container then
                    espConnections["Mobs"] = container.ChildAdded:Connect(function(obj)
                        if table.find(selectedMobs, obj.Name) then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                createESPText(part, obj.Name, Color3.fromRGB(255, 255, 0))
                            end
                        end
                    end)
                end
            end
        else
            if espConnections["Mobs"] then
                espConnections["Mobs"]:Disconnect()
                espConnections["Mobs"] = nil
            end
        end
    end
})

-- TELEPORT TAB
local scan_map = false

Tabs.Teleport:Section({ Title = "Scan Map", Icon = "map" })

Tabs.Teleport:Toggle({
    Title = "Scan Map (Essential)",
    Default = false,
    Callback = function(state)
        scan_map = state

        if not state then
            if type(tp1) == "function" and scan_map_was_on then
                tp1()
            end
            scan_map_was_on = false
            return
        else
            scan_map_was_on = true
        end

        task.spawn(function()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 3)
            if not hrp then return end

            local map = workspace:FindFirstChild("Map")
            if not map then return end

            local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
            if not foliage then return end

            while scan_map do
                local trees = {}
                for _, obj in ipairs(foliage:GetChildren()) do
                    if obj.Name == "Small Tree" and obj:IsA("Model") then
                        local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                        if trunk then
                            table.insert(trees, trunk)
                        end
                    end
                end

                for _, trunk in ipairs(trees) do
                    if not scan_map then break end
                    if trunk and trunk.Parent then
                        local treeCFrame = trunk.CFrame
                        local rightVector = treeCFrame.RightVector
                        local targetPosition = treeCFrame.Position + rightVector * 69 + Vector3.new(0, 15, 69)
                        
                        hrp.CFrame = CFrame.new(targetPosition)

                        local footPart = Instance.new("Part")
                        footPart.Size = Vector3.new(10, 1, 10)
                        footPart.Anchored = true
                        footPart.CanCollide = true
                        footPart.Transparency = 1
                        footPart.BrickColor = BrickColor.new("Bright yellow")
                        footPart.CFrame = CFrame.new(targetPosition - Vector3.new(0, 3, 0))
                        footPart.Parent = workspace

                        game.Debris:AddItem(footPart, 1)

                        task.wait(0.01)
                    end
                end
                task.wait(0.25)
            end
        end)
    end
})

Tabs.Teleport:Section({ Title = "Teleport", Icon = "map" })

Tabs.Teleport:Button({
    Title = "Teleport to Campfire",
    Locked = false,
    Callback = function()
        tp1()
    end
})

Tabs.Teleport:Button({
    Title = "Teleport to Stronghold",
    Locked = false,
    Callback = function()
        tp2()
    end
})

Tabs.Teleport:Button({
    Title = "Teleport to Safe Zone",
    Callback = function()
        if not workspace:FindFirstChild("SafeZonePart") then
            local createpart = Instance.new("Part")
            createpart.Name = "SafeZonePart"
            createpart.Size = Vector3.new(30, 3, 30)
            createpart.Position = Vector3.new(0, 350, 0)
            createpart.Anchored = true
            createpart.CanCollide = true
            createpart.Transparency = 0.8
            createpart.Color = Color3.fromRGB(255, 0, 0)
            createpart.Parent = workspace
        end
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(0, 360, 0)
    end
})

Tabs.Teleport:Button({
    Title = "Teleport to Trader (Bunny Foot)",
    Callback = function()
        local pos = Vector3.new(-37.08, 3.98, -16.33)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos)
    end
})

Tabs.Teleport:Section({ Title = "Tree", Icon = "tree-deciduous" })

Tabs.Teleport:Button({
    Title = "Teleport to Random Tree",
    Callback = function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart", 3)
        if not hrp then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end

        local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
        if not foliage then return end

        local trees = {}
        for _, obj in ipairs(foliage:GetChildren()) do
            if obj.Name == "Small Tree" and obj:IsA("Model") then
                local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                if trunk then
                    table.insert(trees, trunk)
                end
            end
        end

        if #trees > 0 then
            local trunk = trees[math.random(1, #trees)]
            local treeCFrame = trunk.CFrame
            local rightVector = treeCFrame.RightVector
            local targetPosition = treeCFrame.Position + rightVector * 3
            hrp.CFrame = CFrame.new(targetPosition)
        end
    end
})

-- ANTI TAB
Tabs.Anti:Section({ Title = "Anti Monster", Icon = "skull" })

local torchLoop = nil

Tabs.Anti:Toggle({
    Title = "Auto Stun Deer (Need Flashlight)",
    Value = false,
    Callback = function(state)
        if state then
            torchLoop = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local remote = ReplicatedStorage:FindFirstChild("RemoteEvents")
                        and ReplicatedStorage.RemoteEvents:FindFirstChild("DeerHitByTorch")
                    local deer = workspace:FindFirstChild("Characters")
                        and workspace.Characters:FindFirstChild("Deer")
                    if remote and deer then
                        remote:InvokeServer(deer)
                    end
                end)
                task.wait(0.1)
            end)
        else
            if torchLoop then
                torchLoop:Disconnect()
                torchLoop = nil
            end
        end
    end
})

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

local ESCAPE_DISTANCE_OWL = 80
local ESCAPE_SPEED_OWL = 5

local ESCAPE_DISTANCE_DEER = 60
local ESCAPE_SPEED_DEER = 4

local escapeLoopOwl
local escapeLoopDeer

Tabs.Anti:Toggle({
    Title = "Escape From Owl", 
    Value = false,
    Callback = function(state)
        if state then
            escapeLoopOwl = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local owl = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild("Owl")
                    if owl and owl:FindFirstChild("HumanoidRootPart") then
                        local myPos = HumanoidRootPart.Position
                        local owlPos = owl.HumanoidRootPart.Position
                        local distance = (myPos - owlPos).Magnitude

                        if distance < ESCAPE_DISTANCE_OWL then
                            local direction = (myPos - owlPos).Unit
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * ESCAPE_SPEED_OWL
                        end
                    end
                end)
            end)
        else
            if escapeLoopOwl then
                escapeLoopOwl:Disconnect()
                escapeLoopOwl = nil
            end
        end
    end
})

Tabs.Anti:Toggle({
    Title = "Escape From Deer", 
    Value = false,
    Callback = function(state)
        if state then
            escapeLoopDeer = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local deer = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild("Deer")
                    if deer and deer:FindFirstChild("HumanoidRootPart") then
                        local myPos = HumanoidRootPart.Position
                        local deerPos = deer.HumanoidRootPart.Position
                        local distance = (myPos - deerPos).Magnitude

                        if distance < ESCAPE_DISTANCE_DEER then
                            local direction = (myPos - deerPos).Unit
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * ESCAPE_SPEED_DEER
                        end
                    end
                end)
            end)
        else
            if escapeLoopDeer then
                escapeLoopDeer:Disconnect()
                escapeLoopDeer = nil
            end
        end
    end
})

-- VISION/SETTINGS TAB
local originalParents = {
    Sky = nil,
    Bloom = nil,
    CampfireEffect = nil
}

local function storeOriginalParents()
    local sky = Lighting:FindFirstChild("Sky")
    local bloom = Lighting:FindFirstChild("Bloom")
    local campfireEffect = Lighting:FindFirstChild("CampfireEffect")
    
    if sky and not originalParents.Sky then
        originalParents.Sky = sky.Parent
    end
    if bloom and not originalParents.Bloom then
        originalParents.Bloom = bloom.Parent
    end
    if campfireEffect and not originalParents.CampfireEffect then
        originalParents.CampfireEffect = campfireEffect.Parent
    end
end

storeOriginalParents()

local originalColorCorrectionParent = nil

local function storeColorCorrectionParent()
    local colorCorrection = Lighting:FindFirstChild("ColorCorrection")
    
    if colorCorrection and not originalColorCorrectionParent then
        originalColorCorrectionParent = colorCorrection.Parent
    end
end

storeColorCorrectionParent()

Tabs.Vision:Section({ Title = "Vision", Icon = "eye" })

Tabs.Vision:Toggle({
    Title = "Disable Fog",
    Desc = "",
    Value = false,
    Callback = function(state)
        if state then
            local sky = Lighting:FindFirstChild("Sky")
            local bloom = Lighting:FindFirstChild("Bloom")
            local campfireEffect = Lighting:FindFirstChild("CampfireEffect")
            
            if sky then
                sky.Parent = nil
            end
            if bloom then
                bloom.Parent = nil
            end
            if campfireEffect then
                campfireEffect.Parent = nil
            end
        else
            local sky = game:FindFirstChild("Sky", true)
            local bloom = game:FindFirstChild("Bloom", true) 
            local campfireEffect = game:FindFirstChild("CampfireEffect", true)
            
            if not sky then sky = Lighting:FindFirstChild("Sky") end
            if not bloom then bloom = Lighting:FindFirstChild("Bloom") end
            if not campfireEffect then campfireEffect = Lighting:FindFirstChild("CampfireEffect") end
            
            if sky then
                sky.Parent = originalParents.Sky or Lighting
            end
            if bloom then
                bloom.Parent = originalParents.Bloom or Lighting
            end
            if campfireEffect then
                campfireEffect.Parent = originalParents.CampfireEffect or Lighting
            end
        end
    end
})

local originalLightingValues = {
    Brightness = nil,
    Ambient = nil,
    OutdoorAmbient = nil,
    ShadowSoftness = nil,
    GlobalShadows = nil,
    Technology = nil
}

local function storeOriginalLighting()
    if not originalLightingValues.Brightness then
        originalLightingValues.Brightness = Lighting.Brightness
        originalLightingValues.Ambient = Lighting.Ambient
        originalLightingValues.OutdoorAmbient = Lighting.OutdoorAmbient
        originalLightingValues.ShadowSoftness = Lighting.ShadowSoftness
        originalLightingValues.GlobalShadows = Lighting.GlobalShadows
        originalLightingValues.Technology = Lighting.Technology
    end
end

storeOriginalLighting()

Tabs.Vision:Toggle({
    Title = "Disable NightCampFire Effect",
    Desc = "",
    Value = false,
    Callback = function(state)
        if state then
            local colorCorrection = Lighting:FindFirstChild("ColorCorrection")
            
            if colorCorrection then
                if not originalColorCorrectionParent then
                    originalColorCorrectionParent = colorCorrection.Parent
                end
                colorCorrection.Parent = nil
            end
        else
            local colorCorrection = nil
            
            colorCorrection = Lighting:FindFirstChild("ColorCorrection")
            
            if not colorCorrection then
                colorCorrection = game:FindFirstChild("ColorCorrection", true)
            end
            
            if colorCorrection then
                colorCorrection.Parent = Lighting
            end
        end
    end
})

Tabs.Vision:Section({ Title = "Visual", Icon = "lightbulb" })

Tabs.Vision:Toggle({
    Title = "Full Bright",
    Desc = "",
    Value = false,
    Callback = function(state)
        if state then
            Lighting.ClockTime = 14
            Lighting.Brightness = 2.2
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.ShadowSoftness = 0
            Lighting.GlobalShadows = false
            Lighting.Technology = Enum.Technology.Compatibility
        else
            Lighting.Brightness = originalLightingValues.Brightness
            Lighting.Ambient = originalLightingValues.Ambient
            Lighting.OutdoorAmbient = originalLightingValues.OutdoorAmbient
            Lighting.ShadowSoftness = originalLightingValues.ShadowSoftness
            Lighting.GlobalShadows = originalLightingValues.GlobalShadows
            Lighting.Technology = originalLightingValues.Technology
        end
    end
})

local NoFogToggle = false
local OriginalFogStart = Lighting.FogStart
local OriginalFogEnd = Lighting.FogEnd

Tabs.Vision:Toggle({
    Title = "No Fog",
    Desc = "",
    Value = false,
    Callback = function(state)
        NoFogToggle = state
        
        if not state then
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogStart = OriginalFogStart
            Lighting.FogEnd = OriginalFogEnd
        end
    end
})

RunService.Heartbeat:Connect(function()
    if NoFogToggle then
        if Lighting.FogStart ~= 100000 or Lighting.FogEnd ~= 100000 then
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogStart = 100000
            Lighting.FogEnd = 100000
        end
    end
end)

local vibrantEffect = Lighting:FindFirstChild("VibrantEffect")
if not vibrantEffect then
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    vibrantEffect = Instance.new("ColorCorrectionEffect")
    vibrantEffect.Name = "VibrantEffect"
    vibrantEffect.Saturation = 0.5
    vibrantEffect.Contrast = 0.2
    vibrantEffect.Brightness = 0.1
    vibrantEffect.Enabled = false
    vibrantEffect.Parent = Lighting
end

Tabs.Vision:Toggle({
    Title = "Vibrant Colors",
    Value = false,
    Callback = function(state)
        if state then
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 230, 200)
            Lighting.ColorShift_Bottom = Color3.fromRGB(200, 240, 255)
            if vibrantEffect then
                vibrantEffect.Enabled = true
            end
        else
            if vibrantEffect then
                vibrantEffect.Enabled = false
            end
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        end
    end
})

Tabs.Vision:Section({ Title = "Low Graphic", Icon = "user-cog" })

Tabs.Vision:Button({
    Title = "FPS Boost (By Roblox)",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 1
            lighting.FogEnd = 1000000
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        WindUI:Notify({
            Title = "FPS Boost Applied",
            Content = "Performance optimized successfully",
            Duration = 3
        })
    end
})

Tabs.Vision:Button({
    Title = "FPS Boost (By GalacticScripts Hub)",
    Callback = function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/Nigga.lua"))()
        end)

        if success then
            WindUI:Notify({
                Title = "FPS Boost Applied",
                Content = "Script loaded successfully",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Failed to load FPS boost script",
                Duration = 3
            })
        end
    end
})

-- FPS and Ping Display
local Stats = game:GetService("Stats")
local Camera = workspace.CurrentCamera

local showFPS, showPing = true, true
local fpsCounter, fpsLastUpdate, fpsValue = 0, tick(), 0

local function createText(yOffset)
    local textObj = Drawing.new("Text")
    textObj.Size = 16
    textObj.Position = Vector2.new(Camera.ViewportSize.X - 110, yOffset)
    textObj.Color = Color3.fromRGB(0, 255, 0)
    textObj.Center = false
    textObj.Outline = true
    textObj.Visible = true
    return textObj
end

local fpsText = createText(10)
local msText = createText(30)

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    fpsText.Position = Vector2.new(Camera.ViewportSize.X - 110, 10)
    msText.Position = Vector2.new(Camera.ViewportSize.X - 110, 30)
end)

RunService.RenderStepped:Connect(function()
    fpsCounter += 1

    if tick() - fpsLastUpdate >= 1 then
        fpsValue = fpsCounter
        fpsCounter = 0
        fpsLastUpdate = tick()

        if showFPS then
            fpsText.Text = string.format("FPS: %d", fpsValue)
            fpsText.Color = fpsValue >= 50 and Color3.fromRGB(0, 255, 0)
                or fpsValue >= 30 and Color3.fromRGB(255, 165, 0)
                or Color3.fromRGB(255, 0, 0)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end

        if showPing then
            local pingStat = Stats.Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            local color, label = Color3.fromRGB(0, 255, 0), "Ping: "

            if ping > 120 then
                color, label = Color3.fromRGB(255, 0, 0), "Ew Wifi Ping: "
            elseif ping > 60 then
                color = Color3.fromRGB(255, 165, 0)
            end

            msText.Text = string.format("%s%d ms", label, ping)
            msText.Color = color
            msText.Visible = true
        else
            msText.Visible = false
        end
    end
end)

Tabs.Vision:Section({ Title = "Show Status", Icon = "settings-2" })

Tabs.Vision:Toggle({
    Title = "Show FPS",
    Default = true,
    Callback = function(val)
        showFPS = val
        fpsText.Visible = val
    end
})

Tabs.Vision:Toggle({
    Title = "Show Ping",
    Default = true,
    Callback = function(val)
        showPing = val
        msText.Visible = val
    end
})

-- FARM TAB
Tabs.Farm:Section({ Title = "Auto Farm", Icon = "gem" })
Tabs.Farm:Section({ Title = "Feature: Auto Exe, Auto Server-Hop", Icon = "info" })

Tabs.Farm:Button({
    Title = "Auto Farm (Cào Mod)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/kuy/refs/heads/main/dyhub99night.lua"))()
    end
})

-- INFO TAB
local Info = Tabs["Info"]

if not ui then ui = {} end
if not ui.Creator then ui.Creator = {} end

ui.Creator.Request = function(requestData)
    local HttpService = game:GetService("HttpService")
    
    local success, result = pcall(function()
        if HttpService.RequestAsync then
            local response = HttpService:RequestAsync({
                Url = requestData.Url,
                Method = requestData.Method or "GET",
                Headers = requestData.Headers or {}
            })
            return {
                Body = response.Body,
                StatusCode = response.StatusCode,
                Success = response.Success
            }
        else
            local body = HttpService:GetAsync(requestData.Url)
            return {
                Body = body,
                StatusCode = 200,
                Success = true
            }
        end
    end)
    
    if success then
        return result
    else
        error("HTTP Request failed: " .. tostring(result))
    end
end

local InviteCode = "8hcbcDqfFM"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local function LoadDiscordInfo()
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(ui.Creator.Request({
            Url = DiscordAPI,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "RobloxBot/1.0",
                ["Accept"] = "application/json"
            }
        }).Body)
    end)

    if success and result and result.guild then
        local DiscordInfo = Info:Paragraph({
            Title = result.guild.name,
            Desc = ' <font color="#52525b">●</font> Member Count : ' .. tostring(result.approximate_member_count) ..
                '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(result.approximate_presence_count),
            Image = "https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=1024",
            ImageSize = 42,
        })

        Info:Button({
            Title = "Update Info",
            Callback = function()
                local updated, updatedResult = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(ui.Creator.Request({
                        Url = DiscordAPI,
                        Method = "GET",
                    }).Body)
                end)

                if updated and updatedResult and updatedResult.guild then
                    DiscordInfo:SetDesc(
                        ' <font color="#52525b">●</font> Member Count : ' .. tostring(updatedResult.approximate_member_count) ..
                        '\n <font color="#16a34a">●</font> Online Count : ' .. tostring(updatedResult.approximate_presence_count)
                    )
                    
                    WindUI:Notify({
                        Title = "Discord Info Updated",
                        Content = "Successfully refreshed Discord statistics",
                        Duration = 2,
                        Icon = "refresh-cw",
                    })
                else
                    WindUI:Notify({
                        Title = "Update Failed",
                        Content = "Could not refresh Discord info",
                        Duration = 3,
                        Icon = "alert-triangle",
                    })
                end
            end
        })

        Info:Button({
            Title = "Copy Discord Invite",
            Callback = function()
                setclipboard("https://discord.gg/" .. InviteCode)
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "Discord invite copied to clipboard",
                    Duration = 2,
                    Icon = "clipboard-check",
                })
            end
        })
    else
        Info:Paragraph({
            Title = "Error fetching Discord Info",
            Desc = "Unable to load Discord information. Check your internet connection.",
            Image = "triangle-alert",
            ImageSize = 26,
            Color = "Red",
        })
    end
end

LoadDiscordInfo()

Info:Divider()
Info:Section({ 
    Title = "GalacticScripts Hub Information",
    TextXAlignment = "Center",
    TextSize = 17,
})
Info:Divider()

Info:Paragraph({
    Title = "Main Owner",
    Desc = "porxiai",
    Image = "rbxassetid://73838388",
    ImageSize = 30,
})

Info:Paragraph({
    Title = "Social",
    Desc = "Copy link social media for follow!",
    Image = "rbxassetid://7373837",
    ImageSize = 30,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://discord.gg/8hcbcDqfFM")
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "Discord link copied to clipboard",
                    Duration = 2
                })
            end,
        }
    }
})

Info:Paragraph({
    Title = "Discord Server",
    Desc = "Join our discord for more scripts!",
    Image = "rbxassetid://17373838",
    ImageSize = 30,
    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Link",
            Callback = function()
                setclipboard("https://discord.gg/8hcbcDqfFM")
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "Discord link copied to clipboard",
                    Duration = 2
                })
            end,
        }
    }
})

----------------------------------------------------------------
-- >>> ADD-ON FEATURES (integrated as requested) <<
----------------------------------------------------------------

-- Adds:
-- 1) Instant Bag Children
-- 2) Auto Unlock All Available Chests
-- 3) Auto Get All Available Coin Stacks
-- 4) Auto Boost Pad when Near
-- 5) Bring Items Cooldown (UI slider)
-- 6) Kill Aura: Max Radius toggle
-- 7) Auto Cook Food quick-enable button (uses existing hub-2 cook flow)

-- ===== (5) Bring Items Cooldown: drop-in replacement wrapper =====
local bringCooldownSeconds = 0.35 -- default; configurable in UI below
do
    local _orig_bypass = bypassBringSystem
    if typeof(_orig_bypass) == "function" then
        bypassBringSystem = function(items, stopFlag)
            if isCollecting then return end
            isCollecting = true

            local player = Players.LocalPlayer
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                isCollecting = false
                return
            end

            local hrp = player.Character.HumanoidRootPart
            originalPosition = hrp.CFrame

            for _, itemName in ipairs(items) do
                if stopFlag and not stopFlag() then break end

                local itemsFound = {}
                for _, item in ipairs(workspace:GetDescendants()) do
                    if item.Name == itemName and (item:IsA("BasePart") or item:IsA("Model")) then
                        local ip = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
                        if ip and ip.Parent ~= player.Character then
                            table.insert(itemsFound, {item = item, part = ip})
                        end
                    end
                end

                for _, itemData in ipairs(itemsFound) do
                    if stopFlag and not stopFlag() then break end
                    local item = itemData.item
                    local itemPart = itemData.part
                    if itemPart and itemPart.Parent then
                        local itemPos = itemPart.CFrame + Vector3.new(0, 5, 0)
                        local playerPos = hrp.Position + Vector3.new(0, -1, 0)

                        pcall(function()
                            smoothPullToItem(hrp.CFrame, itemPos, itemPos)
                            createItemPullEffect(itemPart, playerPos, 0.8)

                            local keepAttached = true
                            task.spawn(function()
                                while keepAttached do
                                    if stopFlag and not stopFlag() then keepAttached = false break end
                                    if itemPart and itemPart.Parent and hrp and hrp.Parent then
                                        pcall(function()
                                            local offset = Vector3.new(
                                                math.sin(tick() * 2) * 0.5,
                                                -1 + math.cos(tick() * 3) * 0.2,
                                                math.cos(tick() * 2) * 0.5
                                            )
                                            itemPart.CFrame = CFrame.new(hrp.Position + offset)
                                            itemPart.Velocity = Vector3.new(0, 0, 0)
                                            itemPart.AngularVelocity = Vector3.new(0, 0, 0)
                                        end)
                                    end
                                    task.wait(0.03)
                                end
                            end)

                            smoothPullToItem(hrp.CFrame, originalPosition, originalPosition)
                            keepAttached = false
                            task.wait(0.1)

                            local landingPos = originalPosition.Position + Vector3.new(
                                math.random(-4, 4), 2, math.random(-4, 4)
                            )
                            createItemPullEffect(itemPart, landingPos, 0.5)
                        end)
                    end

                    task.wait(math.max(0, tonumber(bringCooldownSeconds) or 0.35))
                end
            end

            if originalPosition then hrp.CFrame = originalPosition end
            isCollecting = false
        end
    end
end

-- Hook cooldown slider into Bring tab
pcall(function()
    Tabs.Bring:Slider({
        Title = "Bring Item Cooldown (s)",
        Value = { Min = 0, Max = 2, Default = 0.35 },
        Callback = function(v)
            bringCooldownSeconds = tonumber(v) or 0.35
        end
    })
end)

----------------------------------------------------------------
-- Bring: spawn items in front of player (no campfire return)
----------------------------------------------------------------
local bringDropDist = 4      -- studs in front of player
local bringDropHeight = 1.5  -- height offset
local bringScatter = 1       -- small random scatter

-- optional UI sliders (keep or remove as you like)
pcall(function()
    Tabs.Bring:Slider({
        Title = "Bring Drop Distance",
        Value = { Min = 1, Max = 12, Default = bringDropDist },
        Callback = function(v) bringDropDist = tonumber(v) or 4 end
    })
    Tabs.Bring:Slider({
        Title = "Bring Drop Height",
        Value = { Min = 0, Max = 5, Default = bringDropHeight },
        Callback = function(v) bringDropHeight = tonumber(v) or 1.5 end
    })
end)

-- hard override so all Bring toggles use this behavior
do
    local _dragStart = function(it)
        pcall(function()
            game:GetService("ReplicatedStorage")
                :WaitForChild("RemoteEvents")
                :WaitForChild("RequestStartDraggingItem")
                :FireServer(it)
        end)
    end
    local _dragStop = function(it)
        pcall(function()
            game:GetService("ReplicatedStorage")
                :WaitForChild("RemoteEvents")
                :WaitForChild("StopDraggingItem")
                :FireServer(it)
        end)
    end

    bypassBringSystem = function(items, stopFlag)
        if isCollecting then return end
        isCollecting = true

        local player = game:GetService("Players").LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then isCollecting = false return end

        for _, itemName in ipairs(items) do
            if stopFlag and not stopFlag() then break end

            -- gather all targets first (prevents mid-loop changes)
            local targets = {}
            for _, d in ipairs(workspace:GetDescendants()) do
                if (d:IsA("BasePart") or d:IsA("Model")) and d.Name == itemName then
                    local part = d:IsA("Model") and (d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart")) or d
                    if part and part.Parent ~= char then
                        table.insert(targets, {inst = d, part = part})
                    end
                end
            end

            for _, t in ipairs(targets) do
                if stopFlag and not stopFlag() then break end

                local dropPos = hrp.Position
                    + (hrp.CFrame.LookVector * bringDropDist)
                    + Vector3.new(
                        (math.random() * 2 - 1) * bringScatter,
                        bringDropHeight,
                        (math.random() * 2 - 1) * bringScatter
                    )

                -- try drag-teleport first
                local ok = pcall(function()
                    _dragStart(t.inst)
                    if t.inst:IsA("Model") then
                        if not t.inst.PrimaryPart and t.part and t.part:IsA("BasePart") then
                            t.inst.PrimaryPart = t.part
                        end
                        t.inst:SetPrimaryPartCFrame(CFrame.new(dropPos))
                    else
                        t.part.CFrame = CFrame.new(dropPos)
                    end
                    _dragStop(t.inst)
                end)

                -- fallback: fire any prompt we can find
                if not ok then
                    local pp = t.inst:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if pp then
                        pcall(function() fireproximityprompt(pp, 1, true) end)
                    end
                end

                task.wait(math.max(0, tonumber(bringCooldownSeconds) or 0.35))
            end
        end

        isCollecting = false
    end
end
----------------------------------------------------------------


-- ===== (6) Kill Aura: Max Radius toggle =====
local maxAuraToggle = false
local previousAuraValue = auraRadius or 50
pcall(function()
    Tabs.Combat:Toggle({
        Title = "Max Aura Radius",
        Value = false,
        Callback = function(state)
            maxAuraToggle = state
            if state then
                previousAuraValue = auraRadius
                auraRadius = 800
            else
                auraRadius = previousAuraValue or 50
            end
        end
    })
end)

-- ===== (7) Auto Cook Food quick enable =====
pcall(function()
    Tabs.Auto:Button({
        Title = "Enable Auto Cook (All Foods)",
        Callback = function()
            for _, itemName in ipairs({"Morsel","Steak","Ribs","Salmon","Mackerel"}) do
                autoCookEnabledItems[itemName] = true
            end
            autoCookEnabled = true
            WindUI:Notify({ Title = "Auto Cook", Content = "Enabled for all raw foods.", Duration = 3 })
        end
    })
end)

-- ===== (1) Instant Bag Children =====
local instantBagChildrenToggle = false
local bagNames = {"Bag","LootBag","Sack","Good Sack","Giant Sack"}

local function isBag(model)
    if not model or not model.Name then return false end
    for _, n in ipairs(bagNames) do
        if string.find(string.lower(model.Name), string.lower(n)) then
            return true
        end
    end
    return false
end

local function collectFromBag(bag)
    if not bag then return end
    for _, obj in ipairs(bag:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            pcall(function() fireproximityprompt(obj, 1, true) end)
        end
        local part = (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))) or (obj:IsA("BasePart") and obj)
        if part then
            pcall(function()
                moveItemToPos(obj:IsA("Model") and obj or part, (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position) or Vector3.new())
            end)
        end
    end
end

local function bagSweep()
    for _, m in ipairs(Workspace:GetDescendants()) do
        if m:IsA("Model") and isBag(m) then
            collectFromBag(m)
        end
    end
end

pcall(function()
    Tabs.Auto:Toggle({
        Title = "Instant Bag Children",
        Value = false,
        Callback = function(state)
            instantBagChildrenToggle = state
        end
    })
end)

task.spawn(function()
    while task.wait(1.0) do
        if instantBagChildrenToggle then
            bagSweep()
        end
    end
end)

-- ===== (2) Auto Unlock All Available Chests =====
local autoChestToggle = false
local seenChestPrompt = {}

local function isChestPrompt(pp)
    if not pp or not pp.Parent then return false end
    if string.find(string.lower(pp.ObjectText or ""), "chest") then return true end
    local a = pp.Parent
    while a do
        if a.Name and string.find(string.lower(a.Name), "chest") then return true end
        a = a.Parent
    end
    return false
end

local function unlockNearbyChests()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, pp in ipairs(Workspace:GetDescendants()) do
        if pp:IsA("ProximityPrompt") and isChestPrompt(pp) then
            local adornee = pp.Parent:IsA("BasePart") and pp.Parent or pp.Parent:FindFirstChildWhichIsA("BasePart")
            local d = adornee and (adornee.Position - hrp.Position).Magnitude or 1e9
            if d <= 35 then
                if not seenChestPrompt[pp] then
                    seenChestPrompt[pp] = true
                    pcall(function() fireproximityprompt(pp, 1, true) end)
                    task.delay(8, function() seenChestPrompt[pp] = nil end)
                end
            end
        end
    end
end

pcall(function()
    Tabs.Auto:Toggle({
        Title = "Auto Unlock Chests (nearby)",
        Value = false,
        Callback = function(state)
            autoChestToggle = state
        end
    })
end)

task.spawn(function()
    while task.wait(0.5) do
        if autoChestToggle then
            unlockNearbyChests()
        end
    end
end)

-- ===== (3) Auto Get All Available Coin Stacks =====
local autoCoinsToggle = false

local function pullCoinStacks()
    local items = Workspace:FindFirstChild("Items")
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not items or not hrp then return end

    for _, it in ipairs(items:GetChildren()) do
        if it.Name == "Coin Stack" then
            local ok = pcall(function() moveItemToPos(it, hrp.Position + Vector3.new(0, 0.5, 0)) end)
            if not ok then
                local pp = it:FindFirstChildWhichIsA("ProximityPrompt", true)
                if pp then
                    pcall(function() fireproximityprompt(pp, 1, true) end)
                else
                    local back = hrp.CFrame
                    hrp.CFrame = (it:IsA("Model") and it.PrimaryPart and it.PrimaryPart.CFrame or (it:IsA("BasePart") and it.CFrame or hrp.CFrame)) + Vector3.new(0, 3, 0)
                    task.wait(0.2)
                    hrp.CFrame = back
                end
            end
            task.wait(0.15)
        end
    end
end

pcall(function()
    Tabs.Auto:Toggle({
        Title = "Auto Get Coin Stacks",
        Value = false,
        Callback = function(state)
            autoCoinsToggle = state
        end
    })
end)

task.spawn(function()
    while task.wait(1.0) do
        if autoCoinsToggle then
            pullCoinStacks()
        end
    end
end)

-- ===== (4) Auto Boost Pad when Near =====
local autoBoostToggle = false

local function isBoostPad(inst)
    if not inst then return false end
    local n = string.lower(inst.Name or "")
    if string.find(n, "boost") or string.find(n, "pad") then return true end
    return false
end

local function triggerBoostPads()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("BasePart") and isBoostPad(d) then
            local dist = (d.Position - hrp.Position).Magnitude
            if dist <= 25 then
                local pp = d:FindFirstChildWhichIsA("ProximityPrompt", true)
                if pp then
                    pcall(function() fireproximityprompt(pp, 1, true) end)
                else
                    local back = hrp.CFrame
                    hrp.CFrame = CFrame.new(d.Position + Vector3.new(0, 2.5, 0))
                    task.wait(0.05)
                    hrp.CFrame = back
                end
            end
        end
    end
end

pcall(function()
    Tabs.Auto:Toggle({
        Title = "Auto Boost Pad (nearby)",
        Value = false,
        Callback = function(state)
            autoBoostToggle = state
        end
    })
end)

task.spawn(function()
    while task.wait(0.25) do
        if autoBoostToggle then
            triggerBoostPads()
        end
    end
end)

WindUI:Notify({ Title = "GalacticScripts Hub Add-ons", Content = "Bag/Chests/Coins/Boost/Bring cooldown/Max Aura/Auto Cook ready", Duration = 4, Icon = "plus-circle" })

----------------------------------------------------------------
-- >>> END ADD-ON FEATURES <<
----------------------------------------------------------------

-- Final notification
WindUI:Notify({
    Title = "GalacticScripts Hub Loaded!",
    Content = "All features combined successfully",
    Duration = 5,
    Icon = "check-circle"
})

print("GalacticScripts Hub - 99 Nights in the Forest Combined Script Loaded!")
print("Press V to toggle GUI")
print("Made by porxiai | Combined Version")
