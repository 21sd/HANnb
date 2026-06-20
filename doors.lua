-- 加载 WindUI 库
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()

-- 创建主窗口
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
    Title = "doors",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "doors",
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

-- 为打开按钮添加旋转渐变动画
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

-- ========================================================
--  Doors 功能模块（完整集成）
-- ========================================================

--[[
    德与中山 - Doors 功能模块 (独立版)
    游戏: Doors
    功能: 透视物品、透视怪物、怪物检测、物品刷新提示、夜视等
]]

-- 请确保 WindUI 库已加载，此脚本依赖于 WindUI 框架

local function doors()
    -- Window:Divider()   -- 如需分隔线可取消注释（取决于WindUI版本）
    local a = Window:Tab({
        Title = "主要功能",
        Icon = "home",
        Desc = "Doors"
    })

    local b = Window:Tab({
        Title = "物品透视",
        Icon = "package-search",
        Desc = "Doors"
    })

    local c = Window:Tab({
        Title = "怪物透视",
        Icon = "skull-crossbones",
        Desc = "Doors"
    })

    local d = Window:Tab({
        Title = "怪物提示",
        Icon = "radar",
        Desc = "Doors"
    })


    local Lighting = game:GetService("Lighting")
    local espTasks = {}

    local function guanbi(itemName)
        for _, item in pairs(workspace:GetDescendants()) do
            if item.Name == itemName and item:IsA("Model") then
                local billboard = item:FindFirstChild("ItemMarker")
                local highlight = item:FindFirstChild("DoorHighlight")
                if billboard then 
                    billboard:Destroy() 
                end
                if highlight then 
                    highlight:Destroy() 
                end
            end
        end
    end

    local function hanshu(name, yanse, gaoliangyanse, zhongwm)
        for _, item in pairs(workspace:GetDescendants()) do
            if item.Name == name and item:IsA("Model") then
                if not item:FindFirstChild("ItemMarker") then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ItemMarker"
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Enabled = true

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = zhongwm
                    textLabel.TextColor3 = yanse
                    textLabel.TextScaled = true
                    textLabel.Parent = billboard
                    billboard.Parent = item
                end
                
                if not item:FindFirstChild("DoorHighlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "DoorHighlight"
                    highlight.Adornee = item
                    highlight.FillColor = gaoliangyanse
                    highlight.FillTransparency = 0.6
                    highlight.OutlineColor = gaoliangyanse
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = item
                end
            end
        end
    end

    local function createItemESP(itemName, color, highlightColor, displayName, toggleKey)
        return function(value)
            if value then
                guanbi(itemName)
                
                local taskRunning = true
                local taskId = tick()
                espTasks[toggleKey] = {id = taskId, running = taskRunning}
                
                task.spawn(function()
                    while taskRunning and espTasks[toggleKey] and espTasks[toggleKey].id == taskId do
                        hanshu(itemName, color, highlightColor, displayName)
                        task.wait(0.5)
                    end
                end)
            else
                if espTasks[toggleKey] then
                    espTasks[toggleKey].running = false
                    espTasks[toggleKey] = nil
                end
                
                guanbi(itemName)
            end
        end
    end

    a:Toggle({
        Title = "跳跃",
        Desc = "获得跳跃能力",
        Callback = function(value)
            local LocalPlayer = game.Players.LocalPlayer
            if LocalPlayer.Character then
                LocalPlayer.Character:SetAttribute("CanJump", value)
            end
            
            LocalPlayer.CharacterAdded:Connect(function(newCharacter)
                task.wait(1.5)
                newCharacter:SetAttribute("CanJump", value)
            end)
        end
    })

    a:Button({
        Title = "删除Seek触手",
        Desc = "删除游戏中Seek追逐战的触手",
        Callback = function()
            for _, a in pairs(workspace:GetDescendants()) do
                if a.Name == "Seek_Arm" then
                    a:Destroy()
                end
            end
        end
    })

    a:Button({
        Title = "Seek",
        Desc = "删除游戏中Seek",
        Callback = function()
            for _, a in pairs(workspace:GetDescendants()) do
                if a.Name == "SeekMoving" then
                    a:Destroy()
                end
            end
        end
    })

    b:Toggle({
        Title = "门",
        Desc = "透视门",
        Callback = createItemESP("Door", Color3.fromRGB(255, 165, 0), Color3.fromRGB(0, 255, 0), "门", "door")
    })

    b:Toggle({
        Title = "钥匙",
        Desc = "透视钥匙",
        Callback = createItemESP("KeyObtain", Color3.fromRGB(255, 165, 0), Color3.fromRGB(0, 255, 0), "钥匙", "key")
    })

    b:Toggle({
        Title = "十字架",
        Desc = "透视十字架",
        Callback = createItemESP("Crucifix", Color3.fromRGB(139, 69, 19), Color3.fromRGB(139, 69, 19), "十字架", "crucifix")
    })

    b:Toggle({
        Title = "手电筒",
        Desc = "透视手电筒",
        Callback = createItemESP("Flashlight", Color3.fromRGB(30, 144, 255), Color3.fromRGB(30, 144, 255), "手电筒", "flashlight")
    })

    b:Toggle({
        Title = "电池",
        Desc = "透视电池",
        Callback = createItemESP("Battery", Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 215, 0), "电池", "battery")
    })

    b:Toggle({
        Title = "蜡烛",
        Desc = "透视蜡烛",
        Callback = createItemESP("Candle", Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 165, 0), "蜡烛", "candle")
    })

    b:Toggle({
        Title = "打火机",
        Desc = "透视打火机",
        Callback = createItemESP("Lighter", Color3.fromRGB(255, 69, 0), Color3.fromRGB(255, 69, 0), "打火机", "lighter")
    })

    b:Toggle({
        Title = "绷带",
        Desc = "透视绷带",
        Callback = createItemESP("BandagePack", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), "绷带包", "bandage")
    })

    b:Toggle({
        Title = "金币",
        Desc = "透视金币",
        Callback = createItemESP("GoldPile", Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 215, 0), "金币", "gold")
    })

    a:Button({
        Title = "清理所有透视",
        Desc = "清除所有透视效果",
        Callback = function()
            for taskKey, taskInfo in pairs(espTasks) do
                taskInfo.running = false
            end
            espTasks = {}
            
            local items = {"Door", "KeyObtain", "Crucifix", "Flashlight", "Battery", "Candle", "Lighter", "BandagePack", "GoldPile"}
            for _, itemName in ipairs(items) do
                guanbi(itemName)
            end
        end
    })

    a:Button({
        Title = "夜视",
        Desc = "好清楚",
        Callback = function()
            Lighting.Brightness = 2
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            if Lighting:FindFirstChild("Atmosphere") then
                Lighting.Atmosphere:Destroy()
            end
        end
    })

    d:Toggle({
        Title = "rush",
        Desc = "rush检测",
        Callback = function(value)
            local a = value
            if value then
                while a do
                    for _, b in pairs(workspace:GetDescendants()) do
                        if b.Name == "RushMoving" and b:IsA("Model") then
                            WindUI:Notify({
                                Title = "怪物检测",
                                Content = "Rush来了快躲避",
                                Duration = 2
                            })
                        end
                    end
                    task.wait(0.5)
                end
            end
        end
    })

    d:Toggle({
        Title = "Eyes",
        Desc = "Eyes检测",
        Callback = function(value)
            local a = value
            if value then
                while a do
                    for _, b in pairs(workspace:GetDescendants()) do
                        if b.Name == "Eyes" and b:IsA("Model") then
                            WindUI:Notify({
                                Title = "怪物检测",
                                Content = "Eyes来了别看他",
                                Duration = 2
                            })
                        end
                    end
                    task.wait(0.5)
                end
            end
        end
    })

    d:Toggle({
        Title = "Ambush",
        Desc = "Ambush检测",
        Callback = function(value)
            local a = value
            if value then
                while a do
                    for _, b in pairs(workspace:GetDescendants()) do
                        if b.Name == "AmbushMoving" and b:IsA("Model") then
                            WindUI:Notify({
                                Title = "怪物检测",
                                Content = "AmbushMoving来了快躲避",
                                Duration = 2
                            })
                        end
                    end
                    task.wait(0.5)
                end
            end
        end
    })

    d:Toggle({
        Title = "A60",
        Desc = "A60检测",
        Callback = function(value)
            local a = value
            if value then
                while a do
                    for _, b in pairs(workspace:GetDescendants()) do
                        if b.Name == "A60" and b:IsA("Model") then
                            WindUI:Notify({
                                Title = "怪物检测",
                                Content = "A60来了快躲避",
                                Duration = 2
                            })
                        end
                    end
                    task.wait(0.5)
                end
            end
        end
    })

    d:Toggle({
        Title = "A120",
        Desc = "120检测",
        Callback = function(value)
            local a = value
            if value then
                while a do
                    for _, b in pairs(workspace:GetDescendants()) do
                        if b.Name == "A120" and b:IsA("Model") then
                            WindUI:Notify({
                                Title = "怪物检测",
                                Content = "A120来了快躲避",
                                Duration = 2
                            })
                        end
                    end
                    task.wait(0.5)
                end
            end
        end
    })

    d:Toggle({
        Title = "Screech",
        Desc = "Screech",
        Callback = function(value)
            local a = value
            if value then
                while a do
                    for _, b in pairs(workspace:GetDescendants()) do
                        if b.Name == "Screech" and b:IsA("Model") then
                            WindUI:Notify({
                                Title = "怪物检测",
                                Content = "Screech来了快看看他",
                                Duration = 2
                            })
                        end
                    end
                    task.wait(0.5)
                end
            end
        end
    })

    a:Toggle({
        Title = "Seek",
        Desc = "Seek检测",
        Callback = function(value)
            local a = value
            if value then
                while a do
                    for _, b in pairs(workspace:GetDescendants()) do
                        if b.Name == "SeekMoving" and b:IsA("Model") then
                            WindUI:Notify({
                                Title = "怪物检测",
                                Content = "seek来了快跑",
                                Duration = 2
                            })
                        end
                    end
                    task.wait(0.5)
                end
            end
        end
    })

    c:Toggle({
        Title = "rush",
        Desc = "透视rush",
        Callback = createItemESP("RushMoving", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), "rush", "rush")
    })

    c:Toggle({
        Title = "Ambush",
        Desc = "透视Ambush",
        Callback = createItemESP("AmbushMoving", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), "Ambush", "ambush")
    })

    c:Toggle({
        Title = "A60",
        Desc = "透视A60",
        Callback = createItemESP("A60", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), "A60", "a60")
    })

    c:Toggle({
        Title = "A120",
        Desc = "透视A120",
        Callback = createItemESP("A120", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), "A120", "a120")
    })

    c:Toggle({
        Title = "FigureRig",
        Desc = "透视FigureRig",
        Callback = createItemESP("FigureRig", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), "FigureRig", "figurerig")
    })
end

-- 执行 Doors 功能加载
doors()