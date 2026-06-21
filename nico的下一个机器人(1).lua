local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()
if not WindUI then
    warn("WindUI 加载失败，请检查网络或链接有效性")
    return
end
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local AutoJumpEnabled = false
local AutoCrouchEnabled = false
local AutoWalkEnabled = false
local AutoEvadeEnabled = false
local EvadeDistance = 30
local EvadeSafeDistance = 3
local AutoJumpConnection = nil
local AutoCrouchConnection = nil
local AutoWalkConnection = nil
local AutoEvadeConnection = nil
local function StartAutoJump()
    if AutoJumpConnection then AutoJumpConnection:Disconnect() end
    AutoJumpConnection = RunService.Heartbeat:Connect(function()
        if AutoJumpEnabled and LocalPlayer.Character then
            local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid and Humanoid.FloorMaterial ~= Enum.Material.Air then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end
local function StopAutoJump()
    if AutoJumpConnection then AutoJumpConnection:Disconnect() AutoJumpConnection = nil end
end
local function ToggleAutoJump(Enabled)
    AutoJumpEnabled = Enabled
    if Enabled then StartAutoJump() else StopAutoJump() end
end
local function StartAutoCrouch()
    if AutoCrouchConnection then AutoCrouchConnection:Disconnect() end
    AutoCrouchConnection = RunService.Heartbeat:Connect(function()
        if AutoCrouchEnabled and LocalPlayer.Character then
            local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid.Crouch = (Humanoid.FloorMaterial ~= Enum.Material.Air)
            end
        end
    end)
end
local function StopAutoCrouch()
    if AutoCrouchConnection then AutoCrouchConnection:Disconnect() AutoCrouchConnection = nil end
end
local function ToggleAutoCrouch(Enabled)
    AutoCrouchEnabled = Enabled
    if Enabled then StartAutoCrouch() else StopAutoCrouch() end
end
local function StartAutoWalk()
    if AutoWalkConnection then AutoWalkConnection:Disconnect() end
    local StartDirection = nil
    AutoWalkConnection = RunService.Heartbeat:Connect(function()
        if not AutoWalkEnabled then return end
        local character = LocalPlayer.Character
        if not character then return end
        local Humanoid = character:FindFirstChildOfClass("Humanoid")
        local RootPart = character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not RootPart then return end
        if not StartDirection then
            StartDirection = RootPart.CFrame.LookVector
            StartDirection = Vector3.new(StartDirection.X, 0, StartDirection.Z).Unit
        end
        RootPart.CFrame = CFrame.new(RootPart.Position, RootPart.Position + StartDirection)
        Humanoid:Move(StartDirection, false)
    end)
end
local function StopAutoWalk()
    if AutoWalkConnection then AutoWalkConnection:Disconnect() AutoWalkConnection = nil end
    local character = LocalPlayer.Character
    if character then
        local Humanoid = character:FindFirstChildOfClass("Humanoid")
        if Humanoid then Humanoid:Move(Vector3.new(0, 0, 0), false) end
    end
end
local function ToggleAutoWalk(Enabled)
    AutoWalkEnabled = Enabled
    if Enabled then StartAutoWalk() else StopAutoWalk() end
end
local NextbotNames = {
    "afton", "aheno", "alternate", "angry munci", "ao_oni", "apparition", "arkade", "armstrong",
    "ash baby", "aá̵̧̘̖͇͉̓̈́̈́́̋", "babel", "baldi", "baller", "ballin", "bateman", "beagle",
    "bear 5", "benny", "blabber", "blahaj", "blonk", "bloxy cola", "blåhaj", "bob", "boderman",
    "bodyswap", "boioioioioing", "bombastic", "bowling ball", "burger", "burner harvester", "bust",
    "cammy cat", "cardboard", "carmen", "carter", "cat", "caterpillar", "chilly", "colon tree",
    "cootie", "crabbo", "crying noob", "crying sans", "darkness", "dave", "decay", "delgado",
    "dev_envmap", "do not", "dog lover", "doge", "doot", "drakobloxxer", "dread", "dream", "drip",
    "dummie", "egg", "ellis", "engineergaming", "enphoso", "epic face", "executable",
    "fazbear mug", "fiend", "fire in the hole", "firebrand", "flashbang", "flying gorilla",
    "follower", "fresh", "friend", "fritzi", "frog", "fuwatti", "gangster", "geoffery", "giddy",
    "giggle", "glimpse", "god tycoon", "gravity coil", "gromit mug", "grudge", "grumbo", "guest",
    "happy", "he", "heavy a-pose", "humanoid", "hyper sanic", "i need you", "ice face",
    "icosahedron", "identity", "idiot", "impostor", "incoming", "inconvenient jet", "insomniac",
    "intruder", "invitation", "jack", "jeep", "jeff", "jeremy", "jerma", "jermias", "jonathan",
    "jungler", "kabosu", "keeper", "leorio", "light", "liminesque", "linked sword", "local",
    "lolguy", "lolhoo", "louie", "madchen", "man face coffee cup",
    "man shocked at a sight of a banana", "man shocked at sight of banana",
    "man with a unique aura", "maxwell", "meem", "metal pipe", "michael", "mohu", "monkey", "moon",
    "mulch", "nerd", "niedźwiedź", "noob", "nope", "nuh uh", "nuke", "observer", "obunga",
    "oh hell nah", "oh sweet neptune", "old ai", "oragne", "pbj", "penguino", "personoid",
    "pigeon", "pigment", "pinhead", "plankton", "pleasant gradient", "polb", "preacher",
    "provoked", "proxy", "quack", "quandie", "qubert", "racon", "real dog", "real ghost",
    "reckless driver kleiner", "red", "rei plush", "reverse follower", "reverse munci",
    "reverse stalkbot", "riker bodypillow", "roblox", "sad", "sanic", "scary", "scary burger",
    "scopophobe", "screensaver", "silly cat", "skull", "smelvin", "smile", "smileghost",
    "speciman", "specimen", "speed", "speed coil", "sponge", "stalkbot", "steamhappy", "stuert",
    "subspace tripmine", "sunshine", "super sanic", "swanson", "taco", "the blue one",
    "the boiled one", "thehorror", "this dude", "this man", "tiler", "tomino", "toob", "tornado",
    "train griffin", "trauma", "tribute", "trollface", "trollge", "tube", "ufo", "unfortunate",
    "unknown", "unpleasant gradient", "vehilce", "vendor", "very poorly camoflauged nextbot",
    "vibe", "what", "wise mystical tree", "wisp", "witches brew", "yippee", "yoshie", "zombie",
    "zombiespecial", "шайлушай", "犬かわいがり屋さん"
}
local function GetBotsFolder()
    return Workspace:FindFirstChild("bots")
end
local function IsNextbot(obj)
    if not obj then return false end
    for _, name in ipairs(NextbotNames) do
        if obj.Name:lower() == name:lower() then
            return true
        end
    end
    return false
end
local function EvadeNextbot(botPart)
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local myPos = rootPart.Position
    local botPos = botPart.Position
    local direction = (myPos - botPos).Unit
    local targetPos = botPos + direction * EvadeSafeDistance
    targetPos = Vector3.new(targetPos.X, myPos.Y, targetPos.Z)
    rootPart.CFrame = CFrame.new(targetPos, botPos)
end
local function StartAutoEvade()
    if AutoEvadeConnection then AutoEvadeConnection:Disconnect() end
    AutoEvadeConnection = RunService.Heartbeat:Connect(function()
        if not AutoEvadeEnabled then return end
        local character = LocalPlayer.Character
        if not character then return end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        local botsFolder = GetBotsFolder()
        if not botsFolder then return end
        local myPos = rootPart.Position
        for _, child in ipairs(botsFolder:GetChildren()) do
            if IsNextbot(child) then
                local botPart = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChild("Torso") or child:FindFirstChild("Head") or child:FindFirstChildWhichIsA("BasePart")
                if botPart then
                    local dist = (botPart.Position - myPos).Magnitude
                    if dist <= EvadeDistance then
                        EvadeNextbot(botPart)
                        return
                    end
                end
            end
        end
    end)
end
local function StopAutoEvade()
    if AutoEvadeConnection then AutoEvadeConnection:Disconnect() AutoEvadeConnection = nil end
end
local function ToggleAutoEvade(Enabled)
    AutoEvadeEnabled = Enabled
    if Enabled then StartAutoEvade() else StopAutoEvade() end
end
LocalPlayer.CharacterAdded:Connect(function()
    if AutoJumpEnabled then StartAutoJump() end
    if AutoCrouchEnabled then StartAutoCrouch() end
    if AutoWalkEnabled then task.wait(0.5) StartAutoWalk() end
    if AutoEvadeEnabled then StartAutoEvade() end
end)
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
    Title = "nico的下一个机器人",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})
