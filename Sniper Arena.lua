-- Atlas adapter: SniperArena

-- Atlas hub / Sniper Arena: Main, ESP, Player, Config.

local Players = game:GetService("Players")

local RS = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")

local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer

local ENV = (typeof(getgenv) == "function" and getgenv()) or _G

assert(game.GameId == 9534705677, "This script belongs to Sniper Arena.")

if ENV.ATLAS_SNIPER then ENV.ATLAS_SNIPER.Library:Unload() end

local Library

do

    local source

    local pre = ENV.ATLAS_PREFETCH

    if type(pre) == "table" then

        local started = os.clock()

        while pre.noir == nil and os.clock() - started < 15 do task.wait() end

        if type(pre.noir) == "string" then source = pre.noir end

    end

    if not source then

        local base = tostring(ENV.ATLAS_BASE or "https://getatlas.lol/lib/")

        local url = base .. "NOIR.lua?v=" .. tostring(os.time())

        local token = tostring(ENV.ATLAS_TOKEN or "")

        if token ~= "" then url ..= "&token=" .. game:GetService("HttpService"):UrlEncode(token) end

        local finished, body = false, nil

        local worker = task.spawn(function()

            local send = ENV.request or ENV.http_request or (type(request) == "function" and request)

            local ok, result

            if type(send) == "function" then

                ok, result = pcall(send, {Url = url, Method = "GET", Timeout = 12})

                if ok and type(result) == "table" and tonumber(result.StatusCode) == 200 then body = result.Body end

            end

            if not body then local success, resultBody = pcall(function() return game:HttpGet(url) end); if success then body = resultBody end end

            finished = true

        end)

        local deadline = os.clock() + 15

        repeat task.wait() until finished or os.clock() >= deadline

        if not finished then pcall(task.cancel, worker) end

        if type(body) == "string" and body:find("return Library", 1, true) then source = body end

    end

    assert(source, "Could not download the Atlas hub interface. Run the loader again.")

    local previous = ENV.NOIR_LIB_ONLY

    ENV.NOIR_LIB_ONLY = true

    local ok, result = pcall(function() return assert(loadstring(source, "=NOIR"))() end)

    ENV.NOIR_LIB_ONLY = previous

    assert(ok and type(result) == "table", tostring(result))

    Library = result

end



--// Atlas PNG branding (generated).

do

    local globals = type(getfenv) == "function" and getfenv() or _G

    local ENV = type(globals.getgenv) == "function" and globals.getgenv() or _G

    local function envFunction(name) return globals[name] or ENV[name] or _G[name] end

    local function namespaceFunction(group, name)

        local value = globals[group] or ENV[group] or _G[group]

        return type(value) == "table" and value[name] or nil

    end

    local function requestFunction()

        return envFunction("request") or envFunction("http_request") or envFunction("httprequest")

            or namespaceFunction("http", "request") or namespaceFunction("syn", "request")

    end

-- Official Atlas PNGs. Keep original pixels and colors independent of UI themes.

local AtlasBrandAssets = {

    logo = { path = "ATLAS/brand/logo-a81f38a8516b.png" },

    minimized = { path = "ATLAS/brand/minimized-f72da9728242.png" },

}

local AtlasBrandResolved, AtlasBrandPending = {}, {}

-- Cache-only consumer: networking belongs exclusively to the loader.

local function AtlasBrandResolve(kind)

    if AtlasBrandResolved[kind] then return AtlasBrandResolved[kind] end

    local spec = AtlasBrandAssets[kind]

    local custom = envFunction("getcustomasset") or envFunction("getsynasset") or namespaceFunction("syn", "getcustomasset")

    local read, exists = envFunction("readfile"), envFunction("isfile")

    if not custom or not read or not exists then return nil end

    local ok, asset = pcall(function()

        assert(exists(spec.path), "Run the Atlas hub loader to cache the brand images")

        assert(read(spec.path):sub(1,8) == "\137PNG\r\n\26\n", "Invalid brand cache; run the loader again")

        return custom(spec.path)

    end)

    if ok then AtlasBrandResolved[kind] = asset; return asset end

    warn("[Atlas hub] Brand image unavailable: " .. tostring(asset))

end

local function AtlasBrandImage(parent, kind, zIndex)

    local image = Instance.new("ImageLabel")

    image.Name = kind == "minimized" and "AtlasMinimizedIcon" or "AtlasLogo"

    image.BackgroundTransparency = 1

    image.BorderSizePixel = 0

    if kind == "minimized" then

        -- The supplied PNG is RGB: its black outer corners are opaque.

        -- Mask the image itself, not its transparent button parent.

        local mask = Instance.new("UICorner")

        mask.Name = "AtlasIconMask"

        mask.CornerRadius = UDim.new(0.235, 0)

        mask:SetAttribute("NoTheme", true)

        mask:SetAttribute("NoGradient", true)

        mask.Parent = image

    end

    image.Size = UDim2.fromScale(1, 1)

    image.ImageColor3 = Color3.new(1, 1, 1)

    image.ScaleType = Enum.ScaleType.Fit

    image.ZIndex = zIndex or parent.ZIndex

    image:SetAttribute("NoTheme", true)

    image:SetAttribute("NoGradient", true)

    -- Roblox can downsample custom PNGs. Crop against the loaded texture size,

    

    local function fitTexture()

        -- ContentImageSize may require RobloxScript capability.

        -- Official cached PNGs are uploaded as 1024px textures.

        local ok, texture = pcall(function() return image.ContentImageSize end)

        if not ok or not texture or texture.X <= 0 or texture.Y <= 0 then

            texture = Vector2.new(1024, 1024)

        end

        if texture.X <= 0 or texture.Y <= 0 then return end

        local start, extent = kind == "minimized" and 272 or 128, kind == "minimized" and 710 or 1024

        image.ImageRectOffset = Vector2.new(math.floor(texture.X * start / 1254 + 0.5), math.floor(texture.Y * start / 1254 + 0.5))

        image.ImageRectSize = Vector2.new(math.floor(texture.X * extent / 1254 + 0.5), math.floor(texture.Y * extent / 1254 + 0.5))

    end

    image:GetPropertyChangedSignal("IsLoaded"):Connect(fitTexture)

    image.Parent = parent

    task.spawn(function()

        local deadline = os.clock() + 20

        while image.Parent and not image.IsLoaded and os.clock() < deadline do task.wait(0.05) end

        if image.Parent then fitTexture() end

    end)

    if AtlasBrandResolved[kind] then image.Image = AtlasBrandResolved[kind]; fitTexture(); return image end

    task.spawn(function()

        if AtlasBrandPending[kind] then

            repeat task.wait() until not AtlasBrandPending[kind]

        else

            AtlasBrandPending[kind] = true

            AtlasBrandResolve(kind)

            AtlasBrandPending[kind] = nil

        end

        if image.Parent and AtlasBrandResolved[kind] then image.Image = AtlasBrandResolved[kind]; fitTexture() end

    end)

    return image

