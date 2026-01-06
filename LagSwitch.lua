-- Lag Switch (Blink) - IMPROVED VERSION
-- للعبة Steal a Brainrot - إصدار محسن
-- بيخليك تتحرك من غير ما السيرفر يحس بيك + يمسك الأشياء

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- 1. تنظيف
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "LagSwitchGUI" then v:Destroy() end
end

-- 2. إعداد الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LagSwitchGUI"
ScreenGui.ResetOnSpawn = false
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = CoreGui

-- زر اللاج
local Btn = Instance.new("TextButton")
Btn.Parent = ScreenGui
Btn.Size = UDim2.new(0, 150, 0, 150)
Btn.Position = UDim2.new(0.7, 0, 0.4, 0)
Btn.Text = "LAG: OFF 🟢"
Btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.FredokaOne
Btn.TextSize = 20
Btn.Active = true
Btn.Draggable = true
Btn.TextScaled = true

-- زر الإمساك التلقائي
local GrabBtn = Instance.new("TextButton")
GrabBtn.Parent = ScreenGui
GrabBtn.Size = UDim2.new(0, 120, 0, 40)
GrabBtn.Position = UDim2.new(0.7, 0, 0.55, 0)
GrabBtn.Text = "AUTO GRAB: OFF"
GrabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
GrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GrabBtn.Font = Enum.Font.Gotham
GrabBtn.TextSize = 14
GrabBtn.Active = true
GrabBtn.Visible = false -- يظهر لما اللاج يشتغل

-- تجميل
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = Btn

local GrabCorner = Instance.new("UICorner")
GrabCorner.CornerRadius = UDim.new(0.5, 0)
GrabCorner.Parent = GrabBtn

-- 3. المتغيرات
local Lagging = false
local AutoGrab = false
local OldPos = nil
local StolenObjects = {}
local AntiReturn = false

-- 4. نظام الإمساك التلقائي المحسن
local function AutoGrabItems()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local pos = LP.Character.HumanoidRootPart.Position
    
    -- البحث عن كل الأشياء في ووركسبيس
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent then
            -- الكلمات الدلالية للأشياء المسروقة
            local name = obj.Name:lower()
            if name:find("brain") or name:find("item") or name:find("coin") or name:find("cash") then
                local distance = (obj.Position - pos).Magnitude
                
                if distance < 20 then -- مسافة أكبر
                    -- تيليبورت الشيء للاعب
                    pcall(function()
                        obj.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                        
                        -- تأكيد الإمساك
                        if not table.find(StolenObjects, obj) then
                            table.insert(StolenObjects, obj)
                            Btn.Text = "LAG: ON 🔴\n(Grabbed!)"
                        end
                    end)
                end
            end
        end
    end
end

-- 5. وظيفة اللاج المحسنة
Btn.MouseButton1Click:Connect(function()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
        Btn.Text = "NO CHARACTER"
        task.wait(1)
        Btn.Text = "LAG: OFF 🟢"
        return
    end
    
    Lagging = not Lagging
    
    if Lagging then
        -- تشغيل اللاج (قطع الاتصال الوهمي)
        Btn.Text = "LAG: ON 🔴\n(Walk Now!)"
        Btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
        -- إظهار زر الإمساك
        GrabBtn.Visible = true
        
        -- حفظ المكان الأصلي
        OldPos = LP.Character.HumanoidRootPart.CFrame
        
        -- لاج أقوى + تعطيل فيزياء
        settings().Network.IncomingReplicationLag = 3000 -- زيادة القيمة
        settings().Physics.PhysicsSendRate = 0
        
        -- تعطيل الاصطدامات فوراً
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Velocity = Vector3.new(0, 0, 0)
            end
        end
        
        -- تفعيل نظام منع العودة
        AntiReturn = true
        
        -- مؤقت تلقائي 10 ثواني
        task.spawn(function()
            task.wait(10)
            if Lagging then
                Lagging = false
                Btn.Text = "LAG: OFF 🟢"
                Btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                GrabBtn.Visible = false
                settings().Network.IncomingReplicationLag = 0
                settings().Physics.PhysicsSendRate = 60
                AntiReturn = false
            end
        end)
        
    else
        -- إعادة الاتصال
        Btn.Text = "LAG: OFF 🟢"
        Btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        GrabBtn.Visible = false
        
        -- إرجاع الإعدادات
        settings().Network.IncomingReplicationLag = 0
        settings().Physics.PhysicsSendRate = 60
        
        -- إعادة الاصطدامات بعد تأخير
        task.spawn(function()
            task.wait(1)
            if LP.Character then
                for _, part in pairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end)
        
        -- إيقاف نظام منع العودة بعد 5 ثواني
        task.spawn(function()
            task.wait(5)
            AntiReturn = false
        end)
    end
end)

-- 6. زر الإمساك التلقائي
GrabBtn.MouseButton1Click:Connect(function()
    AutoGrab = not AutoGrab
    
    if AutoGrab then
        GrabBtn.Text = "AUTO GRAB: ON"
        GrabBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        Btn.Text = "LAG: ON 🔴\n(Auto-Grab ON)"
    else
        GrabBtn.Text = "AUTO GRAB: OFF"
        GrabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
        Btn.Text = "LAG: ON 🔴\n(Walk Now!)"
    end
end)

-- 7. نظام منع العودة (الأهم)
RunService.Heartbeat:Connect(function()
    if AntiReturn and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        
        -- إذا حاول النظام إرجاعك للمكان القديم
        if OldPos and (hrp.Position - OldPos.Position).Magnitude < 10 then
            pcall(function()
                -- إرجاعك فوراً للمكان الجديد
                hrp.CFrame = OldPos
            end)
        end
    end
end)

-- 8. نظام الإمساك التلقائي أثناء التشغيل
RunService.Stepped:Connect(function()
    if Lagging then
        -- طول ما اللاج شغال، امسح التصادم
        if LP.Character then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then 
                    v.CanCollide = false 
                end
            end
        end
        
        -- إذا كان الإمساك التلقائي مفعل
        if AutoGrab then
            AutoGrabItems()
        end
    end
end)

-- 9. إعادة تعيين عند موت اللاعب
LP.CharacterAdded:Connect(function(character)
    task.wait(1)
    if Lagging then
        Lagging = false
        Btn.Text = "LAG: OFF 🟢"
        Btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        GrabBtn.Visible = false
        settings().Network.IncomingReplicationLag = 0
        settings().Physics.PhysicsSendRate = 60
        AntiReturn = false
        AutoGrab = false
    end
end)

print("✅ Lag Switch IMPROVED Loaded!")
print("🎯 المميزات الجديدة:")
print("1. نظام منع العودة التلقائي")
print("2. إمساك تلقائي للأشياء")
print("3. لاج أقوى (3000ms)")
print("4. مؤقت تلقائي 10 ثواني")
