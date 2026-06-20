local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = 'han付费',
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
    Title = "终极战场",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "终极战场",
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

-- ==================== 终极战场功能 ====================
local function qw()
    Window:Divider()
    local Tab = Window:Tab({
        Title = "主要功能",
        Icon = "sword",
        Locked = false,
    })
    Tab:Button({
        Title = "篡改",
        Desc = "玩的时候第一先开启这个功能",
        Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dream77239/ubg-script/refs/heads/main/%E6%8B%A6%E6%88%AA.txt"))()
        end
    })
    local fakeBlockEnabled = false
    local loopRunning = false

    Tab:Toggle({
        Title = "假防(关闭功能后按一次防御即可取消假防)",
        Value = false,
        Callback = function(state)
            fakeBlockEnabled = state

            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local BlockRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Block")
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()

            local function enableBlock()
                pcall(function()
                    BlockRemote:FireServer(true)
                end)
            end

            if fakeBlockEnabled then
                enableBlock()
            end

            if not loopRunning then
                loopRunning = true
                task.spawn(function()
                    while true do
                        task.wait(0.1)
                        if fakeBlockEnabled then
                            local success, isBlocking = pcall(function()
                                return character:GetAttribute("IsBlocking")
                            end)
                            if success and not isBlocking then
                                enableBlock()
                            end
                        end
                    end
                end)
            end
        end
    })

    local defaultCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Dash.Value

    Tab:Toggle({
        Title = "侧闪无冷却",
        Value = false,
        Callback = function(state)
            local dashCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Dash
            if state then
                dashCooldown.Value = 1
            else
                dashCooldown.Value = defaultCooldown
            end
        end
    })
    local defaultMeleeCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Melee.Value

    Tab:Toggle({
        Title = "近战无冷却",
        Value = false,
        Callback = function(state)
            local meleeCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Melee
            if state then
                meleeCooldown.Value = 1
            else
                meleeCooldown.Value = defaultMeleeCooldown
            end
        end
    })
    local rs = game:GetService("ReplicatedStorage")
    local settings = rs.Settings

    local defaultAbility = settings.Cooldowns.Ability.Value
    Tab:Toggle({
        Title = "技能无冷却(仅宿傩角色)",
        Value = false,
        Callback = function(state)
            settings.Cooldowns.Ability.Value = state and 1 or defaultAbility
        end
    })
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Remotes = ReplicatedStorage.Remotes
    local Combat = Remotes.Combat
    local EmoteClaim = Combat.EmoteClaim

    local emoteClaimActive = false
    local emoteClaimConnection = nil

    local function startEmoteClaim()
        emoteClaimConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if emoteClaimActive then
                EmoteClaim:FireServer()
            end
        end)
    end

    local function stopEmoteClaim()
        if emoteClaimConnection then
            emoteClaimConnection:Disconnect()
            emoteClaimConnection = nil
        end
    end

    Tab:Toggle({
        Title = "自动签到表情",
        Value = false,
        Callback = function(state)
            emoteClaimActive = state
            if state then
                startEmoteClaim()
            else
                stopEmoteClaim()
            end
        end
    })
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local noSlowdownsToggle = ReplicatedStorage.Settings.Toggles.NoSlowdowns

    local defaultValue = false

    Tab:Toggle({
        Title = "无减速效果",
        Value = noSlowdownsToggle.Value,
        Callback = function(state)
            if state then
                noSlowdownsToggle.Value = true
            else
                noSlowdownsToggle.Value = defaultValue
            end
        end
    })

    local defaultDisableHitStun = settings.Toggles.DisableHitStun.Value
    Tab:Toggle({
        Title = "取消被攻击硬直",
        Value = false,
        Callback = function(state)
            settings.Toggles.DisableHitStun.Value = state
        end
    })

    local defaultDisableIntros = settings.Toggles.DisableIntros.Value
    Tab:Toggle({
        Title = "跳过角色开场动作",
        Value = false,
        Callback = function(state)
            settings.Toggles.DisableIntros.Value = state
        end
    })

    local defaultNoStunOnMiss = settings.Toggles.NoStunOnMiss.Value
    Tab:Toggle({
        Title = "普攻无僵直",
        Value = false,
        Callback = function(state)
            settings.Toggles.NoStunOnMiss.Value = state
        end
    })

    local defaultRagdollTimer = settings.Multipliers.RagdollTimer.Value
    Tab:Toggle({
        Title = "被别人击倒不会变成布娃娃",
        Value = false,
        Callback = function(state)
            settings.Multipliers.RagdollTimer.Value = state and 0.5 or defaultRagdollTimer
        end
    })

    local defaultUltimateTimer = settings.Multipliers.UltimateTimer.Value
    Tab:Toggle({
        Title = "延长大招时间",
        Value = false,
        Callback = function(state)
            settings.Multipliers.UltimateTimer.Value = state and 100000 or defaultUltimateTimer
        end
    })

    local defaultInstantTransformation = settings.Toggles.InstantTransformation.Value
    Tab:Toggle({
        Title = "秒开大",
        Value = false,
        Callback = function(state)
            settings.Toggles.InstantTransformation.Value = state
        end
    })
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local Ping = player:WaitForChild("Info"):WaitForChild("Ping")

    local loop

    Tab:Toggle({
        Title = "ping乱码",
        Value = false,
        Callback = function(state)
            if state then
                loop = task.spawn(function()
                    while state do
                        for i = 0, 999, 25 do
                            if not state then break end
                            Ping.Value = i
                            task.wait(0.03)
                        end
                        for i = 999, 0, -25 do
                            if not state then break end
                            Ping.Value = i
                            task.wait(0.03)
                        end
                    end
                end)
            else
                if loop then
                    task.cancel(loop)
                    loop = nil
                end
            end
        end
    })
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local MeleeDamage = ReplicatedStorage:WaitForChild("Settings"):WaitForChild("Multipliers"):WaitForChild("MeleeDamage")

    MeleeDamage.Value = 100

    Tab:Toggle({
        Title = "一拳倒地",
        Value = false,
        Callback = function(state)
            if state then
                MeleeDamage.Value = 1000000
            else
                MeleeDamage.Value = 100
            end
        end
    })
    Tab:Toggle({
        Title = "一拳击飞",
        Value = false,
        Callback = function(state)
            local Players = game:GetService("Players")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local RunService = game:GetService("RunService")

            local LocalPlayer = Players.LocalPlayer
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

            local RagdollPower = ReplicatedStorage:WaitForChild("Settings"):WaitForChild("Multipliers"):WaitForChild("RagdollPower")

            local maxTeleportDistance = 50
            local lastPosition = HumanoidRootPart.Position
            local connection

            if state then
                RagdollPower.Value = 10000

                connection = RunService.Heartbeat:Connect(function()
                    -- refresh character in case of reset
                    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                        lastPosition = HumanoidRootPart.Position
                    end

                    local currentPos = HumanoidRootPart.Position
                    local distance = (currentPos - lastPosition).Magnitude

                    if distance > maxTeleportDistance then
                        HumanoidRootPart.CFrame = CFrame.new(lastPosition)
                    else
                        lastPosition = currentPos
                    end
                end)
            else
                RagdollPower.Value = 100
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end
    })
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local wallCombo = ReplicatedStorage.Settings.Cooldowns.WallCombo

    Tab:Toggle({
        Title = "墙打无冷却",
        Value = false,
        Callback = function(state)
            if state then
                wallCombo.Value = 0
                print("WallCombo cooldown set to 0")
            else
                wallCombo.Value = 100
                print("WallCombo cooldown reset to 100")
            end
        end
    })
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    local wall = nil
    pcall(function()
        wall = workspace.Map.Structural.Terrain:GetChildren()[5]:GetChildren()[12]
    end)

    if not wall then
        wall = Instance.new("Part")
        wall.Parent = workspace
    end

    wall.Size = Vector3.new(12,6,2)
    wall.Transparency = 0.6
    wall.Material = Enum.Material.SmoothPlastic
    wall.Anchored = true
    wall.CanCollide = true
    wall.CFrame = wall.CFrame or CFrame.new(0,5,0)

    if getconnections then
        for _, conn in pairs(getconnections(wall.AncestryChanged)) do
            conn:Disable()
        end
    end

    local mt = getrawmetatable(game)
    setreadonly(mt,false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if self == wall and method == "Destroy" then
            return
        end
        return old(self, ...)
    end)
    setreadonly(mt,true)

    local followConnection = nil
    Tab:Toggle({
        Title = "随处墙打",
        Value = false,
        Callback = function(state)
            if state then
                if not followConnection then
                    followConnection = RunService.Heartbeat:Connect(function()
                        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            wall.CFrame = hrp.CFrame * CFrame.new(0,0,-8)
                        end
                    end)
                end
            else
                if followConnection then
                    followConnection:Disconnect()
                    followConnection = nil
                end
            end
        end
    })
    local originalData = {}
    local skyBackup = nil

    Tab:Toggle({
        Title = "防卡",
        Value = false,
        Callback = function(state)
            if state then
                originalData = {}
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Explosion") then
                        originalData[v] = v.Enabled
                        v.Enabled = false
                    elseif v:IsA("Decal") or v:IsA("Texture") then
                        originalData[v] = v.Transparency
                        v.Transparency = 1
                    elseif v:IsA("MeshPart") or v:IsA("UnionOperation") or v:IsA("Part") then
                        if v.Name ~= "HumanoidRootPart" then
                            originalData[v] = v.Material
                            v.Material = Enum.Material.SmoothPlastic
                        end
                    elseif v:IsA("SurfaceGui") or v:IsA("BillboardGui") or v:IsA("Beam") then
                        if v:IsA("Beam") then
                            originalData[v] = v.Enabled
                            v.Enabled = false
                        else
                            originalData[v] = v.Enabled ~= nil and v.Enabled or true
                            if v.Enabled ~= nil then
                                v.Enabled = false
                            end
                        end
                    end
                end
                originalData["GlobalShadows"] = game.Lighting.GlobalShadows
                originalData["FogEnd"] = game.Lighting.FogEnd
                game.Lighting.GlobalShadows = false
                game.Lighting.FogEnd = 9e9
                local sky = game.Lighting:FindFirstChildOfClass("Sky")
                if sky then
                    skyBackup = sky:Clone()
                    sky:Destroy()
                end
                local newSky = Instance.new("Sky")
                newSky.SkyboxBk = ""
                newSky.SkyboxDn = ""
                newSky.SkyboxFt = ""
                newSky.SkyboxLf = ""
                newSky.SkyboxRt = ""
                newSky.SkyboxUp = ""
                newSky.SunAngularSize = 0
                newSky.MoonAngularSize = 0
                newSky.Parent = game.Lighting
                game.Lighting.Ambient = Color3.fromRGB(128,128,128)
                game.Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
            else
                for obj, value in pairs(originalData) do
                    if typeof(obj) == "Instance" and obj.Parent then
                        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Explosion") then
                            obj.Enabled = value
                        elseif obj:IsA("Decal") or obj:IsA("Texture") then
                            obj.Transparency = value
                        elseif obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Part") then
                            obj.Material = value
                        elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") or obj:IsA("Beam") then
                            if obj:IsA("Beam") then
                                obj.Enabled = value
                            elseif obj.Enabled ~= nil then
                                obj.Enabled = value
                            end
                        end
                    elseif obj == "GlobalShadows" then
                        game.Lighting.GlobalShadows = value
                    elseif obj == "FogEnd" then
                        game.Lighting.FogEnd = value
                    end
                end
                if skyBackup then
                    local currentSky = game.Lighting:FindFirstChildOfClass("Sky")
                    if currentSky then
                        currentSky:Destroy()
                    end
                    skyBackup.Parent = game.Lighting
                    skyBackup = nil
                end
                originalData = {}
            end
        end
    })
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Camera = workspace.CurrentCamera

    local clone, platform, originalCFrame, originalCameraSubject

    local function CreatePlatform(position)
        local part = Instance.new("Part")
        part.Size = Vector3.new(10, 1, 10)
        part.Position = position - Vector3.new(0, 3, 0)
        part.Anchored = true
        part.CanCollide = true
        part.Transparency = 0.5
        part.Parent = workspace
        return part
    end

    local function CreateClone()
        local newClone = Character:Clone()
        for _, v in ipairs(newClone:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Transparency = 0.5
            end
        end
        newClone.Parent = workspace
        return newClone
    end

    local function ToggleInvisibility(state)
        if state then
            originalCFrame = HumanoidRootPart.CFrame
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, -50, 0)
            platform = CreatePlatform(HumanoidRootPart.Position)
            
            task.wait(1)
            
            clone = CreateClone()
            clone:MoveTo(originalCFrame.Position)
            Camera.CameraSubject = clone:FindFirstChildWhichIsA("Humanoid")
            LocalPlayer.Character = clone
        else
            if clone then
                clone:Destroy()
                clone = nil
            end
            
            if platform then
                platform:Destroy()
                platform = nil
            end
            
            if originalCFrame then
                HumanoidRootPart.CFrame = originalCFrame
                originalCFrame = nil
            end
            
            Camera.CameraSubject = Character:FindFirstChildWhichIsA("Humanoid")
            LocalPlayer.Character = Character
        end
    end

    Tab:Toggle({
        Title = "隐身",
        Value = false,
        Callback = ToggleInvisibility
    })

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local active = false

    local function getLocalPlayerCharacter()
        return LocalPlayer.Character
    end

    local function generateActionNumber()
        return "Action" .. math.random(1000, 9999)
    end

    local function getServerTime()
        return tick()
    end

    local function wallcomboveryud()
        local playerChar = getLocalPlayerCharacter()
        if not playerChar then return false end

        local head = playerChar:FindFirstChild("Head")
        if not head then return false end

        local charData = LocalPlayer:FindFirstChild("Data")
        local charValue = charData and charData:FindFirstChild("Character") and charData.Character.Value
        if not charValue then return false end

        local charsFolder = ReplicatedStorage:FindFirstChild("Characters")
        if not charsFolder or not charsFolder:FindFirstChild(charValue) then return false end

        local wallComboAbility = charsFolder[charValue]:FindFirstChild("WallCombo")
        if not wallComboAbility then return false end

        local targetCharacter = playerChar
        if not targetCharacter then return false end

        local actionNumber = generateActionNumber()
        local serverTime = getServerTime()
        local randomId = math.random(100000, 999999)

        local remoteArgs = {
            wallComboAbility,
            "Characters:" .. charValue .. ":WallCombo",
            1,
            randomId,
            {
                HitboxCFrames = {nil},
                BestHitCharacter = targetCharacter,
                HitCharacters = {targetCharacter},
                Ignore = {[actionNumber] = {targetCharacter}},
                DeathInfo = {},
                Actions = {[actionNumber] = {}},
                HitInfo = {
                    Blocked = false,
                    IsFacing = true,
                    IsInFront = true
                },
                BlockedCharacters = {},
                ServerTime = serverTime,
                FromCFrame = nil
            },
            actionNumber
        }

        pcall(function()
            ReplicatedStorage.Remotes.Abilities.Ability:FireServer(wallComboAbility, randomId)
        end)

        pcall(function()
            ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(remoteArgs))
        end)
    end

    task.spawn(function()
        while task.wait(0.01) do
            if active then
                pcall(wallcomboveryud)
            end
        end
    end)

    Tab:Toggle({
        Title = "无敌",
        Value = false,
        Callback = function(state)
            active = state
        end
    })
    Tab:Button({
        Title = "卡服",
        Callback = function()
            local Players = game:GetService("Players")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local RunService = game:GetService("RunService")

            local player = Players.LocalPlayer
            local active = true
            local spawnedTasks = {}

            local function buildCombatArgs()
                return {
                    [1] = ReplicatedStorage.Characters.Gon.WallCombo,
                    [2] = "Characters:Gon:WallCombo",
                    [3] = 1,
                    [4] = 33036,
                    [5] = {
                        ["HitboxCFrames"] = {},
                        ["BestHitCharacter"] = workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum"),
                        ["HitCharacters"] = {workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum")},
                        ["Ignore"] = {},
                        ["DeathInfo"] = {},
                        ["Actions"] = {},
                        ["HitInfo"] = {
                            ["IsFacing"] = true,
                            ["IsInFront"] = true
                        },
                        ["BlockedCharacters"] = {},
                        ["ServerTime"] = os.clock(),
                        ["FromCFrame"] = CFrame.new(534.693, 5.532, 79.486)
                    },
                    [6] = "Action651",
                    [7] = 0
                }
            end

            local abilityArgs = {
                [1] = ReplicatedStorage.Characters.Gon.WallCombo,
                [2] = 33036,
                [4] = workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum"),
                [5] = Vector3.new(527.693, 4.532, 79.978)
            }

            for i = 1, 10000 do
                local t = task.spawn(function()
                    if active then
                        pcall(function()
                            local combatArgs = buildCombatArgs()
                            ReplicatedStorage.Remotes.Abilities.Ability:FireServer(unpack(abilityArgs))
                            ReplicatedStorage.Remotes.Combat.Action:FireServer(unpack(combatArgs))
                        end)
                    end
                end)
                table.insert(spawnedTasks, t)
            end

            task.delay(3, function()
                active = false
                for _, t in ipairs(spawnedTasks) do
                    if task.cancel then
                        task.cancel(t)
                    end
                end
                spawnedTasks = {}

                local localContainers = workspace:FindFirstChild("Container(Drawing)")
                if localContainers then
                    for _, v in ipairs(localContainers:GetChildren()) do
                        if v.Name:match(tostring(player.UserId)) then
                            v:Destroy()
                        end
                    end
                end

                print("已瞬发500事件，本地已停止继续发展并清理任务与日志")
            end)
        end
    })
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Core = require(ReplicatedStorage:WaitForChild("Core"))
    local LocalPlayer = Players.LocalPlayer

    local Configs = {
        IgnoreFriends = false,
        MaxDistance = 100,
        Damage = 9999,
        HealthLimit = 0,
        DashInterval = 0.7,
        AttackInterval = 0.001
    }

    local running = false
    local conn
    local lastDash = 0
    local lastAttack = 0

    local data = LocalPlayer:WaitForChild("Data")
    local charValue = data:WaitForChild("Character")
    local localCharacterName = charValue.Value
    local ability = ReplicatedStorage:WaitForChild("Characters"):WaitForChild(localCharacterName):WaitForChild("WallCombo")
    local AbilitiesRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Abilities"):WaitForChild("Ability")
    local CombatRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action")

    local function getLocalRootPart()
        local c = LocalPlayer.Character
        return c and c:FindFirstChild("HumanoidRootPart")
    end

    local function triggerDash()
        if tick() - lastDash < Configs.DashInterval then return end
        lastDash = tick()
        local hrp = getLocalRootPart()
        if not hrp then return end
        local dashRemote = ReplicatedStorage.Remotes.Character:FindFirstChild("Dash")
        if dashRemote then
            pcall(function()
                dashRemote:FireServer(hrp.CFrame, "L", hrp.CFrame.LookVector, nil, tick())
            end)
        end
    end

    local function sendKillAura()
        if tick() - lastAttack < Configs.AttackInterval then return end
        lastAttack = tick()
        local localRootPart = getLocalRootPart()
        if not localRootPart then return end
        triggerDash()
        local maxDistSq = Configs.MaxDistance * Configs.MaxDistance
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= LocalPlayer then
                local targetChar = targetPlayer.Character
                if targetChar then
                    local targetRootPart = targetChar:FindFirstChild("HumanoidRootPart")
                    local targetHumanoid = targetChar:FindFirstChild("Humanoid")
                    if targetRootPart and targetHumanoid and targetHumanoid.Health > Configs.HealthLimit then
                        if not (Configs.IgnoreFriends and LocalPlayer:IsFriendsWith(targetPlayer.UserId)) then
                            local delta = localRootPart.Position - targetRootPart.Position
                            if delta.Magnitude * delta.Magnitude <= maxDistSq then
                                pcall(function()
                                    AbilitiesRemote:FireServer(ability, Configs.Damage, {}, targetRootPart.Position)
                                end)
                                pcall(function()
                                    CombatRemote:FireServer(
                                        ability,
                                        localCharacterName .. ":WallCombo",
                                        2,
                                        Configs.Damage,
                                        {
                                            HitboxCFrames = {targetRootPart.CFrame, targetRootPart.CFrame},
                                            BestHitCharacter = targetChar,
                                            HitCharacters = {targetChar},
                                            Ignore = {},
                                            DeathInfo = {},
                                            BlockedCharacters = {},
                                            HitInfo = {IsFacing = false, IsInFront = true},
                                            ServerTime = os.time(),
                                            Actions = {
                                                ActionNumber1 = {
                                                    [targetPlayer.Name] = {
                                                        StartCFrameStr = tostring(localRootPart.CFrame),
                                                        Local = true,
                                                        Collision = false,
                                                        Animation = "Punch1Hit",
                                                        Preset = "Punch",
                                                        Velocity = Vector3.zero,
                                                        FromPosition = targetRootPart.Position,
                                                        Seed = math.random(1,999999)
                                                    }
                                                }
                                            },
                                            FromCFrame = targetRootPart.CFrame
                                        },
                                        "Action150",
                                        0
                                    )
                                end)
                            end
                        end
                    end
                end
            end
        end
    end

    local function startAura()
        if conn then conn:Disconnect() conn = nil end
        conn = RunService.Heartbeat:Connect(function()
            if running then
                sendKillAura()
            end
        end)
    end

    local function stopAura()
        if conn then conn:Disconnect() conn = nil end
    end

    Tab:Toggle({
        Title = "杀戮光环",
        Value = false,
        Callback = function(state)
            running = state
            if running then
                startAura()
            else
                stopAura()
            end
        end
    })

    Tab:Toggle({
        Title = "杀戮光环忽略好友",
        Value = false,
        Callback = function(state)
            Configs.IgnoreFriends = state
        end
    })
    Tab:Toggle({
        Title = "墙打秒杀",
        Value = false,
        Callback = function(state)
            toggleWallCombo(state)
        end
    })

    Tab:Toggle({
        Title = "墙打秒杀忽略好友",
        Value = false,
        Callback = function(state)
            ignoreFriends = state
        end
    })
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local CircleParts = {}
    local Connection

    local function RainbowColor(t)
        local r = math.sin(t) * 40 + 180
        local g = math.sin(t + 2) * 40 + 180
        local b = math.sin(t + 4) * 40 + 180
        return Color3.fromRGB(r, g, b)
    end

    Tab:Toggle({
        Title = "墙打/杀戮光环范围显示",
        Value = false,
        Callback = function(state)
            local function CreateCircle(radius, segments, thickness)
                local parts = {}
                for i = 1, segments do
                    local part = Instance.new("Part")
                    part.Anchored = true
                    part.CanCollide = false
                    part.Material = Enum.Material.Neon
                    part.Size = Vector3.new(thickness, 0.2, radius * 2 * math.pi / segments)
                    part.Color = Color3.fromRGB(180,180,180)
                    part.Parent = workspace
                    table.insert(parts, part)
                end
                return parts
            end

            local function DestroyCircle()
                if Connection then
                    Connection:Disconnect()
                    Connection = nil
                end
                for _, part in ipairs(CircleParts) do
                    if part and part.Parent then
                        part:Destroy()
                    end
                end
                CircleParts = {}
            end

            if state then
                DestroyCircle()
                local radius = 60
                local segments = 60
                local thickness = 0.2
                CircleParts = CreateCircle(radius, segments, thickness)

                local time = 0
                local updateAccumulator = 0
                local updateRate = 1/60

                Connection = RunService.Heartbeat:Connect(function(dt)
                    time = time + dt
                    updateAccumulator = updateAccumulator + dt
                    if updateAccumulator < updateRate then return end
                    updateAccumulator = 0

                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local rootPos = char.HumanoidRootPart.Position
                        local humanoid = char:FindFirstChild("Humanoid")
                        local heightOffset = humanoid and humanoid.HipHeight / 2 + 0.1 or 0.9 -- 下移一点点
                        local pos = rootPos - Vector3.new(0, heightOffset, 0)

                        for i, part in ipairs(CircleParts) do
                            local angle = (i / #CircleParts) * 2 * math.pi
                            local x = pos.X + math.cos(angle) * radius
                            local z = pos.Z + math.sin(angle) * radius
                            part.Position = Vector3.new(x, pos.Y, z)
                            part.Orientation = Vector3.new(0, -math.deg(angle), 0)
                            part.Color = RainbowColor(time + i * 0.1)
                        end
                    end
                end)
            else
                DestroyCircle()
            end
        end
    })

    Tab:Button({
        Title = "删除墙打特效",
        Desc = "点了该功能就无法恢复墙打特效",
        Callback = function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local paths = {
                ReplicatedStorage.Characters.Gon.WallCombo.GonWallCombo.Center,
                ReplicatedStorage.Characters.Gon.WallCombo.GonWallCombo.Explosion,
                ReplicatedStorage.Characters.Gon.WallCombo.GonIntroHands,
                ReplicatedStorage.Characters.Mob.WallCombo.MobWallCombo.Center,
                ReplicatedStorage.Characters.Nanami.WallCombo.NanamiWallCombo.Center,
                ReplicatedStorage.Characters.Stark.WallCombo.StarkWallCombo.Center,
                ReplicatedStorage.Characters.Sukuna.WallCombo.SukunaTransformWallCombo,
                ReplicatedStorage.Characters.Sukuna.WallCombo.SukunaWallCombo
            }

            for _, obj in ipairs(paths) do
                if obj and obj:IsA("Instance") then
                    for _, child in ipairs(obj:GetChildren()) do
                        child:Destroy()
                    end
                end
            end
        end
    })
    Tab:Button({
        Title = "删除击杀表情特效",
        Desc = "点击删除击杀表情的部分特效,不可恢复",
        Callback = function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local KillEmote = ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote")

            local function removeEffects(obj)
                for _, child in ipairs(obj:GetChildren()) do
                    if child:IsA("ParticleEmitter") 
                    or child:IsA("Trail") 
                    or child:IsA("Beam") 
                    or child:IsA("Fire") 
                    or child:IsA("Smoke") 
                    or child:IsA("Sparkles") 
                    or child:IsA("Light") then
                        child:Destroy()
                    else
                        removeEffects(child)
                    end
                end
            end

            removeEffects(KillEmote)
            print("KillEmote 特效已删除（保留本体）")
        end
    })
     local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local multiUseCutscenesToggle = ReplicatedStorage.Settings.Toggles.MultiUseCutscenes

    local defaultValue = false

    Tab:Toggle({
        Title = "艾斯帕大招技能多次使用(全角色通用)",
        Value = multiUseCutscenesToggle.Value,
        Callback = function(state)
            if state then
                multiUseCutscenesToggle.Value = true
            else
                multiUseCutscenesToggle.Value = defaultValue
            end
        end
    })
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local QEfly = true

    local FLYING = false
    local flyKeyDown, flyKeyUp, mobileFlyConn
    local iyflyspeed = 2
    local vehicleflyspeed = 2

    local function getRoot(char)
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    end

    local function NOFLY()
        FLYING = false
        if flyKeyDown then flyKeyDown:Disconnect() flyKeyDown = nil end
        if flyKeyUp then flyKeyUp:Disconnect() flyKeyUp = nil end
        if mobileFlyConn then mobileFlyConn:Disconnect() mobileFlyConn = nil end
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local root = getRoot(char)
            if humanoid then humanoid.PlatformStand = false end
            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
        pcall(function()
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end)
    end

    local function sFLY(vfly)
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")
        local root = getRoot(char)

        if flyKeyDown then flyKeyDown:Disconnect() end
        if flyKeyUp then flyKeyUp:Disconnect() end
        if mobileFlyConn then mobileFlyConn:Disconnect() end

        local CONTROL = {F=0,B=0,L=0,R=0,Q=0,E=0}

        local BG = Instance.new("BodyGyro")
        local BV = Instance.new("BodyVelocity")
        BG.P = 9e4
        BG.MaxTorque = Vector3.new(9e9,9e9,9e9)
        BG.CFrame = root.CFrame
        BG.Parent = root
        BV.MaxForce = Vector3.new(9e9,9e9,9e9)
        BV.Velocity = Vector3.new(0,0,0)
        BV.Parent = root

        FLYING = true

        flyKeyDown = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.W then CONTROL.F = iyflyspeed end
                if input.KeyCode == Enum.KeyCode.S then CONTROL.B = -iyflyspeed end
                if input.KeyCode == Enum.KeyCode.A then CONTROL.L = -iyflyspeed end
                if input.KeyCode == Enum.KeyCode.D then CONTROL.R = iyflyspeed end
                if input.KeyCode == Enum.KeyCode.E and QEfly then CONTROL.Q = iyflyspeed*2 end
                if input.KeyCode == Enum.KeyCode.Q and QEfly then CONTROL.E = -iyflyspeed*2 end
            end
        end)

        flyKeyUp = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0 end
                if input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0 end
                if input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0 end
                if input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0 end
                if input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0 end
                if input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0 end
            end
        end)

        mobileFlyConn = RunService.Heartbeat:Connect(function()
            if not FLYING then return end
            local camera = workspace.CurrentCamera
            local moveVector = Vector3.new(CONTROL.L+CONTROL.R, CONTROL.Q+CONTROL.E, CONTROL.F+CONTROL.B)

            local ok, controlModule = pcall(function()
                return require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
            end)
            if ok and controlModule then
                local mv = controlModule:GetMoveVector()
                moveVector = Vector3.new(mv.X*(vfly and vehicleflyspeed or iyflyspeed), moveVector.Y, -mv.Z*(vfly and vehicleflyspeed or iyflyspeed))
            end

            BV.Velocity = (camera.CFrame.RightVector*moveVector.X + Vector3.new(0,moveVector.Y,0) + camera.CFrame.LookVector*moveVector.Z)*50
            BG.CFrame = camera.CFrame
            humanoid.PlatformStand = true
        end)
    end

    local function applyFly()
        sFLY()
        LocalPlayer.CharacterAdded:Connect(function()
            if FLY_TOGGLE_STATE then
                task.wait(0.5)
                sFLY()
            end
        end)
    end

    local FLY_TOGGLE_STATE = false

    Tab:Toggle({
        Title = "飞行",
        Value = false,
        Callback = function(state)
            FLY_TOGGLE_STATE = state
            if state then
                applyFly()
            else
                NOFLY()
            end
        end
    })

    Tab:Slider({
        Title = "飞行速度",
        Value = {
            Min = 1,
            Max = 10,
            Default = 2
        },
        Callback = function(value)
            iyflyspeed = value
            vehicleflyspeed = value
        end
    })
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local tpwalking = false
    local tpwalkSpeed = 100

    Tab:Toggle({
        Title = "速度",
        Value = false,
        Callback = function(state)
            tpwalking = state
            if state then
                spawn(function()
                    while tpwalking do
                        local chr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                        local hrp = chr:FindFirstChild("HumanoidRootPart")
                        local hum = chr:FindFirstChildWhichIsA("Humanoid")
                        local delta = RunService.Heartbeat:Wait()
                        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * tpwalkSpeed * delta)
                        end
                    end
                end)
            end
        end
    })

    Tab:Slider({
        Title = "速度调节",
        Value = {
            Min = 0,
            Max = 250,
            Default = tpwalkSpeed,
        },
        Callback = function(value)
            tpwalkSpeed = value
        end
    })
    Tab:Slider({
        Title = "冲刺加速(默认值100)",
        Value = {
            Min = 0,
            Max = 1000,
            Default = 100,
        },
        Callback = function(value)
            game:GetService("ReplicatedStorage").Settings.Multipliers.DashSpeed.Value = value
        end
    })

    Tab:Slider({
        Title = "跳跃增强(默认值100)",
        Value = {
            Min = 0,
            Max = 1000,
            Default = 100,
        },
        Callback = function(value)
            game:GetService("ReplicatedStorage").Settings.Multipliers.JumpHeight.Value = value
        end
    })

    Tab:Slider({
        Title = "攻击加速(默认值100)",
        Value = {
            Min = 0,
            Max = 1000,
            Default = 100,
        },
        Callback = function(value)
            game:GetService("ReplicatedStorage").Settings.Multipliers.MeleeSpeed.Value = value
        end
    })
    local Players = game:GetService("Players")
    local Tab = Window:Tab({
        Title = "碰撞箱扩大",
        Icon = "box",
        Locked = false,
    })

    local expansionMethod = "Add"
    local hitboxX, hitboxY, hitboxZ = 0, 0, 0
    local isHitboxExpanded = false
    local hitModuleTable = nil
    local originalBox = nil
    local sizeModifier = Vector3.new(0, 0, 0)

    local function setupHitboxHook()
        if hitModuleTable and hitModuleTable._boxSizeModifierHookInstalled then
            print("Hitbox hook already installed.")
            return true
        end
        
        local player = Players.LocalPlayer
        local playerScripts = player:WaitForChild("PlayerScripts")
        local combatFolder = playerScripts:WaitForChild("Combat")
        local hitModule = combatFolder:WaitForChild("Hit")
        
        hitModuleTable = require(hitModule)
        originalBox = hitModuleTable.Box
        
        hitModuleTable.Box = function(...)
            local args = {...}
            if args[3] and typeof(args[3]) == "table" then
                local config = args[3]
                if config.Size and typeof(config.Size) == "Vector3" then
                    if not config._originalSize then
                        config._originalSize = config.Size
                    end
                    if expansionMethod == "Set" then
                        config.Size = sizeModifier
                    elseif expansionMethod == "Add" then
                        config.Size = config._originalSize + sizeModifier
                    end
                end
                return originalBox(...)
            else
                return originalBox(...)
            end
        end
        hitModuleTable._boxSizeModifierHookInstalled = true
        return true
    end

    local function applySigmaHitbox(x, y, z)
        if not setupHitboxHook() then
            warn("Failed to setup hitbox hook!")
            return
        end
        sizeModifier = Vector3.new(x, y, z)
        print("Sigma hitbox expansion applied:", sizeModifier)
    end

    Tab:Input({
        Title = "X 轴向量",
        Value = "0",
        InputIcon = "bird",
        Type = "Input",
        Placeholder = "输入一个数字...",
        Callback = function(input)
            hitboxX = tonumber(input) or 0
            print("Hitbox X vector set to:", hitboxX)
        end
    })

    Tab:Input({
        Title = "Y 轴向量",
        Value = "0",
        InputIcon = "bird",
        Type = "Input",
        Placeholder = "输入一个数字...",
        Callback = function(input)
            hitboxY = tonumber(input) or 0
            print("Hitbox Y vector set to:", hitboxY)
        end
    })

    Tab:Input({
        Title = "Z 轴向量",
        Value = "0",
        InputIcon = "bird",
        Type = "Input",
        Placeholder = "输入一个数字...",
        Callback = function(input)
            hitboxZ = tonumber(input) or 0
            print("Hitbox Z vector set to:", hitboxZ)
        end
    })

    Tab:Dropdown({
        Title = "扩展方法",
        Values = {"Add", "Set"},
        Value = "Add",
        Multi = false,
        AllowNone = false,
        Callback = function(option)
            expansionMethod = option
            print("Hitbox method set to:", expansionMethod)
        end
    })

    Tab:Button({
        Title = "应用碰撞箱修改",
        Desc = nil,
        Locked = false,
        Callback = function()
            applySigmaHitbox(hitboxX, hitboxY, hitboxZ)
            isHitboxExpanded = true
        end
    })

    Tab:Button({
        Title = "小幅扩展 (+5范围)",
        Desc = nil,
        Locked = false,
        Callback = function()
            hitboxX, hitboxY, hitboxZ = 5, 5, 5
            applySigmaHitbox(hitboxX, hitboxY, hitboxZ)
            isHitboxExpanded = true
        end
    })

    Tab:Button({
        Title = "中幅扩展 (+10范围)",
        Desc = nil,
        Locked = false,
        Callback = function()
            hitboxX, hitboxY, hitboxZ = 10, 10, 10
            applySigmaHitbox(hitboxX, hitboxY, hitboxZ)
            isHitboxExpanded = true
        end
    })

    Tab:Button({
        Title = "大幅扩展 (+20范围)",
        Desc = nil,
        Locked = false,
        Callback = function()
            hitboxX, hitboxY, hitboxZ = 20, 20, 20
            applySigmaHitbox(hitboxX, hitboxY, hitboxZ)
            isHitboxExpanded = true
        end
    })

    local LockTab = Window:Tab({
        Title = "锁人",
        Icon = "target",
        Locked = false,
    })

    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local localPlayer = Players.LocalPlayer

    local BEHIND_DISTANCE = 5

    local followEnabled   = false
    local circleEnabled   = false
    local lookEnabled     = false

    local selectedTargetName = nil

    local followConnection  = nil
    local circleConnection  = nil
    local lookConnection    = nil

    local circleRadius = 6
    local circleSpeed  = 13
    local circleAngle  = 0

    local function getHRP(player)
        if player and player.Character then
            return player.Character:FindFirstChild("HumanoidRootPart")
        end
    end

    local function getPlayerByName(name)
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name == name then
                return p
            end
        end
    end

    local function startFollow()
        followConnection = RunService.Heartbeat:Connect(function()
            if not followEnabled then return end
            local myHRP   = getHRP(localPlayer)
            local target  = getPlayerByName(selectedTargetName)
            local targetHRP = target and getHRP(target)
            if myHRP and targetHRP then
                local pos = targetHRP.Position - targetHRP.CFrame.LookVector * BEHIND_DISTANCE
                myHRP.CFrame = CFrame.new(pos.X, targetHRP.Position.Y, pos.Z)
            end
        end)
    end

    local function startCircle()
        circleConnection = RunService.Heartbeat:Connect(function(dt)
            if not circleEnabled then return end
            local myHRP   = getHRP(localPlayer)
            local target  = getPlayerByName(selectedTargetName)
            local targetHRP = target and getHRP(target)
            if myHRP and targetHRP then
                circleAngle = circleAngle + circleSpeed * dt
                local x = math.cos(circleAngle) * circleRadius
                local z = math.sin(circleAngle) * circleRadius
                local p = targetHRP.Position + Vector3.new(x, 0, z)
                myHRP.CFrame = CFrame.new(p.X, targetHRP.Position.Y, p.Z)
            end
        end)
    end

    local function startLook()
        lookConnection = RunService.Heartbeat:Connect(function()
            if not lookEnabled then return end
            local myHRP   = getHRP(localPlayer)
            local target  = getPlayerByName(selectedTargetName)
            local targetHRP = target and getHRP(target)
            if myHRP and targetHRP then
                local myPos = myHRP.Position
                local tp    = targetHRP.Position
                myHRP.CFrame = CFrame.new(myPos, Vector3.new(tp.X, myPos.Y, tp.Z))
            end
        end)
    end

    local function stopConnections()
        if followConnection then followConnection:Disconnect() end
        if circleConnection then circleConnection:Disconnect() end
        if lookConnection   then lookConnection:Disconnect()   end
        followConnection = nil
        circleConnection = nil
        lookConnection   = nil
        circleAngle      = 0
    end

    local playerDropdown = LockTab:Dropdown({
        Title = "选择目标玩家",
        Multi = false,
        AllowNone = false,
        Value = nil,
        Values = (function()
            local names = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= localPlayer then
                    table.insert(names, p.Name)
                end
            end
            return names
        end)(),
        Callback = function(name)
            selectedTargetName = name
        end
    })

    LockTab:Button({
        Title = "刷新玩家列表",
        Callback = function()
            selectedTargetName = nil
            playerDropdown:Destroy()
            playerDropdown = LockTab:Dropdown({
                Title = "选择目标玩家",
                Multi = false,
                AllowNone = false,
                Value = nil,
                Values = (function()
                    local names = {}
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= localPlayer then
                            table.insert(names, p.Name)
                        end
                    end
                    return names
                end)(),
                Callback = function(name)
                    selectedTargetName = name
                end
            })
        end
    })

    LockTab:Toggle({
        Title = "锁背",
        Value = false,
        Callback = function(state)
            followEnabled = state
            if state and not followConnection then startFollow() end
            if not state then stopConnections() end
        end
    })

    LockTab:Toggle({
        Title = "转圈",
        Value = false,
        Callback = function(state)
            circleEnabled = state
            if state and not circleConnection then startCircle() end
            if not state then stopConnections() end
        end
    })

    LockTab:Toggle({
        Title = "看着玩家(需要关移位锁)",
        Value = false,
        Callback = function(state)
            lookEnabled = state
            if state and not lookConnection then startLook() end
            if not state then stopConnections() end
        end
    })
    local lightningCharacterSwapTab = Window:Tab({
        Title = "快速切换角色",
        Icon = "bird",
        Locked = false,
    })

    local lastPosition

    local function getHumanoidRootPart()
        local character = LocalPlayer.Character
        return character and character:FindFirstChild("HumanoidRootPart")
    end

    local function savePosition()
        local rootPart = getHumanoidRootPart()
        if rootPart then
            lastPosition = rootPart.CFrame
        end
    end

    local function handleKeyPress(characterName)
        savePosition()
        
        local rootPart = getHumanoidRootPart()
        if rootPart then
            rootPart.CFrame = CFrame.new(1011.1289672851562, -1009.359588623046875, 116.37605285644531)
        end

        ReplicatedStorage.Remotes.Character.ChangeCharacter:FireServer(characterName)

        local groundY = workspace.Map.Structural.Ground:GetChildren()[21].Position.Y
        repeat task.wait() until getHumanoidRootPart() and getHumanoidRootPart().Position.Y > groundY
        task.wait(0.15)

        local newRootPart = getHumanoidRootPart()
        if newRootPart and lastPosition then
            repeat
                newRootPart.CFrame = lastPosition
                task.wait(0.1)
            until (newRootPart.Position - lastPosition.Position).Magnitude < 10
        end
    end

    lightningCharacterSwapTab:Button({
        Title = "快速切换成小杰",
        Locked = false,
        Callback = function() handleKeyPress("Gon") end
    })

    lightningCharacterSwapTab:Button({
        Title = "快速切换成被诅咒的导师",
        Locked = false,
        Callback = function() handleKeyPress("Nanami") end
    })

    lightningCharacterSwapTab:Button({
        Title = "快速切换成沉默的艾丝帕",
        Locked = false,
        Callback = function() handleKeyPress("Mob") end
    })
    local env = {}
    env.ReplicatedStorage = game:GetService("ReplicatedStorage")
    env.Players = game:GetService("Players")
    env.LocalPlayer = env.Players.LocalPlayer
    env.core = require(env.ReplicatedStorage:WaitForChild("Core"))
    env.Character = env.LocalPlayer.Character
    env.HumanoidRootPart = env.Character and env.Character:WaitForChild("HumanoidRootPart")
    env.orbitToggle = nil
    env.fakeWallToggle = nil
    env.serverStatus = "goodstate"

    local forceKillEmoteTab = Window:Tab({
        Title = "击杀表情功能",
        Icon = "smile",
        Locked = false,
    })

    local killEmotes = {}
    local isAuraMode = false
    local isSpammingSelectedEmote = false
    local auraDelay = 0.5
    local spamDelay = 0.5
    local selectedEmote = ""
    local selectedKeybind = Enum.KeyCode.G
    local emoteDropdown
    local UserInputService = game:GetService("UserInputService")

    local function getRoot(char)
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function useEmote(emoteName)
        local emoteModule = env.ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote"):FindFirstChild(emoteName)
        local myRoot = getRoot(env.LocalPlayer.Character)
        if not myRoot then return end
        local closestTarget = nil
        local shortestDistance = math.huge
        for _, player in pairs(env.Players:GetPlayers()) do
            if player ~= env.LocalPlayer and player.Character then
                local targetRoot = getRoot(player.Character)
                if targetRoot then
                    local distance = (myRoot.Position - targetRoot.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestTarget = player.Character
                    end
                end
            end
        end
        if closestTarget and emoteModule then
            task.spawn(function()
                _G.KillEmote = true
                pcall(function()
                    if env.core and env.core.Get then
                        env.core.Get("Combat", "Ability").Activate(emoteModule, closestTarget)
                    end
                end)
                _G.KillEmote = false
            end)
        end
    end

    local function useRandomEmote()
        if #killEmotes > 0 then
            local randomEmote = killEmotes[math.random(1, #killEmotes)]
            useEmote(randomEmote)
        end
    end

    task.spawn(function()
        while true do
            if isAuraMode then
                useRandomEmote()
                task.wait(auraDelay)
            else
                task.wait(0.5)
            end
        end
    end)

    task.spawn(function()
        while true do
            if isSpammingSelectedEmote and selectedEmote ~= "" then
                useEmote(selectedEmote)
                task.wait(spamDelay)
            else
                task.wait(0.5)
            end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, isGameProcessed)
        if isGameProcessed then return end
        if input.KeyCode == selectedKeybind and selectedEmote ~= "" then
            useEmote(selectedEmote)
        end
    end)

    local function createOrUpdateEmoteDropdown(emoteList)
        local values = emoteList
        if not values or #values == 0 then
            values = {"No emotes found"}
        end
        emoteDropdown = forceKillEmoteTab:Dropdown({
            Title = "击杀表情功能(要靠近别人)",
            Values = values,
            Multi = false,
            AllowNone = false,
            Callback = function(option)
                if option ~= "No emotes found" then
                    selectedEmote = option
                    useEmote(option)
                end
            end
        })
    end

    forceKillEmoteTab:Button({
        Title = "刷新击杀表情",
        Desc = "刷新可用的击杀表情",
        Callback = function()
            local currentEmotes = {}
            for _, emote in pairs(env.ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote"):GetChildren()) do
                table.insert(currentEmotes, emote.Name)
            end
            killEmotes = currentEmotes
            createOrUpdateEmoteDropdown(killEmotes)
        end
    })

    for _, emote in pairs(env.ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote"):GetChildren()) do
        table.insert(killEmotes, emote.Name)
    end

    createOrUpdateEmoteDropdown(killEmotes)

    forceKillEmoteTab:Toggle({
        Title = "击杀表情光环",
        Desc = "对旁边的人持续使用随机的击杀表情",
        Icon = "bird",
        Type = "Checkbox",
        Default = false,
        Callback = function(isEnabled)
            isAuraMode = isEnabled
        end
    })

    forceKillEmoteTab:Slider({
        Title = "击杀表情光环间隔",
        Step = 0.01,
        Value = { Min = 0.01, Max = 5.0, Default = 0.5 },
        Callback = function(value)
            auraDelay = value
        end
    })

    forceKillEmoteTab:Toggle({
        Title = "持续发送你选择的表情",
        Desc = "持续发送当前选择的表情",
        Icon = "bird",
        Type = "Checkbox",
        Default = false,
        Callback = function(isEnabled)
            isSpammingSelectedEmote = isEnabled
        end
    })

    forceKillEmoteTab:Slider({
        Title = "调整你选择的表情速度",
        Step = 0.01,
        Value = { Min = 0.01, Max = 5.0, Default = 0.5 },
        Callback = function(value)
            spamDelay = value
        end
    })

    local emoteKeybindOptions = { "G", "F", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", "Q", "E", "R", "T", "Y", "U", "I", "O", "P" }
    local emoteKeybindMap = {
        ["G"] = Enum.KeyCode.G, ["F"] = Enum.KeyCode.F, ["H"] = Enum.KeyCode.H,
        ["J"] = Enum.KeyCode.J, ["K"] = Enum.KeyCode.K, ["L"] = Enum.KeyCode.L,
        ["Z"] = Enum.KeyCode.Z, ["X"] = Enum.KeyCode.X, ["C"] = Enum.KeyCode.C,
        ["V"] = Enum.KeyCode.V, ["B"] = Enum.KeyCode.B, ["N"] = Enum.KeyCode.N,
        ["M"] = Enum.KeyCode.M, ["Q"] = Enum.KeyCode.Q, ["E"] = Enum.KeyCode.E,
        ["R"] = Enum.KeyCode.R, ["T"] = Enum.KeyCode.T, ["Y"] = Enum.KeyCode.Y,
        ["U"] = Enum.KeyCode.U, ["I"] = Enum.KeyCode.I, ["O"] = Enum.KeyCode.O,
        ["P"] = Enum.KeyCode.P
    }

    forceKillEmoteTab:Dropdown({
        Title = "快捷键设置",
        Values = emoteKeybindOptions,
        Value = "G",
        Multi = false,
        AllowNone = false,
        Callback = function(option)
            selectedKeybind = emoteKeybindMap[option]
        end
    })

    forceKillEmoteTab:Button({
        Title = "随机用一个击杀表情",
        Desc = "字面意思",
        Locked = false,
        Callback = function()
            useRandomEmote()
        end
    })
    local Tab = Window:Tab({
        Title = "设置",
        Icon = "settings",
        Locked = false,
    })
    local themeValues = {}
    for name, _ in pairs(WindUI:GetThemes()) do
        table.insert(themeValues, name)
    end

    Tab:Dropdown({
        Title = "更改ui颜色",
        Multi = false,
        AllowNone = false,
        Value = nil,
        Values = themeValues,
        Callback = function(theme)
            WindUI:SetTheme(theme)
        end
    })
end

qw()  -- 执行终极战场功能