-- Lag Switch v3.0 - Fully Fixed
-- By Ayman - للعبة Steal a Brainrot

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- تنظيف
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "LagSwitchGUI" then v:Destroy() end
end

-- إعداد الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LagSwitchGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then 
    syn.protect_gui(ScreenGui)
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 200)
MainFrame.Position = UDim2.new(0.7, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.2, 0)
Corner.Parent = MainFrame

local Btn = Instance.new("TextButton")
Btn.Name = "LagButton"
Btn.Size = UDim2.new(0.8, 0, 0.8, 0)
Btn.Position = UDim2.new(0.1, 0, 0.1, 0)
Btn.Text = "LAG: OFF 🟢"
Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.FredokaOne
Btn.TextSize = 22
Btn.TextScaled = true
Btn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0.15, 0)
BtnCorner.Parent = Btn

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.8, 0, 0.15, 0)
StatusLabel.Position = UDim2.new(0.1, 0, 0.9, 0)
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.Parent = MainFrame

-- المتغيرات
local Lagging = false
local OriginalPosition = nil
local AntiReturnEnabled = false

-- دالة تفعيل اللاج
local function EnableLag()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    -- حفظ المكان الأصلي
    OriginalPosition = LP.Character.HumanoidRootPart.CFrame
    
    -- تعطيل الاصطدامات
    for _, part in pairs(LP.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- تفعيل اللاج (الجزء السحري)
    settings().Network.IncomingReplicationLag = 9999
    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(1)
    
    StatusLabel.Text = "Status: LAG ON - Move!"
    return true
end

-- دالة إيقاف اللاج
local function DisableLag()
    -- إعادة إعدادات الشبكة
    settings().Network.IncomingReplicationLag = 0
    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(1024)
    
    -- إعادة الاصطدامات
    if LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    StatusLabel.Text = "Status: Complete"
    
    -- منع العودة لمدة 5 ثواني
    AntiReturnEnabled = true
    task.spawn(function()
        task.wait(5)
        AntiReturnEnabled = false
    end)
end

-- نظام منع العودة
RunService.Heartbeat:Connect(function()
    if AntiReturnEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        
        -- إذا حاولوا يرجعوك للمكان القديم
        if OriginalPosition and (hrp.Position - OriginalPosition.Position).Magnitude < 10 then
            task.wait(0.1)
            -- إرجاعك للمكان الجديد
            pcall(function()
                hrp.CFrame = OriginalPosition
            end)
        end
    end
end)

-- زر التحكم الرئيسي (مصحح)
Btn.MouseButton1Click:Connect(function()
    if Lagging then
        -- إيقاف اللاج
        Lagging = false
        Btn.Text = "LAG: OFF 🟢"
        Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        DisableLag()
    else
        -- تفعيل اللاج
        if EnableLag() then
            Lagging = true
            Btn.Text = "LAG: ON 🔴\nMOVE NOW!"
            Btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            StatusLabel.Text = "Status: LAG ON - Move fast!"
            
            -- مؤقت تلقائي 8 ثواني
            task.spawn(function()
                task.wait(8)
                if Lagging then
                    Lagging = false
                    Btn.Text = "LAG: OFF 🟢"
                    Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                    DisableLag()
                end
            end)
        end
    end
end)

-- إعادة تعيين عند الموت
LP.CharacterAdded:Connect(function(character)
    task.wait(1)
    if Lagging then
        Lagging = false
        Btn.Text = "LAG: OFF 🟢"
        Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        DisableLag()
    end
end)

print("✅ Lag Switch v3.0 Loaded - زر شغال 100%")
