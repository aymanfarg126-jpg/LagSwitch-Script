-- UNLOCK BASE (Chilli Logic)
-- بيفتح كل القواعد والمخازن المقفولة

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = Library:MakeWindow({Name = "🔓 UNLOCKER", HidePremium = false, SaveConfig = false, ConfigFolder = "UnlockConfig"})

local Tab = Window:MakeTab({Name = "Base & Tycoon", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- 1. الزرار اللي أنت عاوزه (Unlock Base)
Tab:AddButton({
	Name = "🔓 UNLOCK ALL BASES (Delete Doors)",
	Callback = function()
        local Count = 0
        -- البحث عن كل الأبواب والحواجز في الماب
        for _, object in pairs(workspace:GetDescendants()) do
            -- قائمة الأسماء اللي السكربت بيدور عليها عشان يمسحها
            local names = {
                "Door", "Gate", "Laser", "Barrier", "OwnerDoor", 
                "Security", "Glass", "Wall", "Entrance"
            }
            
            for _, name in pairs(names) do
                -- لو لقينا جزء اسمه زي الأسماء دي
                if string.find(object.Name, name) or object.Name == name then
                    -- نتأكد إنه مش الأرضية ولا اللاعبين
                    if object:IsA("BasePart") and not object.Parent:FindFirstChild("Humanoid") then
                        object:Destroy() -- امسحه فوراً
                        Count = Count + 1
                    end
                end
            end
        end
        
        Library:MakeNotification({
            Name = "Success!", 
            Content = "Unlocked " .. Count .. " doors/walls. Enter now!", 
            Time = 4
        })
  	end
})

-- 2. زرار إضافي: سرقة القاعدة (Claim Tycoon)
Tab:AddButton({
	Name = "🏠 Auto Claim Free Tycoon",
	Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            -- البحث عن زرار البداية (Begin / Claim)
            if v.Name == "TouchInterest" and v.Parent then
                if string.find(string.lower(v.Parent.Name), "claim") or string.find(string.lower(v.Parent.Name), "begin") or string.find(string.lower(v.Parent.Name), "owner") then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
        end
  	end
})

-- 3. زرار الطوارئ (Noclip) لو الباب متمسحش
Tab:AddToggle({
	Name = "👻 Noclip (Walk Through)",
	Default = false,
	Callback = function(Value)
        getgenv().Noclip = Value
        game:GetService("RunService").Stepped:Connect(function()
            if getgenv().Noclip and game.Players.LocalPlayer.Character then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
	end
})

Library:Init()
