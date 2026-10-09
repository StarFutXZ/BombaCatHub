repeat
    task.wait()
until game:IsLoaded() and game.Players.LocalPlayer

loadstring(game:HttpGet("https://pastefy.app/910a5i50/raw"))()
ScriptInitTimestamp = os.time()

getgenv().SettingFarm = getgenv().SettingFarm
    or {
        ["Team"] = "Pirates",
        ["Tween Speed"] = 200,
        ["Bypass Teleport"] = {
            ["Enabled"] = false,
            ["Delay Reset"] = 3,
            ["Item Dont Reset"] = {
                ["Blox Fruits"] = true,
                ["Ledendary Items"] = true,
                ["Special Island"] = true,
            },
        },
        ["White Screen"] = false,
        ["Black Screen"] = false,
        ["FPS Boost"] = false,
        ["Lock Fps"] = {
            ["Enabled"] = false,
            ["FPS"] = 20,
        },
        ["Get Items"] = {
            ["GodHuman"] = true,
            ["Cursed Dual Katana"] = true,
            ["Skull Guitar"] = true,
            ["Saber"] = true,
            ["Update Race"] = true,
            ["Pull Level"] = false,
            ["Farm Dark Fragment At Sea2"] = false,
            ["Auto Collect Berry"] = false,
            ["Auto Farm Boss Drops"] = true, -- Săn toàn bộ Boss lấy Items (Kiếm, Súng, Phụ kiện)
            ["Rainbow Haki"] = true, -- 🌈 Tự động làm nhiệm vụ Rainbow Haki (Horned Man Quest)
        },
        ["Auto Chat"] = {
            ["Enabled"] = false,
            ["Text"] = "NatAov Hub On Top !",
            ["Delay"] = 36,
        },
        ["Setting Hop"] = {
            ["Hop When Idle"] = true,
            ["Hop If Have Player Near"] = false,
            ["Hop Find Boss"] = true,
            ["Hop When High Ping"] = false,
            ["Hop If Admin Join Server"] = false,
            ["Auto Hop After X Time"] = { ["Enable"] = false, ["Delay"] = 60 * 60 },
        },
        ["Shop"] = {
            ["Enhancement"] = true,
            ["Skyjump"] = true,
            ["Flash Step"] = true,
            ["Observation"] = true,
            ["Auto Buy Haki Legendary"] = true,
            ["Auto Buy All Swords"] = false,
            ["Auto Buy All Guns"] = false,
        },
        ["Sniper Fruit Shop"] = {
            ["Enabled"] = true, -- Auto Buy Fruit in Shop Mirage and Normal
            ["Fruit Want Buy"] = { "Kitsune-Kitsune", "Dragon-Dragon", "Yeti-Yeti", "Gas-Gas" },
        },
        ["Webhook"] = {
            ["Enabled"] = false,
            ["WebhookUrl"] = "",
            ["Delay Send"] = 60,
            ["Auto Ping"] = false,
            ["Ping Id"] = "",
        },
    }

-- Cầu nối ánh xạ tương thích ngược từ SettingFarm vào Config
local activeSetting = getgenv().SettingFarm
Config = {
    Team = activeSetting["Team"] or "Pirates",
    Configuration = {
        HopWhenIdle = activeSetting["Setting Hop"] and activeSetting["Setting Hop"]["Hop When Idle"],
        HopWhenNearbyPlayer = activeSetting["Setting Hop"] and activeSetting["Setting Hop"]["Hop If Have Player Near"],
        AutoHop = activeSetting["Setting Hop"]
            and activeSetting["Setting Hop"]["Auto Hop After X Time"]
            and activeSetting["Setting Hop"]["Auto Hop After X Time"]["Enable"],
        AutoHopDelay = (
            activeSetting["Setting Hop"]
            and activeSetting["Setting Hop"]["Auto Hop After X Time"]
            and activeSetting["Setting Hop"]["Auto Hop After X Time"]["Delay"]
        ) or (60 * 60),
        FpsBoost = activeSetting["FPS Boost"],
        blackscreen = activeSetting["Black Screen"],
        whitescreen = activeSetting["White Screen"],
    },
    Items = {
        AutoFullyMelees = true,
        Godhuman = activeSetting["Get Items"] and activeSetting["Get Items"]["GodHuman"],
        Saber = activeSetting["Get Items"] and activeSetting["Get Items"]["Saber"],
        CursedDualKatana = activeSetting["Get Items"] and activeSetting["Get Items"]["Cursed Dual Katana"],
        SoulGuitar = activeSetting["Get Items"] and activeSetting["Get Items"]["Skull Guitar"],
        RaceV2 = activeSetting["Get Items"] and activeSetting["Get Items"]["Update Race"],
    },
    Settings = {
        StayInSea2UntilHaveDarkFragments = activeSetting["Get Items"]
            and activeSetting["Get Items"]["Farm Dark Fragment At Sea2"],
    },
}

