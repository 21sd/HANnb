local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "无标题拳击",
    Icon = "gem",
    IconSize = 22,
    Author = "6",
    Folder = "UltimateBattle",
    Size = UDim2.new(0, 580, 0, 460),
    Transparent = true,
    Theme = "Indigo",
    Background = "https://raw.githubusercontent.com/21sd/HANnb/refs/heads/main/Image_1795249115572_823.jpg",
    BackgroundImageTransparency = 0.5,
    OpenButton = {
        Enabled = true,
        Draggable = true,
        OnlyIcon = false,
        Color = ColorSequence.new(Color3.fromHex("#38bdf8"), Color3.fromHex("#2563eb")),
    },
    Topbar = {
        Height = 52,
        ButtonsType = "Default",
    },
})
Window:Tag({
    Title = "无标题拳击",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local dodgeEnabled = false
local dodgeConn = nil
local lastPerfect = nil
local dashEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("ForceDash", 5)

local function getState()
    local states = Workspace:FindFirstChild("States")
    return states and states:FindFirstChild(player.Name)
end

local function triggerDash(character, direction, perfect)
    if not dashEvent then return end
    dashEvent:Fire({Direction = direction})

    RunService.Heartbeat:Once(function()
        local char = player.Character
        local state = getState()
        local occupied = state and state:FindFirstChild("Occupied")
        local dashing = occupied and occupied:FindFirstChild("Dashing")

        if char == character and character:GetAttribute("Perfect") == perfect and (not dashing or dashing.Value == false) then
            dashEvent:Fire({Direction = direction})
        end
    end)

    RunService.Heartbeat:Once(function()
        local char = player.Character
        local state = getState()
        local occupied = state and state:FindFirstChild("Occupied")
        local dashing = occupied and occupied:FindFirstChild("Dashing")

        if char == character and character:GetAttribute("Perfect") == perfect and (not dashing or dashing.Value == false) then
            dashEvent:Fire({Direction = direction})
        end
    end)
end

local function checkAndDodge()
    if not dodgeEnabled then return end

    local character = player.Character
    if not character then return end

    local perfect = character:GetAttribute("Perfect")
    if perfect == nil or perfect == lastPerfect then return end

    local direction = character:GetAttribute("NeededDirection")
    if direction ~= "Left" and direction ~= "Right" and direction ~= "Backward" and direction ~= "Forward" then
        return
    end

    local state = getState()
    if not state then return end

    local occupied = state:FindFirstChild("Occupied")
    if not occupied then return end

    local locked = occupied:FindFirstChild("LockedOn")
    local dashing = occupied:FindFirstChild("Dashing")

    if not locked or not locked.Value then return end
    if dashing and dashing.Value then return end

    local enemy = locked.Value
    if not enemy then return end

    if enemy:GetAttribute("IsFeinting") == true or enemy:GetAttribute("LocalIsFeinting") == true then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    local eroot = enemy:FindFirstChild("HumanoidRootPart")

    if not root or not eroot then return end
    if (root.Position - eroot.Position).Magnitude > 14 then return end

    lastPerfect = perfect
    triggerDash(character, direction, perfect)
end

local function startDodge()
    if dodgeConn then dodgeConn:Disconnect() end
    lastPerfect = nil
    dodgeConn = RunService.Heartbeat:Connect(checkAndDodge)
end

local function stopDodge()
    if dodgeConn then
        dodgeConn:Disconnect()
        dodgeConn = nil
    end
    lastPerfect = nil
end

player.CharacterAdded:Connect(function()
    lastPerfect = nil
end)

local hitboxEnabled = false
local hitboxConn = nil
local hitboxObjects = {} 

local RED_COLOR = Color3.fromRGB(255, 0, 0)

local function clearAllHitboxes()
    for part, box in pairs(hitboxObjects) do
        if box and box.Parent then
            box:Destroy()
        end
    end
    table.clear(hitboxObjects)
end

local function addHitbox(part)
    if not part:IsA("BasePart") then return end
    if hitboxObjects[part] then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = part
    box.AlwaysOnTop = true
    box.Color3 = RED_COLOR
    box.Transparency = 0.3 
    box.Size = part.Size
    box.ZIndex = 5
    box.Parent = part

    hitboxObjects[part] = box
end

local function refreshHitboxes()
    if not hitboxEnabled then return end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then addHitbox(root) end
            
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if torso then addHitbox(torso) end
        end
    end

    local states = Workspace:FindFirstChild("States")
    if states then
        for _, desc in ipairs(states:GetDescendants()) do
            if desc:IsA("BasePart") then
                addHitbox(desc)
            end
        end
    end
end

local function onDescendantAdded(desc)
    if not hitboxEnabled then return end
    if desc:IsA("BasePart") then
        local model = desc:FindFirstAncestorOfClass("Model")
        if model and model:FindFirstChildOfClass("Humanoid") then
            addHitbox(desc)
        elseif desc:IsDescendantOf(Workspace:FindFirstChild("States")) then
            addHitbox(desc)
        end
    end
end

local function startHitbox()
    clearAllHitboxes()
    refreshHitboxes()
    if hitboxConn then hitboxConn:Disconnect() end
    hitboxConn = Workspace.DescendantAdded:Connect(onDescendantAdded)
end

local function stopHitbox()
    if hitboxConn then
        hitboxConn:Disconnect()
        hitboxConn = nil
    end
    clearAllHitboxes()
end

player.CharacterAdded:Connect(function()
    if hitboxEnabled then
        task.wait(0.5)
        refreshHitboxes()
    end
end)

local CombatSection = Window:Tab({
    Title = "战斗",
    Icon = "swords",
}):Section({
    Title = "自动闪避",
    Icon = "shield",
})

CombatSection:Toggle({
    Title = "自动闪避",
    Desc = "自动闪避",
    Icon = "zap",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        dodgeEnabled = state
        if state then
            startDodge()
        else
            stopDodge()
        end
    end,
})

local VisualSection = Window:Tab({
    Title = "视觉",
    Icon = "eye",
}):Section({
    Title = "碰撞箱",
    Icon = "box",
})

VisualSection:Toggle({
    Title = "显示人物碰撞箱",
    Desc = "显示玩家的红色透视判定框",
    Icon = "scan",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        hitboxEnabled = state
        if state then
            startHitbox()
        else
            stopHitbox()
        end
    end,
})

VisualSection:Button({
    Title = "刷新碰撞箱",
    Desc = "重新扫描并绘制",
    Icon = "refresh-cw",
    Callback = function()
        if hitboxEnabled then
            clearAllHitboxes()
            refreshHitboxes()
        end
    end,
})

print("已加载")