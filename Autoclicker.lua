local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoClickerGui"
screenGui.Parent = playerGui

-- Create Toggle Button (bottom-left corner)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 1, -70) -- 20px from left, 70px from bottom
toggleButton.AnchorPoint = Vector2.new(0, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 24
toggleButton.Parent = screenGui

-- Create CPS Label (top-right corner)
local cpsLabel = Instance.new("TextLabel")
cpsLabel.Size = UDim2.new(0, 100, 0, 30)
cpsLabel.Position = UDim2.new(1, -110, 0, 20) -- 110px from right, 20px from top
cpsLabel.AnchorPoint = Vector2.new(0, 0)
cpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
cpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
cpsLabel.Font = Enum.Font.SourceSansBold
cpsLabel.TextSize = 20
cpsLabel.Text = ""
cpsLabel.Visible = false
cpsLabel.Parent = screenGui

local autoClicking = false
local connection

local clicksThisSecond = 0
local cps = 0

-- Placeholder function to simulate left click action
local function performClick()
    -- Replace this with your actual left click handler, e.g.:
    -- game.ReplicatedStorage.YourClickEvent:FireServer()
    print("Left click performed")
end

local function startAutoClicker()
    clicksThisSecond = 0
    cpsLabel.Visible = true

    connection = RunService.Heartbeat:Connect(function(dt)
        -- Aim for ~290 clicks per second
        -- Heartbeat runs roughly 60 times per second, so click multiple times per frame
        local clicksPerFrame = 290 / 60
        for i = 1, math.floor(clicksPerFrame) do
            performClick()
            clicksThisSecond = clicksThisSecond + 1
        end
        -- Handle fractional clicks per frame probabilistically
        if math.random() < (clicksPerFrame - math.floor(clicksPerFrame)) then
            performClick()
            clicksThisSecond = clicksThisSecond + 1
        end
    end)

    -- Update CPS every second
    spawn(function()
        while autoClicking do
            cps = clicksThisSecond
            clicksThisSecond = 0
            cpsLabel.Text = "CPS: " .. tostring(cps)
            wait(1)
        end
    end)
end

local function stopAutoClicker()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    cpsLabel.Visible = false
    cpsLabel.Text = ""
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
