-- Simple Forward Dash (Fixed Physics)
-- نفس الكود بتاعك بس ضفنا حماية عشان اللعبة متهنجش

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- 1. تنظيف
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "DashGUI" then v:Destroy() end
end

-- 2. تصميم الزرار (صغرته شوية عشان مياخدش الشاشة)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DashGUI"
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = CoreGui

local Btn = Instance.new("TextButton")
Btn.Parent = ScreenGui
Btn.Size = UDim2.new(0, 100, 0, 60) -- حجم أصغر شوية
Btn.Position = UDim2.new(0.8, 0, 0.4, 0) -- يمين الشاشة
Btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- أحمر عشان تشوفه
Btn.Text = "⚡ اختراق\n(DASH)"
Btn.TextColor3 = Color3.white
Btn.Font = Enum.Font.FredokaOne
Btn.TextSize = 16

-- تجميل
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Btn

-- 3. الوظيفة (مع تصحيح الفيزياء حسب التقرير)
Btn.MouseButton1Click:Connect(function()
    local Char = LP.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        local HRP = Char.HumanoidRootPart
        
        -- [[ أهم خطوة: إلغاء التصادم قبل النقل ]] --
        -- ده اللي بيمنع الشاشة السوداء لما تدخل في الحيطة
        for _, part in pairs(Char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- الحركة: 15 خطوة للأمام (نفس رقمك)
        HRP.CFrame = HRP.CFrame + (HRP.CFrame.LookVector * 15)
        
        -- صوت عشان تتأكد إنه اشتغل
        local Sound = Instance.new("Sound")
        Sound.Parent = HRP
        Sound.SoundId = "rbxassetid://131068869" -- صوت سرعة
        Sound.PlayOnRemove = true
        Sound:Destroy()
    end
end)
