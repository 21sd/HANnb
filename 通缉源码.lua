local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = '通缉',
    Icon = "crown",
    IconThemed = true,
    Author = "",
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
    Title = "通缉",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "通缉",
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

-- ============================================================
-- 以下是从文件集成的完整功能代码
-- ============================================================

Window:Divider()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

for _, v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v, "exploitDetected") then
        if typeof(rawget(v, "exploitDetected")) == "Instance" then
            targetRemote = v["exploitDetected"]
            break
        end
    end
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if self == targetRemote and method == "FireServer" then
        return nil
    end
    return oldNamecall(self, ...)
end)

local oldFireServer
oldFireServer = hookfunction(Instance.new("RemoteEvent").FireServer, function(self, ...)
    if self == targetRemote then
        return nil
    end
    return oldFireServer(self, ...)
end)

local Tabs = {
    Player = Window:Tab({ Title = "玩家", Icon = "house" }),
    Attack = Window:Tab({ Title = "攻击", Icon = "combat" }),
    Auto = Window:Tab({ Title = "自动", Icon = "settings" }),
    Teleport = Window:Tab({ Title = "传送", Icon = "map-pin" }),
    Perspective = Window:Tab({ Title = "透视", Icon = "map-pin" }),
}
Window:SelectTab(1)

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local function TeleportToPosition(x, y, z)
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    HumanoidRootPart.CFrame = CFrame.new(x, y, z)
end

local RangeColorPalette = {
    RangeColor = Color3.fromRGB(255, 0, 0),
    Transparency = 0.7
}

local function UpdateAllRangeColors()
    if _G.Disabled and _G.HeadSizeConnection then
        for _, v in ipairs(game:GetService('Players'):GetPlayers()) do
            if v ~= game:GetService('Players').LocalPlayer then
                pcall(function()
                    local root = v.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.BrickColor = BrickColor.new(RangeColorPalette.RangeColor)
                        root.Transparency = RangeColorPalette.Transparency
                    end
                end)
            end
        end
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local NoRecoilActive = false
local NoRecoilConnections = {}

