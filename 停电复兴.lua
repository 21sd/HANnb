local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = '停电复兴',
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
    Title = "停电复兴",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "停电复兴",
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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FOVCircle_UI"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local circle = Instance.new("Frame")
circle.Name = "FOVCircle"
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.Position = UDim2.new(0.5, 0, 0.5, 0)
circle.Size = UDim2.new(0, 240, 0, 240)
circle.BackgroundTransparency = 1
circle.Parent = screenGui
circle.Visible = false

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(128, 0, 128)
stroke.Parent = circle

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = circle

local ESP_SETTINGS = {
    HighlightEnabled = false,
    WallCheck = false,
    SmoothAim = false
}

local FOV = 120
local Smoothness = 0.18
local ShowFOVCircle = true
local MaxDistance = 1000

local function GetZombiePart(zombieModel)
    if not zombieModel or not zombieModel:IsA("Model") then return nil end
    local part = zombieModel:FindFirstChild("HumanoidRootPart")
    if part then return part end
    part = zombieModel:FindFirstChild("Head")
    if part then return part end
    part = zombieModel.PrimaryPart
    if part then return part end
    for _, child in ipairs(zombieModel:GetDescendants()) do
        if child:IsA("BasePart") then
            return child
        end
    end
    return nil
end

local function GetTargetZombie()
    local npcFolder = workspace:FindFirstChild("NPCs")
    if not npcFolder then return nil end
    
    local customFolder = npcFolder:FindFirstChild("Custom")
    if not customFolder then return nil end
    
    for _, obj in ipairs(customFolder:GetChildren()) do
        if obj:IsA("Model") then
            return obj
        end
    end
    return nil
end

local function isVisibleZombie(zombieModel, part)
    if not Camera then return false end
    if not ESP_SETTINGS.WallCheck then return true end
    
    local origin = Camera.CFrame.Position
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.IgnoreWater = true
    
    local ignoreList = {LocalPlayer.Character, Camera}
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        table.insert(ignoreList, tool)
    end
    rayParams.FilterDescendantsInstances = ignoreList
    
    local direction = part.Position - origin
    local result = workspace:Raycast(origin, direction, rayParams)
    
    if not result then return true end
    local hit = result.Instance
    if hit and hit:IsDescendantOf(zombieModel) then return true end
    if hit and (hit.Transparency > 0.4 or hit.CanCollide == false or hit.Material == Enum.Material.Glass) then
        return true
    end
    return false
end

local function isZombieAlive(zombieModel)
    local humanoid = zombieModel:FindFirstChildWhichIsA("Humanoid")
    return humanoid and humanoid.Health > 0
end

local CurrentTarget = nil
local LastSwitchTime = 0
local SWITCH_DELAY = 0.25

local function getZombieTarget()
    local now = tick()
    local center = Camera.ViewportSize / 2
    
    local zombie = GetTargetZombie()
    if not zombie or not isZombieAlive(zombie) then return nil end
    
    local part = GetZombiePart(zombie)
    if not part then return nil end
    
    local camPos = Camera.CFrame.Position
    local dist3D = (part.Position - camPos).Magnitude
    if dist3D > MaxDistance then return nil end
    
    if not isVisibleZombie(zombie, part) then return nil end
    
    local pos, visible = Camera:WorldToViewportPoint(part.Position)
    if not visible then return nil end
    
    local dist2D = (Vector2.new(pos.X, pos.Y) - center).Magnitude
    if dist2D > FOV then return nil end
    
    if CurrentTarget and CurrentTarget ~= zombie then
        if now - LastSwitchTime < SWITCH_DELAY then
            return CurrentTarget
        end
    end
    
    CurrentTarget = zombie
    LastSwitchTime = now
    return zombie
end

local TabAimbot = Window:Tab({
    Title = "僵尸自瞄",
    Icon = "target",
    Locked = false,
})

TabAimbot:Toggle({
    Title = "自瞄开关",
    Default = false,
    Callback = function(v)
        ESP_SETTINGS.HighlightEnabled = v
        if circle then
            circle.Visible = v
        end
    end
})

TabAimbot:Toggle({
    Title = "显示FOV圈",
    Default = true,
    Callback = function(v)
        ShowFOVCircle = v
    end
})

TabAimbot:Toggle({
    Title = "墙体检测",
    Default = false,
    Callback = function(v)
        ESP_SETTINGS.WallCheck = v
    end
})

TabAimbot:Toggle({
    Title = "平滑自瞄",
    Default = false,
    Callback = function(v)
        ESP_SETTINGS.SmoothAim = v
    end
})

TabAimbot:Slider({
    Title = "自瞄范围(FOV)",
    Value = {
        Min = 10,
        Max = 700,
        Default = FOV,
    },
    Increment = 10,
    Callback = function(v)
        FOV = v
    end
})

TabAimbot:Slider({
    Title = "最大距离",
    Value = {
        Min = 50,
        Max = 6000,
        Default = MaxDistance,
    },
    Increment = 50,
    Callback = function(v)
        MaxDistance = v
    end
})

TabAimbot:Slider({
    Title = "平滑度",
    Value = {
        Min = 0.01,
        Max = 1,
        Default = Smoothness,
    },
    Increment = 0.01,
    Callback = function(v)
        Smoothness = v
    end
})

RunService.RenderStepped:Connect(function()

    if circle then
        local size = FOV * 2
        circle.Size = UDim2.new(0, size, 0, size)
        local shouldShow = ESP_SETTINGS.HighlightEnabled and ShowFOVCircle
        if circle.Visible ~= shouldShow then
            circle.Visible = shouldShow
        end
    end
    
    if not Camera then return end
    if not ESP_SETTINGS.HighlightEnabled then return end
    
    local target = getZombieTarget()
    
    if target then
        local part = GetZombiePart(target)
        if part then
            local camPos = Camera.CFrame.Position
            local direction = (part.Position - camPos).Unit
            local newCF = CFrame.new(camPos, camPos + direction)
            
            if ESP_SETTINGS.SmoothAim then
                Camera.CFrame = Camera.CFrame:Lerp(newCF, Smoothness)
            else
                Camera.CFrame = newCF
            end
        end
    end
end)
