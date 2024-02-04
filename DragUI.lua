local UserInputService = game:GetService("UserInputService")

local function createDraggableFrame(frame)
    local isDragging = false
    local dragStartPos
    local startPos

    local function updatePosition(input)
        local delta = input.Position - dragStartPos
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStartPos = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end

    local function onInputChanged(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updatePosition(input)
        end
    end

    local inputConnection = frame.InputBegan:Connect(onInputBegan)
    local changedConnection = frame.InputChanged:Connect(onInputChanged)

    return {
        Disconnect = function()
            inputConnection:Disconnect()
            changedConnection:Disconnect()
        end
    }
end

local frame = PutYourFrameNameHere
local draggable = createDraggableFrame(frame)

-- To disconnect the events when needed:
-- draggable.Disconnect()
-- By Kaizerr <:3