Window:EditOpenButton({
    Title = "nico的下一个机器人",
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
local MainTab = Window:Tab({
    Title = "主要功能",
    Desc = "辅助功能",
    Icon = "solar:bolt-bold",
    IconColor = Color3.fromRGB(255, 100, 100),
    IconShape = "Square",
    Border = true,
})
MainTab:Section({
    Title = "自动移动",
    Description = "自动移动"
})
MainTab:Toggle({
    Title = "自动连跳",
    Default = false,
    Callback = function(Value)
        ToggleAutoJump(Value)
        WindUI:Notify({
            Title = "nico的下一个机器人",
            Content = "自动连跳 " .. (Value and "已开启" or "已关闭"),
            Icon = "robot",
            Duration = 1.5
        })
    end
})
MainTab:Toggle({
    Title = "自动蹲下",
    Default = false,
    Callback = function(Value)
        ToggleAutoCrouch(Value)
        WindUI:Notify({
            Title = "nico的下一个机器人",
            Content = "自动蹲下 " .. (Value and "已开启" or "已关闭"),
            Icon = "robot",
            Duration = 1.5
        })
    end
})
MainTab:Toggle({
    Title = "自动往前走",
    Default = false,
    Callback = function(Value)
        ToggleAutoWalk(Value)
        WindUI:Notify({
            Title = "nico的下一个机器人",
            Content = "自动往前走 " .. (Value and "已开启" or "已关闭"),
            Icon = "robot",
            Duration = 1.5
        })
    end
})
MainTab:Divider()
MainTab:Section({
    Title = "自动远离 Nextbot",
    Description = "靠近怪物自动瞬移"
})
MainTab:Toggle({
    Title = "自动远离怪物",
    Default = false,
    Callback = function(Value)
        ToggleAutoEvade(Value)
        WindUI:Notify({
            Title = "nico的下一个机器人",
            Content = "自动远离怪物 " .. (Value and "已开启" or "已关闭"),
            Icon = "robot",
            Duration = 1.5
        })
    end
})
MainTab:Input({
    Title = "检测距离",
    Desc = "多少米内触发瞬移（输入数字）",
    Placeholder = "30",
    Default = "30",
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            EvadeDistance = num
            WindUI:Notify({
                Title = "nico的下一个机器人",
                Content = "检测距离已设置为 " .. num .. " 米",
                Icon = "robot",
                Duration = 1.5
            })
        end
    end
})
MainTab:Input({
    Title = "瞬移距离",
    Desc = "瞬移后离怪物多远（输入数字）",
    Placeholder = "3",
    Default = "3",
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            EvadeSafeDistance = num
            WindUI:Notify({
                Title = "nico的下一个机器人",
                Content = "瞬移距离已设置为 " .. num .. " 米",
                Icon = "robot",
                Duration = 1.5
            })
        end
    end
})
MainTab:Paragraph({
    Title = "说明",
    Desc = "刷分专属"
})
print("nico的下一个机器人 脚本加载完成")