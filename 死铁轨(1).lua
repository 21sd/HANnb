local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()

if not WindUI then
    warn("WindUI 库加载失败，请检查网络或脚本地址")
    return
end

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
    Title = "死铁轨",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "死铁轨",
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

local MainTab = Window:Tab({
    Title = "死铁轨",
    Icon = "sword"
})

MainTab:Button({
    Title = "全图金条瞬移",
    Desc = "将附近金条传送到玩家头上",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local char = LocalPlayer.Character
        if not char then print("角色不存在") return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then print("找不到 HumanoidRootPart") return end

        local moved = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Prop_GoldBar" then
                if obj:IsA("Model") then
                    local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local pos = root.Position + Vector3.new(math.random(-4,4), 6, math.random(-4,4))
                        part.AssemblyLinearVelocity = Vector3.zero
                        part.AssemblyAngularVelocity = Vector3.zero
                        part.CFrame = CFrame.new(pos)
                        moved += 1
                    end
                elseif obj:IsA("BasePart") then
                    local pos = root.Position + Vector3.new(math.random(-4,4), 6, math.random(-4,4))
                    obj.AssemblyLinearVelocity = Vector3.zero
                    obj.AssemblyAngularVelocity = Vector3.zero
                    obj.CFrame = CFrame.new(pos)
                    moved += 1
                end
            end
        end
        print("全地图已传送金条数量:", moved)
    end
})

-- ============================================
-- 顶部先声明（放在所有UI代码之前）
-- ============================================
local ESP_Enabled = false
local ESP_Connection = nil
local CACHE = {}

-- ============================================
-- Toggle 开关
-- ============================================
MainTab:Toggle({
    Title = "透视物品加生物",
    Desc = "",
    Default = false,
    Callback = function(Value)
        ESP_Enabled = Value

        if not Value then
            -- 关闭ESP
            if ESP_Connection then
                ESP_Connection:Disconnect()
                ESP_Connection = nil
            end
            for obj, data in pairs(CACHE) do
                if data.Highlight then data.Highlight:Destroy() end
                if data.Billboard then data.Billboard:Destroy() end
            end
            CACHE = {}
            print("❌ ESP已关闭")
            return
        end

        -- 开启ESP
        print("✅ 死铁轨中文ESP启动")
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer

        CACHE = {}

        local CN = {
            -- 金子
            ["gold_bar"] = "金条",
            ["gold_nugget"] = "金块",
            ["gold_watch"] = "金表",
            ["gold_statue"] = "黄金雕像",
            -- 银子
            ["silver_bar"] = "银条",
            ["silver_cup"] = "银杯",
            -- 医疗
            ["bandage"] = "绷带",
            ["snake_oil"] = "蛇油",
            ["medkit"] = "医疗包",
            -- 弹药
            ["ammo_light"] = "轻型子弹",
            ["ammo_medium"] = "中型子弹",
            ["ammo_shells"] = "霰弹",
            ["ammo_rifle"] = "步枪子弹",
            ["ammo_revolver"] = "左轮子弹",
            ["ammo_heavy"] = "重型子弹",
            ["ammo_ballista_bolts"] = "防弹弹药",
            -- 武器
            ["revolver"] = "左轮",
            ["shotgun"] = "霰弹枪",
            ["rifle"] = "步枪",
            ["pistol"] = "手枪",
            ["maxim_gun"] = "加特林",
            ["crossbow"] = "十字弓",
            -- 资源
            ["coal"] = "煤炭",
            ["wood"] = "木材",
            ["fuel"] = "燃料",
            ["water"] = "水",
            ["food"] = "食物",
            -- 工具
            ["lantern"] = "提灯",
            ["torch"] = "火把",
            ["camera"] = "相机",
            ["rope"] = "绳子",
            ["book"] = "书",
            ["lightning_rod"] = "避雷针",
            ["barbed_wire"] = "铁丝网",
            ["molotov"] = "燃烧瓶",
            ["pickaxe"] = "镐",
            ["mining_helmet"] = "采矿头盔",
            ["banjo"] = "五弦琴",
            -- 车辆
            ["wheel"] = "车轮",
            -- 其他
            ["barrel"] = "木桶",
            ["chair"] = "椅子",
            ["painting"] = "油画",
            ["stone_statue"] = "石像",
            ["crate"] = "箱子",
            ["newspaper_cure"] = "报纸",
            -- 敌人
            ["zombie"] = "僵尸",
            ["bandit"] = "土匪"
        }

        local function getRealName(obj)
            local name = string.lower(obj.Name)
            if name == "root" or name == "handle" or name == "part" or name == "bottle" then
                if obj.Parent then
                    name = string.lower(obj.Parent.Name)
                end
            end
            return name
        end

        local function getChineseName(obj)
            local realName = getRealName(obj)
            for key, cn in pairs(CN) do
                if string.find(realName, key) then
                    return cn
                end
            end
            print("未知物品:", realName)
            return realName
        end

        local function getColor(obj)
            local realName = getRealName(obj)
            if string.find(realName, "gold") then
                return Color3.fromRGB(255, 215, 0)
            end
            if string.find(realName, "silver") then
                return Color3.fromRGB(220, 220, 220)
            end
            if string.find(realName, "bandage") or string.find(realName, "med") or string.find(realName, "snake") then
                return Color3.fromRGB(0, 255, 0)
            end
            if string.find(realName, "ammo") then
                return Color3.fromRGB(255, 140, 0)
            end
            -- 武器红色：原有 + 新增加特林
            if string.find(realName, "rifle")
                or string.find(realName, "shotgun")
                or string.find(realName, "revolver")
                or string.find(realName, "maxim") then      -- 新增加特林
                return Color3.fromRGB(255, 0, 0)
            end
            return Color3.fromRGB(255, 255, 255)
        end

        local function findPart(obj)
            if obj:IsA("BasePart") then
                return obj
            end
            for _, v in pairs(obj:GetDescendants()) do
                if v:IsA("BasePart") then
                    return v
                end
            end
            return nil
        end

        local function createESP(obj)
            if CACHE[obj] then return end
            local part = findPart(obj)
            if not part then return end

            local color = getColor(obj)
            local cnName = getChineseName(obj)

            local hl = Instance.new("Highlight")
            hl.Name = "CN_ESP"
            hl.FillColor = color
            hl.OutlineColor = Color3.new(1, 1, 1)
            hl.FillTransparency = 0.5
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = obj

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "CN_BILLBOARD"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.AlwaysOnTop = true
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.Parent = part

            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.TextColor3 = color
            text.TextStrokeTransparency = 0
            text.Font = Enum.Font.SourceSansBold
            text.TextSize = 16
            text.Parent = billboard

            CACHE[obj] = {
                Part = part,
                Highlight = hl,
                Billboard = billboard,
                Text = text,
                Name = cnName
            }
            print("已识别:", cnName)
        end

        local function removeESP(obj)
            local data = CACHE[obj]
            if not data then return end
            if data.Highlight then data.Highlight:Destroy() end
            if data.Billboard then data.Billboard:Destroy() end
            CACHE[obj] = nil
        end

        local function updateESP()
            if not ESP_Enabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local folder = workspace:FindFirstChild("ObjectModels")
            if not folder then return end

            for _, obj in pairs(folder:GetChildren()) do
                createESP(obj)
            end

            for obj, data in pairs(CACHE) do
                if not obj or not obj.Parent or not data.Part or not data.Part.Parent then
                    removeESP(obj)
                else
                    local distance = math.floor((root.Position - data.Part.Position).Magnitude)
                    data.Text.Text = data.Name .. "\n" .. distance .. "m"
                end
            end
        end

        ESP_Connection = RunService.RenderStepped:Connect(function()
            pcall(updateESP)
        end)

        print("🎯 死铁轨全中文ESP已开启")
    end
})

