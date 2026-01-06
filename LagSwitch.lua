-- 🚨 SILENT STEAL SYSTEM 🚨
-- نظام سرقة صامت - ما بيخليش السيرفر يحس بيك خالص
-- للعبة Steal a Brainrot - إصدار نهائي

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- تنظيف
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "SilentStealGUI" then v:Destroy() end
end

-- واجهة بسيطة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SilentStealGUI"
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = CoreGui

local MainBtn = Instance.new("TextButton")
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 160, 0, 50)
MainBtn.Position = UDim2.new(0.8, 0, 0.5, 0)
MainBtn.Text = "🚪 ENTER STEAL MODE"
MainBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 200)
MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainBtn.Font = Enum.Font.FredokaOne
MainBtn.TextSize = 18
MainBtn.Active = true
MainBtn.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.3, 0)
Corner.Parent = MainBtn

-- المتغيرات
local StealMode = false
local OriginalCFrame = nil
local Teleporting = false
local ItemsCollected = {}

-- النظام الجديد: تخزين اللاعب في مكان وهمي
local function CreateGhostPlayer()
    if not LP.Character then return nil end
    
    -- نسخ الشخصية كاملة
    local ghost = LP.Character:Clone()
    
    -- جعل النسخة شفافة
    for _, part in pairs(ghost:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0.8
            part.CanCollide = false
            part.Anchored = true
        end
    end
    
    ghost.Parent = workspace
    ghost.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame
    
    return ghost
end

-- النظام الأساسي: سرقة صامتة
MainBtn.MouseButton1Click:Connect(function()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    
    if not StealMode then
        -- بدء وضع السرقة
        StealMode = true
        MainBtn.Text = "🔄 STEALING..."
        MainBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        
        -- حفظ مكان اللاعب الأصلي
        OriginalCFrame = LP.Character.HumanoidRootPart.CFrame
        
        -- إنشاء نسخة وهمية للاعب في مكانه الأصلي
        local ghost = CreateGhostPlayer()
        
        -- تعطيل فيزياء اللاعب الحقيقي
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Transparency = 0.3
            end
        end
        
        -- جعل اللاعب شبه مخفي للسيرفر
        LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        
        wait(0.5)
        
        -- الآن اللاعب يقدر يتحرك بحرية
        MainBtn.Text = "🎯 MOVE & GRAB ITEMS"
        MainBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        
        -- مؤقت 15 ثانية للسرقة
        task.spawn(function()
            wait(15)
            if StealMode then
                StealMode = false
                MainBtn.Text = "🚪 ENTER STEAL MODE"
                MainBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 200)
                
                -- إرجاع اللاعب لمكانه الأصلي
                if OriginalCFrame then
                    LP.Character.HumanoidRootPart.CFrame = OriginalCFrame
                end
                
                -- إعادة الإعدادات
                for _, part in pairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                        part.Transparency = 0
                    end
                end
                
                -- تنظيف النسخة الوهمية
                if ghost then
                    ghost:Destroy()
                end
            end
        end)
        
    else
        -- إيقاف وضع السرقة يدوياً
        StealMode = false
        MainBtn.Text = "🚪 ENTER STEAL MODE"
        MainBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 200)
        
        -- إرجاع اللاعب لمكانه الأصلي
        if OriginalCFrame then
            LP.Character.HumanoidRootPart.CFrame = OriginalCFrame
        end
        
        -- إعادة الإعدادات
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
                part.Transparency = 0
            end
        end
    end
end)

-- نظام جمع الأشياء التلقائي
RunService.Heartbeat:Connect(function()
    if StealMode and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local playerPos = LP.Character.HumanoidRootPart.Position
        
        -- البحث عن أشياء قريبة
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                local objName = obj.Name:lower()
                
                -- التحقق إذا كان الشيء مسروق
                if objName:find("brain") or objName:find("money") or 
                   objName:find("coin") or objName:find("cash") or
                   objName:find("item") or objName:find("loot") then
                    
                    local objPos = obj:IsA("BasePart") and obj.Position or 
                                   (obj.PrimaryPart and obj.PrimaryPart.Position)
                    
                    if objPos then
                        local distance = (playerPos - objPos).Magnitude
                        
                        if distance < 15 then -- مسافة الجمع
                            -- إخفاء الشيء بدل حذفه
                            pcall(function()
                                if obj:IsA("BasePart") then
                                    obj.Transparency = 1
                                    obj.CanCollide = false
                                    obj.Anchored = true
                                    
                                    -- حفظ الشيء في جدول
                                    if not table.find(ItemsCollected, obj) then
                                        table.insert(ItemsCollected, obj)
                                        MainBtn.Text = "💰 ITEM COLLECTED"
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- منع العودة التلقائي
RunService.Stepped:Connect(function()
    if StealMode and OriginalCFrame then
        local distance = (LP.Character.HumanoidRootPart.Position - OriginalCFrame.Position).Magnitude
        
        -- إذا اللاعب بعيد جداً، إرجاعه قليلاً
        if distance > 100 then
            LP.Character.HumanoidRootPart.CFrame = OriginalCFrame
        end
    end
end)

print("✅ Silent Steal System Loaded!")
print("🎮 التعليمات:")
print("1. اضغط الزر الأزرق للدخول لوضع السرقة")
print("2. حرك شخصيتك بحرية (مخفي عن السيرفر)")
print("3. اقترب من الأشياء لتجميعها تلقائياً")
print("4. بعد 15 ثانية أو اضغط الزر مرة أخرى للخروج")
