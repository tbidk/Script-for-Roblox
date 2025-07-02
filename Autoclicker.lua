-- Blade Ball Script | G-Key Enables/Disables GUI Function + FPS Boost + Auto Parry

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- === PERFORMANCE BOOST ===
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
Lighting.GlobalShadows = false
Lighting.FogEnd = 100
Lighting.FogStart = 0
Lighting.Brightness = 0.5
Lighting.ClockTime = 14

for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
        v:Destroy()
    end
end

if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("Texture") or v:IsA("Decal") then
        v:Destroy()
    end
end

-- === LOGIC SETTINGS ===
local AUTO_PARRY_DISTANCE = 15
local BLOCK_INTERVAL = 1 / 300
local manualBlockOn = false
local lastBlockTime = 0
local guiLogicEnabled = true -- G toggles this

-- === GUI SETUP ===
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "BlockToggleGui"

local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Text = "Manual Block: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 24
toggleButton.AutoButtonColor = true

-- === G KEY TURNS FUNCTIONALITY ON/OFF ===
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.G then
        guiLogicEnabled = not guiLogicEnabled
        toggleButton.Text = "Manual Block: " .. (manualBlockOn and "ON" or "OFF") .. (guiLogicEnabled and " ✅" or " ❌")
        toggleButton.TextColor3 = guiLogicEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end)

-- === BUTTON TOGGLE ===
toggleButton.MouseButton1Click:Connect(function()
    if guiLogicEnabled then
        manualBlockOn = not manualBlockOn
        toggleButton.Text = "Manual Block: " .. (manualBlockOn and "ON" or "OFF") .. (guiLogicEnabled and " ✅" or " ❌")
        toggleButton.TextColor3 = manualBlockOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end)

-- === AUTO PARRY ===
local function autoParry()
    if not guiLogicEnabled then return end
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

-- === BLOCK ===
local function manualBlock()
    if not guiLogicEnabled or not manualBlockOn then return end
    if tick() - lastBlockTime >= BLOCK_INTERVAL then
        lastBlockTime = tick()
        local remote = LocalPlayer:FindFirstChild("RemoteEvent") or (Character and Character:FindFirstChild("RemoteEvent"))
        if remote then
            remote:FireServer("Block")
        end
    end
end

-- === MAIN LOOP ===
RunService.RenderStepped:Connect(function()
    autoParry()
    manualBlock()
end)