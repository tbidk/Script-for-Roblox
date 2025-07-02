-- Blade Ball Script | Left Click Spam + Aim Ball Toward Facing + GUI Drag + G Toggle

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- SETTINGS
local CLICK_INTERVAL = 1 / 300
local autoClickEnabled = false
local guiLogicEnabled = true
local lastClickTime = 0

-- GUI SETUP
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "AutoClickGui"
screenGui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton", screenGui)
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

-- G KEY TOGGLE FUNCTION
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.G then
		guiLogicEnabled = not guiLogicEnabled
		toggleButton.Text = "Auto Click: " .. (autoClickEnabled and "ON ✅" or "OFF ❌")
		toggleButton.TextColor3 = guiLogicEnabled and (autoClickEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0)) or Color3.fromRGB(255, 0, 0)
	end
end)

-- GUI BUTTON TOGGLE
toggleButton.MouseButton1Click:Connect(function()
	if guiLogicEnabled then
		autoClickEnabled = not autoClickEnabled
		toggleButton.Text = "Auto Click: " .. (autoClickEnabled and "ON ✅" or "OFF ❌")
		toggleButton.TextColor3 = autoClickEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	end
end)

-- FIRE CLICK REMOTE
local function simulateClick()
	if tick() - lastClickTime >= CLICK_INTERVAL then
		lastClickTime = tick()

		local remote = LocalPlayer:FindFirstChild("RemoteEvent") or (Character and Character:FindFirstChild("RemoteEvent"))
		if remote then
			-- Send "Hit" or "Click" type action (depends on actual game structure)
			remote:FireServer("Click")

			-- Simulate ball direction toward lookVector
			local ball = nil
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
					ball = obj
					break
				end
			end

			if ball then
				local direction = HumanoidRootPart.CFrame.LookVector * 100
				ball.AssemblyLinearVelocity = direction
			end
		end
	end
end

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
	if autoClickEnabled and guiLogicEnabled then
		simulateClick()
	end
end)