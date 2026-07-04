local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = 'Viltrumites项目',
    Icon = "crown",
    IconThemed = true,
    Author = "",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(500, 400),
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
    Title = "Viltrumites项目",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "Viltrumites项目",
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

local AnnouncementTab = Window:Tab({ Title = "公告", Icon = "bell" })
local MainTab = Window:Tab({ Title = "主要", Icon = "info" })

local AnnouncementSection = AnnouncementTab:Section({ Title = "最新公告" })

AnnouncementSection:Paragraph({
    Title = "Viltrumites项目",
    Content = ""
})

AnnouncementSection:Divider()

AnnouncementSection:Paragraph({
    Title = "该源码由seyoyt提供",
    Content = ""
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

local EventsFolder = ReplicatedStorage:FindFirstChild("Events")
local CombatEvent = EventsFolder and EventsFolder:FindFirstChild("CombatEvent")
local HitEvent = EventsFolder and EventsFolder:FindFirstChild("HitEvent")

local CharactersFolder = ReplicatedStorage:FindFirstChild("Characters")
local MarkFolder = CharactersFolder and CharactersFolder:FindFirstChild("Mark")
local MarkEvents = MarkFolder and MarkFolder:FindFirstChild("Events")
local MarkServerEvent = MarkEvents and MarkEvents:FindFirstChild("ServerEvent")

local TechSuit = CharactersFolder and CharactersFolder:FindFirstChild("TechSuit")
local AnimationModule = nil
local SoundModule = nil

pcall(function()
    local animFunc = ReplicatedStorage:FindFirstChild("Functions") and ReplicatedStorage.Functions:FindFirstChild("Animation")
    if animFunc then AnimationModule = require(animFunc) end
end)

pcall(function()
    local soundInst = ReplicatedStorage:FindFirstChild("Instancers") and ReplicatedStorage.Instancers:FindFirstChild("Sound")
    if soundInst then SoundModule = require(soundInst) end
end)

local AuraConfig = { Enabled = false, Range = 50, Interval = 0.01, LastAttack = 0 }
local VFXConfig = { Enabled = false, Range = 50, Interval = 0.01, LastVFX = 0 }
local ESPConfig = { Name = false, Distance = false, Health = false }
local TeleportConfig = { TargetPlayer = nil, LockTeleport = false, ChainTeleport = false, ChainList = {}, ChainIndex = 1 }
local BillboardCache = {}

local KillAuraSection = MainTab:Section({ Title = "杀戮光环" })

KillAuraSection:Toggle({
    Title = "开启杀戮光环",
    Default = false,
    Callback = function(Value)
        AuraConfig.Enabled = Value
    end
})

KillAuraSection:Input({
    Title = "杀戮光环范围 (15-100)",
    Default = "50",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            AuraConfig.Range = math.clamp(num, 15, 100)
        else
            AuraConfig.Range = 50
        end
    end
})

KillAuraSection:Input({
    Title = "杀戮光环间隔 (0.01-1)",
    Default = "0.01",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            AuraConfig.Interval = math.clamp(num, 0.01, 1)
        else
            AuraConfig.Interval = 0.01
        end
    end
})

KillAuraSection:Toggle({
    Title = "开启打击特效光环(别人能看见)",
    Default = false,
    Callback = function(Value)
        VFXConfig.Enabled = Value
    end
})

KillAuraSection:Input({
    Title = "特效光环范围 (15-100)",
    Default = "50",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            VFXConfig.Range = math.clamp(num, 15, 100)
        else
            VFXConfig.Range = 50
        end
    end
})

KillAuraSection:Input({
    Title = "特效光环间隔 (0.01-1)",
    Default = "0.01",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            VFXConfig.Interval = math.clamp(num, 0.01, 1)
        else
            VFXConfig.Interval = 0.01
        end
    end
})
-- ========== 修改结束 ==========

-- 以下代码保持不变（杀戮光环逻辑、ESP、传送等）
RunService.Heartbeat:Connect(function()
    if not AuraConfig.Enabled then return end
    if tick() - AuraConfig.LastAttack < AuraConfig.Interval then return end
    if not CombatEvent or not HitEvent or not MarkServerEvent then return end
    
    local targets = {}
    local myChar = LocalPlayer.Character
    if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then return end
    
    local myPos = myChar.HumanoidRootPart.Position
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 and (myPos - player.Character.HumanoidRootPart.Position).Magnitude <= AuraConfig.Range then
                table.insert(targets, player.Character)
            end
        end
    end
    
    if #targets > 0 then
        AuraConfig.LastAttack = tick()
        pcall(function()
            MarkServerEvent:FireServer("StatusChanged", "BoostStarted", nil, {1})
        end)
        pcall(function()
            CombatEvent:FireServer("Attack")
        end)
        pcall(function()
            HitEvent:FireServer(targets)
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if not VFXConfig.Enabled then continue end
        if tick() - VFXConfig.LastVFX < VFXConfig.Interval then continue end
        if not TechSuit then continue end
        
        VFXConfig.LastVFX = tick()
        local myChar = LocalPlayer.Character
        if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then continue end
        
        local myPos = myChar.HumanoidRootPart.Position
        local hitCount = 0
        
        for _, enemyPlayer in ipairs(Players:GetPlayers()) do
            if enemyPlayer ~= LocalPlayer and enemyPlayer.Character and enemyPlayer.Character:FindFirstChild("HumanoidRootPart") and enemyPlayer.Character:FindFirstChild("Humanoid") then
                if (myPos - enemyPlayer.Character.HumanoidRootPart.Position).Magnitude <= VFXConfig.Range and enemyPlayer.Character.Humanoid.Health > 0 then
                    local targetChar = enemyPlayer.Character
                    if targetChar and targetChar:IsDescendantOf(workspace) then
                        local v8 = targetChar:FindFirstChild("HumanoidRootPart")
                        if v8 then
                            pcall(function()
                                if AnimationModule and AnimationModule.ReturnAnimationTable then
                                    local animTable = AnimationModule:ReturnAnimationTable("TechSuit - CombatAnimations")
                                    if animTable and animTable.Play then animTable:Play("Block_Hit") end
                                end
                            end)
                            
                            local blockVFX = TechSuit:FindFirstChild("Assets") and TechSuit.Assets:FindFirstChild("Block_VFX")
                            if blockVFX then
                                local v9 = blockVFX:Clone()
                                v9.Parent = workspace:FindFirstChild("Debris") or workspace
                                v9.CFrame = v8.CFrame
                                for _, v10 in ipairs(v9:GetDescendants()) do
                                    if v10:IsA("ParticleEmitter") and v10:GetAttribute("EmitCount") then 
                                        v10:Emit(v10:GetAttribute("EmitCount")) 
                                    end
                                end
                                
                                local noise = TechSuit.Assets:FindFirstChild("Noise")
                                if noise and noise:FindFirstChild("BlockHit") and SoundModule and SoundModule.new then
                                    pcall(function()
                                        SoundModule.new(noise.BlockHit, nil, v8)
                                    end)
                                end
                                
                                Debris:AddItem(v9, 0.3)
                            end
                            
                            hitCount = hitCount + 1
                            if hitCount >= 3 then break end
                        end
                    end
                end
            end
        end
    end
end)

local ESPSection = MainTab:Section({ Title = "ESP" })

ESPSection:Toggle({
    Title = "透视名字",
    Default = false,
    Callback = function(Value)
        ESPConfig.Name = Value
    end
})

ESPSection:Toggle({
    Title = "透视距离",
    Default = false,
    Callback = function(Value)
        ESPConfig.Distance = Value
    end
})

ESPSection:Toggle({
    Title = "透视血量",
    Default = false,
    Callback = function(Value)
        ESPConfig.Health = Value
    end
})

local function createESP(player)
    if player == LocalPlayer then return end
    local function setupChar(char)
        char:WaitForChild("HumanoidRootPart")
        local bboard = Instance.new("BillboardGui")
        bboard.Size = UDim2.new(0, 200, 0, 50)
        bboard.AlwaysOnTop = true
        bboard.ExtentsOffset = Vector3.new(0, 3, 0)
        bboard.Adornee = char:FindFirstChild("HumanoidRootPart")

        local label = Instance.new("TextLabel", bboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0
        label.TextSize = 14

        bboard.Parent = char
        BillboardCache[player] = {Gui = bboard, Label = label, Char = char}
    end
    player.CharacterAdded:Connect(setupChar)
    if player.Character then setupChar(player.Character) end
end

Players.PlayerAdded:Connect(createESP)
for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerRemoving:Connect(function(p) BillboardCache[p] = nil end)

RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    for player, data in pairs(BillboardCache) do
        if data.Char and data.Char.Parent and data.Char:FindFirstChild("HumanoidRootPart") and data.Char:FindFirstChild("Humanoid") then
            local text = ""
            if ESPConfig.Name then text = text .. player.Name .. "\n" end
            if ESPConfig.Distance and myHRP then text = text .. "Dist: " .. tostring(math.floor((myHRP.Position - data.Char.HumanoidRootPart.Position).Magnitude)) .. "m\n" end
            if ESPConfig.Health then text = text .. "HP: " .. tostring(math.floor(data.Char.Humanoid.Health)) .. "/" .. tostring(math.floor(data.Char.Humanoid.MaxHealth)) .. "\n" end
            data.Label.Text = text
            data.Gui.Enabled = (ESPConfig.Name or ESPConfig.Distance or ESPConfig.Health)
        else
            data.Gui.Enabled = false
        end
    end
end)

local TeleportSection = MainTab:Section({ Title = "传送" })

local PlayerDropdown
local function getPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

PlayerDropdown = TeleportSection:Dropdown({
    Title = "选择玩家",
    Values = getPlayerNames(),
    Default = 1,
    Multi = false,
    Callback = function(Value)
        TeleportConfig.TargetPlayer = Players:FindFirstChild(Value)
    end
})

TeleportSection:Toggle({
    Title = "锁定传送",
    Default = false,
    Callback = function(Value)
        TeleportConfig.LockTeleport = Value
    end
})

TeleportSection:Toggle({
    Title = "传送所有",
    Default = false,
    Callback = function(Value)
        TeleportConfig.ChainTeleport = Value
        if Value then
            TeleportConfig.ChainList = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    table.insert(TeleportConfig.ChainList, p)
                end
            end
            TeleportConfig.ChainIndex = 1
        end
    end
})

local function updatePlayerDropdown()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    PlayerDropdown:Refresh(names, true)
end

Players.PlayerAdded:Connect(updatePlayerDropdown)
Players.PlayerRemoving:Connect(updatePlayerDropdown)

RunService.Heartbeat:Connect(function()
    if TeleportConfig.ChainTeleport then
        local currentEnemy = TeleportConfig.ChainList[TeleportConfig.ChainIndex]
        if currentEnemy and currentEnemy.Parent then
            local char = currentEnemy.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            else
                TeleportConfig.ChainIndex = TeleportConfig.ChainIndex + 1
                if TeleportConfig.ChainIndex > #TeleportConfig.ChainList then
                    TeleportConfig.ChainList = {}
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer then
                            table.insert(TeleportConfig.ChainList, p)
                        end
                    end
                    TeleportConfig.ChainIndex = 1
                end
            end
        else
            TeleportConfig.ChainIndex = TeleportConfig.ChainIndex + 1
            if TeleportConfig.ChainIndex > #TeleportConfig.ChainList then
                TeleportConfig.ChainTeleport = false
            end
        end
    elseif TeleportConfig.LockTeleport and TeleportConfig.TargetPlayer then
        local p = TeleportConfig.TargetPlayer
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end
end)