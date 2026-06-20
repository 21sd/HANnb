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
    Title = "忍者传奇",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "忍者传奇",
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

local RainHubTabs = {
    RainHubMain = Window:Tab({ Title = "自动", Icon = "pointer-off" }),
    RainHubPet = Window:Tab({ Title = "宠物复制", Icon = "layers-2" }),
    RainHubGamepass = Window:Tab({ Title = "通行证", Icon = "crown" }),
    RainHubInfo = Window:Tab({ Title = "信息", Icon = "info" }),
    RainHubBoss = Window:Tab({ Title = "刷Boss", Icon = "activity" }),
    RainHubCoins = Window:Tab({ Title = "金币修改", Icon = "circle-pound-sterling" }),
    RainHubCharacter = Window:Tab({ Title = "玩家设置", Icon = "user" }),
    RainHubLottery = Window:Tab({ Title = "抽奖", Icon = "dices" })
}

Window:SelectTab(1)

local function RainHubTeleport(RainHubPosition)
    local RainHubPlayer = game.Players.LocalPlayer
    if RainHubPlayer.Character and RainHubPlayer.Character:FindFirstChild("HumanoidRootPart") then
        RainHubPlayer.Character.HumanoidRootPart.CFrame = RainHubPosition
    end
end

-- 自动功能
RainHubTabs.RainHubMain:Toggle({
    Title = "自动攻击",
    Default = false,
    Callback = function(RainHubState)
        getgenv().RainHubAuto1 = RainHubState
        if RainHubState then
            spawn(function()
                while RainHubAuto1 == true do
                    local RainHubArgs = {[1] = "swingKatana"}
                    game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(RainHubArgs))    
                    wait(0.1)
                end
            end)
        end
    end
})

RainHubTabs.RainHubMain:Toggle({
    Title = "自动出售",
    Default = false,
    Callback = function(RainHubState)
        getgenv().RainHubAuto2 = RainHubState
        if RainHubState then
            spawn(function()
                while RainHubAuto2 == true do
                    local RainHubPlayer = game.Players.LocalPlayer
                    if RainHubPlayer.Character and RainHubPlayer.Character:FindFirstChild("Head") then
                        local RainHubHead = RainHubPlayer.Character.Head
                        local RainHubSell = game:GetService("Workspace"):FindFirstChild("sellAreaCircles")
                        if RainHubSell then
                            local RainHubCircle = RainHubSell:FindFirstChild("sellAreaCircle16")
                            if RainHubCircle and RainHubCircle:FindFirstChild("circleInner") then
                                local RainHubInner = RainHubCircle.circleInner
                                for _, RainHubValue in pairs(RainHubInner:GetDescendants()) do
                                    if RainHubValue.Name == "TouchInterest" and RainHubValue.Parent then
                                        firetouchinterest(RainHubHead, RainHubValue.Parent, 0)
                                        wait(0.1)
                                        firetouchinterest(RainHubHead, RainHubValue.Parent, 1)
                                        break
                                    end
                                end
                            end
                        end
                    end
                    wait(0.5)
                end
            end)
        end
    end
})

RainHubTabs.RainHubMain:Toggle({
    Title = "自动升级职位",
    Default = false,
    Callback = function(RainHubState)
        getgenv().RainHubAuto3 = RainHubState
        if RainHubState then
            spawn(function()
                while RainHubAuto3 == true do
                    local RainHubRanks = {
                        "Grasshopper", "Apprentice", "Samurai", "Assassin", "Shadow",
                        "Ninja", "Master Ninja", "Sensei", "Master Sensei", "Ninja Legend",
                        "Lava Legend", "Inferno Legend", "Blazing Legend", "Shadow Legend",
                        "Genesis Legend", "Cosmic Legend", "Cyber Legend", "Spatial Legend",
                        "Chrono Legend", "Apex Legend", "Nova Legend", "Quantum Legend",
                        "Celestial Legend", "Infinity Legend", "Eternal Legend", "Primordial Legend",
                        "Ultra Genesis Shadow"
                    }
                    
                    for RainHubI = 1, #RainHubRanks, 5 do
                        for RainHubJ = RainHubI, math.min(RainHubI+4, #RainHubRanks) do
                            local RainHubArgs = {[1] = "buyRank", [2] = RainHubRanks[RainHubJ]}
                            game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(RainHubArgs))
                        end
                        wait(0.1)
                    end
                    wait(0.5)
                end
            end)
        end
    end
})