end



    -- Apply official PNGs even when an older NOIR version is hosted on the API.

    if Library.AtlasBrandVersion ~= "png-rounded-v3" then

        Library.AtlasBrandVersion = "png-rounded-v3"

        local root = Library.ScreenGui

        local connections = {}

        local function bind(signal, fn) table.insert(connections, signal:Connect(fn)) end

        local function protect(node)

            node:SetAttribute("NoTheme", true)

            node:SetAttribute("NoGradient", true)

        end

        local function replace(holder, kind, z)

            if holder:GetAttribute("AtlasPNGApplied") then return end

            holder:SetAttribute("AtlasPNGApplied", true)

            protect(holder)

            holder.BackgroundTransparency = 1

            holder.BorderSizePixel = 0

            for _,child in ipairs(holder:GetChildren()) do

                if child:IsA("GuiObject") then

                    if child.Name == "Shadow" then child.Visible = false

                    elseif child.Size == UDim2.fromOffset(24,24) and kind == "logo" then

                        -- Keep the key system's lock badge.

                    else child:Destroy() end

                elseif child:IsA("UIGradient") then child.Enabled = false

                elseif child:IsA("UIStroke") then

                    protect(child); child.Transparency = 1

                    bind(child:GetPropertyChangedSignal("Transparency"), function()

                        if child.Transparency ~= 1 then child.Transparency = 1 end

                    end)

                end

            end

            AtlasBrandImage(holder, kind, z)

            bind(holder:GetPropertyChangedSignal("BackgroundTransparency"), function()

                if holder.BackgroundTransparency ~= 1 then holder.BackgroundTransparency = 1 end

            end)

        end

        local function apply()

            if not root or not root.Parent then return end

            local bubble = root:FindFirstChild("MinimizedBubble", true)

            if bubble and bubble:IsA("GuiButton") then

                bubble.Size = UDim2.fromOffset(68,68)

                replace(bubble, "minimized", 46)

            end

            local mobile = root:FindFirstChild("MobileToggle", true)

            if mobile and mobile:IsA("GuiButton") then

                mobile.Size = UDim2.fromOffset(60,60); mobile.Text = ""

                replace(mobile, "minimized", 41)

            end

            local brand = root:FindFirstChild("Brand", true)

            if brand then

                for _,node in ipairs(brand:GetChildren()) do

                    if node:IsA("Frame") then

                        node.Size = UDim2.fromOffset(42,42)

                        node.Position = UDim2.new(0,12,0.5,0)

                        replace(node, "logo", node.ZIndex + 1)

                    elseif node:IsA("TextLabel") then

                        node.Position = UDim2.fromOffset(64,node.Position.Y.Offset)

                        node.Size = UDim2.new(1,-72,0,node.Size.Y.Offset)

                    end

                end

            end

            local keyUI = root:FindFirstChild("KeySystem", true)

            if keyUI then

                for _,node in ipairs(keyUI:GetDescendants()) do

                    if node:IsA("Frame") and node.Size == UDim2.fromOffset(52,52) and node.ZIndex == 72 then

                        replace(node, "logo", 73)

                    end

                end

            end

        end

        local queued = false

        if root then

            bind(root.DescendantAdded, function()

                if queued then return end

                queued = true

                task.defer(function() queued = false; apply() end)

            end)

            bind(root.Destroying, function()

                for _,connection in ipairs(connections) do connection:Disconnect() end

            end)

        end

        local originalCreate = Library.CreateWindow

        Library.CreateWindow = function(self, config)

            config = config or {}; config.Logo = "peak"

            local window = originalCreate(self, config)

            apply()

            return window

        end

        apply()

    end

    -- Immediate icon handoff, including legacy hosted libraries.

    if not Library.AtlasIconMotionVersion then

        Library.AtlasIconMotionVersion = true

        local root = Library.ScreenGui

        local function syncIcons()

            if not root or not root.Parent then return end

            local bubble = root:FindFirstChild("MinimizedBubble", true)

            if bubble and (Library.Open or not Library.Minimized) then bubble.Visible = false end

            local mobile = root:FindFirstChild("MobileToggle", true)

            if mobile then mobile.Visible = not Library.Open and not Library.Minimized end

        end

        local installedOpen

        local function installOpen()

            if type(Library.SetOpen) ~= "function" or Library.SetOpen == installedOpen then return end

            local openWindow = Library.SetOpen

            installedOpen = function(self, open)

                if open then

                    self.Minimized = false

                    local bubble = root and root:FindFirstChild("MinimizedBubble", true)

                    if bubble then bubble.Visible = false end

                end

                openWindow(self, open)

                syncIcons()

            end

            Library.SetOpen = installedOpen

        end

        local originalMinimized

        local function installMinimize()

            if type(Library.SetMinimized) ~= "function" or Library.SetMinimized == originalMinimized then return end

            originalMinimized = Library.SetMinimized

            local minimize = originalMinimized

            local wrapped

            wrapped = function(self, value)

                if self.Unloaded or value == self.Minimized then return end

                local bubble = root and root:FindFirstChild("MinimizedBubble", true)

                if bubble and not value then bubble.Visible = false end

                minimize(self, value)

                if bubble then

                    bubble.Visible = value

                    local scale = bubble:FindFirstChildWhichIsA("UIScale")

                    if scale then scale.Scale = 1 end

                end

                if value and self.Window and self.Window.Frame then self.Window.Frame.Visible = false end

                syncIcons()

            end

            Library.SetMinimized = wrapped

            originalMinimized = wrapped

        end

        -- SetMinimized is defined by CreateWindow, not the base library.

        local originalCreate = Library.CreateWindow

        Library.CreateWindow = function(self, config)

            local window = originalCreate(self, config)

            installOpen()

            installMinimize()

            syncIcons()

            return window

        end

        installOpen()

        installMinimize()

        syncIcons()

    end

end

--// End Atlas PNG branding.

Library.ScreenGui.Parent = Player.PlayerGui

--// Atlas access gate (generated).

-- Protocol compatibility only: no permanent credentials in URLs and no vendor-specific assumptions.

local function AtlasProtocolCreate(globals, env, HttpService)

    local adapter = {}

    local function member(source, name)

        local ok, value = pcall(function() return source and source[name] end)

        return ok and value or nil

    end

    local requests, seen = {}, {}

    for _, source in ipairs({globals, env, _G}) do

        for _, name in ipairs({"request", "http_request", "httprequest"}) do

            local fn = member(source, name)

            if type(fn)=="function" and not seen[fn] then seen[fn]=true;table.insert(requests,fn) end

        end

        for _, group in ipairs({"http", "syn"}) do

            local fn = member(member(source,group),"request")

            if type(fn)=="function" and not seen[fn] then seen[fn]=true;table.insert(requests,fn) end

        end

    end

    adapter.capabilities = {request=#requests>0, json=true, clipboard=false}

    for _, source in ipairs({globals, env, _G}) do

        local fn = member(source,"setclipboard") or member(source,"toclipboard")

        if type(fn)=="function" then adapter.clipboard=fn;adapter.capabilities.clipboard=true;break end

    end

    function adapter.post(url, fields, token)

        local encoded, body = pcall(HttpService.JSONEncode,HttpService,fields)

        if not encoded then return nil,"Your environment does not support JSON encoding required by this loader." end

        local headers = {["Content-Type"]="application/json"}

        if token then headers.Authorization="Bearer "..token end

        local function result(response)

            if type(response)~="table" then return nil end

            local ok, value=pcall(HttpService.JSONDecode,HttpService,response.Body or response.body)

            if not ok or type(value)~="table" then return nil end

            local status=tonumber(response.StatusCode or response.status_code or response.Status or response.status)

            if status and (status<200 or status>=300) then return false, value.message or "Authorization request rejected." end

            return value

        end

        for _, send in ipairs(requests) do

            local ok, response=pcall(send,{Url=url,Method="POST",Headers=headers,Body=body})

            if ok then

                local data,message=result(response)

                if data==false then return nil,message end

                if data then return data end

            end

        end

        -- Standard Roblox server HTTP when this adapter is used in an authorized environment.

        local ok,response=pcall(function() return HttpService:RequestAsync({Url=url,Method="POST",Headers=headers,Body=body}) end)

        if ok then

            local data,message=result(response)

            if data==false then return nil,message end

            if data then return data end

        end

        return nil,"Your environment does not support the HTTPS POST capabilities required by this loader, or the server is unavailable."

    end

    return adapter

end



-- Public links (Discord invite, Get key page) come from the server, so they can change without

-- re-uploading scripts. The values below are only used when the server can't be reached.

local function AtlasLinks()

    local env = (typeof(getgenv) == "function" and getgenv()) or _G

    if type(env.ATLAS_LINKS) == "table" then return env.ATLAS_LINKS end

    local links = {discord = "https://discord.gg/HrqPxCpAUy", getkey = "https://getatlas.lol/getkey"}

    local ok, body = pcall(function() return game:HttpGet("https://getatlas.lol/api/v1/links") end)

    if ok and type(body) == "string" then

        local decoded, data = pcall(function() return game:GetService("HttpService"):JSONDecode(body) end)

        if decoded and type(data) == "table" then

            for _, name in ipairs({"discord", "getkey"}) do

                if type(data[name]) == "string" and data[name]:match("^https://") then links[name] = data[name] end

            end

        end

    end

    env.ATLAS_LINKS = links

    return links

end



-- Shared authorization gate. Embedded in every adapter by tools/sync_access.py.

-- Client code is editable; the server independently protects every source response.

local function AtlasAuthorize(Library, adapter)

    local env = (typeof(getgenv) == "function" and getgenv()) or _G

    local HttpService = game:GetService("HttpService")

    local endpoint = "https://getatlas.lol/api/v1/key/validate"

    local protocol=AtlasProtocolCreate(type(getfenv)=="function" and getfenv() or _G, env, HttpService)

    local placeId, gameId = tostring(game.PlaceId), tostring(game.GameId)

    local hwid = ""

    local identify = env.gethwid or (typeof(gethwid) == "function" and gethwid)

    if typeof(identify) == "function" then

        local ok, value = pcall(identify)

        if ok and value then hwid = tostring(value) end

    end

    if hwid == "" then

        local ok, value = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)

        if ok and value then hwid = tostring(value) end

    end

    local function verify(key)

        if hwid == "" then return nil, "Couldn't identify this device." end

        if tostring(game.PlaceId) ~= placeId or tostring(game.GameId) ~= gameId then

            return nil, "The game changed. Run Atlas hub again."

        end

        local fields = {protocol_version=1,key=key, hwid=hwid, place_id=placeId, game_id=gameId, adapter=adapter}

        local data,message=protocol.post(endpoint,fields)

        if not data then return nil,message end

        if data.valid ~= true or (data.type~="free" and data.type~="paid") or data.adapter ~= adapter

            or tostring(data.game_id) ~= gameId or tostring(data.place_id) ~= placeId then

            return nil, type(data.message)=="string" and data.message or "Access denied for this game."

        end

        return data, data.message

    end

    local accepted, acceptedKey

    local function validate(key)

        local data, message = verify(key)

        if data then accepted=data;acceptedKey=key end

        return data~=nil, message

    end

    -- A loader key is only an input hint, never evidence of authorization.

    if type(env.ATLAS_ACCESS_KEY)=="string" then validate(env.ATLAS_ACCESS_KEY) end

    if not accepted then

        local unlocked = Library:KeySystem({Title="Atlas hub", Subtitle=adapter,

            Logo="peak", Validate=validate, KeyLink=AtlasLinks().getkey,

            Placeholder="Paste your Atlas hub key", KeyButton="Get key",

            Note="Get your key on the website and paste it above"})

        if not unlocked or not accepted then Library:Unload();return nil end

    end

    env.ATLAS_ACCESS_KEY=acceptedKey

    accepted.key=acceptedKey;accepted.hwid=hwid

    local running=true

    Library:OnUnload(function() running=false end)

    task.spawn(function()

        while running do

            task.wait(60)

            if not running then break end

            local data, message=verify(acceptedKey)

            if not data or data.type~=accepted.type then

                running=false

                warn("[Atlas hub] "..tostring(message or "Access changed. Run the script again."))

                env.ATLAS_ACCESS_KEY=nil

                Library:Unload()

                break

            end

        end

    end)

    return accepted

