-- Quick Note: You might wanna use an Anti Cheat for this one.
-- This script was from like few months ago but I kinda like rebuilt it.
-- Credits goes to the real owner that I took the AP on.

-- Configuration
local DEBUG_MODE = false

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Constants
local REMOTE_FOLDER_NAME = "Remotes"
local BALLS_FOLDER_NAME = "Balls"
local PARRY_DISTANCE_THRESHOLD = 10
local UPDATE_INTERVAL = 1/60 -- Go mess this up around [1/60 Updates every 1 second, 1/120 - Every 2 seconds, 1/240, every 3 seconds.]

-- Variables
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local remotes = ReplicatedStorage:WaitForChild(REMOTE_FOLDER_NAME, math.huge)
local balls = Workspace:WaitForChild(BALLS_FOLDER_NAME, math.huge)

local function debugPrint(...)
    if DEBUG_MODE then
        warn(...)
    end
end

-- Auto Parry System for the Ball
local BallParrySystem = {}

function BallParrySystem.new(ball)
    local self = setmetatable({}, {__index = BallParrySystem})
    self.ball = ball
    self.oldPosition = ball.Position
    self.oldTick = tick()
    self:update() 
    return self
end

function BallParrySystem:update()
    local distance = (self.ball.Position - Workspace.CurrentCamera.Focus.Position).Magnitude
    local velocity = (self.oldPosition - self.ball.Position).Magnitude
    local timeToCollision = distance / velocity

    debugPrint("Distance:", distance, "Velocity:", velocity, "Time:", timeToCollision)

    if timeToCollision <= PARRY_DISTANCE_THRESHOLD then
        self:performParry()
    end

    self.oldPosition = self.ball.Position
    self.oldTick = tick()
end

function BallParrySystem:performParry()
    remotes:WaitForChild("ParryButtonPress"):Fire()
end

-- Spawned Event Handler for the Ball
balls.ChildAdded:Connect(function(ball)
    if typeof(ball) == "Instance" and ball:IsA("BasePart") and ball:IsDescendantOf(balls) and ball:GetAttribute("realBall") == true then
        debugPrint("Ball Spawned:", ball)
        BallParrySystem.new(ball)
    end
end)

local function updateAllBallParrySystems()
    for _, ballParrySystem in pairs(BallParrySystem) do
        ballParrySystem:update()
    end
end

spawn(function()
    while wait(UPDATE_INTERVAL) do
        updateAllBallParrySystems()
    end
end)
