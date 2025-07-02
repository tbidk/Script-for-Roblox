-- Blade Ball Script | Delta Executor Compatible
-- Features: Auto Parry + GUI Manual Blocker (Toggleable at 300 blocks/sec)
-- ⚠️ Use in PRIVATE games only

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- === CONFIG ===
local AUTO_PARRY_DISTANCE = 15
local BLOCK_INTERVAL = 1 / 300
local TOGGLE_KEY = Enum.KeyCode.B

-- === GUI SETUP ===
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "BlockToggleGui"

local toggleLabel = Instance.new("TextLabel", screenGui)
toggleLabel.Size = UDim2.new(0, 200, 0, 50)
toggleLabel.Position = UDim2.new(0, 20, 0, 20)
toggleLabel.Text = "Manual Block: OFF"
toggleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleLabel.Font = Enum.Font.SourceSansBold
toggleLabel.TextSize = 24

-- === AUTOPARRY ===
local function autoParry()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
            if (obj.Position - HumanoidRootPart.Position).Magnitude <= AUTO_PARRY_DISTANCE then
                local remote = LocalPlayer:FindFirstChild("RemoteEvent") or (Character and Character:FindFirstChild("RemoteEvent"))
                if remote then
                    remote:FireServer("Parry")
                end
            end
        end
    end
end

-- === MANUAL BLOCK ===
local manualBlockOn = false
local lastBlockTime = 0

local function manualBlock()
    if tick() - lastBlockTime >= BLOCK_INTERVAL then
        lastBlockTime = tick()
        local remote = LocalPlayer:FindFirstChild("RemoteEvent") or (Character and Character:FindFirstChild("RemoteEvent"))
        if remote then
            remote:FireServer("Block")
        end
    end
end

-- === INPUT TOGGLE ===
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == TOGGLE_KEY then
        manualBlockOn = not manualBlockOn
        toggleLabel.Text = "Manual Block: " .. (manualBlockOn and "ON" or "OFF")
        toggleLabel.TextColor3 = manualBlockOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end)

-- === MAIN LOOP ===
RunService.RenderStepped:Connect(function()
    autoParry()
    if manualBlockOn then
        manualBlock()
    end
end)