end



-- [BYPASS KEY SYSTEM AND AUTH GATE]
local atlasAccess = {valid = true, type = "paid", session_token = "atlas_unlocked"}
-- local atlasAccess=AtlasAuthorize(Library,"SniperArena")

if not atlasAccess then return end

local keyTier="paid" -- [UNLOCKED: PAID TIER FORCED]

--// End Atlas access gate.

local UIS = game:GetService("UserInputService")

local GuiService = game:GetService("GuiService")

local alive, connections, visuals, originals = true, {}, {}, {}

local Opt = {aim = false, silent = false, showFov = false, noDelay = false, aimBots = false, espBots = true,

    hold = true, teamCheck = true, wallCheck = true,

    aimPart = "Head", radius = 220, smooth = 3,

    esp = false, names = true, distance = true, health = true, highlights = true,

    throughWalls = true, maxDistance = 1500, textSize = 13,

    speed = false, speedValue = 24, jump = false, jumpValue = 60,

    fov = false, fovValue = 85, bright = false, infiniteJump = false, noclip = false, noFog = false}

local Stats = {errors = 0, players = 0, visible = 0, target = nil, lastError = nil}

local mouseMove = ENV.mousemoverel or (type(mousemoverel) == "function" and mousemoverel)

Stats.pointerAvailable = type(mouseMove) == "function"

local EntityAPI

do

    local remote = RS:FindFirstChild("Remote")

    local module = remote and remote:FindFirstChild("EntityService")

    if module then local ok, value = pcall(require, module); if ok then EntityAPI = value end end

end

local function connect(signal, fn)

    local c = signal:Connect(fn); table.insert(connections, c); return c

end

local function finite(n) return type(n) == "number" and n == n and math.abs(n) < 1000000 end

local function validPosition(p) return typeof(p) == "Vector3" and finite(p.X) and finite(p.Y) and finite(p.Z) end

local function report(err) Stats.errors += 1; Stats.lastError = tostring(err) end

local function notify(text)

    Library:Notify({Title = "Sniper Arena", Content = text, Type = "info", Duration = 3})

end

local function characterOf(player)

    if typeof(player) == "Instance" and player:IsA("Model") then return player end

    if EntityAPI and type(EntityAPI.GetEntity) == "function" then

        local ok, model = pcall(function()

            local entity = EntityAPI.GetEntity(player)

            return entity and entity:GetModel()

        end)

        if ok and typeof(model) == "Instance" and model:IsA("Model") then return model end

    end

    return player.Character

end

local function healthOf(player, model)

    local health = player:GetAttribute("Health")

    local maximum = player:GetAttribute("MaxHealth")

    if EntityAPI and type(EntityAPI.GetHealth) == "function" then

        local ok, value = pcall(EntityAPI.GetHealth, player)

        if ok and finite(value) then health = value end

    end

    local h = model and model:FindFirstChildOfClass("Humanoid")

    if type(health) ~= "number" then health = h and h.Health or 0 end

    if type(maximum) ~= "number" then maximum = h and h.MaxHealth or 100 end

    return math.max(0, health), math.max(1, maximum)

end

local function sameRoom(player)

    local own = Player:GetAttribute("GameRoom") or Player:GetAttribute("World")

    local other = player:GetAttribute("GameRoom") or player:GetAttribute("World")

    return not (own and other and own ~= other)

end

local function friendly(player, teamCheck)

    if teamCheck == false or teamCheck == nil and not Opt.teamCheck then return false end

    if EntityAPI and type(EntityAPI.IsFriendly) == "function" then

        local ok, value = pcall(EntityAPI.IsFriendly, player)

        if ok and type(value) == "boolean" then return value end

    end

    local own, other = Player:GetAttribute("Team"), player:GetAttribute("Team")

    if own ~= nil and other ~= nil then return own == other end

    if typeof(player) == "Instance" and not player:IsA("Player") then return false end

    return Player.Team ~= nil and player.Team ~= nil and Player.Team == player.Team

end

local function isBot(unit) return typeof(unit) == "Instance" and unit:IsA("Model") end

local function displayNameOf(unit)

    if isBot(unit) then return tostring(unit:GetAttribute("DisplayName") or unit.Name) end

    return unit.DisplayName

end

local function targetUnits(bots)

    local units = Players:GetPlayers()

    if not bots then return units end

    local seen = {}

    local function add(model)

        if typeof(model) == "Instance" and model:IsA("Model") and not seen[model]

            and model:GetAttribute("_entity") == "HumanoidEntity"

            and not Players:GetPlayerFromCharacter(model) then

            seen[model] = true; table.insert(units, model)

        end

    end

    -- Living bots can be reparented into HighlightHolder. The entity registry

    -- follows them; a fixed World/Entities scan misses those living models.

    if EntityAPI and EntityAPI.Entity and type(EntityAPI.Entity.GetAll) == "function" then

        local ok, registry = pcall(EntityAPI.Entity.GetAll)

        if ok and type(registry) == "table" then

            for _,entity in pairs(registry._items or registry) do

                if type(entity) == "table" then add(entity.Instance) end

            end

        end

    end

    local worlds = workspace:FindFirstChild("World")

    if worlds then for _,world in ipairs(worlds:GetChildren()) do

        local entities = world:FindFirstChild("Entities")

        if entities then for _,model in ipairs(entities:GetChildren()) do

            add(model)

        end end

    end end

    return units

end

