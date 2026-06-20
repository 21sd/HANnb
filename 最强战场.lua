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
    Title = "最强战场",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "最强战场",
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

-- FIN-Ui 功能加载标志
local finUILoaded = false

-- ========== FIN-Ui 功能加载 ==========
local function loadFINUIFeatures()
    if finUILoaded then
        WindUI:Notify({ Title = "提示", Content = "最强战场功能已加载", Duration = 3, Icon = "info" })
        return
    end
    finUILoaded = true

    -- 重新获取服务（避免依赖外部变量）
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    local function T(str)
        return str
    end

    -- 全局状态（原脚本中的 GlobalState）
    local GlobalState = {
        OriginalCFrame = nil,
        BCXZJHYT = false,
        AUTO_TRASH_MASTER = false,
        AttackAura = false,
        AutoFight = false,
        ZDGJT = false,
        AutoUltimate = false,
        ELZRCSXKT = false,
        ZDNLJTT = false,
        awdawdwaT = false,
        AutoParry = false,
        YCDSHYT = false,
        TrashCanPositions = {},
        CurrentTrashIndex = 0,
        AutoKillEnabled = false,
        TargetKills = 0,
        TargetTotalKills = 0,
        TargetPlayer = nil,
        AutoTargetAttack = false,
        PlayerList = {},
        LoopLaunchEnabled = false,
        LoopLaunchPower = 100,
        LoopTeleportEnabled = false,
        LoopTeleportDistance = 50,
        WalkSpeedMultiplier = 1,
        JumpPowerMultiplier = 1,
        GravityMultiplier = 1,
        ParryDelay = 0,
        ParryRange = 25,
        NoclipEnabled = false
    }

    -- Core 工具函数
    local Core = {}
    function Core.GetCharacterParts(player)
        local plr = player or LocalPlayer
        local char = plr.Character
        if not char then return nil, nil, nil, nil end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        local comm = char:FindFirstChild("Communicate")
        return char, root, hum, comm
    end

    function Core.FindBestTarget(maxDistance)
        maxDistance = maxDistance or math.huge
        local bestTarget = nil
        local minKills = math.huge
        local char, root = Core.GetCharacterParts()
        if not root then return nil end

        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local pChar, pRoot, pHum = Core.GetCharacterParts(player)
            if not pRoot or not pHum or pHum.Health <= 0 then continue end
            if GlobalState.BCXZJHYT and player:IsFriendsWith(LocalPlayer.UserId) then continue end

            local distance = (root.Position - pRoot.Position).Magnitude
            local kills = player:GetAttribute("Kills") or 0

            if distance < maxDistance and kills < minKills then
                bestTarget = player
                maxDistance = distance
                minKills = kills
            end
        end
        return bestTarget
    end

    function Core.UseAbility(abilityName)
        local char, _, _, comm = Core.GetCharacterParts()
        if not comm then return end
        local tool = LocalPlayer.Backpack:FindFirstChild(abilityName)
        if not tool then return end

        comm:FireServer({
            Tool = tool,
            Goal = "Console Move",
            ToolName = abilityName
        })
    end

    function Core.GetRandomAbility()
        local hotbar = LocalPlayer.PlayerGui:FindFirstChild("Hotbar")
        if not hotbar then return nil end
        local hotbarContainer = hotbar.Backpack:FindFirstChild("Hotbar")
        if not hotbarContainer then return nil end

        local availableAbilities = {}
        for _, slot in pairs(hotbarContainer:GetChildren()) do
            if slot:IsA("GuiObject") and slot.Visible then
                local toolName = slot.Base:FindFirstChild("ToolName")
                local cooldown = slot.Base:FindFirstChild("Cooldown")
                if toolName and toolName.Text ~= "N/A" and not cooldown then
                    table.insert(availableAbilities, toolName.Text)
                end
            end
        end

        if #availableAbilities == 0 then return nil end
        return availableAbilities[math.random(1, #availableAbilities)]
    end

    function Core.ActivateUltimate()
        local ultimate = LocalPlayer:GetAttribute("Ultimate") or 0
        if ultimate < 100 then return end
        local _, _, _, comm = Core.GetCharacterParts()
        if not comm then return end
        comm:FireServer({
            MoveDirection = Vector3.new(0, 0, 0),
            Key = Enum.KeyCode.G,
            Goal = "KeyPress"
        })
    end

    function Core.TeleportUnderPlayer(player, offset)
        local pChar, pRoot = Core.GetCharacterParts(player)
        local char, root = Core.GetCharacterParts()
        if not pRoot or not root then return end
        local off = offset or Vector3.new(0, -5, 0)
        local targetCFrame = pRoot.CFrame:ToWorldSpace(CFrame.new(off))
        if char.PrimaryPart then
            char:SetPrimaryPartCFrame(targetCFrame)
        else
            root.CFrame = targetCFrame
        end
    end

    -- 辅助函数
    local function UpdatePlayerList()
        GlobalState.PlayerList = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(GlobalState.PlayerList, player.Name)
            end
        end
    end

    local function DetectTrashCanPositions()
        GlobalState.TrashCanPositions = {}
        local trashFolders = {
            Workspace:FindFirstChild("Trash"),
            Workspace.Map and Workspace.Map:FindFirstChild("Trash")
        }
        for _, folder in pairs(trashFolders) do
            if not folder then continue end
            for _, trash in pairs(folder:GetChildren()) do
                if not trash:IsA("Model") then continue end
                local part = trash:FindFirstChild("Handle") or trash.PrimaryPart or trash:FindFirstChildWhichIsA("BasePart")
                if part then
                    table.insert(GlobalState.TrashCanPositions, part.Position)
                end
            end
        end
        GlobalState.CurrentTrashIndex = 0
        if #GlobalState.TrashCanPositions > 0 then
            WindUI:Notify({
                Title = T("垃圾桶检测完成"),
                Content = T("共找到 " .. #GlobalState.TrashCanPositions .. " 个垃圾桶"),
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = T("检测失败"),
                Content = T("未找到任何垃圾桶"),
                Duration = 2
            })
        end
    end

    local function TeleportToNextTrashCan()
        if #GlobalState.TrashCanPositions == 0 then
            WindUI:Notify({
                Title = T("错误"),
                Content = T("请先执行垃圾桶坐标检测"),
                Duration = 2
            })
            return
        end
        GlobalState.CurrentTrashIndex = (GlobalState.CurrentTrashIndex % #GlobalState.TrashCanPositions) + 1
        local targetPos = GlobalState.TrashCanPositions[GlobalState.CurrentTrashIndex]
        local char, root = Core.GetCharacterParts()
        if root then
            root.CFrame = CFrame.new(targetPos)
            WindUI:Notify({
                Title = T("传送成功"),
                Content = T("已传送到第" .. GlobalState.CurrentTrashIndex .. "个垃圾桶"),
                Duration = 2
            })
        end
    end

    local function RunAutoTrashMaster()
        while GlobalState.AUTO_TRASH_MASTER do
            pcall(function()
                local char, root, hum = Core.GetCharacterParts()
                if not char or not hum or hum.Health <= 0 then
                    task.wait(1)
                    return
                end
                if not char:GetAttribute("HasTrashcan") then
                    local trashFolder = Workspace:FindFirstChild("Trash") or Workspace.Map and Workspace.Map:FindFirstChild("Trash")
                    if not trashFolder then
                        task.wait(1)
                        return
                    end
                    local nearestTrash = nil
                    local nearestDist = math.huge
                    local trashPos = nil
                    for _, trash in pairs(trashFolder:GetChildren()) do
                        if not GlobalState.AUTO_TRASH_MASTER then break end
                        if not trash:IsA("Model") then continue end
                        local part = trash:FindFirstChild("Handle") or trash.PrimaryPart or trash:FindFirstChildWhichIsA("BasePart")
                        if not part then continue end
                        local dist = (root.Position - part.Position).Magnitude
                        if dist <= 15 and dist < nearestDist then
                            nearestDist = dist
                            nearestTrash = trash
                            trashPos = part.Position
                        end
                    end
                    if nearestTrash and trashPos then
                        local dir = (trashPos - root.Position).Unit
                        local targetPos = trashPos + (dir * 2)
                        root.CFrame = CFrame.lookAt(targetPos, trashPos)
                        task.wait(0.2)
                        local comm = char:FindFirstChild("Communicate")
                        if comm then
                            comm:FireServer({Goal = "LeftClick"})
                            task.wait(0.15)
                            comm:FireServer({Goal = "LeftClickRelease"})
                        end
                        local waitTimer = 0
                        while waitTimer < 2 and not char:GetAttribute("HasTrashcan") do
                            task.wait(0.1)
                            waitTimer = waitTimer + 0.1
                        end
                    else
                        task.wait(1)
                    end
                else
                    local target = Core.FindBestTarget(100)
                    if not target then
                        task.wait(1)
                        return
                    end
                    local pChar, pRoot = Core.GetCharacterParts(target)
                    if not pRoot then return end
                    local lookDir = pRoot.CFrame.LookVector
                    lookDir = Vector3.new(lookDir.X, 0, lookDir.Z).Unit
                    local behindPos = pRoot.Position - (lookDir * 2)
                    root.CFrame = CFrame.lookAt(behindPos, pRoot.Position)
                    task.wait(0.2)
                    local comm = char:FindFirstChild("Communicate")
                    if comm then
                        comm:FireServer({Goal = "LeftClick"})
                        task.wait(0.1)
                        comm:FireServer({Goal = "LeftClickRelease"})
                    end
                    task.wait(1.5)
                end
            end)
            task.wait(0.1)
        end
    end

    local function RunAutoParry()
        local AnimConfig = {
            Attacks = {
                ["rbxassetid://10469493270"] = {Start = 0, End = 0.30},
                ["rbxassetid://10469630950"] = {Start = 0, End = 0.30}
            },
            Dodges = {
                ["rbxassetid://10479335397"] = {Start = 0, End = 0.50}
            },
            Barrages = {
                ["rbxassetid://10466974800"] = {Start = 0.20, End = 1.80}
            },
            Abilities = {
                ["rbxassetid://10468665991"] = {Start = 0.15, End = 0.60}
            }
        }
        local isParrying = false
        local parryCooldown = 0.2
        local function PerformParry(animType)
            if isParrying or not GlobalState.AutoParry then return end
            isParrying = true
            task.wait(GlobalState.ParryDelay or 0)
            local char, _, _, comm = Core.GetCharacterParts()
            if comm then
                comm:FireServer({Goal = "KeyPress", Key = Enum.KeyCode.F})
                local holdTime = animType == "Barrage" and 0.9 or animType == "Ability" and 0.3 or 0.1
                task.wait(holdTime)
                comm:FireServer({Goal = "KeyRelease", Key = Enum.KeyCode.F})
            end
            task.wait(parryCooldown)
            isParrying = false
        end
        while GlobalState.AutoParry do
            pcall(function()
                local char, root = Core.GetCharacterParts()
                if not char or not root then
                    task.wait(0.1)
                    return
                end
                for _, player in pairs(Players:GetPlayers()) do
                    if not GlobalState.AutoParry then break end
                    if player == LocalPlayer then continue end
                    local pChar, pRoot, pHum = Core.GetCharacterParts(player)
                    if not pChar or not pRoot or not pHum or pHum.Health <= 0 then continue end
                    local dist = (root.Position - pRoot.Position).Magnitude
                    if dist > (GlobalState.ParryRange or 25) then continue end
                    local animator = pHum:FindFirstChild("Animator")
                    if not animator then continue end
                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                        local animId = track.Animation and track.Animation.AnimationId
                        local timePos = track.TimePosition
                        if AnimConfig.Attacks[animId] then
                            local cfg = AnimConfig.Attacks[animId]
                            if timePos >= cfg.Start and timePos <= cfg.End then
                                task.spawn(PerformParry, "Attack")
                                task.wait(parryCooldown)
                                break
                            end
                        elseif AnimConfig.Dodges[animId] then
                            local cfg = AnimConfig.Dodges[animId]
                            if timePos >= cfg.Start and timePos <= cfg.End then
                                task.spawn(PerformParry, "Dodge")
                                task.wait(parryCooldown)
                                break
                            end
                        elseif AnimConfig.Barrages[animId] then
                            local cfg = AnimConfig.Barrages[animId]
                            if timePos >= cfg.Start and timePos <= cfg.End then
                                task.spawn(PerformParry, "Barrage")
                                task.wait(parryCooldown)
                                break
                            end
                        elseif AnimConfig.Abilities[animId] then
                            local cfg = AnimConfig.Abilities[animId]
                            if timePos >= cfg.Start and timePos <= cfg.End then
                                task.spawn(PerformParry, "Ability")
                                task.wait(parryCooldown)
                                break
                            end
                        end
                    end
                end
            end)
            task.wait(0.05)
        end
    end

    local function RunAutoKillSetter()
        while GlobalState.AutoKillEnabled do
            pcall(function()
                local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                if not leaderstats then return end
                local kills = leaderstats:FindFirstChild("Kills")
                local totalKills = leaderstats:FindFirstChild("Total Kills")
                if kills and kills:IsA("NumberValue") then
                    kills.Value = GlobalState.TargetKills
                end
                if totalKills and totalKills:IsA("NumberValue") then
                    totalKills.Value = GlobalState.TargetTotalKills
                end
            end)
            task.wait(0.1)
        end
    end

    local function RunAutoTargetAttack()
        while GlobalState.AutoTargetAttack and GlobalState.TargetPlayer do
            pcall(function()
                local targetPlayer = Players:FindFirstChild(GlobalState.TargetPlayer)
                if not targetPlayer then return end
                local pChar, pRoot, pHum = Core.GetCharacterParts(targetPlayer)
                local char, root, hum = Core.GetCharacterParts()
                if not pRoot or not root or not hum or hum.Health <= 0 or not pHum or pHum.Health <= 0 then
                    task.wait(0.5)
                    return
                end
                Core.TeleportUnderPlayer(targetPlayer, Vector3.new(0, -3, 2))
                task.wait(0.1)
                local comm = char:FindFirstChild("Communicate")
                if comm then
                    comm:FireServer({Goal = "LeftClick"})
                    task.wait(0.05)
                    comm:FireServer({Goal = "LeftClickRelease"})
                end
                task.wait(0.2)
            end)
            task.wait(0.1)
        end
    end

    local function LoopLaunch()
        while GlobalState.LoopLaunchEnabled do
            local char, root = Core.GetCharacterParts()
            if char and root then
                root.Velocity = Vector3.new(math.random(-GlobalState.LoopLaunchPower, GlobalState.LoopLaunchPower), math.random(-GlobalState.LoopLaunchPower, GlobalState.LoopLaunchPower), math.random(-GlobalState.LoopLaunchPower, GlobalState.LoopLaunchPower))
            end
            task.wait(0.1)
        end
    end

    local function LoopTeleport()
        while GlobalState.LoopTeleportEnabled do
            local char, root = Core.GetCharacterParts()
            if char and root then
                local randomPos = root.Position + Vector3.new(math.random(-GlobalState.LoopTeleportDistance, GlobalState.LoopTeleportDistance), 0, math.random(-GlobalState.LoopTeleportDistance, GlobalState.LoopTeleportDistance))
                root.CFrame = CFrame.new(randomPos)
            end
            task.wait(0.2)
        end
    end

    local function UpdateMovementValues()
        local char, _, hum = Core.GetCharacterParts()
        if not hum then return end
        local originalWalkSpeed = hum.WalkSpeed / GlobalState.WalkSpeedMultiplier
        local originalJumpPower = hum.JumpPower / GlobalState.JumpPowerMultiplier
        hum.WalkSpeed = originalWalkSpeed * GlobalState.WalkSpeedMultiplier
        hum.JumpPower = originalJumpPower * GlobalState.JumpPowerMultiplier
        workspace.Gravity = 196.2 * GlobalState.GravityMultiplier
    end

    local function Noclip()
        local noclipConnection
        noclipConnection = RunService.Stepped:Connect(function()
            if not GlobalState.NoclipEnabled then
                noclipConnection:Disconnect()
                return
            end
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end

    -- 创建窗口标签（原脚本中的时间标签等）
    local TimeTag = Window:Tag({
        Title = "00:00",
        Color = Color3.fromHex("#30ff6a")
    })

    local hue = 0
    task.spawn(function()
        while true do
            local now = os.date("*t")
            local hours = string.format("%02d", now.hour)
            local minutes = string.format("%02d", now.min)
            hue = (hue + 0.01) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            TimeTag:SetTitle(hours .. ":" .. minutes)
            TimeTag:SetColor(color)
            task.wait(0.06)
        end
    end)

    -- 创建三个主标签页
    local StrongBattleTab = Window:Tab({
        Title = T("最强战场"),
        Icon = "bird",
        Locked = false
    })

    local TeleportLaunchTab = Window:Tab({
        Title = "传送与甩飞",
        Icon = "rocket",
        Locked = false
    })

    local GeneralTab = Window:Tab({
        Title = "通用",
        Icon = "settings",
        Locked = false
    })

    -- ===== 最强战场标签页内容 =====
    StrongBattleTab:Dropdown({
        Title = T("传送位置"),
        Values = {T("原图"), T("山上"), T("一拳超人开大"), T("切原子")},
        Value = T("原图"),
        Callback = function(option)
            local char, root = Core.GetCharacterParts()
            if not root then return end
            local cframes = {
                [T("原图")] = CFrame.new(63.4928513, 440.505829, -92.9229507),
                [T("山上")] = CFrame.new(253.515198, 699.103455, 420.533813),
                [T("一拳超人开大")] = CFrame.new(-62, 29, 20338),
                [T("切原子")] = CFrame.new(1068, 133, 23015)
            }
            root.CFrame = cframes[option] or cframes[T("原图")]
        end
    })

    StrongBattleTab:Button({
        Title = T("设置原位"),
        Desc = T("设置原本的位置"),
        Callback = function()
            local char, root = Core.GetCharacterParts()
            if not root then return end
            GlobalState.OriginalCFrame = root.CFrame
            WindUI:Notify({
                Title = T("设置成功"),
                Content = T("已保存当前位置为原位"),
                Duration = 2
            })
        end
    })

    StrongBattleTab:Button({
        Title = T("传送原位"),
        Desc = T("传送到原位"),
        Callback = function()
            local char, root = Core.GetCharacterParts()
            if not root or not GlobalState.OriginalCFrame then 
                WindUI:Notify({
                    Title = T("错误"),
                    Content = T("未设置原位"),
                    Duration = 2
                })
                return 
            end
            root.CFrame = GlobalState.OriginalCFrame
            WindUI:Notify({
                Title = T("传送成功"),
                Content = T("已返回原位"),
                Duration = 2
            })
        end
    })

    StrongBattleTab:Button({
        Title = T("传送虚空"),
        Desc = T("建议使用英雄猎人三技能快结束的时候点击此功能可以将人扔到虚空里"),
        Icon = "teleport",
        Callback = function()
            local char, root = Core.GetCharacterParts()
            if not root then return end
            root.CFrame = CFrame.new(-774.454834, -137.237228, 126.384216)
            WindUI:Notify({
                Title = T("传送成功"),
                Content = T("已传送到虚空"),
                Duration = 2
            })
        end
    })

    StrongBattleTab:Paragraph({
        Title = T("指定目标攻击"),
        Desc = T("选择玩家后循环攻击"),
        Color = "Red"
    })

    local playerDropdown
    UpdatePlayerList()
    playerDropdown = StrongBattleTab:Dropdown({
        Title = T("选择目标玩家"),
        Values = GlobalState.PlayerList,
        Value = GlobalState.PlayerList[1] or T("无玩家"),
        Callback = function(selected)
            GlobalState.TargetPlayer = selected
        end
    })

    StrongBattleTab:Button({
        Title = T("刷新玩家列表"),
        Desc = T("更新当前在线玩家"),
        Icon = "refresh",
        Callback = function()
            UpdatePlayerList()
            playerDropdown:SetValues(GlobalState.PlayerList)
            playerDropdown:SetValue(GlobalState.PlayerList[1] or T("无玩家"))
            WindUI:Notify({
                Title = T("刷新完成"),
                Content = T("共找到 " .. #GlobalState.PlayerList .. " 名其他玩家"),
                Duration = 2
            })
        end
    })

    StrongBattleTab:Toggle({
        Title = T("启动指定目标攻击"),
        Desc = T("循环传送至目标并攻击"),
        Default = false,
        Callback = function(state)
            GlobalState.AutoTargetAttack = state
            if state and GlobalState.TargetPlayer then
                WindUI:Notify({
                    Title = T("已启动"),
                    Content = T("已开始攻击目标: " .. GlobalState.TargetPlayer),
                    Duration = 2
                })
                task.spawn(RunAutoTargetAttack)
            else
                GlobalState.AutoTargetAttack = false
                WindUI:Notify({
                    Title = T("已停止"),
                    Content = T("指定目标攻击已关闭"),
                    Duration = 2
                })
            end
        end
    })

    StrongBattleTab:Paragraph({
        Title = T("垃圾桶功能"),
        Desc = T("检测与循环传送"),
        Color = "Orange"
    })

    StrongBattleTab:Button({
        Title = T("检测所有垃圾桶坐标"),
        Desc = T("扫描场景内所有垃圾桶位置"),
        Icon = "search",
        Callback = function()
            task.spawn(DetectTrashCanPositions)
        end
    })

    StrongBattleTab:Button({
        Title = T("传送到下一个垃圾桶"),
        Desc = T("点击循环切换所有垃圾桶"),
        Icon = "location",
        Callback = function()
            task.spawn(TeleportToNextTrashCan)
        end
    })

    StrongBattleTab:Toggle({
        Title = T("不朝向好友"),
        Desc = T("自动朝向不朝向好友"),
        Default = false,
        Callback = function(state)
            GlobalState.BCXZJHYT = state
            WindUI:Notify({
                Title = T("设置成功"),
                Content = state and T("已开启不朝向好友") or T("已关闭不朝向好友"),
                Duration = 2
            })
        end
    })

    StrongBattleTab:Toggle({
        Title = T("自动垃圾桶"),
        Desc = T("拾取+传送最近玩家身后+攻击"),
        Default = false,
        Callback = function(state)
            GlobalState.AUTO_TRASH_MASTER = state
            if state then
                WindUI:Notify({
                    Title = T("已启动"),
                    Content = T("自动垃圾桶功能已开启"),
                    Duration = 2
                })
                task.spawn(RunAutoTrashMaster)
            else
                WindUI:Notify({
                    Title = T("已停止"),
                    Content = T("自动垃圾桶功能已关闭"),
                    Duration = 2
                })
            end
        end
    })

    StrongBattleTab:Toggle({
        Title = T("攻击光环"),
        Desc = T("其他玩家靠近自动攻击"),
        Default = false,
        Callback = function(state)
            GlobalState.AttackAura = state
            if state then
                WindUI:Notify({
                    Title = T("已启动"),
                    Content = T("攻击光环功能已开启"),
                    Duration = 2
                })
                RunService.RenderStepped:Connect(function()
                    if not GlobalState.AttackAura then return end
                    local NearestTarget = Core.FindBestTarget(5)
                    if NearestTarget then
                        Core.TeleportUnderPlayer(NearestTarget)
                        local RandomAbility = Core.GetRandomAbility()
                        if RandomAbility then
                            Core.UseAbility(RandomAbility)
                        elseif GlobalState.AutoUltimate then
                            Core.ActivateUltimate()
                        end
                    end
                end)
            else
                WindUI:Notify({
                    Title = T("已停止"),
                    Content = T("攻击光环功能已关闭"),
                    Duration = 2
                })
            end
        end
    })

    StrongBattleTab:Toggle({
        Title = T("自动战斗"),
        Desc = T("角色自动战斗"),
        Default = false,
        Callback = function(state)
            GlobalState.AutoFight = state
            if state then
                WindUI:Notify({
                    Title = T("已启动"),
                    Content = T("自动战斗功能已开启"),
                    Duration = 2
                })
                RunService.RenderStepped:Connect(function()
                    if not GlobalState.AutoFight then return end
                    local BestTarget = Core.FindBestTarget()
                    if BestTarget then
                        Core.TeleportUnderPlayer(BestTarget)
                        local RandomAbility = Core.GetRandomAbility()
                        if RandomAbility then
                            Core.UseAbility(RandomAbility)
                        elseif GlobalState.AutoUltimate then
                            Core.ActivateUltimate()
                        end
                    end
                end)
            else
                WindUI:Notify({
                    Title = T("已停止"),
                    Content = T("自动战斗功能已关闭"),
                    Duration = 2
                })
            end
        end
    })

    StrongBattleTab:Toggle({
        Title = T("自动攻击"),
        Desc = T("角色自动攻击"),
        Default = false,
        Callback = function(state)
            GlobalState.ZDGJT = state
            if state then
                WindUI:Notify({
                    Title = T("已启动"),
                    Content = T("自动攻击功能已开启"),
                    Duration = 2
                })
                task.spawn(function()
                    while GlobalState.ZDGJT do
                        pcall(function()
                            local char, _, _, comm = Core.GetCharacterParts()
                            if not comm then
                                task.wait(0.5)
                                return
                            end
                            comm:FireServer({Goal = "LeftClick"})
                            task.wait(0.05)
                            comm:FireServer({Goal = "LeftClickRelease"})
                            task.wait(0.3)
                        end)
                    end
                end)
            else
                WindUI:Notify({
                    Title = T("已停止"),
                    Content = T("自动攻击功能已关闭"),
                    Duration = 2
                })
            end
        end
    })

    StrongBattleTab:Toggle({
        Title = T("自动开大"),
        Desc = T("角色自动使用终极"),
        Default = false,
        Callback = function(state)
            GlobalState.AutoUltimate = state
            WindUI:Notify({
                Title = T("设置成功"),
                Content = state and T("已开启自动开大") or T("已关闭自动开大"),
                Duration = 2
            })
        end
    })

    StrongBattleTab:Toggle({
        Title = T("抓人传虚空"),
        Desc = T("使用技能后自动传送目标到虚空"),
        Default = false,
        Callback = function(state)
            GlobalState.ELZRCSXKT = state
            if state then
                WindUI:Notify({
                    Title = T("已启动"),
                    Content = T("抓人传虚空功能已开启"),
                    Duration = 2
                })
                LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
                    if not tool:IsA("Tool") or tool.Name ~= "Lethal Whirlwind Stream" then return end
                    tool.Equipped:Connect(function()
                        local char, root = Core.GetCharacterParts()
                        if not root then return end
                        local target = Core.FindBestTarget(10)
                        if not target then return end
                        local pChar, pRoot = Core.GetCharacterParts(target)
                        if not pRoot then return end
                        local originalCFrame = pRoot.CFrame
                        task.wait(1)
                        pRoot.CFrame = CFrame.new(-62, 29, 20338)
                        task.wait(3)
                        pRoot.CFrame = originalCFrame
                    end)
                end)
            else
                WindUI:Notify({
                    Title = T("已停止"),
                    Content = T("抓人传虚空功能已关闭"),
                    Duration = 2
                })
            end
        end
    })


StrongBattleTab:Toggle({
    Title = T("自动拿垃圾桶"),
    Desc = T("角色自动面向并拿垃圾桶"),
    Default = false,
    Callback = function(state)
        GlobalState.ZDNLJTT = state
        if state then
            WindUI:Notify({
                Title = T("已启动"),
                Content = T("自动拿垃圾桶功能已开启"),
                Duration = 2
            })
            task.spawn(function()
                while GlobalState.ZDNLJTT do
                    pcall(function()
                        local char, root, _, comm = Core.GetCharacterParts()
                        if not char or not root or not comm then
                            task.wait(0.5)
                            return
                        end
                        if char:GetAttribute("HasTrashcan") then
                            task.wait(0.5)
                            return
                        end
                        local trashFolder = Workspace:FindFirstChild("Trash") or (Workspace.Map and Workspace.Map:FindFirstChild("Trash"))
                        if not trashFolder then
                            task.wait(0.5)
                            return
                        end
                        local nearestTrash = nil
                        local nearestDist = 10
                        local trashPos = nil
                        for _, trash in pairs(trashFolder:GetChildren()) do
                            if not GlobalState.ZDNLJTT then break end
                            if not trash:IsA("Model") then continue end
                            local part = trash:FindFirstChild("Handle") or trash.PrimaryPart or trash:FindFirstChildWhichIsA("BasePart")
                            if not part then continue end
                            local dist = (root.Position - part.Position).Magnitude
                            if dist <= 10 and dist < nearestDist then
                                nearestDist = dist
                                nearestTrash = trash
                                trashPos = part.Position
                            end
                        end
                        if nearestTrash and trashPos then
                            local lookDir = (trashPos - root.Position).Unit
                            root.CFrame = CFrame.lookAt(root.Position, root.Position + Vector3.new(lookDir.X, 0, lookDir.Z))
                            local success = false
                            for attempt = 1, 3 do
                                if not GlobalState.ZDNLJTT then break end
                                comm:FireServer({Goal = "LeftClick"})
                                task.wait(0.05)
                                comm:FireServer({Goal = "LeftClickRelease"})
                                local waitStart = tick()
                                while tick() - waitStart < 0.5 do
                                    if char:GetAttribute("HasTrashcan") then
                                        success = true
                                        break
                                    end
                                    task.wait(0.05)
                                end
                                if success then break end
                                root.CFrame = root.CFrame + root.CFrame.LookVector * 0.5
                                task.wait(0.2)
                            end
                            if success then
                                task.wait(0.3)
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        else
            WindUI:Notify({
                Title = T("已停止"),
                Content = T("自动拿垃圾桶功能已关闭"),
                Duration = 2
            })
        end
    end
})

    StrongBattleTab:Toggle({
        Title = T("取消冲刺后摇"),
        Desc = T("m1reset+emotedash 自己把握好距离(手机勿用)"),
        Default = false,
        Callback = function(state)
            GlobalState.awdawdwaT = state
            local plr = LocalPlayer
            local uis = UserInputService
            local isMobile = uis.TouchEnabled
            getgenv()._TempestAlreadyRan = true
            local frontDashArgs = {
                [1] = {
                    Dash = Enum.KeyCode.W,
                    Key = Enum.KeyCode.Q,
                    Goal = "KeyPress"
                }
            }
            local function frontDash()
                if plr.Character then
                    local communicate = plr.Character:FindFirstChild("Communicate")
                    if communicate then
                        communicate:FireServer(unpack(frontDashArgs))
                    end
                end
            end
            local function stopAnimation(char, animationId)
                local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    local animator = humanoid:FindFirstChildWhichIsA("Animator")
                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            if track.Animation and track.Animation.AnimationId == "rbxassetid://" .. tostring(animationId) then
                                track:Stop()
                            end
                        end
                    end
                end
            end
            local function isAnimationRunning(char, animationId)
                local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    local animator = humanoid:FindFirstChildWhichIsA("Animator")
                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            if track.Animation and track.Animation.AnimationId == "rbxassetid://" .. tostring(animationId) then
                                return true
                            end
                        end
                    end
                end
                return false
            end
            local inputBeganConnections = {}
            local characterAddedConnections = {}
            local dashButtonConnections = {}
            local function setupNoEndlagDash()
                if not plr.Character then return end
                local connection = uis.InputBegan:Connect(function(input, t)
                    if t then return end
                    if GlobalState.awdawdwaT and input.KeyCode == Enum.KeyCode.Q and not uis:IsKeyDown(Enum.KeyCode.D) and not uis:IsKeyDown(Enum.KeyCode.A) and not uis:IsKeyDown(Enum.KeyCode.S) and plr.Character:FindFirstChild("UsedDash") then
                        frontDash()
                    end
                end)
                table.insert(inputBeganConnections, connection)
                local destroyConn = plr.Character.Destroying:Connect(function()
                    for i, conn in ipairs(inputBeganConnections) do
                        if conn == connection then
                            conn:Disconnect()
                            table.remove(inputBeganConnections, i)
                            break
                        end
                    end
                    destroyConn:Disconnect()
                end)
            end
            local function setupEmoteDash()
                if not plr.Character then return end
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local connection = uis.InputBegan:Connect(function(input, t)
                    if t then return end
                    if GlobalState.awdawdwaT and input.KeyCode == Enum.KeyCode.Q and not uis:IsKeyDown(Enum.KeyCode.W) and not uis:IsKeyDown(Enum.KeyCode.S) and not isAnimationRunning(plr.Character, 10491993682) then
                        local vel = hrp:FindFirstChild("dodgevelocity")
                        if vel then
                            vel:Destroy()
                            stopAnimation(plr.Character, 10480793962)
                            stopAnimation(plr.Character, 10480796021)
                        end
                    end
                end)
                table.insert(inputBeganConnections, connection)
                local destroyConn = plr.Character.Destroying:Connect(function()
                    for i, conn in ipairs(inputBeganConnections) do
                        if conn == connection then
                            conn:Disconnect()
                            table.remove(inputBeganConnections, i)
                            break
                        end
                    end
                    destroyConn:Disconnect()
                end)
            end
            local function cleanupConnections()
                for _, conn in ipairs(inputBeganConnections) do conn:Disconnect() end
                for _, conn in ipairs(characterAddedConnections) do conn:Disconnect() end
                for _, conn in ipairs(dashButtonConnections) do conn:Disconnect() end
                inputBeganConnections = {}
                characterAddedConnections = {}
                dashButtonConnections = {}
            end
            if state then
                if plr.Character then
                    setupNoEndlagDash()
                    setupEmoteDash()
                end
                local charAddedConn1 = plr.CharacterAdded:Connect(setupNoEndlagDash)
                local charAddedConn2 = plr.CharacterAdded:Connect(setupEmoteDash)
                table.insert(characterAddedConnections, charAddedConn1)
                table.insert(characterAddedConnections, charAddedConn2)
                WindUI:Notify({
                    Title = T("已启动"),
                    Content = T("取消冲刺后摇功能已开启"),
                    Duration = 2
                })
            else
                cleanupConnections()
                WindUI:Notify({
                    Title = T("已停止"),
                    Content = T("取消冲刺后摇功能已关闭"),
                    Duration = 2
                })
            end
        end
    })

    StrongBattleTab:Slider({
        Title = T("自动防御延迟"),
        Value = {
            Min = 0,
            Max = 1,
            Default = 0
        },
        Increment = 0.05,
        Callback = function(value)
            GlobalState.ParryDelay = value
        end
    })

    StrongBattleTab:Slider({
        Title = T("自动防御范围"),
        Value = {
            Min = 5,
            Max = 50,
            Default = 25
        },
        Increment = 1,
        Callback = function(value)
            GlobalState.ParryRange = value
        end
    })

    StrongBattleTab:Toggle({
        Title = T("自动防御"),
        Desc = T("角色自动防御(增强版)"),
        Icon = "shield",
        Default = false,
        Callback = function(state)
            GlobalState.AutoParry = state
            if state then
                WindUI:Notify({
                    Title = T("已启动"),
                    Content = T("自动防御功能已开启"),
                    Duration = 2
                })
                task.spawn(RunAutoParry)
            else
                WindUI:Notify({
                    Title = T("已停止"),
                    Content = T("自动防御功能已关闭"),
                    Duration = 2
                })
            end
        end
    })

    StrongBattleTab:Toggle({
        Title = T("移除定身"),
        Desc = T("角色无定身状态(如攻击4下之后的定身)"),
        Default = false,
        Callback = function(state)
            GlobalState.YCDSHYT = state
            if state then
                WindUI:Notify({
                    Title = T("已启动"),
                    Content = T("移除定身功能已开启"),
                    Duration = 2
                })
                task.spawn(function()
                    while GlobalState.YCDSHYT do
                        pcall(function()
                            local char = LocalPlayer.Character
                            if not char then return end
                            local Freeze = char:FindFirstChild("Freeze")
                            local ComboStun = char:FindFirstChild("ComboStun")
                            if Freeze then Freeze:Destroy() end
                            if ComboStun then ComboStun:Destroy() end
                        end)
                        task.wait(0.1)
                    end
                end)
            else
                WindUI:Notify({
                    Title = T("已停止"),
                    Content = T("移除定身功能已关闭"),
                    Duration = 2
                })
            end
        end
    })

    StrongBattleTab:Input({
        Title = T("击杀数"),
        Desc = T("设置目标击杀数"),
        Placeholder = "输入数字",
        Callback = function(input)
            GlobalState.TargetKills = tonumber(input) or 0
        end
    })

    StrongBattleTab:Input({
        Title = T("总击杀数"),
        Desc = T("设置目标总击杀数"),
        Placeholder = "输入数字",
        Callback = function(input)
            GlobalState.TargetTotalKills = tonumber(input) or 0
        end
    })

    StrongBattleTab:Button({
        Title = T("启动自动刷击杀数"),
        Desc = T("持续设置为目标击杀数和总击杀数"),
        Icon = "repeat",
        Callback = function()
            GlobalState.AutoKillEnabled = not GlobalState.AutoKillEnabled
            if GlobalState.AutoKillEnabled then
                WindUI:Notify({
                    Title = T("已启动"),
                    Content = T("自动刷击杀数功能已开启"),
                    Duration = 2
                })
                task.spawn(RunAutoKillSetter)
            else
                WindUI:Notify({
                    Title = T("已停止"),
                    Content = T("自动刷击杀数功能已关闭"),
                    Duration = 2
                })
            end
        end
    })

    -- ===== 传送与甩飞标签页内容 =====
    TeleportLaunchTab:Paragraph({
        Title = "循环甩飞设置",
        Desc = "持续对自身施加随机方向的力",
        Color = "Blue"
    })

    TeleportLaunchTab:Slider({
        Title = "甩飞功率",
        Value = {
            Min = 0,
            Max = 500,
            Default = 100
        },
        Increment = 10,
        Callback = function(value)
            GlobalState.LoopLaunchPower = value
        end
    })

    TeleportLaunchTab:Toggle({
        Title = "开启循环甩飞",
        Desc = "持续随机方向甩飞自身",
        Default = false,
        Callback = function(state)
            GlobalState.LoopLaunchEnabled = state
            if state then
                WindUI:Notify({
                    Title = "已开启",
                    Content = "循环甩飞功能已激活",
                    Duration = 2
                })
                task.spawn(LoopLaunch)
            else
                WindUI:Notify({
                    Title = "已关闭",
                    Content = "循环甩飞功能已停止",
                    Duration = 2
                })
            end
        end
    })

    TeleportLaunchTab:Paragraph({
        Title = "循环传送设置",
        Desc = "持续随机传送自身",
        Color = "Purple"
    })

    TeleportLaunchTab:Slider({
        Title = "传送距离",
        Value = {
            Min = 0,
            Max = 200,
            Default = 50
        },
        Increment = 5,
        Callback = function(value)
            GlobalState.LoopTeleportDistance = value
        end
    })

    TeleportLaunchTab:Toggle({
        Title = "开启循环传送",
        Desc = "持续随机传送",
        Default = false,
        Callback = function(state)
            GlobalState.LoopTeleportEnabled = state
            if state then
                WindUI:Notify({
                    Title = "已开启",
                    Content = "循环传送功能已激活",
                    Duration = 2
                })
                task.spawn(LoopTeleport)
            else
                WindUI:Notify({
                    Title = "已关闭",
                    Content = "循环传送功能已停止",
                    Duration = 2
                })
            end
        end
    })

    TeleportLaunchTab:Paragraph({
        Title = "定点传送功能",
        Desc = "最强战场相关传送功能",
        Color = "Green"
    })

    TeleportLaunchTab:Dropdown({
        Title = "预设传送位置",
        Values = {T("地图"), T("山脉"), T("安全港"), T("秘密房间1"), T("秘密房间2")},
        Value = T("地图"),
        Callback = function(option)
            local char, root = Core.GetCharacterParts()
            if not root then return end
            local cframes = {
                [T("地图")] = CFrame.new(63.4928513, 440.505829, -92.9229507),
                [T("山脉")] = CFrame.new(253.515198, 699.103455, 420.533813),
                [T("安全港")] = CFrame.new(-774.454834, -137.237228, 126.384216),
                [T("秘密房间1")] = CFrame.new(-62, 29, 20338),
                [T("秘密房间2")] = CFrame.new(1068, 133, 23015)
            }
            root.CFrame = cframes[option] or cframes[T("地图")]
            WindUI:Notify({
                Title = "传送成功",
                Content = "已传送到" .. option,
                Duration = 2
            })
        end
    })

    TeleportLaunchTab:Button({
        Title = "设置原位",
        Desc = "保存当前位置为原位",
        Callback = function()
            local char, root = Core.GetCharacterParts()
            if not root then return end
            GlobalState.OriginalCFrame = root.CFrame
            WindUI:Notify({
                Title = "设置成功",
                Content = "已保存当前位置为原位",
                Duration = 2
            })
        end
    })

    TeleportLaunchTab:Button({
        Title = "传送原位",
        Desc = "返回保存的原位",
        Callback = function()
            local char, root = Core.GetCharacterParts()
            if not root or not GlobalState.OriginalCFrame then 
                WindUI:Notify({
                    Title = "错误",
                    Content = "未设置原位",
                    Duration = 2
                })
                return 
            end
            root.CFrame = GlobalState.OriginalCFrame
            WindUI:Notify({
                Title = "传送成功",
                Content = "已返回原位",
                Duration = 2
            })
        end
    })

    TeleportLaunchTab:Button({
        Title = "强制传送虚空",
        Desc = "传送到秘密房间1",
        Icon = "teleport",
        Callback = function()
            local char, root = Core.GetCharacterParts()
            if not root then return end
            root.CFrame = CFrame.new(-62, 29, 20338)
            WindUI:Notify({
                Title = "传送成功",
                Content = "已强制传送到虚空",
                Duration = 2
            })
        end
    })

    TeleportLaunchTab:Paragraph({
        Title = "垃圾桶传送",
        Desc = "扫描并传送至垃圾桶位置",
        Color = "Orange"
    })

    TeleportLaunchTab:Button({
        Title = "检测所有垃圾桶坐标",
        Desc = "扫描场景内垃圾桶",
        Icon = "search",
        Callback = function()
            task.spawn(DetectTrashCanPositions)
        end
    })

    TeleportLaunchTab:Button({
        Title = "传送到下一个垃圾桶",
        Desc = "循环切换垃圾桶位置",
        Icon = "location",
        Callback = function()
            task.spawn(TeleportToNextTrashCan)
        end
    })

    -- ===== 通用标签页内容 =====
    GeneralTab:Paragraph({
        Title = "移动速度设置",
        Desc = "调整角色移动相关参数",
        Color = "Red"
    })

    GeneralTab:Slider({
        Title = "移动速度倍率",
        Value = {
            Min = 1,
            Max = 10,
            Default = 1
        },
        Increment = 0.5,
        Callback = function(value)
            GlobalState.WalkSpeedMultiplier = value
            UpdateMovementValues()
        end
    })

    GeneralTab:Slider({
        Title = "跳跃力度倍率",
        Value = {
            Min = 1,
            Max = 10,
            Default = 1
        },
        Increment = 0.5,
        Callback = function(value)
            GlobalState.JumpPowerMultiplier = value
            UpdateMovementValues()
        end
    })

    GeneralTab:Slider({
        Title = "重力倍率",
        Value = {
            Min = 0.1,
            Max = 5,
            Default = 1
        },
        Increment = 0.1,
        Callback = function(value)
            GlobalState.GravityMultiplier = value
            UpdateMovementValues()
        end
    })

    GeneralTab:Toggle({
        Title = "开启穿墙",
        Desc = "角色无碰撞体积",
        Default = false,
        Callback = function(state)
            GlobalState.NoclipEnabled = state
            if state then
                WindUI:Notify({
                    Title = "已开启",
                    Content = "穿墙功能已激活",
                    Duration = 2
                })
                task.spawn(Noclip)
            else
                WindUI:Notify({
                    Title = "已关闭",
                    Content = "穿墙功能已停止",
                    Duration = 2
                })
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    })

    GeneralTab:Paragraph({
        Title = "玩家列表管理",
        Desc = "更新和查看在线玩家",
        Color = "Blue"
    })

    local generalPlayerDropdown = GeneralTab:Dropdown({
        Title = "在线玩家列表",
        Values = GlobalState.PlayerList,
        Value = GlobalState.PlayerList[1] or T("无玩家"),
        Callback = function(selected)
            GlobalState.TargetPlayer = selected
        end
    })

    GeneralTab:Button({
        Title = "刷新玩家列表",
        Desc = "更新当前在线玩家",
        Icon = "refresh",
        Callback = function()
            UpdatePlayerList()
            generalPlayerDropdown:SetValues(GlobalState.PlayerList)
            generalPlayerDropdown:SetValue(GlobalState.PlayerList[1] or T("无玩家"))
            WindUI:Notify({
                Title = "刷新完成",
                Content = "共找到 " .. #GlobalState.PlayerList .. " 名其他玩家",
                Duration = 2
            })
        end
    })

    GeneralTab:Button({
        Title = "传送到目标玩家",
        Desc = "传送到选中玩家位置",
        Icon = "person",
        Callback = function()
            if not GlobalState.TargetPlayer then
                WindUI:Notify({
                    Title = "错误",
                    Content = "未选择目标玩家",
                    Duration = 2
                })
                return
            end
            local targetPlayer = Players:FindFirstChild(GlobalState.TargetPlayer)
            if not targetPlayer then
                WindUI:Notify({
                    Title = "错误",
                    Content = "目标玩家不存在或已离开",
                    Duration = 2
                })
                return
            end
            local pChar, pRoot = Core.GetCharacterParts(targetPlayer)
            local char, root = Core.GetCharacterParts()
            if not pRoot or not root then return end
            root.CFrame = pRoot.CFrame
            WindUI:Notify({
                Title = "传送成功",
                Content = "已传送到目标玩家位置",
                Duration = 2
            })
        end
    })

    -- 玩家列表更新事件
    Players.PlayerAdded:Connect(function()
        UpdatePlayerList()
        playerDropdown:SetValues(GlobalState.PlayerList)
        generalPlayerDropdown:SetValues(GlobalState.PlayerList)
    end)

    Players.PlayerRemoving:Connect(function()
        UpdatePlayerList()
        playerDropdown:SetValues(GlobalState.PlayerList)
        generalPlayerDropdown:SetValues(GlobalState.PlayerList)
    end)

    -- 角色重生时更新移动属性
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        Character = newChar
        wait(1)
        UpdateMovementValues()
    end)

    UpdateMovementValues()

    WindUI:Notify({
        Title = T("加载完成"),
        Content = T("最强战场 功能已就绪"),
        Duration = 2
    })
end


-- 加载最强战场功能
loadFINUIFeatures()