local function clearConnections()
    for _, c in ipairs(NoRecoilConnections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(NoRecoilConnections)
end

local function setupNoRecoil()
    local function findTool()
        local character = LocalPlayer.Character
        if not character then return nil end
        for _, v in ipairs(character:GetChildren()) do
            if v:IsA("Tool") then
                return v
            end
        end
        return nil
    end

    local lastTool = nil
    table.insert(NoRecoilConnections, RunService.Heartbeat:Connect(function()
        if not NoRecoilActive then return end
        local tool = findTool()
        if tool and tool ~= lastTool then
            lastTool = tool
            task.wait(0.2)
            for _, v in ipairs(tool:GetDescendants()) do
                if v:IsA("ModuleScript") then
                    local ok, m = pcall(require, v)
                    if ok and type(m) == "table" then
                        if m.spread then
                            local o = m.spread
                            m.spread = function(...)
                                if NoRecoilActive then
                                    return 0
                                end
                                return o(...)
                            end
                        end
                        if m.kickBack then m.kickBack = 0 end
                        if m.kickHoriz then m.kickHoriz = 0 end
                        if m.angle then m.angle = 0 end
                        if m.climb then m.climb = 0 end
                        if m.sway then m.sway = 0 end
                    end
                end
            end
        end
    end))

    table.insert(NoRecoilConnections, RunService.RenderStepped:Connect(function()
        if not NoRecoilActive then return end
        if not LocalPlayer:GetAttribute("FPS") then
            LocalPlayer:SetAttribute("xAngle", LocalPlayer:GetAttribute("xAngle") or 0)
            LocalPlayer:SetAttribute("yAngle", LocalPlayer:GetAttribute("yAngle") or 0)
        end
    end))

    local shooter = ReplicatedStorage:FindFirstChild("Client")
        and ReplicatedStorage.Client:FindFirstChild("Wanted")
        and ReplicatedStorage.Client.Wanted:FindFirstChild("Objects")
        and ReplicatedStorage.Client.Wanted.Objects:FindFirstChild("ClientTool")
        and ReplicatedStorage.Client.Wanted.Objects.ClientTool:FindFirstChild("Components")
        and ReplicatedStorage.Client.Wanted.Objects.ClientTool.Components:FindFirstChild("Guns")
        and ReplicatedStorage.Client.Wanted.Objects.ClientTool.Components.Guns:FindFirstChild("Shooter")

    if shooter then
        local ok, m = pcall(require, shooter)
        if ok and m and m.new then
            local oldNew = m.new
            m.new = function(tool)
                local inst = oldNew(tool)
                if inst._shoot then
                    local os = inst._shoot
                    inst._shoot = function(self)
                        local r = os(self)
                        if NoRecoilActive then
                            self.spread = 0
                            self.kickBack = 0
                            self.kickHoriz = 0
                            self.angle = 0
                            self.climb = 0
                            self.sway = 0
                            self.firstShotKick = 0
                            self.firstShotKickMult = 0
                        end
                        return r
                    end
                end
                if inst._cameraRecoil then
                    local oc = inst._cameraRecoil
                    inst._cameraRecoil = function(self, dt)
                        if NoRecoilActive then return end
                        return oc(self, dt)
                    end
                end
                return inst
            end
        end
    end

    local shared = ReplicatedStorage:FindFirstChild("Shared")
        and ReplicatedStorage.Shared:FindFirstChild("Core")
        and ReplicatedStorage.Shared.Core:FindFirstChild("Network")

    if shared then
        for _, n in ipairs({"f0bJNHPM", "yVoG1RIG"}) do
            local e = shared:FindFirstChild(n)
            if e then
                local of = e.FireServer
                e.FireServer = function(self, ...)
                    local args = {...}
                    if NoRecoilActive and args[1] == "Shoot" and type(args[3]) == "table" then
                        for _, p in ipairs(args[3]) do
                            if type(p) == "table" and typeof(p[2]) == "userdata" then
                                local b = {}
                                for i = 0, buffer.len(p[2]) - 1 do
                                    b[i+1] = buffer.readu8(p[2], i)
                                end
                                if #b >= 22 then
                                    b[13], b[14], b[21], b[22] = 0, 0, 0, 0
                                    local nb = buffer.create(#b)
                                    for i, v in ipairs(b) do
                                        buffer.writeu8(nb, i-1, v)
                                    end
                                    p[2] = nb
                                end
                            end
                        end
                    end
                    return of(self, unpack(args))
                end
            end
        end
    end

    local ok, devv = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Devv"))
    end)

    if ok and devv and devv.load then
        local cross = devv.load("CrosshairScreen")
        if cross and cross.SetCrosshairSpread then
            local os = cross.SetCrosshairSpread
            cross.SetCrosshairSpread = function(self, s)
                if NoRecoilActive then
                    return os(self, 0)
                end
                return os(self, s)
            end
        end
    end
end

Tabs.Attack:Toggle({
    Title = "枪械无后坐分散",
    Value = false,
    Callback = function(state)
        NoRecoilActive = state
        if state then
            setupNoRecoil()
        else
            clearConnections()
        end
    end
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Config = {
    FireInterval = 0.1,
    MaxRange = 2000,
    HitMaterial = Enum.Material.Concrete,
    HitType = "player",
    SendHitInfo = false,
    Enabled = false,
    MaxAttacks = 4,
    BurstCount = 4,
    UseNetworkModule = true,
    DebugRay = false,
    RemoteOverrides = {
        Invoke = nil,
        Shoot = nil,
        Hit = nil
    }
}

local vector = rawget(_G, "vector")
if type(vector) ~= "table" then
    vector = {}
    _G.vector = vector
end
if type(vector.create) ~= "function" then
    function vector.create(x, y, z)
        return Vector3.new(x, y, z)
    end
end

local Network = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Core"):WaitForChild("Network")
local RemoteFunctions = {}
local RemoteEvents = {}

local Devv = require(ReplicatedStorage:WaitForChild("Devv"))
local NetworkModule
local ClientToolsModule
local MathUtilModule
local NUIDModule
local ClientGunsModule
local ClientProjectilesModule
local ProjectileUtilModule
local ObjectsModule
local ClientPlayers

local function InitGameModules()
    local ok = pcall(function()
        Devv = require(ReplicatedStorage:WaitForChild("Devv", 5))
    end)
    if not ok or not Devv then
        return false
    end
    pcall(function() ClientPlayers = Devv.load("ClientPlayers") end)
    pcall(function()
        NetworkModule = Devv.load("Network")
        ClientToolsModule = Devv.load("ClientTools")
        MathUtilModule = Devv.load("MathUtil")
        NUIDModule = Devv.load("NUID")
        ClientGunsModule = Devv.load("ClientGuns")
        ClientProjectilesModule = Devv.load("ClientProjectiles")
        ProjectileUtilModule = Devv.load("ProjectileUtil")
        ObjectsModule = Devv.load("Objects")
    end)
    return true
end

local OverrideHitPos
local OverrideOrigin
local OriginalMakeGunProjectiles

local function HookMakeGunProjectiles()
    if not ClientGunsModule or not ClientGunsModule.MakeGunProjectiles then
        return
    end
    if OriginalMakeGunProjectiles then
        return
    end
    OriginalMakeGunProjectiles = ClientGunsModule.MakeGunProjectiles
    ClientGunsModule.MakeGunProjectiles = function(userId, toolId, muzzleCFrame, projectiles)
        if OverrideHitPos and OverrideOrigin and userId == LocalPlayer.UserId then
            local newProjectiles = {}
            for _, proj in ipairs(projectiles) do
                table.insert(newProjectiles, {proj[1], CFrame.new(OverrideOrigin, OverrideHitPos)})
            end
            return OriginalMakeGunProjectiles(userId, toolId, muzzleCFrame, newProjectiles)
        end
        return OriginalMakeGunProjectiles(userId, toolId, muzzleCFrame, projectiles)
    end
end

local function ScanRemotes()
    for _, child in ipairs(Network:GetChildren()) do
        if child:IsA("RemoteFunction") then
            RemoteFunctions[child.Name] = child
        elseif child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
            RemoteEvents[child.Name] = child
        end
    end
end

local function GetEquippedToolId()
    if ClientToolsModule and ClientToolsModule.GetLocalEquippedTool then
        local ok, tool = pcall(ClientToolsModule.GetLocalEquippedTool)
        if ok and tool and tool.toolId then
            return tool.toolId
        end
    end
    if ClientPlayers then
        local ok, p = pcall(ClientPlayers.Get)
        if ok and p then
            if p.GetEquippedReplica then
                local ok2, r = pcall(p.GetEquippedReplica, p)
                if ok2 and r and r.toolId then
                    return r.toolId
                end
            end
        end
    end
end

local function CompressCFrame(cf)
    local b = buffer.create(24)
    local axis, angle = cf:ToAxisAngle()
    buffer.writef32(b, 0, cf.X)
    buffer.writef32(b, 4, cf.Y)
    buffer.writef32(b, 8, cf.Z)
    buffer.writef32(b, 12, axis.X * angle)
    buffer.writef32(b, 16, axis.Y * angle)
    buffer.writef32(b, 20, axis.Z * angle)
    return b
end

local function GetClosestEnemy()
    local best, dist, ply
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if h and hum and hum.Health > 0 then
                local d = (h.Position - Camera.CFrame.Position).Magnitude
                if not dist or d < dist then
                    dist = d
                    best = h
                    ply = p
                end
            end
        end
    end
    return best, ply
end

local LastFireTime = 0
local AttackCount = 0
local CachedToolId

local function DoAttack(hitbox, targetPlayer)
    local t = tick()
    if t - LastFireTime < Config.FireInterval then return end
    local toolId = GetEquippedToolId() or CachedToolId
    if not toolId then return end
    CachedToolId = toolId
    LastFireTime = t
    AttackCount += 1
end

local function MainLoop()
    if not Config.Enabled then return end
    if Config.MaxAttacks > 0 and AttackCount >= Config.MaxAttacks then
        Config.Enabled = false
        return
    end
    local h, p = GetClosestEnemy()
    if h then
        DoAttack(h, p)
    end
end

if not InitGameModules() then
    return
end

task.wait(0.5)
ScanRemotes()
HookMakeGunProjectiles()

RunService.Heartbeat:Connect(MainLoop)

Tabs.Attack:Toggle({
    Title = "愤怒机器人",
    Value = false,
    Callback = function(state)
        Config.Enabled = state
        if state then
            AttackCount = 0
            LastFireTime = 0
        else
            OverrideHitPos = nil
            OverrideOrigin = nil
        end
    end
})

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Enabled = false

local cachedTarget = nil
local lastUpdate = 0
local updateDelay = 0.1

local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Visible = false
FOV_Circle.Radius = 250
FOV_Circle.Color = Color3.fromRGB(255, 255, 255)
FOV_Circle.Thickness = 1
FOV_Circle.Transparency = 1
FOV_Circle.Filled = false
FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

local function updateTarget()
    local closest, dist = nil, math.huge
    local camCF = Camera.CFrame
    local camPos = camCF.Position
    local camLook = camCF.LookVector

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local c = p.Character
            if c then
                local head = c:FindFirstChild("Head")
                local hum = c:FindFirstChildOfClass("Humanoid")
                if head and hum and hum.Health > 0 and not c:FindFirstChild("ForceField") then
                    local dir = head.Position - camPos
                    local angle = math.deg(math.acos(camLook:Dot(dir.Unit)))
                    if angle <= 15 then
                        local mag = dir.Magnitude
                        if mag < dist then
                            dist = mag
                            closest = head
                        end
                    end
                end
            end
        end
    end

    cachedTarget = closest
end

RunService.RenderStepped:Connect(function()
    if not Enabled then
        cachedTarget = nil
        return
    end
    if tick() - lastUpdate > updateDelay then
        lastUpdate = tick()
        updateTarget()
    end
end)

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if Enabled and not checkcaller() and self == Workspace and (method == "Raycast" or method == "FindPartOnRay") then
        if cachedTarget then
            local args = {...}
            local origin

            if method == "Raycast" then
                origin = args[1]
            else
                local ray = args[1]
                if typeof(ray) == "Ray" then
                    origin = ray.Origin
                end
            end

            if origin then
                return {
                    Instance = cachedTarget,
                    Position = cachedTarget.Position,
                    Normal = (cachedTarget.Position - origin).Unit,
                    Material = Enum.Material.Plastic
                }
            end
        end
    end
    return old(self, ...)
end)

Tabs.Attack:Toggle({
    Title = "子弹追踪",
    Value = false,
    Callback = function(state)
        Enabled = state
        FOV_Circle.Visible = state
        if not state then
            cachedTarget = nil
        end
    end
})

LocalPlayer.CharacterAdded:Connect(function()
    if NoRecoilActive then
        task.wait(1)
        setupNoRecoil()
    end
end)

local function InitializeRangeColorPalette()
    Tabs.Attack:Colorpicker({
        Title = "范围颜色",
        Desc = "选择范围显示的颜色",
        Default = RangeColorPalette.RangeColor,
        Callback = function(color)
            RangeColorPalette.RangeColor = color
            UpdateAllRangeColors()
        end
    })
    
    Tabs.Attack:Slider({
        Title = "范围透明度",
        Desc = "调整范围的透明度",
        Step = 0.1,
        Value = {
            Min = 0.1,
            Max = 1,
            Default = 0.7
        },
        Callback = function(value)
            RangeColorPalette.Transparency = value
            UpdateAllRangeColors()
        end
    })
end

Tabs.Teleport:Paragraph({
    Title = "地点",
    Desc = "传送地点",
    ImageSize = 30
})

Tabs.Teleport:Button({
    Title = "警察局",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(1623.02, 122.10, -678.86)
    end
})

Tabs.Teleport:Button({
    Title = "要塞",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(-1456.56, 183.32, 3345.91)
    end
})

Tabs.Teleport:Button({
    Title = "维修站",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(288.62, 39.83, -2922.87)
    end
})

Tabs.Teleport:Button({
    Title = "枪店",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(-3277.16, 39.93, 1849.02)
    end
})

Tabs.Teleport:Button({
    Title = "黑市",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(-2910.80, 37.33, 1651.62)
    end
})

Tabs.Teleport:Button({
    Title = "二倍售卖",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(-7892.93, 21.59, 1181.68)
    end
})

Tabs.Teleport:Button({
    Title = "银行",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(-386.98, 621.04, -1194.99)
    end
})

Tabs.Teleport:Paragraph({
    Title = "传送枪械",
    Desc = "传送到免费枪械",
    ImageSize = 30
})

Tabs.Teleport:Button({
    Title = "UZI",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(-1351.23, 40.43, 2036.70)
    end
})

Tabs.Teleport:Button({
    Title = "RPG",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(-1392.26, 272.13, 3203.12)
    end
})

Tabs.Teleport:Button({
    Title = "AK47",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(-7838.77, 21.59, 1194.19)
    end
})

Tabs.Teleport:Button({
    Title = "M4A1",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(-6343.96, 134.61, -4329.21)
    end
})

Tabs.Teleport:Button({
    Title = "贝内利M1014",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(1348.13, 141.27, -4808.40)
    end
})

Tabs.Teleport:Button({
    Title = "UMP 45",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(1665.20, 143.59, -644.01)
    end
})

Tabs.Teleport:Button({
    Title = "自动瞄准器",
    Icon = "map-pin",
    Callback = function()
        TeleportToPosition(-822.88, 325.84, -505.92)
    end
})

Tabs.Attack:Paragraph({
    Title = "攻击功能",
    Desc = "增强攻击能力",
    ImageSize = 30
})

InitializeRangeColorPalette()

Tabs.Attack:Slider({
    Title = "范围",
    Desc = "可以配合枪械",
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 1
    },
    Callback = function(value)
        if _G.HeadSizeConnection then
            _G.HeadSizeConnection:Disconnect()
        end

        _G.HeadSize = value
        _G.Disabled = true

        _G.HeadSizeConnection = game:GetService('RunService').RenderStepped:Connect(function()
            if _G.Disabled then
                for _, v in ipairs(game:GetService('Players'):GetPlayers()) do
                    if v ~= game:GetService('Players').LocalPlayer then
                        pcall(function()
                            local root = v.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                root.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                                root.Transparency = RangeColorPalette.Transparency
                                root.BrickColor = BrickColor.new(RangeColorPalette.RangeColor)
                                root.Material = "Neon"
                                root.CanCollide = false
                            end
                        end)
                    end
                end
            end
        end)
    end
})

Tabs.Attack:Toggle({
    Title = "头部大小开关",
    Desc = "开启/关闭头部大小修改",
    Value = false,
    Callback = function(state)
        if _G.HeadSizeConnection then
            _G.HeadSizeConnection:Disconnect()
        end
        
        if state then
            _G.Disabled = true
            _G.HeadSize = _G.HeadSize or 1
            
            _G.HeadSizeConnection = game:GetService('RunService').RenderStepped:Connect(function()
                if _G.Disabled then
                    for _, v in ipairs(game:GetService('Players'):GetPlayers()) do
                        if v ~= game:GetService('Players').LocalPlayer then
                            pcall(function()
                                local root = v.Character:FindFirstChild("HumanoidRootPart")
                                if root then
                                    root.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                                    root.Transparency = RangeColorPalette.Transparency
                                    root.BrickColor = BrickColor.new(RangeColorPalette.RangeColor)
                                    root.Material = "Neon"
                                    root.CanCollide = false
                                end
                            end)
                        end
                    end
                end
            end)
        else
            _G.Disabled = false
            
            for _, v in ipairs(game:GetService('Players'):GetPlayers()) do
                if v ~= game:GetService('Players').LocalPlayer then
                    pcall(function()
                        local root = v.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.Size = Vector3.new(2, 2, 1)
                            root.Transparency = 0
                            root.BrickColor = BrickColor.new("Medium stone grey")
                            root.Material = "Plastic"
                            root.CanCollide = true
                        end
                    end)
                end
            end
        end
    end
})

local PlayerConfig = {
    playernamedied = "",
    dropdown = {},
    dropdownHandle = nil,
    LoopTeleport = false,
    LoopTeleportToMe = false
}

local function RefreshPlayerList()
    PlayerConfig.dropdown = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(PlayerConfig.dropdown, player.Name)
        end
    end
    
    if PlayerConfig.dropdownHandle then
        PlayerConfig.dropdownHandle:SetValues(PlayerConfig.dropdown)
        if #PlayerConfig.dropdown > 0 and PlayerConfig.playernamedied == "" then
            PlayerConfig.dropdownHandle:SetValue(PlayerConfig.dropdown[1])
            PlayerConfig.playernamedied = PlayerConfig.dropdown[1]
        end
    end
end

RefreshPlayerList()

local function InitializeAutoRefreshPlayers()
    game.Players.PlayerAdded:Connect(function(player)
        task.wait(0.5)
        RefreshPlayerList()
    end)
    
    game.Players.PlayerRemoving:Connect(function(player)
        task.wait(0.5)
        RefreshPlayerList()
    end)
    
    task.spawn(function()
        while true do
            task.wait(0.1)
            RefreshPlayerList()
        end
    end)
end

InitializeAutoRefreshPlayers()

PlayerConfig.dropdownHandle = Tabs.Attack:Dropdown({
    Title = "选择玩家名称",
    Values = PlayerConfig.dropdown,
    Value = PlayerConfig.dropdown[1] or "",
    Callback = function(selected)
        PlayerConfig.playernamedied = selected
    end
})

Tabs.Attack:Button({
    Title = "传送到玩家旁边",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        local localRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
        local targetRoot = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if localRoot and targetRoot then
            localRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

Tabs.Attack:Toggle({
    Title = "循环锁定传送",
    Value = false,
    Callback = function(isEnabled)
        PlayerConfig.LoopTeleport = isEnabled
        
        if isEnabled then
            task.spawn(function()
                while PlayerConfig.LoopTeleport do
                    task.wait(0.1)
                    local localPlayer = game.Players.LocalPlayer
                    local localRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
                    local targetRoot = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if localRoot and targetRoot then
                        localRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
                    end
                end
            end)
        end
    end
})

Tabs.Attack:Button({
    Title = "把玩家传送过来",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        local localRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
        local targetRoot = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if localRoot and targetRoot then
            targetRoot.CFrame = localRoot.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

Tabs.Attack:Toggle({
    Title = "循环传送玩家过来",
    Value = false,
    Callback = function(isEnabled)
        PlayerConfig.LoopTeleportToMe = isEnabled
        
        if isEnabled then
            task.spawn(function()
                while PlayerConfig.LoopTeleportToMe do
                    task.wait(0.1)
                    local localPlayer = game.Players.LocalPlayer
                    local localRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
                    local targetRoot = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if localRoot and targetRoot then
                        targetRoot.CFrame = localRoot.CFrame + Vector3.new(0, 3, 0)
                    end
                end
            end)
        end
    end
})

local infiniteJumpEnabled = false
local jumpConnection

local function toggleInfiniteJump(state)
    infiniteJumpEnabled = state
    
    if state then
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end

local tpSpeed = 1
local tpEnabled = false
local tpHeartbeatConnection = nil
local character, humanoid
local tpIsInitialized = false

local function setupCharacter()
    character = Players.LocalPlayer.Character
    if character then
        humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            repeat task.wait() until Players.LocalPlayer.Character ~= nil
            setupCharacter()
            if tpEnabled then
                startTPWalk()
            end
        end)
        return true
    end
    return false
end

local function startTPWalk()
    if tpHeartbeatConnection then
        tpHeartbeatConnection:Disconnect()
    end
    tpHeartbeatConnection = RunService.Heartbeat:Connect(function()
        if not tpEnabled or not character or not humanoid or humanoid.Health <= 0 then
            return
        end
        if humanoid.MoveDirection.Magnitude > 0 then
            local currentCFrame = character.PrimaryPart.CFrame
            local newPosition = currentCFrame.Position + (humanoid.MoveDirection * tpSpeed)
            character:SetPrimaryPartCFrame(CFrame.new(newPosition) * currentCFrame.Rotation)
        end
    end)
end

local function stopTPWalk()
    if tpHeartbeatConnection then
        tpHeartbeatConnection:Disconnect()
        tpHeartbeatConnection = nil
    end
end

local function initializeTPSystem()
    local success = setupCharacter()
    
    if not success then
        Players.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
            setupCharacter()
            if tpEnabled then
                startTPWalk()
            end
        end)
    end
    
    tpIsInitialized = true
end
initializeTPSystem()

local fovValue = 70
local fovEnabled = false
local fovRenderConnection = nil
local fovIsInitialized = false
local fovConnections = {}

local function initializeFOVSystem()
    for _, connection in pairs(fovConnections) do
        connection:Disconnect()
    end
    fovConnections = {}
    
    local LocalPlayer = Players.LocalPlayer
    
    local function updateFOV()
        local camera = workspace.CurrentCamera
        if camera then
            camera.FieldOfView = fovValue
        end
    end
    
    local cameraConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        if fovEnabled then
            updateFOV()
        end
    end)
    table.insert(fovConnections, cameraConnection)
    
    if LocalPlayer.Character then
        if fovEnabled then
            updateFOV()
        end
    end
    
    local characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function()
        if fovEnabled then
            updateFOV()
        end
    end)
    table.insert(fovConnections, characterAddedConnection)
    
    local function startFOVUpdate()
        if fovRenderConnection then
            fovRenderConnection:Disconnect()
        end
        
        fovRenderConnection = RunService.RenderStepped:Connect(function()
            if fovEnabled then
                updateFOV()
            end
        end)
        table.insert(fovConnections, fovRenderConnection)
    end
    
    if fovEnabled then
        startFOVUpdate()
    end
    
    fovIsInitialized = true
end

local function startFOV()
    if fovRenderConnection then
        fovRenderConnection:Disconnect()
    end
    
    fovRenderConnection = RunService.RenderStepped:Connect(function()
        if fovEnabled then
            local camera = workspace.CurrentCamera
            if camera then
                camera.FieldOfView = fovValue
            end
        end
    end)
end

local function stopFOV()
    if fovRenderConnection then
        fovRenderConnection:Disconnect()
        fovRenderConnection = nil
    end
end

Tabs.Player:Toggle({
    Title = "连跳功能",
    Value = false,
    Callback = function(state)
        toggleInfiniteJump(state)
    end
})

Tabs.Player:Slider({
    Title = "TP步行速度",
    Value = { Min = 1, Max = 15, Default = 1 },
    Callback = function(value)
        tpSpeed = value
    end
})

Tabs.Player:Toggle({
    Title = "TP步行开关",
    Value = false,
    Callback = function(state)
        tpEnabled = state
        if state then
            if not tpIsInitialized then
                initializeTPSystem()
            end
            if character and humanoid then
                startTPWalk()
            end
        else
            stopTPWalk()
        end
    end
})

Tabs.Player:Slider({
    Title = "FOV大小",
    Value = {
        Min = 70,
        Max = 120,
        Default = 70,
    },
    Callback = function(value)
        fovValue = value
        if fovEnabled then
            local camera = workspace.CurrentCamera
            if camera then
                camera.FieldOfView = fovValue
            end
        end
    end
})

Tabs.Player:Toggle({
    Title = "FOV开关",
    Value = false,
    Callback = function(state)
        fovEnabled = state
        if state then
            if not fovIsInitialized then
                initializeFOVSystem()
            end
            startFOV()
        else
            stopFOV()
        end
    end
})

local rep = game:GetService("ReplicatedStorage")
local plr = game.Players.LocalPlayer
local Network = require(rep.Shared.Core.Network)

local char = plr.Character or plr.CharacterAdded:Wait()
local charConnection = plr.CharacterAdded:Connect(function(c)
    char = c
end)

local AuraSystem = {
    Running = false,
    Tasks = {},
    Cooldowns = {},
    LastUpdate = {},
    BufferSize = 10,
    Performance = {
        TargetFPS = 60,
        FrameTime = 1/60
    }
}

local function initializeAuraSystem()
    if AuraSystem.Running then return end
    
    AuraSystem.Running = true
    
    local taskScheduler = coroutine.create(function()
        while AuraSystem.Running do
            local startTime = tick()
            
            if AuraSystem.Tasks.register then
                coroutine.wrap(function()
                    AuraSystem.Tasks.register()
                end)()
            end
            
            if AuraSystem.Tasks.atm then
                coroutine.wrap(function()
                    AuraSystem.Tasks.atm()
                end)()
            end
            
            local elapsed = tick() - startTime
            local sleepTime = math.max(0.01, AuraSystem.Performance.FrameTime - elapsed)
            
            if sleepTime > 0 then
                task.wait(sleepTime)
            else
                AuraSystem.Performance.FrameTime = math.min(0.05, AuraSystem.Performance.FrameTime * 1.05)
            end
        end
    end)
    
    coroutine.resume(taskScheduler)
end

local function stopAuraSystem()
    AuraSystem.Running = false
    AuraSystem.Tasks = {}
    AuraSystem.Cooldowns = {}
    AuraSystem.LastUpdate = {}
end

local GizmoCache = {
    register = {Data = {}, Time = 0, TTL = 0.5},
    atm = {Data = {}, Time = 0, TTL = 0.5}
}

local function GetSortedGizmos(gizmoName, gizmoType)
    local cache = GizmoCache[gizmoType:lower()]
    if cache and tick() - cache.Time < cache.TTL then
        return cache.Data
    end
    
    local targets = {}
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then 
        GizmoCache[gizmoType:lower()] = {Data = targets, Time = tick(), TTL = 0.5}
        return targets 
    end
    
    local myPos = root.Position
    local gizmoFolder = workspace.Local.Gizmos

    for _, v in pairs(gizmoFolder:GetDescendants()) do
        if v.Name == gizmoName and v:GetAttribute("gizmoType") == gizmoType then
            local targetPart = v:FindFirstChild("Metal") or v:FindFirstChildOfClass("BasePart") or v:FindFirstChildOfClass("MeshPart")
            local targetPos = (targetPart and targetPart:IsA("BasePart") and targetPart.Position) or (v:IsA("BasePart") and v.Position)
            
            if targetPos then
                local dist = (myPos - targetPos).Magnitude
                table.insert(targets, {
                    Instance = v,
                    Part = targetPart,
                    Dist = dist,
                    Position = targetPos,
                    Id = v:GetAttribute("objectId")
                })
            end
        end
    end
    
    table.sort(targets, function(a, b)
        return a.Dist < b.Dist
    end)
    
    GizmoCache[gizmoType:lower()] = {Data = targets, Time = tick(), TTL = 0.5}
    return targets
end

local function SafeNetworkFire(gizmoType, args)
    local now = tick()
    local cooldownKey = gizmoType .. "_" .. tostring(args[1].id)
    
    if AuraSystem.Cooldowns[cooldownKey] and now - AuraSystem.Cooldowns[cooldownKey] < 0.1 then
        return
    end
    
    local success, err = pcall(function()
        Network.FireServer("registerMeleeHits", args)
    end)
    
    if success then
        AuraSystem.Cooldowns[cooldownKey] = now
    end
end

local function CreateAuraTask(gizmoName, gizmoType)
    return function()
        local lastUpdate = AuraSystem.LastUpdate[gizmoType] or 0
        if tick() - lastUpdate < 0.05 then
            return
        end
        
        local targets = GetSortedGizmos(gizmoName, gizmoType)
        
        for _, info in ipairs(targets) do
            if not AuraSystem.Tasks[gizmoType:lower()] then break end
            
            if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                break
            end
            
            local args = {{
                normal = Vector3.new(0, 1, 0),
                direction = Vector3.new(0, -1, 0),
                source = "Melee",
                id = info.Id,
                material = Enum.Material.Metal,
                position = info.Position,
                gizmoType = gizmoType,
                processedPlayerId = plr.UserId,
                hit = info.Part,
                speed = 50,
                collisionPoint = info.Position,
                hitName = "Metal",
                hitType = "gizmo"
            }}
            
            SafeNetworkFire(gizmoType, args)
            
            if #targets > 5 then
                task.wait(0.001)
            end
        end
        
        AuraSystem.LastUpdate[gizmoType] = tick()
    end
end

Tabs.Auto:Toggle({
    Title = "收银机光环",
    Default = false,
    Callback = function(state)
        if state then
            if not AuraSystem.Running then
                initializeAuraSystem()
            end
            
            AuraSystem.Tasks.register = CreateAuraTask("Register", "Register")
        else
            AuraSystem.Tasks.register = nil
            
            if not AuraSystem.Tasks.atm then
                stopAuraSystem()
            end
        end
    end
})

Tabs.Auto:Toggle({
    Title = "ATM光环",
    Default = false,
    Callback = function(state)
        if state then
            if not AuraSystem.Running then
                initializeAuraSystem()
            end
            
            AuraSystem.Tasks.atm = CreateAuraTask("ATM", "ATM")
        else
            AuraSystem.Tasks.atm = nil
            
            if not AuraSystem.Tasks.register then
                stopAuraSystem()
            end
        end
    end
})

local RainHub335 = {
    RainHub304 = false,
    RainHub307 = false,
    RainHub306 = {},
    RainHub336 = {},
    RainHub337 = {
        RainHub338 = false,
        RainHub339 = false,
        RainHub340 = {
            Vector3.new(-1137.00, 78.31, -1953.00),
            Vector3.new(-44.00, 63.20, -2083.00),
            Vector3.new(194.00, 45.62, -2884.00),
            Vector3.new(-370.81, 72.17, -1183.00)
        },
        RainHub341 = nil
    }
}

function RainHub335:RainHub342()
    if self.RainHub307 then 
        return 
    end
    self.RainHub307 = true
    
    self.RainHub337.RainHub338 = true
    self.RainHub337.RainHub339 = true
    self.RainHub337.RainHub341 = nil
    
    local RainHub325 = game:GetService("Players")
    local RainHub310 = game:GetService("RunService")
    local RainHub343 = game:GetService("VirtualInputManager")
    
    local RainHub326 = RainHub325.LocalPlayer
    local RainHub313 = RainHub326.Character or RainHub326.CharacterAdded:Wait()
    local RainHub158 = RainHub313:WaitForChild("HumanoidRootPart")
    
    local function RainHub344()
        return Vector3.new(
            math.random(-5, 5),
            0,
            math.random(-5, 5)
        )
    end
    
    local function RainHub345(RainHub346)
        local RainHub347 = RaycastParams.new()
        RainHub347.FilterType = Enum.RaycastFilterType.Exclude
        RainHub347.FilterDescendantsInstances = {RainHub313}
        
        local RainHub348 = Vector3.new(RainHub346.X, RainHub346.Y + 100, RainHub346.Z)
        local RainHub349 = Vector3.new(0, -200, 0)
        local RainHub350 = workspace:Raycast(RainHub348, RainHub349, RainHub347)
        
        if RainHub350 and RainHub350.Position then
            return RainHub350.Position + Vector3.new(0, 3, 0)
        end
        
        return RainHub346 + Vector3.new(0, 5, 0)
    end
    
    local function RainHub351()
        local RainHub352 = {}
        
        for RainHub194 = 1, #self.RainHub337.RainHub340 do
            if RainHub194 ~= self.RainHub337.RainHub341 then
                table.insert(RainHub352, RainHub194)
            end
        end
        
        if #RainHub352 == 0 then
            RainHub352 = {1, 2, 3, 4}
        end
        
        local RainHub353 = math.random(1, #RainHub352)
        local RainHub354 = RainHub352[RainHub353]
        self.RainHub337.RainHub341 = RainHub354
        
        return self.RainHub337.RainHub340[RainHub354]
    end
    
    local function RainHub355()
        if not RainHub313 or not RainHub313.Parent then
            RainHub313 = RainHub326.Character
            if not RainHub313 then
                return false
            end
        end
        
        RainHub158 = RainHub313:FindFirstChild("HumanoidRootPart")
        if not RainHub158 then
            return false
        end
        
        return true
    end
    
    local function RainHub356(RainHub357)
        local RainHub358 = {}
        
        local function RainHub359(RainHub360)
            if RainHub360:IsA("Model") or RainHub360:IsA("BasePart") then
                if RainHub360.Name:lower():find("atm") then
                    table.insert(RainHub358, RainHub360)
                end
            end
            
            for _, RainHub361 in ipairs(RainHub360:GetChildren()) do
                RainHub359(RainHub361)
            end
        end
        
        if RainHub357 then
            RainHub359(RainHub357)
        end
        return RainHub358
    end
    
    local function RainHub362()
        RainHub343:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.01)
        RainHub343:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
    
    local function RainHub363()
        local RainHub364 = workspace:FindFirstChild("Local")
        if not RainHub364 then return nil end
        
        local RainHub365 = RainHub364:FindFirstChild("Gizmos")
        if not RainHub365 then return nil end
        
        local RainHub366 = RainHub365:FindFirstChild("White")
        return RainHub366
    end
    
    local function RainHub367()
        while self.RainHub307 and self.RainHub337.RainHub338 do
            if not RainHub355() then
                task.wait(1)
                RainHub313 = RainHub326.Character or RainHub326.CharacterAdded:Wait()
                RainHub158 = RainHub313:WaitForChild("HumanoidRootPart")
            end
            
            local RainHub368 = RainHub351()
            local RainHub369 = RainHub344()
            local RainHub370 = RainHub368 + RainHub369
            local RainHub371 = RainHub345(RainHub370)
            
            pcall(function()
                RainHub158.CFrame = CFrame.new(RainHub371)
            end)
            
            task.wait(1)
        end
    end
    
    local function RainHub372()
        while self.RainHub307 and self.RainHub337.RainHub339 do
            task.wait(0.1)
            
            local RainHub313 = RainHub326.Character
            if not RainHub313 then
                task.wait(0.5)
                continue
            end
            
            local RainHub158 = RainHub313:FindFirstChild("HumanoidRootPart")
            if not RainHub158 then
                task.wait(0.5)
                continue
            end
            
            local RainHub373 = RainHub363()
            if not RainHub373 then
                task.wait(1)
                continue
            end
            
            local RainHub358 = RainHub356(RainHub373)
            
            if #RainHub358 == 0 then
                task.wait(1)
                continue
            end
            
            for _, RainHub374 in ipairs(RainHub358) do
                if not self.RainHub307 or not self.RainHub337.RainHub339 then break end
                
                local RainHub375
                if RainHub374:IsA("Model") then
                    local RainHub376 = RainHub374.PrimaryPart or RainHub374:FindFirstChildWhichIsA("BasePart")
                    if RainHub376 then
                        RainHub375 = RainHub376.Position
                    else
                        continue
                    end
                elseif RainHub374:IsA("BasePart") then
                    RainHub375 = RainHub374.Position
                else
                    continue
                end
                
                local RainHub377 = RainHub375 + Vector3.new(0, 0, -3)
                
                pcall(function()
                    RainHub158.CFrame = CFrame.new(RainHub377)
                end)
                
                task.wait(0.05)
                RainHub362()
                task.wait(0.05)
            end
        end
    end
    
    self.RainHub336.RainHub378 = task.spawn(RainHub367)
    self.RainHub336.RainHub379 = task.spawn(RainHub372)
    
    self.RainHub306.RainHub317 = RainHub326.CharacterAdded:Connect(function(RainHub380)
        RainHub313 = RainHub380
        RainHub158 = RainHub313:WaitForChild("HumanoidRootPart")
    end)
end

function RainHub335:RainHub381()
    if not self.RainHub307 then 
        return 
    end
    self.RainHub307 = false
    
    self.RainHub337.RainHub338 = false
    self.RainHub337.RainHub339 = false
    
    for _, RainHub311 in pairs(self.RainHub306) do
        if RainHub311 then
            RainHub311:Disconnect()
        end
    end
    
    self.RainHub306 = {}
    self.RainHub336 = {}
    self.RainHub337.RainHub341 = nil
end

local RainHub382 = {
    RainHub304 = false,
    RainHub307 = false,
    RainHub306 = {},
    RainHub383 = nil,
    RainHub384 = Vector3.new(-386.98, 621.04, -1194.99),
    RainHub385 = {
        RainHub386 = "Workspace.Local.Gizmos.White",
        RainHub387 = "MainBankCash",
        RainHub388 = 0.1,
        RainHub389 = 0.01,
        RainHub390 = CFrame.new(0, 3, 0),
        RainHub391 = 10,
        RainHub392 = 20 * 60,
    }
}

function RainHub382:RainHub342()
    if self.RainHub307 then 
        return 
    end
    self.RainHub307 = true
    self.RainHub304 = true
    
    self:RainHub393()
    
    self.RainHub383 = task.spawn(function()
        local RainHub325 = game:GetService("Players")
        local RainHub310 = game:GetService("RunService")
        local RainHub394 = game:GetService("UserInputService")
        
        local RainHub156 = RainHub325.LocalPlayer
        if not RainHub156 then 
            self.RainHub307 = false
            return 
        end
        
        local RainHub157 = RainHub156.Character or RainHub156.CharacterAdded:Wait()
        local RainHub212 = RainHub157:WaitForChild("Humanoid")
        
        local RainHub385 = self.RainHub385
        local RainHub386 = RainHub385.RainHub386
        local RainHub387 = RainHub385.RainHub387
        local RainHub388 = RainHub385.RainHub388
        local RainHub389 = RainHub385.RainHub389
        local RainHub390 = RainHub385.RainHub390
        local RainHub391 = RainHub385.RainHub391
        local RainHub392 = RainHub385.RainHub392
        
        local RainHub395 = {}
        local RainHub396 = nil
        local RainHub397 = true
        local RainHub398 = false
        local RainHub399 = nil
        local RainHub400 = 0
        local RainHub401 = tick()
        
        local workspace = game:GetService("Workspace")
        local RainHub402 = nil
        
        local function RainHub403()
            local RainHub404 = workspace:FindFirstChild("Local")
            if not RainHub404 then return false end
            
            local RainHub365 = RainHub404:FindFirstChild("Gizmos")
            if not RainHub365 then return false end
            
            RainHub402 = RainHub365:FindFirstChild("White")
            return RainHub402 ~= nil
        end
        
        local function RainHub405()
            if not RainHub402 or not RainHub402.Parent then
                if not RainHub403() then
                    return false
                end
            end
            
            table.clear(RainHub395)
            
            for _, RainHub361 in ipairs(RainHub402:GetChildren()) do
                if RainHub361.Name == RainHub387 and RainHub361:IsA("Model") then
                    table.insert(RainHub395, RainHub361)
                end
            end
            
            return #RainHub395 > 0
        end
        
        local function RainHub406()
            if RainHub398 then
                RainHub398 = false
                if RainHub399 then
                    RainHub399:Disconnect()
                    RainHub399 = nil
                end
            end
        end
        
        local function RainHub407(RainHub408, RainHub409)
            local RainHub410 = RainHub409.X - RainHub408.X
            local RainHub411 = RainHub409.Y - RainHub408.Y
            local RainHub412 = RainHub409.Z - RainHub408.Z
            return math.sqrt(RainHub410*RainHub410 + RainHub411*RainHub411 + RainHub412*RainHub412)
        end
        
        local function RainHub413()
            if not RainHub396 or not RainHub157 or not RainHub157.PrimaryPart then
                return false
            end
            
            local RainHub414 = RainHub396.PrimaryPart
            if not RainHub414 then
                for _, RainHub223 in ipairs(RainHub396:GetChildren()) do
                    if RainHub223:IsA("BasePart") then
                        RainHub414 = RainHub223
                        break
                    end
                end
            end
            
            if not RainHub414 or not RainHub157.PrimaryPart then
                return false
            end
            
            return RainHub407(RainHub157.PrimaryPart.Position, RainHub414.Position) <= RainHub391
        end
        
        local function RainHub415()
            if #RainHub395 == 0 then return nil end
            return RainHub395[math.random(1, #RainHub395)]
        end
        
        local function RainHub416(RainHub360)
            local RainHub376 = RainHub360.PrimaryPart
            if RainHub376 then return RainHub376 end
            
            for _, RainHub223 in ipairs(RainHub360:GetChildren()) do
                if RainHub223:IsA("BasePart") then
                    return RainHub223
                end
            end
            return nil
        end
        
        local function RainHub417(RainHub418)
            if not RainHub418 or not RainHub418.Parent then
                return false
            end
            
            local RainHub414 = RainHub416(RainHub418)
            if not RainHub414 or not RainHub157 or not RainHub157.PrimaryPart then
                return false
            end
            
            RainHub396 = RainHub418
            
            RainHub157:SetPrimaryPartCFrame(RainHub414.CFrame * RainHub390)
            
            return true
        end
        
        local function RainHub419()
            local RainHub420 = tick()
            
            if RainHub420 - RainHub401 >= RainHub392 then
                if RainHub157 and RainHub157.PrimaryPart then
                    local RainHub421 = CFrame.new(self.RainHub384)
                    RainHub157:SetPrimaryPartCFrame(RainHub421)
                    RainHub401 = tick()
                end
            end
        end
        
        local function RainHub422()
            if not RainHub397 or not RainHub396 then return end
            
            local RainHub343 = game:GetService("VirtualInputManager")
            if not RainHub343 then return end
            
            pcall(function()
                RainHub343:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
                task.wait(0.01)
                RainHub343:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
            end)
        end
        
        local function RainHub423()
            RainHub397 = false
            RainHub406()
            table.clear(RainHub395)
            RainHub396 = nil
        end
        
        local function RainHub424()
            while RainHub397 and self.RainHub304 do
                local RainHub420 = tick()
                
                RainHub419()
                
                if RainHub420 - RainHub400 >= RainHub388 then
                    RainHub400 = RainHub420
                    
                    local RainHub425 = RainHub405()
                    
                    if RainHub425 then
                        local RainHub426 = RainHub396 and RainHub396.Parent and RainHub413()
                        
                        if not RainHub426 then
                            RainHub406()
                            
                            local RainHub427 = RainHub415()
                            if RainHub427 then
                                if RainHub417(RainHub427) then
                                    RainHub398 = true
                                end
                            end
                        else
                            if not RainHub398 then
                                RainHub398 = true
                            end
                        end
                    else
                        RainHub406()
                        RainHub396 = nil
                    end
                end
                
                if RainHub398 and RainHub396 then
                    RainHub422()
                end
                
                task.wait(RainHub389)
            end
        end
        
        self.RainHub306.RainHub428 = RainHub156.CharacterRemoving:Connect(RainHub423)
        
        self.RainHub306.RainHub429 = RainHub394.WindowFocusReleased:Connect(function()
            RainHub423()
        end)
        
        self.RainHub306.RainHub430 = RainHub394.WindowFocused:Connect(function()
            if not RainHub397 then
                RainHub397 = true
                task.spawn(RainHub424)
            end
        end)
        
        self.RainHub306.RainHub317 = RainHub156.CharacterAdded:Connect(function(RainHub380)
            RainHub157 = RainHub380
            RainHub212 = RainHub157:WaitForChild("Humanoid")
            if not RainHub397 then
                RainHub397 = true
                task.spawn(RainHub424)
            end
        end)
        
        if RainHub403() then
            RainHub424()
        else
            self.RainHub307 = false
        end
        
        while RainHub397 and self.RainHub304 do
            task.wait(1)
        end
        
        RainHub423()
    end)
end

function RainHub382:RainHub393()
    local RainHub156 = game:GetService("Players").LocalPlayer
    if not RainHub156 then return false end
    
    local RainHub157 = RainHub156.Character or RainHub156.CharacterAdded:Wait()
    if not RainHub157 then return false end
    
    local RainHub158 = RainHub157:WaitForChild("HumanoidRootPart")
    if not RainHub158 then return false end
    
    pcall(function()
        RainHub158.CFrame = CFrame.new(self.RainHub384)
    end)
    
    return true
end

function RainHub382:RainHub381()
    if not self.RainHub307 then 
        return 
    end
    self.RainHub307 = false
    self.RainHub304 = false
    
    for _, RainHub311 in pairs(self.RainHub306) do
        if RainHub311 then
            RainHub311:Disconnect()
        end
    end
    
    self.RainHub306 = {}
    
    if self.RainHub383 then
        task.cancel(self.RainHub383)
        self.RainHub383 = nil
    end
end

local RainHub431 = {
    RainHub304 = false,
    RainHub307 = false,
    RainHub306 = {},
    RainHub383 = nil,
    RainHub385 = {
        RainHub386 = "Workspace.Local.Gizmos.White",
        RainHub387 = "CashPallet",
        RainHub388 = 0.1,
        RainHub389 = 0.01,
        RainHub390 = CFrame.new(0, 3, 0),
        RainHub391 = 10,
    }
}

function RainHub431:RainHub342()
    if self.RainHub307 then 
        return 
    end
    self.RainHub307 = true
    self.RainHub304 = true
    
    self.RainHub383 = task.spawn(function()
        local RainHub325 = game:GetService("Players")
        local RainHub310 = game:GetService("RunService")
        local RainHub394 = game:GetService("UserInputService")
        
        local RainHub156 = RainHub325.LocalPlayer
        if not RainHub156 then 
            self.RainHub307 = false
            return 
        end
        
        local RainHub157 = RainHub156.Character or RainHub156.CharacterAdded:Wait()
        local RainHub212 = RainHub157:WaitForChild("Humanoid")
        
        local RainHub385 = self.RainHub385
        local RainHub386 = RainHub385.RainHub386
        local RainHub387 = RainHub385.RainHub387
        local RainHub388 = RainHub385.RainHub388
        local RainHub389 = RainHub385.RainHub389
        local RainHub390 = RainHub385.RainHub390
        local RainHub391 = RainHub385.RainHub391
        
        local RainHub395 = {}
        local RainHub396 = nil
        local RainHub397 = true
        local RainHub398 = false
        local RainHub400 = 0
        
        local workspace = game:GetService("Workspace")
        local RainHub402 = nil
        
        local function RainHub403()
            local RainHub404 = workspace:FindFirstChild("Local")
            if not RainHub404 then return false end
            
            local RainHub365 = RainHub404:FindFirstChild("Gizmos")
            if not RainHub365 then return false end
            
            RainHub402 = RainHub365:FindFirstChild("White")
            return RainHub402 ~= nil
        end
        
        local function RainHub405()
            if not RainHub402 or not RainHub402.Parent then
                if not RainHub403() then
                    return false
                end
            end
            
            table.clear(RainHub395)
            
            for _, RainHub361 in ipairs(RainHub402:GetChildren()) do
                if RainHub361.Name == RainHub387 and RainHub361:IsA("Model") then
                    table.insert(RainHub395, RainHub361)
                end
            end
            
            return #RainHub395 > 0
        end
        
        local function RainHub407(RainHub408, RainHub409)
            local RainHub410 = RainHub409.X - RainHub408.X
            local RainHub411 = RainHub409.Y - RainHub408.Y
            local RainHub412 = RainHub409.Z - RainHub408.Z
            return math.sqrt(RainHub410*RainHub410 + RainHub411*RainHub411 + RainHub412*RainHub412)
        end
        
        local function RainHub413()
            if not RainHub396 or not RainHub157 or not RainHub157.PrimaryPart then
                return false
            end
            
            local RainHub414 = RainHub396.PrimaryPart
            if not RainHub414 then
                for _, RainHub223 in ipairs(RainHub396:GetChildren()) do
                    if RainHub223:IsA("BasePart") then
                        RainHub414 = RainHub223
                        break
                    end
                end
            end
            
            if not RainHub414 or not RainHub157.PrimaryPart then
                return false
            end
            
            return RainHub407(RainHub157.PrimaryPart.Position, RainHub414.Position) <= RainHub391
        end
        
        local function RainHub415()
            if #RainHub395 == 0 then return nil end
            return RainHub395[math.random(1, #RainHub395)]
        end
        
        local function RainHub416(RainHub360)
            local RainHub376 = RainHub360.PrimaryPart
            if RainHub376 then return RainHub376 end
            
            for _, part in ipairs(RainHub360:GetChildren()) do
                if part:IsA("BasePart") then
                    return part
                end
            end
            return nil
        end
        
        local function RainHub417(RainHub418)
            if not RainHub418 or not RainHub418.Parent then
                return false
            end
            
            local RainHub414 = RainHub416(RainHub418)
            if not RainHub414 or not RainHub157 or not RainHub157.PrimaryPart then
                return false
            end
            
            RainHub396 = RainHub418
            
            RainHub157:SetPrimaryPartCFrame(RainHub414.CFrame * RainHub390)
            
            return true
        end
        
        local function RainHub422()
            if not RainHub397 or not RainHub396 then return end
            
            local RainHub343 = game:GetService("VirtualInputManager")
            if not RainHub343 then return end
            
            pcall(function()
                RainHub343:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
                task.wait(0.01)
                RainHub343:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
            end)
        end
        
        local function RainHub423()
            RainHub397 = false
            RainHub398 = false
            table.clear(RainHub395)
            RainHub396 = nil
        end
        
        local function RainHub424()
            while RainHub397 and self.RainHub304 do
                local RainHub420 = tick()
                
                if RainHub420 - RainHub400 >= RainHub388 then
                    RainHub400 = RainHub420
                    
                    local RainHub425 = RainHub405()
                    
                    if RainHub425 then
                        local RainHub426 = RainHub396 and RainHub396.Parent and RainHub413()
                        
                        if not RainHub426 then
                            local RainHub427 = RainHub415()
                            if RainHub427 then
                                if RainHub417(RainHub427) then
                                    RainHub398 = true
                                end
                            end
                        else
                            if not RainHub398 then
                                RainHub398 = true
                            end
                        end
                    else
                        RainHub396 = nil
                        RainHub398 = false
                    end
                end
                
                if RainHub398 and RainHub396 then
                    RainHub422()
                end
                
                task.wait(RainHub389)
            end
        end
        
        self.RainHub306.RainHub428 = RainHub156.CharacterRemoving:Connect(RainHub423)
        
        self.RainHub306.RainHub429 = RainHub394.WindowFocusReleased:Connect(function()
            RainHub423()
        end)
        
        self.RainHub306.RainHub430 = RainHub394.WindowFocused:Connect(function()
            if not RainHub397 then
                RainHub397 = true
                task.spawn(RainHub424)
            end
        end)
        
        self.RainHub306.RainHub317 = RainHub156.CharacterAdded:Connect(function(RainHub380)
            RainHub157 = RainHub380
            RainHub212 = RainHub157:WaitForChild("Humanoid")
            if not RainHub397 then
                RainHub397 = true
                task.spawn(RainHub424)
            end
        end)
        
        if RainHub403() then
            RainHub424()
        else
            self.RainHub307 = false
        end
        
        while RainHub397 and self.RainHub304 do
            task.wait(1)
        end
        
        RainHub423()
    end)
end

function RainHub431:RainHub381()
    if not self.RainHub307 then 
        return 
    end
    self.RainHub307 = false
    self.RainHub304 = false
    
    for _, RainHub311 in pairs(self.RainHub306) do
        if RainHub311 then
            RainHub311:Disconnect()
        end
    end
    
    self.RainHub306 = {}
    
    if self.RainHub383 then
        task.cancel(self.RainHub383)
        self.RainHub383 = nil
    end
end

Tabs.Auto:Toggle({
    Title = "自动ATM",
    Default = false,
    Callback = function(state)
        RainHub335.RainHub304 = state
        if state then
            RainHub335:RainHub342()
        else
            RainHub335:RainHub381()
        end
    end
})

Tabs.Auto:Toggle({
    Title = "自动银行",
    Default = false,
    Callback = function(state)
        if state then
            RainHub382:RainHub393()
            RainHub382.RainHub304 = state
            RainHub382:RainHub342()
        else
            RainHub382.RainHub304 = state
            RainHub382:RainHub381()
        end
    end
})

Tabs.Auto:Toggle({
    Title = "自动现金盘",
    Default = false,
    Callback = function(state)
        if state then
            RainHub431.RainHub304 = state
            RainHub431:RainHub342()
        else
            RainHub431.RainHub304 = state
            RainHub431:RainHub381()
        end
    end
})

local MoneyAura = {
    Enabled = false,
    Running = false,
    Connections = {},
    Config = {
        TARGET_PATH = "Workspace.Local.Gizmos.Green",
        MODEL_NAME = "Cash",
        CHECK_INTERVAL = 0.01,
        TELEPORT_OFFSET = CFrame.new(0, 3, 0),
        PROXIMITY_RANGE = 10
    },
    State = {
        DetectedModels = {},
        CurrentTarget = nil,
        LastCheckTime = 0,
        WhiteContainer = nil
    }
}

function MoneyAura:Initialize()
    local workspace = game:GetService("Workspace")
    local localPart = workspace:FindFirstChild("Local")
    if not localPart then return false end
    
    local gizmos = localPart:FindFirstChild("Gizmos")
    if not gizmos then return false end
    
    self.State.WhiteContainer = gizmos:FindFirstChild("Green")
    return self.State.WhiteContainer ~= nil
end

function MoneyAura:FindModels()
    if not self.State.WhiteContainer or not self.State.WhiteContainer.Parent then
        if not self:Initialize() then
            return false
        end
    end
    
    table.clear(self.State.DetectedModels)
    
    for _, child in ipairs(self.State.WhiteContainer:GetChildren()) do
        if child.Name == self.Config.MODEL_NAME and child:IsA("Model") then
            table.insert(self.State.DetectedModels, child)
        end
    end
    
    return #self.State.DetectedModels > 0
end

function MoneyAura:GetDistance(position1, position2)
    local dx = position2.X - position1.X
    local dy = position2.Y - position1.Y
    local dz = position2.Z - position1.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

function MoneyAura:IsNearTarget()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    
    if not self.State.CurrentTarget or not character or not character.PrimaryPart then
        return false
    end
    
    local targetPart = self.State.CurrentTarget.PrimaryPart
    if not targetPart then
        for _, part in ipairs(self.State.CurrentTarget:GetChildren()) do
            if part:IsA("BasePart") then
                targetPart = part
                break
            end
        end
    end
    
    if not targetPart or not character.PrimaryPart then
        return false
    end
    
    return self:GetDistance(character.PrimaryPart.Position, targetPart.Position) <= self.Config.PROXIMITY_RANGE
end

function MoneyAura:GetRandomTarget()
    if #self.State.DetectedModels == 0 then return nil end
    return self.State.DetectedModels[math.random(1, #self.State.DetectedModels)]
end

function MoneyAura:GetTargetPrimaryPart(model)
    local primary = model.PrimaryPart
    if primary then return primary end
    
    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") then
            return part
        end
    end
    return nil
end

function MoneyAura:TeleportToTarget(targetModel)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    
    if not targetModel or not targetModel.Parent then
        return false
    end
    
    local targetPart = self:GetTargetPrimaryPart(targetModel)
    if not targetPart or not character or not character.PrimaryPart then
        return false
    end
    
    self.State.CurrentTarget = targetModel
    
    pcall(function()
        character:SetPrimaryPartCFrame(targetPart.CFrame * self.Config.TELEPORT_OFFSET)
    end)
    
    return true
end

function MoneyAura:MainLoop()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local player = Players.LocalPlayer
    
    while self.Running do
        local currentTime = tick()
        
        if currentTime - self.State.LastCheckTime >= self.Config.CHECK_INTERVAL then
            self.State.LastCheckTime = currentTime
            
            local character = player.Character
            if not character then
                task.wait(0.5)
                continue
            end
            
            local hasModels = self:FindModels()
            
            if hasModels then
                local targetValid = self.State.CurrentTarget and 
                                   self.State.CurrentTarget.Parent and 
                                   self:IsNearTarget()
                
                if not targetValid then
                    local newTarget = self:GetRandomTarget()
                    if newTarget then
                        self:TeleportToTarget(newTarget)
                    end
                end
            else
                self.State.CurrentTarget = nil
            end
        end
        
        task.wait(self.Config.CHECK_INTERVAL)
    end
end

function MoneyAura:Start()
    if self.Running then return end
    
    self.Running = true
    self.Enabled = true
    
    self:CleanupConnections()
    
    if not self:Initialize() then
        self.Running = false
        self.Enabled = false
        return
    end
    
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local player = Players.LocalPlayer
    
    self.Connections.WindowFocusReleased = UserInputService.WindowFocusReleased:Connect(function()
        self.Running = false
    end)
    
    self.Connections.WindowFocused = UserInputService.WindowFocused:Connect(function()
        if not self.Running and self.Enabled then
            self.Running = true
            task.spawn(function()
                self:MainLoop()
            end)
        end
    end)
    
    self.Connections.CharacterAdded = player.CharacterAdded:Connect(function(character)
        if self.Enabled and not self.Running then
            self.Running = true
            task.spawn(function()
                self:MainLoop()
            end)
        end
    end)
    
    task.spawn(function()
        self:MainLoop()
    end)
end

function MoneyAura:Stop()
    self.Running = false
    self.Enabled = false
    self:CleanupConnections()
    
    table.clear(self.State.DetectedModels)
    self.State.CurrentTarget = nil
    self.State.WhiteContainer = nil
    self.State.LastCheckTime = 0
end

function MoneyAura:CleanupConnections()
    for name, connection in pairs(self.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    self.Connections = {}
end

function MoneyAura:Toggle(state)
    if state then
        self:Start()
    else
        self:Stop()
    end
end

local GiftBoxAuto = {
    Enabled = false,
    Running = false,
    Connections = {},
    Config = {
        TARGET_PATH = "Workspace.Local.Gizmos.White",
        MODEL_NAME = "WorldItem",
        CHECK_INTERVAL = 0.1,
        SIMULATION_INTERVAL = 0.01,
        TELEPORT_OFFSET = CFrame.new(0, 3, 0),
        PROXIMITY_RANGE = 10
    },
    State = {
        DetectedModels = {},
        CurrentTarget = nil,
        IsSimulating = false,
        LastCheckTime = 0,
        WhiteContainer = nil
    }
}

function GiftBoxAuto:Initialize()
    local workspace = game:GetService("Workspace")
    local localPart = workspace:FindFirstChild("Local")
    if not localPart then return false end
    
    local gizmos = localPart:FindFirstChild("Gizmos")
    if not gizmos then return false end
    
    self.State.WhiteContainer = gizmos:FindFirstChild("White")
    return self.State.WhiteContainer ~= nil
end

function GiftBoxAuto:FindModels()
    if not self.State.WhiteContainer or not self.State.WhiteContainer.Parent then
        if not self:Initialize() then
            return false
        end
    end
    
    table.clear(self.State.DetectedModels)
    
    for _, child in ipairs(self.State.WhiteContainer:GetChildren()) do
        if child.Name == self.Config.MODEL_NAME and child:IsA("Model") then
            table.insert(self.State.DetectedModels, child)
        end
    end
    
    return #self.State.DetectedModels > 0
end

function GiftBoxAuto:StopSimulation()
    if self.State.IsSimulating then
        self.State.IsSimulating = false
    end
end

function GiftBoxAuto:GetDistance(position1, position2)
    local dx = position2.X - position1.X
    local dy = position2.Y - position1.Y
    local dz = position2.Z - position1.Z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

function GiftBoxAuto:IsNearTarget()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    
    if not self.State.CurrentTarget or not character or not character.PrimaryPart then
        return false
    end
    
    local targetPart = self.State.CurrentTarget.PrimaryPart
    if not targetPart then
        for _, part in ipairs(self.State.CurrentTarget:GetChildren()) do
            if part:IsA("BasePart") then
                targetPart = part
                break
            end
        end
    end
    
    if not targetPart or not character.PrimaryPart then
        return false
    end
    
    return self:GetDistance(character.PrimaryPart.Position, targetPart.Position) <= self.Config.PROXIMITY_RANGE
end

function GiftBoxAuto:GetRandomTarget()
    if #self.State.DetectedModels == 0 then return nil end
    return self.State.DetectedModels[math.random(1, #self.State.DetectedModels)]
end

function GiftBoxAuto:GetTargetPrimaryPart(model)
    local primary = model.PrimaryPart
    if primary then return primary end
    
    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") then
            return part
        end
    end
    return nil
end

function GiftBoxAuto:TeleportToTarget(targetModel)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    
    if not targetModel or not targetModel.Parent then
        return false
    end
    
    local targetPart = self:GetTargetPrimaryPart(targetModel)
    if not targetPart or not character or not character.PrimaryPart then
        return false
    end
    
    self.State.CurrentTarget = targetModel
    
    pcall(function()
        character:SetPrimaryPartCFrame(targetPart.CFrame * self.Config.TELEPORT_OFFSET)
    end)
    
    return true
end

function GiftBoxAuto:SimulateEKey()
    if not self.Enabled or not self.State.CurrentTarget then return end
    
    local virtualInputManager = game:GetService("VirtualInputManager")
    if not virtualInputManager then return end
    
    pcall(function()
        virtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
        task.wait(0.01)
        virtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
    end)
end

function GiftBoxAuto:MainLoop()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local player = Players.LocalPlayer
    
    while self.Running do
        local currentTime = tick()
        
        if currentTime - self.State.LastCheckTime >= self.Config.CHECK_INTERVAL then
            self.State.LastCheckTime = currentTime
            
            local character = player.Character
            if not character then
                task.wait(0.5)
                continue
            end
            
            local hasModels = self:FindModels()
            
            if hasModels then
                local targetValid = self.State.CurrentTarget and 
                                   self.State.CurrentTarget.Parent and 
                                   self:IsNearTarget()
                
                if not targetValid then
                    self:StopSimulation()
                    
                    local newTarget = self:GetRandomTarget()
                    if newTarget then
                        if self:TeleportToTarget(newTarget) then
                            self.State.IsSimulating = true
                        end
                    end
                else
                    if not self.State.IsSimulating then
                        self.State.IsSimulating = true
                    end
                end
            else
                self:StopSimulation()
                self.State.CurrentTarget = nil
            end
        end
        
        if self.State.IsSimulating and self.State.CurrentTarget then
            self:SimulateEKey()
        end
        
        task.wait(self.Config.SIMULATION_INTERVAL)
    end
end

function GiftBoxAuto:Start()
    if self.Running then return end
    
    self.Running = true
    self.Enabled = true
    
    self:CleanupConnections()
    
    if not self:Initialize() then
        self.Running = false
        self.Enabled = false
        return
    end
    
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local player = Players.LocalPlayer
    
    self.Connections.WindowFocusReleased = UserInputService.WindowFocusReleased:Connect(function()
        self.Running = false
    end)
    
    self.Connections.WindowFocused = UserInputService.WindowFocused:Connect(function()
        if not self.Running and self.Enabled then
            self.Running = true
            task.spawn(function()
                self:MainLoop()
            end)
        end
    end)
    
    self.Connections.CharacterAdded = player.CharacterAdded:Connect(function(character)
        if self.Enabled and not self.Running then
            self.Running = true
            task.spawn(function()
                self:MainLoop()
            end)
        end
    end)
    
    self.Connections.CharacterRemoving = player.CharacterRemoving:Connect(function()
        self:CleanupState()
    end)
    
    task.spawn(function()
        self:MainLoop()
    end)
end

function GiftBoxAuto:Stop()
    self.Running = false
    self.Enabled = false
    self:CleanupConnections()
    self:CleanupState()
end

function GiftBoxAuto:CleanupState()
    self:StopSimulation()
    table.clear(self.State.DetectedModels)
    self.State.CurrentTarget = nil
    self.State.WhiteContainer = nil
    self.State.LastCheckTime = 0
end

function GiftBoxAuto:CleanupConnections()
    for name, connection in pairs(self.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    self.Connections = {}
end

function GiftBoxAuto:Toggle(state)
    if state then
        self:Start()
    else
        self:Stop()
    end
end

Tabs.Auto:Toggle({
    Title = "金钱光环",
    Icon = "dollar-sign",
    Default = false,
    Callback = function(state)
        MoneyAura:Toggle(state)
    end
})

Tabs.Auto:Toggle({
    Title = "自动礼物盒",
    Icon = "gift",
    Default = false,
    Callback = function(state)
        GiftBoxAuto:Toggle(state)
    end
})

local ESPEnabled = false
local ESPConnections = {}
local PlayerData = {}
local PlayerCharacters = {}
local ESPConfig = {
    TotalEnabled = false,
    SkeletonEnabled = false,
    TracerEnabled = false,
    BoxEnabled = false,
    HealthEnabled = false,
    DistanceEnabled = false,
    NameEnabled = false,
    MaxDistance = 1000
}

local function UpdateAllESPVisibility()
    for player, data in pairs(PlayerData) do
        if data then
            if data.Box then
                data.Box.Visible = ESPConfig.BoxEnabled and ESPConfig.TotalEnabled
            end
            
            if data.Tracer then
                data.Tracer.Visible = ESPConfig.TracerEnabled and ESPConfig.TotalEnabled
            end
            
            if data.SkeletonLines then
                for _, line in ipairs(data.SkeletonLines) do
                    line.Visible = ESPConfig.SkeletonEnabled and ESPConfig.TotalEnabled
                end
            end
            
            if data.NameText then
                data.NameText.Visible = ESPConfig.NameEnabled and ESPConfig.TotalEnabled
            end
            
            if data.InfoText then
                data.InfoText.Visible = (ESPConfig.HealthEnabled or ESPConfig.DistanceEnabled) and ESPConfig.TotalEnabled
            end
        end
    end
end

local function UpdatePlayerInfoText(player, data, character)
    if not data or not data.InfoText or not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then 
        data.InfoText.Text = ""
        return
    end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local distance = (workspace.CurrentCamera.CFrame.Position - rootPart.Position).Magnitude
    
    local healthText = ""
    local distanceText = ""
    local separator = ""
    
    if ESPConfig.HealthEnabled then
        local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
        healthText = healthPercent .. "%"
    end
    
    if ESPConfig.DistanceEnabled then
        distanceText = math.floor(distance) .. "m"
    end
    
    if ESPConfig.HealthEnabled and ESPConfig.DistanceEnabled then
        separator = " | "
    end
    
    data.InfoText.Text = healthText .. separator .. distanceText
end

local function initializeESPSystem()
    for _, connection in pairs(ESPConnections) do
        connection:Disconnect()
    end
    ESPConnections = {}
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    
    local LocalPlayer = Players.LocalPlayer
    while not LocalPlayer do
        task.wait()
        LocalPlayer = Players.LocalPlayer
    end
    
    local BoxColor = Color3.fromRGB(0, 120, 255)
    local SkeletonColor = Color3.fromRGB(0, 200, 255)
    local TracerColor = Color3.fromRGB(255, 50, 50)
    local TextColor = Color3.fromRGB(255, 255, 255)
    local BoxThickness = 1
    local SkeletonThickness = 2
    local TracerThickness = 1
    local TextSize = 14
    local TracerOrigin = Vector2.new(0.5, 1)
    
    local SkeletonConnections = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"LowerTorso", "HumanoidRootPart"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
    }
    
    local CurrentCamera = workspace.CurrentCamera
    
    local function CreateDrawing(type, properties)
        local drawing = Drawing.new(type)
        for prop, value in pairs(properties) do
            drawing[prop] = value
        end
        return drawing
    end
    
    local function WorldToScreen(position)
        if not CurrentCamera then return Vector2.new(0, 0), false, 0 end
        local screenPoint, onScreen = CurrentCamera:WorldToViewportPoint(position)
        return Vector2.new(screenPoint.X, screenPoint.Y), onScreen, screenPoint.Z
    end
    
    local function GetTracerOrigin()
        if not CurrentCamera then return Vector2.new(0, 0) end
        local viewportSize = CurrentCamera.ViewportSize
        return Vector2.new(
            viewportSize.X * TracerOrigin.X,
            viewportSize.Y * TracerOrigin.Y
        )
    end
    
    local function GetPlayerBounds(character)
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
            return nil, nil
        end
        
        local head = character:FindFirstChild("Head")
        local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
        
        local minX, maxX, minY, maxY, minZ, maxZ = 0, 0, 0, 0, 0, 0
        local partCount = 0
        
        local parts = {humanoidRootPart, head, torso}
        for _, part in ipairs(parts) do
            if part and part:IsA("BasePart") then
                local size = part.Size
                if partCount == 0 then
                    minX, maxX = -size.X/2, size.X/2
                    minY, maxY = -size.Y/2, size.Y/2
                    minZ, maxZ = -size.Z/2, size.Z/2
                else
                    minX = math.min(minX, -size.X/2)
                    maxX = math.max(maxX, size.X/2)
                    minY = math.min(minY, -size.Y/2)
                    maxY = math.max(maxY, size.Y/2)
                    minZ = math.min(minZ, -size.Z/2)
                    maxZ = math.max(maxZ, size.Z/2)
                end
                partCount = partCount + 1
            end
        end
        
        if partCount == 0 then
            local height = humanoid.HipHeight * 2 + 2
            return humanoidRootPart.CFrame, Vector3.new(2.5, height, 1.5)
        end
        
        local centerX = (minX + maxX) / 2
        local centerY = (minY + maxY) / 2
        local centerZ = (minZ + maxZ) / 2
        
        local width = maxX - minX
        local height = maxY - minY
        local depth = maxZ - minZ
        
        local centerOffset = Vector3.new(centerX, centerY, centerZ)
        local boxCFrame = humanoidRootPart.CFrame * CFrame.new(centerOffset)
        
        return boxCFrame, Vector3.new(width, height, depth)
    end
    
    local function GetSkeletonConnections(character)
        local connections = {}
        local boneCache = {}
        
        for _, partName in ipairs({
            "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart",
            "LeftUpperArm", "LeftLowerArm", "LeftHand",
            "RightUpperArm", "RightLowerArm", "RightHand",
            "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
            "RightUpperLeg", "RightLowerLeg", "RightFoot", "Torso"
        }) do
            local part = character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                boneCache[partName] = part
            end
        end
        
        for _, connection in ipairs(SkeletonConnections) do
            local fromPart = boneCache[connection[1]]
            local toPart = boneCache[connection[2]]
            if fromPart and toPart then
                table.insert(connections, {From = fromPart, To = toPart})
            end
        end
        
        return connections
    end
    
    local function CreateESP(player)
        if PlayerData[player] then return end
        
        PlayerData[player] = {
            Box = CreateDrawing("Square", {
                Thickness = BoxThickness,
                Color = BoxColor,
                Filled = false,
                ZIndex = 1,
                Visible = false
            }),
            Tracer = CreateDrawing("Line", {
                Thickness = TracerThickness,
                Color = TracerColor,
                ZIndex = 2,
                Visible = false
            }),
            SkeletonLines = {},
            NameText = CreateDrawing("Text", {
                Color = TextColor,
                Outline = true,
                OutlineColor = Color3.new(0, 0, 0),
                Size = TextSize,
                ZIndex = 3,
                Visible = false
            }),
            InfoText = CreateDrawing("Text", {
                Color = TextColor,
                Outline = true,
                OutlineColor = Color3.new(0, 0, 0),
                Size = TextSize - 2,
                ZIndex = 3,
                Visible = false
            })
        }
        
        for i = 1, 16 do
            table.insert(PlayerData[player].SkeletonLines, CreateDrawing("Line", {
                Thickness = SkeletonThickness,
                Color = SkeletonColor,
                ZIndex = 2,
                Visible = false
            }))
        end
    end
    
    local function UpdateESP(player)
        local data = PlayerData[player]
        if not data then return end
        
        local character = PlayerCharacters[player]
        if not character or not character.Parent then
            character = player.Character
            PlayerCharacters[player] = character
        end
        
        if not character then
            data.Box.Visible = false
            data.Tracer.Visible = false
            data.NameText.Visible = false
            data.InfoText.Visible = false
            for _, line in ipairs(data.SkeletonLines) do
                line.Visible = false
            end
            return
        end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            data.Box.Visible = false
            data.Tracer.Visible = false
            data.NameText.Visible = false
            data.InfoText.Visible = false
            for _, line in ipairs(data.SkeletonLines) do
                line.Visible = false
            end
            return
        end
        
        local boxCFrame, boxSize = GetPlayerBounds(character)
        if not boxCFrame then
            data.Box.Visible = false
            data.Tracer.Visible = false
            data.NameText.Visible = false
            data.InfoText.Visible = false
            for _, line in ipairs(data.SkeletonLines) do
                line.Visible = false
            end
            return
        end
        
        local distance = (CurrentCamera.CFrame.Position - boxCFrame.Position).Magnitude
        if distance > ESPConfig.MaxDistance then
            data.Box.Visible = false
            data.Tracer.Visible = false
            data.NameText.Visible = false
            data.InfoText.Visible = false
            for _, line in ipairs(data.SkeletonLines) do
                line.Visible = false
            end
            return
        end
        
        local head = character:FindFirstChild("Head")
        local headScreenPos, headOnScreen = nil, false
        if head then
            headScreenPos, headOnScreen = WorldToScreen(head.Position)
        else
            local topPosition = boxCFrame * CFrame.new(0, boxSize.Y/2, 0)
            headScreenPos, headOnScreen = WorldToScreen(topPosition.Position)
        end
        
        local corners = {
            boxCFrame * CFrame.new(boxSize.X/2, boxSize.Y/2, boxSize.Z/2),
            boxCFrame * CFrame.new(-boxSize.X/2, boxSize.Y/2, boxSize.Z/2),
            boxCFrame * CFrame.new(boxSize.X/2, -boxSize.Y/2, boxSize.Z/2),
            boxCFrame * CFrame.new(-boxSize.X/2, -boxSize.Y/2, boxSize.Z/2),
            boxCFrame * CFrame.new(boxSize.X/2, boxSize.Y/2, -boxSize.Z/2),
            boxCFrame * CFrame.new(-boxSize.X/2, boxSize.Y/2, -boxSize.Z/2),
            boxCFrame * CFrame.new(boxSize.X/2, -boxSize.Y/2, -boxSize.Z/2),
            boxCFrame * CFrame.new(-boxSize.X/2, -boxSize.Y/2, -boxSize.Z/2)
        }
        
        local minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge
        local anyVisible = false
        
        for _, corner in ipairs(corners) do
            local screenPos, onScreen = WorldToScreen(corner.Position)
            if onScreen then
                anyVisible = true
                minX = math.min(minX, screenPos.X)
                maxX = math.max(maxX, screenPos.X)
                minY = math.min(minY, screenPos.Y)
                maxY = math.max(maxY, screenPos.Y)
            end
        end
        
        if anyVisible then
            local padding = 2
            local width = maxX - minX + padding * 2
            local height = maxY - minY + padding * 2
            local scaleFactor = math.clamp(1 / (distance / 50), 0.5, 2)
            data.Box.Size = Vector2.new(width, height) * scaleFactor
            data.Box.Position = Vector2.new(minX - padding, minY - padding)
            data.Box.Visible = ESPConfig.BoxEnabled and ESPConfig.TotalEnabled
        else
            data.Box.Visible = false
        end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local rootScreenPos, rootVisible = WorldToScreen(rootPart.Position)
            local tracerOrigin = GetTracerOrigin()
            if rootVisible then
                data.Tracer.From = tracerOrigin
                data.Tracer.To = rootScreenPos
                data.Tracer.Visible = ESPConfig.TracerEnabled and ESPConfig.TotalEnabled
            else
                data.Tracer.Visible = false
            end
        else
            data.Tracer.Visible = false
        end
        
        local skeletonConnections = GetSkeletonConnections(character)
        for i, line in ipairs(data.SkeletonLines) do
            line.Visible = false
        end
        
        for i, connection in ipairs(skeletonConnections) do
            if i <= #data.SkeletonLines then
                local fromScreen, fromVisible = WorldToScreen(connection.From.Position)
                local toScreen, toVisible = WorldToScreen(connection.To.Position)
                if fromVisible and toVisible then
                    data.SkeletonLines[i].From = fromScreen
                    data.SkeletonLines[i].To = toScreen
                    data.SkeletonLines[i].Visible = ESPConfig.SkeletonEnabled and ESPConfig.TotalEnabled
                end
            end
        end
        
        if headOnScreen then
            local textScale = math.clamp(1 / (distance / 100), 0.5, 1.5)
            
            if data.NameText then
                data.NameText.Size = math.floor(TextSize * textScale)
                data.NameText.Text = player.Name
                data.NameText.Position = Vector2.new(headScreenPos.X, headScreenPos.Y - data.NameText.Size - 5)
                data.NameText.Visible = ESPConfig.NameEnabled and ESPConfig.TotalEnabled
            end
            
            if data.InfoText then
                data.InfoText.Size = math.floor((TextSize - 2) * textScale)
                UpdatePlayerInfoText(player, data, character)
                data.InfoText.Position = Vector2.new(headScreenPos.X, headScreenPos.Y + 5)
                data.InfoText.Visible = (ESPConfig.HealthEnabled or ESPConfig.DistanceEnabled) and ESPConfig.TotalEnabled
            end
        else
            if data.NameText then
                data.NameText.Visible = false
            end
            if data.InfoText then
                data.InfoText.Visible = false
            end
        end
    end
    
    local function RemoveESP(player)
        local data = PlayerData[player]
        if data then
            data.Box:Remove()
            data.Tracer:Remove()
            data.NameText:Remove()
            data.InfoText:Remove()
            for _, line in ipairs(data.SkeletonLines) do
                line:Remove()
            end
            PlayerData[player] = nil
            PlayerCharacters[player] = nil
        end
    end
    
    local function ClearAllESP()
        for player, data in pairs(PlayerData) do
            if data then
                data.Box:Remove()
                data.Tracer:Remove()
                data.NameText:Remove()
                data.InfoText:Remove()
                for _, line in ipairs(data.SkeletonLines) do
                    line:Remove()
                end
            end
        end
        PlayerData = {}
        PlayerCharacters = {}
    end
    
    local function InitializePlayers()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreateESP(player)
            end
        end
    end
    
    local playerAddedConnection = Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end)
    table.insert(ESPConnections, playerAddedConnection)
    
    local playerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
        RemoveESP(player)
    end)
    table.insert(ESPConnections, playerRemovingConnection)
    
    local windowFocusedConnection = UserInputService.WindowFocused:Connect(function()
        UpdateAllESPVisibility()
    end)
    table.insert(ESPConnections, windowFocusedConnection)
    
    local windowFocusReleasedConnection = UserInputService.WindowFocusReleased:Connect(function()
        for _, data in pairs(PlayerData) do
            if data then
                data.Box.Visible = false
                data.Tracer.Visible = false
                data.NameText.Visible = false
                data.InfoText.Visible = false
                for _, line in ipairs(data.SkeletonLines) do
                    line.Visible = false
                end
            end
        end
    end)
    table.insert(ESPConnections, windowFocusReleasedConnection)
    
    local renderConnection = RunService.RenderStepped:Connect(function()
        if not ESPConfig.TotalEnabled then return end
        
        CurrentCamera = workspace.CurrentCamera
        if not CurrentCamera then return end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                UpdateESP(player)
            end
        end
    end)
    table.insert(ESPConnections, renderConnection)
    
    InitializePlayers()
end

Tabs.Perspective:Toggle({
    Title = "透视总开关",
    Value = false,
    Callback = function(state)
        ESPConfig.TotalEnabled = state
        
        if state then
            if not ESPConnections or #ESPConnections == 0 then
                initializeESPSystem()
            end
            UpdateAllESPVisibility()
        else
            UpdateAllESPVisibility()
        end
    end
})

Tabs.Perspective:Toggle({
    Title = "骨骼透视",
    Value = false,
    Callback = function(state)
        ESPConfig.SkeletonEnabled = state
        UpdateAllESPVisibility()
    end
})

Tabs.Perspective:Toggle({
    Title = "射线显示",
    Value = false,
    Callback = function(state)
        ESPConfig.TracerEnabled = state
        UpdateAllESPVisibility()
    end
})

Tabs.Perspective:Toggle({
    Title = "方框框架",
    Value = false,
    Callback = function(state)
        ESPConfig.BoxEnabled = state
        UpdateAllESPVisibility()
    end
})

Tabs.Perspective:Toggle({
    Title = "玩家名字",
    Value = false,
    Callback = function(state)
        ESPConfig.NameEnabled = state
        UpdateAllESPVisibility()
    end
})

Tabs.Perspective:Toggle({
    Title = "血量显示",
    Value = false,
    Callback = function(state)
        ESPConfig.HealthEnabled = state
        UpdateAllESPVisibility()
    end
})

Tabs.Perspective:Toggle({
    Title = "距离显示",
    Value = false,
    Callback = function(state)
        ESPConfig.DistanceEnabled = state
        UpdateAllESPVisibility()
    end
})

Tabs.Perspective:Slider({
    Title = "透视距离",
    Value = { Min = 100, Max = 2000, Default = 1000 },
    Callback = function(value)
        ESPConfig.MaxDistance = value
    end
})
