local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = '寒付费',
    Icon = "crown",
    IconThemed = true,
    Author = "SL团队",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(300, 200),
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
    Title = "脑叶公司",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "脑叶公司",
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

local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local TweenService = cloneref(game:GetService("TweenService"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

game:GetService("TextChatService").ChatWindowConfiguration.Enabled = true

local Assets = ReplicatedStorage:FindFirstChild("Assets")
if not Assets then
    warn("⚠️ Assets not found in ReplicatedStorage, some features may not work.")
end

LOL = LOL or {}
LOL.list = LOL.list or {}

local setting = {
    aw = false,
    AL = {},
    kill = false,
    ab = false,
}

for _, v in next, Players:GetPlayers() do
    if v ~= LocalPlayer then
        table.insert(LOL.list, v.Name)
    end
end

LocalPlayer.Idled:Connect(
    function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
)

local kill
if Assets then
    local ToolDamageEvent = Assets:FindFirstChild("RemoteEvents") and Assets.RemoteEvents:FindFirstChild("ToolDamageEvent")
    if ToolDamageEvent then
        kill = hookmetamethod(ToolDamageEvent, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            if setting.kill and method == "FireServer" then
                args[2] = math.huge
                return kill(self, unpack(args))
            end
            return kill(self, ...)
        end)
    else
        warn("ToolDamageEvent not found, kill feature disabled.")
    end
else
    warn("Assets is nil, kill feature disabled.")
end

local MainTab = Window:Tab({Title = "主要功能", Icon = "Sword"})

MainTab:Button({
    Title = "点击解锁所有异想体",
    Desc = "获得所有异想体",
    Callback = function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "LockedFrame" then
                v:Destroy()
            end
        end
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "RequirerResearchLabel" then
                v:Destroy()
            end
        end
    end
})

MainTab:Slider({
    Title = "修改武器攻击间隔",
    Desc = "武器攻击间隔",
    Value = {
        Min = 0,
        Max = 50,
        Default = 16
    },
    Callback = function(Value)
        if Character and Character:FindFirstChild("CharStats") then
            local speed = Character.CharStats:FindFirstChild("AttackSpeed")
            if speed then
                speed.Value = Value
            end
        end
    end
})

MainTab:Input({
    Title = "修改武器最大伤害",
    Callback = function(Value)
        for _,v in next,LocalPlayer.Backpack:GetChildren() do
            if v:IsA("Tool") and v:FindFirstChild("SettingValues") then
                local max = v.SettingValues:FindFirstChild("MaxDamageValue")
                if max then max.Value = Value end
            end
        end
        for _,v in next,Character:GetChildren() do
            if v:IsA("Tool") and v:FindFirstChild("SettingValues") then
                local max = v.SettingValues:FindFirstChild("MaxDamageValue")
                if max then max.Value = Value end
            end
        end
    end
})

MainTab:Input({
    Title = "修改武器最小伤害",
    Callback = function(Value)
        for _,v in next,LocalPlayer.Backpack:GetChildren() do
            if v:IsA("Tool") and v:FindFirstChild("SettingValues") then
                local min = v.SettingValues:FindFirstChild("MinDamageValue")
                if min then min.Value = Value end
            end
        end
        for _,v in next,Character:GetChildren() do
            if v:IsA("Tool") and v:FindFirstChild("SettingValues") then
                local min = v.SettingValues:FindFirstChild("MinDamageValue")
                if min then min.Value = Value end
            end
        end
    end
})

MainTab:Toggle({
    Title = "开启自动工作",
    Image = "自动工作",
    Value = false,
    Callback = function(state)
        setting.aw = state
        task.spawn(function()
            while setting.aw and task.wait() do
                if not (Character and workspace:FindFirstChild("Abnormalities")) then
                    continue
                end
                local abnormalities = workspace.Abnormalities:GetChildren()
                for _, v in ipairs(abnormalities) do
                    local module = v:FindFirstChild("Abnormality") and v.Abnormality:FindFirstChild("AbnormalityModule")
                    if not module then continue end
                    local data = require(module)
                    if not data.WorkSuccessRates then continue end
                    local highestAverage = 0
                    local bestAttribute = nil
                    for attr, rates in pairs(data.WorkSuccessRates) do
                        local sum = 0
                        for _, rate in ipairs(rates) do
                            sum = sum + rate
                        end
                        local average = sum / #rates
                        if average > highestAverage then
                            highestAverage = average
                            bestAttribute = attr
                        end
                    end
                    if bestAttribute and Assets then
                        local WorkEvent = Assets:FindFirstChild("RemoteEvents") and Assets.RemoteEvents:FindFirstChild("WorkEvent")
                        if WorkEvent then
                            WorkEvent:FireServer(v.WorkTablet, bestAttribute)
                        end
                    end
                end
            end
        end)
    end
})

MainTab:Toggle({
    Title = "自动格挡",
    Image = "自动格挡",
    Value = false,
    Callback = function(state)
        setting.ab = state
        local parryBar = LocalPlayer.PlayerGui:FindFirstChild("GameplayGui") and 
                         LocalPlayer.PlayerGui.GameplayGui:FindFirstChild("GameplayFrame") and
                         LocalPlayer.PlayerGui.GameplayGui.GameplayFrame:FindFirstChild("ParryBarHolder") and
                         LocalPlayer.PlayerGui.GameplayGui.GameplayFrame.ParryBarHolder:FindFirstChild("ParryBar")
        if not parryBar then
            warn("ParryBar not found, auto block disabled.")
            return
        end
        parryBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            if setting.ab and parryBar.AbsoluteSize.X > 126.470 then
                if Assets then
                    local ToolModuleEvent = Assets:FindFirstChild("RemoteEvents") and Assets.RemoteEvents:FindFirstChild("ToolModuleEvent")
                    if ToolModuleEvent then
                        ToolModuleEvent:FireServer("BlockEvent", LocalPlayer.Character, true)
                    end
                end
            end
        end)
    end
})

MainTab:Toggle({
    Title = "秒杀",
    Image = "秒杀",
    Value = false,
    Callback = function(state)
        setting.kill = state
    end
})

local SelectPlayer = MainTab:Dropdown({
    Title = "选择玩家",
    Values = LOL.list,
    Value = "未选择",
    Callback = function(option)
        LOL.sp = option
    end
})

MainTab:Button({
    Title = "传送玩家",
    Desc = "传送玩家",
    Callback = function()
        if LOL.sp and LOL.sp ~= "未选择" then
            local targetPlayer = Players:FindFirstChild(LOL.sp)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
})

Players.PlayerAdded:Connect(
    function(s)
        if s ~= LocalPlayer then
            table.insert(LOL.list, s.Name)
            SelectPlayer:Refresh(LOL.list)
        end
    end
)

Players.PlayerRemoving:Connect(
    function(s)
        if s ~= LocalPlayer then
            for aI, aJ in ipairs(LOL.list) do
                if aJ == s.Name then
                    table.remove(LOL.list, aI)
                    SelectPlayer:Refresh(LOL.list)
                    break
                end
            end
        end
    end
)