RainHubTabs.RainHubMain:Toggle({
    Title = "自动购买腰带",
    Default = false,
    Callback = function(RainHubState)
        getgenv().RainHubAuto4 = RainHubState
        if RainHubState then
            spawn(function()
                while RainHubAuto4 == true do
                    local RainHubArgs = {[1] = "buyAllBelts", [2] = "Blazing Vortex Island"}
                    game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(RainHubArgs))        
                    wait(0.5)
                end
            end)
        end
    end
})

RainHubTabs.RainHubMain:Toggle({
    Title = "自动购买武器",
    Default = false,
    Callback = function(RainHubState)
        getgenv().RainHubAuto5 = RainHubState
        if RainHubState then
            spawn(function()
                while RainHubAuto5 == true do
                    local RainHubArgs = {[1] = "buyAllSwords", [2] = "Blazing Vortex Island"}
                    game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(RainHubArgs))        
                    wait(0.5)
                end
            end)
        end
    end
})

local RainHubRunning6 = false
RainHubTabs.RainHubMain:Toggle({
    Title = "自动收集训练环",
    Default = false,
    Callback = function(RainHubState)
        if RainHubState and not RainHubRunning6 then
            RainHubRunning6 = true
            spawn(function()
                while RainHubRunning6 do
                    local RainHubPlayer = game.Players.LocalPlayer
                    if RainHubPlayer.Character and RainHubPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local RainHubCFrame = RainHubPlayer.Character.HumanoidRootPart.CFrame
                        local RainHubHoops = workspace:FindFirstChild("Hoops")
                        if RainHubHoops then
                            for RainHubI, RainHubChild in ipairs(RainHubHoops:GetChildren()) do
                                if RainHubChild.Name == "Hoop" then
                                    RainHubChild.CFrame = RainHubCFrame
                                end
                            end
                        end
                    end
                    wait(0.1)
                end
            end)
        else
            RainHubRunning6 = false
        end
    end
})

RainHubTabs.RainHubMain:Toggle({
    Title = "自动收集气",
    Default = false,
    Callback = function(RainHubState)
        getgenv().RainHubAuto7 = RainHubState
        if RainHubState then
            spawn(function()
                while RainHubAuto7 == true do
                    local RainHubCoins = game:GetService("Workspace"):FindFirstChild("spawnedCoins")
                    if RainHubCoins then
                        local RainHubValley = RainHubCoins:FindFirstChild("Valley")
                        if RainHubValley then
                            local RainHubCrates = {"Pink Chi Crate", "Blue Chi Crate", "Chi Crate"}
                            for _, RainHubCrateName in ipairs(RainHubCrates) do
                                local RainHubCrate = RainHubValley:FindFirstChild(RainHubCrateName)
                                if RainHubCrate and RainHubCrate:FindFirstChild("CFrame") then
                                    RainHubTeleport(RainHubCrate.CFrame)
                                    wait(0.1)
                                end
                            end
                        end
                    end
                    wait(0.5)
                end
            end)
        end
    end
})

RainHubTabs.RainHubMain:Button({
    Title = "解锁所有元素",
    Callback = function()
        local RainHubElements = game:GetService("ReplicatedStorage"):FindFirstChild("Elements")
        if RainHubElements then
            for RainHubI, RainHubV in pairs(RainHubElements:GetChildren()) do
                local RainHubElement = RainHubV.Name
                game.ReplicatedStorage.rEvents.elementMasteryEvent:FireServer(RainHubElement)
                wait(0.1)
            end
        end
    end
})