local ESPTab = Window:Tab({
    Title = "其他透视",
    Icon = "eye"
})

local rainbowColors = {
    Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 127, 0), Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(139, 0, 255), Color3.fromRGB(255, 0, 255)
}

local ESPObjects = {
    itemESP = {}, oreESP = {}, nightEnemiesESP = {}, unicornESP = {},
    buildESP = {}, buildZombieESP = {}, bankESP = {}, bondESP = {}
}

local function createESP(parent, text, espType)
    if not parent or parent.Parent == nil then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Parent = parent
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.Adornee = parent

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RainbowBillboard"
    billboard.Parent = parent
    billboard.Adornee = parent
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "ESPLabel"
    nameLabel.Parent = billboard
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = text
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextColor3 = Color3.new(1, 1, 1)

    local colorIndex = 1
    local rainbowConnection
    rainbowConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if not parent or parent.Parent == nil then
            rainbowConnection:Disconnect()
            return
        end
        highlight.FillColor = rainbowColors[colorIndex]
        highlight.OutlineColor = rainbowColors[colorIndex]
        nameLabel.TextColor3 = rainbowColors[colorIndex]
        colorIndex = colorIndex + 1
        if colorIndex > #rainbowColors then colorIndex = 1 end
    end)

    table.insert(ESPObjects[espType], {
        Parent = parent,
        Highlight = highlight,
        Billboard = billboard,
        Connection = rainbowConnection
    })
end

local function clearESP(espType)
    for _, espData in ipairs(ESPObjects[espType]) do
        if espData.Highlight and espData.Highlight.Parent then espData.Highlight:Destroy() end
        if espData.Billboard and espData.Billboard.Parent then espData.Billboard:Destroy() end
        if espData.Connection then espData.Connection:Disconnect() end
    end
    ESPObjects[espType] = {}
