--[[ 
    REPORT-BASED EXPLOIT: STEAL A BRAINROT
    Based on Section 2.1 (Physics) & 5.2 (Bypass)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local CoreGui = game:GetService("CoreGui")

-- تنظيف الواجهة القديمة
if CoreGui:FindFirstChild("AnalystGUI") then CoreGui.AnalystGUI:Destroy() end

-- 1. إنشاء الواجهة (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnalystGUI"
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.1, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Title.Text = "REPORT IMPLEMENTATION"
Title.TextColor3 = Color3.white
Title.Font = Enum.Font.Code
Title.Parent = Frame

-- 2. تنفيذ كود التقرير (Noclip - Section 2.1)
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(1, 0, 0, 40)
NoclipBtn.Position = UDim2.new(0, 0, 0, 35)
NoclipBtn.Text = "1. تفعيل النوكليب (Sec 2.1)"
NoclipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NoclipBtn.TextColor3 = Color3.white
NoclipBtn.Parent = Frame

local noclipLoop = nil
NoclipBtn.MouseButton1Click:Connect(function()
    if noclipLoop then
        noclipLoop:Disconnect()
        noclipLoop = nil
        NoclipBtn.Text = "1. تفعيل النوكليب (Sec 2.1)"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    else
        NoclipBtn.Text = "✅ النوكليب شغال"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- هذا هو الكود المذكور في التقرير بالضبط
        noclipLoop = RunService.Stepped:Connect(function()
            if LP.Character then
                for _, part in pairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- 3. أداة الانتقال (لتجاوز Rubberbanding - Section 5.2)
local TPBtn = Instance.new("TextButton")
TPBtn.Size = UDim2.new(1, 0, 0, 40)
TPBtn.Position = UDim2.new(0, 0, 0, 80)
TPBtn.Text = "2. هات أداة النقل (Bypass)"
TPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TPBtn.TextColor3 = Color3.white
TPBtn.Parent = Frame

TPBtn.MouseButton1Click:Connect(function()
    local Tool = Instance.new("Tool")
    Tool.Name = "🚀 Bypass TP"
    Tool.RequiresHandle = false
    Tool.Parent = LP.Backpack
    
    Tool.Activated:Connect(function()
        local Char = LP.Character
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            -- الانتقال المباشر لتجاوز فحص المشي
            Char.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)
    TPBtn.Text = "✅ الأداة في الشنطة"
    TPBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
end)