RainHubTabs.RainHubMain:Toggle({
    Title = "自动收集元素",
    Default = false,
    Callback = function(RainHubState)
        getgenv().RainHubAuto8 = RainHubState
        if RainHubState then
            spawn(function()
                while RainHubAuto8 == true do
                    local RainHubElements = {
                        "Inferno", "Frost", "Lightning", "Electral Chaos",
                        "Shadow Charge", "Masterful Wrath", "Shadowfire",
                        "Eternity Storm", "Blazing Entity"
                    }
                    
                    for _, RainHubElement in ipairs(RainHubElements) do
                        local RainHubArgs = {[1] = RainHubElement}
                        game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("elementMasteryEvent"):FireServer(unpack(RainHubArgs))
                        wait(0.1)
                    end
                    wait(0.5)
                end
            end)
        end
    end
})

-- 宠物复制
local RainHubPetName = ""
local RainHubCopyCount = 1

RainHubTabs.RainHubPet:Input({
    Title = "宠物名称",
    Desc = "输入要复制的宠物名",
    Value = "",
    Placeholder = "请输入宠物名称",
    Color = Color3.fromRGB(0, 170, 255),
    Callback = function(RainHubInput)
        RainHubPetName = RainHubInput
    end
})

RainHubTabs.RainHubPet:Input({
    Title = "复制数量",
    Desc = "输入复制次数",
    Value = "1",
    Placeholder = "请输入数字...",
    Color = Color3.fromRGB(0, 170, 255),
    Callback = function(RainHubInput)
        RainHubCopyCount = tonumber(RainHubInput) or 1
    end
})

RainHubTabs.RainHubPet:Button({
    Title = "开始复制宠物",
    Desc = "点击开始复制",
    Callback = function()
        if RainHubPetName and RainHubPetName ~= "" then
            local RainHubPlayer = game.Players.LocalPlayer
            local RainHubPets = RainHubPlayer:FindFirstChild("petsFolder")
            if RainHubPets then
                local RainHubRare = RainHubPets:FindFirstChild("Rare")
                if RainHubRare then
                    local RainHubTarget = RainHubRare:FindFirstChild(RainHubPetName)
                    if RainHubTarget then
                        for RainHubI = 1, RainHubCopyCount do
                            local RainHubClone = RainHubTarget:Clone()
                            RainHubClone.Parent = RainHubRare
                            RainHubClone.Name = RainHubPetName .. " (Copy " .. RainHubI .. ")"
                            task.wait(0.1)
                        end
                    end
                end
            end
        end
    end
})

-- 通行证解锁
local RainHubGamepasses = {
    {Title = "解锁宠物栏位+2", Id = "+2 Pet Slots"},
    {Title = "解锁宠物栏位+3", Id = "+3 Pet Slots"},
    {Title = "解锁宠物栏位+4", Id = "+4 Pet Slots"},
    {Title = "解锁容量+100", Id = "+100 Capacity"},
    {Title = "解锁容量+200", Id = "+200 Capacity"},
    {Title = "解锁容量+20", Id = "+20 Capacity"},
    {Title = "解锁容量+60", Id = "+60 Capacity"},
    {Title = "解锁无限弹药", Id = "Infinite Ammo"},
    {Title = "解锁无限忍术", Id = "Infinite Ninjitsu"},
    {Title = "解锁永久岛屿", Id = "Permanent Islands Unlock"},
    {Title = "解锁双倍金币", Id = "x2 Coins"},
    {Title = "解锁双倍伤害", Id = "x2 Damage"},
    {Title = "解锁双倍生命值", Id = "x2 Health"},
    {Title = "解锁双倍忍术", Id = "x2 Ninjitsu"},
    {Title = "解锁双倍速度", Id = "x2 Speed"},
    {Title = "解锁快速剑击", Id = "Faster Sword"},
    {Title = "解锁宠物克隆+3", Id = "x3 Pet Clones"}
}

