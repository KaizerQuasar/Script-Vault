game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
warn("Lmfao") -- Do not delete both of the first 2 lines.

local isToggled = false

local function toggleParry()
    isToggled = not isToggled
    while isToggled do
        game:GetService("ReplicatedStorage").Remotes.ParryAttempt:FireServer(1.5, CFrame.new(-254.2939910888672, 112.13581848144531, -119.27256774902344) * CFrame.Angles(-2.029526710510254, 0.5662040710449219, 2.314905881881714), {[2617721424] = Vector3.new(-273.400146484375, -724.8031005859375, -20.92414093017578)}, {910, 154})
        wait()
    end
end

local userInput = game:GetService("UserInputService")
local isVKeyPressed = false

userInput.InputBegan:Connect(function(input, isProcessed)
    if input.KeyCode == Enum.KeyCode.V and not isProcessed then
        isVKeyPressed = not isVKeyPressed
        toggleParry()
        print("Parry Starting..")
    end
end)

userInput.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.V then
        isVKeyPressed = false
        print("Parry Stopped..")
    end
end)