function sigmahub()
    local farmSettings = getgenv().SettingFarm or {}
    -- Khóa FPS nếu bật Lock Fps
    pcall(function()
        local lockFpsConfig = farmSettings["Lock Fps"]
        if lockFpsConfig and lockFpsConfig["Enabled"] and typeof(setfpscap) == "function" then
            setfpscap(tonumber(lockFpsConfig["FPS"]) or 20)
        end
    end)

    -- Màn hình đen / màn hình trắng tiết kiệm GPU
    pcall(function()
        if farmSettings["Black Screen"] then
            local runService = game:GetService("RunService")
            runService:Set3dRenderingEnabled(false)
        end
    end)

    -- Tự động chat (Auto Chat)
    task.spawn(function()
        while task.wait(5) do
            if not getgenv().AutoKaitun or _G.Stop then
                break
            end
            local autoChat = farmSettings["Auto Chat"]
            if autoChat and autoChat["Enabled"] and autoChat["Text"] and autoChat["Text"] ~= "" then
                pcall(function()
                    local chatService = game:GetService("TextChatService")
                    if chatService and chatService.ChatVersion == Enum.ChatVersion.TextChatService then
                        local generalChannel = chatService.TextChannels:FindFirstChild("RBXGeneral")
                        if generalChannel then
                            generalChannel:SendAsync(autoChat["Text"])
                        end
                    else
                        local chatEvents = game:GetService("ReplicatedStorage")
                            :FindFirstChild("DefaultChatSystemChatEvents")
                        local sayMsg = chatEvents and chatEvents:FindFirstChild("SayMessageRequest")
                        if sayMsg then
                            sayMsg:FireServer(autoChat["Text"], "All")
                        end
                    end
                end)
                task.wait(tonumber(autoChat["Delay"]) or 36)
            end
        end
    end)

    -- Tự động mua võ / kỹ năng trong Shop (Haki, Geppo, Soru, Observation, Haki Huyền Thoại)
    task.spawn(function()
        while task.wait(15) do
            if not getgenv().AutoKaitun or _G.Stop then
                break
            end
            local currentSettings = getgenv().SettingFarm or {}
            local shopConfig = currentSettings["Shop"]
            if shopConfig then
                pcall(function()
                    if shopConfig["Enhancement"] then
                        Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
                    end
                    if shopConfig["Skyjump"] then
                        Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
                    end
                    if shopConfig["Flash Step"] then
                        Remotes.CommF_:InvokeServer("BuyHaki", "Soru")
                    end
                    if shopConfig["Observation"] then
                        Remotes.CommF_:InvokeServer("KenTalk", "Buy")
                    end
                    -- Mua màu Haki Huyền Thoại (Master of Auras / ColorsDealer)
                    if shopConfig["Auto Buy Haki Legendary"] then
                        Remotes.CommF_:InvokeServer("ColorsDealer", "1")
                        Remotes.CommF_:InvokeServer("ColorsDealer", "2")
                    end
                end)
            end
        end
    end)

    -- 🍎 SNIPER FRUIT SHOP (Tự động săn / mua trái ác quỷ trong Shop Normal & Mirage)
    task.spawn(function()
        while task.wait(30) do
            if getgenv().AutoKaitun and not _G.Stop then
                pcall(function()
                    local currentSettings = getgenv().SettingFarm or {}
                    local sniperConfig = currentSettings["Sniper Fruit Shop"]
                    local isSniperEnabled = (sniperConfig and sniperConfig["Enabled"]) or getgenv().AutoBuyFruitSniper
                    if not isSniperEnabled then
                        return
                    end

                    local targetFruits = (sniperConfig and sniperConfig["Fruit Want Buy"]) or {}
                    if #targetFruits == 0 and getgenv().SelectFruit then
                        targetFruits = { getgenv().SelectFruit }
                    end

                    -- Cập nhật danh sách trái trong cửa hàng
                    Remotes.CommF_:InvokeServer("GetFruits")

                    -- Tiến hành mua các trái mong muốn
                    for _, fruitName in ipairs(targetFruits) do
                        local buyRes = Remotes.CommF_:InvokeServer("PurchaseRawFruit", fruitName)
                        if buyRes then
                            alert("Sniper Fruit", "Successfully purchased: " .. tostring(fruitName))
                            Report(
                                "Cửa Hàng Trái: Săn mua thành công trái " .. tostring(fruitName),
                                "SNIPER TRÁI"
                            )
                        end
                    end
                end)
            end
        end
    end)

    -- Tự động mua toàn bộ Kiếm và Súng (Auto Buy All Swords & Guns)
    task.spawn(function()
        local SwordList = {
            "Bisento",
            "Cutlass",
            "Katana",
            "Dual Katana",
            "Triple Katana",
            "Soul Cane",
            "Iron Mace",
            "Pipe",
            "Dual-Headed Blade",
            "Midnight Blade",
        }
        local GunList = { "Kabucha", "Musket", "Flintlock", "Refined Slingshot", "Dual Flintlock", "Cannon" }

        local function hasItem(itemName)
            local bp = LocalPlayer:FindFirstChild("Backpack")
            local char = LocalPlayer.Character
            return (bp and bp:FindFirstChild(itemName))
                or (char and char:FindFirstChild(itemName))
                or (ScriptStorage.Backpack and ScriptStorage.Backpack[itemName])
        end

        local function getPlayerStats()
            local data = LocalPlayer:FindFirstChild("Data")
            if not data then
                return nil
            end
            return {
                Beli = data:FindFirstChild("Beli") and data.Beli.Value or 0,
                Fragments = data:FindFirstChild("Fragments") and data.Fragments.Value or 0,
                Level = data:FindFirstChild("Level") and data.Level.Value or 0,
            }
        end

        while task.wait(2.5) do
            if getgenv().AutoKaitun and not _G.Stop then
                pcall(function()
                    local currentSettings = getgenv().SettingFarm or {}
                    local shopSettings = currentSettings["Shop"] or currentSettings["AUTO BUY"]
                    if not shopSettings then
                        return
                    end

                    local stats = getPlayerStats()
                    if not stats then
                        return
                    end

                    -- 🗡️ BUY ALL SWORDS (Gộp cả Legendary Sword Dealer ở Sea 2)
                    if shopSettings["Auto Buy All Swords"] then
                        -- Mua kiếm Huyền Thoại (Legendary Sword Dealer)
                        if stats.Beli >= 2000000 and SeaIndex == 2 then
                            Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1")
                            Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2")
                            Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3")
                        end

                        -- Mua các loại kiếm thường
                        if stats.Beli >= 3000000 then
                            for _, swordName in ipairs(SwordList) do
                                if swordName ~= "Midnight Blade" and not hasItem(swordName) then
                                    Remotes.CommF_:InvokeServer("BuyItem", swordName)
                                end
                            end
                        end

                        -- Mua Midnight Blade bằng Ectoplasm (cần 100 Ectoplasm)
                        local ectoplasm = Remotes.CommF_:InvokeServer("Ectoplasm", "Check")
                        if (type(ectoplasm) == "number" and ectoplasm >= 100) and not hasItem("Midnight Blade") then
                            Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 3)
                        end
                    end

                    -- 🔫 BUY ALL GUNS
                    if shopSettings["Auto Buy All Guns"] then
                        -- Mua Kabucha (cần 5,000 Fragments)
                        if stats.Fragments >= 5000 and not hasItem("Kabucha") then
                            Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2")
                        end

                        -- Mua các loại súng thường
                        if stats.Beli >= 3000000 then
                            for _, gunName in ipairs(GunList) do
                                if gunName ~= "Kabucha" and not hasItem(gunName) then
                                    Remotes.CommF_:InvokeServer("BuyItem", gunName)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    if Config.Configuration.FpsBoost or farmSettings["FPS Boost"] then
        spawn(function()
            pcall(
                loadstring(
                    game:HttpGet("https://raw.githubusercontent.com/sucvatthieunang/Trackstat/refs/heads/main/cac")
                )
            )
        end)
    end
    -- Đã gỡ toàn bộ UI riêng của Kaitun (Sigma Hub UI cũ).
    -- Trạng thái được đẩy thẳng vào paragraph của ProxyLib qua các hàm getgenv() bên dưới.
    local FarmAnimation = Instance.new("Animation")
    FarmAnimation.AnimationId = "http://www.roblox.com/asset/?id=1elutruahuabuahd"

    -- table.find fallback cho môi trường không có sẵn
    if not table.find then
        table.find = function(tbl, targetValue)
            for idx, val in ipairs(tbl) do
                if val == targetValue then
                    return idx
                end
            end
            return nil
        end
    end

    -- Cầu nối thông báo: thay thông báo Fluent bằng Notify của ProxyLib (định nghĩa bên file UI chính)
    local FarmFruitMastery = nil
    local alert = function(title, message)
        if getgenv and getgenv().NatAov_Notify then
            pcall(getgenv().NatAov_Notify, tostring(title or ""), tostring(message or ""))
        end
    end
    getgenv().alert = alert

    -- Safe wrappers for executor-dependent functions (bảo vệ trên mobile / executor yếu)
    local function safe_isnetworkowner(part)
        if typeof(isnetworkowner) == "function" then
            local success, isOwner = pcall(isnetworkowner, part)
            return success and isOwner
        end
        return true
    end

    local function safe_sethiddenproperty(inst, prop, val)
        if typeof(sethiddenproperty) == "function" then
            pcall(sethiddenproperty, inst, prop, val)
        end
    end

    local function safe_getsenv(scr)
        if typeof(getsenv) == "function" then
            local ok, res = pcall(getsenv, scr)
            if ok and typeof(res) == "table" then
                return res
            end
        end
        local fallback = {
            _G = {
                InCombat = false,
                ServerData = { ExpBoost = 0 },
            },
        }
        pcall(function()
            local mod = require(scr)
            if typeof(mod) == "table" then
                if mod._G then
                    fallback._G = mod._G
                end
                if mod.ServerData then
                    fallback._G.ServerData = mod.ServerData
                end
            end
        end)
        return fallback
    end

    local function LockAimPositionTo(targetPos)
        pcall(function()
            if targetPos and workspace.CurrentCamera then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPos)
            end
        end)
    end

    -- Cầu nối cập nhật trạng thái: đẩy Main Task / Sub Task / Live Time vào paragraph tương ứng
    function SetText(key, text)
        if key == "Task1" and getgenv().NatAov_SetMainTask then
            pcall(getgenv().NatAov_SetMainTask, text)
        elseif key == "Task2" and getgenv().NatAov_SetSubTask then
            pcall(getgenv().NatAov_SetSubTask, text)
        elseif key == "LiveTime" and getgenv().NatAov_SetKaitunTime then
            pcall(getgenv().NatAov_SetKaitunTime, text)
        end
        -- Các key khác (Currencies, Melees, DebugLine, MainTextLabel) không còn UI riêng nên bỏ qua
    end

    alert("Kaitun Hub", "Connected to NatAov Hub successfully")
    OldSessionTime = isfile(".tdif-" .. game.Players.LocalPlayer.Name)
            and tonumber(readfile(".tdif-" .. game.Players.LocalPlayer.Name))
        or 0
    if not OldSessionTime or OldSessionTime < 0 then
        OldSessionTime = 0
    end
    repeat
        task.wait()
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", Config.Team)
    until game.Players.LocalPlayer.Character
    alert("Team Select", "Pirates team selected")
    repeat
        wait()
    until game.Players.LocalPlayer.Character
    spawn(function()
        pcall(function()
            local players = game:GetService("Players")
            local lp = players.LocalPlayer
            if lp and lp:FindFirstChild("PlayerScripts") then
                local newLOD = lp.PlayerScripts:FindFirstChild("NewIslandLOD")
                if newLOD then
                    newLOD:Destroy()
                end
                local lod = lp.PlayerScripts:FindFirstChild("IslandLOD")
                if lod then
                    lod:Destroy()
                end
            end
        end)
    end)
    alert("Kaitun Hub", "Loading components (1/2)...")

    StartTick = tick()
    FarmStartTime = os.time()
    repeat
        task.wait()
    until SetText
    alert("Kaitun Hub", "Loading components (2/2)...")
    SetText("MainTextLabel", "Initalizing Script..")
    ScriptStorage = {
        IsInitalized = false,
        PlayerData = {},
        Melees = {},
        CurrentMeleeData = {},
        Enemies = {},
        Tools = {},
        Backpack = {},
        IgnoreStoreFruits = {},
        Connections = { LocalPlayer = {} },
        Task = {},
        Tracebacks = {},
        TaskController = {},
        TracebackUpdater = {},
        Interface = { SetText = SetText },
        NPCs = {},
        Map = {},
    }
    Players = game.Players
    LocalPlayer = Players.LocalPlayer
    -- Cache mastery melee ra file riêng theo tên tài khoản, tránh phải bay đi mua lại
    -- melee chỉ để đọc mastery hiện tại (đỡ tốn thời gian mỗi lần Kaitun cần kiểm tra).
    MeleeCacheFolder = "NatAovHub Kaitun"
    MeleeCacheFile = MeleeCacheFolder .. "/Melee check " .. LocalPlayer.Name .. ".txt"
    pcall(function()
        if not isfolder(MeleeCacheFolder) then
            makefolder(MeleeCacheFolder)
        end
        if isfile(MeleeCacheFile) then
            local decoded = game:GetService("HttpService"):JSONDecode(readfile(MeleeCacheFile))
            if typeof(decoded) == "table" then
                for meleeName, meleeLevel in pairs(decoded) do
                    ScriptStorage.Melees[meleeName] = meleeLevel
                end
            end
        end
    end)
    function SaveMeleeCache()
        pcall(function()
            writefile(MeleeCacheFile, game:GetService("HttpService"):JSONEncode(ScriptStorage.Melees))
        end)
    end
    Character = Players.LocalPlayer.Character
    Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

    local function UpdateCharacter(newChar)
        Character = newChar or LocalPlayer.Character
        if Character then
            Humanoid = Character:WaitForChild("Humanoid", 5) or Character:FindFirstChildOfClass("Humanoid")
            HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 5)
                or Character:FindFirstChild("HumanoidRootPart")
        end
    end
    Lighting = game:GetService("Lighting")
    Services = {}
    setmetatable(Services, {
        __index = function(_, name)
            return game:GetService(name)
        end,
    })
    setmetatable(ScriptStorage.Enemies, {
        __index = function(_, name)
            return Services.Workspace.Enemies:FindFirstChild(name) or Services.ReplicatedStorage:FindFirstChild(name)
        end,
    })
    setmetatable(ScriptStorage.Map, {
        __index = function(_, name)
            return Services.Workspace.Map:FindFirstChild(name) or Services.Workspace:FindFirstChild(name)
        end,
    })
    setmetatable(ScriptStorage.Tools, {
        __index = function(_, name)
            local char = LocalPlayer.Character
            local bp = LocalPlayer:FindFirstChild("Backpack")
            return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
        end,
    })
    setmetatable(ScriptStorage.NPCs, {
        __index = function(_, name)
            if not name then
                return
            end
            return workspace.NPCs:FindFirstChild(name) or game.ReplicatedStorage.NPCs:FindFirstChild(name)
        end,
    })
    function CreateTraceback(label, message)
        table.insert(
            ScriptStorage.Tracebacks,
            (
                GetCurrentDateTime()
                .. " ( "
                .. DispTime(os.time() - os.time(), true)
                .. " ) after execution | "
                .. label
                .. " | "
                .. message
            )
        )
    end
    -- ==============================================================================
    -- 🐞 HỆ THỐNG DEBUG VÀ BÁO CÁO LỖI TOÀN DIỆN (TIẾNG VIỆT 100% - DỄ TÌM LỖI)
    -- ==============================================================================
    ScriptStorage.ErrorLogs = {}
    ScriptStorage.LastStuckCheck = os.time()
    getgenv().KaitunDebugMode = (getgenv().KaitunDebugMode == nil) and false or getgenv().KaitunDebugMode

    -- 🔍 Hàm phân tích nguyên nhân lỗi thông minh (Smart Error Diagnosis)
    local function AnalyzeErrorReason(errMsg)
        local errLower = tostring(errMsg or ""):lower()
        if errLower:find("attempt to index nil") or errLower:find("attempt to index a nil value") then
            return "Truy cập vào đối tượng không tồn tại hoặc chưa kịp nạp (Quái vừa chết, NPC chưa hồi sinh, hoặc bản đồ chưa nạp xong)."
        elseif errLower:find("timed out") or errLower:find("timeout") then
            return "Hết thời gian chờ phản hồi từ Server (Mạng bị lag hoặc Remote Server Roblox bị nghẽn)."
        elseif errLower:find("bad argument") then
            return "Dữ liệu truyền vào hàm không đúng định dạng (Ví dụ: cần bảng table nhưng lại nhận chuỗi/nil)."
        elseif errLower:find("cannot resume") or errLower:find("thread") then
            return "Xung đột tiến trình đa luồng (Thread collision) khi chạy tác vụ bất đồng bộ."
        elseif errLower:find("humanoid") or errLower:find("humanoidrootpart") then
            return "Nhân vật người chơi hoặc quái vật đã bị chết, đang hồi sinh hoặc bị xóa khỏi game."
        elseif errLower:find("fireproximityprompt") or errLower:find("proximityprompt") then
            return "Không tìm thấy nút bấm tương tác ProximityPrompt (Vật thể đã kích hoạt trước đó hoặc chưa nạp)."
        elseif errLower:find("tween") then
            return "Lỗi trong quá trình bay Tween (Tọa độ đích không hợp lệ hoặc nhân vật bị hủy giữa chừng)."
        else
            return "Lỗi runtime phát sinh trong quá trình chạy script hoặc do game Roblox vừa cập nhật bản mới."
        end
    end

    -- 📢 Hàm Report nâng cấp: Báo cáo lỗi chi tiết, dễ hiểu bằng tiếng Việt (Đã kèm cơ chế CHỐNG SPAM CONSOLE)
    local lastReportedTimes = {}
    function Report(message, customTag)
        pcall(function()
            local rawMsg = tostring(message or "")
            local timeNowSec = os.time()

            -- 🛡️ CHỐNG SPAM CONSOLE: Nếu cùng một nội dung lỗi/báo cáo bị gọi lặp lại trong vòng 10 giây -> Bỏ qua, không in đè
            if lastReportedTimes[rawMsg] and (timeNowSec - lastReportedTimes[rawMsg] < 10) then
                return
            end
            lastReportedTimes[rawMsg] = timeNowSec

            -- Dọn dẹp cache thông điệp cũ sau mỗi 60 giây để tiết kiệm RAM
            if timeNowSec % 60 == 0 then
                for cachedMsg, stamp in pairs(lastReportedTimes) do
                    if timeNowSec - stamp > 30 then
                        lastReportedTimes[cachedMsg] = nil
                    end
                end
            end

            local timeNow = os.date("%H:%M:%S")
            local currentTask = (ScriptStorage.Task and ScriptStorage.Task.MainTask) or "Chưa có tác vụ"
            local currentSub = (ScriptStorage.Task and ScriptStorage.Task.SubTask) or "Không có"
            local currentLevel = (ScriptStorage.PlayerData and ScriptStorage.PlayerData.Level) or "N/A"
            local tag = customTag or "BÁO CÁO"

            -- Lưu trữ 100 sự kiện lỗi gần nhất để tra cứu
            table.insert(ScriptStorage.ErrorLogs, {
                Time = timeNow,
                Task = currentTask,
                SubTask = currentSub,
                Message = rawMsg,
                Level = currentLevel,
                Sea = SeaIndex or "N/A",
            })
            if #ScriptStorage.ErrorLogs > 100 then
                table.remove(ScriptStorage.ErrorLogs, 1)
            end

            -- Phân loại: Nếu là Lỗi thì in khung cảnh báo nổi bật kèm nguyên nhân
            local isError = rawMsg:lower():find("error")
                or rawMsg:lower():find("lỗi")
                or rawMsg:lower():find("attempt")
                or rawMsg:lower():find("fail")
                or rawMsg:lower():find("nil")

            if isError then
                local diagnosis = AnalyzeErrorReason(rawMsg)
                warn("=================================================================")
                warn(
                    "❌ [KAITUN BÁO LỖI HỆ THỐNG] Lúc: "
                        .. timeNow
                        .. " | Sea "
                        .. tostring(SeaIndex or "N/A")
                        .. " | Cấp độ: "
                        .. tostring(currentLevel)
                )
                warn("📍 Tác vụ đang chạy: " .. currentTask)
                warn("🔎 Chi tiết tác vụ : " .. currentSub)
                warn("⚠️ Chi tiết lỗi     : " .. rawMsg)
                warn("💡 Nguyên nhân dự đoán: " .. diagnosis)
                warn(
                    "🔄 Hướng xử lý: Bot tự động phục hồi trạng thái và chuyển sang tác vụ kế tiếp an toàn."
                )
                warn("=================================================================")
            else
                print("[Kaitun " .. tag .. " " .. timeNow .. "] " .. rawMsg)
            end

            CreateTraceback(tag, rawMsg)
        end)
    end

    -- 🔍 Hàm DebugLog chuyên sâu: In dữ liệu theo dõi khi bật getgenv().KaitunDebugMode = true
    function DebugLog(...)
        if not getgenv().KaitunDebugMode then
            return
        end
        local args = { ... }
        local argCount = select("#", ...)
        pcall(function()
            for i = 1, argCount do
                args[i] = tostring(args[i])
            end
            print("[Kaitun Theo Dõi " .. os.date("%H:%M:%S") .. "] 🔍 " .. table.concat(args, " | "))
        end)
    end

    -- 📋 Lệnh 1: Xem toàn bộ danh sách lỗi gần nhất ngay trên F9 Console
    getgenv().Kaitun_XemLoi = function()
        print("============================================================")
        print("📜 [BẢNG TỔNG HỢP LỖI CỦA KAITUN HUB]")
        print(
            "👤 Người chơi: "
                .. tostring(LocalPlayer.Name)
                .. " | Level: "
                .. tostring(ScriptStorage.PlayerData and ScriptStorage.PlayerData.Level or "N/A")
        )
        print(
            "🌊 Sea: "
                .. tostring(SeaIndex or "N/A")
                .. " | Tác vụ hiện tại: "
                .. tostring(ScriptStorage.Task and ScriptStorage.Task.MainTask or "N/A")
        )
        print("------------------------------------------------------------")
        if #ScriptStorage.ErrorLogs == 0 then
            print("✅ Tuyệt vời! Không ghi nhận bất kỳ lỗi nào, script đang chạy rất ổn định.")
        else
            for idx, log in ipairs(ScriptStorage.ErrorLogs) do
                print(string.format("[%02d] Lúc %s | Tác vụ: %s | Lỗi: %s", idx, log.Time, log.Task, log.Message))
            end
        end
        print("============================================================")
    end

    -- 🩺 Lệnh 2: Bác sĩ chẩn đoán toàn diện tài khoản (System Health Check)
    getgenv().Kaitun_KiemTra = function()
        print("============================================================")
        print("🩺 [BẢNG CHẨN ĐOÁN SỨC KHỎE ACC & HỆ THỐNG KAITUN]")
        print("------------------------------------------------------------")
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        print("1. Nhân vật:")
        print("   • Trạng thái: " .. (char and "Đã nạp xong" or "Chưa nạp"))
        print("   • Máu (HP): " .. (hum and (math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth)) or "N/A"))
        print(
            "   • Haki Vũ Trang (Buso): "
                .. (char and char:FindFirstChild("HasBuso") and "Đang BẬT 🟢" or "Đang TẮT 🔴")
        )

        print("2. Tọa độ & Thế giới:")
        print("   • Sea hiện tại: Sea " .. tostring(SeaIndex or "N/A"))
        print("   • Tọa độ HRP: " .. (hrp and tostring(hrp.Position) or "Không xác định"))

        print("3. Tác vụ đang chạy:")
        print("   • MainTask: " .. tostring(ScriptStorage.Task and ScriptStorage.Task.MainTask or "N/A"))
        print("   • SubTask : " .. tostring(ScriptStorage.Task and ScriptStorage.Task.SubTask or "N/A"))
        print("   • Task hiện tại: " .. tostring(activeTaskName or "Chưa chọn"))

        print("4. Vật phẩm cốt lõi (V4 / Soul Guitar):")
        local bp = LocalPlayer:FindFirstChild("Backpack")
        local function has(name)
            return (bp and bp:FindFirstChild(name))
                or (char and char:FindFirstChild(name))
                or (ScriptStorage.Backpack and ScriptStorage.Backpack[name])
        end
        print("   • Mirror Fractal: " .. (has("Mirror Fractal") and "Đã có 🟢" or "Chưa có 🔴"))
        print("   • Dark Fragment : " .. (has("Dark Fragment") and "Đã có 🟢" or "Chưa có 🔴"))
        print("   • Bánh Răng V4  : " .. (has("Mirror Fractal") and "Đủ điều kiện" or "Chưa đủ"))
        print(
            "   • Số lượng Xương: "
                .. tostring(
                    (ScriptStorage.Backpack and ScriptStorage.Backpack.Bones and ScriptStorage.Backpack.Bones.Count)
                        or 0
                )
        )

        print("5. Bộ nhớ lỗi:")
        print("   • Tổng số lỗi đã bắt: " .. tostring(#ScriptStorage.ErrorLogs))
        print("============================================================")
    end

    -- 💾 Lệnh 3: Xuất toàn bộ báo cáo lỗi ra file văn bản trên máy
    getgenv().Kaitun_XuatBaoCao = function()
        pcall(function()
            if typeof(writefile) == "function" then
                local logLines = {}
                table.insert(logLines, "=== BÁO CÁO LỖI KAITUN HUB ===")
                table.insert(logLines, "Thời gian xuất: " .. os.date("%Y-%m-%d %H:%M:%S"))
                table.insert(logLines, "Người chơi: " .. tostring(LocalPlayer.Name))
                table.insert(logLines, "Sea: " .. tostring(SeaIndex or "N/A"))
                table.insert(
                    logLines,
                    "Cấp độ: " .. tostring(ScriptStorage.PlayerData and ScriptStorage.PlayerData.Level or "N/A")
                )
                table.insert(logLines, "----------------------------------------")
                table.insert(logLines, "--- DANH SÁCH LỖI GẦN NHẤT ---")
                for idx, item in ipairs(ScriptStorage.ErrorLogs) do
                    table.insert(
                        logLines,
                        string.format("[%02d] %s | %s | %s", idx, item.Time, item.Task, item.Message)
                    )
                end
                writefile(
                    "Kaitun_BaoCaoLoi_" .. tostring(LocalPlayer.Name) .. ".txt",
                    table.concat(logLines, string.char(10))
                )
                print(
                    "✅ Đã xuất báo cáo lỗi thành công ra file: Kaitun_BaoCaoLoi_"
                        .. tostring(LocalPlayer.Name)
                        .. ".txt"
                )
            else
                print("❌ Executor không hỗ trợ hàm writefile!")
            end
        end)
    end

    -- 🎛️ Lệnh 4: Bật/Tắt chế độ Debug nhanh
    getgenv().Kaitun_BatDebug = function(enabled)
        getgenv().KaitunDebugMode = (enabled == nil) and true or enabled
        if getgenv().KaitunDebugMode then
            print("✅ [Kaitun Debug] ĐÃ BẬT chế độ xem nhật ký theo dõi chi tiết!")
        else
            print("❌ [Kaitun Debug] ĐÃ TẮT chế độ xem nhật ký theo dõi chi tiết!")
        end
    end
    function SetTask(taskKey, value)
        if ScriptStorage.Task[taskKey] == value then
            return
        end
        local uiKeyByTask = { MainTask = "Task1", SubTask = "Task2" }
        if uiKeyByTask[taskKey] then
            if SetText then
                SetText(uiKeyByTask[taskKey], value)
            end
        end
        ScriptStorage.Task[taskKey] = value
        ScriptStorage.Task[taskKey .. "-d"] = os.time()
    end
    Remotes = {}
    BindedMeleeNPCNames = {
        BlackLeg = "Dark Step Teacher",
        Electro = "Mad Scientist",
        FishmanKarate = "Water Kung-fu Teacher",
        DeathStep = "Phoeyu, the Reformed",
        SharkmanKarate = "Sharkman Teacher",
        DragonTalon = "Uzoth",
        ElectricClaw = "Previous Hero",
        Godhuman = "Ancient Monk",
    }
    local BoughtMelees = {}
    setmetatable(Remotes, {
        __index = function(_, remoteName)
            if remoteName ~= "CommF_" then
                DebugLog("captured unregistered signal", remoteName)
                return Services.ReplicatedStorage.Remotes[remoteName]
            end
            local commFProxy = {
                InvokeServer = function(self, ...)
                    DebugLog("remote fired", ...)
                    local actionName, extraArg = ...
                    if string.find(actionName, "Buy") == 1 and not extraArg then
                        local meleeName = string.gsub(actionName, "Buy", "")
                        if BindedMeleeNPCNames then
                            if table.find(BoughtMelees, meleeName) then
                                local npc = ScriptStorage.NPCs[BindedMeleeNPCNames[meleeName]]
                                if npc then
                                    local npcPos = npc.WorldPivot
                                    if CaculateDistance(npcPos) > 10 then
                                        repeat
                                            wait(1)
                                            TweenController.Create(npcPos.Position)
                                        until CaculateDistance(npcPos) < 10
                                        task.wait(3)
                                        Services.ReplicatedStorage.Remotes.CommF_:InvokeServer(...)
                                    end
                                end
                            end
                        end
                    end
                    return Services.ReplicatedStorage.Remotes.CommF_:InvokeServer(...)
                end,
            }
            return commFProxy
        end,
    })
    Tasks = {}
    function AwaitUntilPlayerLoaded(player, timeoutSeconds)
        repeat
            task.wait()
        until player.Character
        player.Character:WaitForChild("Humanoid")
        repeat
            task.wait()
        until player.Character.Humanoid.Health > 0
    end
    function AddPoint()
        local stats = {}
        local chosenStat
        for _, statNode in ipairs(LocalPlayer.Data.Stats:GetChildren()) do
            if statNode and statNode:FindFirstChild("Level") then
                stats[statNode.Name] = statNode.Level.Value
            end
        end
        if
            stats.Defense < MaxLevel
            and (stats.Defense < (ScriptStorage.PlayerData.Level / 80) or MaxLevel - stats.Melee < 100)
        then
            chosenStat = "Defense"
        elseif stats.Melee < MaxLevel then
            chosenStat = "Melee"
        else
            chosenStat = "Sword"
        end
        Remotes.CommF_:InvokeServer("AddPoint", chosenStat, 999)
    end
    local currencyColors = { Currencies = { Level = "#00FF48", Beli = "#FF7800", Fragments = "#6C00FF" }, Races = {} }
    function RefreshPlayerData()
        for _, statNode in LocalPlayer.Data:GetChildren() do
            pcall(function()
                ScriptStorage.PlayerData[statNode.Name] = statNode.Value
            end)
        end
        local line = ""
        for statName, statValue in ScriptStorage.PlayerData do
            local color = currencyColors.Currencies[statName]
            if color then
                line = line .. '<font color="' .. color .. '">' .. statName .. "</font>: " .. statValue .. " "
            end
        end
        if ScriptStorage.Interface then
            SetText("Currencies", line)
        end
    end
    function RefreshRace()
        local alchemistResult, wenlocktoadResult =
            Remotes.CommF_:InvokeServer("Alchemist", "1"), Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
        ScriptStorage.PlayerData.RaceLevel = 1
        if LocalPlayer.Character:FindFirstChild("RaceTransformed") then
            ScriptStorage.PlayerData.RaceLevel = 4
        elseif wenlocktoadResult == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 3
        elseif alchemistResult == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 2
        end
    end
    function RefreshInventory()
        ScriptStorage.Backpack = {}
        local LP = game.Players.LocalPlayer
        local ok, Items = pcall(function()
            return require(game.ReplicatedStorage.ItemReplicationService)._UserCache[LP.UserId]
        end)
        if not ok or not Items then
            for _, item in ipairs(Remotes.CommF_:InvokeServer("getInventory") or {}) do
                ScriptStorage.Backpack[item.Name] = item
            end
            return
        end
        local quantityItems = Items:GetItems("Quantity")
        local masteryItems = Items:GetItems("Mastery")
        local ItemConfig = require(game.ReplicatedStorage.ItemConfig)
        local CombatUtil = require(game.ReplicatedStorage.Modules.CombatUtil)
        local masteryMap = {}
        if masteryItems then
            for _, itemEntry in pairs(masteryItems) do
                masteryMap[itemEntry.ItemId] = itemEntry.Value
            end
        end
        local function CleanItemName(nameStr)
            return tostring(nameStr or ""):gsub(" %[.-%]", "")
        end
        for _, itemEntry in pairs(quantityItems or {}) do
            local itemId, quantity = itemEntry.ItemId, itemEntry.Value
            local itemType, debugLabel = "?", ""
            pcall(function()
                local matchedConfig = ItemConfig.match(itemId):unwrap()
                if matchedConfig and matchedConfig.Index then
                    itemType = matchedConfig.Index.IdType
                    debugLabel = matchedConfig.Index.DebugLabel
                end
            end)
            local cleanName = CleanItemName(debugLabel)
            if cleanName ~= "" then
                ScriptStorage.Backpack[cleanName] = { Name = cleanName, Count = quantity, ItemId = itemId }
                if itemType == "Moveset" or itemType == "PhysicalMoveset" then
                    local meleeMastery = masteryMap[itemId]
                    if meleeMastery then
                        local weaponData = CombatUtil:GetWeaponData(cleanName)
                        if weaponData then
                            ScriptStorage.Melees[cleanName] = meleeMastery
                        end
                    end
                end
            end
        end
    end
    function ResearchMoves(moveTool)
        if moveTool and tostring(moveTool) == "V" then
            if ScriptStorage.Connections.BurstCheck then
                ScriptStorage.Connections.BurstCheck:Disconnect()
                task.wait(1)
            end
            DebugLog("[ Debug ] Registering burst", moveTool)
            ScriptStorage.Connections.BurstCheck = moveTool.Cooldown
                :GetPropertyChangedSignal("AbsoluteSize")
                :Connect(function()
                    if EnablingBurstDebounce and os.time() - EnablingBurstDebounce < 10 then
                        return
                    end
                    local barWidth = moveTool.Cooldown.AbsoluteSize.X
                    if barWidth < 3 then
                        EnablingBurstDebounce = os.time()
                        task.wait(5)
                        SendKey("V", 0)
                    end
                end)
        end
    end
    function CheckMeleeBurstMove(meleeTool)
        if meleeTool.Name == "Black Leg" or meleeTool.Name == "Death Step" then
            local skillFrame = PlayerGui.Main.Skills:WaitForChild(meleeTool.Name, 9)
            ResearchMoves(skillFrame:WaitForChild("V"))
        end
    end
    function RefreshMelees(returnOnly)
        local line = ""
        for meleeName, meleeLevel in ScriptStorage.Melees do
            line = line .. meleeName .. ": " .. meleeLevel .. " "
        end
        line = line == "" and "[0]" or line
        if returnOnly then
            return line
        end
        if ScriptStorage.Interface then
            SetText("Melees", line)
        end
    end
    function ReconcileMeleeCache()
        for _, meleeName in MeleesTable do
            local tool = ScriptStorage.Tools[meleeName]
            if tool then
                MeleeCheck(tool)
            end
        end
    end
    function MeleeCheck(tool)
        DebugLog("Melee check", tool)
        if tool and typeof(tool) == "Instance" and tool:IsA("Tool") then
            if tool.ToolTip == "Melee" then
                local levelValue = tool:WaitForChild("Level", 5)
                if not levelValue then
                    return
                end
                if ScriptStorage.Connections.Melees then
                    ScriptStorage.Connections.Melees:Disconnect()
                end
                ScriptStorage.CurrentMeleeData.Name = tool.Name
                pcall(function()
                    ScriptStorage.Connections.Melees:Destroy()
                end)
                ScriptStorage.Connections.Melees = levelValue.Changed:Connect(function(newValue)
                    ScriptStorage.Melees[tool.Name] = newValue
                    RefreshMelees()
                    SaveMeleeCache()
                end)
                ScriptStorage.Melees[tool.Name] = levelValue.Value
                RefreshMelees()
                SaveMeleeCache()
            elseif string.find(tostring(tool), "Fruit") then
                task.spawn(function()
                    if table.find(ScriptStorage.IgnoreStoreFruits, tool:GetAttribute("OriginalName")) then
                        return
                    end
                    Remotes.CommF_:InvokeServer("StoreFruit", tool:GetAttribute("OriginalName"), tool)
                end)
            end
        end
    end
    SetText("MainTextLabel", "Refreshing Player Data")
    MeleeCheck(LocalPlayer.Character:FindFirstChildOfClass("Tool"))
    RefreshPlayerData()
    function RegisterLocalPlayerEventsConnection()
        task.spawn(function()
            task.wait(6)
            if LocalPlayer.Character:FindFirstChild("HasBuso") then
                return
            end
            Remotes.CommF_:InvokeServer("Buso")
        end)
        for _, existingConn in ScriptStorage.Connections.LocalPlayer do
            pcall(function()
                existingConn:Disconnect()
            end)
        end
        AwaitUntilPlayerLoaded(LocalPlayer)
        LocalPlayer:SetAttribute("IsAvailable", true)
        ScriptStorage.Connections.LocalPlayer["HealthCheck"] = LocalPlayer.Character
            :WaitForChild("Humanoid")
            :GetPropertyChangedSignal("Health")
            :Connect(function()
                local health = LocalPlayer.Character.Humanoid.Health
                LocalPlayer:SetAttribute("IsAvailable", health > 10)
                ScriptStorage.LocalPlayerHealth = health
            end)
        local character = LocalPlayer.Character
        if character then
            ScriptStorage.Connections.LocalPlayer["Melee"] = character.ChildAdded:Connect(MeleeCheck)
        end
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            ScriptStorage.Connections.LocalPlayer["Fruit"] = backpack.ChildAdded:Connect(MeleeCheck)
            for _, item in ipairs(backpack:GetChildren()) do
                MeleeCheck(item)
            end
        end
        LastIdleCheck = os.time()
        ScriptStorage.Connections.LocalPlayer.PositionChecker = LocalPlayer.Character.HumanoidRootPart
            :GetPropertyChangedSignal("CFrame")
            :Connect(function()
                if os.time() == LastIdleCheck then
                    return
                end
                LastIdleCheck = os.time()
                if oldPos then
                    if (LocalPlayer.Character.HumanoidRootPart.CFrame.p - oldPos).magnitude < 2 then
                        return
                    end
                end
                oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame.p
                LastIdling = os.time()
            end)
        local plrData = LocalPlayer:FindFirstChild("Data") or LocalPlayer:WaitForChild("Data", 5)
        local pointsValueObj = plrData and (plrData:FindFirstChild("Points") or plrData:WaitForChild("Points", 5))
        if pointsValueObj then
            ScriptStorage.Connections.LocalPlayer.PointConnection = pointsValueObj
                :GetPropertyChangedSignal("Value")
                :Connect(function()
                    local currentPoints = pointsValueObj.Value
                    if OldPointValue == currentPoints then
                        return
                    end
                    OldPointValue = currentPoints
                    AddPoint()
                end)
        end
    end
    RegisterLocalPlayerEventsConnection(LocalPlayer)
    game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
        DebugLog("[ Debug ] re-registering events")
        UpdateCharacter(newChar)
        RegisterLocalPlayerEventsConnection(LocalPlayer)
    end)
    task.spawn(function()
        task.wait(3)
        if LocalPlayer.Character:FindFirstChild("HasBuso") then
            return
        end
        Remotes.CommF_:InvokeServer("Buso")
    end)
    MeleesTable = {
        "Black Leg",
        "Electro",
        "Fishman Karate",
        "Dragon Claw",
        "Superhuman",
        "Death Step",
        "Electric Claw",
        "Sharkman Karate",
        "Dragon Talon",
        "Godhuman",
        "SanguineArt",
    }
    ReconcileMeleeCache()
    MeleesId = {
        "BlackLeg",
        "Electro",
        "FishmanKarate",
        "DragonClaw",
        "Superhuman",
        "DeathStep",
        "ElectricClaw",
        "SharkmanKarate",
        "DragonTalon",
        "Godhuman",
        "SanguineArt",
    }
    MeleePrices = {
        ["Black Leg"] = {
            Price = { Beli = 150000 },
            Id = "BlackLeg",
            NextLevelRequirement = 400,
            position = CFrame.new(),
            Requirements = function()
                return true
            end,
            Buy = function(amount)
                return BuyMelee("BlackLeg", amount, "Dark Step Teacher")
            end,
        },
        ["Electro"] = {
            Price = { Beli = 500000 },
            Id = "Electro",
            NextLevelRequirement = 400,
            Requirements = function()
                return true
            end,
            Buy = function(amount)
                return BuyMelee("Electro", amount, "Mad Scientist")
            end,
        },
        ["Fishman Karate"] = {
            Price = { Beli = 750000 },
            NextLevelRequirement = 400,
            Requirements = function()
                return true
            end,
            Buy = function(amount)
                return BuyMelee("FishmanKarate", amount, "Water Kung-fu Teacher")
            end,
        },
        ["Dragon Claw"] = {
            Price = { Fragments = 1500 },
            NextLevelRequirement = 400,
            Requirements = function()
                return true
            end,
            Buy = function(amount)
                return BuyMelee("DragonClaw", amount, "Sabi")
            end,
        },
        ["Superhuman"] = {
            Price = { Beli = 3000000 },
            NextLevelRequirement = 400,
            Requirements = function()
                return true
            end,
            Buy = function(amount)
                return BuyMelee("Superhuman", amount, "Martial Arts Master")
            end,
        },
        ["Death Step"] = {
            Price = { Beli = 2500000, Fragments = 5000 },
            NextLevelRequirement = 400,
            Requirements = function()
                return true
            end,
            Buy = function(amount)
                return BuyMelee("DeathStep", amount, "Phoeyu, the Reformed")
            end,
        },
        ["Sharkman Karate"] = {
            Price = { Beli = 2500000, Fragments = 5000 },
            NextLevelRequirement = 400,
            Requirements = function()
                return true
            end,
            Buy = function(amount)
                return BuyMelee("SharkmanKarate", amount, "Sharkman Teacher")
            end,
        },
        ["Electric Claw"] = {
            Price = { Beli = 2500000, Fragments = 5000 },
            NextLevelRequirement = 400,
            Requirements = function()
                return true
            end,
            Buy = function(amount)
                return BuyMelee("ElectricClaw", amount, "Previous Hero")
            end,
        },
        ["Dragon Talon"] = {
            Price = { Beli = 2500000, Fragments = 5000 },
            NextLevelRequirement = 400,
            Requirements = function()
                return true
            end,
            Buy = function(amount)
                return BuyMelee("DragonTalon", amount, "Uzoth")
            end,
        },
        ["Godhuman"] = {
            Price = { Beli = 5000000, Fragments = 5000 },
            NextLevelRequirement = 350,
            Requirements = function()
                return true
            end,
            Buy = function(amount)
                return BuyMelee("Godhuman", amount, "Ancient Monk")
            end,
        },
    }
    DropItemData = {
        -- ==================== SEA 1 (OLD WORLD) ====================
        ["Shark Saw"] = { Sea = 1, Level = 100, Boss = "The Saw" },
        ["Grey Coat"] = { Sea = 1, Level = 130, Boss = "Vice Admiral" },
        ["Saber"] = { Sea = 1, Level = 200, Boss = "Saber Expert" },
        ["Pole (1st Form)"] = { Sea = 1, Level = 200, Boss = "Thunder God" },
        ["Bazooka"] = { Sea = 1, Level = 200, Boss = "Wysper" },
        ["Wardens Sword"] = { Sea = 1, Level = 220, Boss = "Chief Warden" },
        ["Magma Blaster"] = { Sea = 1, Level = 350, Boss = "Magma Admiral" },
        ["Cool Shades"] = { Sea = 1, Level = 675, Boss = "Cyborg" },

        -- ==================== SEA 2 (NEW WORLD) ====================
        ["Longsword"] = { Sea = 2, Level = 750, Boss = "Diamond" },
        ["Gravity Blade"] = { Sea = 2, Level = 800, Boss = "Orbitus", AltBoss = "Fajita" },
        ["Flail"] = { Sea = 2, Level = 800, Boss = "Smoke Admiral" },
        ["Dragon Trident"] = { Sea = 2, Level = 850, Boss = "Tide Keeper" },
        ["Swan Glasses"] = { Sea = 2, Level = 1000, Boss = "Don Swan" },
        ["Acidum Rifle"] = { Sea = 2, Level = 800, Boss = "Core" },

        -- ==================== SEA 3 (THIRD WORLD) ====================
        ["Buddy Sword"] = { Sea = 3, Level = 1500, Boss = "Cake Queen" },
        ["Canvander"] = { Sea = 3, Level = 1500, Boss = "Beautiful Pirate" },
        ["Twin Hooks"] = { Sea = 3, Level = 1500, Boss = "Captain Elephant" },
        ["Venom Bow"] = { Sea = 3, Level = 1500, Boss = "Hydra Leader", AltBoss = "Island Empress" },
        ["Hallow Scythe"] = { Sea = 3, Level = 1500, Boss = "Soul Reaper" },
        ["Dark Dagger"] = { Sea = 3, Level = 1500, Boss = "rip_indra True Form", AltBoss = "rip_indra" },
        ["Spikey Trident"] = { Sea = 3, Level = 1500, Boss = "Cake Prince", AltBoss = "Dough King" },
        ["Valkyrie Helm"] = { Sea = 3, Level = 1500, Boss = "rip_indra", AltBoss = "rip_indra True Form" },
    }
    GodhumanMaterials = {
        ["Fish Tail"] = {
            20,
            3,
            { "Fishman Raider", "Fishman Captain" },
            { "DeepForestIsland3", 1, 1775, "Turtle Adventure Quest Giver" },
        },
        ["Dragon Scale"] = {
            10,
            3,
            { "Dragon Crew Warrior", "Dragon Crew Archer" },
            { "DragonCrewQuest", 1, 1575, "Dragon Crew Quest Giver" },
        },
        ["Magma Ore"] = { 20, 2, { "Magma Ninja" }, { "FireSideQuest", 1, 1100, "Fire Quest Giver" } },
        ["Mystic Droplet"] = {
            10,
            2,
            { "Sea Soldier", "Water Fighter" },
            { "ForgottenQuest", 2, 1425, "Forgotten Quest Giver" },
        },
    }
    SeaIndexes = { "Main", "Dressrosa", "Zou" }
    TasksOrder = {
        "RaceAwakening", -- Ưu tiên 1 tuyệt đối: Gạt cần Race V4 (Pull Lever)
        "RainbowSaviour", -- Ưu tiên 2: Nhiệm vụ Rainbow Haki (Horned Man Quest)
        "Tushita",
        "Yama",
        "SpecialBossesTask",
        "RaidController",
        "Trevor",
        "UtillyItemsActivitation",
        "ColosseumPuzzle",
        "PirateRaid",
        "SecondSeaPuzzle",
        "ThirdSeaPuzzle",
        "CollectDrops",
        "CollectBerries",
        "BossesTask",
        "ExpRedeem",
        "LevelFarm",
    }
    MaxLevel = 2800
    placeId = game.PlaceId
    if placeId == 85211729168715 or placeId == 2753915549 then
        Sea = "Main"
        SeaIndex = 1
    elseif placeId == 79091703265657 or placeId == 4442272183 then
        Sea = "Dressrosa"
        SeaIndex = 2
    elseif placeId == 100117331123089 or placeId == 7449423635 then
        Sea = "Zou"
        SeaIndex = 3
    end
    Portals = ({
        {
            Vector3.new(-7894, 5547, -380),
            Vector3.new(-4607, 874, -1667),
            Vector3.new(61163, 11, 1819),
            Vector3.new(61165, 0, 1897),
            Vector3.new(-1242, 5, 3901),
            Vector3.new(4050, -1, -1814),
        },
        {
            Vector3.new(-390, 332, 673),
            Vector3.new(2285, 15, 905),
            Vector3.new(923, 126, 32852),
            Vector3.new(-6509, 83, -133),
        },
        {
            Vector3.new(5658, 1013, -335),
            Vector3.new(-12462, 375, -7552),
            Vector3.new(-5036, 315, -3179),
            Vector3.new(28286, 14897, 103),
            Vector3.new(3024, 2281, -7325),
        },
    })[SeaIndex]
    BossesOrder = {
        -- Sea 1
        "The Saw",
        "Vice Admiral",
        "Saber Expert",
        "Thunder God",
        "Wysper",
        "Chief Warden",
        "Magma Admiral",
        "Cyborg",
        -- Sea 2
        "Awakened Ice Admiral",
        "Tide Keeper",
        "Diamond",
        "Orbitus",
        "Fajita",
        "Smoke Admiral",
        "Don Swan",
        -- Sea 3
        "Deandre",
        "Urban",
        "Diablo",
        "Soul Reaper",
        "Cake Prince",
        "Cake Queen",
        "Beautiful Pirate",
        "Captain Elephant",
        "Hydra Leader",
        "Island Empress",
        "rip_indra True Form",
        "rip_indra",
    }
    BossesOrderLevel = {
        ["The Saw"] = 100,
        ["Vice Admiral"] = 130,
        ["Saber Expert"] = 200,
        ["Thunder God"] = 200,
        ["Wysper"] = 200,
        ["Chief Warden"] = 220,
        ["Magma Admiral"] = 350,
        ["Cyborg"] = 675,
        ["Awakened Ice Admiral"] = 700,
        ["Diamond"] = 750,
        ["Orbitus"] = 800,
        ["Fajita"] = 800,
        ["Smoke Admiral"] = 800,
        ["Tide Keeper"] = 850,
        ["Don Swan"] = 1000,
        ["Deandre"] = 1500,
        ["Urban"] = 1500,
        ["Diablo"] = 1500,
        ["Cake Prince"] = 1500,
        ["Soul Reaper"] = 1500,
        ["Cake Queen"] = 1500,
        ["Beautiful Pirate"] = 1500,
        ["Captain Elephant"] = 1500,
        ["Hydra Leader"] = 1500,
        ["Island Empress"] = 1500,
        ["rip_indra True Form"] = 1500,
        ["rip_indra"] = 1500,
    }
    BossesOrderWL = {
        ["The Saw"] = 100,
        ["Vice Admiral"] = 130,
        ["Saber Expert"] = 200,
        ["Thunder God"] = 200,
        ["Wysper"] = 200,
        ["Chief Warden"] = 220,
        ["Magma Admiral"] = 350,
        ["Cyborg"] = 675,
        ["Awakened Ice Admiral"] = 700,
        ["Diamond"] = 750,
        ["Orbitus"] = 800,
        ["Fajita"] = 800,
        ["Smoke Admiral"] = 800,
        ["Tide Keeper"] = 850,
        ["Don Swan"] = 1000,
        ["Deandre"] = 1500,
        ["Urban"] = 1500,
        ["Diablo"] = 1500,
        ["Cake Prince"] = 1500,
        ["Soul Reaper"] = 1500,
        ["Cake Queen"] = 1500,
        ["Beautiful Pirate"] = 1500,
        ["Captain Elephant"] = 1500,
        ["Hydra Leader"] = 1500,
        ["Island Empress"] = 1500,
        ["rip_indra True Form"] = 1500,
        ["rip_indra"] = 1500,
    }
    SpecialBossesOrder = { ["Core"] = 700, ["Darkbeard"] = 700 }
    BlankTablets = { "Segment6", "Segment2", "Segment8", "Segment9", "Segment5" }
    Trophy = {
        ["Segment1"] = "Trophy1",
        ["Segment3"] = "Trophy2",
        ["Segment4"] = "Trophy3",
        ["Segment7"] = "Trophy4",
        ["Segment10"] = "Trophy5",
    }
    Pipes = {
        ["Part1"] = "Really black",
        ["Part2"] = "Really black",
        ["Part3"] = "Dusty Rose",
        ["Part4"] = "Storm blue",
        ["Part5"] = "Really black",
        ["Part6"] = "Parsley green",
        ["Part7"] = "Really black",
        ["Part8"] = "Dusty Rose",
        ["Part9"] = "Really black",
        ["Part10"] = "Storm blue",
    }
    function GenerateUUID()
        local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
        return string.gsub(template, "[xy]", function(char)
            local hexDigit = (char == "x") and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format("%x", hexDigit)
        end)
    end
    function CheckIsPlayerAlive(player)
        player = player or LocalPlayer
        return player
            and player.Character
            and player.Character.Humanoid
            and player.Character.HumanoidRootPart
            and player.Character.Head
            and player.Character.Humanoid.Health > 0
    end
    function ConvertTo(vectorType, source)
        return vectorType.new(source.X, source.Y, source.Z)
    end
    function CaculateDistance(pointA, pointB)
        if not pointA then
            return 0
        end
        if not pointB then
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then
                return math.huge
            end
            pointB = hrp.Position
        end
        local vecA = (typeof(pointA) == "Vector3") and pointA
            or ((typeof(pointA) == "CFrame") and pointA.Position or ConvertTo(Vector3, pointA))
        local vecB = (typeof(pointB) == "Vector3") and pointB
            or ((typeof(pointB) == "CFrame") and pointB.Position or ConvertTo(Vector3, pointB))
        return (vecA - vecB).Magnitude
    end
    function FormatElapsedTime(totalSeconds, includeSeconds)
        totalSeconds = tonumber(totalSeconds)
        if not totalSeconds then
            return "[err]"
        end
        local days = math.floor(totalSeconds / 86400)
        local hours = math.floor(math.fmod(totalSeconds, 86400) / 3600)
        local minutes = math.floor(math.fmod(totalSeconds, 3600) / 60)
        local seconds = math.floor(math.fmod(totalSeconds, 60))
        if includeSeconds then
            return string.format("%dday, %dhrs, %dmin, %dsec.", days, hours, minutes, seconds)
        end
        return string.format("%dday, %dhrs.", days, hours)
    end
    DispTime = FormatElapsedTime -- Alias tương thích ngược
    CalculateDistance = CaculateDistance
    CalculateCircleDirection = CaculateCircreDirection
    function GetCurrentDateTime()
        local now = os.date("*t")
        local hour = now.hour
        local minute = now.min
        local day = now.day
        local month = now.month
        local year = now.year
        local weekday = now.wday
        local timeStr = string.format("%02d:%02d ", hour, minute)
        local weekdayNames = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }
        local weekdayName = weekdayNames[weekday]
        local monthNames = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
        local monthName = monthNames[month]
        local dateStr = string.format("%s, %s %d %d", weekdayName, monthName, day, year)
        return timeStr .. dateStr
    end
    function RandomArguments(...)
        local args = { ... }
        if #args == 0 then
            return nil
        end
        return args[math.random(1, #args)]
    end
    function RoundVector3Down(vec)
        return Vector3.new(math.floor(vec.X / 10) * 10, math.floor(vec.Y / 10) * 10, math.floor(vec.Z / 10) * 10)
    end
    local currentAngle = 30
    lastChange = tick()
    CaculateCircreDirection = function(basePos)
        if currentAngle > 50000 then
            currentAngle = 60
        end
        currentAngle = currentAngle + ((tick() - lastChange) > 0.4 and 80 or 0)
        if tick() - lastChange > 0.4 then
            lastChange = tick()
        end
        local pos = (typeof(basePos) == "CFrame") and basePos.Position or basePos
        local offset = Vector3.new(math.cos(math.rad(currentAngle)) * 40, 0, math.sin(math.rad(currentAngle)) * 40)
        local newPos = pos + offset
        return CFrame.new(RoundVector3Down(newPos))
    end
    function GetMonAsSortedRange()
        local found = {}
        local enemiesFolder = Services.Workspace:FindFirstChild("Enemies")
        if enemiesFolder then
            for _, entity in ipairs(enemiesFolder:GetChildren()) do
                if
                    entity
                    and entity:FindFirstChild("Humanoid")
                    and entity:FindFirstChild("HumanoidRootPart")
                    and entity.Humanoid.Health > 0
                then
                    table.insert(found, entity)
                end
            end
        end
        for _, entity in ipairs(game.ReplicatedStorage:GetChildren()) do
            if
                entity
                and entity:FindFirstChild("Humanoid")
                and entity:FindFirstChild("HumanoidRootPart")
                and entity.Humanoid.Health > 0
            then
                table.insert(found, entity)
            end
        end
        table.sort(found, function(entityA, entityB)
            return CaculateDistance(entityA.HumanoidRootPart.CFrame) < CaculateDistance(entityB.HumanoidRootPart.CFrame)
        end)
        return found
    end
    function GetMeleeIdByName(name)
        for idx, entry in MeleesTable do
            if entry == name then
                return MeleesId[idx]
            end
        end
    end
    function getpos(name)
        for _, npc in game:GetService("ReplicatedStorage").NPCs:GetChildren() do
            if npc.Name == name then
                return npc.HumanoidRootPart.CFrame
            end
        end
        for _, npc in workspace.NPCs:GetChildren() do
            if npc.Name == name then
                return npc.HumanoidRootPart.CFrame
            end
        end
    end
    function BuyMelee(meleeId, confirm)
        if meleeId == "DragonClaw" and workspace.NPCs:FindFirstChild("Sabi") then
            if confirm then
                local buyRes = Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
                if (buyRes == 1 or buyRes == true) and not table.find(BoughtMelees, meleeId) then
                    table.insert(BoughtMelees, meleeId)
                end
                return Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
            end
            return Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
        end
        if confirm then
            local res = Remotes.CommF_:InvokeServer("Buy" .. meleeId, true)
            DebugLog("Response_", res == 1, typeof(res))
            if type(res) == "number" and not table.find(BoughtMelees, meleeId) then
                table.insert(BoughtMelees, meleeId)
            end
            return res == 1
        end
        return Remotes.CommF_:InvokeServer("Buy" .. meleeId)
    end
    function SendKey(key, holdTime)
        (function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
            task.wait(holdTime)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
        end)()
    end
    function FruitIdToName(fruitId)
        if not fruitId then
            return ""
        end
        local str = tostring(fruitId)
        if string.find(str, "Fruit") then
            return str
        end
        local name = string.match(str, "((%u)[^%-]+)$")
        return (name or str) .. " Fruit"
    end
    function Split(text, sep)
        if sep == nil then
            sep = "%s"
        end
        local parts = {}
        for piece in string.gmatch(tostring(text or ""), "([^" .. sep .. "]+)") do
            table.insert(parts, piece)
        end
        return parts
    end
    function FruitNameToId(fruitName)
        local parts = Split(fruitName)
        local firstWord = parts[1] or tostring(fruitName or "")
        return firstWord .. "-" .. firstWord
    end
    local QuestManager = {
        CurrentLevel = 2,
        DoubleQuest = true,
        CurrentQuests = {},
        BlacklistedQuestIds = { BartiloQuest = 1, CitizenQuest = 1, Trainees = 1, MarineQuest = 1, ImpelQuest = 1 },
    }
    local J = QuestManager -- Alias tương thích ngược
    local GuideNPCList = require(game.ReplicatedStorage.GuideModule).Data.NPCList
    -- Chờ nạp dữ liệu người chơi an toàn (LocalPlayer.Data.Level)
    local dataLoadTimeout = os.time() + 10
    repeat
        task.wait(0.2)
        pcall(RefreshPlayerData)
    until (ScriptStorage.PlayerData and ScriptStorage.PlayerData.Level) or os.time() > dataLoadTimeout
    pcall(function()
        QuestManager.Quests = require(game.ReplicatedStorage:WaitForChild("Quests", 5))
    end)
    QuestManager.Quests = QuestManager.Quests or {}

    function QuestManager.Set(self, key, value)
        self[key] = value
    end

    function QuestManager.RefreshQuest(self)
        if not (ScriptStorage.PlayerData and ScriptStorage.PlayerData.Level) then
            pcall(RefreshPlayerData)
            local waitTimeout = os.time() + 5
            while not (ScriptStorage.PlayerData and ScriptStorage.PlayerData.Level) and os.time() < waitTimeout do
                task.wait(0.3)
                pcall(RefreshPlayerData)
            end
        end
        local highestLevelReq = 0
        local matchedQuest = nil
        for questId, questList in pairs(QuestManager.Quests) do
            if not QuestManager.BlacklistedQuestIds[questId] then
                local firstStep = questList[1]
                if
                    firstStep
                    and firstStep.LevelReq >= highestLevelReq
                    and firstStep.LevelReq <= ScriptStorage.PlayerData.Level
                then
                    highestLevelReq = firstStep.LevelReq
                    matchedQuest = questList
                    self.CurrentQuestId = questId
                    if ScriptStorage.PlayerData.Level >= 1500 and SeaIndex == 2 and questId == "ForgottenQuest" then
                        break
                    end
                end
            end
        end
        if not matchedQuest then
            return
        end
        local lastStep = matchedQuest[#matchedQuest]
        if lastStep and lastStep.Task then
            for _, stepDone in pairs(lastStep.Task) do
                if stepDone == 1 then
                    table.remove(matchedQuest, #matchedQuest)
                    break
                end
            end
        end
        for npcEntry, npcData in pairs(GuideNPCList) do
            for _, npcLevel in ipairs(npcData.Levels or {}) do
                if matchedQuest[#matchedQuest] and npcLevel == matchedQuest[#matchedQuest].LevelReq then
                    self.CurrentNpc = npcEntry.CFrame
                end
            end
        end
        self.CurrentQuests = matchedQuest
    end

    function QuestManager.GetCurrentQuest(self)
        local stepIndex = self.CurrentQuests[self.CurrentLevel]
                and self.CurrentQuests[self.CurrentLevel].LevelReq <= ScriptStorage.PlayerData.Level
                and self.CurrentLevel
            or 1
        local questStepData = self.CurrentQuests[stepIndex]
        if questStepData and questStepData.Task then
            local taskFlag = next(questStepData.Task)
            if taskFlag then
                return taskFlag, self.CurrentNpc, self.CurrentQuestId, stepIndex, questStepData.Name
            end
        end
    end

    function QuestManager.MarkAsCompleted(self)
        self.CurrentLevel = (self.CurrentLevel == 2) and 1 or 2
    end

    function QuestManager.AbandonQuest()
        DebugLog("Abandon Quest")
        Remotes.CommF_:InvokeServer("AbandonQuest")
    end

    function QuestManager.GetCurrentClaimQuest(self)
        local questGui = game.Players.LocalPlayer.PlayerGui.Main.Quest
        local questVisible = questGui and questGui.Visible
        local titleLabel = questVisible and questGui.Container.QuestTitle.Title
        local questRawText = titleLabel and titleLabel.Text
        local questParsedMob = questRawText and questRawText:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", "%2")
        local cleanMob = (
            type(questParsedMob) == "string" and string.gsub(questParsedMob, "Military ", "Mil. ") or questParsedMob
        )
        return cleanMob, questRawText or ""
    end

    function QuestManager.StartQuest(questId, step)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ColorsDealer", "2")
        return Remotes.CommF_:InvokeServer("StartQuest", questId, step)
    end
    -- local W = game:HttpGet('https://raw.githubusercontent.com/sucvatthieunang/Trackstat/refs/heads/main/boss')
    ScriptStorage.MobRegions = {}
    local spawnFolder = game:GetService("ReplicatedStorage"):FindFirstChild("FortBuilderReplicatedSpawnPositionsFolder")
    if spawnFolder then
        for _, spawnPoint in ipairs(spawnFolder:GetChildren()) do
            local key = tostring(spawnPoint.Name or spawnPoint)
            ScriptStorage.MobRegions[key] = ScriptStorage.MobRegions[key] or {}
            table.insert(ScriptStorage.MobRegions[key], spawnPoint.CFrame)
        end
    end
    TweenController = {}
    function TweenController.Update()
        if _G.Stop then
            return
        end
        local trackedRoot = game.Players.LocalPlayer.Character.HumanoidRootPart
        HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        if CaculateDistance(trackedRoot.CFrame) > 250 then
            pcall(function()
                TweenInstance:Cancel()
            end)
            TweenDebounce = true
            trackedRoot.CFrame = HumanoidRootPart.CFrame
            TweenDebounce = false
        end
        HumanoidRootPart.CFrame = trackedRoot.CFrame + Vector3.new(0, 3, 0)
    end
    function CheckItem(itemName)
        local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name == itemName or string.find(tool.Name, itemName)) then
                    return tool
                end
            end
        end
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, tool in ipairs(character:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name == itemName or string.find(tool.Name, itemName)) then
                    return tool
                end
            end
        end
        return false
    end
    function CheckLegendaryItems()
        return CheckItem("God's Chalice")
            or CheckItem("Fist of Darkness")
            or CheckItem("Sweet Chalice")
            or CheckItem("Hallow Essence")
            or CheckItem("Flower1")
    end
    function InArea(pos)
        local WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
        if not WorldOrigin or not WorldOrigin:FindFirstChild("Locations") then
            return nil
        end
        local posVec = typeof(pos) == "CFrame" and pos.Position or pos
        local bestLocation, bestScale = nil, 0
        for _, locationPart in ipairs(WorldOrigin.Locations:GetChildren()) do
            local mesh = locationPart:FindFirstChild("Mesh")
            if mesh and (posVec - locationPart.Position).Magnitude <= (mesh.Scale.X / 2) + 500 then
                if mesh.Scale.X > bestScale then
                    bestScale = mesh.Scale.X
                    bestLocation = locationPart
                end
            end
        end
        return bestLocation
    end
    function GetSpawnPoint(pos)
        if not pos then
            return nil
        end
        local origin = workspace:FindFirstChild("_WorldOrigin")
        local teamName = (game.Players.LocalPlayer.Team and game.Players.LocalPlayer.Team.Name) or Config.Team
        local spawns = origin and origin:FindFirstChild("PlayerSpawns") and origin.PlayerSpawns:FindFirstChild(teamName)
        if not spawns then
            return nil
        end
        local posVec = (typeof(pos) == "CFrame") and pos.Position
            or ((typeof(pos) == "Vector3") and pos or (pos.Position or pos))
        for _, spawnEntry in ipairs(spawns:GetChildren()) do
            local part = spawnEntry:FindFirstChild("Part")
            if part and (part.Position - posVec).Magnitude <= 2500 then
                return spawnEntry
            end
        end
        return nil
    end
    function CanBypassTeleport(targetPos)
        local currentSettings = getgenv().SettingFarm or farmSettings
        local bypassConfig = currentSettings and currentSettings["Bypass Teleport"]
        if bypassConfig and not bypassConfig["Enabled"] then
            return false
        end
        if bypassConfig and bypassConfig["Item Dont Reset"] then
            local dontReset = bypassConfig["Item Dont Reset"]
            local char = game.Players.LocalPlayer.Character
            if dontReset["Blox Fruits"] and char then
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("Tool") and string.find(child.Name, "Fruit") then
                        return false
                    end
                end
            end
            if dontReset["Ledendary Items"] and CheckLegendaryItems() then
                return false
            end
        end
        local area = InArea(targetPos)
        if not area then
            return false
        end
        local areaName = area.Name
        local isRestrictedArea = areaName:find("Dimension")
            or areaName:find("Submerged")
            or areaName == "Sealed Cavern"
            or areaName:lower():find("under")
        if isRestrictedArea then
            return false
        end
        if CheckLegendaryItems() then
            return false
        end
        local data = game.Players.LocalPlayer:FindFirstChild("Data")
        local lso = data and data:FindFirstChild("LastSpawnPoint")
        if lso and lso.Value == "SubmergedIsland" then
            return false
        end
        local hrp = game.Players.LocalPlayer.Character
            and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return false
        end
        if (targetPos - hrp.Position).Magnitude <= 3500 then
            return false
        end
        return true
    end
    function GetBypassCFrame(targetPos)
        local bestVal, bestSpawn = math.huge, nil
        local hrp = game.Players.LocalPlayer.Character
            and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return nil
        end
        local origin = workspace:FindFirstChild("_WorldOrigin")
        local teamName = (game.Players.LocalPlayer.Team and game.Players.LocalPlayer.Team.Name) or Config.Team
        local spawns = origin and origin:FindFirstChild("PlayerSpawns") and origin.PlayerSpawns:FindFirstChild(teamName)
        if not spawns then
            return nil
        end
        local currentSpawn = GetSpawnPoint(hrp)
        for _, spawnLocation in ipairs(spawns:GetChildren()) do
            local spawnPart = spawnLocation:FindFirstChild("Part")
            if spawnPart then
                local distPlayerToTarget = (targetPos - hrp.Position).Magnitude
                local distSpawnToPlayer = (spawnPart.Position - hrp.Position).Magnitude
                local distSpawnToTarget = (spawnPart.Position - targetPos).Magnitude
                local resolvedSpawn = GetSpawnPoint(spawnPart)
                if
                    distPlayerToTarget >= 3000
                    and resolvedSpawn ~= currentSpawn
                    and distSpawnToPlayer <= 10000
                    and distSpawnToTarget <= bestVal
                then
                    bestVal = distSpawnToTarget
                    bestSpawn = spawnLocation
                end
            end
        end
        return bestSpawn
    end
    function BypassTP(targetPos)
        if not CanBypassTeleport(targetPos) then
            return false
        end
        local targetSpawn = GetBypassCFrame(targetPos)
        if not targetSpawn then
            return false
        end
        local char = game.Players.LocalPlayer.Character
        if not char then
            return false
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then
            return false
        end
        pcall(function()
            char.LastSpawnPoint.Disabled = true
        end)
        Remotes.CommF_:InvokeServer("SetLastSpawnPoint", targetSpawn.Name)
        Remotes.CommF_:InvokeServer("SetSpawnPoint")
        char:PivotTo(targetSpawn.Part.CFrame)
        hum:ChangeState(15)
        repeat
            task.wait()
        until game.Players.LocalPlayer.Character
            and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0
        return true
    end
    function RequestEntrance(pos)
        local bestDist, bestPortal = math.huge, nil
        for _, portalPos in ipairs(Portals or {}) do
            local targetPosition = (typeof(pos) == "CFrame") and pos.Position or pos
            local distanceToPortal = (portalPos - targetPosition).Magnitude
            if distanceToPortal < bestDist then
                bestDist = distanceToPortal
                bestPortal = portalPos
            end
        end
        if bestPortal and bestDist < CaculateDistance(pos) then
            if TweenInstance then
                pcall(function()
                    TweenInstance:Cancel()
                end)
            end
            Remotes.CommF_:InvokeServer("requestEntrance", bestPortal)
            task.wait(1)
            return true
        end
    end
    function TweenController.Create(target)
        if _G.Stop then
            return
        end
        if not target or TweenDebounce then
            return
        end
        local targetCFrame = typeof(target) ~= "CFrame" and ConvertTo(CFrame, target) or target
        if TweenInstance then
            pcall(function()
                TweenInstance:Cancel()
            end)
        end
        local hrp = game.Players.LocalPlayer.Character
            and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return
        end
        local dist = CaculateDistance(targetCFrame)
        if dist >= 5000 then
            if BypassTP(targetCFrame.Position) then
                return
            end
        end
        for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        local head = game.Players.LocalPlayer.Character:WaitForChild("Head")
        if not head:FindFirstChild("eltrul") then
            local noFallForce = Instance.new("BodyVelocity")
            noFallForce.Name = "eltrul"
            noFallForce.MaxForce = Vector3.new(0, math.huge, 0)
            noFallForce.Velocity = Vector3.zero
            noFallForce.Parent = head
        end
        if CaculateDistance(targetCFrame) > 500 then
            if SeaIndex ~= 3 then
                if RequestEntrance(targetCFrame) then
                    return TweenController.Create(targetCFrame)
                end
            end
        end

        if
            CaculateDistance(Vector3.new(11256, -2138.0, 9888), targetCFrame)
                < (CaculateDistance(targetCFrame) - 700)
            and SeaIndex == 3
        then
            local submarineDock = CFrame.new(-16269.0, 23, 1371)
            if CaculateDistance(submarineDock) > 60 then
                return TweenController.Create(submarineDock) and task.wait(1)
            end
            local netModule = require(game.ReplicatedStorage.Modules.Net)
            netModule:RemoteFunction("SubmarineWorkerSpeak"):InvokeServer("TravelToSubmergedIsland")
            AwaitUntilPlayerLoaded(game.Players.LocalPlayer)
            task.wait(1)
        end
        targetCFrame = CFrame.new(targetCFrame.Position)
        local char = game.Players.LocalPlayer.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return
        end
        local travelDist = CalculateDistance(hrp.CFrame, targetCFrame)
        local currentPos = hrp.Position
        hrp.CFrame = CFrame.new(currentPos.X, targetCFrame.Y, currentPos.Z)

        local currentSettings = getgenv().SettingFarm or farmSettings
        local configuredSpeed = tonumber(currentSettings["Tween Speed"]) or 200
        local travelSpeed = (travelDist < 18 and 25 or configuredSpeed)

        TweenInstance = Services.TweenService:Create(
            hrp,
            TweenInfo.new(travelDist / travelSpeed, Enum.EasingStyle.Linear),
            { CFrame = targetCFrame }
        )
        TweenInstance:Play()
    end
    local AttackModule = {}
    local playersService = game:GetService("Players")
    local AttackObject = {}
    function GetAllBladeHits()
        local bladehits = {}
        local char = game.Players.LocalPlayer.Character
        local myHrp = char and char:FindFirstChild("HumanoidRootPart")
        if not myHrp then
            return bladehits
        end
        local enemiesFolder = workspace:FindFirstChild("Enemies")
        if enemiesFolder then
            for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                local inRange = enemy:FindFirstChild("Humanoid")
                    and enemy:FindFirstChild("HumanoidRootPart")
                    and enemy.Humanoid.Health > 0
                    and (enemy.HumanoidRootPart.Position - myHrp.Position).Magnitude <= 75
                if inRange then
                    table.insert(bladehits, enemy)
                end
            end
        end
        return bladehits
    end
    function Getplayerhit()
        local bladehits = {}
        local char = game.Players.LocalPlayer.Character
        local myHrp = char and char:FindFirstChild("HumanoidRootPart")
        if not myHrp then
            return bladehits
        end
        local charsFolder = workspace:FindFirstChild("Characters")
        if charsFolder then
            for _, enemy in ipairs(charsFolder:GetChildren()) do
                local inRange = enemy.Name ~= game.Players.LocalPlayer.Name
                    and enemy:FindFirstChild("Humanoid")
                    and enemy:FindFirstChild("HumanoidRootPart")
                    and enemy.Humanoid.Health > 0
                    and (enemy.HumanoidRootPart.Position - myHrp.Position).Magnitude <= 75
                if inRange then
                    table.insert(bladehits, enemy)
                end
            end
        end
        return bladehits
    end
    local netModule = Services.ReplicatedStorage.Modules.Net
    local attackRemote = require(netModule):RemoteEvent("RegisterAttack", true)
    local hitRemote = require(netModule):RemoteEvent("RegisterHit", true)
    function AttackObject:Attack()
        local targets = {}
        for _, hitEntry in ipairs(GetAllBladeHits()) do
            table.insert(targets, hitEntry)
        end
        for _, hitEntry in ipairs(Getplayerhit()) do
            table.insert(targets, hitEntry)
        end
        if #targets == 0 then
            return
        end
        local payload = { [1] = nil, [2] = {}, [4] = "078da5141" }
        for _, hitEntry in ipairs(targets) do
            attackRemote:FireServer(0)
            if not payload[1] then
                payload[1] = hitEntry:FindFirstChild("Head") or hitEntry:FindFirstChild("HumanoidRootPart")
            end
            table.insert(payload[2], { [1] = hitEntry, [2] = hitEntry:FindFirstChild("HumanoidRootPart") })
            table.insert(payload[2], hitEntry)
        end
        hitRemote:FireServer(payload[1], payload[2], nil, payload[4])
    end
    local lastFastAttackTick = 0
    task.spawn(function()
        while task.wait(0.01) do
            if not _G.Stop and (tick() - lastFastAttackTick < 0.45) then
                pcall(function()
                    AttackObject:Attack()
                end)
            end
        end
    end)
    function AttackModule.Attack(target)
        lastFastAttackTick = tick()
    end
    CombatController = {
        GRAB = true,
        GRAB_DISTANCE = SeaIndex == 1 and 250 or 350,
        MAX_ATTACK_DURATION = 2,
        MAX_ATTACK_DURATION_2 = 60,
        LEVITATE_TIME = 0,
        CurrentIndex = 1,
    }
    LastFound = os.time()
    function CombatController.Grab(mobName)
        safe_sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
        if not CombatController.GRAB or GrabDebounce == os.time() then
            return
        end
        GrabDebounce = os.time()
        if not MonResult or not MonResult:FindFirstChild("HumanoidRootPart") then
            return
        end
        local targetPos = MonResult.HumanoidRootPart.Position
        local enemiesFolder = Services.Workspace:FindFirstChild("Enemies")
        if not enemiesFolder then
            return
        end

        local maxGrabDistance = CombatController.GRAB_DISTANCE or (SeaIndex == 1 and 300 or 400)
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            if enemy ~= MonResult and enemy.Name == mobName then
                local hum = enemy:FindFirstChildOfClass("Humanoid")
                local root = enemy:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.Health > 0 then
                    local dist = (root.Position - targetPos).Magnitude
                    if dist <= maxGrabDistance then
                        local bv = root:FindFirstChild("FarmingVelocity")
                        if not bv then
                            bv = Instance.new("BodyVelocity")
                            bv.Name = "FarmingVelocity"
                            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                            bv.Velocity = Vector3.zero
                            bv.Parent = root
                        end
                        root.CanCollide = false
                        if safe_isnetworkowner(root) then
                            root.CFrame = MonResult.HumanoidRootPart.CFrame
                                * CFrame.new(math.random(-2, 2), 0, math.random(-2, 2))
                        end
                        enemy:SetAttribute("IsGrabbed", true)
                    end
                end
            end
        end
    end
    local function GetEntityDistance(entity)
        local rootPart = entity and entity:FindFirstChild("HumanoidRootPart")
        return rootPart and math.floor(CalculateDistance(rootPart.CFrame)) or math.huge
    end
    function CombatController.Search(names)
        local candidates = {}
        local anyFound = false
        for _, entity in GetMonAsSortedRange() do
            if table.find(names, entity.Name) and entity:FindFirstChild("Humanoid") and entity.Humanoid.Health > 0 then
                if (entity:GetAttribute("FailureCount") or 0) < 3 then
                    anyFound = true
                    table.insert(candidates, entity)
                end
            end
        end
        table.sort(candidates, function(entityA, entityB)
            return GetEntityDistance(entityA) < GetEntityDistance(entityB)
        end)
        if anyFound then
            local best = candidates[1]
            return best
        end
        for _, npcName in names do
            local npc = game.ReplicatedStorage:FindFirstChild(npcName)
            if npc then
                return npc
            end
        end
    end
    function CombatController.Attack(names, useNearest, maxDistance, onGiveUp)
        if
            ScriptStorage.Tools["Sweet Chalice"] and safe_getsenv(game.ReplicatedStorage.GuideModule)["_G"]["InCombat"]
        then
            TweenController.Create(Vector3.new(0, 0, 0))
            return
        end
        safe_sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
        names = type(names) == "string" and { names } or (names or {})
        for _, mobName in names do
            local mobNameStr = tostring(mobName)
            if
                mobNameStr == "Deandre"
                or mobNameStr == "Urban"
                or mobNameStr == "Diablo" and (os.time() - (lastEliteHunterCheck or 0)) > 180
            then
                lastEliteHunterCheck = os.time()
                Remotes.CommF_:InvokeServer("EliteHunter")
            end
            if useNearest then
                local nearestMob = GetMonAsSortedRange()[1]
                local nearestPos = nearestMob
                    and nearestMob:FindFirstChild("HumanoidRootPart")
                    and nearestMob.HumanoidRootPart.Position
                if nearestPos and CaculateDistance(nearestPos) < maxDistance then
                    MonResult = nearestMob
                end
            else
                MonResult = CombatController.Search(names)
            end
            if MonResult then
                LastFound = os.time()
                local attackTicks = 0
                local attackTicks2, lastTickTime = 0, os.time()
                while task.wait() do
                    if _G.Stop then
                        return
                    end
                    if
                        ScriptStorage.Tools["Sweet Chalice"]
                        and safe_getsenv(game.ReplicatedStorage.GuideModule)["_G"]["InCombat"]
                    then
                        TweenController.Create(Vector3.new(0, 0, 0))
                        return
                    end

                    -- Tự động giữ Haki Buso (Aura) luôn BẬT trong lúc đánh quái
                    local myChar = LocalPlayer.Character
                    if myChar and not myChar:FindFirstChild("HasBuso") then
                        pcall(function()
                            Remotes.CommF_:InvokeServer("Buso")
                        end)
                    end

                    -- Chống choáng / tự động nhảy thoát nếu bị quái đánh ngồi (Unsit)
                    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
                    if myHum and myHum.Sit then
                        myHum.Sit = false
                        myHum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end

                    local monHumanoid = MonResult:FindFirstChild("Humanoid")
                    local monRoot = MonResult:FindFirstChild("HumanoidRootPart")
                    if not monHumanoid or monHumanoid.Health <= 0 then
                        if MonResult.Name == "Don Swan" then
                            Storage:Set("SwanDefeated", true)
                        end
                        break
                    end
                    TweenController.Create(CaculateCircreDirection(monRoot.CFrame) + Vector3.new(0, 35, 0))
                    if CaculateDistance(monRoot.Position + Vector3.new(0, 35, 0)) < 150 then
                        if onGiveUp then
                            onGiveUp()
                        end
                        CombatController.Grab(mobName or "")
                        if MonResult.Name ~= "Core" then
                            local stuckTooLong = ScriptStorage.PlayerData.Level > 100
                                and attackTicks2 >= CombatController.MAX_ATTACK_DURATION_2
                                and monHumanoid.Health - monHumanoid.MaxHealth == 0
                            if stuckTooLong then
                                SetTask(
                                    "SubTask",
                                    "Hop Server - Mob Health Unchanged ( "
                                        .. monHumanoid.Health
                                        .. " / "
                                        .. monHumanoid.MaxHealth
                                        .. ")"
                                )
                                alert("Combat Alert", "Mob health unchanged, resetting...")
                                _G.Stop = true
                                game.Players.LocalPlayer:Kick("Rejoining..")
                            end
                            if
                                attackTicks >= CombatController.MAX_ATTACK_DURATION
                                and monHumanoid.Health - monHumanoid.MaxHealth == 0
                            then
                                attackTicks = 0
                                local oldPos = MonResult:GetAttribute("OldPosition")
                                if oldPos then
                                    MonResult:SetPrimaryPartCFrame(CFrame.new(oldPos))
                                    MonResult:SetAttribute("IgnoreGrab", true)
                                    MonResult:SetAttribute(
                                        "FailureCount",
                                        (MonResult:GetAttribute("FailureCount") or 0) + 1
                                    )
                                    alert(
                                        "Combat Alert",
                                        "Attack failed, resetting position (#"
                                            .. tostring(MonResult:GetAttribute("FailureCount") or 0)
                                            .. ")"
                                    )
                                    MonResult.HumanoidRootPart.CFrame = (CFrame.new(oldPos))
                                    task.wait()
                                    return
                                end
                            end
                        end
                        local shouldUseFruit = (FarmFruitMastery or math.huge) - os.time() < 3
                            and math.floor(MonResult.Humanoid.Health / MonResult.Humanoid.MaxHealth * 100) < 30
                            and not FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
                        if shouldUseFruit then
                            TweenController.Create(monRoot.CFrame + Vector3.new(0, 25, 0))
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Blox Fruit")
                            LockAimPositionTo(MonResult.HumanoidRootPart.CFrame.p)
                            local keyList = { "Z", "X", "C", "V" }
                            local chosenKey = keyList[math.random(1, #keyList)]
                            SendKey(chosenKey, 0.31)
                        else
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(
                                ScriptStorage.ForceToUseSword and "Sword" or "Melee"
                            )
                        end
                        AttackModule:Attack(MonResult)
                        if os.time() ~= lastTickTime then
                            lastTickTime = os.time()
                            attackTicks = attackTicks + 1
                            attackTicks2 = attackTicks2 + 1
                        end
                        if attackTicks > 30 and MonResult.Name ~= "Core" then
                            alert("Combat Alert", "Attack timeout (>30s), switching target...")
                            break
                        end
                    end
                end
            elseif not useNearest then
                if (os.time() - LastFound) > 200 then
                    alert("Kaitun Hub", "Mob spawn timeout, rejoining...")
                    game.Players.LocalPlayer:Kick("Rejoining..")
                    return
                end
                local KnownMobPositions = {
                    ["Sky Bandit"] = Vector3.new(-4835, 718, -2618),
                    ["God's Guard"] = Vector3.new(-4720, 845, -1950),
                    ["Bandit"] = Vector3.new(1060, 16, 1548),
                    ["Monkey"] = Vector3.new(-1610, 36, 147),
                    ["Gorilla"] = Vector3.new(-1240, 6, -500),
                    ["Pirate"] = Vector3.new(-1215, 4, 3915),
                    ["Brute"] = Vector3.new(-1145, 14, 4300),
                    ["Desert Bandit"] = Vector3.new(900, 6, 4400),
                    ["Desert Officer"] = Vector3.new(1600, 6, 4350),
                    ["Snow Bandit"] = Vector3.new(1285, 26, -1350),
                    ["Snowman"] = Vector3.new(1185, 30, -1450),
                    ["Chief Petty Officer"] = Vector3.new(-5035, 20, 4320),
                    ["Swan Pirate"] = Vector3.new(900, 120, 1200),
                    ["Factory Staff"] = Vector3.new(425, 72, -430),
                    ["Marine Lieutenant"] = Vector3.new(-2800, 72, -3000),
                    ["Forest Pirate"] = Vector3.new(-13270, 332, -7625),
                    ["Mythological Pirate"] = Vector3.new(-13500, 470, -6900),
                    ["Jungle Pirate"] = Vector3.new(-12100, 332, -10500),
                }

                local regionList = ScriptStorage.MobRegions[mobName]
                if not regionList then
                    local foundNpc = Services.Workspace.Enemies:FindFirstChild(mobName)
                        or game.ReplicatedStorage:FindFirstChild(mobName)
                    regionList = foundNpc and { foundNpc:GetPrimaryPartCFrame().p }
                end
                if not regionList and KnownMobPositions[mobName] then
                    regionList = { KnownMobPositions[mobName] }
                end
                if not regionList then
                    Report(
                        "Lỗi dữ liệu quái vật: Quái "
                            .. tostring(mobName)
                            .. " không có dữ liệu tọa độ hồi sinh!",
                        "LỖI GAME"
                    )
                    return
                end
                local chosenPos
                if not regionList[CombatController.CurrentIndex] then
                    CombatController.CurrentIndex = 1
                end
                chosenPos = regionList[CombatController.CurrentIndex]
                TweenController.Create(chosenPos + Vector3.new(0, 35, 35))
                if CaculateDistance(chosenPos + Vector3.new(0, 35, 35)) < 15 then
                    CombatController.CurrentIndex = CombatController.CurrentIndex + 1
                end
            end
        end
    end
    LevelFarmTTL = 0
    LastTravel = os.time()
    FunctionsHandler = { Initalized = false }
    setmetatable(FunctionsHandler, {
        __index = function(self, moduleName)
            local existingModule = rawget(self, moduleName)
            if not existingModule then
                return {
                    Register = function(selfModule)
                        if selfModule == false then
                            return
                        end
                        local newModule = {
                            CacheListener = {},
                            RealCache = {},
                            Methods = {},
                            Constants = {},
                            Events = {},
                            Initalized = true,
                        }
                        function newModule.RegisterMethod(moduleSelf, methodName, callback)
                            moduleSelf.Methods[methodName] = {
                                Name = methodName,
                                Callback = callback,
                                Call = function(methodSelf, ...)
                                    return methodSelf.Callback(...)
                                end,
                                Events = {},
                            }
                            return true
                        end
                        setmetatable(newModule.Constants, {
                            __newindex = function()
                                assert(false, "cannot change constant value!")
                            end,
                        })
                        function newModule.SaveConstant(moduleSelf, constKey, constVal)
                            if moduleSelf.Constants[constKey] then
                                return assert(false, "constant name was used before!")
                            end
                            rawset(moduleSelf.Constants, constKey, constVal)
                        end
                        function newModule.Set(moduleSelf, key, value)
                            moduleSelf.CacheListener[key] = value
                            return value
                        end
                        function newModule.Get(moduleSelf, key)
                            return moduleSelf.Constants[key] or moduleSelf.RealCache[key]
                        end
                        function newModule.AddVariableChangeListener(moduleSelf, key, callback)
                            moduleSelf.Events[key] = callback
                        end
                        newModule.CacheListener.__parent = newModule
                        setmetatable(newModule.CacheListener, {
                            __newindex = function(cacheListenerSelf, key, value)
                                _ = cacheListenerSelf.__parent.Events[key]
                                    and cacheListenerSelf.__parent.Events[key](key, value)
                                cacheListenerSelf.__parent.RealCache[key] = value
                            end,
                        })
                        FunctionsHandler[moduleName] = newModule
                    end,
                    Initalized = false,
                }
            end
            return existingModule
        end,
    })
    function FunctionsHandler.SynchorizeUntilModuleLoaded(moduleTable, timeoutSeconds)
        local startTime = os.time()
        while not moduleTable.Initalized do
            task.wait()
            local elapsed = os.time() - startTime
            assert(not (timeoutSeconds and elapsed > timeoutSeconds), "timed out")
        end
    end
    function GetCurrentClaimQuest(unusedArg)
        local questGui = game.Players.LocalPlayer.PlayerGui.Main.Quest
        local questText = questGui.Visible
            and questGui.Container.QuestTitle.Title.Text:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", "%2")
        return (type(questText) == "string" and string.gsub(questText, "Military ", "Mil. ") or questText),
            questGui.Container.QuestTitle.Title.Text
    end
    FunctionsHandler.LocalPlayerController.Register()
    FunctionsHandler.ExpRedeem:Register()
    FunctionsHandler.LevelFarm:Register()
    FunctionsHandler.Saber:Register()
    FunctionsHandler.Rengoku:Register()
    FunctionsHandler.Yama:Register()
    FunctionsHandler.Tushita:Register()
    FunctionsHandler.SpikeyTrident:Register()
    FunctionsHandler.SharkAchor:Register()
    FunctionsHandler.Pole:Register()
    FunctionsHandler.FoxLamp:Register()
    FunctionsHandler.DarkDagger:Register()
    FunctionsHandler.Canvander:Register()
    FunctionsHandler.BuddySword:Register()
    FunctionsHandler.HallowScythe:Register()
    FunctionsHandler.CursedDualKatana:Register()
    FunctionsHandler.AcidumRifle:Register()
    FunctionsHandler.Kabucha:Register()
    FunctionsHandler.VenomBow:Register()
    FunctionsHandler.SoulGuitar:Register()
    FunctionsHandler.DragonStorm:Register()
    FunctionsHandler.InsictV2:Register()
    FunctionsHandler.RainbowSaviour:Register()

    -- ==============================================================================
    -- 🌈 RAINBOW HAKI QUEST SYSTEM (HORNED MAN / RAINBOW SAVIOUR)
    -- ==============================================================================
    local RainbowBossList = {
        "Stone",
        "Hydra Leader",
        "Kilo Admiral",
        "Captain Elephant",
        "Beautiful Pirate",
    }

    local HornedManCFrame = CFrame.new(-11892, 931, -8761)

    local function HasCompletedRainbowHaki()
        if Storage and Storage.Get and Storage:Get("RainbowHakiCompleted") then
            return true
        end
        local isDone = false
        pcall(function()
            local status = Remotes.CommF_:InvokeServer("HornedMan", "Bet")
            if status == 1 then
                isDone = true
                if Storage and Storage.Set then
                    Storage:Set("RainbowHakiCompleted", true)
                    Storage:Save()
                end
            end
        end)
        return isDone
    end

    local function GetActiveRainbowHakiBoss()
        local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
            and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
        if not questGui or not questGui.Visible then
            return nil
        end
        local titleContainer = questGui:FindFirstChild("Container") and questGui.Container:FindFirstChild("QuestTitle")
        local titleLabel = titleContainer and titleContainer:FindFirstChild("Title")
        local questText = titleLabel and titleLabel.Text:lower()
        if not questText then
            return nil
        end

        for _, bossName in ipairs(RainbowBossList) do
            if string.find(questText, bossName:lower()) then
                return bossName
            end
        end
        if string.find(questText, "empress") or string.find(questText, "hydra") then
            return "Hydra Leader"
        end
        return nil
    end

    FunctionsHandler.RainbowSaviour:RegisterMethod("Refresh", function()
        -- 1. Kiểm tra cấu hình bật Rainbow Haki
        local currentSettings = getgenv().SettingFarm or farmSettings
        local getItems = currentSettings and currentSettings["Get Items"]
        local isEnabled = getItems and (getItems["Rainbow Haki"] or getItems["RGB Haki"])
        if not isEnabled then
            return false
        end

        -- 2. Phải ở Sea 3 và Cấp độ >= 1950
        if SeaIndex ~= 3 or (ScriptStorage.PlayerData.Level or 0) < 1950 then
            return false
        end

        -- 3. Kiểm tra xem đã sở hữu Rainbow Haki chưa
        if HasCompletedRainbowHaki() then
            return false
        end

        return true
    end)

    FunctionsHandler.RainbowSaviour:RegisterMethod("Start", function()
        if HasCompletedRainbowHaki() then
            alert("Rainbow Haki", "Rainbow Haki already unlocked!")
            Report("Nhiệm vụ Rainbow Haki: Người chơi đã hoàn thành từ trước!", "RAINBOW HAKI")
            return
        end

        local activeBoss = GetActiveRainbowHakiBoss()

        if activeBoss then
            -- Trường hợp 1: Đang có quest đánh một trong 5 boss
            SetTask("MainTask", "Rainbow Haki | Hunting Boss | " .. activeBoss)
            local bossModel = ScriptStorage.Enemies[activeBoss]
                or (Services.Workspace.Enemies and Services.Workspace.Enemies:FindFirstChild(activeBoss))
                or (activeBoss == "Hydra Leader" and Services.Workspace.Enemies and Services.Workspace.Enemies:FindFirstChild(
                    "Island Empress"
                ))
                or (game.ReplicatedStorage:FindFirstChild(activeBoss))

            if bossModel and bossModel:FindFirstChild("Humanoid") and bossModel.Humanoid.Health > 0 then
                alert("Rainbow Haki", "Found " .. activeBoss .. "! Engaging target...")
                CombatController.Attack(bossModel.Name)
                task.wait(1)
                return
            else
                -- Boss chưa hồi sinh trên server
                local currentSettings = getgenv().SettingFarm or farmSettings
                local canHopBoss = currentSettings
                    and currentSettings["Setting Hop"]
                    and currentSettings["Setting Hop"]["Hop Find Boss"]
                if canHopBoss then
                    SetTask("MainTask", "Rainbow Haki | Boss Not Spawned | Hopping Server...")
                    alert("Rainbow Haki", "Boss " .. activeBoss .. " not spawned! Hopping server...")
                    Hop("Rainbow Haki - Finding " .. activeBoss)
                    task.wait(5)
                else
                    SetTask("MainTask", "Rainbow Haki | Waiting Respawn | " .. activeBoss)
                    task.wait(2)
                end
                return
            end
        else
            -- Trường hợp 2: Chưa có quest -> Bay tới NPC Horned Man để nhận nhiệm vụ
            SetTask("MainTask", "Rainbow Haki | Horned Man | Traveling to NPC")
            if CalculateDistance(HornedManCFrame) > 15 then
                TweenController.Create(HornedManCFrame)
                return
            else
                local betResult = nil
                pcall(function()
                    betResult = Remotes.CommF_:InvokeServer("HornedMan", "Bet")
                end)
                task.wait(1)

                if betResult == 1 then
                    alert("Rainbow Haki", "Congratulations! Rainbow Haki unlocked successfully!")
                    Report(
                        "Chúc mừng! Đã hoàn thành toàn bộ chuỗi nhiệm vụ và mở khóa Rainbow Haki thành công!",
                        "RAINBOW HAKI"
                    )
                    if Storage and Storage.Set then
                        Storage:Set("RainbowHakiCompleted", true)
                        Storage:Save()
                    end
                else
                    local newBoss = GetActiveRainbowHakiBoss()
                    if newBoss then
                        SetTask("MainTask", "Rainbow Haki | Quest Accepted | Target: " .. newBoss)
                        alert("Rainbow Haki", "Next target: " .. newBoss)
                    end
                end
            end
        end
    end)

    FunctionsHandler.DarkBladeV2:Register()
    FunctionsHandler.SecondSeaPuzzle:Register()
    FunctionsHandler.ColosseumPuzzle:Register()
    FunctionsHandler.Trevor:Register()
    FunctionsHandler.EvoRace:Register()
    FunctionsHandler.Wenlocktoad:Register()
    FunctionsHandler.DarkBladeV3:Register()
    FunctionsHandler.ThirdSeaPuzzle:Register()
    FunctionsHandler.DojoQuest:Register()
    -- ==============================================================================
    -- ⚡ RACE V4 & PULL LEVER HELPERS (ĐIỀU KIỆN GẠT CẦN)
    -- ==============================================================================
    local RACES_V3 = {
        "Last Resort",
        "Agility",
        "Water Body",
        "Heavenly Blood",
        "Heightened Senses",
        "Energy Core",
        "Primordial Reign",
    }

    local function HasRaceAbility(character)
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            return false
        end
        for _, raceName in ipairs(RACES_V3) do
            if rootPart:FindFirstChild(raceName) then
                return true
            end
        end
        return false
    end

    local function HasMirrorFractal()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local character = LocalPlayer.Character
        return (backpack and backpack:FindFirstChild("Mirror Fractal"))
            or (character and character:FindFirstChild("Mirror Fractal"))
            or (ScriptStorage.Backpack and ScriptStorage.Backpack["Mirror Fractal"])
    end

    local function GetMysticIsland()
        local mapFolder = workspace:FindFirstChild("Map")
        return (mapFolder and mapFolder:FindFirstChild("MysticIsland")) or workspace:FindFirstChild("MysticIsland")
    end

    local function EnsureTempleOfTimeLoaded()
        pcall(function()
            local stash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")
            local temple = stash and stash:FindFirstChild("Temple of Time")
            local map = workspace:FindFirstChild("Map")
            if temple and map and not map:FindFirstChild("Temple of Time") then
                temple.Parent = map
            end
        end)
    end

    FunctionsHandler.RaceAwakening:Register()
    FunctionsHandler.RaceAwakening:RegisterMethod("Refresh", function()
        -- 1. Kiểm tra cấu hình bật Pull Level / Pull Lever
        local currentSettings = getgenv().SettingFarm or farmSettings
        local getItems = currentSettings["Get Items"] or {}
        local isPullLevelEnabled = getItems["Pull Level"] or getItems["Pull Lever"]
        if not isPullLevelEnabled then
            return false
        end

        -- 2. Điều kiện 1: Player phải trên Sea 3
        if SeaIndex ~= 3 then
            return false
        end

        -- 3. Kiểm tra xem đã gạt cần thành công chưa (nếu đã xong thì bỏ qua để farm việc khác)
        if Storage and Storage.Get and Storage:Get("LeverPulledCompleted") then
            return false
        end

        -- 4. Điều kiện 4: Player trong inventory phải có Mirror Fractal
        if not HasMirrorFractal() then
            return false
        end

        -- 5. Điều kiện 3: Player phải có Race V3
        if not HasRaceAbility(LocalPlayer.Character) then
            return false
        end

        -- 6. Điều kiện 2: Phải có Đảo Bí Ẩn (MysticIsland) hoặc đã có quyền mở cửa Temple of Time
        local mysticIsland = GetMysticIsland()
        local templeDoorCheck = false
        pcall(function()
            templeDoorCheck = Remotes.CommF_:InvokeServer("CheckTempleDoor")
        end)

        -- Trường hợp 1: Đã xong bánh răng xanh trên đảo, cửa mở -> Vào gạt cần
        if templeDoorCheck then
            return { Step = "PullLeverInTemple" }
        end

        -- Trường hợp 2: Có đảo bí ẩn xuất hiện -> Tiến hành các bước làm Đảo Bí Ẩn
        if mysticIsland then
            return { Step = "MirageIsland", Island = mysticIsland }
        end

        return false
    end)

    FunctionsHandler.RaceAwakening:RegisterMethod("Start", function(targetData)
        if not targetData then
            return
        end

        -- Xử lý an toàn: Kiểm tra nhân vật còn sống hay bị giết
        if not CheckIsPlayerAlive(LocalPlayer) then
            SetTask("MainTask", "Race V4 | Player Respawning | Waiting...")
            AwaitUntilPlayerLoaded(LocalPlayer)
            task.wait(1)
            return
        end

        EnsureTempleOfTimeLoaded()

        -- Kiểm tra tiến trình Race V4 ban đầu qua Remote Check
        local raceV4Check = nil
        pcall(function()
            raceV4Check = Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
        end)

        if raceV4Check == 1 then
            SetTask("MainTask", "Race V4 | King Red Head | Starting Quest")
            pcall(function()
                Remotes.CommF_:InvokeServer("RaceV4Progress", "Begin")
            end)
            task.wait(1)
            return
        elseif raceV4Check == 2 then
            SetTask("MainTask", "Race V4 | Great Tree Top | Traveling to Peak")
            local greatTreeTop = CFrame.new(28610, 14897, 106)
            if CalculateDistance(greatTreeTop) > 500 then
                RequestEntrance(Vector3.new(28283, 14897, 105))
                TweenController.Create(greatTreeTop)
                return
            else
                if CalculateDistance(CFrame.new(28610, 14897, 107)) < 25 then
                    task.wait(1)
                    pcall(function()
                        Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack")
                    end)
                    task.wait(0.5)
                    TweenController.Create(CFrame.new(2956, 2282, -7216))
                    pcall(function()
                        Remotes.CommF_:InvokeServer("RaceV4Progress", "Teleport")
                    end)
                end
                return
            end
        elseif raceV4Check == 3 then
            SetTask("MainTask", "Race V4 | Quest Progress | Continuing...")
            pcall(function()
                Remotes.CommF_:InvokeServer("RaceV4Progress", "Continue")
            end)
            task.wait(1)
            return
        end

        -- ======================================================================
        -- BƯỚC 1: XỬ LÝ TRÊN ĐẢO BÍ ẨN (MYSTIC / MIRAGE ISLAND)
        -- ======================================================================
        if targetData.Step == "MirageIsland" then
            local mysticIsland = GetMysticIsland()
            -- Xử lý lỗi: MẤT ĐẢO BÍ ẨN KHI ĐANG LÀM
            if not mysticIsland or not mysticIsland.Parent then
                SetTask("MainTask", "Race V4 | Mirage Island Despawned | Resuming Farm")
                Report(
                    "Đảo Bí Ẩn (Mirage Island) đã biến mất! Tạm dừng quy trình gạt cần để quay lại farm.",
                    "TỘC V4"
                )
                pcall(function()
                    if TweenInstance then
                        TweenInstance:Cancel()
                    end
                end)
                task.wait(2)
                return
            end

            -- 1. Tìm Bánh Răng Xanh (Blue Gear) trên đảo
            local blueGear = nil
            for _, item in ipairs(mysticIsland:GetDescendants()) do
                if
                    item.Name == "Part"
                    and item:IsA("MeshPart")
                    and item.Transparency == 0
                    and item.Size.Magnitude < 15
                then
                    blueGear = item
                    break
                end
            end

            -- Nếu đã xuất hiện Bánh Răng Xanh: Bay tới nhặt ngay
            if blueGear then
                SetTask("MainTask", "Race V4 | Blue Gear Found | Collecting Gear...")
                TweenController.Create(blueGear.CFrame)
                if CalculateDistance(blueGear.CFrame) < 8 then
                    task.wait(1)
                    Report("Đã nhặt thành công Bánh Răng Xanh (Blue Gear) trên Đảo Bí Ẩn!", "TỘC V4")
                end
                return
            end

            -- Nếu chưa có Bánh Răng Xanh: Cần lên đỉnh cao nhất, nhìn trăng và bật tộc V3
            local islandCenter = mysticIsland:FindFirstChild("Center")
            if not islandCenter then
                SetTask("MainTask", "Race V4 | Mirage Island | Locating Island Center")
                TweenController.Create(mysticIsland:GetPivot())
                return
            end

            local miragePeak = CFrame.new(islandCenter.Position.X, 500, islandCenter.Position.Z)
            SetTask("MainTask", "Race V4 | Mirage Island | Traveling to Peak")
            TweenController.Create(miragePeak)

            if CalculateDistance(miragePeak) < 150 then
                -- Kiểm tra trời tối (Night time)
                local currentClock = Lighting.ClockTime
                local isNight = (currentClock > 16.5 or currentClock < 5.5)

                if not isNight then
                    SetTask(
                        "MainTask",
                        "Race V4 | Mirage Island | Waiting for Night (Clock: "
                            .. string.format("%.1f", currentClock)
                            .. ")"
                    )
                    task.wait(1)
                    return
                end

                -- Xoay góc nhìn Camera nhìn thẳng vào Mặt Trăng
                SetTask("MainTask", "Race V4 | Mirage Island | Resonating Moon & V3 Ability")
                pcall(function()
                    local camera = workspace.CurrentCamera
                    if camera then
                        local moonDir = Lighting:GetMoonDirection()
                        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, camera.CFrame.Position + moonDir * 100)
                    end
                end)
                task.wait(0.5)

                -- Bật kỹ năng tộc V3
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
                end)
                task.wait(1)
            end
            return
        end

        -- ======================================================================
        -- BƯỚC 2: VÀO TEMPLE OF TIME VÀ GẠT CẦN (PULL LEVER)
        -- ======================================================================
        if targetData.Step == "PullLeverInTemple" then
            SetTask("MainTask", "Race V4 | Temple of Time | Entering Temple")
            EnsureTempleOfTimeLoaded()

            local templeLeverPosition = CFrame.new(28575, 14937, 72)
            local currentDistance = CalculateDistance(templeLeverPosition)

            -- Nếu đang ở xa ngoài đảo, dùng cổng dịch chuyển vào trước
            if currentDistance > 500 then
                RequestEntrance(Vector3.new(28283, 14897, 105))
                TweenController.Create(templeLeverPosition)
                return
            end

            -- Khi đã tới gần vị trí cần gạt
            if currentDistance > 10 then
                TweenController.Create(templeLeverPosition)
                return
            else
                SetTask("MainTask", "Race V4 | Temple of Time | Pulling the Lever")
                local templeMap = workspace.Map:FindFirstChild("Temple of Time")
                local leverPrompt = templeMap
                    and templeMap:FindFirstChild("Lever")
                    and templeMap.Lever:FindFirstChild("Prompt")
                    and templeMap.Lever.Prompt:FindFirstChild("ProximityPrompt")

                if leverPrompt then
                    pcall(function()
                        fireproximityprompt(leverPrompt, math.huge)
                    end)
                    task.wait(1)
                    alert("Race V4", "Congratulations! Pulled the lever successfully!")
                    Report(
                        "Chúc mừng! Đã gạt cần thành công tại Temple of Time mở khóa cổng Tộc V4!",
                        "TỘC V4"
                    )
                    if Storage and Storage.Set then
                        Storage:Set("LeverPulledCompleted", true)
                        Storage:Save()
                    end
                else
                    -- Nếu không thấy Prompt, có thể cần đã được gạt trước đó
                    Report(
                        "Không tìm thấy nút bấm cần gạt (Cần đã gạt trước đó hoặc phòng thử thách đã mở)!",
                        "TỘC V4"
                    )
                    if Storage and Storage.Set then
                        Storage:Set("LeverPulledCompleted", true)
                        Storage:Save()
                    end
                end
            end
        end
    end)

    FunctionsHandler.PirateRaid:Register()
    FunctionsHandler.RaidController:Register()
    FunctionsHandler.MeleesController:Register()
    FunctionsHandler.Superhuman:Register()
    FunctionsHandler.DeathStep:Register()
    FunctionsHandler.SharkmanKarate:Register()
    FunctionsHandler.ElectricClaw:Register()
    FunctionsHandler.DragonTalon:Register()
    FunctionsHandler.Godhuman:Register()
    FunctionsHandler.BossesTask:Register()
    FunctionsHandler.SpecialBossesTask:Register()
    FunctionsHandler.CollectDrops:Register()
    FunctionsHandler.CollectBerries:Register()
    FunctionsHandler.UtillyItemsActivitation:Register()
    FunctionsHandler.ExpRedeem:RegisterMethod("Refresh", function()
        return ScriptStorage.PlayerData.Level < MaxLevel
            and safe_getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost == 0
            and not Storage.Get(Storage, "IsCodesRanOut")
    end)
    FunctionsHandler.ExpRedeem:RegisterMethod("Start", function()
        local codesList = {
            "BANEXPLOIT",
            "NOMOREHACKS",
            "WildDares",
            "BossBuild",
            "GetPranked",
            "EARN_FRUITS",
            "Sub2UncleKizaru",
            "FIGHT4FRUIT",
            "kittgaming",
            "TRIPLEABUSE",
            "Sub2CaptainMaui",
            "Sub2Fer999",
            "Enyu_is_Pro",
            "Magicbus",
            "JCWK",
            "Starcodeheo",
            "Bluxxy",
            "SUB2GAMERROBOT_EXP1",
            "Sub2NoobMaster123",
            "Sub2Daigrock",
            "Axiore",
            "TantaiGaming",
            "StrawHatMaine",
            "Sub2OfficialNoobie",
            "TheGreatAce",
            "SEATROLLIN",
            "24NOADMIN",
            "ADMIN_TROLL",
            "NEWTROLL",
            "SECRET_ADMIN",
            "staffbattle",
            "NOEXPLOIT",
            "NOOB2ADMIN",
            "CODESLIDE",
            "fruitconcepts",
        }
        for _, code in codesList do
            SetTask("MainTask", "Code Redeem | " .. code .. " | Redeeming...")
            local redeemResult = (Remotes.Redeem:InvokeServer(code))
            task.wait()
            SetTask("MainTask", "Code Redeem | " .. code .. " | Status: " .. (redeemResult or "Failed"))
            if safe_getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost == 0 then
                if redeemResult and string.find(redeemResult, "SUCC") then
                    return SetTask("MainTask", "Code Redeem | 2x EXP Boost | Activated!") and task.wait(1)
                end
            else
                return
            end
        end
        Storage:Set("IsCodesRanOut", 1)
        Storage:Save()
    end)
    FunctionsHandler.LevelFarm:RegisterMethod("Refresh", function()
        local level = (ScriptStorage.PlayerData and ScriptStorage.PlayerData.Level) or 0

        -- ⚡ 100% Tự động sử dụng SKIP MODE tối ưu tốc độ cày Level 1-70 ở Sea 1
        if SeaIndex == 1 then
            if level < 50 then
                return 1 -- Floor 1: Bay tắt Đảo Trời đánh Sky Bandit (Level 1 -> 50)
            elseif level < 70 then
                return 2 -- Floor 2: Bay tắt Đảo Trời đánh God's Guard (Level 50 -> 70)
            end
        end

        return 4 -- Level 70+ cày theo chuỗi nhiệm vụ chuẩn
    end)
    FunctionsHandler.LevelFarm:RegisterMethod("Start", function(farmMode)
        if SeaIndex == 3 then
            local boneCount = (ScriptStorage.Backpack.Bones and ScriptStorage.Backpack.Bones.Count) or 0
            if boneCount >= 50 and os.time() > (BonesCooldown or 0) then
                local boneStatus, _, _, cooldownText = Remotes.CommF_:InvokeServer("Bones", "Check")
                DebugLog("Bone State", boneStatus, "Message", cooldownText)
                if tonumber(boneStatus or 1) == 0 and cooldownText then
                    local timeParts = Split(cooldownText, ":")
                    local cooldownWait = ((tonumber(timeParts[1] or 0) * 60) + tonumber(timeParts[2] or 0)) * 60
                    BonesCooldown = os.time() + cooldownWait
                    DebugLog("Next Bones Roll in:", cooldownWait, "seconds")
                else
                    DebugLog("Rolling Bones for materials...")
                    Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                end
            end
        end

        local playerLevel = ScriptStorage.PlayerData.Level or 0
        if GodHumanFlag then
            local neededMaterial, materialConfig = (function()
                for matName, matData in pairs(GodhumanMaterials) do
                    local ownedCount = (ScriptStorage.Backpack[matName] and ScriptStorage.Backpack[matName].Count) or 0
                    if ownedCount < matData[1] then
                        return matName, matData
                    end
                end
                return nil, nil
            end)()

            if neededMaterial and materialConfig then
                local targetSea = materialConfig[2]
                local targetMobs = materialConfig[3]
                local questInfo = materialConfig[4]

                if SeaIndex ~= targetSea then
                    alert("Godhuman Material", "Traveling to Sea " .. targetSea .. " for " .. neededMaterial)
                    SetTask("MainTask", "Sea Travel | Godhuman | Traveling to Sea " .. targetSea)
                    Remotes.CommF_:InvokeServer("Travel" .. SeaIndexes[targetSea])
                    return
                end

                SetTask("MainTask", "Godhuman | Farming " .. neededMaterial .. " | In Progress")
                if playerLevel >= questInfo[3] then
                    local claimMob, claimTitle = GetCurrentClaimQuest()
                    if claimMob then
                        if
                            not string.find(claimTitle, targetMobs[1])
                            and not string.find(claimTitle, targetMobs[2] or targetMobs[1])
                        then
                            QuestManager.AbandonQuest()
                        else
                            CombatController.Attack(targetMobs)
                            return
                        end
                    else
                        local npcInstance = ScriptStorage.NPCs[questInfo[4]]
                        local npcPos = npcInstance and npcInstance:GetModelCFrame()
                        if npcPos then
                            TweenController.Create(npcPos + Vector3.new(0, 5, 3))
                            if CalculateDistance(npcPos) < 10 then
                                task.wait(1)
                            else
                                return
                            end
                        else
                            Report(
                                "Không tìm thấy NPC " .. tostring(questInfo[4]) .. " trên bản đồ!",
                                "CẢNH BÁO NPC"
                            )
                        end
                        QuestManager.StartQuest(questInfo[1], questInfo[2])
                        return
                    end
                end
                CombatController.Attack(targetMobs)
            end
            Remotes.CommF_:InvokeServer("BuyGodhuman", true)
            Remotes.CommF_:InvokeServer("BuyGodhuman")
            GodHumanFlag = false
            return true
        end
        if os.time() - LastTravel > 60 then
            LastTravel = os.time()
            if playerLevel >= 1500 and SeaIndex == 2 then
                local shouldWaitDarkFragments = Config.Settings.StayInSea2UntilHaveDarkFragments
                    and not ScriptStorage.Backpack["Dark Fragment"]
                if not shouldWaitDarkFragments then
                    local libraryDoor = Services.Workspace.Map.IceCastle.Hall.LibraryDoor
                    if not (libraryDoor and libraryDoor:FindFirstChild("PhoeyuDoor")) then
                        Remotes.CommF_:InvokeServer("TravelZou")
                        SetTask("MainTask", "Sea Travel | Teleporting to Third Sea")
                    end
                end
            elseif playerLevel >= 700 and SeaIndex == 1 then
                SetTask("MainTask", "Sea Travel | Teleporting to Second Sea")
                Remotes.CommF_:InvokeServer("TravelDressrosa")
            end
        end
        if ScriptStorage.Tools["God's Chalice"] and not ScriptStorage.Tools["Mirror Fractal"] then
            if (ScriptStorage.Backpack["Conjured Cocoa"] or { Count = 0 }).Count < 10 then
                SetTask("MainTask", "Material Farming | Conjured Cocoa | Farming (Need 10x)")
                CombatController.Attack({ "Cocoa Warrior", "Chocolate Bar Battler" })
                return
            end
            Remotes.CommF_:InvokeServer("SweetChaliceNpc")
        end
        if
            ScriptStorage.Tools["Sweet Chalice"]
            or (
                playerLevel == MaxLevel
                and (ScriptStorage.Backpack.Bones and ScriptStorage.Backpack.Bones.Count or 0) >= 500
            )
        then
            SetTask("MainTask", "Fragments Farming | Cake Prince & Dough King")
            if
                ScriptStorage.Tools["Sweet Chalice"]
                and (not lastCakePrinceSpawn or os.time() - lastCakePrinceSpawn > 10)
            then
                task.spawn(function()
                    while
                        not ScriptStorage.Enemies["Dough King"]
                        and task.wait()
                        and ScriptStorage.Tools["Sweet Chalice"]
                    do
                        lastCakePrinceSpawn = os.time()
                        Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                    end
                end)
            end
            CombatController.Attack({ "Head Baker", "Baking Staff", "Cookie Crafter", "Cake Guard" })
            if playerLevel >= 2200 then
                local activeMob, questTitle = GetCurrentClaimQuest()
                if activeMob then
                    if not string.find(tostring(questTitle or ""), "Cookie") then
                        QuestManager.AbandonQuest()
                    else
                        Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                        return
                    end
                else
                    DebugLog("Start Cake Quest")
                    local cakeNpc = ScriptStorage.NPCs["Cake Quest Giver 1"]
                    local cakeNpcCFrame = cakeNpc and cakeNpc:GetModelCFrame()
                    if cakeNpcCFrame then
                        TweenController.Create(cakeNpcCFrame + Vector3.new(0, 5, 3))
                        if CalculateDistance(cakeNpcCFrame) < 10 then
                            task.wait(1)
                        else
                            return
                        end
                    else
                        Report("Không tìm thấy NPC Cake Quest Giver 1 tại Đảo Bánh!", "CẢNH BÁO NPC")
                    end
                    QuestManager.StartQuest("CakeQuest1", 1)
                    return
                end
            end
            DebugLog("attack ohoo")
            return
        end
        local shouldFarmBones = playerLevel >= 2025
            and (safe_getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost == 0 or playerLevel <= MaxLevel)
            and (ScriptStorage.Backpack.Bones and ScriptStorage.Backpack.Bones.Count or 0) < 500

        if shouldFarmBones then
            SetTask("MainTask", "Bones Farming | Haunted Castle | For 2x EXP/Beli")
            local bonesMobs = { "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy" }
            local activeBonesQuest = GetCurrentClaimQuest(true)
            if activeBonesQuest then
                local matchesBonesQuest = false
                for _, mobName in ipairs(bonesMobs) do
                    if string.find(activeBonesQuest, mobName) then
                        matchesBonesQuest = true
                        break
                    end
                end
                if not matchesBonesQuest then
                    QuestManager.AbandonQuest()
                    return
                else
                    SetTask("SubTask", "Bones Quest | Farming | " .. activeBonesQuest)
                    CombatController.Attack(bonesMobs)
                    return
                end
            else
                DebugLog("StartQuest Bones", activeBonesQuest)
                local hauntedCastlePos = CFrame.new(-9516.99316, 172.01718, 6078.46533)
                local hauntedNpc = ScriptStorage.NPCs["Haunted Castle Quest Giver 2"]
                    or workspace.NPCs:FindFirstChild("Haunted Castle Quest Giver 2")
                    or game.ReplicatedStorage.NPCs:FindFirstChild("Haunted Castle Quest Giver 2")

                if not hauntedNpc and CalculateDistance(hauntedCastlePos) > 50 then
                    SetTask("SubTask", "Bones Quest | Traveling | Haunted Castle Area")
                    TweenController.Create(hauntedCastlePos)
                    return
                end

                hauntedNpc = hauntedNpc
                    or workspace.NPCs:WaitForChild("Haunted Castle Quest Giver 2", 5)
                    or game.ReplicatedStorage.NPCs:WaitForChild("Haunted Castle Quest Giver 2", 5)
                local hauntedNpcCFrame = hauntedNpc and hauntedNpc:GetModelCFrame()

                if hauntedNpcCFrame then
                    TweenController.Create(hauntedNpcCFrame + Vector3.new(0, 5, 3))
                    if CalculateDistance(hauntedNpcCFrame) < 20 then
                        task.wait(1)
                        if not (HauntedQuest2Debounce and os.time() - HauntedQuest2Debounce < 5) then
                            HauntedQuest2Debounce = os.time()
                            local questResult = QuestManager.StartQuest("HauntedQuest2", 1)
                            DebugLog("HauntedQuest2 StartQuest result:", questResult)
                        end
                    else
                        return
                    end
                else
                    if
                        not (HauntedQuest2NotFoundWarnDebounce and os.time() - HauntedQuest2NotFoundWarnDebounce < 15)
                    then
                        HauntedQuest2NotFoundWarnDebounce = os.time()
                        Report(
                            "Không tìm thấy NPC Haunted Quest Giver 2 tại Lâu Đài Bóng Đêm!",
                            "CẢNH BÁO NPC"
                        )
                    end
                end
                return
            end
        end
        if farmMode == 1 then
            SetTask("MainTask", "Level Farming | Skip Mode | Sky Bandit")
            local skyBanditPos = Vector3.new(-4835, 718, -2618)
            if CalculateDistance(skyBanditPos) > 150 then
                TweenController.Create(CFrame.new(skyBanditPos + Vector3.new(0, 35, 0)))
            end
            CombatController.Attack("Sky Bandit")
        elseif farmMode == 2 then
            SetTask("MainTask", "Level Farming | Skip Mode | God's Guard")
            local godsGuardPos = Vector3.new(-4720, 845, -1950)
            if CalculateDistance(godsGuardPos) > 150 then
                TweenController.Create(CFrame.new(godsGuardPos + Vector3.new(0, 35, 0)))
            end
            CombatController.Attack("God's Guard")
        elseif farmMode == 4 then
            local _, questNpcPos, questId, questStep, targetName = QuestManager:GetCurrentQuest()
            local claimedQuestMob = GetCurrentClaimQuest()
            if claimedQuestMob then
                if claimedQuestMob ~= targetName and claimedQuestMob ~= (targetName .. "s") then
                    return QuestManager.AbandonQuest()
                end
            else
                if not questNpcPos then
                    return QuestManager:RefreshQuest()
                        and Report(
                            "Lỗi không xác định được tọa độ NPC nhận nhiệm vụ cấp độ hiện tại!",
                            "LỖI NHIỆM VỤ"
                        )
                end
                TweenController.Create(questNpcPos + Vector3.new(0, 5, 3))
                SetTask("MainTask", "Level Farming | " .. targetName .. " | Claiming Quest")
                if CalculateDistance(questNpcPos) > 20 then
                    return
                end
                levelFarmStuckTimer = 0
                QuestManager.StartQuest(questId, questStep)
                task.wait(0.3)
            end
            SetTask("MainTask", "Level Farming | " .. targetName .. " | Defeating Enemies")
            local fightStartTime = os.time()
            CombatController.Attack(targetName)
            LevelFarmTTL = LevelFarmTTL + os.time() - fightStartTime
            if LevelFarmTTL > 160 then
                Hop("Level farm stuck too long")
            end
        end
    end)
    FunctionsHandler.LocalPlayerController:RegisterMethod("EquipTool", function(toolName)
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then
            return
        end
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then
            return
        end
        for _, item in ipairs(bp:GetChildren()) do
            if
                item:IsA("Tool")
                and item.Name ~= "Tool"
                and (item.Name == tostring(toolName) or item.ToolTip == toolName)
            then
                hum:EquipTool(item)
            end
        end
    end)
    FunctionsHandler.LocalPlayerController:RegisterMethod("ToggleAbilities", function(ability, enabled)
        if ability == "Buso" then
            local char = LocalPlayer.Character
            local hasBuso = char and char:FindFirstChild("HasBuso")
            if enabled and not hasBuso then
                Remotes.CommF_:InvokeServer("Buso")
            elseif not enabled and hasBuso then
                Remotes.CommF_:InvokeServer("Buso")
            end
        elseif ability == "Observation" then
            return
        end
    end)
    FunctionsHandler.LocalPlayerController:RegisterMethod("ConfigurationAbilitiesToggle", function()
        FunctionsHandler.LocalPlayerController.Methods.ToggleAbilities:Call("Buso", true)
    end)
    FunctionsHandler.Saber:RegisterMethod("Refresh", function()
        if not Config.Items.Saber then
            return
        end
        local step
        if ScriptStorage.Backpack.Saber then
            return
        end
        if ScriptStorage.PlayerData.Level < 200 then
            return
        end
        local progress = Remotes.CommF_:InvokeServer("ProQuestProgress")
        for _, plateDone in progress.Plates do
            if plateDone == false then
                step = 1
            end
        end
        if not step then
            if not progress.UsedTorch then
                step = 2
            elseif not progress.UsedCup then
                step = 3
            elseif not progress.TalkedSon then
                step = 4
            elseif not progress.KilledMob then
                step = 5
            elseif not progress.UsedRelic then
                step = 6
            elseif not progress.KilledShanks and ScriptStorage.Enemies["Saber Expert"] then
                step = 7
            end
        end
        FunctionsHandler.Saber:Set("CurrentProgressLevel", step)
        FunctionsHandler.Saber:Set("LastestRefreshSenque", os.time())
        return step
    end)
    FunctionsHandler.Saber:RegisterMethod("GetQuestplates", function()
        local cachedPlates = FunctionsHandler.Saber:Get("QuestplatesCache")
        if cachedPlates then
            return cachedPlates
        end
        local jungleMap = Services.Workspace.Map.Jungle
        local plates = {}
        table.foreach(jungleMap.QuestPlates:GetChildren(), function(_, child)
            _ = child:FindFirstChild("Button") and table.insert(plates, child)
        end)
        FunctionsHandler.Saber:Get("QuestplatesCache", plates)
        return plates
    end)
    FunctionsHandler.Saber:RegisterMethod("Start", function()
        local step, lastRefresh =
            FunctionsHandler.Saber:Get("CurrentProgressLevel"), FunctionsHandler.Saber:Get("LastestRefreshSenque")
        DebugLog("[ Debug ] Saber quest indexes", step)
        if not step then
            FunctionsHandler.Saber.Methods.Refresh:Call()
            return FunctionsHandler.Saber.Methods.Start:Call()
        elseif step == 0 then
            return
        elseif os.time() - lastRefresh > 60 then
            FunctionsHandler.Saber.Methods.Refresh:Call()
            return FunctionsHandler.Saber.Methods.Start:Call()
        else
            if step == 1 then
                local plates = FunctionsHandler.Saber.Methods.GetQuestplates:Call()
                for idx, plate in plates do
                    SetTask("MainTask", "Saber Quest | Quest Plates | Touching " .. idx .. "/5")
                    while CaculateDistance(plate.Button.CFrame) > 20 do
                        task.wait()
                        TweenController.Create(plate.Button.CFrame)
                    end
                    task.wait(1)
                end
            elseif step == 2 then
                SetTask("MainTask", "Saber Quest | Torch Puzzle | Using Torch")
                Remotes.CommF_:InvokeServer("ProQuestProgress", "GetTorch")
                task.wait(1)
                Remotes.CommF_:InvokeServer("ProQuestProgress", "DestroyTorch")
            elseif step == 3 then
                SetTask("MainTask", "Saber Quest | Sick Man | Helping with Cup")
                Remotes.CommF_:InvokeServer("ProQuestProgress", "GetCup")
                if ScriptStorage.Tools.Cup then
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Cup")
                    task.wait(1)
                    Remotes.CommF_:InvokeServer("ProQuestProgress", "FillCup", LocalPlayer.Character.Cup)
                end
                Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan")
            elseif step == 4 then
                SetTask("MainTask", "Saber Quest | Rich Son | Getting Information")
                Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
            elseif step == 5 then
                SetTask("MainTask", "Saber Quest | Mob Leader | Defeating Boss")
                CombatController.Attack("Mob Leader")
            elseif step == 6 then
                SetTask("MainTask", "Saber Quest | Relic | Placing at Location")
                Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
            elseif step == 7 then
                SetTask("MainTask", "Saber Quest | Saber Expert | Final Battle")
                CombatController.Attack("Saber Expert")
            end
        end
    end)
    Remotes.RefreshQuestPro.OnClientEvent:Connect(FunctionsHandler.Saber.Methods.Refresh.Callback)
    MeleeLastCursor = 1
    FirstCall = true
    CanPurchase = {}
    FunctionsHandler.MeleesController:RegisterMethod("Start", function()
        for meleeIdx, meleeName in MeleesTable do
            if meleeName ~= "SanguineArt" then
                if not Config.Items.AutoFullyMelees then
                    break
                end
                Data = MeleePrices[meleeName]
                if not Data then
                    DebugLog("no melee data for", meleeName)
                    break
                end
                local canPurchase = CanPurchase[meleeName]
                if not canPurchase then
                    CanPurchase[meleeName] = Data.Buy(1)
                    canPurchase = CanPurchase[meleeName]
                    DebugLog("CanBuy", meleeName, canPurchase)
                end
                if meleeName == "Dragon Talon" then
                    IsFireEssenceGave = (function()
                        if IsFireEssenceGave ~= nil then
                            return IsFireEssenceGave
                        end
                        local buyResult = Remotes.CommF_:InvokeServer("BuyDragonTalon", true)
                        alert("Dragon Talon", "Purchase status: " .. tostring(typeof(buyResult) ~= "string"))
                        return typeof(buyResult) ~= "string" and true or false
                    end)()
                    DebugLog("IsFireEssenceGave", IsFireEssenceGave)
                    if not IsFireEssenceGave then
                        DebugLog("no fire essence provided")
                        break
                    end
                end
                if meleeName == "Godhuman" and not GodHumanFlag then
                    if (ScriptStorage.Melees["Dragon Talon"] or 0) > 399 then
                        if not ScriptStorage.Melees.Godhuman then
                            Remotes.CommF_:InvokeServer("BuyGodhuman", true)
                            Remotes.CommF_:InvokeServer("BuyGodhuman")
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Melee")
                            if not ScriptStorage.Melees.Godhuman then
                                GodHumanFlag = true
                                return
                            end
                        end
                    end
                end
                if
                    not ScriptStorage.Melees[meleeName]
                    or (ScriptStorage.Melees[meleeName] or 0) < Data.NextLevelRequirement
                then
                    local meleeId = GetMeleeIdByName(meleeName)
                    local playerData = ScriptStorage.PlayerData
                    local canAfford = true
                    if not meleeId then
                        return DebugLog("[ Debug ] Failed to get melee id of", meleeName)
                    end
                    MSet = false
                    if not canPurchase then
                        for currencyName, requiredAmount in Data.Price do
                            if playerData[currencyName] < requiredAmount and not FirstCall then
                                if not ScriptStorage.Melees[meleeName] then
                                    MSet = true
                                    SetTask(
                                        "SubTask",
                                        "Melee Purchase | "
                                            .. meleeName
                                            .. " | Need "
                                            .. currencyName
                                            .. " ("
                                            .. tostring(requiredAmount)
                                            .. ")"
                                    )
                                end
                                return
                            end
                        end
                    end
                    if
                        not MSet
                        and ScriptStorage.Melees[meleeName]
                        and ScriptStorage.Melees[meleeName] < Data.NextLevelRequirement
                    then
                        SetTask(
                            "SubTask",
                            "Melee Mastery | "
                                .. meleeName
                                .. " | "
                                .. tostring(ScriptStorage.Melees[meleeName] or 0)
                                .. "/"
                                .. tostring(Data.NextLevelRequirement)
                        )
                        if not ScriptStorage.Tools[meleeName] then
                            DebugLog("no m1 found, buy")
                            Data.Buy()
                        end
                        return
                    end
                    if not FirstCall then
                        if canAfford and Data.Requirements() and not ScriptStorage.Tools[meleeName] then
                            if meleeName == "Dragon Talon" and not IsFireEssenceGave then
                                alert("Dragon Talon", "Fire Essence status: " .. tostring(IsFireEssenceGave))
                                return SetTask("SubTask", "Dragon Talon | Waiting for Fire Essence from Bones")
                            end
                            Data.Buy()
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Melee")
                            if not ScriptStorage.Tools[meleeName] then
                                task.wait()
                                if not ScriptStorage.Tools[meleeName] then
                                    if
                                        (meleeName == "Death Step" or meleeName == "Sharkman Karate")
                                        and SeaIndex ~= 2
                                    then
                                        alert("Sea Travel", "Returning to Sea 2 for Water Key / Library Key")
                                        Remotes.CommF_:InvokeServer("TravelDressrosa")
                                    end
                                else
                                    MeleeLastCursor = meleeIdx + 1
                                    return
                                end
                            else
                                MeleeLastCursor = meleeIdx + 1
                                return
                            end
                        end
                    elseif not FirstCall then
                        MeleeLastCursor = meleeIdx + 1
                    end
                end
            end
        end
        if FirstCall then
            FirstCall = false
            return
        end
        FarmingItem = nil
        for _, item in ScriptStorage.Backpack do
            if item.Type == "Sword" then
                if item.Name == "Yama" or item.Name == "Tushita" then
                    MasteryRequirement = 350
                else
                    for _, reqValue in item.MasteryRequirements do
                        MasteryRequirement = reqValue
                    end
                end
                if item.Mastery < MasteryRequirement then
                    if item.Name == "Yama" or item.Name == "Tushita" then
                        FarmingItem = { item.Name, item.Mastery, MasteryRequirement }
                        break
                    end
                end
            end
        end
        if FarmingItem then
            SetTask("SubTask", "Sword Mastery | " .. FarmingItem[1] .. " | " .. FarmingItem[2] .. "/" .. FarmingItem[3])
            if not ScriptStorage.Tools[FarmingItem[1]] then
                Remotes.CommF_:InvokeServer("LoadItem", FarmingItem[1])
            end
            ScriptStorage.ForceToUseSword = FarmingItem
        end
    end)
    FunctionsHandler.SecondSeaPuzzle:RegisterMethod("Refresh", function()
        if ScriptStorage.PlayerData.Level < 700 or SeaIndex ~= 1 then
            return
        end
        if FunctionsHandler.SecondSeaPuzzle:Get("IsCompleted") then
            return
        end
        local progress = Remotes.CommF_:InvokeServer("DressrosaQuestProgress")
        DebugLog("TalkedDetective", progress.TalkedDetective, "KilledIceBoss", progress.KilledIceBoss)
        local puzzleStep = nil
        if not progress.TalkedDetective then
            puzzleStep = 1
        elseif not progress.KilledIceBoss then
            puzzleStep = 2
        else
            FunctionsHandler.SecondSeaPuzzle:Set("IsCompleted", true)
        end
        FunctionsHandler.SecondSeaPuzzle:Set("CurrentProgressLevel", puzzleStep)
        FunctionsHandler.SecondSeaPuzzle:Set("LastestRefreshSenque", os.time())
        return puzzleStep
    end)
    FunctionsHandler.SecondSeaPuzzle:RegisterMethod("Start", function()
        local step = FunctionsHandler.SecondSeaPuzzle:Get("CurrentProgressLevel")
        FunctionsHandler.SecondSeaPuzzle:Set("CurrentProgressLevel", nil)
        if not step then
            FunctionsHandler.SecondSeaPuzzle.Methods.Refresh:Call()
            return FunctionsHandler.SecondSeaPuzzle.Methods.Start:Call()
        elseif step == 1 then
            SetTask("MainTask", "Second Sea Quest | Detective | Talking to NPC")
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Key")
            TweenController.Create(CFrame.new(1347.7124, 37.3751602, -1325.6488))
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            task.wait(1)
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "UseKey")
        elseif step == 2 then
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            task.wait(1)
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "UseKey")
            SetTask("MainTask", "Second Sea Quest | Ice Admiral | Defeating Boss")
            local iceAdmiral = Services.Workspace.Enemies:FindFirstChild("Ice Admiral")
            if iceAdmiral and iceAdmiral:FindFirstChild("Humanoid") and iceAdmiral.Humanoid.Health > 0 then
                while
                    iceAdmiral.Parent
                    and iceAdmiral:FindFirstChild("Humanoid")
                    and iceAdmiral.Humanoid.Health > 0
                    and not _G.Stop
                do
                    local root = iceAdmiral:FindFirstChild("HumanoidRootPart")
                    if not root then
                        break
                    end
                    TweenController.Create(root.CFrame + Vector3.new(0, 35, 0))
                    if CaculateDistance(root.Position) < 150 then
                        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(
                            ScriptStorage.ForceToUseSword and "Sword" or "Melee"
                        )
                        AttackModule:Attack(iceAdmiral)
                    end
                    task.wait()
                end
                Remotes.CommF_:InvokeServer("TravelDressrosa")
            else
                TweenController.Create(CFrame.new(1347.7124, 37.3751602, -1325.6488))
            end
        end
    end)
    FunctionsHandler.ColosseumPuzzle:RegisterMethod("Refresh", function()
        if SeaIndex ~= 2 then
            return
        end
        if ScriptStorage.PlayerData.Level < 850 or ScriptStorage.Backpack["Warrior Helmet"] then
            return
        end
        local progress = Remotes.CommF_:InvokeServer("BartiloQuestProgress")
        local colosseumStep = nil
        if not progress.KilledBandits then
            colosseumStep = 1
        elseif not progress.KilledSpring then
            if ScriptStorage.Enemies.Jeremy then
                colosseumStep = 2
            end
        elseif not progress.DidPlates then
            colosseumStep = 3
        end
        FunctionsHandler.ColosseumPuzzle:Set("CurrentProgressLevel", colosseumStep)
        FunctionsHandler.ColosseumPuzzle:Set("LastestRefreshSenque", os.time())
        return colosseumStep
    end)
    FunctionsHandler.ColosseumPuzzle:RegisterMethod("Start", function()
        local step = FunctionsHandler.ColosseumPuzzle:Get("CurrentProgressLevel")
        FunctionsHandler.ColosseumPuzzle:Set("CurrentProgressLevel", nil)
        DebugLog("Progress", step)
        if not step then
            FunctionsHandler.ColosseumPuzzle.Methods.Refresh:Call()
            return FunctionsHandler.ColosseumPuzzle.Methods.Start:Call()
        elseif step == 1 then
            SetTask("MainTask", "Bartilo Quest | Swan Pirates | Defeating 50x Enemies")
            local hasActiveQuest, questTitleText = QuestManager:GetCurrentClaimQuest()
            if hasActiveQuest then
                if not string.find(questTitleText, "50") then
                    QuestManager.AbandonQuest()
                else
                    CombatController.Attack("Swan Pirate")
                end
            else
                QuestManager.StartQuest("BartiloQuest", 1)
            end
        elseif step == 2 then
            SetTask("MainTask", "Bartilo Quest | Jeremy | Defeating Boss")
            CombatController.Attack("Jeremy")
        elseif step == 3 then
            SetTask("MainTask", "Bartilo Quest | Colosseum | Solving Riddle")
            local puzzleEntryCFrame = CFrame.new(
                -1837.46155,
                44.2921753,
                1656.1987,
                0.999881566,
                -1.03885048e-22,
                -0.0153914848,
                1.07805858e-22,
                1,
                2.53909284e-22,
                0.0153914848,
                -2.55538502e-22,
                0.999881566
            )
            if CaculateDistance(puzzleEntryCFrame) > 10 then
                alert("Bartilo Quest", "Moving to puzzle location...")
                TweenController.Create(puzzleEntryCFrame)
            else
                LocalPlayer = game.Players.LocalPlayer
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1836.0, 11, 1714)
                task.wait(0.5)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1850.49329, 13.1789551, 1750.89685)
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.87305, 19.3777466, 1712.01807)
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1803.94324, 16.5789185, 1750.89685)
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.55835, 16.8604317, 1724.79541)
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1869.54224, 15.987854, 1681.00659)
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1800.0979, 16.4978027, 1684.52368)
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1819.26343, 14.795166, 1717.90625)
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1813.51843, 14.8604736, 1724.79541)
            end
        end
    end)
    FunctionsHandler.EvoRace:RegisterMethod("Refresh", function()
        if not Config.Items.RaceV2 then
            return
        end
        if SeaIndex ~= 2 then
            return
        end
        local notEligible = safe_getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost ~= 0
            or ScriptStorage.PlayerData.Level < 900
            or ScriptStorage.PlayerData.Beli < 1000000
            or ScriptStorage.PlayerData.RaceLevel ~= 1
        if notEligible then
            return
        end
        return true
    end)
    FunctionsHandler.EvoRace:RegisterMethod("Start", function()
        Remotes.CommF_:InvokeServer("Alchemist", "1")
        Remotes.CommF_:InvokeServer("Alchemist", "2")
        for flowerIdx = 1, 2, 1 do
            local ownedFlower = ScriptStorage.Tools["Flower " .. flowerIdx]
            local flowerSpot = Services.Workspace:FindFirstChild("Flower" .. flowerIdx)
            if not ownedFlower then
                if flowerSpot and flowerSpot.Transparency == 0 then
                    SetTask("MainTask", "Race V2 | Flower " .. flowerIdx .. " | Collecting Flower")
                    while not ScriptStorage.Tools["Flower " .. flowerIdx] do
                        task.wait()
                        TweenController.Create(flowerSpot.CFrame + Vector3.new(0, math.random(-1.0, 2), 0))
                    end
                end
            end
        end
        if not ScriptStorage.Tools["Flower 3"] then
            SetTask("MainTask", "Race V2 | Flower 3 | Defeating Swan Pirates")
            CombatController.Attack("Swan Pirate")
        else
            SetTask("MainTask", "Race V2 | Completed | Idling")
            if LocalPlayer.Character.HumanoidRootPart.CFrame.Y < 50000 then
                TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 50, 0))
            end
            Remotes.CommF_:InvokeServer("Alchemist", "3")
            RefreshRace()
        end
    end)
    FunctionsHandler.BossesTask:RegisterMethod("Refresh", function()
        local foundBoss
        for _, bossName in BossesOrder do
            local requiredLevel = BossesOrderLevel[bossName]
            if ScriptStorage.PlayerData.Level >= requiredLevel then
                local bossInstance = ScriptStorage.Enemies[bossName]
                if bossInstance and bossInstance:FindFirstChild("Humanoid") and bossInstance.Humanoid.Health > 0 then
                    foundBoss = bossInstance
                end
            end
        end
        local closeEnough = foundBoss
            and (
                CaculateDistance(foundBoss.HumanoidRootPart.CFrame) < (SeaIndex == 2 and 3000 or 5000)
                or BossesOrderWL[tostring(foundBoss)]
                or ScriptStorage.PlayerData.Level == MaxLevel
            )
        if closeEnough then
            return foundBoss
        end
    end)
    FunctionsHandler.BossesTask:RegisterMethod("Start", function(boss)
        if boss then
            local bossName = boss.Name
            SetTask("MainTask", "Boss Hunter | " .. bossName .. " | Defeating for Item Drop")
            alert("Boss Hunter", "Hunting Boss: " .. bossName .. " for item drop!")
            CombatController.Attack(tostring(bossName), nil, nil, function()
                SpecialItems = nil
            end)
            SpecialItems = nil
            task.wait(1)
            pcall(RefreshInventory)
        end
    end)
    FunctionsHandler.SpecialBossesTask:RegisterMethod("Refresh", function()
        local foundBoss
        for bossName, requiredLevel in SpecialBossesOrder do
            if ScriptStorage.PlayerData.Level >= requiredLevel then
                local bossInstance = ScriptStorage.Enemies[bossName]
                if bossInstance and bossInstance:FindFirstChild("Humanoid") and bossInstance.Humanoid.Health > 0 then
                    foundBoss = bossInstance
                end
            end
        end
        return foundBoss
    end)
    FunctionsHandler.SpecialBossesTask:RegisterMethod("Start", function(boss)
        if FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
            pcall(function()
                LocalPlayer.Character.Humanoid.Health = 0
            end)
        end
        if boss then
            SetTask("MainTask", "Boss Hunter | " .. boss.Name .. " | Defeating Boss")
            CombatController.Attack(tostring(boss))
        end
    end)
    FunctionsHandler.RaidController:RegisterMethod("RefreshRaidType", function()
        for _, raidName in require(game.ReplicatedStorage.Raids).raids do
            if string.find(ScriptStorage.PlayerData.DevilFruit, raidName) then
                FunctionsHandler.RaidController:Set("CurrentChip", raidName)
                return
            end
        end
        FunctionsHandler.RaidController:Set("CurrentChip", "Flame")
    end)
    FunctionsHandler.RaidController:RegisterMethod("GetRaidableFruit", function()
        for _, item in ScriptStorage.Backpack do
            if string.find(FruitIdToName(item.Name), " Fruit") then
                if item.Value and item.Value < 1000000 then
                    return item
                end
            end
        end
    end)
    FunctionsHandler.RaidController:RegisterMethod("GetCurrentRaidIsland", function()
        local islandsList = { {}, {}, {}, {}, {} }
        local locationsFolder = workspace:FindFirstChild("_WorldOrigin")
            and workspace._WorldOrigin:FindFirstChild("Locations")
        if locationsFolder then
            for _, locationPart in ipairs(locationsFolder:GetChildren()) do
                if
                    string.find(locationPart.Name, "Island ")
                    and CalculateDistance(locationPart.Position, Vector3.new(0, 0, 0)) > 7000
                then
                    local islandNumStr = string.gsub(locationPart.Name, "Island ", "")
                    local islandNum = tonumber(islandNumStr)
                    if islandNum and islandsList[islandNum] then
                        table.insert(islandsList[islandNum], locationPart)
                    end
                end
            end
        end
        for islandIdx = 5, 1, -1 do
            for _, candidateIsland in ipairs(islandsList[islandIdx]) do
                if CalculateDistance(candidateIsland.Position) < 2000 then
                    return candidateIsland
                end
            end
        end
        return nil
    end)
    function CheckSpecialMicrochip()
        local character = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if character then
            local microchip = character:FindFirstChild("Special Microchip")
            if microchip then
                return microchip
            end
        end
        if backpack then
            local microchip = backpack:FindFirstChild("Special Microchip")
            if microchip then
                return microchip
            end
        end
        return nil
    end
    FunctionsHandler.RaidController:RegisterMethod("Refresh", function()
        local level = ScriptStorage.PlayerData.Level
        local fragments = ScriptStorage.PlayerData.Fragments
        if level < 1300 or SeaIndex == 1 then
            return
        end
        if level < 1500 and fragments > 2000 then
            return
        end
        if level < MaxLevel then
            if fragments > 5000 then
                return
            end
        else
            if fragments > 10000 then
                return
            end
        end
        local raidableFruit = FunctionsHandler.RaidController.Methods.GetRaidableFruit:Call()
        if raidableFruit then
            FunctionsHandler.RaidController:Set("CurrentProgressLevel", raidableFruit)
        end
        return raidableFruit
            or FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
            or CheckSpecialMicrochip()
    end)
    FunctionsHandler.RaidController:RegisterMethod("Start", function()
        if not FunctionsHandler.RaidController:Get("CurrentChip") then
            FunctionsHandler.RaidController.Methods.RefreshRaidType:Call()
        end
        local raidIslandLocation = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        RefreshInventory()
        FunctionsHandler.RaidController:Set("CurrentProgressLevel", nil)
        if not raidIslandLocation then
            if SeaIndex == 2 then
                SetTask("MainTask", "Auto Raid | Circle Island | Traveling to Island")
                TweenController.Create(CFrame.new(-6438.73535, 250.645355, -4501.50684))
                task.wait(1)
            elseif SeaIndex == 3 then
                SetTask("MainTask", "Auto Raid | Boat Castle | Entering Castle")
                pcall(function()
                    Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5097.93164, 316.447021, -3142.66602))
                end)
                task.wait(0.5)
                SetTask("MainTask", "Auto Raid | Boat Castle | Traveling to Station")
                TweenController.Create(CFrame.new(-5033.50879, 315.014252, -2947.77539))
                task.wait(1)
            else
                task.wait(1)
                game.Players.LocalPlayer:Kick("Rejoining..")
                return
            end
            local islandName = (SeaIndex == 2) and "CircleIsland" or "Boat Castle"
            local raidIsland = workspace.Map:FindFirstChild(islandName) or workspace:FindFirstChild(islandName)
            local raidSummon = raidIsland and raidIsland:FindFirstChild("RaidSummon2")
            local summonBtn = raidSummon
                and raidSummon:FindFirstChild("Button")
                and raidSummon.Button:FindFirstChild("Main")
            if summonBtn then
                SetTask("MainTask", "Auto Raid | Buying Chip | " .. FunctionsHandler.RaidController:Get("CurrentChip"))
                if not ScriptStorage.Tools["Special Microchip"] then
                    local raidableFruit = FunctionsHandler.RaidController.Methods.GetRaidableFruit:Call()
                    if raidableFruit then
                        table.insert(ScriptStorage.IgnoreStoreFruits, raidableFruit.Name)
                        alert("Auto Raid", "Loading fruit: " .. raidableFruit.Name)
                        Remotes.CommF_:InvokeServer("LoadFruit", raidableFruit.Name)
                        Remotes.CommF_:InvokeServer(
                            "RaidsNpc",
                            "Select",
                            FunctionsHandler.RaidController:Get("CurrentChip")
                        )
                        task.wait(2)
                    end
                end
                FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Special Microchip")
                task.wait(0.3)
                SetTask("MainTask", "Auto Raid | Starting | Activating Summon Button")
                if summonBtn:FindFirstChild("ClickDetector") then
                    fireclickdetector(summonBtn.ClickDetector)
                elseif summonBtn:FindFirstChild("ProximityPrompt") then
                    fireproximityprompt(summonBtn.ProximityPrompt)
                else
                    Report(
                        "Nút bấm triệu hồi Raid trên đảo "
                            .. islandName
                            .. " bị thiếu bộ kích hoạt Click/Prompt!",
                        "LỖI RAID"
                    )
                end
            else
                Report(
                    "Không tìm thấy nút bấm bệ triệu hồi Raid trên đảo " .. islandName .. "!",
                    "LỖI RAID"
                )
            end
            local waitStartTime = os.time()
            SetTask("MainTask", "Auto Raid | Waiting | Waiting for Raid to Start")
            repeat
                task.wait()
            until os.time() - (LastRaidAlert2 or 0) < 20 or os.time() - waitStartTime > 30
            TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
            repeat
                task.wait()
            until os.time() - (LastRaidAlert or 0) < 20 or os.time() - waitStartTime > 30
            alert("Auto Raid", "Arrived at raid station")
            task.wait(0.5)
            if os.time() - waitStartTime > 30 then
                game.Players.LocalPlayer:Kick("Rejoining..")
                SetTask("MainTask", "Auto Raid | Timeout | Raid Did Not Start")
                Report("Hết thời gian chờ Raid bắt đầu (quá 30 giây), hủy lượt!", "LỖI RAID")
            end
            LastRaidAlert = 0
        else
            SetTask("MainTask", "Auto Raid | " .. raidIslandLocation.Name .. " | Wave Progress")
            local attackedAny = false
            for _, enemy in GetMonAsSortedRange() do
                local fightStartTime = os.time()
                while
                    enemy
                    and enemy:FindFirstChild("HumanoidRootPart")
                    and enemy.Humanoid.Health > 0
                    and CaculateDistance(enemy.HumanoidRootPart.Position) < 1000
                    and os.time() - fightStartTime < 60
                    and task.wait(0.05)
                do
                    attackedAny = true
                    if string.find(enemy.Name, "Master") or true then
                        CombatController.Attack(enemy.Name)
                    else
                        pcall(sethiddenproperty, LocalPlayer, "SimulationRadius", math.huge)
                        pcall(function()
                            enemy.HumanoidRootPart.CanCollide = false
                            enemy.Humanoid.Health = 0
                            enemy:BreakJoints()
                        end)
                    end
                end
            end
            if not attackedAny then
                TweenController.Create(raidIslandLocation.Position + Vector3.new(0, 100, 0))
            end
        end
    end)
    FunctionsHandler.CollectDrops:RegisterMethod("Refresh", function()
        local ownedFruits = {}
        for fruit in ScriptStorage.Backpack do
            ownedFruits[FruitIdToName(fruit)] = fruit
        end
        for _, fruit in workspace:GetChildren() do
            local isDroppedFruit = string.find(fruit.Name, "Fruit")
                and not LocalPlayer.Backpack:FindFirstChild(fruit.Name)
                and fruit:FindFirstChild("Handle")
                and not ownedFruits[tostring(fruit)]
                and not ScriptStorage.Backpack[FruitNameToId(tostring(fruit))]
            if isDroppedFruit then
                FunctionsHandler.CollectDrops:Set("CurrentProgressLevel", fruit)
                return fruit
            end
        end
    end)
    FunctionsHandler.CollectDrops:RegisterMethod("Start", function()
        local fruitDrop = FunctionsHandler.CollectDrops:Get("CurrentProgressLevel")
        FunctionsHandler.CollectDrops:Set("CurrentProgressLevel", nil)
        if fruitDrop then
            SetTask("MainTask", "Collect Drops | Fruit | Picking up " .. tostring(fruitDrop))
            TweenController.Create(fruitDrop:GetModelCFrame())
        end
    end)

    -- ==============================================================================
    -- 🍓 AUTO COLLECT BERRY (Ưu tiên ngang nhặt trái tự nhiên)
    -- ==============================================================================
    local activeBerryBush = nil
    local CollectionService = game:GetService("CollectionService")

    local function CheckAvailableBerries()
        local berryCount = 0
        for _, bush in ipairs(CollectionService:GetTagged("BerryBush")) do
            for attrName, attrVal in pairs(bush:GetAttributes()) do
                if attrName:sub(1, 12) == "_BerryCFrame" and attrVal then
                    berryCount = berryCount + 1
                end
            end
        end
        return berryCount > 0
    end

    FunctionsHandler.CollectBerries:RegisterMethod("Refresh", function()
        local currentSettings = getgenv().SettingFarm or farmSettings
        local autoCollectBerry = currentSettings
            and currentSettings["Get Items"]
            and currentSettings["Get Items"]["Auto Collect Berry"]
        if not autoCollectBerry then
            return false
        end
        return CheckAvailableBerries()
    end)

    FunctionsHandler.CollectBerries:RegisterMethod("Start", function()
        if not CheckAvailableBerries() then
            activeBerryBush = nil
            return
        end

        SetTask("MainTask", "Collect Berries | Harvesting | Gathering Berries...")
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return
        end

        if not activeBerryBush or not activeBerryBush.Parent then
            local closestBush, closestDist = nil, math.huge
            for _, taggedBush in ipairs(CollectionService:GetTagged("BerryBush")) do
                for attrName in pairs(taggedBush:GetAttributes()) do
                    if attrName:sub(1, 12) == "_BerryCFrame" and taggedBush:GetAttribute(attrName) then
                        local bushParent = taggedBush.Parent
                        if bushParent and bushParent:IsA("Model") then
                            local pivotPos = bushParent:GetPivot().Position
                            local dist = (pivotPos - hrp.Position).Magnitude
                            if dist < closestDist then
                                closestBush = bushParent
                                closestDist = dist
                            end
                        end
                    end
                end
            end

            if closestBush then
                activeBerryBush = closestBush
                local targetCFrame = CFrame.new(closestBush:GetPivot().Position + Vector3.new(0, 2, 0))
                TweenController.Create(targetCFrame)
                return
            end
        else
            -- Đang đứng tại bụi dâu: Nhận quả qua Remote và nhặt Berries
            pcall(function()
                local netModules = game.ReplicatedStorage:FindFirstChild("Modules")
                    and game.ReplicatedStorage.Modules:FindFirstChild("Net")
                local claimBerryRemote = netModules and netModules:FindFirstChild("RF/ClaimBerry")
                if claimBerryRemote then
                    for _, streamedBush in ipairs(CollectionService:GetTagged("BerryBushStreamed")) do
                        for attrName in pairs(streamedBush:GetAttributes()) do
                            if attrName:sub(1, 12) == "_BerryCFrame" and streamedBush:GetAttribute(attrName) then
                                local parentName = streamedBush.Parent and streamedBush.Parent.Name
                                if parentName then
                                    claimBerryRemote:InvokeServer(parentName, attrName)
                                end
                            end
                        end
                    end
                end
            end)

            local berriesFolder = activeBerryBush:FindFirstChild("Berries")
            if berriesFolder then
                for _, berryModel in ipairs(berriesFolder:GetChildren()) do
                    if berryModel:IsA("Model") and berryModel.PrimaryPart then
                        TweenController.Create(berryModel.PrimaryPart.CFrame)
                        task.wait(0.2)
                        return
                    end
                end
            end
            activeBerryBush = nil
        end
    end)
    FunctionsHandler.UtillyItemsActivitation:RegisterMethod("Refresh", function()
        if os.time() - ScriptInitTimestamp < 20 then
            return
        end
        if not SpecialItems then
            SpecialItems = {}
            local excludedBossesList = {}
            canSkipIceAdmiral = true
            if not ScriptStorage.Backpack.Rengoku then
                table.insert(SpecialItems, "Hidden Key")
                canSkipIceAdmiral = false
            end
            if SeaIndex == 2 and Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild("PhoeyuDoor") then
                table.insert(SpecialItems, "Library Key")
                canSkipIceAdmiral = false
            end
            if canSkipIceAdmiral then
                table.insert(excludedBossesList, "Awakened Ice Admiral")
            end
            local sharkmanResponse = not ScriptStorage.Melees["Sharkman Karate"]
                and Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
            hasSharkmanKaratePrereq = (typeof(sharkmanResponse) == "string")
            if typeof(sharkmanResponse) == "string" then
                table.insert(SpecialItems, "Water Key")
            else
                canSkipTideKeeper = true
                table.insert(excludedBossesList, "Tide Keeper")
            end
            if ScriptStorage.Backpack.Yama then
                DebugLog("Elite Bosses Excluded")
                table.insert(excludedBossesList, "Deandre")
                table.insert(excludedBossesList, "Urban")
                table.insert(excludedBossesList, "Diablo")
            end
            local function SortBosses()
                local filteredBosses = {}
                for _, candidateBoss in ipairs(BossesOrder) do
                    local isBossExcluded = false
                    for _, excludedBossName in ipairs(excludedBossesList) do
                        if excludedBossName == candidateBoss then
                            isBossExcluded = true
                            break
                        end
                    end
                    if not isBossExcluded then
                        table.insert(filteredBosses, candidateBoss)
                    end
                end
                table.sort(filteredBosses, function(bossA, bossB)
                    return tostring(bossA):lower() < tostring(bossB):lower()
                end)
                return filteredBosses
            end
            BossesOrder = SortBosses()
            local function CheckItemOwned(itemName)
                local bp = LocalPlayer:FindFirstChild("Backpack")
                local char = LocalPlayer.Character
                local sbp = ScriptStorage.Backpack

                local aliases = {
                    ["Gravity Blade"] = "Gravity Cane",
                    ["Gravity Cane"] = "Gravity Blade",
                    ["Flail"] = "Jitte",
                    ["Jitte"] = "Flail",
                    ["Venom Bow"] = "Serpent Bow",
                    ["Serpent Bow"] = "Venom Bow",
                    ["Skull Guitar"] = "Soul Guitar",
                    ["Soul Guitar"] = "Skull Guitar",
                }
                local altName = aliases[itemName]

                local function check(n)
                    if not n then
                        return false
                    end
                    return (bp and bp:FindFirstChild(n) ~= nil)
                        or (char and char:FindFirstChild(n) ~= nil)
                        or (sbp and sbp[n] ~= nil)
                end

                return check(itemName) or check(altName)
            end

            local currentSettings = getgenv().SettingFarm or farmSettings
            local getItems = currentSettings["Get Items"] or {}
            local allowBossDrops = (getItems["Auto Farm Boss Drops"] ~= false)

            if allowBossDrops then
                for dropName, dropConfig in pairs(DropItemData) do
                    if not CheckItemOwned(dropName) and SeaIndex == dropConfig.Sea then
                        if ScriptStorage.PlayerData.Level >= dropConfig.Level then
                            BossesOrderLevel[dropConfig.Boss] = dropConfig.Level
                            if not table.find(BossesOrder, dropConfig.Boss) then
                                table.insert(BossesOrder, dropConfig.Boss)
                            end
                            if dropConfig.AltBoss and not table.find(BossesOrder, dropConfig.AltBoss) then
                                BossesOrderLevel[dropConfig.AltBoss] = dropConfig.Level
                                table.insert(BossesOrder, dropConfig.AltBoss)
                            end
                        end
                    end
                end
            end
            if FunctionsHandler.Trevor:Get("IsCompleted") and not Storage:Get("SwanDefeated") then
                DebugLog("Added Don Swan to boss order list")
                BossesOrderLevel["Don Swan"] = 1100
                table.insert(BossesOrder, "Don Swan")
                DebugLog(ScriptStorage.PlayerData.Level, ScriptStorage.Enemies["Don Swan"])
                if
                    SeaIndex == 2
                    and ScriptStorage.PlayerData.Level > 1500
                    and not ScriptStorage.Enemies["Don Swan"]
                then
                    local canHopBoss = currentSettings
                        and currentSettings["Setting Hop"]
                        and currentSettings["Setting Hop"]["Hop Find Boss"]
                    if canHopBoss then
                        DebugLog("hop")
                        alert("Boss Hunter", "Hopping server for Don Swan...")
                        Hop("Find Don Swan")
                    end
                end
            end
        end
        for _, specialItemName in ipairs(SpecialItems) do
            if ScriptStorage.Tools[specialItemName] then
                FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", specialItemName)
                return specialItemName
            end
        end
        local canGetPreviousHero = SeaIndex == 3
            and (ScriptStorage.Melees["Electro"] or 0) >= 400
            and ScriptStorage.PlayerData.Beli >= 2500000
            and ScriptStorage.PlayerData.Fragments >= 5000
            and not ScriptStorage.Melees["Electric Claw"]
        if canGetPreviousHero then
            FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", "Previous Hero")
            return "Previous Hero"
        end
        if ScriptStorage.Tools["Red Key"] then
            FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", "Red Key")
            return "Red Key"
        end
        if ScriptStorage.Tools["Hallow Essence"] then
            FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", "Soul Reaper Spawner")
            return "Soul Reaper Spawner"
        end
        if ScriptStorage.Tools["Fire Essence"] then
            FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", "Uzoth")
            return "Uzoth"
        end
    end)
    FunctionsHandler.UtillyItemsActivitation:RegisterMethod("Start", function()
        local currentUtilityItem = FunctionsHandler.UtillyItemsActivitation:Get("CurrentProgressLevel")
        if currentUtilityItem == "Hidden Key" then
            Remotes.CommF_:InvokeServer("OpenRengoku")
        elseif currentUtilityItem == "Water Key" then
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Water Key")
            Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
            Remotes.CommF_:InvokeServer("BuySharkmanKarate")
        elseif currentUtilityItem == "Library Key" then
            Remotes.CommF_:InvokeServer("OpenLibrary")
            pcall(function()
                local door = Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild("PhoeyuDoor")
                if door then
                    door:Destroy()
                end
            end)
        elseif currentUtilityItem == "Red Key" then
            alert("Red Key", "Submitting Red Key to Scientist...")
            Remotes.CommF_:InvokeServer("CakeScientist", "Check")
            pcall(function()
                local rk = ScriptStorage.Tools["Red Key"]
                if rk then
                    rk:Destroy()
                end
            end)
        elseif currentUtilityItem == "Previous Hero" then
            Remotes.CommF_:InvokeServer("BuyElectricClaw", "Start")
            task.wait(3)
            local mansionPos = CFrame.new(-12548.0, 332.378, -7617.0)
            repeat
                task.wait()
                TweenController.Create(CFrame.new(-12548.0, 332.378 + math.random(-2.0, 2), -7617.0))
            until CalculateDistance(mansionPos) < 30
            local eClawData = MeleePrices["Electric Claw"]
            if eClawData then
                eClawData.Buy(1)
            end
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Melee")
        elseif currentUtilityItem == "Uzoth" then
            DebugLog("Use Fire Essence")
            Remotes.CommF_:InvokeServer("BuyDragonTalon", true)
            Remotes.CommF_:InvokeServer("BuyDragonTalon")
            IsFireEssenceGave = true
            Report("Đã giao Tinh Hoa Lửa (Fire Essence) cho NPC Uzoth mở khóa Dragon Talon!", "DRAGON TALON")
        elseif currentUtilityItem == "Soul Reaper Spawner" then
            DebugLog("Use Hallow Essence")
            local soulReaper = ScriptStorage.Enemies["Soul Reaper"]
            if soulReaper and soulReaper:FindFirstChild("Humanoid") and soulReaper.Humanoid.Health > 0 then
                SetTask("SubTask", "Soul Reaper | Defeating | Fighting Boss")
                CombatController.Attack("Soul Reaper")
                SpecialItems = nil
            else
                SetTask("SubTask", "Soul Reaper | Summoning | Traveling to Altar")
                local summonPos = CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125)
                repeat
                    task.wait(0.1)
                    TweenController.Create(summonPos)
                until not getgenv().AutoKaitun or _G.Stop or CalculateDistance(summonPos) < 10
                if getgenv().AutoKaitun and not _G.Stop then
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Hallow Essence")
                end
            end
        end
    end)
    FunctionsHandler.Trevor:RegisterMethod("GetFruit", function()
        for _, fruit in pairs(ScriptStorage.Backpack) do
            if string.find(FruitIdToName(fruit.Name), " Fruit") then
                if fruit.Value and fruit.Value > 1000000 and fruit.Value < 2500000 then
                    return fruit
                end
            end
        end
    end)
    FunctionsHandler.Trevor:RegisterMethod("Refresh", function()
        if FunctionsHandler.Trevor:Get("IsCompleted") or os.time() - ScriptInitTimestamp < 1 then
            return
        end
        if ScriptStorage.PlayerData.Level < 1100 then
            return
        end
        local fruit = FunctionsHandler.Trevor.Methods.GetFruit:Call()
        if fruit then
            FunctionsHandler.Trevor:Set("Fruit", fruit)
        end
        TrevorDebounce = os.time()
        if not FunctionsHandler.Trevor:Get("IsCompleted") then
            local talkResult = Remotes.CommF_:InvokeServer("TalkTrevor", "1")
            FunctionsHandler.Trevor:Set("IsCompleted", talkResult == 0)
            DebugLog("Update IsCompleted", FunctionsHandler.Trevor:Get("IsCompleted"), talkResult)
        end
        return not FunctionsHandler.Trevor:Get("IsCompleted") and fruit
    end)
    FunctionsHandler.Trevor:RegisterMethod("Start", function()
        alert("Trevor Quest", "Submitting fruit to Trevor...")
        local fruit = FunctionsHandler.Trevor:Get("Fruit")
        FunctionsHandler.Trevor:Set("Fruit", nil)
        if fruit then
            table.insert(ScriptStorage.IgnoreStoreFruits, fruit.Name)
            Remotes.CommF_:InvokeServer("LoadFruit", fruit.Name)
        end
        task.wait()
        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(FruitIdToName(fruit.Name))
        Remotes.CommF_:InvokeServer("TalkTrevor", "1")
        Remotes.CommF_:InvokeServer("TalkTrevor", "2")
        Remotes.CommF_:InvokeServer("TalkTrevor", "3")
        task.wait(1)
        FunctionsHandler.Trevor:Set("IsCompleted", true)
    end)
    FunctionsHandler.ThirdSeaPuzzle:RegisterMethod("Refresh", function()
        if ScriptStorage.PlayerData.Level < 1500 or SeaIndex ~= 2 then
            return
        end
        if nil == FunctionsHandler.ThirdSeaPuzzle:Get("State") then
            ZQuestProgress = Remotes.CommF_:InvokeServer("ZQuestProgress", "Check")
            DebugLog("ZQuestProgress", ZQuestProgress)
            FunctionsHandler.ThirdSeaPuzzle:Set("State", ZQuestProgress == 0)
        end
        return FunctionsHandler.ThirdSeaPuzzle:Get("State")
    end)
    FunctionsHandler.ThirdSeaPuzzle:RegisterMethod("Start", function()
        local started = FunctionsHandler.ThirdSeaPuzzle:Get("State")
        if started then
            repeat
                task.wait(1)
                local startResponse = Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
                DebugLog("StartResponse", startResponse)
            until CaculateDistance(Vector3.new(0, 0, 0)) > 20000
            task.spawn(function()
                task.wait(30)
                LocalPlayer:Kick()
            end)
            alert("Third Sea Puzzle", "Attacking rip_indra...")
            while task.wait() do
                CombatController.Attack("rip_indra")
            end
        end
    end)
    FunctionsHandler.Yama:RegisterMethod("Refresh", function()
        if SeaIndex ~= 3 then
            return
        end
        if ScriptStorage.Backpack.Yama then
            return
        end
        if not FunctionsHandler.Yama:Get("EliteCount") then
            FunctionsHandler.Yama:Set("EliteCount", Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        end
        if FunctionsHandler.Yama:Get("EliteCount") >= 30 then
            return true
        end
    end)
    FunctionsHandler.Yama:RegisterMethod("Start", function()
        repeat
            task.wait()
            TweenController.Create(game:GetService("ReplicatedStorage").FakeIslands.Waterfall:GetModelCFrame())
        until workspace.Map:FindFirstChild("Waterfall") and workspace.Map.Waterfall:FindFirstChild("SealedKatana")
        fireclickdetector(workspace.Map.Waterfall.SealedKatana.Hitbox.ClickDetector)
    end)
    FunctionsHandler.PirateRaid:RegisterMethod("Refresh", function()
        local lastSeen = FunctionsHandler.PirateRaid:Get("Senque")
        return lastSeen and os.time() - lastSeen < 500
    end)
    FunctionsHandler.PirateRaid:RegisterMethod("Start", function()
        local nearbyMobs = GetMonAsSortedRange()
        local anchorPos = Vector3.new(-5543.5327148438, 313.80062866211, -2964.2585449219)
        if nearbyMobs[1] then
            local humanoid, rootPart =
                nearbyMobs[1]:FindFirstChild("Humanoid"), nearbyMobs[1]:FindFirstChild("HumanoidRootPart")
            if rootPart and humanoid and humanoid.Health > 0 and CaculateDistance(rootPart.CFrame, anchorPos) < 500 then
                CombatController.Attack(nearbyMobs[1].Name)
                return
            end
        end
        TweenController.Create(anchorPos)
    end)
    function CheckFullMoon(strict)
        local sky = Lighting:FindFirstChildOfClass("Sky") or Lighting:FindFirstChild("Sky")
        if not sky or sky.MoonTextureId ~= "http://www.roblox.com/asset/?id=970914431" then
            return false
        end
        if strict then
            return true
        end
        return Lighting.ClockTime > 18 or Lighting.ClockTime < 5
    end
    -- Hàm phát hiện rương gần nhất để tìm Fist of Darkness ở Sea 2
    local function DetectNearestChest()
        local nearestChest = nil
        local minDistance = math.huge
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return nil
        end

        local taggedChests = CollectionService:GetTagged("_ChestTagged")
        for _, chest in ipairs(taggedChests) do
            if chest:IsA("BasePart") and chest.Parent and chest:GetAttribute("IsDisabled") ~= true then
                local dist = (chest.Position - hrp.Position).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    nearestChest = chest
                end
            end
        end

        if not nearestChest then
            local chestModels = workspace:FindFirstChild("ChestModels")
            if chestModels then
                for _, model in ipairs(chestModels:GetChildren()) do
                    local part = model:IsA("BasePart") and model or model:FindFirstChildOfClass("Part")
                    if part and model:GetAttribute("IsDisabled") ~= true then
                        local dist = (part.Position - hrp.Position).Magnitude
                        if dist < minDistance then
                            minDistance = dist
                            nearestChest = part
                        end
                    end
                end
            end
        end

        return nearestChest
    end

    FunctionsHandler.SoulGuitar:RegisterMethod("Refresh", function()
        if not Config.Items.SoulGuitar then
            return
        end
        if ScriptStorage.Backpack["Skull Guitar"] then
            return
        end
        if ScriptStorage.PlayerData.Level < 2300 then
            return
        end

        -- Nếu chưa có Dark Fragment: Tự động về Sea 2 săn Darkbeard hoặc farm rương tìm Fist of Darkness
        if not ScriptStorage.Backpack["Dark Fragment"] then
            return "GetDarkFragment"
        end

        local ectoplasm = (ScriptStorage.Backpack["Ectoplasm"] or { Count = 0 })["Count"]
        local bones = (ScriptStorage.Backpack["Bones"] or { Count = 0 })["Count"]

        -- Nếu chưa đủ Ectoplasm (cần 250): Farm quái Tàu Ma ở Sea 2
        if ectoplasm < 250 then
            return 1
        end

        -- Đã có Dark Fragment & đủ Ectoplasm nhưng đang ở Sea 2 -> Quay lại Sea 3
        if SeaIndex ~= 3 then
            return "TravelToSea3"
        end
        SoulGuitarProcess = Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check")
        if not SoulGuitarProcess then
            Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
            if not CheckFullMoon() then
                SetTask("MainTask", "Soul Guitar | Full Moon | Hopping Server for Full Moon")
                Hop()
            end
            return 7
        end
        if not SoulGuitarProcess.Swamp then
            return 2
        elseif not SoulGuitarProcess.Gravestones then
            return 3
        elseif not SoulGuitarProcess.Ghost then
            return 4
        elseif not SoulGuitarProcess.Trophies then
            return 5
        elseif not SoulGuitarProcess.Pipes then
            return 6
        elseif bones >= 500 and not ScriptStorage.Backpack["Skull Guitar"] then
            return 8
        end
    end)
    FunctionsHandler.SoulGuitar:RegisterMethod("Start", function(step)
        if step == "GetDarkFragment" then
            -- Nếu đang ở Sea 3: Di chuyển về Sea 2
            if SeaIndex == 3 then
                SetTask("MainTask", "Soul Guitar | Dark Fragment | Traveling to Sea 2")
                alert("Soul Guitar", "Traveling to Sea 2 for Dark Fragment")
                Remotes.CommF_:InvokeServer("TravelDressrosa")
                task.wait(2)
                return
            end

            -- Đang ở Sea 2:
            if SeaIndex == 2 then
                -- 1. Kiểm tra Boss Darkbeard đã spawn chưa -> Nếu có đánh luôn
                local darkbeardBoss = ScriptStorage.Enemies["Darkbeard"]
                    or (Services.Workspace.Enemies and Services.Workspace.Enemies:FindFirstChild("Darkbeard"))
                    or (game.ReplicatedStorage and game.ReplicatedStorage:FindFirstChild("Darkbeard"))

                if darkbeardBoss and darkbeardBoss:FindFirstChild("Humanoid") and darkbeardBoss.Humanoid.Health > 0 then
                    SetTask("MainTask", "Soul Guitar | Darkbeard | Defeating Boss for Fragment")
                    alert("Soul Guitar", "Found Darkbeard! Defeating boss...")
                    CombatController.Attack("Darkbeard")
                    return
                end

                -- 2. Kiểm tra xem người chơi đã có Fist of Darkness chưa
                local hasFist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Fist of Darkness"))
                    or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild(
                        "Fist of Darkness"
                    ))
                    or (ScriptStorage.Backpack and ScriptStorage.Backpack["Fist of Darkness"])

                if hasFist then
                    SetTask("MainTask", "Soul Guitar | Darkbeard | Summoning at Dark Arena...")
                    local darkArenaPedestal = CFrame.new(3777, 14, -3499)
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Fist of Darkness")
                    TweenController.Create(darkArenaPedestal)
                    if CalculateDistance(darkArenaPedestal) < 15 then
                        task.wait(1)
                    end
                    return
                end

                -- 3. Chưa có Fist of Darkness và chưa có Boss: Farm rương tìm Fist of Darkness
                SetTask("MainTask", "Soul Guitar | Fist of Darkness | Farming Chests in Sea 2")
                local nearestChest = DetectNearestChest()
                if nearestChest and nearestChest.Parent then
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Sit then
                        hum.Sit = false
                    end

                    TweenController.Create(nearestChest.CFrame * CFrame.new(0, 3, 2))
                    task.wait(0.2)
                    return
                else
                    -- Hết rương ở Sea 2 -> Tự động Hop server tìm rương mới / tìm server có Darkbeard
                    SetTask("MainTask", "Soul Guitar | Fist of Darkness | No Chests Left, Hopping Server")
                    alert("Soul Guitar", "No chests left in Sea 2! Hopping server to find Fist of Darkness...")
                    Hop("Soul Guitar - No chests left in Sea 2 / Finding Fist of Darkness")
                    task.wait(5)
                    return
                end
            end
        elseif step == "TravelToSea3" then
            SetTask("MainTask", "Soul Guitar | Dark Fragment | Returning to Sea 3")
            alert("Soul Guitar", "Got Dark Fragment! Returning to Sea 3")
            Remotes.CommF_:InvokeServer("TravelZou")
            task.wait(2)
            return
        elseif step == 7 then
            while CaculateDistance(CFrame.new(-8654.0, 140, 6167)) > 5 do
                task.wait()
                TweenController.Create(CFrame.new(-8654.0, 140, 6167))
            end
            SoulGuitarProcess = Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
        elseif step == 1 then
            if SeaIndex ~= 2 then
                SetTask("MainTask", "Soul Guitar | Ectoplasm | Traveling to Sea 2")
                return Remotes.CommF_:InvokeServer("TravelDressrosa")
            else
                SetTask("MainTask", "Soul Guitar | Ectoplasm | Farming Cursed Ship Mobs")
                CombatController.Attack({ "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer" })
                return
            end
        elseif step == 2 then
            soulGuitarTimer = soulGuitarTimer or 0
            if os.time() ~= lastSoulGuitarTick then
                soulGuitarTimer = soulGuitarTimer + 1
                lastSoulGuitarTick = os.time()
            end
            if soulGuitarTimer > 60 then
                return Hop("Soul Guitar Timeout")
            end
            local zombies = {}
            for _, enemy in ipairs(Services.Workspace.Enemies:GetChildren()) do
                if enemy.Name == "Living Zombie" then
                    table.insert(zombies, enemy)
                end
            end
            if #zombies < 6 then
                SetTask("MainTask", "Soul Guitar | Task 1/5 | Waiting for Living Zombies")
                local zSpawn = ScriptStorage.MobRegions["Living Zombie"]
                    and ScriptStorage.MobRegions["Living Zombie"][1]
                if zSpawn then
                    TweenController.Create(zSpawn + Vector3.new(0, 30, 0))
                end
            else
                local stepStartTime = os.time()
                for idx, zombieEntity in zombies do
                    while task.wait() and zombieEntity.Humanoid.Health > 7000 do
                        SetTask("MainTask", "Soul Guitar | Task 1/5 | Syncing Mob HP " .. idx .. "/6")
                        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Melee")
                        if os.time() - stepStartTime > 60 then
                            Hop()
                        end
                        TweenController.Create(zombieEntity.HumanoidRootPart.CFrame + Vector3.new(0, 50, 0))
                        AttackModule:Attack()
                    end
                end
                SetTask("MainTask", "Soul Guitar | Task 1/5 | Defeating All Zombies")
                while workspace.Enemies:FindFirstChild("Living Zombie") and task.wait() do
                    if os.time() - stepStartTime > 60 then
                        Hop()
                    end
                    CombatController.Attack("Living Zombie")
                end
            end
        elseif step == 3 then
            local hauntedCastle = workspace.Map["Haunted Castle"]
            while CaculateDistance(CFrame.new(-8800.0, 178, 6033)) > 10 do
                task.wait()
                SetTask("MainTask", "Soul Guitar | Task 2/5 | Solving Placards Puzzle")
                TweenController.Create(CFrame.new(-8800.0, 178, 6033))
            end
            for placardName, direction in
                {
                    Placard1 = "Right",
                    Placard2 = "Right",
                    Placard3 = "Left",
                    Placard4 = "Right",
                    Placard5 = "Left",
                    Placard6 = "Left",
                    Placard7 = "Left",
                }
            do
                fireclickdetector(hauntedCastle[placardName][direction].ClickDetector)
            end
        elseif step == 4 then
            Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost")
        elseif step == 5 then
            local tabletsAreaCFrame = CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375)
            if CaculateDistance(tabletsAreaCFrame) > 30 then
                TweenController.Create(tabletsAreaCFrame)
            else
                local hauntedCastleTablets = workspace.Map["Haunted Castle"].Tablet
                for _, tabletName in pairs(BlankTablets) do
                    local tablet = hauntedCastleTablets[tabletName]
                    if tablet.Line.Rotation.Z ~= 0 then
                        repeat
                            task.wait()
                            fireclickdetector(tablet.ClickDetector)
                        until tablet.Line.Rotation.Z == 0
                    end
                end
                for tabletName, questKey in pairs(Trophy) do
                    local rotationComponent = workspace.Map["Haunted Castle"].Trophies.Quest[questKey].Handle.CFrame
                    rotationComponent = tostring(rotationComponent)
                    rotationComponent = rotationComponent:split(", ")[4]
                    local expectedRotationStr = "180"
                    if rotationComponent == "1" or rotationComponent == "-1" then
                        expectedRotationStr = "90"
                    end
                    local tabletMatches =
                        string.find(tostring(hauntedCastleTablets[tabletName].Line.Rotation.Z), expectedRotationStr)
                    if not tabletMatches then
                        repeat
                            task.wait()
                            fireclickdetector(hauntedCastleTablets[tabletName].ClickDetector)
                        until string.find(
                                tostring(hauntedCastleTablets[tabletName].Line.Rotation.Z),
                                expectedRotationStr
                            )
                    end
                end
            end
        elseif step == 6 then
            for pipeName, expectedColor in pairs(Pipes) do
                pcall(function()
                    local floorTile = workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model[pipeName]
                    if floorTile.BrickColor.Name ~= expectedColor then
                        repeat
                            task.wait()
                            fireclickdetector(floorTile.ClickDetector)
                        until floorTile.BrickColor.Name == expectedColor
                    end
                end)
            end
            Remotes.CommF_:InvokeServer("soulGuitarBuy")
        elseif step == 8 then
            Remotes.CommF_:InvokeServer("soulGuitarBuy")
        end
    end)
    FunctionsHandler.Tushita:RegisterMethod("Refresh", function()
        if ScriptStorage.Backpack.Tushita then
            return
        end
        if ScriptStorage.PlayerData.Level < 2000 then
            return
        end
        if SeaIndex ~= 3 then
            return
        end
        TushitaProgress = TushitaProgress or Remotes.CommF_:InvokeServer("TushitaProgress")
        if not TushitaProgress.OpenedDoor then
            if ScriptStorage.Enemies["rip_indra True Form"] then
                TushitaProgress = nil
                return 1
            end
        else
            if ScriptStorage.Enemies["Longma"] then
                TushitaProgress = nil
                return 2
            end
        end
    end)
    FunctionsHandler.Tushita:RegisterMethod("Start", function(step)
        if step == 1 then
            alert("Tushita Quest", "Lighting torches...")
            TweenController.Create(CFrame.new(5714, math.random(19, 21), 256))
            if ScriptStorage.Tools["Holy Torch"] then
                for i = 1, 5 do
                    Remotes.CommF_:InvokeServer("TushitaProgress", "Torch", i)
                end
                return true
            end
        elseif step == 2 then
            alert("Tushita Quest", "Defeating Longma...")
            CombatController.Attack("Longma")
        end
    end)
    FunctionsHandler.CursedDualKatana:RegisterMethod("Refresh", function()
        if not Config.Items.CursedDualKatana then
            return
        end
        local backpack = ScriptStorage.Backpack
        if ScriptStorage.PlayerData.Level < 2200 then
            return
        end
        local notReady = backpack["Cursed Dual Katana"]
            or not backpack.Tushita
            or backpack.Tushita.Mastery < 350
            or not backpack.Yama
            or backpack.Yama.Mastery < 350
        if notReady then
            return
        end
        if SeaIndex ~= 3 then
            return
        end
        local progress = CdkProgess or Remotes.CommF_:InvokeServer("CDKQuest", "Progress") or "uwu"
        if not progress or progress == "uwu" then
            return
        end
        if workspace.Map.Turtle.Cursed:FindFirstChild("Breakable") then
            alert("Cursed Dual Katana", "Opening Cursed Door...")
            return { "break" }
        end
        local itemByCategory = { Good = "Tushita", Evil = "Yama" }
        if progress.Good == 4 and progress.Evil == 4 then
            DebugLog("burn 2")
            return { "burn 2" }
        end
        if progress.Good == 3 or progress.Evil == 3 then
            DebugLog("burn 1")
            return { "burn" }
        end
        if progress.Opened then
            for category, trialLevel in progress do
                if category ~= "Opened" and category ~= "Finished" and trialLevel < 3 then
                    DebugLog(category, trialLevel)
                    ScriptStorage.CdkCache = { category, trialLevel + 1 }
                    if not ScriptStorage.Tools[itemByCategory[category]] then
                        Remotes.CommF_:InvokeServer("LoadItem", itemByCategory[category])
                    end
                    alert(
                        "Cursed Dual Katana",
                        "Starting " .. tostring(itemByCategory[category]) .. " " .. tostring(category) .. " Trial"
                    )
                    Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", category)
                    SetTask(
                        "MainTask",
                        "Cursed Dual Katana | "
                            .. tostring(itemByCategory[category])
                            .. " | Starting "
                            .. tostring(category)
                            .. " Trial"
                    )
                    return false
                end
            end
        end
        local cached = ScriptStorage.CdkCache
        if not cached then
            return
        end
        local cachedCategory, cachedLevel = cached[1], cached[2]
        if cachedCategory == "Evil" and cachedLevel == 3 then
            if not ScriptStorage.Enemies["Soul Reaper"] then
                ForceToRollBone = true
                return
            end
        elseif cachedCategory == "Good" then
            if cachedLevel == 2 then
                SetTask("SubTask", "CDK Quest | Waiting | Pirate Raid to Start")
                return
            elseif cachedLevel == 3 and not ScriptStorage.Enemies["Cake Queen"] then
                local currentSettings = getgenv().SettingFarm or farmSettings
                local canHopBoss = currentSettings
                    and currentSettings["Setting Hop"]
                    and currentSettings["Setting Hop"]["Hop Find Boss"]
                if canHopBoss then
                    Hop("Find Cake Queen")
                end
                SetTask("SubTask", "CDK Quest | Waiting | Cake Queen to Respawn")
                return
            end
        end
        return cached
    end)
    FunctionsHandler.CursedDualKatana:RegisterMethod("GetHazeMon", function()
        local hazeMobs = {}
        local qHaze = LocalPlayer:FindFirstChild("QuestHaze")
        if qHaze then
            for _, mob in ipairs(qHaze:GetChildren()) do
                if mob.Value > 0 then
                    table.insert(hazeMobs, mob)
                end
            end
            table.sort(hazeMobs, function(mob, other)
                return CaculateDistance(mob:GetAttribute("Position")) < CaculateDistance(other:GetAttribute("Position"))
            end)
        end
        return hazeMobs[1] and tostring(hazeMobs[1]) or ""
    end)
    FunctionsHandler.CursedDualKatana:RegisterMethod("DoDimension", function(dimensionName)
        local mapName = string.gsub(dimensionName, " ", "")
        local waitStartTime = os.time()
        repeat
            task.wait()
            TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
            if os.time() - waitStartTime > 60 then
                return
            end
        until os.time() - TorchEnabledTime < 10
        local dimensionMap
        repeat
            task.wait()
            dimensionMap = workspace.Map:WaitForChild(mapName, 10)
            if dimensionMap then
                for _, child in dimensionMap:GetChildren() do
                    if
                        child
                        and string.find(child.Name, "Torch")
                        and child:FindFirstChild("ProximityPrompt")
                        and child.ProximityPrompt.Enabled
                    then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = child.CFrame
                        child.ProximityPrompt.HoldDuration = 0
                        task.wait(1)
                        local inputManager = game:GetService("VirtualInputManager")
                        inputManager:SendKeyEvent(true, "E", 0, game)
                        inputManager:SendKeyEvent(false, "E", 0, game)
                        fireproximityprompt(
                            workspace.Map:WaitForChild(mapName, 10):FindFirstChild(tostring(child)).ProximityPrompt
                        )
                    end
                    for _, enemyEntity in workspace.Enemies:GetChildren() do
                        local enemyRoot = enemyEntity:FindFirstChild("HumanoidRootPart")
                        local enemyHumanoid = enemyEntity:FindFirstChild("Humanoid")
                        if enemyRoot and enemyHumanoid and CaculateDistance(enemyRoot.CFrame) < 1000 then
                            CombatController.Attack(enemyEntity.Name)
                        end
                    end
                end
                local exitDoor = dimensionMap:FindFirstChild("Exit")
                DebugLog("exit door", exitDoor)
                if exitDoor then
                    exitPortalColor = tostring(exitDoor.BrickColor)
                    DebugLog("Brick color", exitDoor, exitDoor.BrickColor, exitPortalColor)
                end
            else
                DebugLog("dimension map not loaded")
            end
            DebugLog("portal color check:", exitPortalColor)
        until exitPortalColor == "Olive" or exitPortalColor == "Cloudy grey"
        DebugLog("Leaving dimension...")
        local exitStart = os.time()
        local finalExitDoor = dimensionMap and dimensionMap:FindFirstChild("Exit")
        while os.time() - exitStart < 15 and finalExitDoor and finalExitDoor.Parent do
            TweenController.Create(finalExitDoor.CFrame + Vector3.new(0, math.random(1, 5), 0))
            task.wait(0.2)
        end
        Hop("Finished CDK Dimension")
    end)
    FunctionsHandler.CursedDualKatana:RegisterMethod("Start", function(progressState)
        if progressState[1] == "break" then
            TweenController.Create(workspace.Map.Turtle.Cursed.Breakable.CFrame)
            Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")
            Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
            workspace.Map.Turtle.Cursed.Breakable:Destroy()
            CdkProgess = nil
            return
        end
        if progressState[1] == "burn 2" then
            if workspace.Map.Turtle.Cursed.Pedestal3.ProximityPrompt.Enabled then
                fireproximityprompt(workspace.Map.Turtle.Cursed.Pedestal3.ProximityPrompt)
                task.wait(1)
                pcall(function()
                    LocalPlayer.Character.Humanoid.Health = 0
                end)
                task.wait(10)
            else
                CDKAttempts = (CDKAttempts or 0) + 1
                TweenController.Create(CFrame.new(-12341.66796875, 603.3455810546875, -6550.6064453125))
                task.wait(5)
                pcall(function()
                    LocalPlayer.Character.Humanoid.Health = 0
                end)
                task.wait(5)
                if CDKAttempts > 5 then
                    Hop()
                end
                CdkProgess = nil
            end
        elseif progressState[1] == "burn" then
            for pedestalIdx = 1, 3, 1 do
                if workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. pedestalIdx).ProximityPrompt.Enabled then
                    repeat
                        task.wait()
                        TweenController.Create(
                            workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. pedestalIdx).CFrame
                        )
                    until CaculateDistance(
                            workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. pedestalIdx).CFrame
                        ) < 5
                    fireproximityprompt(
                        workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. pedestalIdx).ProximityPrompt
                    )
                    task.wait(3)
                    pcall(function()
                        LocalPlayer.Character.Humanoid.Health = 0
                    end)
                end
                CdkProgess = nil
            end
        elseif progressState[1] == "Evil" then
            if progressState[2] == 1 then
                local forestPirate = ScriptStorage.Enemies["Forest Pirate"]
                local fSpawn = ScriptStorage.MobRegions["Forest Pirate"]
                    and ScriptStorage.MobRegions["Forest Pirate"][1]
                TweenController.Create(
                    (
                        forestPirate
                        and forestPirate:FindFirstChild("HumanoidRootPart")
                        and forestPirate.HumanoidRootPart.CFrame
                    ) or fSpawn
                )
                CdkProgess = nil
            elseif progressState[2] == 2 then
                CombatController.Attack(FunctionsHandler.CursedDualKatana.Methods.GetHazeMon:Call())
                CdkProgess = nil
            elseif progressState[2] == 3 then
                Report(
                    "Đã phát hiện Boss Soul Reaper để hoàn thành Thử Thách Quỷ số 3 của Yama!",
                    "CDK QUEST"
                )
                while not (os.time() - TorchEnabledTime < 100 or not ScriptStorage.Enemies["Soul Reaper"]) do
                    DebugLog("tweening to soul reaper")
                    task.wait()
                    if FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
                        pcall(function()
                            LocalPlayer.Character.Humanoid.Health = 0
                        end)
                    end
                    TweenController.Create(ScriptStorage.Enemies["Soul Reaper"]:GetModelCFrame())
                end
                if not ScriptStorage.Enemies["Soul Reaper"] then
                    return
                end
                FunctionsHandler.CursedDualKatana.Methods.DoDimension.Callback("Hell Dimension")
                CdkProgess = nil
            end
        else
            if progressState[2] == 1 then
                for _, npc in game.ReplicatedStorage.NPCs:GetChildren() do
                    if npc.Name == "Luxury Boat Dealer" then
                        repeat
                            task.wait()
                            if os.time() - DoneCdkTick < 15 then
                                return
                            end
                            local charRoot = game.Players.LocalPlayer.Character
                                and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if charRoot then
                                charRoot.CFrame = npc:GetModelCFrame()
                            end
                            luxuryBoatDealerNpc = nil
                            local npcsFolder = workspace:FindFirstChild("NPCs")
                            if npcsFolder then
                                for _, candidateNpc in ipairs(npcsFolder:GetChildren()) do
                                    if CalculateDistance(candidateNpc:GetModelCFrame(), npc:GetModelCFrame()) < 20 then
                                        luxuryBoatDealerNpc = candidateNpc
                                        break
                                    end
                                end
                            end
                        until CalculateDistance(npc:GetModelCFrame()) < 5 and luxuryBoatDealerNpc
                        Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", luxuryBoatDealerNpc)
                    end
                end
                CdkProgess = nil
            elseif progressState[2] == 3 then
                repeat
                    task.wait()
                    DebugLog("attacking cake queen")
                    CombatController.Attack("Cake Queen")
                until os.time() - TorchEnabledTime < 10 or not ScriptStorage.Enemies["Cake Queen"]
                TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
                Report("Đang tiến vào Chiều Không Gian Thiên Đường qua Boss Cake Queen!", "CDK QUEST")
                FunctionsHandler.CursedDualKatana.Methods.DoDimension.Callback("Heavenly Dimension")
                CdkProgess = nil
            end
        end
    end)
    local notifyRegistry = { Listeners = {} }
    TorchEnabledTime = 0
    DoneCdkTick = 0
    getgenv().NotificationCallBack = function(text)
        for keyword, callback in notifyRegistry.Listeners do
            if string.find(string.lower(text), string.lower(keyword)) then
                callback(text)
            end
        end
    end
    function notifyRegistry:RegisterNotifyListener(keyword, callback)
        notifyRegistry.Listeners[keyword] = callback
    end
    notifyRegistry:RegisterNotifyListener("go!", function()
        LastRaidAlert = os.time()
    end)
    notifyRegistry:RegisterNotifyListener("raid", function()
        LastRaidAlert2 = os.time()
    end)
    notifyRegistry:RegisterNotifyListener("been spotted approaching", function()
        FunctionsHandler.PirateRaid:Set("Senque", os.time())
    end)
    notifyRegistry:RegisterNotifyListener("job", function()
        FunctionsHandler.PirateRaid:Set("Senque", 0)
    end)
    notifyRegistry:RegisterNotifyListener("level", function()
        AddPoint()
    end)
    notifyRegistry:RegisterNotifyListener("torch", function()
        TorchEnabledTime = os.time()
    end)
    notifyRegistry:RegisterNotifyListener("scroll reacts", function()
        DoneCdkTick = os.time()
    end)
    notifyRegistry:RegisterNotifyListener("elite", function()
        FunctionsHandler.Yama:Set("EliteCount", Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        alert("Elite Hunter", "Elite defeated: " .. tostring(FunctionsHandler.Yama:Get("EliteCount") or "n/a"))
    end)
    notifyRegistry:RegisterNotifyListener("the raid with", function()
        if ScriptStorage.PlayerData.Level < MaxLevel then
            return
        end
        Remotes.CommF_:InvokeServer("Awakener", "Awaken")
    end)
    notifyRegistry:RegisterNotifyListener("quest completed", function()
        QuestManager:RefreshQuest()
        task.wait()
        if not QuestManager:GetCurrentClaimQuest() then
            QuestManager:MarkAsCompleted()
        end
    end)
    local originalNotificationNew
    if typeof(hookfunction) == "function" then
        pcall(function()
            local notifMod = require(game.ReplicatedStorage:WaitForChild("Notification", 5))
            if notifMod and notifMod.new then
                originalNotificationNew = hookfunction(notifMod.new, function(title, text)
                    local notificationText = tostring(title or "") .. " " .. tostring(text or "")
                    if getgenv().NotificationCallBack then
                        pcall(getgenv().NotificationCallBack, notificationText)
                    end
                    return originalNotificationNew(title, text)
                end)
            end
        end)
    end
    -- ==============================================================================
    -- 🔁 HOP SERVER: dùng Roblox Public Games API để lấy danh sách server,
    -- rồi hop qua remote __ServerBrowser (thay cho GetServers/Hop/LowHop cũ)
    -- ==============================================================================
    -- ==============================================================================
    -- 🛡️ AN TOÀN & BẢO VỆ: HOP KHI PING CAO & KHI CÓ ADMIN VÀO SERVER
    -- ==============================================================================
    local AdminList = {
        "red_game43",
        "rip_indra",
        "Axiore",
        "Polkster",
        "wenlocktoad",
        "Daigrock",
        "toilamvidamme",
        "oofficialnoobie",
        "Uzoth",
        "Azarth",
        "arlthmetic",
        "Death_King",
        "Lunoven",
        "TheGreateAced",
        "rip_fud",
        "drip_mama",
        "layandikit12",
        "Hingoi",
    }

    local function IsAdminName(playerName)
        for _, adminName in ipairs(AdminList) do
            if string.lower(tostring(playerName)) == string.lower(adminName) then
                return true
            end
        end
        return false
    end

    -- Lắng nghe ngay khi Admin vừa kết nối vào Server
    game:GetService("Players").PlayerAdded:Connect(function(newPlayer)
        local currentSettings = getgenv().SettingFarm or farmSettings
        local hopAdmin = currentSettings
            and currentSettings["Setting Hop"]
            and currentSettings["Setting Hop"]["Hop If Admin Join Server"]
        if hopAdmin and IsAdminName(newPlayer.Name) then
            alert("Security Alert", "Admin joined: " .. newPlayer.Name .. " -> Hopping server!")
            Hop("Admin Joined: " .. newPlayer.Name)
        end
    end)

    -- Vòng lặp định kỳ kiểm tra Admin trong Server
    task.spawn(function()
        while task.wait(3) do
            if getgenv().AutoKaitun and not _G.Stop then
                local currentSettings = getgenv().SettingFarm or {}
                local hopAdmin = currentSettings["Setting Hop"]
                    and currentSettings["Setting Hop"]["Hop If Admin Join Server"]
                if hopAdmin then
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if IsAdminName(player.Name) then
                            alert("Security Alert", "Admin detected: " .. player.Name .. " -> Hopping server!")
                            Hop("Admin Found: " .. player.Name)
                            break
                        end
                    end
                end
            end
        end
    end)

    -- Giám sát Ping cao để Hop Server (Hop When High Ping)
    local function GetCurrentNetworkPing()
        local pingVal = nil
        pcall(function()
            local stats = game:GetService("Stats")
            local net = stats and stats:FindFirstChild("Network")
            local serverStats = net and net:FindFirstChild("ServerStatsItem")
            local dataPing = serverStats and serverStats:FindFirstChild("Data Ping")
            if dataPing then
                pingVal = dataPing:GetValue()
            end
            if not pingVal then
                local perf = stats:FindFirstChild("PerformanceStats")
                local pingItem = perf and perf:FindFirstChild("Ping")
                if pingItem then
                    pingVal = pingItem:GetValue()
                end
            end
        end)
        return pingVal or 0
    end

    task.spawn(function()
        local highPingCounter = 0
        local PING_LIMIT = 800
        local MAX_DURATION_SECONDS = 15
        while task.wait(2) do
            if not getgenv().AutoKaitun or _G.Stop then
                highPingCounter = 0
            else
                local currentSettings = getgenv().SettingFarm or farmSettings
                local hopPing = currentSettings
                    and currentSettings["Setting Hop"]
                    and currentSettings["Setting Hop"]["Hop When High Ping"]
                if hopPing then
                    local currentPing = GetCurrentNetworkPing()
                    if currentPing > PING_LIMIT then
                        highPingCounter = highPingCounter + 2
                        if highPingCounter >= MAX_DURATION_SECONDS then
                            highPingCounter = 0
                            Hop("High Ping (" .. math.floor(currentPing) .. "ms)")
                            task.wait(10)
                        end
                    else
                        highPingCounter = 0
                    end
                else
                    highPingCounter = 0
                end
            end
        end
    end)

    function GetPublicServerList(cursor)
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor and cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONDecode(game:HttpGet(url))
        end)
        if success and result and result.data then
            return result
        end
        return nil
    end

    function Hop(reason)
        if reason then
            alert("Server Hop", tostring(reason))
        end
        SetTask("MainTask", "Server Hopping | " .. (reason and tostring(reason) or "Switching Server"))
        local currentJobId = game.JobId
        local cursor = ""
        while getgenv().AutoKaitun do
            local serverList = GetPublicServerList(cursor)
            if not serverList then
                task.wait(5)
            else
                cursor = (serverList.nextPageCursor and serverList.nextPageCursor ~= "null")
                        and serverList.nextPageCursor
                    or ""
                for _, server in ipairs(serverList.data) do
                    local serverId = tostring(server.id)
                    local currentPlayers = tonumber(server.playing)
                    local maxPlayers = tonumber(server.maxPlayers)
                    if currentPlayers and maxPlayers and currentPlayers < maxPlayers and serverId ~= currentJobId then
                        DebugLog("[Hop] Teleporting to server", serverId)
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("__ServerBrowser")
                            :InvokeServer("teleport", serverId)
                        task.wait(2)
                        return
                    end
                end
                task.wait(1)
            end
        end
    end
    Storage = { WRITE_DELAY = 10, Data = {}, Dirty = false }
    Services = {}
    setmetatable(Services, {
        __index = function(_, serviceName)
            return game:GetService(serviceName)
        end,
    })
    LocalPlayer = game.Players.LocalPlayer
    local storageFilePath = ".storage_u_" .. tostring(LocalPlayer)
    function Decode(json)
        return Services.HttpService:JSONDecode(json)
    end
    function Encode(data)
        return Services.HttpService:JSONEncode(data)
    end
    function Storage.Set(self, key, value)
        self.Data[key] = value
        self.Dirty = true
    end
    function Storage.Get(self, key)
        return self.Data[key]
    end
    function Storage.Save(self)
        if not self.Dirty then
            return
        end
        pcall(function()
            if typeof(writefile) == "function" then
                writefile(storageFilePath, Encode(self.Data))
                self.Dirty = false
            end
        end)
    end
    pcall(function()
        if typeof(isfile) == "function" and not isfile(storageFilePath) then
            if typeof(writefile) == "function" then
                writefile(storageFilePath, "{}")
            end
            task.wait(0.5)
        end
        if typeof(readfile) == "function" and typeof(isfile) == "function" and isfile(storageFilePath) then
            Storage.Data = Decode(readfile(storageFilePath) or "{}")
        end
    end)
    spawn(function()
        while task.wait(Storage.WRITE_DELAY) do
            Storage:Save()
        end
    end)
    CreateTraceback("Initalize", "Initalizing script..")
    SetTask("MainTask", "Starting Kaitun Hub...")
    SetTask("SubTask", "Initializing Tasks...")
    function RefreshTasksData()
        if _G.Stop then
            return
        end
        TaskWarned = TaskWarned or {}
        for _, taskName in ipairs(TasksOrder) do
            local taskModule = FunctionsHandler[taskName]
            if taskModule and taskModule.Initalized then
                local refreshMethod = taskModule.Methods.Refresh
                local startMethod = taskModule.Methods.Start
                if refreshMethod and startMethod then
                    local ok, refreshResult = pcall(function()
                        return refreshMethod:Call()
                    end)
                    if ok and refreshResult then
                        CurrentTask = taskName
                        if ScriptStorage.Interface and ScriptStorage.Interface.SetText then
                            ScriptStorage.Interface.SetText("DebugLine", taskName)
                        end
                        pcall(function()
                            startMethod:Call(refreshResult)
                        end)
                        return
                    end
                end
            elseif not TaskWarned[taskName] then
                DebugLog("[ Debug ] Task", taskName, "is not registered yet")
                TaskWarned[taskName] = true
            end
        end
    end
    SetText("MainTextLabel", "Refreshing Player Items..")
    AddPoint()
    QuestManager:RefreshQuest()
    RefreshInventory()
    Remotes.CommE.OnClientEvent:Connect(function(...)
        local eventPayload = { ... }
        if eventPayload[1] and string.find(tostring(eventPayload[1]), "Item") then
            RefreshInventory()
        end
    end)
    RefreshRace()
    playersService.LocalPlayer.Idled:Connect(function()
        Services.VirtualUser:CaptureController()
        Services.VirtualUser:ClickButton2(Vector2.new())
    end)
    SetText("MainTextLabel", "Loaded In " .. tick() - StartTick .. "ms!")
    QueueList = {}
    function NearbyHopHandler()
        if not Config.Configuration.HopWhenNearbyPlayer then
            return
        end
        if NearbyHopHandlerDebounce and os.time() - NearbyHopHandlerDebounce < 10 then
            return
        end
        NearbyHopHandlerDebounce = os.time()
        for _, otherPlayer in playersService:GetPlayers() do
            local otherPos = otherPlayer
                and otherPlayer.Character
                and otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                and otherPlayer.Character.HumanoidRootPart.Position
            if otherPos then
                local queuedSince = QueueList[otherPlayer.Name]
                if not queuedSince then
                    QueueList[otherPlayer.Name] = os.time()
                else
                    if os.time() - queuedSince > 30 then
                        if CaculateDistance(otherPos) < 100 then
                            Hop("nearby plr")
                            task.wait(5)
                        else
                            QueueList[otherPlayer.Name] = nil
                        end
                    end
                end
            end
        end
    end
    local lastDataRefresh = 0
    local lastFileWrite = 0
    task.spawn(function()
        while task.wait(0.2) do
            if not _G.Stop then
                NearbyHopHandler()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Sit then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                local now = os.time()
                if now - lastDataRefresh >= 1 then
                    lastDataRefresh = now
                    pcall(RefreshPlayerData)
                    local elapsed = now - FarmStartTime
                    local currentSession = elapsed + OldSessionTime
                    if now - lastFileWrite >= 5 then
                        lastFileWrite = now
                        pcall(function()
                            if typeof(writefile) == "function" then
                                writefile(".tdif-" .. game.Players.LocalPlayer.Name, tostring(currentSession))
                            end
                        end)
                    end
                    if ScriptStorage.Interface then
                        SetText(
                            "LiveTime",
                            "Total Elapsed Time: "
                                .. DispTime(currentSession, true)
                                .. " Elapsed Time: "
                                .. DispTime(elapsed, true)
                        )
                    end
                end
            end
        end
    end)
    AddPoint()
    Remotes.CommF_:InvokeServer("Cousin", "DLCBoxData")
    task.spawn(function()
        task.wait(Config.Configuration.AutoHopDelay)
        if Config.Configuration.AutoHop then
            Hop("Autohop")
        end
    end)
    -- Farm Hallow Essence (đổi Bones) để triệu hồi Soul Reaper - chạy độc lập,
    -- không chiếm slot ưu tiên của RefreshTasksData nên không chặn các task khác
    -- (LevelFarm, BossesTask...) trong lúc chờ roll ra được essence.
    task.spawn(function()
        while getgenv().AutoKaitun do
            task.wait(1)
            if
                not _G.Stop
                and SeaIndex == 3
                and ScriptStorage.PlayerData.Level >= 1500
                and not ScriptStorage.Tools["Hallow Essence"]
            then
                local boneCount = (ScriptStorage.Backpack.Bones and ScriptStorage.Backpack.Bones.Count) or 0
                if boneCount >= 50 then
                    local soulReaper = ScriptStorage.Enemies["Soul Reaper"]
                    local alreadySpawned = soulReaper
                        and soulReaper:FindFirstChild("Humanoid")
                        and soulReaper.Humanoid.Health > 0
                    if not alreadySpawned then
                        pcall(function()
                            Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                        end)
                        task.wait(1)
                    end
                end
            end
        end
    end)
    while task.wait() do
        if not getgenv().AutoKaitun then
            break
        end
        if Config.Configuration.HopWhenIdle and LastIdling and os.time() - LastIdling > 300.0 then
            Hop("Idle timeout")
        end
        if not AnimationDelay or os.time() - AnimationDelay > 60 then
            AnimationDelay = os.time()
            LocalPlayer.Character:WaitForChild("Humanoid"):LoadAnimation(FarmAnimation):Play()
        end
        FunctionsHandler.MeleesController.Methods.Start:Call()
        local taskSuccess, taskError = xpcall(RefreshTasksData, debug.traceback)
        if not taskSuccess then
            Report("Lỗi trong quá trình thực thi tác vụ: " .. tostring(taskError), "LỖI TÁC VỤ")
        end
    end

    -- ==============================================================================
    -- 📊 DISCORD WEBHOOK NOTIFICATION SYSTEM (THỐNG KÊ TÀI KHOẢN & TÚI ĐỒ)
    -- ==============================================================================
    local function StartWebhookMonitor()
        local function GetPlayerStats()
            local stats = { Level = 0, Beli = 0, Frag = 0, Race = "Unknown" }
            pcall(function()
                local data = LocalPlayer:FindFirstChild("Data")
                if data then
                    stats.Level = data:FindFirstChild("Level") and data.Level.Value or 0
                    stats.Beli = data:FindFirstChild("Beli") and data.Beli.Value or 0
                    stats.Frag = data:FindFirstChild("Fragments") and data.Fragments.Value or 0
                    stats.Race = data:FindFirstChild("Race") and data.Race.Value or "Unknown"
                end
            end)
            return stats
        end

        local function GetInventoryData()
            local itemsList = {}
            local invMap = {}
            if ScriptStorage and ScriptStorage.Backpack then
                for itemName, itemData in pairs(ScriptStorage.Backpack) do
                    invMap[itemName] = true
                    local count = itemData.Count or 1
                    if count > 1 then
                        table.insert(itemsList, "• " .. tostring(itemName) .. " (x" .. tostring(count) .. ")")
                    else
                        table.insert(itemsList, "• " .. tostring(itemName))
                    end
                end
            end
            table.sort(itemsList)
            return itemsList, invMap
        end

        local function GetFarmingStatus(invMap)
            local status = {}
            local okG, resG = pcall(function()
                return Remotes.CommF_:InvokeServer("BuyGodhuman", true)
            end)
            status.GodHuman = (okG and (resG == 1 or resG == 2))
                or (ScriptStorage.Melees and ScriptStorage.Melees["Godhuman"] ~= nil)

            local function checkItem(itemName)
                return (invMap and invMap[itemName])
                    or (ScriptStorage.Backpack and ScriptStorage.Backpack[itemName] ~= nil)
                    or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(itemName) ~= nil)
            end

            status.CDK = checkItem("Cursed Dual Katana")
            status.SG = checkItem("Skull Guitar") or checkItem("Soul Guitar")
            status.Valk = checkItem("Valkyrie Helm")
            status.Mirror = checkItem("Mirror Fractal")

            local okL, resL = pcall(function()
                return Remotes.CommF_:InvokeServer("CheckTempleDoor")
            end)
            status.PullLever = (okL and (resL == true or resL == "true"))
                or (Storage and Storage.Get and Storage:Get("LeverPulledCompleted"))

            local okRgb, resRgb = pcall(function()
                return Remotes.CommF_:InvokeServer("HornedMan", "Bet")
            end)
            status.RainbowHaki = (okRgb and resRgb == 1)
                or (Storage and Storage.Get and Storage:Get("RainbowHakiCompleted"))

            status.Sea3 = (SeaIndex == 3)
            return status
        end

        local function GetStatusIcon(condition)
            return condition and "🟢" or "🔴"
        end

        local function FormatNumber(n)
            if not n then
                return "0"
            end
            local s = tostring(math.floor(n))
            local result, count = "", 0
            for i = #s, 1, -1 do
                count = count + 1
                result = s:sub(i, i) .. result
                if count % 3 == 0 and i ~= 1 then
                    result = "," .. result
                end
            end
            return result
        end

        local function SendWebhook()
            local currentSettings = getgenv().SettingFarm or {}
            local webhookCfg = currentSettings["Webhook"]
            if not webhookCfg or not webhookCfg["Enabled"] then
                return
            end

            local webhookUrl = webhookCfg["WebhookUrl"]
            if not webhookUrl or webhookUrl == "" or webhookUrl == "link url" then
                return
            end

            local stats = GetPlayerStats()
            local items, invMap = GetInventoryData()
            local farmStatus = GetFarmingStatus(invMap)

            local userName = LocalPlayer.Name
            local dispName = LocalPlayer.DisplayName
            local timeStr = GetCurrentDateTime()

            local invStr = (#items == 0) and "_No items in inventory_" or table.concat(items, "\n")

            if string.len(invStr) > 1000 then
                invStr = string.sub(invStr, 1, 980) .. "\n...[ And more items ]"
            end

            local farmStr = string.format(
                "GodHuman           : %s\nCursed Dual Katana : %s\nSkull Guitar       : %s\nValkyrie Helm      : %s\nMirror Fractal     : %s\nPull Lever         : %s\nRainbow Haki       : %s\nSea 3              : %s",
                GetStatusIcon(farmStatus.GodHuman),
                GetStatusIcon(farmStatus.CDK),
                GetStatusIcon(farmStatus.SG),
                GetStatusIcon(farmStatus.Valk),
                GetStatusIcon(farmStatus.Mirror),
                GetStatusIcon(farmStatus.PullLever),
                GetStatusIcon(farmStatus.RainbowHaki),
                GetStatusIcon(farmStatus.Sea3)
            )

            local pingStr = (webhookCfg["Auto Ping"] and webhookCfg["Ping Id"] and webhookCfg["Ping Id"] ~= "")
                    and ("<@" .. webhookCfg["Ping Id"] .. ">")
                or ""
            local imageUrl = "https://cdn.discordapp.com/attachments/1395142660611637388/1515593779497799700/image0.png"

            local embed = {
                title = "NatAovHub Kaitun Notification",
                color = 0x00BFFF,
                fields = {
                    {
                        name = "👤 Player",
                        value = "```\nUser Name    : " .. userName .. "\nDisplay Name : " .. dispName .. "\n```",
                        inline = false,
                    },
                    {
                        name = "📊 Account Stats",
                        value = "```\nLevel : " .. FormatNumber(stats.Level) .. "\nBeli  : " .. FormatNumber(
                            stats.Beli
                        ) .. "\nFrag  : " .. FormatNumber(stats.Frag) .. "\nRace  : " .. stats.Race .. "\n```",
                        inline = false,
                    },
                    {
                        name = "⚙️ Farming Status",
                        value = "```\n" .. farmStr .. "\n```",
                        inline = false,
                    },
                    {
                        name = "🎒 Inventory",
                        value = "```\n" .. invStr .. "\n```",
                        inline = false,
                    },
                },
                image = { url = imageUrl },
                footer = { text = "NatAovHub Kaitun • " .. timeStr },
            }

            local httpReq = request
                or http_request
                or (syn and syn.request)
                or (getgenv and getgenv().http and getgenv().http.request)
            if not httpReq then
                return
            end

            pcall(function()
                httpReq({
                    Url = webhookUrl,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = game:GetService("HttpService"):JSONEncode({
                        content = (pingStr ~= "") and pingStr or nil,
                        embeds = { embed },
                    }),
                })
            end)
        end

        task.spawn(function()
            while true do
                local currentSettings = getgenv().SettingFarm or {}
                local webhookCfg = currentSettings["Webhook"]
                local delayTime = (webhookCfg and tonumber(webhookCfg["Delay Send"])) or 60
                task.wait(delayTime)
                if getgenv().AutoKaitun and not _G.Stop then
                    pcall(SendWebhook)
                end
            end
        end)
    end
    StartWebhookMonitor()
end

-- ==============================================================================
-- BỘ ĐIỀU KHIỂN BẬT / TẮT KAITUN QUA getgenv().AutoKaitun
-- ==============================================================================
getgenv().AutoKaitun = (getgenv().AutoKaitun == nil) and false or getgenv().AutoKaitun

-- Huỷ mọi tween đang chạy + trả lại trạng thái bình thường cho player,
-- không để các hàm tween của Kaitun giữ player lại
local function KaitunRestorePlayerState()
    pcall(function()
        if TweenInstance then
            TweenInstance:Cancel()
        end
    end)

    local plr = game.Players.LocalPlayer
    local char = plr and plr.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        local head = char:FindFirstChild("Head")
        if head then
            local eltrul = head:FindFirstChild("eltrul")
            if eltrul then
                eltrul:Destroy()
            end
        end
    end

    local function DisconnectAll(node)
        if typeof(node) == "RBXScriptConnection" then
            pcall(function()
                node:Disconnect()
            end)
        elseif typeof(node) == "table" then
            for _, connection in pairs(node) do
                DisconnectAll(connection)
            end
        end
    end
    if ScriptStorage and ScriptStorage.Connections then
        DisconnectAll(ScriptStorage.Connections)
    end

    if getgenv().NatAov_SetMainTask then
        pcall(getgenv().NatAov_SetMainTask, "Disabled")
    end
    if getgenv().NatAov_SetSubTask then
        pcall(getgenv().NatAov_SetSubTask, "Disabled")
    end
end

-- Đồng bộ _G.Stop liên tục theo công tắc AutoKaitun (chặn TweenController tạo tween mới ngay khi tắt)
task.spawn(function()
    while true do
        _G.Stop = not getgenv().AutoKaitun
        task.wait(0.1)
    end
end)

task.spawn(function()
    local consecutiveFailures = 0
    while true do
        repeat
            task.wait()
        until getgenv().AutoKaitun
        _G.Stop = false
        local ok, err = pcall(sigmahub)
        KaitunRestorePlayerState()
        if ok then
            consecutiveFailures = 0
        else
            consecutiveFailures = consecutiveFailures + 1
            if getgenv().NatAov_Notify then
                pcall(
                    getgenv().NatAov_Notify,
                    "Kaitun Báo Lỗi",
                    "Gặp lỗi (" .. consecutiveFailures .. "/3): " .. tostring(err)
                )
            end
            if consecutiveFailures >= 3 then
                if getgenv().NatAov_Notify then
                    pcall(
                        getgenv().NatAov_Notify,
                        "Kaitun Dừng An Toàn",
                        "Đã tạm dừng sau 3 lỗi liên tiếp. Tắt rồi bật lại Auto Kaitun để tiếp tục."
                    )
                end
                consecutiveFailures = 0
                repeat
                    task.wait()
                until not getgenv().AutoKaitun
            end
        end
    end
end)