end

ESPTab:Toggle({
    Title = "夜晚怪物透视",
    Default = false,
    Callback = function(Value)
        if Value then
            if workspace:FindFirstChild("NightEnemies") then
                for _, v in ipairs(workspace.NightEnemies:GetChildren()) do
                    if v:IsA("Model") and not v:FindFirstChild("ESPHighlight") then
                        createESP(v, v.Name, "nightEnemiesESP")
                    end
                end
                workspace.NightEnemies.ChildAdded:Connect(function(v)
                    if v:IsA("Model") and not v:FindFirstChild("ESPHighlight") and Value then
                        createESP(v, v.Name, "nightEnemiesESP")
                    end
                end)
            end
        else
            clearESP("nightEnemiesESP")
        end
    end
})

ESPTab:Toggle({
    Title = "建筑物透视",
    Default = false,
    Callback = function(Value)
        if Value then
            if workspace:FindFirstChild("RandomBuildings") then
                for _, v in ipairs(workspace.RandomBuildings:GetChildren()) do
                    if v:IsA("Model") and not v:FindFirstChild("ESPHighlight") then
                        createESP(v, v.Name, "buildESP")
                    end
                end
                workspace.RandomBuildings.ChildAdded:Connect(function(v)
                    if v:IsA("Model") and not v:FindFirstChild("ESPHighlight") and Value then
                        createESP(v, v.Name, "buildESP")
                    end
                end)
            end
        else
            clearESP("buildESP")
        end
    end
})

ESPTab:Toggle({
    Title = "房中怪物透视",
    Default = false,
    Callback = function(Value)
        if Value then
            if workspace:FindFirstChild("RandomBuildings") then
                for _, building in ipairs(workspace.RandomBuildings:GetChildren()) do
                    if building:FindFirstChild("StandaloneZombiePart") and building.StandaloneZombiePart:FindFirstChild("Zombies") then
                        for _, zombie in ipairs(building.StandaloneZombiePart.Zombies:GetChildren()) do
                            if zombie:IsA("Model") and not zombie:FindFirstChild("ESPHighlight") then
                                createESP(zombie, zombie.Name, "buildZombieESP")
                            end
                        end
                    end
                end
               
                workspace.RandomBuildings.ChildAdded:Connect(function(building)
                    if building:FindFirstChild("StandaloneZombiePart") and building.StandaloneZombiePart:FindFirstChild("Zombies") then
                        for _, zombie in ipairs(building.StandaloneZombiePart.Zombies:GetChildren()) do
                            if zombie:IsA("Model") and not zombie:FindFirstChild("ESPHighlight") and Value then
                                createESP(zombie, zombie.Name, "buildZombieESP")
                            end
                        end
                    end
                end)
            end
        else
            clearESP("buildZombieESP")
        end
    end
})

-- ============================================
-- 近战杀戮（只保留：极速连砍 + 自动攻击）
-- ============================================

