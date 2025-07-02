local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoClickerGui"
screenGui.Parent = playerGui

-- Create Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 24
toggleButton.Parent = screenGui

local autoClicking = false
local connection

local function pressF()
    -- Replace this with your actual function or event that handles the "F" key action
    print("F key action triggered")
    -- Example: game.ReplicatedStorage.BladeAttackEvent:FireServer()
end

local function startAutoClicker()
    connection = RunService.Heartbeat:Connect(function()
        pressF()
    end)
end

local function stopAutoClicker()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

local function updateButtonAppearance()
    if autoClicking then
        toggleButton.Text = "ON"
        toggleButton.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
    else
        toggleButton.Text = "OFF"
        toggleButton.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White
    end
end

-- Initialize button appearance
autoClicking = false
updateButtonAppearance()

toggleButton.MouseButton1Click:Connect(function()
    autoClicking = not autoClicking
    if autoClicking then
        startAutoClicker()
    else
        stopAutoClicker()
    end
    updateButtonAppearance()
end)


