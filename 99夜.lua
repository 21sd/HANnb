local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()
local Window = WindUI:CreateWindow({
    Title = '99夜',
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
    Title = "99夜",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})
Window:EditOpenButton({
    Title = "森林中的99夜",
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
local lp = game.Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local Light1 = Lighting.Ambient
local Light2 = Lighting.OutdoorAmbient
local Character = lp.Character or lp.CharacterAdded:Wait()
local hrp = Character:FindFirstChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local rs = game:GetService('ReplicatedStorage')
local DamageRemote = rs:FindFirstChild('RemoteEvents'):FindFirstChild('ToolDamageObject')
local inventory = lp:FindFirstChild('Inventory')
local Food = "Carrot"
local PlayerList = {}
for _, v in pairs(game.Players:GetChildren()) do
    if v.Name ~= lp.Name then
        table.insert(PlayerList, v.Name)
    end
end
local TypeList = { y = 0, x = 0 }
local hungerThreshold = 75
local Chinese = {
    ['Coal'] = '煤炭',['Log'] = '木头',['Fuel Canister'] = '燃料罐',['Oil Barrel'] = '燃料桶',
    ['Chair'] = '椅子',['Sapling'] = '树苗',['Broken Microwave'] = '破旧微波炉',['Broken Fan'] = '旧风扇',
    ['Old Radio'] = '旧音响',['Bolt'] = '铁钉',['Sheet Metal'] = '废铁',['Tyre'] = '轮胎',['Washing Machine'] = '洗衣机',
    ['Metal Chair'] = '铁椅子',['UFO Junk'] = '外星残骸',['UFO Scrap'] = '外星残骸1',
    ['Old Car Engine'] = '引擎',['Carrot'] = '胡萝卜',['Cake'] = '蛋糕',['Berry'] = '浆果',
    ['Morsel'] = '生肉腿',['Steak'] = '生肉排',['Cooked Morsel'] = '熟肉腿',['Cooked Steak'] = '熟肉排',
    ['Rifle'] = '步枪',['Revolver'] = '手枪',['Rifle Ammo'] = '步枪子弹',['Revolver Ammo'] = '手枪子弹',
    ['Bandage'] = '绷带',['MedKit'] = '医疗包',['Old Flashlight'] = '旧手电',['Strong Flashlight'] = '强手电',
    ['Old Axe'] = '老斧头',['Good Axe'] = '好斧头',['Strong Axe'] = '强斧头',['Old Sack'] = '旧袋子',
    ['Good Sack'] = '好袋子',['Giant Sack'] = '巨大袋子',['Spear'] = '矛',
    ['Laser Fence Blueprint'] = '防御蓝图',['Leather Body'] = '皮革甲',['Iron Body'] = '铁甲',
    ['Bunny'] = '兔子',['Wolf'] = '狼',['Alpha Wolf'] = '阿尔法狼',['Bear'] = '熊'
}
local ItemList = {
    Item1 = "", Item2 = "", Item3 = "", Item4 = "",
    ItemTpPosition = "玩家",
    Pn = lp.Name
}
local tools = {
    KillTool = "Old Axe",
    CutTool = "Old Axe"
}
local St = {
    Kill = 50,
    Cut = 50
}
local dyzh = {
    ItemESPColor = Color3.fromRGB(0, 128, 255),
    CharacterESPColor = Color3.fromRGB(255, 0, 0),
    nt = 0.5,
    wt = 0
}
local espCache = { Items = {}, Characters = {} }
local function GetItem(Name, Type)
    local ItemState = false
    if Name == "" then
        notify("带来物品", "请你选择物品", 5)
        return
    end
    for _, Item in pairs(workspace.Items:GetChildren()) do
        if Item.Name == Name then
            ItemState = true
            if Type == "玩家" then
                rs.RemoteEvents.RequestStartDraggingItem:FireServer(Item)
                Item:PivotTo(hrp.CFrame * CFrame.new(TypeList.x, TypeList.y, 0))
                task.wait(0.1)
                rs.RemoteEvents.StopDraggingItem:FireServer(Item)
            elseif Type == "篝火" then
                rs.RemoteEvents.RequestStartDraggingItem:FireServer(Item)
                Item:PivotTo(workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(TypeList.x, 20 + TypeList.y, 0))
                task.wait(0.1)
                rs.RemoteEvents.StopDraggingItem:FireServer(Item)
            elseif Type == "工作台" then
                rs.RemoteEvents.RequestStartDraggingItem:FireServer(Item)
                Item:PivotTo(workspace.Map.Campground.Scrapper.Main.CFrame * CFrame.new(TypeList.x, 20 + TypeList.y, 0))
                task.wait(0.1)
                rs.RemoteEvents.StopDraggingItem:FireServer(Item)
            elseif Type == "自定义位置" then
                if workspace:FindFirstChild("waypoint") then
                    rs.RemoteEvents.RequestStartDraggingItem:FireServer(Item)
                    Item:PivotTo(workspace.waypoint.CFrame * CFrame.new(TypeList.x, 20 + TypeList.y, 0))
                    task.wait(0.1)
                    rs.RemoteEvents.StopDraggingItem:FireServer(Item)
                else
                    notify("带来物品", "未找到位置方块", 5)
                    return
                end
            elseif Type == "指定玩家" then
                local targetPlayer = game.Players:FindFirstChild(ItemList.Pn)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local PlCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                    rs.RemoteEvents.RequestStartDraggingItem:FireServer(Item)
                    Item:PivotTo(PlCFrame * CFrame.new(TypeList.x, TypeList.y, 0))
                    task.wait(0.1)
                    rs.RemoteEvents.StopDraggingItem:FireServer(Item)
                else
                    notify("带来物品", "未找到指定玩家或玩家无角色", 5)
                    return
                end
            end
        end
    end
    if not ItemState then
        notify("带来物品", "未找到物品", 5)
    end
end
local function killCharacter(st)
    for _, v in pairs(inventory:GetChildren()) do
        if not string.find(v.Name, "Sack", 1, true) or not string.find(v.Name, "Flashlight", 1, true) or not string.find(v.Name, "MedKit", 1, true) or not string.find(v.Name, "Bandage", 1, true) or not string.find(v.Name, "Riot Shield", 1, true) then
            for _, Child in pairs(workspace.Characters:GetChildren()) do
                local root = Child.PrimaryPart
                if root and hrp and (hrp.Position - root.Position).Magnitude <= st then
                    pcall(function()
                        DamageRemote:InvokeServer(Child, v, true, hrp.CFrame)
                    end)
                end
            end
        end
    end
end
local function CreateEsp(object, config)
    if not object or not object.Parent then return end
    local eh = object:FindFirstChild('Esp')
    local eb = object:FindFirstChild('b')
    if eh then eh:Destroy() end
    if eb then eb:Destroy() end
    local h = Instance.new('Highlight')
    h.Parent = object
    h.FillColor = config.fillColor
    h.Name = 'Esp'
    h.FillTransparency = config.fillTransparency
    h.OutlineColor = Color3.new(1, 1, 1)
    h.OutlineTransparency = config.outlineTransparency
    local b = Instance.new('BillboardGui')
    b.Parent = object
    b.Size = UDim2.new(0, 100, 0, 20)
    b.Name = 'b'
    b.AlwaysOnTop = true
    local t = Instance.new('TextLabel')
    t.Parent = b
    t.Size = UDim2.new(1, 0, 1, 0)
    t.TextSize = 14
    t.Name = 'Label'
    t.TextStrokeColor3 = Color3.new(0, 0, 0)
    t.TextStrokeTransparency = 0
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.SourceSansBold
    t.TextColor3 = config.textColor
    return h, b, t
end
local function GetDisplayName(n)
    return Chinese[n] or n
end
local function CalcDist(o)
    local p = o.PrimaryPart or o:FindFirstChildWhichIsA('BasePart')
    if not p or not hrp then return 0 end
    return (hrp.Position - p.Position).Magnitude
end
local function ModelHeight(m)
    local min, max = math.huge, -math.huge
    for _, v in pairs(m:GetDescendants()) do
        if v:IsA("BasePart") then
            local y = v.CFrame.Y
            local s = v.Size.Y / 2
            min = math.min(min, y - s)
            max = math.max(max, y + s)
        end
    end
    return max > min and max - min or 5
end
local function EspItem(name)
    for _, v in pairs(workspace.Items:GetChildren()) do
        if v.Name == name then
            local old = espCache.Items[v]
            if old then
                if old.conn then old.conn:Disconnect() end
                espCache.Items[v] = nil
            end
            local cfg = {fillColor = Color3.fromRGB(0, 128, 255), textColor = Color3.fromRGB(0, 128, 255),
                         fillTransparency = dyzh.nt, outlineTransparency = dyzh.wt}
            local h, b, l = CreateEsp(v, cfg)
            b.StudsOffset = Vector3.new(0, ModelHeight(v) + 1.5, 0)
            l.Text = GetDisplayName(name) .. "[" .. math.floor(CalcDist(v) + 0.5) .. "m]"
            espCache.Items[v] = {highlight = h, billboard = b, textLabel = l, conn = nil}
        end
    end
end
local function RemoveEspItem(name)
    for _, v in pairs(workspace.Items:GetChildren()) do
        if v.Name == name and espCache.Items[v] then
            local e = espCache.Items[v]
            if e.conn then e.conn:Disconnect() end
            if e.highlight then e.highlight:Destroy() end
            if e.billboard then e.billboard:Destroy() end
            espCache.Items[v] = nil
        end
    end
end
local function EspCharacter(name)
    for _, v in pairs(workspace.Characters:GetChildren()) do
        if v.Name == name then
            local old = espCache.Characters[v]
            if old then
                if old.conn then old.conn:Disconnect() end
                espCache.Characters[v] = nil
            end
            local cfg = {fillColor = Color3.fromRGB(0, 255, 0), textColor = Color3.fromRGB(0, 255, 0),
                         fillTransparency = dyzh.nt, outlineTransparency = dyzh.wt}
            local h, b, l = CreateEsp(v, cfg)
            b.StudsOffset = Vector3.new(0, ModelHeight(v) + 1.5, 0)
            l.Text = GetDisplayName(name) .. "[" .. math.floor(CalcDist(v) + 0.5) .. "m]"
            espCache.Characters[v] = {highlight = h, billboard = b, textLabel = l, conn = nil}
        end
    end
end
local function RemoveEspCharacter(name)
    for _, v in pairs(workspace.Characters:GetChildren()) do
        if v.Name == name and espCache.Characters[v] then
            local e = espCache.Characters[v]
            if e.conn then e.conn:Disconnect() end
            if e.highlight then e.highlight:Destroy() end
            if e.billboard then e.billboard:Destroy() end
            espCache.Characters[v] = nil
        end
    end
end
local function ClearAllEsp()
    for _, e in pairs(espCache.Items) do
        if e.conn then e.conn:Disconnect() end
        if e.highlight then e.highlight:Destroy() end
        if e.billboard then e.billboard:Destroy() end
    end
    for _, e in pairs(espCache.Characters) do
        if e.conn then e.conn:Disconnect() end
        if e.highlight then e.highlight:Destroy() end
        if e.billboard then e.billboard:Destroy() end
    end
    espCache.Items = {}
    espCache.Characters = {}
end
local function OpenChestTme(Time)
    for _, Chest in pairs(workspace.Items:GetChildren()) do
        if Chest.Name:find("Chest") and Chest:FindFirstChild("Main") then
            local Main = Chest.Main
            if Main:FindFirstChild("ProximityAttachment") then
                local Attachment = Main.ProximityAttachment
                if Attachment:FindFirstChild("ProximityInteraction") then
                    Attachment.ProximityInteraction.HoldDuration = Time
                end
            end
        end
    end
end
local function OpenChest()
    for _, Chest in pairs(workspace.Items:GetChildren()) do
        if Chest.Name:find("Chest") then
            local Main = Chest:FindFirstChild("Main")
            if Main then
                local Attachment = Main:FindFirstChild("ProximityAttachment")
                if Attachment then
                    local Interaction = Attachment:FindFirstChild("ProximityInteraction")
                    if Interaction then
                        fireproximityprompt(Interaction)
                    end
                end
            end
        end
    end
end
local function AutoFire(Name)
    for _, Item in pairs(workspace.Items:GetChildren()) do
        if Item.Name == Name then
            rs.RemoteEvents.RequestStartDraggingItem:FireServer(Item)
            Item:PivotTo(workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(0, 20, 0))
        end
    end
end
local function AutoScrapper(Name)
    for _, Item in pairs(workspace.Items:GetChildren()) do
        if Item.Name == Name then
            rs.RemoteEvents.RequestStartDraggingItem:FireServer(Item)
            Item:PivotTo(workspace.Map.Campground.Scrapper.Main.CFrame * CFrame.new(0, 20, 0))
        end
    end
end
local function feed(nome)
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name == nome then
            rs.RemoteEvents.RequestConsumeItem:InvokeServer(item)
            break
        end
    end
end
local function notifeed(nome)
    notify("自动食物停止", "食物已经没了", 3)
end
local function wiki(nome)
    local c = 0
    for _, i in pairs(workspace.Items:GetChildren()) do
        if i.Name == nome then
            c = c + 1
        end
    end
    return c
end
local function ghn()
    return math.floor(lp.PlayerGui.Interface.StatBars.HungerBar.Bar.Size.X.Scale * 100)
end
local function getDeviceType()
    local UserInputService = game:GetService("UserInputService")
    if UserInputService.TouchEnabled then
        if UserInputService.KeyboardEnabled then
            return "平板"
        else
            return "手机"
        end
    else
        return "电脑"
    end
end
local function notify(title, content, duration, icon)
    WindUI:Notify({Title = title, Content = content, Duration = duration or 3, Icon = icon or 'crown'})
end
Window:Divider()
Window:Divider()
local TabHandles = {
    Player = Window:Tab({ Title = "玩家", Icon = "user"}),
    TPItem = Window:Tab({ Title = "传送物品", Icon = "folder"}),
    TPItemSettings = Window:Tab({ Title = "传送物品设置", Icon = "folder"}),
    Kill1 = Window:Tab({ Title = "杀戳光环", Icon = "folder"}),
    Cut1 = Window:Tab({ Title = "砍树光环", Icon = "folder"}),
    plant = Window:Tab({ Title = "种植树", Icon = "folder"}),
    ItemEsp = Window:Tab({ Title = "物品透视", Icon = "folder"}),
    CharacterEsp = Window:Tab({ Title = "动物透视", Icon = "folder"}),
    ESPSettings = Window:Tab({ Title = "透视设置", Icon = "folder"}),
    Auto1 = Window:Tab({ Title = "篝火", Icon = "folder"}),
    Auto2 = Window:Tab({ Title = "工作台", Icon = "folder"}),
    Auto3 = Window:Tab({ Title = "食物", Icon = "folder"}),
    Auto4 = Window:Tab({ Title = "鱼", Icon = "folder"}),
    Chest = Window:Tab({ Title = "宝箱", Icon = "folder"}),
    Coin = Window:Tab({ Title = "金币", Icon = "folder"}),
    LostKid = Window:Tab({ Title = "孩子", Icon = "folder"}),
    Tp2 = Window:Tab({ Title = "传送", Icon = "folder"})
}
TabHandles.Player:Section({ Title = "玩家设置", Desc = "玩家", Icon = 'user', ImageSize = 30, Opened = true })
TabHandles.Player:Slider({
    Title = "玩家速度", Step = 1,
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(value) if Character and Character:FindFirstChild("Humanoid") then Character.Humanoid.WalkSpeed = value end end
})
TabHandles.Player:Slider({
    Title = "玩家跳跃高度", Step = 1,
    Value = { Min = 50, Max = 200, Default = 50 },
    Callback = function(value) if Character and Character:FindFirstChild("Humanoid") then Character.Humanoid.JumpHeight = value end end
})
TabHandles.Player:Toggle({
    Title = "高亮", Value = false,
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.Ambient = Light1
            Lighting.OutdoorAmbient = Light2
        end
    end
})
TabHandles.Player:Button({
    Title = "无敌模式",
    Callback = function() game:GetService("ReplicatedStorage").RemoteEvents.DamagePlayer:FireServer(-10000000000000) end
})
TabHandles.Player:Toggle({
    Title = "自动眩晕鹿", Value = false,
    Callback = function(state)
        if state then
            torchLoop = game.GetService("RunService").Heart:Connect(function()
                pcall(function()
                    local remote = rs:FindFirstChild("RemoteEvents") and rs.RemoteEvents:FindFirstChild("DeerHitByTorch")
                    local deer = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild("Deer")
                    if remote and deer then remote:InvokeServer(deer) end
                end)
                task.wait(0.1)
            end)
        else
            if torchLoop then torchLoop:Disconnect(); torchLoop = nil end
        end
    end
})
TabHandles.TPItem:Section({ Title = "带来物品", Icon = 'anchor', ImageSize = 30, Opened = true })
TabHandles.TPItem:Dropdown({
    Title = "铁质类物品下拉菜单", Values = {'洗衣机', '破旧微波炉', '旧风扇', '旧音响', '铁钉', '废铁', '轮胎', '铁椅子', '外星残骸', '外星残骸1', '外星残骸2', '引擎'},
    Value = "选择", Multi = false, AllowNone = false,
    Callback = function(Item)
        local GetItemList = {
            ['破旧微波炉'] = 'Broken Microwave', ['旧风扇'] = 'Broken Fan', ['旧音响'] = 'Old Radio',
            ['铁钉'] = 'Bolt', ['废铁'] = 'Sheet Metal', ['轮胎'] = 'Tyre', ['铁椅子'] = 'Metal Chair',
            ['外星残骸'] = 'UFO Junk', ['外星残骸1'] = 'UFO Scrap', ['外星残骸2'] = 'UFO Component',
            ['洗衣机'] = 'Washing Machine', ['引擎'] = 'Old Car Engine'
        }
        ItemList.Item1 = GetItemList[Item]
    end
})
TabHandles.TPItem:Button({ Title = "带来", Callback = function() GetItem(ItemList.Item1, ItemList.ItemTpPosition) end })
TabHandles.TPItem:Dropdown({
    Title = "燃料类物品下拉菜单", Values = { '煤炭', '木头', '燃料罐', '燃料桶', '椅子', '树苗' },
    Value = "选择", Multi = false, AllowNone = false,
    Callback = function(Item)
        local GetItemList = { ['煤炭'] = 'Coal', ['木头'] = 'Log', ['燃料罐'] = 'Fuel Canister', ['燃料桶'] = 'Oil Barrel', ['椅子'] = 'Chair', ['树苗'] = 'Sapling' }
        ItemList.Item2 = GetItemList[Item]
    end
})
TabHandles.TPItem:Button({ Title = "带来", Callback = function() GetItem(ItemList.Item2, ItemList.ItemTpPosition) end })
TabHandles.TPItem:Dropdown({
    Title = "食物类物品下拉菜单", Values = {'胡萝卜', '蛋糕', '浆果', '生肉腿', '生肉排', '熟肉腿', '熟肉排'},
    Value = "选择", Multi = false, AllowNone = false,
    Callback = function(Item)
        local GetItemList = { ['胡萝卜'] = 'Carrot', ['蛋糕'] = 'Cake', ['浆果'] = 'Berry', ['生肉腿'] = 'Morsel', ['生肉排'] = 'Steak', ['熟肉腿'] = 'Cooked Morsel', ['熟肉排'] = 'Cooked Steak' }
        ItemList.Item3 = GetItemList[Item]
    end
})
TabHandles.TPItem:Button({ Title = "带来", Callback = function() GetItem(ItemList.Item3, ItemList.ItemTpPosition) end })
TabHandles.TPItem:Paragraph({ Title = "提示", Desc = "带来胡萝卜需要先带来浆果", Image = "info", ImageSize = 15 })
TabHandles.TPItem:Dropdown({
    Title = "道具类物品下拉菜单", Values = { '步枪', '手枪', '外星炮', '手枪子弹', '步枪子弹', '绷带', '医疗包', '旧手电', '强手电', '老斧头', '好斧头', '强斧头', '旧袋子', '好袋子', '巨大袋子', '矛', '防御蓝图', '皮革甲', '铁甲', '森林碎片', '防爆盾' },
    Value = "选择", Multi = false, AllowNone = false,
    Callback = function(Item)
        local GetItemList = {
            ['步枪'] = 'Rifle', ['手枪'] = 'Revolver', ["外星炮"] = 'Laser Cannon',
            ['手枪子弹'] = 'Revolver Ammo', ['步枪子弹'] = 'Rifle Ammo', ['绷带'] = 'Bandage',
            ['医疗包'] = 'MedKit', ['旧手电'] = 'Old Flashlight', ['强手电'] = 'Strong Flashlight',
            ['老斧头'] = 'Old Axe', ['好斧头'] = 'Good Axe', ['强斧头'] = 'Strong Axe',
            ['旧袋子'] = 'Old Sack', ['好袋子'] = 'Good Sack', ['巨大袋子'] = 'Giant Sack',
            ['矛'] = 'Spear', ['防御蓝图'] = 'Defense Blueprint', ['皮革甲'] = 'Leather Body',
            ['铁甲'] = 'Iron Body', ['森林碎片'] = 'Gem of the Forest Fragment', ['防爆盾'] = 'Riot Shield'
        }
        ItemList.Item4 = GetItemList[Item]
    end
})
TabHandles.TPItem:Button({ Title = "带来", Callback = function() GetItem(ItemList.Item4, ItemList.ItemTpPosition) end })
TabHandles.TPItem:Button({
    Title = "传送全服物品",
    Callback = function()
        for _, Item in pairs(workspace.Items:GetChildren()) do
            if not Item.Name:find("Chest") then
                if ItemList.ItemTpPosition == '玩家' then
                    rs.RemoteEvents.RequestStartDraggingItem:FireServer(Item)
                    Item:PivotTo(hrp.CFrame * CFrame.new(ItemList.x, ItemList.y, 0))
                    task.wait(0.1)
                    rs.RemoteEvents.StopDraggingItem:FireServer(Item)
                elseif ItemList.ItemTpPosition == '篝火' then
                    rs.RemoteEvents.RequestStartDraggingItem:FireServer(Item)
                    Item:PivotTo(workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(ItemList.x, 20 + ItemList.y, 0))
                    task.wait(0.1)
                    rs.RemoteEvents.StopDraggingItem:FireServer(Item)
                elseif ItemList.ItemTpPosition == '工作台' then
                    rs.RemoteEvents.RequestStartDraggingItem:FireServer(Item)
                    Item:PivotTo(workspace.Map.Campground.Scrapper.Main.CFrame * CFrame.new(ItemList.x, 20 + ItemList.y, 0))
                    task.wait(0.1)
                    rs.RemoteEvents.StopDraggingItem:FireServer(Item)
                elseif ItemList.ItemTpPosition == '自定义位置' then
                    if workspace.waypoint then
                        rs.RemoteEvents.RequestStartDraggingItem:FireServer(Item)
                        Item:PivotTo(workspace.waypoint.CFrame * CFrame.new(ItemList.x, 20 + ItemList.y, 0))
                        task.wait(0.1)
                        rs.RemoteEvents.StopDraggingItem:FireServer(Item)
                    end
                elseif ItemList.ItemTpPosition == '指定玩家' then
                    local target = game.Players:FindFirstChild(ItemList.Pn)
                    if target and target.Character then
                        rs.RemoteEvents.RequestStartDraggingItem:FireServer(Item)
                        Item:PivotTo(target.Character.HumanoidRootPart.CFrame * CFrame.new(ItemList.x, 20 + ItemList.y, 0))
                        task.wait(0.1)
                        rs.RemoteEvents.StopDraggingItem:FireServer(Item)
                    end
                end
            end
        end
    end
})
TabHandles.TPItemSettings:Section({ Title = "带来物品设置", Icon = 'settings', ImageSize = 30, Opened = true })
TabHandles.TPItemSettings:Dropdown({
    Title = "下拉菜单", Values = {"玩家", "篝火", "工作台", "自定义位置", "指定玩家"},
    Value = "玩家", Multi = false, AllowNone = false,
    Callback = function(Value) ItemList.ItemTpPosition = Value end
})
TabHandles.TPItemSettings:Paragraph({ Title = "提示", Desc = "这是物品传送位置", Image = "info", ImageSize = 15 })
TabHandles.TPItemSettings:Slider({ Title = "右偏移度", Step = 1, Value = { Min = 0, Max = 20, Default = 0 }, Callback = function(value) TypeList.x = value end })
TabHandles.TPItemSettings:Slider({ Title = "上偏移度", Step = 1, Value = { Min = 0, Max = 20, Default = 0 }, Callback = function(value) TypeList.y = value end })
TabHandles.TPItemSettings:Paragraph({ Title = "提示", Desc = "每个位置都带有默认偏移高度 无法改变", Image = "info", ImageSize = 15 })
TabHandles.TPItemSettings:Button({ Title = "在此放置位置方块", Callback = function()
    for _, part in pairs(workspace:GetChildren()) do if part.Name == "waypoint" then part:Destroy() end end
    local waypoint = Instance.new("Part")
    waypoint.Name = "waypoint"
    waypoint.BrickColor = BrickColor.new("Bright red")
    waypoint.Material = Enum.Material.Neon
    waypoint.Transparency = 0.7
    waypoint.Size = Vector3.new(2, 2, 2)
    waypoint.Anchored = true
    waypoint.CanCollide = false
    waypoint.Position = hrp.Position + Vector3.new(0, 3, 0)
    waypoint.Parent = workspace
    notify("自定义位置", "放置完成", 3)
end })
TabHandles.TPItemSettings:Button({ Title = "删除位置方块", Callback = function()
    if workspace.waypoint then workspace.waypoint:Destroy(); notify("自定义位置", "删除完成", 3) end
end })
TabHandles.TPItemSettings:Paragraph({ Title = "提示", Desc = "请打开传送模式的[自定义位置]", Image = "info", ImageSize = 15 })
TabHandles.TPItemSettings:Input({
    Title = "输入指定玩家名称", Value = lp.Name, Placeholder = "请输入",
    Callback = function(text) ItemList.Pn = text; notify("带来物品", "修改完成: " .. text, 3) end
})
local SelectPlayer = TabHandles.TPItemSettings:Dropdown({
    Title = "选择玩家", Values = PlayerList, Value = "请选择",
    Callback = function(value) ItemList.Pn = value; notify("带来物品", "修改完成: " .. value, 3) end
})
TabHandles.Kill1:Section({ Title = "杀戳光环(范围)", Icon = 'axe', ImageSize = 30, Opened = true })
local run = false
TabHandles.Kill1:Toggle({
    Title = "杀戮光环", Value = false,
    Callback = function(state)
        run = state
        if state then
            task.spawn(function()
                while run do
                    killCharacter(St.Kill * 1.1)
                    task.wait(0.1)
                end
            end)
        end
    end
})
TabHandles.Kill1:Slider({ Title = "杀戮范围", Step = 1, Value = { Min = 50, Max = 500, Default = 50 }, Callback = function(value) St.Kill = value end })
TabHandles.Kill1:Section({ Title = "杀戳光环(全图)", Icon = 'axe', ImageSize = 30, Opened = true })
local run1 = false
TabHandles.Kill1:Toggle({
    Title = "全图杀戮光环", Value = false,
    Callback = function(state)
        run1 = state
        if state then
            task.spawn(function()
                while run1 do
                    local axe = inventory:FindFirstChild(tools.KillTool)
                    for _, Child in pairs(workspace.Characters:GetChildren()) do
                        DamageRemote:InvokeServer(Child, axe, '1_' .. lp.CharacterAppearanceId, hrp.CFrame)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})
TabHandles.Cut1:Section({ Title = "砍树光环(范围)", Icon = 'tree-pine', ImageSize = 30, Opened = true })
local ActiveAutoChopTree = false
TabHandles.Cut1:Toggle({
    Title = "砍树光环", Value = false,
    Callback = function(state)
        ActiveAutoChopTree = state
        task.spawn(function()
            while ActiveAutoChopTree do
                local weapon = inventory:FindFirstChild("Old Axe") or inventory:FindFirstChild("Good Axe") or inventory:FindFirstChild("Strong Axe") or inventory:FindFirstChild("Chainsaw")
                for _, tree in pairs(workspace.Map.Foliage:GetChildren()) do
                    if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and tree.PrimaryPart then
                        local distance = (tree.PrimaryPart.Position - hrp.Position).Magnitude
                        if distance <= St.Cut then
                            DamageRemote:InvokeServer(tree, weapon, 999, hrp.CFrame)
                        end
                    end
                end
                for _, tree in pairs(workspace.Map.Landmarks:GetChildren()) do
                    if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and tree.PrimaryPart then
                        local distance = (tree.PrimaryPart.Position - hrp.Position).Magnitude
                        if distance <= St.Cut then
                            DamageRemote:InvokeServer(tree, weapon, 999, hrp.CFrame)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})
TabHandles.Cut1:Slider({ Title = "砍树范围", Step = 1, Value = { Min = 50, Max = 500, Default = 50 }, Callback = function(value) St.Cut = value end })
TabHandles.plant:Section({ Title = "种植树", Icon = 'tree-pine', ImageSize = 30, Opened = true })
local plantShape = "圆形"
local radius = 40
local spacing = 1
local Root = "玩家"
local isPlanting = false
TabHandles.plant:Dropdown({ Title = "选择种植形状", Values = {"圆形", "正方形"}, Value = "圆形", Callback = function(value) plantShape = value end })
TabHandles.plant:Dropdown({ Title = "选择种植中心", Values = {"玩家", "篝火"}, Value = "玩家", Callback = function(value) Root = value end })
TabHandles.plant:Slider({ Title = "种植半径大小", Value = { Min = 1, Max = 150, Default = 50 }, Callback = function(value) radius = value end })
TabHandles.plant:Toggle({
    Title = "自动种植", Value = false,
    Callback = function(state)
        isPlanting = state
        if state then
            local RequestPlantItem = rs.RemoteEvents.RequestPlantItem
            local Sapling = workspace.Items:FindFirstChild("Sapling")
            local rootpart
            if Root == "玩家" then rootpart = hrp else rootpart = workspace.Map.Campground.MainFire:FindFirstChild("Center") end
            local fixedY = 1.216280221939087
            task.spawn(function()
                if plantShape == "圆形" then
                    local circumference = 2 * math.pi * radius
                    local numTrees = math.floor(circumference / spacing)
                    local angleStep = 360 / numTrees
                    for i = 0, numTrees - 1 do
                        if not isPlanting then break end
                        local angle = i * angleStep
                        local angleRad = math.rad(angle)
                        local x = rootpart.Position.X + radius * math.cos(angleRad)
                        local z = rootpart.Position.Z + radius * math.sin(angleRad)
                        RequestPlantItem:InvokeServer(Sapling, Vector3.new(x, fixedY, z))
                        task.wait(0.1)
                    end
                else
                    local sideLength = radius * 2
                    local numTreesPerSide = math.floor(sideLength / spacing)
                    local step = sideLength / numTreesPerSide
                    local halfSide = sideLength / 2
                    for i = 0, numTreesPerSide do
                        if not isPlanting then break end
                        local x = rootpart.Position.X - halfSide + i * step
                        RequestPlantItem:InvokeServer(Sapling, Vector3.new(x, fixedY, rootpart.Position.Z - halfSide))
                        RequestPlantItem:InvokeServer(Sapling, Vector3.new(x, fixedY, rootpart.Position.Z + halfSide))
                        task.wait(0.1)
                    end
                    for i = 1, numTreesPerSide - 1 do
                        if not isPlanting then break end
                        local z = rootpart.Position.Z - halfSide + i * step
                        RequestPlantItem:InvokeServer(Sapling, Vector3.new(rootpart.Position.X - halfSide, fixedY, z))
                        RequestPlantItem:InvokeServer(Sapling, Vector3.new(rootpart.Position.X + halfSide, fixedY, z))
                        task.wait(0.1)
                    end
                end
            end)
        end
    end
})
TabHandles.plant:Paragraph({ Title = "提示", Desc = "种植时务必有一个树苗 否则无效", Image = "info", ImageSize = 15 })
local es, es2, es3, es4, es5, es6, es7, es8, es9, es10, es11, es12, es13, es14, es15, es16, es17 = false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
TabHandles.ItemEsp:Section({ Title = "物品透视", Icon = 'eye', ImageSize = 30, Opened = true })
local function MakeEspToggle(name, items, color)
    local state = false
    TabHandles.ItemEsp:Toggle({
        Title = "透视" .. name, Value = false,
        Callback = function(s)
            state = s
            if s then
                task.spawn(function()
                    while state do
                        if type(items) == "table" then
                            for _, it in pairs(items) do EspItem(it) end
                        else
                            EspItem(items)
                        end
                        task.wait(0.1)
                    end
                end)
            else
                if type(items) == "table" then
                    for _, it in pairs(items) do RemoveEspItem(it) end
                else
                    RemoveEspItem(items)
                end
            end
        end
    })
    return state
end
MakeEspToggle("煤炭", "Coal")
MakeEspToggle("生肉", {"Steak","Morsel"})
MakeEspToggle("熟肉", {"Cooked Steak","Cooked Morsel"})
MakeEspToggle("燃料罐", "Fuel Canister")
MakeEspToggle("燃料桶", "Oil Barrel")
MakeEspToggle("木头", "Log")
MakeEspToggle("铁类物品", {"Old Car Engine","UFO Scrap","UFO Junk","Metal Chair","Tyre","Sheet Metal","Bolt","Old Radio","Broken Fan","Broken Microwave","Washing Machine"})
MakeEspToggle("胡萝卜", "Carrot")
MakeEspToggle("浆果", "Berry")
MakeEspToggle("枪", {"Revolver","Rifle"})
MakeEspToggle("弹药", {"Revolver Ammo","Rifle Ammo"})
MakeEspToggle("袋子", {"Old Sack","Good Sack","Giant Sack"})
MakeEspToggle("斧头", {"Old Axe","Good Axe","Strong Axe"})
MakeEspToggle("手电", {"Old Flashlight","Strong Flashlight"})
MakeEspToggle("盔甲", {"Leather Body","Iron Body"})
MakeEspToggle("医疗用品", {"Bandage","MedKit"})
MakeEspToggle("矛", "Spear")
local esd, esd1, esd2, esd3 = false, false, false, false
TabHandles.CharacterEsp:Section({ Title = "动物透视", Icon = 'eye', ImageSize = 30, Opened = true })
TabHandles.CharacterEsp:Toggle({ Title = "透视兔子", Value = false, Callback = function(s) esd = s; if s then task.spawn(function() while esd do EspCharacter("Bunny") task.wait(0.1) end end) else RemoveEspCharacter("Bunny") end end })
TabHandles.CharacterEsp:Toggle({ Title = "透视狼", Value = false, Callback = function(s) esd1 = s; if s then task.spawn(function() while esd1 do EspCharacter("Wolf") task.wait(0.1) end end) else RemoveEspCharacter("Wolf") end end })
TabHandles.CharacterEsp:Toggle({ Title = "透视阿尔法狼", Value = false, Callback = function(s) esd2 = s; if s then task.spawn(function() while esd2 do EspCharacter("Alpha Wolf") task.wait(0.1) end end) else RemoveEspCharacter("Alpha Wolf") end end })
TabHandles.CharacterEsp:Toggle({ Title = "透视熊", Value = false, Callback = function(s) esd3 = s; if s then task.spawn(function() while esd3 do EspCharacter("Bear") task.wait(0.1) end end) else RemoveEspCharacter("Bear") end end })
TabHandles.ESPSettings:Section({ Title = "透视设置", Icon = 'settings', ImageSize = 30, Opened = true })
TabHandles.ESPSettings:Slider({
    Title = "ESP透明度", Step = 0.1, Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(value)
        dyzh.nt = value
        for _, cache in pairs(espCache.Items) do if cache.highlight then cache.highlight.FillTransparency = value end end
        for _, cache in pairs(espCache.Characters) do if cache.highlight then cache.highlight.FillTransparency = value end end
    end
})
TabHandles.ESPSettings:Slider({
    Title = "ESP透明度(轮廓)", Step = 0.1, Value = { Min = 0, Max = 1, Default = 0 },
    Callback = function(value)
        dyzh.wt = value
        for _, cache in pairs(espCache.Items) do if cache.highlight then cache.highlight.OutlineTransparency = value end end
        for _, cache in pairs(espCache.Characters) do if cache.highlight then cache.highlight.OutlineTransparency = value end end
    end
})
TabHandles.Chest:Section({ Title = "宝箱互动", Icon = 'sparkles', ImageSize = 30, Opened = true })
local OpenTime = 5.5
TabHandles.Chest:Input({ Title = "宝箱打开时间", Value = "5.5", Callback = function(text) OpenTime = tonumber(text) end })
TabHandles.Chest:Toggle({ Title = "开启自定义开启", Value = false, Callback = function(state) if state then OpenChestTme(OpenTime) else OpenChestTme(5.5) end end })
TabHandles.Chest:Button({ Title = "打开所有宝箱", Callback = function() OpenChest() end })
local ChestRunState = false
TabHandles.Chest:Toggle({ Title = "自动打开宝箱", Value = false, Callback = function(state) ChestRunState = state; if state then task.spawn(function() while ChestRunState do OpenChest() task.wait(0.1) end end) end end })
TabHandles.Chest:Paragraph({ Title = "提示", Desc = "需要你的注入器支持", Image = "info", ImageSize = 15 })
TabHandles.Coin:Section({ Title = "捡起硬币", Icon = 'coins', ImageSize = 30, Opened = true })
TabHandles.Coin:Button({ Title = "拾取所有硬币", Callback = function()
    for _, v in pairs(workspace.Items:GetChildren()) do if v.Name == 'Coin Stack' then rs.RemoteEvents.RequestCollectCoints:InvokeServer(v) end end
end })
TabHandles.Coin:Toggle({ Title = "自动拾取硬币", Value = false, Callback = function(state) ChestRunState = state; if state then task.spawn(function() while ChestRunState do for _, v in pairs(workspace.Items:GetChildren()) do if v.Name == 'Coin Stack' then rs.RemoteEvents.RequestCollectCoints:InvokeServer(v) end end task.wait() end end) end end })
TabHandles.Auto1:Section({ Title = "自动篝火", Icon = 'atom', ImageSize = 30, Opened = true })
local AutoState0 = false
TabHandles.Auto1:Toggle({ Title = "自动篝火(椅子)", Value = false, Callback = function(state) AutoState0 = state; if state then task.spawn(function() while AutoState0 do AutoFire("Chair") task.wait(1) end end) end end })
local AutoState1 = false
TabHandles.Auto1:Toggle({ Title = "自动篝火(煤炭)", Value = false, Callback = function(state) AutoState1 = state; if state then task.spawn(function() while AutoState1 do AutoFire("Coal") task.wait(1) end end) end end })
local AutoState2 = false
TabHandles.Auto1:Toggle({ Title = "自动篝火(木头)", Value = false, Callback = function(state) AutoState2 = state; if state then task.spawn(function() while AutoState2 do AutoFire("Log") task.wait(1) end end) end end })
local AutoState3 = false
TabHandles.Auto1:Toggle({ Title = "自动篝火(燃料罐)", Value = false, Callback = function(state) AutoState3 = state; if state then task.spawn(function() while AutoState3 do AutoFire("Fuel Canister") task.wait(1) end end) end end })
local AutoState4 = false
TabHandles.Auto1:Toggle({ Title = "自动篝火(燃料桶)", Value = false, Callback = function(state) AutoState4 = state; if state then task.spawn(function() while AutoState4 do AutoFire("Oil Barrel") task.wait(1) end end) end end })
TabHandles.Auto2:Section({ Title = "自动工作台", Icon = 'chevrons-right', ImageSize = 30, Opened = true })
local function MakeAutoScrapperToggle(name, itemName)
    local state = false
    TabHandles.Auto2:Toggle({ Title = "自动工作台(" .. name .. ")", Value = false, Callback = function(s) state = s; if s then task.spawn(function() while state do AutoScrapper(itemName) task.wait(1) end end) end end })
end
MakeAutoScrapperToggle("木头", "Log")
MakeAutoScrapperToggle("洗衣机", "Washing Machine")
MakeAutoScrapperToggle("破旧微波炉", "Broken Microwave")
MakeAutoScrapperToggle("风扇", "Broken Fan")
MakeAutoScrapperToggle("旧音响", "Old Radio")
MakeAutoScrapperToggle("铁钉", "Bolt")
MakeAutoScrapperToggle("废铁", "Sheet Metal")
MakeAutoScrapperToggle("轮胎", "Tyre")
MakeAutoScrapperToggle("铁椅子", "Metal Chair")
MakeAutoScrapperToggle("外星残骸", "UFO Component")
MakeAutoScrapperToggle("外星残骸1", "UFO Junk")
MakeAutoScrapperToggle("外星残骸2", "UFO Scrap")
MakeAutoScrapperToggle("引擎", "Old Car Engine")
TabHandles.Auto3:Section({ Title = "自动烹饪食物", Icon = 'chef-hat', ImageSize = 30, Opened = true })
local Cooking = false
TabHandles.Auto3:Toggle({ Title = "自动煎烤食物", Value = false, Callback = function(state) Cooking = state; if state then task.spawn(function() while Cooking do for _, Item in pairs(workspace.Items:GetChildren()) do if Item.Name == "Steak" or Item.Name == "Morsel" then rs.RemoteEvents.RequestCookItem:FireServer(workspace.Map.Campground.MainFire, Item) end end task.wait(0.1) end end) end end })
TabHandles.Auto3:Paragraph({ Title = "提示", Desc = "使用前请确保篝火存在", Image = "info", ImageSize = 15 })
TabHandles.Auto3:Section({ Title = "自动吃食物", Icon = 'beef', ImageSize = 30, Opened = true })
TabHandles.Auto3:Dropdown({
    Title = "选择食物", Values = {"蛋糕", "熟肉腿", "熟肉排", "生肉腿", "生肉排", "浆果", "胡萝卜"},
    Value = "胡萝卜", Multi = false,
    Callback = function(value)
        local GetFoodList = { ["蛋糕"] = "Cake", ["熟肉腿"] = "Cooked Steak", ["熟肉排"] = "Cooked Morsel", ["生肉腿"] = "Morsel", ["生肉排"] = "Steak", ["浆果"] = "Berry", ["胡萝卜"] = "Carrot" }
        Food = GetFoodList[value]
    end
})
TabHandles.Auto3:Input({ Title = "饥饿设置", Value = tostring(hungerThreshold), Placeholder = "75", Numeric = true, Callback = function(value) local n = tonumber(value); if n then hungerThreshold = math.clamp(n, 0, 100) end end })
local autoFeed
TabHandles.Auto3:Toggle({ Title = "自动进食", Value = false, Callback = function(state) autoFeed = state; if state then task.spawn(function() while autoFeed do task.wait(0.075); if wiki(Food) == 0 then autoFeed = false; notifeed(Food) break end; if ghn() <= hungerThreshold then feed(Food) end end end) end end })
TabHandles.Auto4:Section({ Title = "钓鱼", Icon = 'fish', ImageSize = 30, Opened = true })
TabHandles.Auto4:Toggle({ Title = "自动钓鱼", Value = false, Callback = function(value)
    if value then
        task.spawn(function()
            local playerGui = lp:WaitForChild("PlayerGui")
            task.wait(1)
            local fishingCatchFrame = playerGui.Interface.FishingCatchFrame
            local timingBar = fishingCatchFrame.TimingBar
            local successArea = timingBar.SuccessArea
            local bar = timingBar.Bar
            local button = playerGui.MobileButtons.Frame.Button3
            local canClick = true
            local function checkOverlap(f1, f2)
                local p1 = f1.AbsolutePosition; local s1 = f1.AbsoluteSize
                local p2 = f2.AbsolutePosition; local s2 = f2.AbsoluteSize
                return not (p1.X + s1.X < p2.X or p2.X + s2.X < p1.X or p1.Y + s1.Y < p2.Y or p2.Y + s2.Y < p1.Y)
            end
            local function clickButton() for _, connection in pairs(getconnections(button.MouseButton1Down)) do connection:Fire() end end
            while value do
                if fishingCatchFrame.Visible and timingBar.Visible then
                    if checkOverlap(successArea, bar) and canClick then
                        canClick = false; clickButton(); task.wait(0.1); canClick = true
                    end
                else canClick = true end
                task.wait()
            end
        end)
    end
end })
TabHandles.Auto4:Toggle({ Title = "无延迟钓鱼", Value = false, Callback = function(value)
    if value then
        task.spawn(function()
            local playerGui = lp:WaitForChild("PlayerGui")
            task.wait(1)
            local button = playerGui.MobileButtons.Frame.Button3
            local function clickButton() for _, connection in pairs(getconnections(button.MouseButton1Down)) do connection:Fire() end end
            while value do
                if playerGui.Interface.FishingCatchFrame.Visible then clickButton() end
                task.wait()
            end
        end)
    end
end })
TabHandles.Auto4:Toggle({ Title = "秒钓鱼", Value = false, Callback = function(value)
    if value then
        task.spawn(function()
            while value do
                pcall(function()
                    local remote = rs:FindFirstChild("RemoteEvents")
                    if remote then
                        local finishFishing = remote:FindFirstChild("FinishFishing")
                        if finishFishing then finishFishing:FireServer(true) end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end })
TabHandles.LostKid:Section({ Title = "收集孩子", Icon = 'baby', ImageSize = 30, Opened = true })
TabHandles.LostKid:Button({ Title = "一键将所有孩子放入袋子", Callback = function()
    local KidNum = 0
    for _, v in pairs(workspace.Characters:GetChildren()) do
        if string.find(v.Name, 'Child', 1, true) then
            for _, i in pairs(v:GetDescendants()) do
                if i:IsA('ProximityPrompt') then
                    local oldpos = hrp.CFrame
                    hrp.CFrame = v.HumanoidRootPart.CFrame
                    fireproximityprompt(i)
                    task.wait(0.1)
                    hrp.CFrame = oldpos
                    KidNum = KidNum + 1
                end
            end
        end
    end
    notify("收集孩子", "收集到: " .. KidNum .. '个孩子', 3, 'baby')
end })
local AutoGetKid = false
TabHandles.LostKid:Toggle({ Title = "收集孩子光环", Value = false, Callback = function(state) AutoGetKid = state; if state then task.spawn(function() while AutoGetKid do task.wait(0.1); for _, v in pairs(workspace.Characters:GetChildren()) do if string.find(v.Name, 'Child', 1, true) then for _, i in pairs(v:GetDescendants()) do if i:IsA('ProximityPrompt') then fireproximityprompt(i) end end end end end end) end end })
TabHandles.Tp2:Section({ Title = "传送", Icon = 'hand', ImageSize = 30, Opened = true })
TabHandles.Tp2:Button({ Title = "传送到篝火", Callback = function()
    local fireCenter = workspace.Map.Campground.MainFire:FindFirstChild("Center")
    if fireCenter then hrp.CFrame = fireCenter.CFrame + Vector3.new(0, 3, 0) else notify("提示", "未找到篝火", 2) end
end })
TabHandles.Tp2:Button({ Title = "传送到工作台", Callback = function()
    local scrapper = workspace.Map.Campground.Scrapper:FindFirstChild("Main")
    if scrapper then hrp.CFrame = scrapper.CFrame + Vector3.new(0, 3, 0) else notify("提示", "未找到工作台", 2) end
end })
TabHandles.Tp2:Section({ Title = "预警传送", Icon = 'hand', ImageSize = 30, Opened = true })
local Health = 75
local HealthTP = false
TabHandles.Tp2:Slider({ Title = "生命阈值", Step = 1, Value = { Min = 0, Max = 100, Default = 75 }, Callback = function(value) Health = tonumber(value) end })
TabHandles.Tp2:Toggle({ Title = "自动检测生命阈值传送", Value = false, Callback = function(state)
    HealthTP = state
    if state then
        task.spawn(function()
            local TPState = true
            while HealthTP do
                task.wait(0.1)
                if lp.Character:FindFirstChild('Humanoid').Health >= Health then return end
                if TPState then
                    hrp.CFrame = workspace.Map.Campground.MainFire:FindFirstChild("Center").CFrame + Vector3.new(0, 3, 0)
                    TPState = false
                end
            end
        end)
    end
end})
Window:OnClose(function()
    if game:GetService("UserInputService").KeyboardEnabled then
        WindUI:Notify({ Title = "通知", Content = "按下N键再次打开", Duration = 3 })
    end
end)
game.Players.PlayerAdded:Connect(function(Pl)
    table.insert(PlayerList, Pl.Name)
    SelectPlayer:Refresh(PlayerList)
end)