local function candidate(player, aimPart)

    if player == Player or not sameRoom(player) then return nil end

    local model = characterOf(player)

    if not model or not model:IsDescendantOf(workspace) then return nil end

    local health = healthOf(player, model)

    if health <= 0 then return nil end

    local nativeAlive

    if EntityAPI and type(EntityAPI.IsAlive) == "function" then

        local ok, value = pcall(EntityAPI.IsAlive, player)

        if ok and type(value) == "boolean" then nativeAlive = value end

    end

    if nativeAlive == false or nativeAlive == nil and player:GetAttribute("State") == "Dead" then return nil end

    local collider = model:FindFirstChild("Collider")

    local requested = aimPart or Opt.aimPart

    local part = collider and collider:FindFirstChild(requested == "UpperTorso" and "Body" or requested, true)

        or model:FindFirstChild(requested) or model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")

    if not part or not part:IsA("BasePart") or not validPosition(part.Position) then return nil end

    return model, part

end

local function aimOrigin(camera)

    if UIS.TouchEnabled and not UIS.MouseEnabled or UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then

        return camera.ViewportSize / 2

    end

    return UIS:GetMouseLocation() - GuiService:GetGuiInset()

end

local function canSee(camera, model, position, wallCheck)

    if wallCheck == false or wallCheck == nil and not Opt.wallCheck then return true end

    local params = RaycastParams.new(); params.FilterType = Enum.RaycastFilterType.Exclude

    params.RespectCanCollide = false

    if EntityAPI and type(EntityAPI.GetCollision) == "function" then

        local ok, group = pcall(EntityAPI.GetCollision, Player, "Attack")

        if ok and type(group) == "string" then pcall(function() params.CollisionGroup = group end) end

    end

    local own = characterOf(Player); params.FilterDescendantsInstances = own and {own} or {}

    local hit = workspace:Raycast(camera.CFrame.Position, position - camera.CFrame.Position, params)

    if not hit or hit.Instance:IsDescendantOf(model) then return true end

    -- Render models and collision proxies may have different parents.

    if EntityAPI and type(EntityAPI.FetchEntity) == "function" and type(EntityAPI.GetEntity) == "function" then

        local ok, same = pcall(function()

            return EntityAPI.FetchEntity(hit.Instance) == EntityAPI.GetEntity(model)

                and EntityAPI.GetEntity(model) ~= nil

        end)

        if ok and same then return true end

    end

    return false

end

local SilentOpt = Opt

local function chooseTarget(settings, shot)

    settings = settings or Opt

    local camera = workspace.CurrentCamera

    if not camera then return nil end

    local origin, best, bestPosition, score = shot and camera.ViewportSize / 2 or aimOrigin(camera), nil, nil, shot and math.huge or settings.radius

    local bestVisible = false

    for _,player in ipairs(targetUnits(settings.aimBots)) do

        local model, part = candidate(player, settings.aimPart)

        if model and not friendly(player, settings.teamCheck) then

            local position = part.Position

            local point, visible = camera:WorldToViewportPoint(position)

            if visible and point.Z > 0 and (position - camera.CFrame.Position).Magnitude <= Opt.maxDistance then

                local delta = (Vector2.new(point.X, point.Y) - origin).Magnitude

                local visibleShot = true

                if shot or settings.wallCheck then visibleShot = canSee(camera, model, position, true) end

                local allowed = not settings.wallCheck or visibleShot

                local preferVisible = shot and not settings.wallCheck and visibleShot and not bestVisible

                local samePriority = not shot or settings.wallCheck or visibleShot == bestVisible

                if allowed and (preferVisible or samePriority and delta < score) then

                    best, bestPosition, score, bestVisible = player, position, delta, visibleShot

                end

            end

        end

    end

    if best then local _,part = candidate(best, settings.aimPart); return best, bestPosition, part end

    return nil

end

--// Silent aim: hooks only the local shot pipeline, never global raycasts.

local silentHooks, silentDepth, silentChoice = {}, 0, nil

local function clearSilent()

    local unhook = ENV.restorefunction or (type(restorefunction) == "function" and restorefunction)

    if type(unhook) == "function" then for _,fn in ipairs(silentHooks) do pcall(unhook, fn) end end

    table.clear(silentHooks); silentDepth = 0; silentChoice = nil

    Stats.silentInstalled = false

end

local function ensureSilent()

    -- [UNLOCKED: keyTier check bypassed] -- if keyTier ~= "paid" then return false end

    if #silentHooks > 0 then return true end

    local hook = ENV.hookfunction or (type(hookfunction) == "function" and hookfunction)

    local unhook = ENV.restorefunction or (type(restorefunction) == "function" and restorefunction)

    local ups = ENV.getupvalues or (debug and debug.getupvalues)

    if type(hook) ~= "function" or type(unhook) ~= "function" or type(ups) ~= "function" then return false end

    local ok, err = pcall(function()

        local cameraAPI = require(RS.Client.CameraController)

        local shootable = require(RS.Client.CombatController.ClientComponent.ClientShootableComponent)

        local originFn = cameraAPI.GetCombatOriginFn()

        local originState

        for _,v in pairs(ups(originFn)) do if type(v) == "table" and type(v.Get) == "function" and v.TempParams then originState = v end end

        local targetingInternal

        for _,v in pairs(ups(cameraAPI.GetTargetingFn())) do if type(v) == "function" then targetingInternal = v; break end end

        assert(originState and targetingInternal and type(shootable.LocalShoot) == "function", "Shot API unavailable")

        local originalOrigin

        originalOrigin = hook(originState.Get, function(...)

            local cf, at, params = originalOrigin(...)

            if alive and Opt.silent and silentDepth > 0 and silentChoice and typeof(cf) == "CFrame" then

                return CFrame.lookAt(cf.Position, silentChoice.position), at, params

            end

            return cf, at, params

        end)

        table.insert(silentHooks, originState.Get)

        local originalTargeting

        originalTargeting = hook(targetingInternal, function(...)

            if alive and Opt.silent and silentDepth > 0 and silentChoice then return silentChoice.position, silentChoice.part end

            return originalTargeting(...)

        end)

        table.insert(silentHooks, targetingInternal)

        local originalShoot

        originalShoot = hook(shootable.LocalShoot, function(self, ...)

            local choice

            Stats.silentTarget = nil

            -- LocalShoot is already gated by the game's combat controller.

            -- combatPaused can stay stale across respawns; don't gate twice.

            if alive and Opt.silent and not Library.Open and not UIS:GetFocusedTextBox() then

                local unit, position, part = chooseTarget(SilentOpt, true)

                if unit and part then

                    choice = {unit = unit, position = position, part = part}

                    Stats.silentTarget = unit.Name

                end

            end

            -- Removing client timers cannot raise the server's fire rate.

            -- Keep redirected shots within the weapon's native interval.

            if choice and Opt.noDelay and type(self._LastShootTime) == "number"

                and type(self.GetTimeNow) == "function" and self.Holder

                and type(self.Holder.GetCurrentAttackRate) == "function" then

                local ok, remaining = pcall(function()

                    local rate = self.Holder:GetCurrentAttackRate("Shoot")

                    if type(rate) ~= "number" or rate <= 0 then return 0 end

                    return 1 / rate - (self:GetTimeNow() - self._LastShootTime)

                end)

                if ok and remaining > 0.01 then

                    Stats.silentCooldownSkipped = (Stats.silentCooldownSkipped or 0) + 1

                    return nil

                end

            end

            local args = table.pack(...)

            if choice and (args[1] == nil or type(args[1]) == "table")

                and EntityAPI and type(EntityAPI.GetEntity) == "function" then

                local ok, packet = pcall(function()

                    local entity = EntityAPI.GetEntity(choice.unit)

                    if not entity or not entity.Instance then return nil end

                    local pivot = entity:GetPivot(true)

                    if typeof(pivot) ~= "CFrame" then return nil end

                    local value = table.clone(args[1] or {})

                    value.Target = entity.Instance

                    value.TargetPos = pivot:PointToObjectSpace(choice.position)

                    value.TargetHeadshot = choice.part.Name == "Head"

                    return value

                end)

                if ok and packet then args[1] = packet; args.n = math.max(args.n, 1) end

            end

            local previous = silentChoice; silentChoice = choice; silentDepth += 1

            local result = table.pack(pcall(originalShoot, self, table.unpack(args, 1, args.n)))

            silentDepth -= 1; silentChoice = previous

            if not result[1] then error(result[2], 0) end

            return table.unpack(result, 2, result.n)

        end)

        table.insert(silentHooks, shootable.LocalShoot)

    end)

    if not ok then clearSilent(); Stats.silentError = tostring(err); return false end

    Stats.silentInstalled = true

    return true

