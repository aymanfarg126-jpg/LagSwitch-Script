-- Safe Teleport Tool (No Noclip Loop = No Crash)
-- ده مجرد أداة نقل بدون أي لعب في ملفات اللعبة

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- تنظيف لو الأداة موجودة
if LP.Backpack:FindFirstChild("⚡ تليفون النقل") then 
    LP.Backpack["⚡ تليفون النقل"]:Destroy() 
end

-- صناعة الأداة
local Tool = Instance.new("Tool")
Tool.Name = "⚡ تليفون النقل"
Tool.RequiresHandle = false
Tool.Parent = LP.Backpack

-- وظيفة النقل فقط (سطر واحد خفيف)
Tool.Activated:Connect(function()
    local Char = LP.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") and Mouse.Hit then
        -- النقل لمكان الماوس + 3 متر لفوق عشان متغرسش
        local newPos = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 4, 0))
        Char.HumanoidRootPart.CFrame = newPos
    end
end)

-- رسالة تأكيد خفيفة
game.StarterGui:SetCore("SendNotification", {
    Title = "تم التشغيل";
    Text = "افتح الشنطة واستخدم الأداة.";
    Duration = 3;
})
