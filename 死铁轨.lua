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


local KillAuraTab = Window:Tab({
    Title = "枪械杀戮",
    Icon = "crosshair"
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game.Workspace

local ShootRemote = nil
local ReloadRemote = nil

-- 安全查找远程事件
pcall(function()
    if ReplicatedStorage:FindFirstChild("Remotes") then
        local remotes = ReplicatedStorage.Remotes
        if remotes:FindFirstChild("Weapon") then
            ShootRemote = remotes.Weapon:FindFirstChild("Shoot")
            ReloadRemote = remotes.Weapon:FindFirstChild("Reload")
        end
    end
end)

-- 如果找不到，尝试其他常见路径
if not ShootRemote then
    pcall(function()
        ShootRemote = ReplicatedStorage:FindFirstChild("Shoot", true)
    end)
end
if not ReloadRemote then
    pcall(function()
        ReloadRemote = ReplicatedStorage:FindFirstChild("Reload", true)
    end)
end

local Camera = workspace.CurrentCamera or workspace:WaitForChild("Camera")
local LocalPlayer = Players.LocalPlayer

local AutoHeadshotEnabled = false
local AutoReloadEnabled = true
local GUN_SEARCH_RADIUS = 1000
local HEADSHOT_DELAY = 0.1
local killAuraCoroutine = nil

local Weapons = {
    ["Revolver"] = true, ["Rifle"] = true, ["Sawed-Off Shotgun"] = true,
    ["Bolt Action Rifle"] = true, ["Navy Revolver"] = true, ["Mauser"] = true, ["Shotgun"] = true
}

local function getEquippedSupportedWeapon()
    local char = LocalPlayer.Character
    if not char then return nil end
    for name, _ in pairs(Weapons) do
        local tool = char:FindFirstChild(name)
        if tool then return tool end
    end
    return nil
end

local function isNPC(obj)
    if not obj:IsA("Model") then return false end
    if workspace:FindFirstChild("Horse") and obj:IsDescendantOf(workspace.Horse) then return false end
    local hum = obj:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    return obj:FindFirstChild("Head") and obj:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(obj)
end

local function findAllNPCsInRange()
    local npcs = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isNPC(obj) then
            local head = obj:FindFirstChild("Head")
            local dist = (head.Position - Camera.CFrame.Position).Magnitude
            if dist <= GUN_SEARCH_RADIUS then
                table.insert(npcs, {model = obj, hum = obj.Humanoid, head = head})
            end
        end
    end
    table.sort(npcs, function(a, b) return (a.head.Position - Camera.CFrame.Position).Magnitude < (b.head.Position - Camera.CFrame.Position).Magnitude end)
    return npcs
end

local function autoHeadshotLoop()
    while AutoHeadshotEnabled do
        local tool = getEquippedSupportedWeapon()
        if tool and ShootRemote then
            local npcs = findAllNPCsInRange()
            for _, npc in ipairs(npcs) do
                if npc.hum and npc.hum.Health > 0 then
                    local pelletTable = {}
                    if tool.Name:lower():find("shotgun") then
                        for i = 1, 6 do pelletTable[tostring(i)] = npc.hum end
                    else
                        pelletTable["1"] = npc.hum
                    end
                    local shootArgs = {
                        workspace:GetServerTimeNow(),
                        tool,
                        CFrame.new(npc.head.Position + Vector3.new(0, 1.5, 0), npc.head.Position),
                        pelletTable
                    }
                    pcall(function() ShootRemote:FireServer(unpack(shootArgs)) end)
                    if AutoReloadEnabled and ReloadRemote then
                        pcall(function() ReloadRemote:FireServer(workspace:GetServerTimeNow(), tool) end)
                    end
                end
            end
        end
        task.wait(HEADSHOT_DELAY)
    end
end

KillAuraTab:Toggle({
    Title = "枪械杀戮光环",
    Desc = "必须持有枪械",
    Default = false,
    Callback = function(Value)
        AutoHeadshotEnabled = Value
        if Value then
            if not killAuraCoroutine then killAuraCoroutine = task.spawn(autoHeadshotLoop) end
        else
            AutoHeadshotEnabled = false
        end
    end
})

KillAuraTab:Slider({
    Title = "枪械攻击范围",
    Desc = "调整枪械攻击范围",
    Value = { Min = 100, Max = 2000, Default = 1000 },
    Callback = function(Value) GUN_SEARCH_RADIUS = tonumber(Value) or 1000 end
})

KillAuraTab:Toggle({
    Title = "自动装弹",
    Desc = "自动装填弹药",
    Default = true,
    Callback = function(Value) AutoReloadEnabled = Value end
})

KillAuraTab:Toggle({
    Title = "开枪无间隔",
    Default = false,
    Callback = function(Value)
        local quickShootEnabled = Value
        if quickShootEnabled then
            task.spawn(function()
                while quickShootEnabled do
                    task.wait(0.1)
                    pcall(function()
                        for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                                v.WeaponConfiguration.FireDelay.Value = 0
                            end
                        end
                        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                            if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                                v.WeaponConfiguration.FireDelay.Value = 0
                            end
                        end
                    end)
                end
            end)
        else
            pcall(function()
                for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                        v.WeaponConfiguration.FireDelay.Value = 0.2
                    end
                end
                for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                        v.WeaponConfiguration.FireDelay.Value = 0.2
                    end
                end
            end)
        end
    end
})

KillAuraTab:Toggle({
    Title = "无换弹时间",
    Desc = "瞬间装弹",
    Default = false,
    Callback = function(Value)
        local quickReloadEnabled = Value
        if quickReloadEnabled then
            task.spawn(function()
                while quickReloadEnabled do
                    task.wait(0.1)
                    pcall(function()
                        for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                                v.WeaponConfiguration.ReloadDuration.Value = 0
                            end
                        end
                        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                            if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                                v.WeaponConfiguration.ReloadDuration.Value = 0
                            end
                        end
                    end)
                end
            end)
        else
            pcall(function()
                for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                        v.WeaponConfiguration.ReloadDuration.Value = 2
                    end
                end
                for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                        v.WeaponConfiguration.ReloadDuration.Value = 2
                    end
                end
            end)
        end
    end
})

KillAuraTab:Toggle({
    Title = "秒杀子弹",
    Default = false,
    Callback = function(Value)
        local instantKillEnabled = Value
        if instantKillEnabled then
            task.spawn(function()
                while instantKillEnabled do
                    task.wait(0.1)
                    pcall(function()
                        for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                                local magazineFed = v.WeaponConfiguration:FindFirstChild("MagazineFed")
                                if not magazineFed then
                                    magazineFed = Instance.new("BoolValue")
                                    magazineFed.Name = "MagazineFed"
                                    magazineFed.Value = true
                                    magazineFed.Parent = v.WeaponConfiguration
                                end
                            end
                        end
                        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                            if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                                local magazineFed = v.WeaponConfiguration:FindFirstChild("MagazineFed")
                                if not magazineFed then
                                    magazineFed = Instance.new("BoolValue")
                                    magazineFed.Name = "MagazineFed"
                                    magazineFed.Value = true
                                    magazineFed.Parent = v.WeaponConfiguration
                                end
                            end
                        end
                    end)
                end
            end)
        else
            pcall(function()
                for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                        local magazineFed = v.WeaponConfiguration:FindFirstChild("MagazineFed")
                        if magazineFed then magazineFed:Destroy() end
                    end
                end
                for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("Tool") and v:FindFirstChild("WeaponConfiguration") then
                        local magazineFed = v.WeaponConfiguration:FindFirstChild("MagazineFed")
                        if magazineFed then magazineFed:Destroy() end
                    end
                end
            end)
        end
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

local KillAuraTab = Window:Tab({
    Title = "近战杀戮",
    Icon = "sword"
})

local MELEE_SEARCH_RADIUS = 50
local meleeAuraEnabled = false
local meleeAuraCoroutine = nil

local function isMeleeWeapon(tool)
    local meleeWeapons = {
        "Axe", "Pickaxe", "Sword", "Knife", "Bat", "Hammer",
        "Crowbar", "Machete", "Katana", "Spear", "Club"
    }
    
    for _, weaponName in ipairs(meleeWeapons) do
        if tool.Name:lower():find(weaponName:lower()) then
            return true
        end
    end
    return false
end

local function findMeleeTargets()
    local targets = {}
    local character = LocalPlayer.Character
    if not character then return targets end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return targets end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isNPC(obj) then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hrp then
                local distance = (hrp.Position - rootPart.Position).Magnitude
                if distance <= MELEE_SEARCH_RADIUS then
                    table.insert(targets, {
                        model = obj,
                        humanoid = obj.Humanoid,
                        distance = distance
                    })
                end
            end
        end
    end
    
    table.sort(targets, function(a, b)
        return a.distance < b.distance
    end)
    
    return targets
end

local function meleeAttackLoop()
    while meleeAuraEnabled do
        local character = LocalPlayer.Character
        if character then
            local tool = nil
            
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Tool") and isMeleeWeapon(child) then
                    tool = child
                    break
                end
            end
            
            if not tool then
                for _, child in ipairs(LocalPlayer.Backpack:GetChildren()) do
                    if child:IsA("Tool") and isMeleeWeapon(child) then
                        tool = child
                        tool.Parent = character
                        task.wait(0.1)
                        break
                    end
                end
            end
            
            if tool then
                local targets = findMeleeTargets()
                for _, target in ipairs(targets) do
                    if target.humanoid and target.humanoid.Health > 0 then
                        tool:Activate()
                        task.wait(0.2)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end

KillAuraTab:Toggle({
    Title = "近战杀戮光环",
    Default = false,
    Callback = function(Value)
        meleeAuraEnabled = Value
        if Value then
            if not meleeAuraCoroutine then
                meleeAuraCoroutine = task.spawn(meleeAttackLoop)
            end
        else
            meleeAuraEnabled = false
        end
    end
})

KillAuraTab:Slider({
    Title = "近战攻击范围",
    Desc = "调整近战攻击范围",
    Value = {
        Min = 10,
        Max = 100,
        Default = 50
    },
    Callback = function(Value)
        MELEE_SEARCH_RADIUS = Value
    end
})


KillAuraTab:Slider({
    Title = "攻击次数",
    Desc = "每次攻击的次数",
    Value = {
        Min = 1,
        Max = 300,
        Default = 100
    },
    Callback = function(Value)
        attackCount = Value
    end
})

KillAuraTab:Toggle({
    Title = "工具快速攻击",
    Default = false,
    Callback = function(Value)
        meleeAttackEnabled = Value
        if Value then
            task.spawn(function()
                while meleeAttackEnabled do
                    task.wait(0.2)
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character
                        if not character or not character:FindFirstChild("HumanoidRootPart") then
                            return
                        end

                        for _, v in pairs(player.Backpack:GetChildren()) do
                            if v:IsA("Tool") and v:FindFirstChild("Configuration") and 
                               v.Configuration:FindFirstChild("Animations") and 
                               v.Configuration.Animations:FindFirstChild("SwingAnimation") then
                                v.Parent = character
                            end
                        end

                        for _, v in pairs(character:GetChildren()) do
                            if v:IsA("Tool") and v:FindFirstChild("Configuration") and 
                               v.Configuration:FindFirstChild("Animations") and 
                               v.Configuration.Animations:FindFirstChild("SwingAnimation") then
                                for i = 1, attackCount do
                                    for u = 1, 10 do
                                        game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.ChargeMelee:FireServer(v, workspace:GetServerTimeNow())
                                        game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.SwingMelee:FireServer(v, workspace:GetServerTimeNow(), Vector3.new(0, 0, 0))
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})