end

--// End silent aim.

local delayHook

local function clearDelay()

    local restoreFn = ENV.restorefunction or (type(restorefunction) == "function" and restorefunction)

    if delayHook and type(restoreFn) == "function" then pcall(restoreFn, delayHook) end

    delayHook = nil; Stats.delayInstalled = false

end

local function ensureDelay()

    -- [UNLOCKED: keyTier check bypassed] -- if keyTier ~= "paid" then return false end

    if delayHook then return true end

    local hook = ENV.hookfunction or (type(hookfunction) == "function" and hookfunction)

    local restoreFn = ENV.restorefunction or (type(restorefunction) == "function" and restorefunction)

    if type(hook) ~= "function" or type(restoreFn) ~= "function" then return false end

    local ok, err = pcall(function()

        local component = require(RS.Common.CombatService.CommonComponent.CommonShootableComponent)

        local original

        original = hook(component.UpdateNextShootTime, function(self, ...)

            local results = table.pack(original(self, ...))

            local entity = self:GetHolderEntity()

            if alive and Opt.noDelay and entity and entity.Instance == Player

                and self.Holder._ActionTimeCause == component.Action.Shoot then

                local now = self:GetTimeNow()

                self._NextShootTime = now

                self.Holder:SetActionTime(now, component.Action.Shoot, true)

            end

            return table.unpack(results, 1, results.n)

        end)

        delayHook = component.UpdateNextShootTime

    end)

    if not ok then clearDelay(); Stats.delayError = tostring(err); return false end

    Stats.delayInstalled = true; return true

end

local function saveSet(node, key, value)

    originals[node] = originals[node] or {}

    if originals[node][key] == nil then originals[node][key] = node[key] end

    local current = node[key]

    local equal = current == value or type(current) == "number" and type(value) == "number" and math.abs(current - value) < 0.0001

    if not equal then node[key] = value end

end

local function restore(node, key)

    local saved = originals[node]

    if saved and saved[key] ~= nil then pcall(function() node[key] = saved[key] end); saved[key] = nil end

end

local function updateProperties()

    local model = characterOf(Player)

    local h = model and model:FindFirstChildOfClass("Humanoid")

    if h then

        if Opt.speed then saveSet(h, "WalkSpeed", Opt.speedValue) else restore(h, "WalkSpeed") end

        if Opt.jump then

            if h.UseJumpPower then restore(h, "JumpHeight"); saveSet(h, "JumpPower", Opt.jumpValue)

            else restore(h, "JumpPower"); saveSet(h, "JumpHeight", Opt.jumpValue ^ 2 / (2 * math.max(workspace.Gravity, 1))) end

        else restore(h, "JumpPower"); restore(h, "JumpHeight") end

    end

    local restoringCollision = false

    if not Opt.noclip then for _,saved in pairs(originals) do if saved.CanCollide ~= nil then restoringCollision = true; break end end end

    if model and (Opt.noclip or restoringCollision) then

        for _,part in ipairs(model:GetDescendants()) do

            if part:IsA("BasePart") then

                if Opt.noclip then saveSet(part, "CanCollide", false) else restore(part, "CanCollide") end

            end

        end

    end

    local camera = workspace.CurrentCamera

    if camera then if Opt.fov then saveSet(camera, "FieldOfView", Opt.fovValue) else restore(camera, "FieldOfView") end end

    if Opt.bright then saveSet(Lighting, "Brightness", 3); saveSet(Lighting, "ClockTime", 14)

    else restore(Lighting, "Brightness"); restore(Lighting, "ClockTime") end

    if Opt.noFog then saveSet(Lighting, "FogStart", 99999); saveSet(Lighting, "FogEnd", 100000)

    else restore(Lighting, "FogStart"); restore(Lighting, "FogEnd") end

    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

    if atmosphere then if Opt.noFog then saveSet(atmosphere, "Density", 0); saveSet(atmosphere, "Haze", 0)

        else restore(atmosphere, "Density"); restore(atmosphere, "Haze") end end

end

local Overlay = Instance.new("ScreenGui")

Overlay.Name = "AtlasSniperOverlay"; Overlay.ResetOnSpawn = false; Overlay.IgnoreGuiInset = true

Overlay.DisplayOrder = 50; Overlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- PlayerGui keeps callbacks portable: hidden containers can require elevated

-- capabilities when new BillboardGuis are created after initialization.

Overlay.Parent = Player.PlayerGui

local function destroyVisual(player)

    local v = visuals[player]

    if not v then return end

    v.label:Destroy(); if v.highlight then v.highlight:Destroy() end

    visuals[player] = nil

end

local function renderModelOf(unit, fallback)

    local ok, model = pcall(function()

        local controllerAPI = require(RS.Client.EntityController)

        local entity = EntityAPI and EntityAPI.FetchEntity(unit)

        local controller = entity and controllerAPI.GetController(entity)

        return controller and controller:GetCurrentModel()

    end)

    if ok and typeof(model) == "Instance" and model:IsA("Model") and model:IsDescendantOf(workspace) then return model end

    return fallback

end

local function visualFor(player, model, part)

    local v = visuals[player]

    if v and v.model ~= model then destroyVisual(player); v = nil end

    if v then v.label.Adornee = part; return v end

    local label = Instance.new("BillboardGui"); label.Name = "AtlasSniperLabel"; label.Adornee = part

    label.Size = UDim2.fromOffset(220, 58); label.StudsOffsetWorldSpace = Vector3.new(0, 2.1, 0); label.Parent = Overlay

    local function textCell(name, y, size, weight)

        local t = Instance.new("TextLabel"); t.Name = name

        t.Position = UDim2.fromOffset(0, y); t.Size = UDim2.new(1, 0, 0, 18)

        t.BackgroundTransparency = 1; t.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", weight)

        t.TextSize = size; t.TextTruncate = Enum.TextTruncate.AtEnd

        t.TextColor3 = Color3.fromRGB(236, 241, 250); t.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); t.TextStrokeTransparency = 0.25

        t.Parent = label; return t

    end

    local text = textCell("PlayerName", 0, Opt.textSize, Enum.FontWeight.Bold)

    local metrics = textCell("Distance", 37, 11, Enum.FontWeight.SemiBold)

    metrics.TextColor3 = Color3.fromRGB(170, 184, 205)

    local track = Instance.new("Frame"); track.Name = "HealthBar"; track.Size = UDim2.fromOffset(86, 5)

    track.AnchorPoint = Vector2.new(0.5, 0); track.Position = UDim2.new(0.5, 0, 0, 23)

    track.BackgroundColor3 = Color3.fromRGB(8, 12, 20); track.BorderSizePixel = 0; track.Parent = label

    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 3); corner.Parent = track

    local border = Instance.new("UIStroke"); border.Color = Color3.fromRGB(0, 0, 0); border.Transparency = 0.2; border.Parent = track

    local fill = Instance.new("Frame"); fill.Name = "Fill"; fill.Size = UDim2.fromScale(1, 1)

    fill.BorderSizePixel = 0; fill.BackgroundColor3 = Color3.fromRGB(82, 197, 148); fill.Parent = track

    local round = corner:Clone(); round.Parent = fill

    for _,n in ipairs(label:GetDescendants()) do n:SetAttribute("NoTheme", true); n:SetAttribute("NoGradient", true) end

    v = {label = label, text = text, metrics = metrics, track = track, fill = fill, model = model}

    visuals[player] = v; return v

end

