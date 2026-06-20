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
    Title = "Chain",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "Chain",
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

-- ===== Chain功能模块 =====
local chainFeaturesLoaded = false

local function loadChainFeatures()
    if chainFeaturesLoaded then
        WindUI:Notify({
            Title = "提示",
            Content = "Chain功能已加载，请勿重复点击",
            Duration = 3,
            Icon = "info"
        })
        return
    end
    chainFeaturesLoaded = true

    local ChainTab = Window:Tab({
        Title = "Chain功能",
        Icon = "zap",
        Locked = false,
    })

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer

    local BypassChainAC = false
    local infiniteStaminaEnabled = false
    local staminaConnection = nil
    local infiniteCombatStaminaEnabled = false
    local combatStaminaConnection = nil
    local WalkSpeed_Enabled = false
    local WalkSpeed_Value = 16
    local WalkSpeed_Connection = nil
    local Noclip_Enabled = false
    local Noclip_Connection = nil
    local NightVision_Enabled = false
    local MonsterESP_Enabled = false
    local MonsterESP_Highlights = {}
    local ScrapESPEnabled = false
    local ScrapESPConnection = nil
    local ActiveScrapHighlights = {}
    local selectedLocation = nil
    local infiniteXSawGasEnabled = false
    local infiniteXSawGasConnection = nil
    local autoXSawClashEnabled = false
    local autoXSawClashConnection = nil

    -- 辅助函数（体力、汽油、动画等）
    local function setupStaminaInfinite(character)
        if character and infiniteStaminaEnabled then
            local stats = character:FindFirstChild("Stats") or character:WaitForChild("Stats", 5)
            if stats then
                local stamina = stats:FindFirstChild("Stamina") or stats:WaitForChild("Stamina", 5)
                if stamina then
                    if staminaConnection then staminaConnection:Disconnect() end
                    staminaConnection = stamina.Changed:Connect(function()
                        if infiniteStaminaEnabled and stamina.Value ~= 100 then
                            stamina.Value = 100
                        end
                    end)
                    stamina.Value = 100
                end
            end
        end
    end

    local function setupCombatStaminaInfinite(character)
        if character and infiniteCombatStaminaEnabled then
            local stats = character:FindFirstChild("Stats") or character:WaitForChild("Stats", 5)
            if stats then
                local combatStamina = stats:FindFirstChild("CombatStamina") or stats:WaitForChild("CombatStamina", 5)
                if combatStamina then
                    if combatStaminaConnection then combatStaminaConnection:Disconnect() end
                    combatStaminaConnection = combatStamina.Changed:Connect(function()
                        if infiniteCombatStaminaEnabled and combatStamina.Value ~= 100 then
                            combatStamina.Value = 100
                        end
                    end)
                    combatStamina.Value = 100
                end
            end
        end
    end

    local function setupInfiniteXSawGas(character)
        if character and infiniteXSawGasEnabled then
            local items = character:FindFirstChild("Items") or character:WaitForChild("Items", 5)
            if items then
                local xSaw = items:FindFirstChild("XSaw") or items:WaitForChild("XSaw", 5)
                if xSaw then
                    if infiniteXSawGasConnection then infiniteXSawGasConnection:Disconnect() end
                    infiniteXSawGasConnection = RunService.Heartbeat:Connect(function()
                        if infiniteXSawGasEnabled then
                            xSaw:SetAttribute("Gas", 100)
                        end
                    end)
                    xSaw:SetAttribute("Gas", 100)
                end
            end
        end
    end

    local function setupAutoXSawClash(character)
        if character and autoXSawClashEnabled then
            local stats = character:FindFirstChild("Stats") or character:WaitForChild("Stats", 5)
            if stats then
                local clashStrength = stats:FindFirstChild("ClashStrength") or stats:WaitForChild("ClashStrength", 5)
                if clashStrength then
                    if autoXSawClashConnection then autoXSawClashConnection:Disconnect() end
                    autoXSawClashConnection = RunService.Heartbeat:Connect(function()
                        if autoXSawClashEnabled then
                            clashStrength.Value = 100
                        end
                    end)
                    clashStrength.Value = 100
                end
            end
        end
    end

    local function UnlockBlueprint(blueprintName)
        local Blueprints = LocalPlayer:WaitForChild('PlayerStats', 5):WaitForChild('Blueprints', 5)
        if Blueprints then
            if Blueprints:GetAttribute(blueprintName) ~= nil then
                Blueprints:SetAttribute(blueprintName, true)
                WindUI:Notify({Title = "✅解锁成功", Content = "已解锁"..blueprintName, Duration = 1.5})
            else
                WindUI:Notify({Title = "❌解锁失败", Content = "未找到"..blueprintName.."蓝图", Duration = 1.5})
            end
        else
            WindUI:Notify({Title = "❌解锁失败", Content = "未找到蓝图", Duration = 1.5})
        end
    end

    local function UpdateMoveSpeed()
        local player = Players.LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = WalkSpeed_Value
            end
        end
    end

    local function SetMoveSpeed(state)
        WalkSpeed_Enabled = state
        if state then
            UpdateMoveSpeed()
            if not WalkSpeed_Connection then
                WalkSpeed_Connection = RunService.Heartbeat:Connect(function()
                    if WalkSpeed_Enabled then UpdateMoveSpeed() end
                end)
            end
            Players.LocalPlayer.CharacterAdded:Connect(function()
                task.wait(1)
                UpdateMoveSpeed()
            end)
        else
            local player = Players.LocalPlayer
            if player and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.WalkSpeed = 16 end
            end
            if WalkSpeed_Connection then
                WalkSpeed_Connection:Disconnect()
                WalkSpeed_Connection = nil
            end
        end
    end

    local function SetNoclip(state)
        Noclip_Enabled = state
        if state then
            if not Noclip_Connection then
                Noclip_Connection = RunService.Stepped:Connect(function()
                    local player = Players.LocalPlayer
                    if player and player.Character then
                        for _, part in ipairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end
        else
            if Noclip_Connection then
                Noclip_Connection:Disconnect()
                Noclip_Connection = nil
            end
        end
    end

    local function SetNightVision(state)
        NightVision_Enabled = state
        if state then
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.FogEnd = 10000
            Lighting.GlobalShadows = false
            Lighting.ExposureCompensation = 1
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 14
            Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
            Lighting.FogEnd = 1000
            Lighting.GlobalShadows = true
            Lighting.ExposureCompensation = 0
        end
    end

    -- 链条透视
    local function AddMonsterESP(monster)
        if not monster or MonsterESP_Highlights[monster] then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "MonsterESP"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = monster
        local head = monster:FindFirstChild("Head")
        if head then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "MonsterInfo"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = head
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 1
            frame.Parent = billboard
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0, 20)
            nameLabel.Text = monster.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            nameLabel.TextScaled = true
            nameLabel.BackgroundTransparency = 1
            nameLabel.Parent = frame
            local healthLabel = Instance.new("TextLabel")
            healthLabel.Size = UDim2.new(1, 0, 0, 20)
            healthLabel.Position = UDim2.new(0, 0, 0, 20)
            healthLabel.Text = "HP: 100"
            healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            healthLabel.TextScaled = true
            healthLabel.BackgroundTransparency = 1
            healthLabel.Parent = frame
        end
        MonsterESP_Highlights[monster] = {highlight = highlight}
    end

    local function RemoveMonsterESP(monster)
        if MonsterESP_Highlights[monster] then
            if MonsterESP_Highlights[monster].highlight and MonsterESP_Highlights[monster].highlight.Parent then
                MonsterESP_Highlights[monster].highlight:Destroy()
            end
            local head = monster:FindFirstChild("Head")
            if head then
                local billboard = head:FindFirstChild("MonsterInfo")
                if billboard then billboard:Destroy() end
            end
            MonsterESP_Highlights[monster] = nil
        end
    end

    local function UpdateMonsterESP()
        for monster, data in pairs(MonsterESP_Highlights) do
            if not monster.Parent then RemoveMonsterESP(monster) end
        end
        local aiFolder = Workspace:FindFirstChild("Misc")
        if aiFolder then
            aiFolder = aiFolder:FindFirstChild("AI")
            if aiFolder then
                for _, monster in ipairs(aiFolder:GetChildren()) do
                    if monster:IsA("Model") and (monster.Name == "CHAIN" or monster.Name == "Entity" or monster.Name == "Monster") then
                        if MonsterESP_Enabled then AddMonsterESP(monster) end
                    end
                end
            end
        end
    end

    local function SetMonsterESP(state)
        MonsterESP_Enabled = state
        if state then
            WindUI:Notify({Title = "✅透视开启", Content = "链条透视已启用", Duration = 1})
            RunService.Heartbeat:Connect(function() UpdateMonsterESP() end)
        else
            WindUI:Notify({Title = "❌透视关闭", Content = "链条透视已禁用", Duration = 1})
            for monster, _ in pairs(MonsterESP_Highlights) do RemoveMonsterESP(monster) end
        end
    end

    -- 废料透视
    local function FindScrapContainer()
        local primaryPath = Workspace:FindFirstChild("Misc") and Workspace.Misc:FindFirstChild("Zones") and Workspace.Misc.Zones:FindFirstChild("LootingItems") and Workspace.Misc.Zones.LootingItems:FindFirstChild("Scrap")
        if primaryPath then return primaryPath end
        for _, child in ipairs(Workspace:GetChildren()) do
            if child.Name == "Scrap" and child:IsA("Folder") then return child end
        end
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            if descendant.Name:lower():find("scrap") and descendant:IsA("Model") then
                return descendant.Parent
            end
        end
        return nil
    end

    local function AddESPToScrap(scrapModel)
        if not scrapModel or ActiveScrapHighlights[scrapModel] or not scrapModel:IsA("Model") then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "ScrapESP_Highlight"
        highlight.FillColor = Color3.fromRGB(46, 204, 113)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0.2
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = scrapModel
        local attachPart = scrapModel.PrimaryPart or scrapModel:FindFirstChild("HumanoidRootPart") or scrapModel:FindFirstChild("Head") or scrapModel:FindFirstChildWhichIsA("BasePart")
        if attachPart then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ScrapESP_Billboard"
            billboard.Size = UDim2.new(0, 200, 0, 60)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.MaxDistance = 1e30
            billboard.Parent = attachPart
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "废料\n距离: 计算中..."
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            textLabel.TextStrokeTransparency = 0.3
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 14
            textLabel.TextYAlignment = Enum.TextYAlignment.Center
            textLabel.TextXAlignment = Enum.TextXAlignment.Center
            textLabel.RichText = true
            textLabel.ZIndex = 10
            textLabel.Parent = billboard
            ActiveScrapHighlights[scrapModel] = {
                Highlight = highlight,
                Billboard = billboard,
                TextLabel = textLabel,
                AttachPart = attachPart
            }
        else
            highlight.FillTransparency = 0.7
            ActiveScrapHighlights[scrapModel] = {
                Highlight = highlight,
                Billboard = nil,
                TextLabel = nil,
                AttachPart = nil
            }
        end
    end

    local function CleanupRemovedScrap()
        for scrapModel, data in pairs(ActiveScrapHighlights) do
            if not scrapModel.Parent then
                if data.Highlight then data.Highlight:Destroy() end
                if data.Billboard then data.Billboard:Destroy() end
                ActiveScrapHighlights[scrapModel] = nil
            end
        end
    end

    local function UpdateAllScrapInfo()
        local player = Players.LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        local maxDisplayDistance = 999999
        for scrapModel, data in pairs(ActiveScrapHighlights) do
            if scrapModel.Parent and data.AttachPart then
                local distance = (rootPart.Position - data.AttachPart.Position).Magnitude
                if distance > maxDisplayDistance then
                    if data.Highlight then data.Highlight.Enabled = false end
                    if data.Billboard then data.Billboard.Enabled = false end
                else
                    if data.Highlight then data.Highlight.Enabled = true end
                    if data.Billboard then data.Billboard.Enabled = true end
                    local statusText = "状态: 未知"
                    local statusColor = Color3.fromRGB(255, 255, 255)
                    local isAvailable = nil
                    local values = scrapModel:FindFirstChild("Values")
                    if values then isAvailable = values:GetAttribute("Available") end
                    if isAvailable == nil then isAvailable = scrapModel:GetAttribute("Available") end
                    if isAvailable == nil then
                        local prompt = scrapModel:FindFirstChild("ProximityPrompt")
                        if prompt and prompt:IsA("ProximityPrompt") then isAvailable = prompt.Enabled end
                    end
                    if isAvailable == true then
                        statusText = "状态: ✓ 可拾取"
                        statusColor = Color3.fromRGB(46, 204, 113)
                        if data.Highlight then data.Highlight.FillColor = Color3.fromRGB(46, 204, 113) end
                    elseif isAvailable == false then
                        statusText = "状态: ✗ 已拾取"
                        statusColor = Color3.fromRGB(231, 76, 60)
                        if data.Highlight then data.Highlight.FillColor = Color3.fromRGB(231, 76, 60) end
                    else
                        if data.Highlight then data.Highlight.FillColor = Color3.fromRGB(155, 89, 182) end
                    end
                    if data.TextLabel then
                        data.TextLabel.Text = string.format("废料\n距离: %d 米\n%s", math.floor(distance), statusText)
                        data.TextLabel.TextColor3 = statusColor
                    end
                    if data.Highlight then data.Highlight.FillTransparency = 0.5 end
                end
            end
        end
    end

    local function MainScrapScanLoop()
        if not ScrapESPEnabled then return end
        CleanupRemovedScrap()
        local scrapContainer = FindScrapContainer()
        if scrapContainer then
            for _, child in ipairs(scrapContainer:GetChildren()) do
                if child:IsA("Model") then AddESPToScrap(child) end
            end
            UpdateAllScrapInfo()
        end
    end

    local function SetScrapESP(state)
        ScrapESPEnabled = state
        if state then
            WindUI:Notify({Title = "✅ 废料透视已启用", Content = "正在扫描并显示废料位置...", Duration = 2})
            if ScrapESPConnection then ScrapESPConnection:Disconnect() end
            for scrapModel, data in pairs(ActiveScrapHighlights) do
                if data.Highlight then data.Highlight:Destroy() end
                if data.Billboard then data.Billboard:Destroy() end
            end
            ActiveScrapHighlights = {}
            ScrapESPConnection = RunService.RenderStepped:Connect(function()
                MainScrapScanLoop()
            end)
        else
            WindUI:Notify({Title = "❌ 废料透视已禁用", Content = "已移除所有废料高亮标记", Duration = 2})
            if ScrapESPConnection then
                ScrapESPConnection:Disconnect()
                ScrapESPConnection = nil
            end
            for scrapModel, data in pairs(ActiveScrapHighlights) do
                if data.Highlight then data.Highlight:Destroy() end
                if data.Billboard then data.Billboard:Destroy() end
            end
            ActiveScrapHighlights = {}
        end
    end

    -- 传送
    local function TeleportToLocation(locationName)
        local player = Players.LocalPlayer
        local character = player.Character
        if not character then
            WindUI:Notify({Title = "传送失败", Content = "角色不存在", Duration = 2})
            return
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            WindUI:Notify({Title = "传送失败", Content = "未找到HumanoidRootPart", Duration = 2})
            return
        end
        local locations = {
            ["房屋"] = CFrame.new(164.408112, -93.5687103, 228.658173, 0.99991262, 0.000353183481, -0.0132142855, 8.33566993e-9, 0.999642968, 0.0267184861, 0.0132190045, -0.0267161522, 0.999555647),
            ["商店"] = CFrame.new(-113.171844, -85.9600906, 209.123428, -0.00369261508, -0.12829496, -0.9917292, -7.23150917e-9, 0.999735935, -0.128295839, 0.999993205, -0.000473739958, -0.00366209983),
            ["仓库"] = CFrame.new(315.716339, -112.372467, -258.560028, -0.999726713, 0.0000574405785, 0.0233771317, 8.75708484e-9, 0.99999696, -0.0024567449, -0.0233772025, -0.00245607318, -0.999723673),
            ["工作房"] = CFrame.new(171.005341, -101.835281, -30.2862396, 0.258823305, -0.00847451296, -0.965887487, -1.02627325e-6, 0.999961495, -0.0087737469, 0.96592468, 0.00227184128, 0.258813351),
            ["电台"] = CFrame.new(-381.520599, -113.735931, 42.9471855, -0.0306593683, -0.0237039384, -0.999248803, 2.74181366e-6, 0.999718785, -0.0237151701, 0.999529898, -0.000729829073, -0.030650679),
            ["电力站"] = CFrame.new(-207.976364, -109.483444, -86.5617981, 0.999895096, -0.000663155632, 0.014468275, 3.69048212e-6, 0.99896282, 0.045532573, -0.014483464, -0.0455277413, 0.998858094),
            ["仪式"] = CFrame.new(-25.7088108, -106.319954, -199.117996, 0.970376134, -0.00883071404, -0.241437614, 0.0000357253812, 0.999337018, -0.0364077166, 0.241599053, 0.0353205539, 0.969733119),
            ["无敌点位"] = CFrame.new(192.54263305664062, -118.93388366699219, -32.854862213134766)
        }
        local targetCFrame = locations[locationName]
        if targetCFrame then
            humanoidRootPart.CFrame = targetCFrame
            WindUI:Notify({Title = "传送成功", Content = "已传送到: " .. locationName, Duration = 3})
        else
            WindUI:Notify({Title = "传送失败", Content = "未知的传送位置", Duration = 2})
        end
    end

    -- ---------- 界面构建 ----------
    ChainTab:Section({Title = "反作弊", Icon = "shield"})
    ChainTab:Toggle({
        Title = "绕过CHAIN反作弊",
        Default = false,
        Callback = function(state)
            BypassChainAC = state
            WindUI:Notify({Title = state and "✅成功开启" or "❌已关闭",
                          Content = state and "已绕过CHAIN所有反作弊检测" or "反作弊绕过功能关闭",
                          Duration = 1.5})
        end
    })

    ChainTab:Section({Title = "主要功能", Icon = "zap"})
    ChainTab:Slider({
        Title = "移动速度",
        Value = {Min = 16, Max = 200, Default = 16},
        Increment = 1,
        Callback = function(Value)
            WalkSpeed_Value = Value
            UpdateMoveSpeed()
        end
    })
    ChainTab:Toggle({
        Title = "移动速度开关",
        Default = false,
        Callback = function(state)
            SetMoveSpeed(state)
            WindUI:Notify({Title = state and "✅移动速度开启" or "❌移动速度关闭",
                          Content = state and "移动速度已启用" or "移动速度已禁用",
                          Duration = 1})
        end
    })
    ChainTab:Toggle({
        Title = "穿墙功能",
        Default = false,
        Callback = function(Value) SetNoclip(Value) end
    })
    ChainTab:Toggle({
        Title = "夜视效果",
        Default = false,
        Callback = function(state)
            SetNightVision(state)
            WindUI:Notify({Title = state and "✅夜视开启" or "❌夜视关闭",
                          Content = state and "夜视效果已启用" or "夜视效果已禁用",
                          Duration = 1})
        end
    })
    ChainTab:Toggle({
        Title = "透视链条",
        Default = false,
        Callback = function(state) SetMonsterESP(state) end
    })
    ChainTab:Toggle({
        Title = "无限体力",
        Default = false,
        Callback = function(state)
            infiniteStaminaEnabled = state
            local player = Players.LocalPlayer
            if player then
                if state then
                    if player.Character then setupStaminaInfinite(player.Character) end
                    player.CharacterAdded:Connect(setupStaminaInfinite)
                else
                    if staminaConnection then staminaConnection:Disconnect(); staminaConnection = nil end
                end
            end
        end
    })
    ChainTab:Toggle({
        Title = "无限战斗体力",
        Default = false,
        Callback = function(state)
            infiniteCombatStaminaEnabled = state
            local player = Players.LocalPlayer
            if player then
                if state then
                    if player.Character then setupCombatStaminaInfinite(player.Character) end
                    player.CharacterAdded:Connect(setupCombatStaminaInfinite)
                else
                    if combatStaminaConnection then combatStaminaConnection:Disconnect(); combatStaminaConnection = nil end
                end
            end
        end
    })
    ChainTab:Toggle({
        Title = "无限油锯汽油",
        Default = false,
        Callback = function(state)
            infiniteXSawGasEnabled = state
            local player = Players.LocalPlayer
            if player then
                if state then
                    if player.Character then setupInfiniteXSawGas(player.Character) end
                    player.CharacterAdded:Connect(setupInfiniteXSawGas)
                else
                    if infiniteXSawGasConnection then infiniteXSawGasConnection:Disconnect(); infiniteXSawGasConnection = nil end
                end
                WindUI:Notify({Title = state and "✅开启成功" or "❌已关闭",
                              Content = state and "无限油锯汽油已启用" or "无限油锯汽油已禁用",
                              Duration = 1})
            end
        end
    })
    ChainTab:Toggle({
        Title = "自动赢得油锯动画",
        Default = false,
        Callback = function(state)
            autoXSawClashEnabled = state
            local player = Players.LocalPlayer
            if player then
                if state then
                    if player.Character then setupAutoXSawClash(player.Character) end
                    player.CharacterAdded:Connect(setupAutoXSawClash)
                else
                    if autoXSawClashConnection then autoXSawClashConnection:Disconnect(); autoXSawClashConnection = nil end
                end
                WindUI:Notify({Title = state and "✅开启成功" or "❌已关闭",
                              Content = state and "自动赢得油锯动画已启用" or "自动赢得油锯动画已禁用",
                              Duration = 1})
            end
        end
    })

    ChainTab:Section({Title = "传送功能", Icon = "map-pin"})
    ChainTab:Dropdown({
        Title = "选择传送地点",
        Values = {"房屋", "商店", "仓库", "工作房", "电台", "电力站", "仪式", "无敌点位"},
        Value = "房屋",
        Callback = function(selectedValue) selectedLocation = selectedValue end
    })
    ChainTab:Button({
        Title = "立即传送",
        Default = false,
        Callback = function()
            if selectedLocation then TeleportToLocation(selectedLocation)
            else WindUI:Notify({Title = "传送失败", Content = "请先选择一个传送地点", Duration = 2}) end
        end
    })

    ChainTab:Section({Title = "废料透视", Icon = "eye"})
    ChainTab:Toggle({
        Title = "开启废料透视",
        Default = false,
        Callback = function(state) SetScrapESP(state) end
    })
    ChainTab:Button({
        Title = "手动刷新废料",
        Default = false,
        Callback = function()
            if ScrapESPEnabled then
                WindUI:Notify({Title = "刷新中...", Content = "正在重新扫描废料位置", Duration = 1})
                MainScrapScanLoop()
            else
                WindUI:Notify({Title = "请先启用废料透视", Content = "需要先开启透视功能", Duration = 2})
            end
        end
    })

    ChainTab:Section({Title = "蓝图获取", Icon = "book-open"})
    ChainTab:Button({Title = "解锁保命刀", Callback = function() UnlockBlueprint("CombatKnife") end})
    ChainTab:Button({Title = "解锁沙漠之鹰", Callback = function() UnlockBlueprint("Deagle") end})
    ChainTab:Button({Title = "解锁霰弹枪", Callback = function() UnlockBlueprint("DoubleBarrel") end})
    ChainTab:Button({Title = "解锁手枪", Callback = function() UnlockBlueprint("M1911") end})
    ChainTab:Button({Title = "解锁大砍刀", Callback = function() UnlockBlueprint("Machete") end})
    ChainTab:Button({Title = "解锁魔法书(可能无法使用)", Callback = function() UnlockBlueprint("SpellBook") end})
    ChainTab:Button({Title = "解锁神器任务", Callback = function()
        local Quests = LocalPlayer:WaitForChild('PlayerStats',5):WaitForChild('Quests',5)
        if Quests then
            Quests.ArtifactQuest = true
            WindUI:Notify({Title = "✅解锁成功", Content = "神器任务已解锁", Duration = 1.5})
        else
            WindUI:Notify({Title = "❌解锁失败", Content = "未找到任务配置", Duration = 1.5})
        end
    end})
end

-- 加载Chain功能
loadChainFeatures()