local MeleeTab = Window:Tab({
    Title = "近战杀戮",
    Icon = "sword"
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- 变量声明
local MeleeSpam = false
local SwingDelay = 0.05
local SwingsPerDelay = 2
local ClientMeleeHandler = nil
local originalHandler = nil
local currentMeleeTool = nil
local currentAttackTime = nil
local currentLookVector = nil
local swingThread = nil
local AutoAttack = false
local AutoAttackDelay = 0.05
local autoAttackThread = nil

-- 初始化近战处理器
local function safeGetMeleeHandler()
    local success, module = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Game"):WaitForChild("Melee"):WaitForChild("ClientMeleeHandler"))
    end)
    if success and module then
        ClientMeleeHandler = module
        originalHandler = module._meleeActionHandler
    end
end
safeGetMeleeHandler()

-- 发送攻击
local function Swing()
    if not currentMeleeTool or not currentAttackTime or not currentLookVector then return end
    pcall(function()
        ReplicatedStorage.Shared.Universe.Network.RemoteEvent.SwingMelee:FireServer(currentMeleeTool, currentAttackTime, currentLookVector)
    end)
end

-- 近战杀戮：拦截输入，按住攻击时疯狂连发
if ClientMeleeHandler then
    ClientMeleeHandler._meleeActionHandler = function(actionName, inputState, inputObject)
        if MeleeSpam then
            if inputState == Enum.UserInputState.Begin then
                local char = LocalPlayer.Character
                if char then
                    currentMeleeTool = char:FindFirstChildWhichIsA("Tool")
                    if currentMeleeTool then
                        currentAttackTime = workspace:GetServerTimeNow()
                        local mouse = LocalPlayer:GetMouse()
                        currentLookVector = (mouse.Hit and mouse.Hit.LookVector) or char:GetPivot().LookVector
                        swingThread = task.spawn(function()
                            while MeleeSpam and currentMeleeTool do
                                for i = 1, SwingsPerDelay do
                                    Swing()
                                    task.wait(SwingDelay)
                                end
                            end
                        end)
                    end
                end
            elseif inputState == Enum.UserInputState.End then
                if swingThread then
                    task.cancel(swingThread)
                    swingThread = nil
                end
            end
        end
        -- 关闭时恢复原版
        if not MeleeSpam and originalHandler then
            return originalHandler(actionName, inputState, inputObject)
        end
    end
end

-- 自动攻击循环
local function autoAttackLoop()
    while AutoAttack do
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildWhichIsA("Tool")
            if tool then
                local attackTime = workspace:GetServerTimeNow()
                local lookVector = char:GetPivot().LookVector
                pcall(function()
                    ReplicatedStorage.Shared.Universe.Network.RemoteEvent.SwingMelee:FireServer(tool, attackTime, lookVector)
                end)
            end
        end
        task.wait(AutoAttackDelay)
    end
end

-- ========== UI 组件 ==========

MeleeTab:Toggle({
    Title = "极速连砍",
    Desc = "按住攻击键疯狂连发",
    Default = false,
    Callback = function(Value)
        MeleeSpam = Value
        if not Value and swingThread then
            task.cancel(swingThread)
            swingThread = nil
        end
        WindUI:Notify({
            Title = "极速连砍",
            Content = Value and "已开启" or "已关闭",
            Duration = 2,
            Icon = "sword"
        })
    end
})

MeleeTab:Slider({
    Title = "连砍间隔",
    Desc = "每次攻击的等待时间",
    Value = { Min = 0.001, Max = 0.5, Default = 0.05 },
    Callback = function(Value)
        SwingDelay = Value
    end
})

MeleeTab:Slider({
    Title = "每次连发次数",
    Desc = "每次循环的攻击次数",
    Value = { Min = 1, Max = 10, Default = 2 },
    Callback = function(Value)
        SwingsPerDelay = Value
    end
})

MeleeTab:Toggle({
    Title = "自动攻击",
    Desc = "无需按键，自动持续攻击",
    Default = false,
    Callback = function(Value)
        AutoAttack = Value
        if Value then
            if not autoAttackThread then
                autoAttackThread = task.spawn(autoAttackLoop)
            end
        else
            AutoAttack = false
            if autoAttackThread then
                task.cancel(autoAttackThread)
                autoAttackThread = nil
            end
        end
        WindUI:Notify({
            Title = "自动攻击",
            Content = Value and "已开启" or "已关闭",
            Duration = 2,
            Icon = "sword"
        })
    end
})

MeleeTab:Slider({
    Title = "自动攻击频率",
    Desc = "自动攻击的间隔时间",
    Value = { Min = 0.001, Max = 1, Default = 0.05 },
    Callback = function(Value)
        AutoAttackDelay = Value
    end
})

-- ============================================
-- 自动刷债券
-- ============================================

local AutoBondTab = Window:Tab({
    Title = "自动刷债券",
    Icon = "banknote"
})

local AutoBondEnabled = false
local AutoBondCoroutine = nil

AutoBondTab:Toggle({
    Title = "自动刷债券",
    Desc = "自动扫描并存储债券",
    Default = false,
    Callback = function(Value)
        AutoBondEnabled = Value

        if Value then
            if not AutoBondCoroutine then
                AutoBondCoroutine = task.spawn(function()
                    local RS = game:GetService("ReplicatedStorage")
                    local world = require(RS.Shared.Universe.ECS.world)
                    local comps = require(RS.Shared.Universe.ECS.components)
                    local replicator = require(RS.Client.Universe.Replication.clientReplicator)
                    local Remotes = require(RS.Shared.Universe.Remotes)
                    local PlayerData = require(RS.Client.Universe.PlayerDataController)
                    local Event = game:GetService("ReplicatedStorage").Shared.Universe.Network.RemoteEvent.Actionable

                    while AutoBondEnabled do
                        local char = world:get_resource(comps.ClientStateResource).localCharacter
                        if char then
                            if not world:has(char, comps.Sack) then
                                world:add(char, comps.Sack)
                                world:set(char, comps.Sack, { contents = {}, maxContents = 10 })
                            end
                            for id = 1, 100000 do
                                if world:has(id, comps.Storable) and world:get(id, comps.ObjectId) == "bond" then
                                    local sr = replicator:get_server_entity(id)
                                    if sr and sr ~= id then
                                        Remotes.Store:FireServer(sr)
                                        Remotes.Store:FireServer()
                                        Event:FireServer(sr)
                                    end
                                end
                            end
                        end
                        task.wait(1)
                    end
                end)
            end
        else
            AutoBondEnabled = false
        end
    end
})

print(1)
