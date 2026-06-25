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
    Title = "在超级商店生存一周",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

Window:EditOpenButton({
    Title = "在超级商店生存一周",
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

local TabCollect = Window:Tab({
    Title = "收集物品",
    Icon = "package"
})

TabCollect:Toggle({
    Title = "自动收集食物",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _,v in next,workspace.Map.Util.Items:GetChildren() do
                if v.ToolStats.ItemType.Value == "Food" then
                    game:GetService("ReplicatedStorage").Remotes.RequestPickupItem:FireServer(v)
                end
            end
        end
    end
})

TabCollect:Toggle({
    Title = "自动收集手电筒",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _,v in next,workspace.Map.Util.Items:GetChildren() do
                if v.ToolStats.ItemType.Value == "Flashlight" then
                    game:GetService("ReplicatedStorage").Remotes.RequestPickupItem:FireServer(v)
                end
            end
        end
    end
})

TabCollect:Toggle({
    Title = "自动收集近战武器",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _,v in next,workspace.Map.Util.Items:GetChildren() do
                if v.ToolStats.ItemType.Value == "Melee" then
                    game:GetService("ReplicatedStorage").Remotes.RequestPickupItem:FireServer(v)
                end
            end
        end
    end
})

TabCollect:Toggle({
    Title = "自动收集枪",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _,v in next,workspace.Map.Util.Items:GetChildren() do
                if v.ToolStats.ItemType.Value == "Gun" then
                    game:GetService("ReplicatedStorage").Remotes.RequestPickupItem:FireServer(v)
                end
            end
        end
    end
})

TabCollect:Toggle({
    Title = "自动收集药品",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _,v in next,workspace.Map.Util.Items:GetChildren() do
                if v.ToolStats.ItemType.Value == "Health" then
                    game:GetService("ReplicatedStorage").Remotes.RequestPickupItem:FireServer(v)
                end
            end
        end
    end
})

local TabCombat = Window:Tab({
    Title = "战斗",
    Icon = "swords"
})

TabCombat:Toggle({
    Title = "自动装弹",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            game:GetService("ReplicatedStorage").Remotes.Weapon.GunReloaded:FireServer(v, 1)
        end
    end
})

TabCombat:Toggle({
    Title = "自动开枪",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _, v in next, game.Players.LocalPlayer.Backpack:GetChildren() do
                if v:FindFirstChild("ToolStats") and v.ToolStats:FindFirstChild("Ammo") then
                    for _,e in next,workspace.Enemies:GetChildren() do
                        if e.Humanoid.Health > 0 then
                            local BulletsPerShot = v.ToolStats.BulletsPerShot.Value
                            local DirectionTbl = {}
                            for i = 1, BulletsPerShot do
                                table.insert(DirectionTbl, Vector3.new(e.Head.Position.X, e.Head.Position.Y, e.Head.Position.Z).Unit)
                            end
                            local args = {
                                [1] = {
                                    ["FiringPlayer"] = game:GetService("Players").LocalPlayer,
                                    ["FiredTime"] = os.time,
                                    ["FiringPlayerUserId"] = game.Players.LocalPlayer.UserId,
                                    ["Origin"] = Vector3.new(game.Players.LocalPlayer.Character:GetPivot().Position),
                                    ["UID"] = game.Players.LocalPlayer.UserId .. "_1",
                                    ["WeaponInstance"] = v,
                                    ["ThisBulletProperties"] = {
                                        ["BulletSpread"] = v.ToolStats.BulletSpread.Value,
                                        ["BulletsPerShot"] = v.ToolStats.BulletsPerShot.Value,
                                        ["BulletPenetration"] = v.ToolStats.BulletPenetration.Value,
                                        ["BulletSpeed"] = v.ToolStats.BulletSpeed.Value,
                                        ["FireSound"] = v.ToolStats.FireSound.Value,
                                        ["BulletSize"] = v.ToolStats.BulletSize.Value
                                    },
                                    ["DirectionTbl"] = DirectionTbl
                                }
                            }
                            game:GetService("ReplicatedStorage").Remotes.Weapon.GunFired:FireServer(unpack(args))
                        end
                    end
                end
            end
        end
    end
})

TabCombat:Toggle({
    Title = "修改超级枪",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            for _,v in next,game.Players.LocalPlayer.Backpack:GetChildren() do
                if v.ToolStats:FindFirstChild("Ammo") then
                    v.ToolStats.ReloadTime.Value = 0
                    v.ToolStats.FireDelay.Value = 0
                    v.ToolStats.Ammo.Value = math.huge
                    v.ToolStats.Damage.Value = math.huge
                end
            end
        end
    end
})

local TabCharacter = Window:Tab({
    Title = "角色",
    Icon = "user"
})

TabCharacter:Toggle({
    Title = "无限体力和饥饿度",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            game.Players.LocalPlayer.Character.CharacterData.MaxStamina.Value = math.huge
            game.Players.LocalPlayer.Character.CharacterData.MaxEnergy.Value = math.huge
            game.Players.LocalPlayer.Character.CharacterData.Energy.Value = game.Players.LocalPlayer.Character.CharacterData.MaxEnergy.Value
            game.Players.LocalPlayer.Character.CharacterData.Stamina.Value = game.Players.LocalPlayer.Character.CharacterData.MaxStamina.Value
        end
    end
})

TabCharacter:Toggle({
    Title = "夜晚自动躲避",
    Default = false,
    Callback = function(state)
        while state and task.wait() do
            if game:GetService("ReplicatedStorage").GameInfo.TimeOfDay.Value == "Night" then
                oldpos = game.Players.LocalPlayer.Character:GetPivot().Position
                repeat task.wait()
                    game.Players.LocalPlayer.Character:PivotTo(CFrame.new(306.18927001953125, 36.67450714111328, -519.2435913085938))
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                until game:GetService("ReplicatedStorage").GameInfo.TimeOfDay.Value ~= "Night"
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(oldpos)
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            else
                task.wait()
            end
        end
    end
})
