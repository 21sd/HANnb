--//GameId: 65241
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = '寒付费',
    Icon = "crown",
    IconThemed = true,
    Author = "SL团队",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(550, 350),
    Transparent = true,
    Theme = "Midnight",
    HideSearchBar = false,
    ScrollBarEnabled = true,
    Resizable = true,
    Background = "https://raw.githubusercontent.com/21sd/-/refs/heads/main/image_download_1777804350158.jpg",
    BackgroundImageTransparency = 0.5,
    User = {
        Enabled = true,
        Callback = function()
            WindUI:Notify({
                Title = "点击了自己",
                Content = "没什么", 
                Duration = 1,
                Icon = "4483362748"
            })
        end,
        Anonymous = false
    },
    SideBarWidth = 250,
    Search = {
        Enabled = true,
        Placeholder = "搜索...",
        Callback = function(searchText)
        end
    },
    SidePanel = {
        Enabled = true,
        Content = {
            {
                Type = "Button", 
                Text = "",
                Style = "Subtle", 
                Size = UDim2.new(1, -20, 0, 30),
                Callback = function()
                end
            }
        }
    }
})

Window:Tag({
    Title = "自然灾害",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "自然灾害",
    Icon = "gem",
    CornerRadius = UDim.new(0, 16), 
    Size = UDim2.new(0, 140, 0, 48), 
    StrokeThickness = 3,
    StrokeColor = Color3.fromRGB(0, 50, 255),
    Color = ColorSequence.new(
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(240, 240, 255),
        Color3.fromRGB(0, 30, 200),
        Color3.fromRGB(0, 10, 150)
    ),
    BackgroundColor = Color3.fromRGB(0, 15, 60),
    BackgroundTransparency = 0.1,
    Draggable = true,
})

local buttonFrame = Window.OpenButtonMain.Button
local stroke = buttonFrame:FindFirstChild("UIStroke")
if stroke then
    local gradient = stroke:FindFirstChildOfClass("UIGradient")
    if gradient then
        gradient.Color = ColorSequence.new(
            Color3.fromRGB(255,255,255),
            Color3.fromRGB(0,30,200),
            Color3.fromRGB(0,10,150),
            Color3.fromRGB(255,255,255)
        )
        game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
            gradient.Rotation = (gradient.Rotation + 60 * deltaTime) % 360
        end)
    end
end

--// Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid", 5)
local RootPart = Character:WaitForChild("HumanoidRootPart", 5)
local Disaster = Character:FindFirstChild("SurvivalTag") and Character:FindFirstChild("SurvivalTag").Value

--// State variables for toggles
local AutoFarmEnabled = false
local WalkingOnWaterEnabled = false
local IslandCollideEnabled = false
local AutoDetectDisasterEnabled = false
local AutoSayDisasterEnabled = false
local NoFallDamageEnabled = false
local NoclipEnabled = false
local FullbrightEnabled = false
local InfJumpEnabled = false
local WalkSpeedValue = 16
local JumpPowerValue = 50

local function Setup(char)
    char.ChildAdded:Connect(function(child)
        if child.Name == "SurvivalTag" then
            Disaster = child.Value
            if AutoDetectDisasterEnabled then
                WindUI:Notify({
                    Title = "检测到灾难",
                    Content = Disaster,
                    Duration = 3
                })
            end
            if AutoSayDisasterEnabled then
                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("灾难: "..Disaster)
            end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if NoFallDamageEnabled and RootPart and RootPart.Parent then
        local oldvel = RootPart.AssemblyLinearVelocity
        RootPart.AssemblyLinearVelocity = Vector3.zero
        RunService.RenderStepped:Wait()
        RootPart.AssemblyLinearVelocity = oldvel
    end
end)

LP.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Setup(newCharacter)
end)
Setup(Character)

RunService.RenderStepped:Connect(function()
    if Humanoid then
        if WalkSpeedValue ~= 16 then
            Humanoid.WalkSpeed = WalkSpeedValue
        end
        if JumpPowerValue ~= 50 then
            Humanoid.JumpPower = JumpPowerValue
        end
    end
    if NoclipEnabled and Character then
        for i, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
    if FullbrightEnabled then
        Lighting.Ambient = Color3.new(1, 1, 1)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and Humanoid then
        Humanoid:ChangeState("Jumping")
    end
end)

--// Tabs
local MainTab = Window:Tab({ Title = "主要", Icon = "home" })
local RemoveTab = Window:Tab({ Title = "移除", Icon = "trash" })
local TeleportTab = Window:Tab({ Title = "传送", Icon = "map" })
local OtherTab = Window:Tab({ Title = "其他", Icon = "settings" })

--// Main Tab
MainTab:Toggle({
    Title = "自动赢",
    Desc = "自动传送到安全位置",
    Value = false,
    Callback = function(state)
        AutoFarmEnabled = state
        if state then
            task.spawn(function()
                while AutoFarmEnabled do
                    task.wait()
                    if Character then
                        Character:PivotTo(CFrame.new(-236, 180, 360))
                    end
                end
            end)
        end
    end
})

local water = workspace:FindFirstChild("WaterLevel")
local mesh = water and water:FindFirstChild("Mesh")

