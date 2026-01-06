-- Improved Lag Switch (Blink) for Steal a Brainrot
-- Version: 2.0 - Fixed Issues

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- تنظيف شامل
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "LagSwitchGUI" then 
        v:Destroy() 
    end
end

-- إعداد واجهة محسنة
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

-- المتغيرات الأساسية
local Lagging = false
local OriginalPosition = nil
local OriginalNetworkSettings = {
    IncomingReplicationLag = settings().Network.IncomingReplicationLag,
    PhysicsSendRate = settings().Physics.PhysicsSendRate
}
local OriginalCollisions = {}
local AntiReturnEnabled = false
local CollectedObjects = {}

-- دالة لحفظ الاصطدامات الأصلية
local function SaveOriginalCollisions()
    OriginalCollisions = {}
    if LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                OriginalCollisions[part] = part.CanCollide
            end
        end
    end
end

-- دالة لإعادة الاصطدامات
local function RestoreCollisions()
    for part, canCollide in pairs(OriginalCollisions) do
        if part and part.Parent then
            pcall(function()
                part.CanCollide = canCollide
            end)
        end
    end
    OriginalCollisions = {}
end

-- دالة لتفعيل وضع النقل الآمن
local function EnableSafeTeleport()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    SaveOriginalCollisions()
    
    -- تعطيل الاصطدامات مؤقتاً
    for _, part in pairs(LP.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Velocity = Vector3.new(0, 0, 0)
            part.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
    
    -- حفظ الموقع الأصلي
    OriginalPosition = LP.Character.HumanoidRootPart.CFrame
    
    -- ضبط إعدادات الشبكة للـ Lag
    settings().Network.IncomingReplicationLag = 5000
    settings().Physics.PhysicsSendRate = 0
    
    StatusLabel.Text = "Status: Teleporting..."
    return true
end

-- دالة لتعطيل وضع النقل
local function DisableSafeTeleport()
    -- إعادة إعدادات الشبكة
    settings().Network.IncomingReplicationLag = OriginalNetworkSettings.IncomingReplicationLag
    settings().Physics.PhysicsSendRate = OriginalNetworkSettings.PhysicsSendRate
    
    -- إعادة الاصطدامات
    RestoreCollisions()
    
    StatusLabel.Text = "Status: Complete"
    
    -- تفعيل نظام منع العودة (Anti-Return)
    task.spawn(function()
        AntiReturnEnabled = true
        task.wait(5)
        AntiReturnEnabled = false
    end)
end

-- نظام منع العودة التلقائي
RunService.Stepped:Connect(function()
    if AntiReturnEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        
        -- الكشف عن محاولات إرجاعك
        if OriginalPosition then
            local distance = (hrp.Position - OriginalPosition.Position).Magnitude
            
            -- إذا حاول النظام إرجاعك للمكان القديم
            if distance < 5 then
                -- إعادة النقل للمكان الجديد
                task.spawn(function()
                    pcall(function()
                        hrp.CFrame = OriginalPosition
                    end)
                end)
            end
        end
    end
end)

-- نظام جمع الأشياء أثناء اللاج
local function CollectNearbyObjects()
    if not LP.Character then return end
    
    local characterPosition = LP.Character.HumanoidRootPart.Position
    
    for _, obj in pairs(workspace:GetChildren()) do
        -- تحديد الأشياء التي يمكن جمعها
        if obj:IsA("BasePart") and (obj.Name:find("Brain") or obj.Name:find("Item") or obj.Name:find("Loot")) then
            local distance = (obj.Position - characterPosition).Magnitude
            
            if distance < 50 then
                table.insert(CollectedObjects, {
                    Object = obj,
                    OriginalPosition = obj.CFrame
                })
                
                -- نقل الشيء للاعب
                local success = pcall(function()
                    obj.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                end)
                
                if success then
                    StatusLabel.Text = "Status: Collected " .. obj.Name
                end
            end
        end
    end
end

-- زر التحكم الرئيسي
Btn.MouseButton1Click:Connect(function()
    if Lagging then
        -- إيقاف اللاج
        Lagging = false
        Btn.Text = "LAG: OFF 🟢"
        Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        DisableSafeTeleport()
        
        -- جمع الأشياء القريبة قبل الإيقاف
        CollectNearbyObjects()
        
    else
        -- تفعيل اللاج
        if EnableSafeTeleport() then
            Lagging = true
            Btn.Text = "LAG: ON 🔴\nMOVE NOW!"
            Btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            
            StatusLabel.Text = "Status: Move to target!"
            
            -- مؤقت تلقائي للإيقاف بعد 10 ثواني
            task.spawn(function()
                task.wait(10)
                if Lagging then
                    Lagging = false
                    Btn.Text = "LAG: OFF 🟢"
                    Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                    
                    DisableSafeTeleport()
                    CollectNearbyObjects()
                end
            end)
        end
    end
end)

-- إعادة تعيين عند موت اللاعب
LP.CharacterAdded:Connect(function()
    task.wait(1)
    if Lagging then
        Lagging = false
        Btn.Text = "LAG: OFF 🟢"
        Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        DisableSafeTeleport()
    end
end)

print("Lag Switch v2.0 - Loaded Successfully!")
