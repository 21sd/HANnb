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
    Title = "在末日中存活下来",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "在末日中存活下来",
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

-- ==================== 传送物品功能 ====================
local bringTab = Window:Tab({
    Title = "主要功能",
    Icon = "package",
})

local bringEnabled = false
local bringConnection = nil

bringTab:Toggle({
    Title = "启用传送物品",
    Default = false,
    Callback = function(Value)
        bringEnabled = Value
        if bringEnabled then
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, item in pairs(workspace.DroppedItems:GetChildren()) do
                    if item:IsA("BasePart") then
                        item.CFrame = root.CFrame * CFrame.new(math.random(-3, 3), 0, math.random(-3, 3))
                    elseif item:IsA("Model") then
                        local main = item:FindFirstChildWhichIsA("BasePart")
                        if main then
                            main.CFrame = root.CFrame * CFrame.new(math.random(-3, 3), 0, math.random(-3, 3))
                        end
                    end
                end
            end
            WindUI:Notify({
                Title = "传送物品",
                Content = "已将所有物品传送到身边",
                Duration = 2,
                Icon = "check"
            })
        end
    end
})

-- ==================== 透视物品功能 ====================
local espTab = Window:Tab({
    Title = "透视物品",
    Icon = "eye",
})

local espEnabled = false
local espObjects = {}

local nameTranslations = {
    ["Bloxiade"] = "布洛西亚德",
    ["Can"] = "罐子",
    ["Chips"] = "薯片",
    ["Mesh"] = "网格",
    ["Beans"] = "豆子",
    ["Fuel"] = "燃料",
    ["Handle"] = "把手",
    ["Lid"] = "盖子",
    ["Body"] = "主体",
    ["Label"] = "标签",
    ["Box"] = "盒子",
    ["Bag"] = "袋子",
    ["Bottle"] = "瓶子",
    ["Wrapper"] = "包装纸",
    ["Cap"] = "瓶盖",
    ["Top"] = "顶部",
    ["Bottom"] = "底部",
    ["Part"] = "零件",
    ["Union"] = "联合体",
    ["Cylinder"] = "圆柱体",
    ["Block"] = "方块",
    ["Sphere"] = "球体",
    ["Wedge"] = "楔形",
    ["CornerWedge"] = "角楔",
    ["Truss"] = "桁架",
    ["Seat"] = "座椅",
    ["Spawn"] = "出生点",
    ["Base"] = "底座",
    ["Plate"] = "板",
    ["Door"] = "门",
    ["Window"] = "窗户",
    ["Wheel"] = "轮子",
    ["Engine"] = "引擎",
    ["Tank"] = "油箱",
    ["Pipe"] = "管道",
    ["Valve"] = "阀门",
    ["Switch"] = "开关",
    ["Button"] = "按钮",
    ["Lever"] = "拉杆",
    ["Panel"] = "面板",
    ["Frame"] = "框架",
    ["Glass"] = "玻璃",
    ["Light"] = "灯",
    ["Screen"] = "屏幕",
    ["Wire"] = "电线",
    ["Gear"] = "齿轮",
    ["Spring"] = "弹簧",
    ["Axle"] = "轴",
    ["Clamp"] = "夹子",
    ["Tray"] = "托盘",
    ["Basket"] = "篮子",
    ["Crate"] = "板条箱",
    ["Pallet"] = "货板",
    ["Rack"] = "货架",
    ["Sign"] = "标牌",
}

local function translate(name)
    return nameTranslations[name] or name
end

local function collectAllDescendants(parent, list)
    for _, child in ipairs(parent:GetChildren()) do
        table.insert(list, child)
        collectAllDescendants(child, list)
    end
end

local function clearESP()
    for _, obj in ipairs(espObjects) do
        if obj then
            pcall(function()
                obj:Destroy()
            end)
        end
    end
    espObjects = {}
end

local function createESP()
    clearESP()
    local targets = {}
    collectAllDescendants(workspace.DroppedItems, targets)

    for _, SL in ipairs(targets) do
        if SL:IsA("BasePart") then
            local h = Instance.new("Highlight")
            h.FillColor = Color3.new(1, 0, 0)
            h.FillTransparency = 0
            h.OutlineColor = Color3.new(1, 1, 1)
            h.OutlineTransparency = 0
            h.Parent = SL
            table.insert(espObjects, h)

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "NameTag"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = SL
            table.insert(espObjects, billboard)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = translate(SL.Name)
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.Font = Enum.Font.SourceSansBold
            label.TextSize = 14
            label.Parent = billboard
            table.insert(espObjects, label)
        end
    end
end

espTab:Toggle({
    Title = "启用透视物品",
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            createESP()
            WindUI:Notify({
                Title = "透视物品",
                Content = "已开启物品透视",
                Duration = 2,
                Icon = "eye"
            })
        else
            clearESP()
            WindUI:Notify({
                Title = "透视物品",
                Content = "已关闭物品透视",
                Duration = 2,
                Icon = "eye-off"
            })
        end
    end
})

-- 监听新物品生成，自动添加ESP
workspace.DroppedItems.ChildAdded:Connect(function(child)
    if espEnabled then
        task.wait(0.5)
        local targets = {}
        collectAllDescendants(workspace.DroppedItems, targets)
        clearESP()
        createESP()
    end
end)
