local Players = game:GetService("Players")
local player = Players.LocalPlayer

local autoClicking = false
local runService = game:GetService("RunService")
local clickInterval = 1 / 300
local connection

local function pressF()
    print("F key action triggered") -- Replace with your actual function or event call
end

local function toggleAutoClicker()
    autoClicking = not autoClicking
    if autoClicking then
        connection = runService.Heartbeat:Connect(function()
            pressF()
        end)
        print("Auto-clicker started")
    else
        if connection then
            connection:Disconnect()
            connection = nil
        end
        print("Auto-clicker stopped")
    end
end

-- Example command handler
local function onCommandEntered(command)
    if command == "toggleAutoClicker" then
        toggleAutoClicker()
    else
        print("Unknown command: " .. command)
    end
end

-- Example GUI setup (you would create this in Roblox Studio)
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local textBox = Instance.new("TextBox", screenGui)
textBox.Size = UDim2.new(0, 200, 0, 50)
textBox.Position = UDim2.new(0, 10, 0, 10)
textBox.PlaceholderText = "Enter command and press Enter"

textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        onCommandEntered(textBox.Text)
        textBox.Text = ""
    end
end)

