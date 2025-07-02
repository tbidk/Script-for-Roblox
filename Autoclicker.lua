local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoBlockGui"
screenGui.Parent = playerGui

-- Create Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 100) -- Start near top-left
toggleButton.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
toggleButton.TextColor3 = Color3.new(1, 1, 1) -- White text
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 28
toggleButton.Text = "Off"
toggleButton.Parent = screenGui
toggleButton.AutoButtonColor = false

-- Variables for dragging
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updatePosition(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(
        0,
        math.clamp(startPos.X.Offset + delta.X, 0, playerGui.AbsoluteSize.X - toggleButton.AbsoluteSize.X),
        0,
        math.clamp(startPos.Y.Offset + delta.Y, 0, playerGui.AbsoluteSize.Y - toggleButton.AbsoluteSize.Y)
    )
    toggleButton.Position = newPos
end

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updatePosition(input)
    end
end)

-- Auto-block logic
local autoBlocking = false
local connection

local blocksThisSecond = 0

-- Replace with your actual block event name
local blockEvent = game:GetService("ReplicatedStorage"):WaitForChild("BlockEvent")

local function performBlock()
    blockEvent:FireServer()
    blocksThisSecond = blocksThisSecond + 1
end

local function startAutoBlock()
    blocksThisSecond = 0
    print("Auto-block started")
    connection = RunService.Heartbeat:Connect(function()
        local blocksPerFrame = 300 / 60
        for i = 1, math.floor(blocksPerFrame) do
            performBlock()
        end
        if math.random() < (blocksPerFrame - math.floor(blocksPerFrame)) then
            performBlock()
        end
    end)
end

local function stopAutoBlock()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    print("Auto-block stopped")
end

local function updateButtonAppearance()
    if autoBlocking then
        toggleButton.Text = "On"
        toggleButton.BackgroundColor3 = Color3.new(0, 0, 0) -- Black
        toggleButton.TextColor3 = Color3.new(1, 1, 1) -- White
    else
        toggleButton.Text = "Off"
        toggleButton.BackgroundColor3 = Color3.new(0, 0, 0) -- Black
        toggleButton.TextColor3 = Color3.new(1, 1, 1) -- White
    end
end

-- Initialize
autoBlocking = false
updateButtonAppearance()

toggleButton.MouseButton1Click:Connect(function()
    autoBlocking = not autoBlocking
    if autoBlocking then
        startAutoBlock()
    else
        stopAutoBlock()
    end
    updateButtonAppearance()
end)

