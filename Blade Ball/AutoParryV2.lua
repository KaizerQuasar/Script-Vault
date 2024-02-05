-- I am bored so I took this from a random ass website and do some changes on it :/

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Stats = game.Stats.Network.ServerStatsItem["Data Ping"]

local LocalPlayer = Players.LocalPlayer
local Balls = Workspace.Balls

getgenv().QuasarAP = {
    adjustment = 3, -- Do anything you want with this one I recommend 2.5 to 5 max.
    hit_range = 0.5, -- Hit Range fuck this shit off also recommend value for it is 0.2 - 0.5
    mode = 'Hold', -- Hold, Toggle, Always - Recommended Always.
    deflect_type = 'Remote', -- Remote, Key Press.
    notifications = true, -- Go ahead, I see what you're gonna do if you set this to false.
    keybind = Enum.KeyCode.Z -- Mess around.
}

local executed = false
local isTargeted = false
local canHit = false

local function findBall()
    for _, ball in pairs(Balls:GetChildren()) do
        if ball:GetAttribute("realBall") == true then
            return ball
        end
    end
end

local function isTargetedPlayer()
    local ball = findBall()
    return ball and ball:GetAttribute("target") == LocalPlayer.Name
end

local function shouldDeflect()
    local ball = findBall()
    
    if ball then
        local velocity = ball.Velocity.Magnitude
        local position = ball.Position
        local playerPosition = LocalPlayer.Character.HumanoidRootPart.Position
        local distance = (position - playerPosition).Magnitude
        local pingAccountability = velocity * (Stats["Data Ping"]:GetValue() / 1000)

        distance = distance - pingAccountability - getgenv().QuasarAP.adjustment

        local hit = distance / velocity

        return hit <= getgenv().QuasarAP.hit_range
    end

    return false
end

local function parry()
    if isTargeted and shouldDeflect() then
        if getgenv().QuasarAP.deflect_type == 'Key Press' then
            keypress(0x46)
        else
            ReplicatedStorage.Remotes.ParryButtonPress:Fire()
        end
    end
end

UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end

    if getgenv().QuasarAP.mode == 'Toggle' and input.KeyCode == getgenv().QuasarAP.keybind then
        canHit = not canHit

        if getgenv().QuasarAP.notifications then
            StarterGui:SetCore("SendNotification",{
                Title = "Quasar Hub",
                Text = canHit and 'Enabled!' or 'Disabled!',
            })
        end
    elseif getgenv().QuasarAP.mode == 'Hold' and input.KeyCode == getgenv().QuasarAP.keybind and getgenv().QuasarAP.notifications then
        StarterGui:SetCore("SendNotification",{
            Title = "Quasar Hub",
            Text = 'Holding keybind!',
        })
    end
end)

UserInputService.InputEnded:Connect(function(input, isTyping)
    if isTyping then return end

    if getgenv().QuasarAP.mode == 'Hold' and input.KeyCode == getgenv().QuasarAP.keybind and getgenv().QuasarAP.notifications then
        StarterGui:SetCore("SendNotification",{
            Title = "Quasar Hub",
            Text = 'No longer holding keybind!',
        })
    end
end)

RunService.PostSimulation:Connect(function()
    isTargeted = isTargetedPlayer()

    if getgenv().QuasarAP.mode == 'Hold' and UserInputService:IsKeyDown(getgenv().QuasarAP.keybind) then
        parry()
    elseif getgenv().QuasarAP.mode == 'Toggle' and canHit then
        parry()
    elseif getgenv().QuasarAP.mode == 'Always' then
        parry()
    end
end)

if not executed then
    executed = true
end
