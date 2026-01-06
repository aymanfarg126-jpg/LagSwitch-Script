-- ⚡ REAL LAG SWITCH v4.0 - STRONG VERSION
-- لعبة Steal a Brainrot - تجاوز كل الحواجز
-- By Ayman - إصدار نهائي قوي

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- تنظيف شامل
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "LagSwitchGUI" then v:Destroy() end
end

-- إعداد واجهة قوية
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
MainFrame.Size = UDim2.new(0, 220, 0, 250)
MainFrame.Position = UDim2.new(0.7, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.15, 0)
Corner.Parent = MainFrame

-- زر رئيسي قوي
local Btn = Instance.new("TextButton")
Btn.Name = "LagButton"
Btn.Size = UDim2.new(0.85, 0, 0.5, 0)
Btn.Position = UDim2.new(0.075, 0, 0.05, 0)
Btn.Text = "⚡ LAG: OFF"
Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.FredokaOne
Btn.TextSize = 26
Btn.TextScaled = false
Btn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0.1, 0)
BtnCorner.Parent = Btn

-- زر الإمساك التلقائي
local GrabBtn = Instance.new("TextButton")
GrabBtn.Name = "GrabButton"
GrabBtn.Size = UDim2.new(0.85, 0, 0.2, 0)
GrabBtn.Position = UDim2.new(0.075, 0, 0.6, 0)
GrabBtn.Text = "🔄 AUTO GRAB: OFF"
GrabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
GrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GrabBtn.Font = Enum.Font.GothamBold
GrabBtn.TextSize = 18
GrabBtn.Parent = MainFrame

local GrabCorner = Instance.new("UICorner")
GrabCorner.CornerRadius = UDim.new(0.1, 0)
GrabCorner.Parent = GrabBtn

-- حالة النظام
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.85, 0, 0.15, 0)
StatusLabel.Position = UDim2.new(0.075, 0, 0.85, 0)
StatusLabel.Text = "✅ System Ready"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextSize = 16
StatusLabel.Parent = MainFrame

-- المتغيرات
local Lagging = false
local AutoGrab = false
local OriginalPosition = nil
local TeleportLock = false
local StrongLagEnabled = false
local StolenObjects = {}
local Connection1, Connection2, Connection3