local function refreshESP()

    if not Opt.esp then for player in pairs(visuals) do destroyVisual(player) end; Stats.visible = 0; return end

    local camera = workspace.CurrentCamera; if not camera then return end

    local seen, count = {}, 0

    for _,player in ipairs(targetUnits(Opt.espBots)) do

        local model, part = candidate(player)

        if model then

            local range = (part.Position - camera.CFrame.Position).Magnitude

            if range <= Opt.maxDistance then

                seen[player] = true

                local v = visualFor(player, model, part)

                    local color = friendly(player) and Color3.fromRGB(82, 197, 148) or Color3.fromRGB(74, 146, 255)

                local hp, maximum = healthOf(player, model)

                local ratio = math.clamp(hp / maximum, 0, 1)

                v.text.Text = displayNameOf(player) .. (isBot(player) and " [BOT]" or "")

                v.text.Visible = Opt.names; v.text.TextSize = Opt.textSize

                v.track.Visible = Opt.health; v.fill.Size = UDim2.fromScale(ratio, 1)

                v.fill.BackgroundColor3 = ratio <= 0.25 and Color3.fromRGB(240, 90, 102)

                    or ratio <= 0.5 and Color3.fromRGB(238, 182, 73) or Color3.fromRGB(82, 197, 148)

                v.metrics.Text = tostring(math.floor(range + 0.5)) .. " studs"; v.metrics.Visible = Opt.distance

                v.label.Enabled = Opt.names or Opt.health or Opt.distance; v.label.AlwaysOnTop = Opt.throughWalls

                if Opt.highlights and count < 24 then

                    count += 1

                    if not v.highlight then local h = Instance.new("Highlight"); h.Name = "AtlasSniperHighlight"; h.Parent = Overlay; v.highlight = h end

                    v.highlight.Adornee = renderModelOf(player, model)

                    v.highlight.FillColor = color; v.highlight.OutlineColor = color; v.highlight.FillTransparency = 0.88; v.highlight.OutlineTransparency = 0.12

                    v.highlight.DepthMode = Opt.throughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded

                elseif v.highlight then v.highlight:Destroy(); v.highlight = nil end

            end

        end

    end

    Stats.visible = 0; Stats.players = #Players:GetPlayers()

    for player in pairs(visuals) do if not seen[player] then destroyVisual(player) else Stats.visible += 1 end end

end

local mobileHeld = false

local function stop()

    if not alive then return end

    alive = false; mobileHeld = false

    clearSilent()

    clearDelay()

    for _,c in ipairs(connections) do c:Disconnect() end

    for player in pairs(visuals) do destroyVisual(player) end

    for node,values in pairs(originals) do for key,value in pairs(values) do pcall(function() node[key] = value end) end end

    table.clear(originals); Overlay:Destroy()

    if ENV.ATLAS_SNIPER and ENV.ATLAS_SNIPER.Library == Library then ENV.ATLAS_SNIPER = nil end

end

Library:OnUnload(stop)

Library.ScreenGui.Parent = Player.PlayerGui

local Window = Library:CreateWindow({Title = "Atlas hub", Subtitle = "Sniper Arena", Logo = "peak"})

local Main = Window:Tab({Name = "Main", Icon = "crosshair", Description = "Shared filters for both aim modes."})

local ESP = Window:Tab({Name = "ESP", Icon = "eye", Description = "Player and bot visibility."})

local Movement = Window:Tab({Name = "Player", Icon = "user-round", Description = "Movement and view settings."})

local Config = Window:Tab({Name = "Config", Icon = "settings", Description = "Save your preferences."})

local function english(node) if node:IsA("GuiBase2d") then node.AutoLocalize = false end end

english(Library.ScreenGui); for _,node in ipairs(Library.ScreenGui:GetDescendants()) do english(node) end

connect(Library.ScreenGui.DescendantAdded, english)

local silentToggle

local delayToggle

local function toggle(section, name, key, icon)

    local control

    control = section:Toggle({Name = name, Icon = icon, Flag = "sniper_" .. key, Default = Opt[key], Callback = function(value)

        if false and (key == "silent" or key == "noDelay") and keyTier ~= "paid" then

            Opt[key] = false

            if value and control then control:Set(false) end

            return

        end

        Opt[key] = value

        if key == "aim" and value and UIS.MouseEnabled and not Stats.pointerAvailable then notify("Mouse movement is unavailable in this executor") end

        if key == "silent" then

            if value and not ensureSilent() then

                Opt.silent = false; if silentToggle then silentToggle:Set(false) end

                notify("Silent aim is unavailable in this executor")

            elseif not value then clearSilent() end

        end

        if key == "noDelay" then

            if value and not ensureDelay() then

                Opt.noDelay = false; if delayToggle then delayToggle:Set(false) end

                notify("Shot delay adjustment is unavailable in this executor")

            elseif not value then clearDelay() end

        end

    end})

    return control

end

