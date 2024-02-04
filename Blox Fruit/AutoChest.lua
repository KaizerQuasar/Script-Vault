local serverHopEnabled = true
local chestFarmEnabled = true
local waitTime = 50 -- Duration when to hop a new server, you are free to adjust this as long as you desire - Kaizerr

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local placeId = game.PlaceId

if placeId == 2753915549 or placeId == 4442272183 or placeId == 7449423635 then
    repeat wait() until game:IsLoaded() ~= false

    local visitedServers = {}
    local nextPageCursor = ""
    local currentHour = os.date("!*t").hour

    local function readVisitedServers()
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile("VisitedServers.json"))
        end)
        return success and result or {}
    end

    local function writeVisitedServers(servers)
        pcall(function()
            writefile("VisitedServers.json", HttpService:JSONEncode(servers))
        end)
    end

    local function findPlayer(username)
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Name == username then
                return player
            end
        end
        return nil
    end

    local function teleportToLocalPlayer(targetPlayer)
        local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and targetPlayer.Character then
            humanoid.Parent = targetPlayer.Character
        end
    end

    local function teleportToPlaceInstance(placeId, instanceId)
        TeleportService:TeleportToPlaceInstance(placeId, instanceId, Players.LocalPlayer)
    end

    local function setPlayerTeam(teamName)
        local string1 = "SetTeam"
        local string2 = teamName
        ReplicatedStorage.Remotes.CommF_:InvokeServer(string1, string2)
    end

    local function teleportToChests()
        while wait(0.8) do
            if chestFarmEnabled then
                for _, chest in pairs(Workspace:GetChildren()) do
                    if string.find(chest.Name, "Chest") then
                        print(chest.Name)
                        Players.LocalPlayer.Character.HumanoidRootPart.CFrame = chest.CFrame
                        wait(0.15)
                    end
                end

                Players.LocalPlayer.Character.Head:Destroy()

                for _, v in pairs(Workspace:GetDescendants()) do
                    if string.find(v.Name, "Chest") and v:IsA("TouchTransmitter") then
                        firetouchinterest(Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0) -- 0 is touch
                        wait()
                        firetouchinterest(Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1) -- 1 is untouch
                    end
                end
            end
        end
    end

    local function teleportToServers()
        while wait() do
            if serverHopEnabled then
                wait(waitTime)
                local serverList
                if nextPageCursor == "" then
                    serverList = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100'))
                else
                    serverList = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. nextPageCursor))
                end

                local num = 0

                for _, server in pairs(serverList.data) do
                    local possible = true
                    local serverId = tostring(server.id)

                    if tonumber(server.maxPlayers) > tonumber(server.playing) then
                        for _, visitedServerId in pairs(visitedServers) do
                            if num ~= 0 then
                                if serverId == tostring(visitedServerId) then
                                    possible = false
                                end
                            else
                                if tonumber(currentHour) ~= tonumber(visitedServerId) then
                                    visitedServers = {}
                                    table.insert(visitedServers, currentHour)
                                    writeVisitedServers(visitedServers)
                                end
                            end
                            num = num + 1
                        end

                        if possible then
                            table.insert(visitedServers, serverId)
                            wait()
                            writeVisitedServers(visitedServers)
                            wait(4)
                            teleportToPlaceInstance(placeId, serverId)
                            print("Finding new server")
                        end
                    end
                end
            end
        end
    end

    spawn(setPlayerTeam, "Pirates")
    spawn(teleportToChests)
    spawn(teleportToServers)
end