for _, RainHubGamepass in ipairs(RainHubGamepasses) do
    RainHubTabs.RainHubGamepass:Button({
        Title = RainHubGamepass.Title,
        Callback = function()
            local RainHubGamepassIds = game:GetService("ReplicatedStorage"):FindFirstChild("gamepassIds")
            if RainHubGamepassIds then
                local RainHubItem = RainHubGamepassIds:FindFirstChild(RainHubGamepass.Id)
                if RainHubItem then
                    local RainHubOwned = game.Players.LocalPlayer:FindFirstChild("ownedGamepasses")
                    if RainHubOwned then
                        RainHubItem.Parent = RainHubOwned
                    end
                end
            end
        end
    })
end

-- 信息展示
local RainHubStatElements = {}
local RainHubStatNames = {
    {key = "Ninjitsu", title = "忍术等级"},
    {key = "Kills", title = "击杀数量"},
    {key = "Rank", title = "当前职位"},
    {key = "Streak", title = "连击次数"},
    {key = "Chi", title = "气能量"},
    {key = "Coins", title = "金币数量"},
    {key = "Duels", title = "决斗次数"},
    {key = "Gems", title = "宝石数量"},
    {key = "Souls", title = "灵魂数量"},
    {key = "Karma", title = "业报值"}
}

for _, RainHubStat in ipairs(RainHubStatNames) do
    local RainHubElement = RainHubTabs.RainHubInfo:Paragraph({
        Title = RainHubStat.title .. ": 加载中...",
    })
    table.insert(RainHubStatElements, {element = RainHubElement, key = RainHubStat.key, title = RainHubStat.title})
end

task.spawn(function()
    while task.wait(1) do
        local RainHubPlayer = game.Players.LocalPlayer
        local RainHubStats = {}
        
        if RainHubPlayer:FindFirstChild("leaderstats") then
            local RainHubLeader = RainHubPlayer.leaderstats
            RainHubStats.Ninjitsu = RainHubLeader:FindFirstChild("Ninjitsu") and RainHubLeader.Ninjitsu.Value or 0
            RainHubStats.Kills = RainHubLeader:FindFirstChild("Kills") and RainHubLeader.Kills.Value or 0
            RainHubStats.Rank = RainHubLeader:FindFirstChild("Rank") and RainHubLeader.Rank.Value or 0
            RainHubStats.Streak = RainHubLeader:FindFirstChild("Streak") and RainHubLeader.Streak.Value or 0
            RainHubStats.Duels = RainHubLeader:FindFirstChild("Duels") and RainHubLeader.Duels.Value or 0
        end
        
        RainHubStats.Chi = RainHubPlayer:FindFirstChild("Chi") and RainHubPlayer.Chi.Value or 0
        RainHubStats.Coins = RainHubPlayer:FindFirstChild("Coins") and RainHubPlayer.Coins.Value or 0
        RainHubStats.Gems = RainHubPlayer:FindFirstChild("Gems") and RainHubPlayer.Gems.Value or 0
        RainHubStats.Souls = RainHubPlayer:FindFirstChild("Souls") and RainHubPlayer.Souls.Value or 0
        RainHubStats.Karma = RainHubPlayer:FindFirstChild("Karma") and RainHubPlayer.Karma.Value or 0
        
        for _, RainHubItem in ipairs(RainHubStatElements) do
            RainHubItem.element:SetTitle(RainHubItem.title .. ": " .. (RainHubStats[RainHubItem.key] or 0))
        end
    end
end)