local function lockSection(section, info)

	local container = section.Container

	if not container or not container.Parent then

		return

	end

	local T = Library:GetTheme()

	local TweenService = game:GetService("TweenService")

	local WHITE = Color3.new(1, 1, 1)

	local function new(class, props, children)

		local inst = Instance.new(class)

		for k, v in pairs(props) do

			inst[k] = v

		end

		for _, c in ipairs(children or {}) do

			c.Parent = inst

		end

		return inst

	end

	local function corner(r)

		return new("UICorner", { CornerRadius = UDim.new(0, r) })

	end

	local function fontOf(weight)

		return Font.new("rbxasset://fonts/families/BuilderSans.json", weight, Enum.FontStyle.Normal)

	end



	-- the controls move into a holder that also carries the glass, so the glass always

	-- matches their size (folding the section included)

	local holder = new("Frame", {

		Name = "PaidHolder",

		Size = UDim2.new(1, 0, 0, 0),

		BackgroundTransparency = 1,

		LayoutOrder = container.LayoutOrder,

		Parent = container.Parent,

	})

	container.Parent = holder

	-- The holder's height follows the controls. (AutomaticSize would also count the glass,

	-- which is sized from the holder itself, and the height would keep doubling.) Absolute

	-- sizes include the window's UIScale, so convert back to layout pixels.

	local function uiScale(inst)

		local s = 1

		local p = inst

		while p do

			local u = p:FindFirstChildOfClass("UIScale")

			if u then

				s *= u.Scale

			end

			p = p.Parent

		end

		return s

	end

	local function syncHeight()

		local s = uiScale(holder)

		holder.Size = UDim2.new(1, 0, 0, math.max(160, math.floor(container.AbsoluteSize.Y / (s > 0 and s or 1) + 0.5)))

	end

	container:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncHeight)

	syncHeight()



	local glass = new("Frame", {

		Name = "PaidGlass",

		Size = UDim2.fromScale(1, 1),

		BackgroundColor3 = T.Surface,

		BackgroundTransparency = 0.08,

		ClipsDescendants = true,

		Active = true, -- the locked controls can't be clicked

		ZIndex = 20,

		Parent = holder,

	}, { corner(7) })



	-- blurred ghost of the controls: faint, and faded out in the middle so the message

	-- sits on clean glass

	for _, o in ipairs({ Vector2.new(-2, -1), Vector2.new(2, 1), Vector2.new(-1, 2), Vector2.new(1, -2) }) do

		local group = new("CanvasGroup", {

			Position = UDim2.fromOffset(o.X, o.Y),

			Size = UDim2.fromScale(1, 1),

			BackgroundTransparency = 1,

			GroupTransparency = 0.9,

			ZIndex = 21,

			Parent = glass,

		}, {

			new("UIGradient", {

				Rotation = 90,

				Transparency = NumberSequence.new({

					NumberSequenceKeypoint.new(0, 0),

					NumberSequenceKeypoint.new(0.28, 0.7),

					NumberSequenceKeypoint.new(0.5, 1),

					NumberSequenceKeypoint.new(0.72, 0.7),

					NumberSequenceKeypoint.new(1, 0),

				}),

			}),

		})

		local ghost = container:Clone()

		ghost.Position = UDim2.new()

		ghost.Parent = group

	end



	-- frost tint + light from the top-left

	new("Frame", {

		Size = UDim2.fromScale(1, 1),

		BackgroundColor3 = WHITE,

		BackgroundTransparency = 0,

		ZIndex = 22,

		Parent = glass,

	}, {

		corner(7),

		new("UIGradient", {

			Rotation = 35,

			Transparency = NumberSequence.new({

				NumberSequenceKeypoint.new(0, 0.9),

				NumberSequenceKeypoint.new(0.45, 0.97),

				NumberSequenceKeypoint.new(1, 0.985),

			}),

		}),

		new("UIStroke", { Color = WHITE, Thickness = 1, Transparency = 0.88, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }),

	})

	-- thin highlight along the top edge

	new("Frame", {

		Position = UDim2.fromOffset(12, 1),

		Size = UDim2.new(1, -24, 0, 1),

		BackgroundColor3 = WHITE,

		BorderSizePixel = 0,

		ZIndex = 23,

		Parent = glass,

	}, {

		new("UIGradient", {

			Transparency = NumberSequence.new({

				NumberSequenceKeypoint.new(0, 1),

				NumberSequenceKeypoint.new(0.5, 0.55),

				NumberSequenceKeypoint.new(1, 1),

			}),

		}),

	})



	-- light sweep that crosses the glass now and then

	local sweep = new("Frame", {

		Size = UDim2.fromScale(1, 1),

		BackgroundColor3 = WHITE,

		ZIndex = 24,

		Parent = glass,

	})

	local band = new("UIGradient", {

		Rotation = 20,

		Offset = Vector2.new(-1, 0),

		Transparency = NumberSequence.new({

			NumberSequenceKeypoint.new(0, 1),

			NumberSequenceKeypoint.new(0.42, 1),

			NumberSequenceKeypoint.new(0.5, 0.9),

			NumberSequenceKeypoint.new(0.58, 1),

			NumberSequenceKeypoint.new(1, 1),

		}),

		Parent = sweep,

	})

	task.spawn(function()

		while alive and sweep.Parent do

			band.Offset = Vector2.new(-1, 0)

			TweenService:Create(band, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Offset = Vector2.new(1, 0) }):Play()

			task.wait(4.5)

		end

	end)



	-- centred message

	local stack = new("Frame", {

		AnchorPoint = Vector2.new(0.5, 0.5),

		Position = UDim2.fromScale(0.5, 0.5),

		Size = UDim2.new(1, -24, 0, 0),

		AutomaticSize = Enum.AutomaticSize.Y,

		BackgroundTransparency = 1,

		ZIndex = 25,

		Parent = glass,

	}, {

		new("UIListLayout", { HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),

	})

	local chip = new("Frame", {

		Size = UDim2.fromOffset(32, 32),

		BackgroundColor3 = WHITE,

		BackgroundTransparency = 0.92,

		LayoutOrder = 1,

		ZIndex = 25,

		Parent = stack,

	}, { corner(16), new("UIStroke", { Color = WHITE, Thickness = 1, Transparency = 0.8, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }) })

	local chipScale = new("UIScale", { Parent = chip })

	new("ImageLabel", {

		AnchorPoint = Vector2.new(0.5, 0.5),

		Position = UDim2.fromScale(0.5, 0.5),

		Size = UDim2.fromOffset(15, 15),

		BackgroundTransparency = 1,

		Image = "rbxassetid://71897067930472", -- Lucide "lock" (Nebula Icon Library)

		ImageColor3 = WHITE,

		ZIndex = 26,

		Parent = chip,

	})

	new("TextLabel", {

		Size = UDim2.new(1, 0, 0, 18),

		BackgroundTransparency = 1,

		Text = info.Title or "Paid feature",

		FontFace = fontOf(Enum.FontWeight.ExtraBold),

		TextSize = 15,

		TextColor3 = WHITE,

		LayoutOrder = 2,

		ZIndex = 25,

		Parent = stack,

	})

	new("TextLabel", {

		Size = UDim2.new(1, 0, 0, 16),

		BackgroundTransparency = 1,

		Text = info.Message or "Unlock it with a paid key",

		FontFace = fontOf(Enum.FontWeight.SemiBold),

		TextSize = 13,

		TextColor3 = T.Muted,

		LayoutOrder = 3,

		ZIndex = 25,

		Parent = stack,

	})

	new("Frame", { Size = UDim2.new(1, 0, 0, 2), BackgroundTransparency = 1, LayoutOrder = 4, Parent = stack }) -- spacing

	-- small pill button (text in a child label, so the theme's accent gradient never tints it)

	local button = new("TextButton", {

		Size = UDim2.fromOffset(112, 30),

		BackgroundColor3 = T.Accent,

		AutoButtonColor = false,

		Text = "",

		LayoutOrder = 5,

		ZIndex = 25,

		Parent = stack,

	}, { corner(15) })

	local buttonText = new("TextLabel", {

		Size = UDim2.fromScale(1, 1),

		BackgroundTransparency = 1,

		Text = info.Button or "Unlock",

		FontFace = fontOf(Enum.FontWeight.Bold),

		TextSize = 14,

		TextColor3 = WHITE,

		ZIndex = 26,

		Parent = button,

	})

	buttonText:SetAttribute("NoTheme", true)

	local press = new("UIScale", { Parent = button })

	button.MouseEnter:Connect(function()

		TweenService:Create(button, TweenInfo.new(0.15), { BackgroundColor3 = T.AccentHover }):Play()

		TweenService:Create(chipScale, TweenInfo.new(0.35, Enum.EasingStyle.Back), { Scale = 1.08 }):Play()

	end)

	button.MouseLeave:Connect(function()

		TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = T.Accent }):Play()

		TweenService:Create(chipScale, TweenInfo.new(0.3), { Scale = 1 }):Play()

		press.Scale = 1

	end)

	button.MouseButton1Down:Connect(function()

		TweenService:Create(press, TweenInfo.new(0.08), { Scale = 0.95 }):Play()

	end)

	button.MouseButton1Up:Connect(function()

		TweenService:Create(press, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Scale = 1 }):Play()

	end)

	button.Activated:Connect(function()

		local copy = (typeof(setclipboard) == "function" and setclipboard) or (typeof(toclipboard) == "function" and toclipboard)

		if copy and pcall(copy, info.Link) then

			buttonText.Text = "Link copied"

			Library:Notify({ Title = "Discord invite copied", Content = "Ask the staff for a paid key.", Type = "success", Duration = 3 })

			task.delay(1.8, function()

				if buttonText.Parent then

					buttonText.Text = info.Button or "Unlock"

				end

			end)

		else

			Library:Notify({ Title = "Our Discord", Content = tostring(info.Link), Type = "info", Duration = 5 })

		end

	end)

end





local targeting = Main:Section({Name = "Aimbot", Icon = "crosshair", Side = "Left"})

toggle(targeting, "Enable aimbot", "aim", "focus")

toggle(targeting, "Hold right mouse", "hold", "mouse-pointer-2")

toggle(targeting, "Show FOV", "showFov", "circle-dashed")

local tuning = targeting

tuning:Slider({Name = "FOV radius", Flag = "sniper_radius", Min = 40, Max = 600, Default = 220, Increment = 10, Callback = function(v) Opt.radius = v end})

tuning:Slider({Name = "Smooth", Flag = "sniper_smooth", Min = 1, Max = 20, Default = 3, Increment = 1, Tooltip = "Lower values pull faster.", Callback = function(v) Opt.smooth = v end})

local silent = Main:Section({Name = "Silent aim", Icon = "target", Side = "Right"})

silentToggle = toggle(silent, "Enable silent aim", "silent", "crosshair")

local function silentSetting(name, key, icon)

    silent:Toggle({Name = name, Icon = icon, Flag = "sniper_silent_" .. key, Default = SilentOpt[key], Callback = function(value) SilentOpt[key] = value end})

end

silentSetting("Target bots", "aimBots", "bot")

silentSetting("Team check", "teamCheck", "users")

silentSetting("Wall check", "wallCheck", "brick-wall")

silent:Dropdown({Name = "Aim part", Flag = "sniper_silent_part", Options = {"Head", "UpperTorso", "HumanoidRootPart"}, Default = "Head", Callback = function(value) SilentOpt.aimPart = value end})

local view = Movement:Section({Name = "View", Icon = "camera", Side = "Right"})

local fovSettings = toggle(view, "Custom FOV", "fov", "scan"):SubOptions()

fovSettings:Slider({Name = "Field of view", Flag = "sniper_fov_value", Min = 50, Max = 110, Default = 85, Increment = 1, Callback = function(v) Opt.fovValue = v end})

toggle(view, "Full bright", "bright", "sun")

toggle(view, "Remove fog", "noFog", "cloud-off")

local vis = ESP:Section({Name = "Visibility", Icon = "eye", Side = "Left"})

