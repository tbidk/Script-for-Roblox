-- Blade Ball | Simulated Left Clicks 300/s + Ball Aim + GUI Drag + G Toggle
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Settings
local CLICK_INTERVAL = 1 / 300
local autoClickEnabled = false
local guiLogicEnabled = true
local lastClickTime = 0

-- GUI Setup
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "ClickSpamGui"
screenGui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Text = "Auto Click: OFF ❌"
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleButton.TextColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 24
toggleButton.AutoButtonColor = true
toggleButton.Draggable = true
toggleButton.Active = true
toggleButton.Parent = screenGui

screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Toggle GUI logic on/off with G
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.G then
		guiLogicEnabled = not guiLogicEnabled
		toggleButton.Text = "Auto Click: " .. (autoClickEnabled and "ON ✅" or "OFF ❌")
		toggleButton.TextColor3 = guiLogicEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	end
end)

-- Toggle autoclicking by pressing the GUI
toggleButton.MouseButton1Click:Connect(function()
	if guiLogicEnabled then
		autoClickEnabled = not autoClickEnabled
		toggleButton.Text = "Auto Click: " .. (autoClickEnabled and "ON ✅" or "OFF ❌")
		toggleButton.TextColor3 = autoClickEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	end
end)

-- Simulated click function
local function simulateHit()
	if tick() - lastClickTime >= CLICK_INTERVAL then
		lastClickTime = tick()

		local remote = LocalPlayer:FindFirstChild("RemoteEvent") or (Character and Character:FindFirstChild("RemoteEvent"))
		if remote then
			-- Simulate "hit" like left click
			remote:FireServer("Hit") -- or "Click" depending on the game
		end

		-- Try aiming ball forward if visible
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
				local direction = HumanoidRootPart.CFrame.LookVector * 100
				obj.AssemblyLinearVelocity = direction
			end
		end
	end
end

-- Main loop
RunService.RenderStepped:Connect(function()
	if autoClickEnabled and guiLogicEnabled then
		simulateHit()
	end
end)