-- 刷Boss
RainHubTabs.RainHubBoss:Toggle({
    Title = "自动对战机器人Boss",
    Default = false,
    Callback = function(RainHubState)
        getgenv().RainHubAuto9 = RainHubState
        if RainHubState then
            spawn(function()
                while RainHubAuto9 == true do
                    local RainHubBoss = game:GetService("Workspace"):FindFirstChild("bossFolder")
                    if RainHubBoss then
                        local RainHubRobot = RainHubBoss:FindFirstChild("RobotBoss")
                        if RainHubRobot and RainHubRobot:FindFirstChild("UpperTorso") then
                            RainHubTeleport(RainHubRobot.UpperTorso.CFrame)
                        end
                    end
                    local RainHubArgs = {[1] = "swingKatana"}
                    game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(RainHubArgs))
                    wait(0.1)
                end
            end)
        end
    end
})

RainHubTabs.RainHubBoss:Toggle({
    Title = "自动对战永恒Boss",
    Default = false,
    Callback = function(RainHubState)
        getgenv().RainHubAuto10 = RainHubState
        if RainHubState then
            spawn(function()
                while RainHubAuto10 == true do
                    local RainHubBoss = game:GetService("Workspace"):FindFirstChild("bossFolder")
                    if RainHubBoss then
                        local RainHubEternal = RainHubBoss:FindFirstChild("EternalBoss")
                        if RainHubEternal and RainHubEternal:FindFirstChild("UpperTorso") then
                            RainHubTeleport(RainHubEternal.UpperTorso.CFrame)
                        end
                    end
                    local RainHubArgs = {[1] = "swingKatana"}
                    game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(RainHubArgs))
                    wait(0.1)
                end
            end)
        end
    end
})

RainHubTabs.RainHubBoss:Toggle({
    Title = "自动对战远古岩浆Boss",
    Default = false,
    Callback = function(RainHubState)
        getgenv().RainHubAuto11 = RainHubState
        if RainHubState then
            spawn(function()
                while RainHubAuto11 == true do
                    local RainHubBoss = game:GetService("Workspace"):FindFirstChild("bossFolder")
                    if RainHubBoss then
                        local RainHubMagma = RainHubBoss:FindFirstChild("AncientMagmaBoss")
                        if RainHubMagma and RainHubMagma:FindFirstChild("UpperTorso") then
                            RainHubTeleport(RainHubMagma.UpperTorso.CFrame)
                        end
                    end
                    local RainHubArgs = {[1] = "swingKatana"}
                    game.Players.LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(RainHubArgs))
                    wait(0.1)
                end
            end)
        end
    end
})

-- 金币修改
local RainHubLooping = false
local RainHubLastInput = 0

RainHubTabs.RainHubCoins:Button({
    Title = "初始化步骤1",
    Desc = "准备金币修改",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("zenMasterEvent"):FireServer("convertGems", -9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999)
    end
})

RainHubTabs.RainHubCoins:Button({
    Title = "初始化步骤2",
    Desc = "激活修改功能",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("elementMasteryEvent"):FireServer("Shadow Charge")
    end
})

RainHubTabs.RainHubCoins:Input({
    Title = "输入金币数量",
    Desc = "输入要添加的金币数量",
    Value = "",
    Placeholder = "请输入数字",
    Callback = function(RainHubValue)
        local RainHubNum = tonumber(RainHubValue)
        if RainHubNum and RainHubNum > 0 then
            RainHubLastInput = RainHubNum
            game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("zenMasterEvent"):FireServer("convertGems", RainHubNum)
        end
    end
})

RainHubTabs.RainHubCoins:Toggle({
    Title = "循环添加金币",
    Default = false,
    Callback = function(RainHubState)
        RainHubLooping = RainHubState
        if RainHubState then
            spawn(function()
                while RainHubLooping and RainHubLastInput > 0 do
                    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("zenMasterEvent"):FireServer("convertGems", RainHubLastInput)
                    wait(0.5)
                end
            end)
        end
    end
})

RainHubTabs.RainHubCoins:Button({
    Title = "恢复金币数量",
    Desc = "将金币恢复正常",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("zenMasterEvent"):FireServer("convertGems", 1)
    end
})

