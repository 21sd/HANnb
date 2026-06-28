local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = '寻宝模拟器',
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
    Title = "寻宝模拟器",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "寻宝模拟器",
    Icon = "gem",
    CornerRadius = UDim.new(0, 16), 
    Size = UDim2.new(0, 140, 0, 48), 
    StrokeThickness = 3,
    Color = ColorSequence.new(
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(0, 30, 200)
    ),
    Draggable = true,
})



local PhysicsService = game:GetService("PhysicsService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- 主要功能标签页
local MainFunctions = Window:Tab({Title = "主要功能", Icon = "zap"})

-- 工具选择部分
local PlayerTool = {}
for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if v:IsA("Tool") then
        table.insert(PlayerTool, v.Name)
    end
end

local ToolName = PlayerTool[1] or ""

MainFunctions:Dropdown({
    Title = "选择工具",
    Values = PlayerTool,
    Callback = function(Value)
        ToolName = Value
    end
})

MainFunctions:Button({
    Title = "刷新工具列表",
    Callback = function()
        PlayerTool = {}
        for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                table.insert(PlayerTool, v.Name)
            end
        end
        WindUI:Notify({Title = "提示", Content = "工具列表已刷新", Duration = 2})
    end
})

-- 自动农场
local autoFarm = false
MainFunctions:Toggle({
    Title = "自动农场",
    Value = false,
    Callback = function(state)
        autoFarm = state
        if state then
            task.spawn(function()
                while autoFarm do
                    if not game.Players.LocalPlayer.Character:FindFirstChild(ToolName) then
                        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolName)
                        if tool then
                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
                        else
                            WindUI:Notify({Title = "警告", Content = "未找到工具: " .. ToolName, Duration = 3})
                            break
                        end
                    end
                    
                    for i, v in pairs(game.Workspace.SandBlocks:GetChildren()) do
                        if v and v:IsA("BasePart") then
                            local playerHead = game.Players.LocalPlayer.Character:FindFirstChild("Head")
                            if playerHead then
                                local distance = (playerHead.Position - v.Position).magnitude
                                if distance <= 30 then
                                    pcall(function()
                                        game:GetService("Players").LocalPlayer.Character.Bucket.RemoteClick:FireServer(
                                            game.Workspace.SandBlocks:FindFirstChild(v.Name)
                                        )
                                    end)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})

local autoTeleportToChest = false
MainFunctions:Toggle({
    Title = "自动传送至宝箱",
    Value = false,
    Callback = function(state)
        autoTeleportToChest = state
        if state then
            task.spawn(function()
                while autoTeleportToChest do
                    for _, sandBlock in ipairs(game.Workspace.SandBlocks:GetChildren()) do
                        if sandBlock:FindFirstChild("Chest") then
                            local chestPosition = sandBlock.CFrame
                            local character = game.Players.LocalPlayer.Character
                            if character then
                                pcall(function()
                                    character.HumanoidRootPart.CFrame = chestPosition
                                end)
                                task.wait(0.5)
                            end
                        end
                    end
                    task.wait(3)
                end
            end)
        end
    end
})

-- 自动重生
local autoRebirth = false
MainFunctions:Toggle({
    Title = "自动重生",
    Value = false,
    Callback = function(state)
        autoRebirth = state
        if state then
            task.spawn(function()
                while autoRebirth do
                    local Character = game.Workspace:WaitForChild(game.Players.LocalPlayer.Name)
                    local a = game.Players.LocalPlayer.PlayerGui.Gui.Buttons.Coins.Amount.Text:gsub(',', '')
                    local b = game.Players.LocalPlayer.PlayerGui.Gui.Rebirth.Needed.Coins.Amount.Text:gsub(',', '')
                    
                    if tonumber(a) > tonumber(b) then
                        pcall(function()
                            game.ReplicatedStorage.Events.Rebirth:FireServer()
                            task.wait(0.1)
                            game.Players.LocalPlayer.PlayerGui.Gui.Popups.GiveReward.Visible = false
                        end)
                        WindUI:Notify({Title = "提示", Content = "已重生", Duration = 2})
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- 箱子部分
local CratesDropdown = {}
for i, v in pairs(game:GetService("ReplicatedStorage").Crates:GetChildren()) do
    table.insert(CratesDropdown, v.Name)
end

local CratesName = CratesDropdown[1] or ""

MainFunctions:Dropdown({
    Title = "选择箱子",
    Values = CratesDropdown,
    Callback = function(Value)
        CratesName = Value
    end
})

-- 自动购买箱子
local autoBuyCrate = false
MainFunctions:Toggle({
    Title = "自动购买箱子",
    Value = false,
    Callback = function(state)
        autoBuyCrate = state
        if state then
            task.spawn(function()
                while autoBuyCrate do
                    pcall(function()
                        game:GetService("ReplicatedStorage").Events.BuyCrate:FireServer(
                            CratesName, 
                            Players.LocalPlayer.Name,
                            1
                        )
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- 自动购买收集工具
local autoBuyTools = false
MainFunctions:Toggle({
    Title = "自动购买收集工具",
    Value = false,
    Callback = function(state)
        autoBuyTools = state
        if state then
            task.spawn(function()
                while autoBuyTools do
                    local coins = game:GetService("Players").LocalPlayer.leaderstats.Coins.Value
                    
                    local purchaseList = {
                        {price = 0, item = "Bucket"},
                        {price = 100, item = "Spade"},
                        {price = 250, item = "Toy Shovel"},
                        {price = 600, item = "Small Shovel"},
                        {price = 2100, item = "Medium Shovel"},
                        {price = 8800, item = "Large Shovel"},
                        {price = 24000, item = "Big Scooper"},
                        {price = 65000, item = "Vacuum"},
                        {price = 250000, item = "Giant Shovel"},
                        {price = 500000, item = "Metal Detector"},
                        {price = 3000000, item = "Jack Hammer"},
                        {price = 10000000, item = "Golden Spoon"}
                    }
                    
                    for _, itemData in ipairs(purchaseList) do
                        if coins >= itemData.price then
                            pcall(function()
                                game:GetService("ReplicatedStorage").Events.Checkout:FireServer(itemData.item)
                                task.wait(0.1)
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- 自动购买填充背包
local autoBuyStorage = false
MainFunctions:Toggle({
    Title = "自动购买背包扩展",
    Value = false,
    Callback = function(state)
        autoBuyStorage = state
        if state then
            task.spawn(function()
                while autoBuyStorage do
                    local coins = game:GetService("Players").LocalPlayer.leaderstats.Coins.Value
                    
                    local storageList = {
                        {price = 0, item = "Starterpack"},
                        {price = 150, item = "Small Bag"},
                        {price = 375, item = "Medium Bag"},
                        {price = 900, item = "Large Bag"},
                        {price = 3150, item = "XL Bag"},
                        {price = 13200, item = "XXL Bag"},
                        {price = 36000, item = "SuperStorage™"},
                        {price = 75000, item = "SuperStorage™ 2"},
                        {price = 150000, item = "Sand Safe"},
                        {price = 350000, item = "Sand Vault"},
                        {price = 700000, item = "SuperStorage™ 3"},
                        {price = 1500000, item = "Small Canister"},
                        {price = 4000000, item = "Medium Canister"},
                        {price = 8000000, item = "Large Canister"},
                        {price = 9e9, item = "Infinite"}
                    }
                    
                    for _, storageData in ipairs(storageList) do
                        if coins >= storageData.price then
                            pcall(function()
                                game:GetService("ReplicatedStorage").Events.Checkout:FireServer(storageData.item)
                                task.wait(0.1)
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- 人物功能标签页
local CharacterSettings = Window:Tab({Title = "人物功能", Icon = "user"})

-- 速度功能
local speedToggle = false
local speedConnection = nil
local Speed = 1

CharacterSettings:Toggle({
    Title = "速度修改 (开/关)",
    Value = false,
    Callback = function(state)
        speedToggle = state
        if state then
            speedConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if game:GetService("Players").LocalPlayer.Character and 
                   game:GetService("Players").LocalPlayer.Character.Humanoid and 
                   game:GetService("Players").LocalPlayer.Character.Humanoid.Parent then
                    if game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
                        game:GetService("Players").LocalPlayer.Character:TranslateBy(
                            game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection * Speed / 10
                        )
                    end
                end
            end)
        elseif not state and speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
    end
})

CharacterSettings:Slider({
    Title = "速度设置",
    Desc = "调整移动速度",
    Value = {Min = 1, Max = 100, Default = 1},
    Callback = function(value)
        Speed = value
    end
})

-- 视野功能
local fovToggle = false
local fovConnection = nil
local FOV = 120

CharacterSettings:Toggle({
    Title = "视野修改 (开/关)",
    Value = false,
    Callback = function(state)
        fovToggle = state
        if state then
            fovConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if workspace.CurrentCamera then
                    workspace.CurrentCamera.FieldOfView = FOV
                end
            end)
        elseif not state and fovConnection then
            fovConnection:Disconnect()
            fovConnection = nil
        end
    end
})

CharacterSettings:Slider({
    Title = "视野范围设置",
    Desc = "调整视野大小",
    Value = {Min = 70, Max = 120, Default = 120},
    Callback = function(value)
        FOV = value
        if fovConnection and workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = FOV
        end
    end
})

-- 通知功能
CharacterSettings:Button({
    Title = "测试通知",
    Callback = function()
        WindUI:Notify({
            Title = "测试通知",
            Content = "这是一个测试通知，功能正常！",
            Duration = 3
        })
    end
})