MainTab:Toggle({
    Title = "在水上行走",
    Desc = "让水面可以站立",
    Value = false,
    Callback = function(state)
        WalkingOnWaterEnabled = state
        if water then
            if state then 
                water.CanCollide = true
                water.Size = Vector3.new(1000, 1, 1000)
                if mesh then mesh.Parent = nil end
            else
                water.CanCollide = false
                water.Size = Vector3.new(10, 1, 10)
                if mesh then mesh.Parent = water end
            end
        end
    end
})

MainTab:Toggle({
    Title = "游戏岛悬崖可碰撞",
    Desc = "让LowerRocks可以碰撞",
    Value = false,
    Callback = function(state)
        IslandCollideEnabled = state
        if workspace:FindFirstChild("Island") then
            for _, v in pairs(workspace.Island:GetChildren()) do
                if v.Name == "LowerRocks" then
                    v.CanCollide = state
                end
            end
        end
    end
})

MainTab:Toggle({
    Title = "自动检测灾难",
    Desc = "检测到灾难时通知",
    Value = false,
    Callback = function(state)
        AutoDetectDisasterEnabled = state
        if state and Disaster then
            WindUI:Notify({
                Title = "检测到灾难",
                Content = Disaster,
                Duration = 3
            })
        end
    end
})

MainTab:Toggle({
    Title = "聊天通知灾难",
    Desc = "在聊天中发送灾难信息",
    Value = false,
    Callback = function(state)
        AutoSayDisasterEnabled = state
        if state and Disaster then
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("灾难: "..Disaster)
        end
    end
})

MainTab:Toggle({
    Title = "无掉落伤害",
    Desc = "防止掉落伤害",
    Value = false,
    Callback = function(state)
        NoFallDamageEnabled = state
    end
})

local items = {"GreenBalloon", "RedApple", "Compass"}
MainTab:Button({
    Title = "获得物品 (需要别人有)",
    Desc = "从其他玩家处克隆物品",
    Callback = function()
        for _, itemName in pairs(items) do
            for _, v in pairs(Players:GetDescendants()) do
                if v.Name == itemName and not (LP.Backpack:FindFirstChild(itemName) or Character:FindFirstChild(itemName)) then
                    v:Clone().Parent = LP.Backpack
                end
            end
        end
    end
})

--// Remove Tab
RemoveTab:Button({
    Title = "移除沙尘暴UI",
    Desc = "删除沙尘暴界面",
    Callback = function()
        if LP.PlayerGui:FindFirstChild("SandStormGui") then
            LP.PlayerGui.SandStormGui:Destroy()
        end
    end
})

RemoveTab:Button({
    Title = "移除暴风雪UI",
    Desc = "删除暴风雪界面",
    Callback = function()
        if LP.PlayerGui:FindFirstChild("BlizzardGui") then
            LP.PlayerGui.BlizzardGui:Destroy()
        end
    end
})

RemoveTab:Button({
    Title = "移除广告",
    Desc = "删除ForwardPortal",
    Callback = function()
        if workspace:FindFirstChild("ForwardPortal") then
            workspace.ForwardPortal:Destroy()
        end
    end
})

--// Teleport Tab
TeleportTab:Button({
    Title = "大厅",
    Desc = "传送到大厅",
    Callback = function()
        if Character then
            Character:PivotTo(CFrame.new(-255, 194, 299))
        end
    end
})

TeleportTab:Button({
    Title = "地图",
    Desc = "传送到地图",
    Callback = function()
        if Character then
            Character:PivotTo(CFrame.new(-117, 47, 5))
        end
    end
})

--// Other Tab
OtherTab:Slider({
    Title = "移动速度",
    Desc = "调整角色移动速度",
    Step = 1,
    Value = {
        Min = 0,
        Max = 500,
        Default = 16
    },
    Callback = function(value)
        WalkSpeedValue = value
        if Humanoid then
            Humanoid.WalkSpeed = value
        end
    end
})

OtherTab:Slider({
    Title = "跳跃高度",
    Desc = "调整角色跳跃高度",
    Step = 1,
    Value = {
        Min = 0,
        Max = 500,
        Default = 50
    },
    Callback = function(value)
        JumpPowerValue = value
        if Humanoid then
            Humanoid.JumpPower = value
        end
    end
})

OtherTab:Button({
    Title = "飞行",
    Desc = "加载飞行脚本",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/main/Content/FlyGuiV3"))()
    end
})

OtherTab:Toggle({
    Title = "穿墙",
    Desc = "开启穿墙模式",
    Value = false,
    Callback = function(state)
        NoclipEnabled = state
        if not state and Humanoid then
            Humanoid:ChangeState("Flying")
        end
    end
})

OtherTab:Toggle({
    Title = "夜视",
    Desc = "开启全亮模式",
    Value = false,
    Callback = function(state)
        FullbrightEnabled = state
        if not state then
            Lighting.Ambient = Color3.new(0, 0, 0)
        end
    end
})

OtherTab:Toggle({
    Title = "无限跳",
    Desc = "可以无限跳跃",
    Value = false,
    Callback = function(state)
        InfJumpEnabled = state
    end
})
