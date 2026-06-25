local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()

function createUI()
    local Window = WindUI:CreateWindow({
        Title = "寒付费",
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
        Title = "启示录",
        Icon = "crown",
        IconColor = Color3.fromHex("#FF1493"),
        Color = Color3.fromHex("#1C1C1C"),
        Border = true,
        BorderColor = Color3.fromHex("#FF1493"),
        IconShape = "Square"
    })

    Window:EditOpenButton({
        Title = "启示录",
        Icon = "crown",
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


    local Auto = Window:Tab({Title = "自动功能", Icon = "ghost"})
    local Aura = Window:Tab({Title = "光环功能", Icon = "palette"})
    local Teleport = Window:Tab({Title = "传送功能", Icon = "map-pin"})
    local Other = Window:Tab({Title = "其他功能", Icon = "settings"})

    Auto:Paragraph({
        Title = "自动功能",
        Image = "ghost",
        ImageSize = 20,
        Color = "White",
    })


    local autoTree = false
    Auto:Toggle({
        Title = "自动砍树",
        Desc = "需你拿着对应工具",
        Icon = "check",
        Value = false,
        Callback = function(Value)
            autoTree = Value
            while autoTree do
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local networkItems = ReplicatedStorage:WaitForChild("Network"):WaitForChild("Items")
                local toolAction = networkItems:WaitForChild("ToolAction")
                local spawnArea = workspace:WaitForChild("Spawned")
                local trees = {"Tree1", "Tree2", "Tree3", "Tree4", "Tree5"}

                for _, treeName in ipairs(trees) do
                    local tree = spawnArea:FindFirstChild(treeName)
                    if tree then
                        toolAction:FireServer("click", tree, false)
                    end
                end
                wait(0.1)
            end
        end
    })

    local autoStone = false
    Auto:Toggle({
        Title = "自动挖石",
        Desc = "需你拿着对应工具",
        Icon = "check",
        Value = false,
        Callback = function(Value)
            autoStone = Value
            while autoStone do
                local replicatedStorage = game:GetService("ReplicatedStorage")
                local networkItems = replicatedStorage:WaitForChild("Network"):WaitForChild("Items")
                local toolActionEvent = networkItems:WaitForChild("ToolAction")
                local targetObject = workspace:WaitForChild("Spawned"):WaitForChild("Stone")

                if targetObject then
                    toolActionEvent:FireServer("click", targetObject, false)
                end
                wait(0.1)
            end
        end
    })

    local autoCoal = false
    Auto:Toggle({
        Title = "自动挖煤",
        Desc = "需你拿着对应工具",
        Icon = "check",
        Value = false,
        Callback = function(Value)
            autoCoal = Value
            while autoCoal do
                local replicatedStorage = game:GetService("ReplicatedStorage")
                local networkItems = replicatedStorage:WaitForChild("Network"):WaitForChild("Items")
                local toolActionEvent = networkItems:WaitForChild("ToolAction")
                local targetObject = workspace:WaitForChild("Spawned"):WaitForChild("Coal")

                if targetObject then
                    toolActionEvent:FireServer("click", targetObject, false)
                end
                wait(0.1)
            end
        end
    })

    local autoIron = false
    Auto:Toggle({
        Title = "自动挖铁",
        Desc = "需你拿着对应工具",
        Icon = "check",
        Value = false,
        Callback = function(Value)
            autoIron = Value
            while autoIron do
                local replicatedStorage = game:GetService("ReplicatedStorage")
                local network = replicatedStorage:WaitForChild("Network")
                local items = network:WaitForChild("Items")
                local toolAction = items:WaitForChild("ToolAction")
                local ironOre = workspace:WaitForChild("Spawned"):WaitForChild("IronOre")

                if ironOre then
                    toolAction:FireServer("click", ironOre, false)
                end
                wait(0.1)
            end
        end
    })

    local autoCopper = false
    Auto:Toggle({
        Title = "自动挖铜",
        Desc = "需你拿着对应工具",
        Icon = "check",
        Value = false,
        Callback = function(Value)
            autoCopper = Value
            while autoCopper do
                local replicatedStorage = game:GetService("ReplicatedStorage")
                local networkItems = replicatedStorage:WaitForChild("Network"):WaitForChild("Items")
                local toolAction = networkItems:WaitForChild("ToolAction")
                local copperOre = workspace:WaitForChild("Spawned"):WaitForChild("CopperOre")

                if copperOre then
                    toolAction:FireServer("click", copperOre, false)
                end
                wait(0.1)
            end
        end
    })


    local auraEnabled = false
    local treeRange = 10
    local stoneRange = 10
    local coalRange = 10
    local ironRange = 10
    local copperRange = 10

    Aura:Toggle({
        Title = "启用光环范围",
        Desc = "需你拿着对应工具",
        Icon = "check",
        Value = false,
        Callback = function(Value)
            auraEnabled = Value
        end
    })

    Aura:Input({
        Title = "砍树范围",
        Default = "10",
        Numeric = true,
        Callback = function(value)
            treeRange = tonumber(value)
        end
    })

    Aura:Input({
        Title = "挖石范围",
        Default = "10",
        Numeric = true,
        Callback = function(value)
            stoneRange = tonumber(value)
        end
    })

    Aura:Input({
        Title = "挖煤范围",
        Default = "10",
        Numeric = true,
        Callback = function(value)
            coalRange = tonumber(value)
        end
    })

    Aura:Input({
        Title = "挖铁范围",
        Default = "10",
        Numeric = true,
        Callback = function(value)
            ironRange = tonumber(value)
        end
    })

    Aura:Input({
        Title = "挖铜范围",
        Default = "10",
        Numeric = true,
        Callback = function(value)
            copperRange = tonumber(value)
        end
    })

    -- 传送功能
    local function TeleportToThing(thing)
        local LP = game.Players.LocalPlayer
        local character = LP.Character or LP.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == thing then
                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    humanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 2, 0)
                    return true
                end
            end
        end
        return false
    end

    Teleport:Button({
        Title = "传送_普通箱子",
        Icon = "bell",
        Callback = function()
            TeleportToThing("CommonLoot")
        end
    })

    Teleport:Button({
        Title = "传送_稀有箱子",
        Icon = "bell",
        Callback = function()
            TeleportToThing("UncommonLoot")
        end
    })

    Teleport:Button({
        Title = "传送_传奇箱子",
        Icon = "bell",
        Callback = function()
            TeleportToThing("RareLoot")
        end
    })


    local infiniteStamina = false
    Other:Toggle({
        Title = "玩家无限体力",
        Icon = "check",
        Value = false,
        Callback = function(Value)
            infiniteStamina = Value
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local dataFolder = player:WaitForChild("Data")
            local staminaFolder = dataFolder:WaitForChild("Stamina")

            if infiniteStamina then
                staminaFolder.Name = "_Stamina"
            else
                staminaFolder.Name = "Stamina"
            end
        end
    })

    local fastRescue = false
    local connection = nil
    Other:Toggle({
        Title = "秒救人",
        Icon = "check",
        Value = false,
        Callback = function(Value)
            fastRescue = Value
            if fastRescue then
                if connection then connection:Disconnect() end
                connection = game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
                    prompt.HoldDuration = 0
                end)
            else
                if connection then 
                    connection:Disconnect()
                    connection = nil
                end
            end
        end
    })

 
    getgenv().TpwalkSpeed = 10
    getgenv().TpwalkEnabled = false

    Other:Toggle({
        Title = "加速移动",
        Description = "按住移动键快速冲刺",
        Default = false,
        Callback = function(state)
            getgenv().TpwalkEnabled = state
        end
    })

    Other:Input({
        Title = "移动速度",
        Default = tostring(getgenv().TpwalkSpeed),
        Numeric = true,
        Callback = function(value)
            local num = tonumber(value)
            if num then getgenv().TpwalkSpeed = num end
        end
    })

    game:GetService("RunService").Heartbeat:Connect(function(delta)
        if getgenv().TpwalkEnabled and game.Players.LocalPlayer.Character then
            local char = game.Players.LocalPlayer.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")

            if hrp and hum then
                local dir = hum.MoveDirection
                if dir.Magnitude > 0 then
                    local newPos = hrp.Position + dir.Unit * getgenv().TpwalkSpeed * delta
                    hrp.CFrame = CFrame.new(newPos, newPos + hrp.CFrame.LookVector)
                end
            end
        end
    end)

    -- 全亮夜视
    getgenv().FullBright_Enabled = false
    getgenv().FullBright_Original = {}

    local Lighting = game:GetService("Lighting")

    if not getgenv().FullBright_Original.Sky then
        local sky = Lighting:FindFirstChildOfClass("Sky")
        getgenv().FullBright_Original.Sky = sky and sky:Clone() or nil
    end
    if not getgenv().FullBright_Original.Ambient then
        getgenv().FullBright_Original.Ambient = Lighting.Ambient
    end
    if not getgenv().FullBright_Original.OutdoorAmbient then
        getgenv().FullBright_Original.OutdoorAmbient = Lighting.OutdoorAmbient
    end
    if not getgenv().FullBright_Original.Brightness then
        getgenv().FullBright_Original.Brightness = Lighting.Brightness
    end
    if not getgenv().FullBright_Original.ClockTime then
        getgenv().FullBright_Original.ClockTime = Lighting.ClockTime
    end

    local function applyFullBright()
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.ClockTime = 14

        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Sky") then obj:Destroy() end
        end
    end

    local function restoreLighting()
        Lighting.Brightness = getgenv().FullBright_Original.Brightness
        Lighting.Ambient = getgenv().FullBright_Original.Ambient
        Lighting.OutdoorAmbient = getgenv().FullBright_Original.OutdoorAmbient
        Lighting.ClockTime = getgenv().FullBright_Original.ClockTime

        if getgenv().FullBright_Original.Sky and not Lighting:FindFirstChildOfClass("Sky") then
            getgenv().FullBright_Original.Sky:Clone().Parent = Lighting
        end
    end

    game:GetService("RunService").RenderStepped:Connect(function()
        if getgenv().FullBright_Enabled then applyFullBright() end
    end)

    game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
        if getgenv().FullBright_Enabled then
            task.wait(0.5)
            applyFullBright()
        end
    end)

    Other:Toggle({
        Title = "屏幕光亮夜视",
        Description = "使游戏场景变亮",
        Default = false,
        Callback = function(state)
            getgenv().FullBright_Enabled = state
            if not state then restoreLighting() else applyFullBright() end
        end
    })

createUI()
