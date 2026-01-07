--[[ 
    REPORT-BASED SCRIPT: STEAL A BRAINROT
    Target: Bypass Server Sanity Checks & Collision
    Logic: Based on User Provided Technical Report (Section 5.2)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- إعدادات الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 130)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- العنوان
local Title = Instance.new("TextLabel")
Title.Text = "🛡️ BRAINROT BYPASS"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.TextColor3 = Color3.white
Title.Parent = MainFrame

-- 1. زرار النوكليب (حسب التقرير: RunService.Stepped)
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(1, 0, 0, 45)
NoclipBtn.Position = UDim2.new(0, 0, 0, 35)
NoclipBtn.Text = "👻 NOCLIP (V2)"
NoclipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NoclipBtn.TextColor3 = Color3.white
NoclipBtn.Parent = MainFrame

local noclipActive = false
NoclipBtn.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    if noclipActive then
        NoclipBtn.Text = "👻 NOCLIP: ON"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        NoclipBtn.Text = "👻 NOCLIP: OFF"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- تنفيذ النوكليب في كل فريم (لتجاوز فحص السيرفر)
RunService.Stepped:Connect(function()
    if noclipActive and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- 2. زرار السرقة التلقائية (Auto Interact)
local StealBtn = Instance.new("TextButton")
StealBtn.Size = UDim2.new(1, 0, 0, 45)
StealBtn.Position = UDim2.new(0, 0, 0, 85)
StealBtn.Text = "🖐️ AUTO STEAL (Nearby)"
StealBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
StealBtn.TextColor3 = Color3.white
StealBtn.Parent = MainFrame

local stealActive = false
StealBtn.MouseButton1Click:Connect(function()
    stealActive = not stealActive
    if stealActive then
        StealBtn.Text = "🖐️ STEALING..."
        StealBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
        
        -- لوب السرقة
        task.spawn(function()
            while stealActive do
                task.wait(0.1) -- سرعة معقولة عشان الكيك
                pcall(function()
                    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        local MyPos = LP.Character.HumanoidRootPart.Position
                        
                        -- التفاعل مع الأزرار (E)
                        for _, v in pairs(Workspace:GetDescendants()) do
                            if v:IsA("ProximityPrompt") then
                                if (v.Parent.Position - MyPos).Magnitude < 15 then
                                    fireproximityprompt(v)
                                end
                            end
                        end
                        
                        -- التفاعل مع اللمس (Touch)
                        for _, v in pairs(Workspace:GetDescendants()) do
                            if v:IsA("TouchTransmitter") and v.Parent then
                                if (v.Parent.Position - MyPos).Magnitude < 10 then
                                    firetouchinterest(LP.Character.HumanoidRootPart, v.Parent, 0)
                                    firetouchinterest(LP.Character.HumanoidRootPart, v.Parent, 1)
                                end
                            end
                        end
                    end
                end)
            end
            StealBtn.Text = "🖐️ AUTO STEAL (Nearby)"
            StealBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end)
    end
end)
