-- التأكد من عدم تشغيل السكربت مرتين
if _G.UndergroundScriptRunning then return end
_G.UndergroundScriptRunning = true

print("مرحباً بك [يجري تشغيل السكربت]")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local isUnderground = false
local depthValue = 10
local basePosition = nil -- نقطة المرجع الأصلية

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "UndergroundGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(255, 85, 0)
Stroke.Thickness = 3

local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleBtn.Text = "تحت الأرض: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)

local ValueText = Instance.new("TextLabel", MainFrame)
ValueText.Size = UDim2.new(1, 0, 0, 20)
ValueText.Position = UDim2.new(0, 0, 0.52, 0)
ValueText.Text = "المسافة: 10"
ValueText.TextColor3 = Color3.new(1, 1, 1)
ValueText.BackgroundTransparency = 1

local SliderBg = Instance.new("Frame", MainFrame)
SliderBg.Size = UDim2.new(0.8, 0, 0, 12)
SliderBg.Position = UDim2.new(0.1, 0, 0.72, 0)
SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local SliderBtn = Instance.new("TextButton", SliderBg)
SliderBtn.Size = UDim2.new(0, 24, 0, 24)
SliderBtn.Position = UDim2.new(0, -12, -0.5, 0)
SliderBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
SliderBtn.Text = ""

-- منطق سحب العداد
local dragging = false
SliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

UserInputService.InputChanged:Connect(function(input)
    if dragging then
        local framePos = SliderBg.AbsolutePosition.X
        local frameSize = SliderBg.AbsoluteSize.X
        local inputX = (input.Position.X or 0)
        local percentage = math.clamp((inputX - framePos) / frameSize, 0, 1)
        depthValue = math.floor(10 + (percentage * 100))
        SliderBtn.Position = UDim2.new(percentage, -12, -0.5, 0)
        ValueText.Text = "المسافة: " .. depthValue
    end
end)

-- منطق النزول (يحدث الشخصية باستمرار)
ToggleBtn.MouseButton1Click:Connect(function()
    isUnderground = not isUnderground
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if isUnderground then
            basePosition = char.HumanoidRootPart.CFrame
            ToggleBtn.Text = "تحت الأرض: ON"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        else
            char.HumanoidRootPart.Anchored = false
            char.HumanoidRootPart.CFrame = basePosition
            ToggleBtn.Text = "تحت الأرض: OFF"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if isUnderground then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            -- تجميد الشخصية في الموقع المختار تحت الأرض بالضبط
            root.CFrame = (basePosition - Vector3.new(0, depthValue, 0))
            root.Anchored = true
        end
    end
end)