-- 🔧 نظام لاج قوي جداً
local function EnableStrongLag()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    -- حفظ المكان بدقة
    OriginalPosition = LP.Character.HumanoidRootPart.CFrame
    
    -- نظام لاج متعدد الطبقات
    settings().Network.IncomingReplicationLag = 50000
    settings().Physics.PhysicsSendRate = 0
    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0.5)
    
    -- إبطاء الفيزياء
    game:GetService("PhysicsService"):SetPhysicsEnvironmentalThrottle(0.1)
    
    -- تعطيل الاصطدامات بالكامل
    for _, part in pairs(LP.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
            part.Velocity = Vector3.new(0, 0, 0)
        end
    end
    
    -- حماية ضد العودة
    TeleportLock = true
    StrongLagEnabled = true
    
    return true
end

-- 🔧 نظام إيقاف اللاج
local function DisableStrongLag()
    -- إعادة كل الإعدادات
    settings().Network.IncomingReplicationLag = 0
    settings().Physics.PhysicsSendRate = 60
    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(1024)
    game:GetService("PhysicsService"):SetPhysicsEnvironmentalThrottle(1)
    
    -- إعادة الاصطدامات بعد تأخير
    task.spawn(function()
        task.wait(2)
        if LP.Character then
            for _, part in pairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.Massless = false
                end
            end
        end
    end)
    
    TeleportLock = false
    task.wait(1)
    StrongLagEnabled = false
end

-- 🛡️ نظام منع العودة القوي
Connection1 = RunService.Heartbeat:Connect(function()
    if TeleportLock and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        
        -- إذا حاولوا يرجعوك
        if OriginalPosition then
            local distance = (hrp.Position - OriginalPosition.Position).Magnitude
            if distance < 15 then
                -- إرجاعك فوراً مع اهتزاز
                local randomOffset = Vector3.new(
                    math.random(-2, 2),
                    0,
                    math.random(-2, 2)
                )
                pcall(function()
                    hrp.CFrame = OriginalPosition + randomOffset
                end)
            end
        end
    end
end)

-- 🎯 نظام الإمساك التلقائي القوي
local function StrongAutoGrab()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local characterPos = LP.Character.HumanoidRootPart.Position
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent then
            -- البحث عن أي شيء يمكن سرقته
            local objName = obj.Name:lower()
            local isStealable = false
            
            -- كلمات دلالية للأشياء المسروقة
            local keywords = {"brain", "item", "loot", "coin", "cash", "money", "diamond", "gold", "treasure", "reward"}
            
            for _, keyword in pairs(keywords) do
                if objName:find(keyword) then
                    isStealable = true
                    break
                end
            end
            
            if isStealable then
                local distance = (obj.Position - characterPos).Magnitude
                
                if distance < 25 then
                    -- تيليبورت الشيء لك
                    pcall(function()
                        obj.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        
                        -- إضافة للقائمة
                        if not table.find(StolenObjects, obj) then
                            table.insert(StolenObjects, obj)
                            StatusLabel.Text = "👜 Grabbed: " .. obj.Name
                        end
                    end)
                end
            end
        end
    end
end

-- 🔄 تحديث الإمساك التلقائي
Connection2 = RunService.Heartbeat:Connect(function()
    if AutoGrab and Lagging then
        StrongAutoGrab()
    end
end)

-- 🎮 زر اللاج الرئيسي
Btn.MouseButton1Click:Connect(function()
    if Lagging then
        -- إيقاف اللاج
        Lagging = false
        Btn.Text = "⚡ LAG: OFF"
        Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        
        DisableStrongLag()
        StatusLabel.Text = "✅ Mission Complete"
        
    else
        -- تفعيل اللاج القوي
        if EnableStrongLag() then
            Lagging = true
            Btn.Text = "⚡ LAG: ON"
            Btn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
            StatusLabel.Text = "🚨 LAG ACTIVE - MOVE FAST!"
            
            -- مؤقت 7 ثواني (مثالي)
            task.spawn(function()
                task.wait(7)
                if Lagging then
                    Lagging = false
                    Btn.Text = "⚡ LAG: OFF"
                    Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                    DisableStrongLag()
                    StatusLabel.Text = "🕒 Auto-Stopped"
                end
            end)
        end
    end
end)

-- 🎮 زر الإمساك التلقائي
GrabBtn.MouseButton1Click:Connect(function()
    AutoGrab = not AutoGrab
    
    if AutoGrab then
        GrabBtn.Text = "🔄 AUTO GRAB: ON"
        GrabBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        StatusLabel.Text = "🎯 Auto-Grab Enabled"
    else
        GrabBtn.Text = "🔄 AUTO GRAB: OFF"
        GrabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
        StatusLabel.Text = "✅ Auto-Grab Disabled"
    end
end)

-- 🛡️ حماية ضد الموت
LP.CharacterAdded:Connect(function(character)
    task.wait(1.5)
    if Lagging then
        Lagging = false
        Btn.Text = "⚡ LAG: OFF"
        Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        DisableStrongLag()
    end
end)

-- 🧹 تنظيف الذاكرة
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    if Lagging then
        DisableStrongLag()
    end
end)

print("")
print("⚡ REAL LAG SWITCH v4.0 LOADED ⚡")
print("✅ زر اللاج: قوي ومباشر")
print("✅ الإمساك التلقائي: يشمل كل الأشياء")
print("✅ منع العودة: نظام متقدم")
print("✅ الوقت: 7 ثواني مثالية")
print("")

StatusLabel.Text = "🔥 SYSTEM READY - PRESS RED BUTTON"
