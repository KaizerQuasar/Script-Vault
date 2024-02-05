local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local targetPlayerName = "UsernameHere"

local function findPlayerByUsername(username)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name == username then
            return player
        end
    end
    return nil
end

local function teleportToLocalPlayer(targetPlayer)
    local humanoidRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")

    if humanoidRoot and targetRoot then
        humanoidRoot.CFrame = CFrame.new(targetRoot.Position)
    end
end

-- Where the player gets teleported to the player
local targetPlayer = findPlayerByUsername(targetPlayerName)
if targetPlayer then
    teleportToLocalPlayer(targetPlayer)
else
    warn("Player not found:", targetPlayerName) -- Warns if the inputted player in the "targetPlayerName" variable doesn't exist.
end

-- Script by Kaizerr <:3