-- 玩家设置
RainHubTabs.RainHubCharacter:Input({
    Title = "设置连跳次数",
    Desc = "设置最大连跳次数",
    Placeholder = "输入连跳次数",
    Callback = function(RainHubValue)
        local RainHubJump = game.Players.LocalPlayer:FindFirstChild("multiJumpCount")
        if RainHubJump then
            local RainHubNum = tonumber(RainHubValue)
            if RainHubNum then
                RainHubJump.Value = RainHubNum
            end
        end
    end
})

RainHubTabs.RainHubCharacter:Button({
    Title = "解锁所有岛屿",
    Desc = "快速解锁全部岛屿",
    Callback = function()
        local RainHubPositions = {
            CFrame.new(26, 766, -114),
            CFrame.new(247, 2013, 347),
            CFrame.new(162, 4047, 13),
            CFrame.new(200, 5656, 13),
            CFrame.new(200, 9284, 13),
            CFrame.new(200, 13679, 13),
            CFrame.new(200, 17686, 13),
            CFrame.new(200, 24069, 13),
            CFrame.new(197, 28256, 7),
            CFrame.new(197, 33206, 7),
            CFrame.new(197, 39317, 7),
            CFrame.new(197, 46010, 7),
            CFrame.new(197, 52607, 7),
            CFrame.new(197, 59594, 7),
            CFrame.new(197, 66668, 7),
            CFrame.new(197, 70270, 7),
            CFrame.new(197, 74442, 7),
            CFrame.new(197, 79746, 7),
            CFrame.new(197, 83198, 7),
            CFrame.new(197, 91245, 7)
        }
        
        local RainHubPlayer = game.Players.LocalPlayer
        if RainHubPlayer.Character and RainHubPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, RainHubPos in ipairs(RainHubPositions) do
                RainHubPlayer.Character.HumanoidRootPart.CFrame = RainHubPos
                wait(0.1)
            end
        end
    end
})

-- 抽奖
local RainHubEggs = {}
local RainHubCrystals = game.Workspace:FindFirstChild("mapCrystalsFolder")
if RainHubCrystals then
    for RainHubI, RainHubV in pairs(RainHubCrystals:GetChildren()) do
        table.insert(RainHubEggs, RainHubV.Name)
    end
else
    table.insert(RainHubEggs, "普通抽奖机")
    table.insert(RainHubEggs, "高级抽奖机")
    table.insert(RainHubEggs, "史诗抽奖机")
end

local RainHubSelectedEgg = ""
local RainHubAutoEgg = false

RainHubTabs.RainHubLottery:Dropdown({
    Title = "选择抽奖机", 
    Desc = "选择要使用的抽奖机",
    Values = RainHubEggs,
    Value = "",
    Callback = function(RainHubSelected)
        RainHubSelectedEgg = RainHubSelected
    end
})

RainHubTabs.RainHubLottery:Toggle({
    Title = "自动抽奖", 
    Desc = "自动购买抽奖",
    Default = false,
    Callback = function(RainHubState)
        RainHubAutoEgg = RainHubState
        if RainHubState then
            spawn(function()
                while RainHubAutoEgg do
                    if RainHubSelectedEgg and RainHubSelectedEgg ~= "" then
                        local RainHubA1 = "openCrystal"
                        local RainHubA2 = RainHubSelectedEgg
                        local RainHubEvent = game:GetService("ReplicatedStorage"):FindFirstChild("rEvents")
                        if RainHubEvent then
                            local RainHubRemote = RainHubEvent:FindFirstChild("openCrystalRemote")
                            if RainHubRemote then
                                RainHubRemote:InvokeServer(RainHubA1, RainHubA2)
                            end
                        end
                    end
                    wait(0.5)
                end
            end)
        end
    end
})

-- 窗口关闭提示（与之前保持一致）
Window:OnClose(function()
    if game:GetService("UserInputService").KeyboardEnabled then
        WindUI:Notify({
            Title = "忍者传奇",
            Content = "按下N键再次打开",
            Duration = 3
        })
    end
end)