toggle(vis, "Enable ESP", "esp", "eye")

toggle(vis, "Show bots", "espBots", "bot")

toggle(vis, "Names", "names", "type")

toggle(vis, "Health", "health", "heart")

toggle(vis, "Distance", "distance", "ruler")

vis:Slider({Name = "Maximum distance", Flag = "sniper_range", Min = 100, Max = 3000, Default = 1500, Increment = 100, Callback = function(v) Opt.maxDistance = v end})

local style = ESP:Section({Name = "Appearance", Icon = "palette", Side = "Right"})

toggle(style, "Highlights", "highlights", "sparkles")

toggle(style, "Through walls", "throughWalls", "layers")

style:Slider({Name = "Text size", Flag = "sniper_text_size", Min = 11, Max = 18, Default = 13, Increment = 1, Callback = function(v) Opt.textSize = v end})

local mobility = Movement:Section({Name = "Movement", Icon = "footprints", Side = "Left"})

local speedSettings = toggle(mobility, "Walk speed", "speed", "gauge"):SubOptions()

speedSettings:Slider({Name = "Speed", Flag = "sniper_speed_value", Min = 8, Max = 100, Default = 24, Increment = 1, Callback = function(v) Opt.speedValue = v end})

local jumpSettings = toggle(mobility, "Custom jump", "jump", "arrow-up"):SubOptions()

jumpSettings:Slider({Name = "Jump power", Flag = "sniper_jump_value", Min = 20, Max = 100, Default = 60, Increment = 1, Callback = function(v) Opt.jumpValue = v end})

toggle(mobility, "Infinite jump", "infiniteJump", "arrow-up-from-line")

toggle(mobility, "Noclip", "noclip", "move-3d")

local weaponSettings = Main:Section({Name = "Exploits", Icon = "zap", Side = "Left"})

delayToggle = toggle(weaponSettings, "Remove local shot delay", "noDelay", "timer-off")

if keyTier ~= "paid" then

    local info = {Title = "Paid feature", Message = "Unlock it with a paid key", Button = "Unlock", Link = AtlasLinks().discord}

    -- task.defer(lockSection, silent, info)

    -- task.defer(lockSection, weaponSettings, info)

end

Library:AddConfigSections(Config, {Scope = "SniperArena"})

local fovCircle = Instance.new("Frame")

fovCircle.Name = "AtlasAimFOV"; fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)

fovCircle.BackgroundTransparency = 1; fovCircle.BorderSizePixel = 0; fovCircle.Visible = false; fovCircle.Parent = Overlay

local fovCorner = Instance.new("UICorner"); fovCorner.CornerRadius = UDim.new(0.5, 0); fovCorner.Parent = fovCircle

local fovStroke = Instance.new("UIStroke"); fovStroke.Color = Color3.fromRGB(255, 255, 255); fovStroke.Thickness = 1; fovStroke.Transparency = 0.15; fovStroke.Parent = fovCircle

local touchButton = Instance.new("TextButton")

touchButton.Name = "AtlasSniperTouchAim"; touchButton.Size = UDim2.fromOffset(64, 64)

touchButton.AnchorPoint = Vector2.new(1, 1); touchButton.Position = UDim2.new(1, -24, 1, -150)

touchButton.BackgroundColor3 = Color3.fromRGB(7, 13, 24); touchButton.TextColor3 = Color3.fromRGB(75, 147, 255)

touchButton.BorderSizePixel = 0; touchButton.Text = "AIM"; touchButton.TextSize = 14

touchButton.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold)

touchButton.Visible = false; touchButton.Parent = Overlay

local touchCorner = Instance.new("UICorner"); touchCorner.CornerRadius = UDim.new(0.5, 0); touchCorner.Parent = touchButton

local touchStroke = Instance.new("UIStroke"); touchStroke.Color = touchButton.TextColor3; touchStroke.Transparency = 0.5; touchStroke.Parent = touchButton

local touchInput

connect(touchButton.InputBegan, function(input)

    if input.UserInputType == Enum.UserInputType.Touch then touchInput = input; mobileHeld = true end

end)

connect(UIS.InputEnded, function(input) if input == touchInput then touchInput = nil; mobileHeld = false end end)

connect(UIS.WindowFocusReleased, function() touchInput = nil; mobileHeld = false end)

connect(Players.PlayerRemoving, destroyVisual)

connect(UIS.JumpRequest, function()

    if alive and Opt.infiniteJump and not Library.Open and not UIS:GetFocusedTextBox() then

        local model = characterOf(Player); local h = model and model:FindFirstChildOfClass("Humanoid")

        if h and healthOf(Player, model) > 0 then h:ChangeState(Enum.HumanoidStateType.Jumping) end

    end

end)

connect(RunService.PreSimulation, function()

    if not alive then return end

    local ok, err = pcall(updateProperties); if not ok then report(err) end

end)

local elapsed = 0

connect(RunService.RenderStepped, function(dt)

    if not alive then return end

    local ok, err = pcall(function()

        -- The UI is authoritative. Recover if a diagnostic or interrupted

        -- cleanup changed the internal option without updating the toggle.

        if silentToggle and silentToggle:Get() ~= Opt.silent then

            silentToggle:Set(silentToggle:Get())

        end

        elapsed += dt

        local fovCamera = workspace.CurrentCamera

        fovCircle.Visible = Opt.showFov and not Library.Open and fovCamera ~= nil

        if fovCircle.Visible then

            local origin = aimOrigin(fovCamera)

            fovCircle.Position = UDim2.fromOffset(origin.X, origin.Y)

            local diameter = Opt.radius * 2

            if fovCircle.Size.X.Offset ~= diameter then fovCircle.Size = UDim2.fromOffset(diameter, diameter) end

        end

        touchButton.Visible = UIS.TouchEnabled and Opt.aim and not Library.Open

        if not touchButton.Visible then mobileHeld = false end

        touchButton.BackgroundColor3 = mobileHeld and Color3.fromRGB(15, 40, 88) or Color3.fromRGB(7, 13, 24)

        if elapsed >= 0.1 then elapsed = 0; refreshESP() end

        Stats.target = nil

        if not Opt.aim or Library.Open or UIS:GetFocusedTextBox() then return end

        local localModel = characterOf(Player)

        local localHealth = healthOf(Player, localModel)

        if localHealth <= 0 then return end

        local touch = UIS.TouchEnabled and not UIS.MouseEnabled

        local engaged = not Opt.hold or (touch and mobileHeld) or (not touch and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2))

        if not engaged then return end

        local target, position = chooseTarget(); if not target or not position then return end

        Stats.target = target.Name

        local camera = workspace.CurrentCamera; if not camera then return end

        local alpha = 1 - math.exp(-180 / math.max(1, Opt.smooth) * math.clamp(dt, 0, 0.05))

        if touch then

            local cf = camera.CFrame

            camera.CFrame = cf:Lerp(CFrame.lookAt(cf.Position, position), alpha)

        elseif Stats.pointerAvailable then

            local point = camera:WorldToViewportPoint(position)

            local delta = (Vector2.new(point.X, point.Y) - aimOrigin(camera)) * alpha

            mouseMove(math.clamp(delta.X, -160, 160), math.clamp(delta.Y, -160, 160))

        end

    end)

    if not ok then report(err) end

end)

ENV.ATLAS_SNIPER = {Library = Library, Window = Window, Options = Opt, Stats = Stats,

    Overlay = Overlay, SilentOptions = SilentOpt,

    Stop = stop, ChooseTarget = chooseTarget, Candidate = candidate, Refresh = refreshESP,

    CharacterOf = characterOf, HealthOf = healthOf, SameRoom = sameRoom, Friendly = friendly,

    TargetUnits = targetUnits, EnsureSilent = ensureSilent,

    ClearSilent = function() silentToggle:Set(false) end, SilentToggle = silentToggle,

    EnsureDelay = ensureDelay, ClearDelay = clearDelay, DelayToggle = delayToggle}

ENV.ATLAS_SNIPER.ChooseSilentTarget = function() return chooseTarget(SilentOpt, true) end

Window:SelectTab(Main); Library:SetOpen(true)

return {ready = true, game = "Sniper Arena", tabs = #Window.Tabs, keyRequired = true, tier = keyTier, pointerAvailable = Stats.pointerAvailable}