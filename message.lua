-- Modified Cookie Hub / Eclipse Loader Script with custom Icon ID and Name
local CLIENT_VERSION = "roblox-gui/1.8"
local REQUEST_ATTEMPTS = 4

assert(getgenv, "This loader needs getgenv to hand the key to the place script.")
local shared = getgenv()
local previous = shared.CookieHubLoaderState
if type(previous) == "table" and (previous.state == "starting" or previous.state == "waiting_key") then
    return
end
local loaderState = { state = "starting" }
shared.CookieHubLoaderState = loaderState
if type(previous) == "table" and type(previous.retire) == "function" then
    pcall(previous.retire)
end
if type(shared.CookieHubLoaderWindow) == "function" then
    pcall(shared.CookieHubLoaderWindow)
end
local function releaseLoader()
    if shared.CookieHubLoaderState == loaderState then shared.CookieHubLoaderState = nil end
end

local loaderOk, loaderErr = pcall(function()

local function requestWithRetry(send, valid, onRetry)
    for attempt = 1, REQUEST_ATTEMPTS do
        local ok, response = pcall(send)
        if ok and valid(response) then return response end
        if attempt < REQUEST_ATTEMPTS then
            local delay = 2 ^ (attempt - 1)
            if onRetry then onRetry(attempt + 1, delay) end
            task.wait(delay)
        end
    end
    error("HTTP request failed after 4 attempts. Check your connection and try again.", 0)
end

local function validHttpResponse(response)
    return type(response) == "table" and (tonumber(response.StatusCode or response.Status or response.status_code) or 0) > 0
end

local WORKER_ORIGIN = "https://script-access-worker.script-access-worker.workers.dev"
local PLACE_ID = tostring(game.PlaceId)
local DISCORD_URL = "http://dsc.gg/cookie-hub-rblx"

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local PLAYER_ID = tostring(Players.LocalPlayer.UserId)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local requestFn = request or http_request or (syn and syn.request)
assert(requestFn, "This loader needs an HTTP request API.")
assert(loadstring, "This loader needs loadstring enabled.")
getgenv().CookieHubDebugLog = nil

local function installationId()
    return getgenv().ScriptAccessInstallationId or ("roblox-" .. Players.LocalPlayer.UserId)
end

local post
local reportedFailures = {}
local analyticsQueues = {}
local analyticsStopped = {}
local function analyticsAvailable(analytics)
    return type(analytics) == "table" and type(analytics.session_id) == "string" and type(analytics.session_token) == "string" and not analyticsStopped[analytics.session_id]
end
local function reportEvent(analytics, event, text)
    if not analyticsAvailable(analytics) then return end
    local queue = analyticsQueues[analytics.session_id]
    if not queue then
        queue = { events = {}, running = false }
        analyticsQueues[analytics.session_id] = queue
    end
    if #queue.events >= 32 then
        if event == "heartbeat" then return end
        local removeIndex = 1
        for index, pendingEvent in ipairs(queue.events) do
            if pendingEvent.event == "heartbeat" then removeIndex = index; break end
        end
        table.remove(queue.events, removeIndex)
    end
    table.insert(queue.events, { id = HttpService:GenerateGUID(false), event = event, text = text })
    if queue.running then return end
    queue.running = true
    task.spawn(function()
        while #queue.events > 0 do
            local pendingEvent = table.remove(queue.events, 1)
            local ok, status = pcall(post, "/v1/analytics/events", {
                session_id = analytics.session_id,
                session_token = analytics.session_token,
                events = { pendingEvent },
            })
            if ok and (status == 401 or status == 403) then
                analyticsStopped[analytics.session_id] = true
                table.clear(queue.events)
                break
            end
        end
        queue.running = false
        analyticsQueues[analytics.session_id] = nil
    end)
end
local function reportLoadFailure(analytics, reason)
    if type(analytics) ~= "table" or type(analytics.session_id) ~= "string" or type(analytics.session_token) ~= "string" then return end
    if reportedFailures[analytics.session_id] then return end
    reportedFailures[analytics.session_id] = true
    reportEvent(analytics, "load_failed", reason)
end

local function startupTracker(analytics)
    local values = { state = "starting" }
    local observer, failureReported, successReported, unloadReported, retired
    local function retire()
        retired = true
        if successReported and not unloadReported and values.analyticsManaged ~= true then
            unloadReported = true
            reportEvent(analytics, "unload")
        end
    end
    loaderState.retire = retire
    local function heartbeat()
        if retired or values.state ~= "ready" or values.analyticsManaged == true or shared.CookieHubLoaderState ~= loaderState or not analyticsAvailable(analytics) then return end
        reportEvent(analytics, "heartbeat")
        task.delay(60, heartbeat)
    end
    local function changed()
        if values.state == "failed" then
            releaseLoader()
            if not failureReported then
                failureReported = true
                reportLoadFailure(analytics, "initialization_failed")
            end
        elseif values.state == "unloaded" then
            retire()
            releaseLoader()
        elseif values.state == "ready" and shared.CookieHubLoaderState == loaderState then
            loaderState.state = "ready"
            if not successReported and values.analyticsManaged ~= true and analyticsAvailable(analytics) then
                successReported = true
                reportEvent(analytics, "load_success")
                task.delay(60, heartbeat)
            end
        end
        if observer then observer(values.state, values.reason) end
    end
    local state = setmetatable({}, {
        __index = values,
        __newindex = function(_, key, value)
            values[key] = value
            if key == "state" then changed() end
        end,
    })
    return state, function(callback) observer = callback; changed() end
end

post = function(path, payload, onRetry)
    local encoded = HttpService:JSONEncode(payload)
    local requestId = "loader-" .. HttpService:GenerateGUID(false)
    local response = requestWithRetry(function() return requestFn({
        Url = WORKER_ORIGIN .. path,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json", ["X-Request-ID"] = requestId },
        Body = encoded,
        body = encoded,
    }) end, validHttpResponse, onRetry)
    local statusCode = tonumber(response.StatusCode or response.Status or response.status_code) or 0
    local raw = response.Body or response.body or ""
    local decoded, body = pcall(HttpService.JSONDecode, HttpService, raw)
    if not decoded or type(body) ~= "table" then
        return statusCode, { error = "The service returned an unreadable response." }, raw
    end
    return statusCode, body, raw
end

task.spawn(function()
    pcall(post, "/v1/client/start", { place_id = PLACE_ID, player_id = PLAYER_ID, client_version = CLIENT_VERSION })
end)

local probeOk, probeCode, probe = pcall(post, "/v1/scripts/load/" .. HttpService:UrlEncode(PLACE_ID), {
    place_id = PLACE_ID,
    player_id = PLAYER_ID,
    client_version = CLIENT_VERSION,
})
if not probeOk then error(tostring(probeCode), 0) end
if probeCode == 404 and probe.reason == "unsupported_place" then
    local function create(class, props)
        local object = Instance.new(class)
        local parent = props.Parent
        for key, value in pairs(props) do
            if key ~= "Parent" then object[key] = value end
        end
        object.Parent = parent
        return object
    end
    local screen = create("ScreenGui", {
        Name = "CookieHubUnsupportedGame", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = Players.LocalPlayer:WaitForChild("PlayerGui"),
    })
    
