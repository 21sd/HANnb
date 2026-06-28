local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = '速度传奇',
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
    Title = "速度传奇",
    Icon = "skull",
    IconColor = Color3.fromHex("#FF1493"),
    Color = Color3.fromHex("#1C1C1C"),
    Border = true,
    BorderColor = Color3.fromHex("#FF1493"),
    IconShape = "Square"
})

local TimeTag = Window:Tag({
    Title = "新年倒计时00天 00时 00分 00秒",
    Color = Color3.fromHex("#000000")
})

local function getNextNewYear()
    local currentYear = os.date("%Y")
    local targetYear = currentYear + 1
    return os.time({
        year = targetYear,
        month = 1,
        day = 1,
        hour = 0,
        min = 0,
        sec = 0
    })
end

local targetTime = getNextNewYear()
local hue = 0

task.spawn(function()
    while true do
        local now = os.time()
        local diff = targetTime - now

 
        if diff <= 0 then
            TimeTag:SetTitle("新年快乐！")
        else
      
            local days = math.floor(diff / 86400)
            local remainder = diff % 86400

            local hours = math.floor(remainder / 3600)
            remainder = remainder % 3600

            local minutes = math.floor(remainder / 60)
            local seconds = remainder % 60

    
            local title = string.format("%d天 %02d时 %02d分 %02d秒", days, hours, minutes, seconds)
            TimeTag:SetTitle(title)
        end

  
        hue = (hue + 0.01) % 1
        local rainbowColor = Color3.fromHSV(hue, 1, 1)
        TimeTag:SetColor(rainbowColor)

        task.wait(0.06)
    end
end)

Window:EditOpenButton({
    Title = "速度传奇",
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

local Interstellar = {
    getorb = false,
    area = "City",
    mainexe = false,
    hoop = false,
    opencrystal = false,
    petshop = false,
    evolvepet = false,
    birth = 9e9,
    autobirth = false,
}

local Main = Window:Tab({Title = "主要功能", Icon = "star"})

Main:Toggle({
    Title = "自动重生",
    Default = false,
    Callback = function(state)
        Interstellar.mainexe = state
        if Interstellar.mainexe then
            while Interstellar.mainexe do
                game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
                wait()
            end
        end
    end
})

Main:Button({
    Title = "获取所有宝箱",
    Callback = function()
        for _, v in pairs(game.ReplicatedStorage.chestRewards:GetChildren()) do
            game.ReplicatedStorage.rEvents.checkChestRemote:InvokeServer(v.Name)
        end
    end
})

Main:Button({
    Title = "获取所有通行证",
    Callback = function()
        for i, v in ipairs(game:GetService("ReplicatedStorage").gamepassIds:GetChildren()) do
            v.Parent = game.Players.LocalPlayer.ownedGamepasses
        end 
    end
})

local RaceTab = Window:Tab({Title = "比赛功能", Icon = "flag"})

local Maps = {}
for i, Map in pairs(game:GetService("Workspace").raceMaps:GetChildren()) do
    Maps[i] = Map.Name
end

local selectedMap = ""
RaceTab:Dropdown({
    Title = "选择比赛地图",
    Values = Maps,
    Callback = function(Value)
        selectedMap = Value
    end
})

RaceTab:Button({
    Title = "传送到终点",
    Callback = function()
        if selectedMap ~= "" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.raceMaps[selectedMap].finishPart.CFrame
        end
    end
})

RaceTab:Toggle({
    Title = "自动参加比赛",
    Default = false,
    Callback = function(state)
        Interstellar.mainexe = state
        if Interstellar.mainexe then
            if game.PlaceId == 3101667897 then
                while Interstellar.mainexe do
                    game:GetService("ReplicatedStorage").rEvents.raceEvent:FireServer("joinRace")
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.raceMaps.Grassland.finishPart.CFrame
                    task.wait(0.1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.raceMaps.Magma.finishPart.CFrame
                    task.wait(0.1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.raceMaps.Desert.finishPart.CFrame
                    task.wait(0.3)
                end
            elseif game.PlaceId == 3276265788 then
                while Interstellar.mainexe do
                    game:GetService("ReplicatedStorage").rEvents.raceEvent:FireServer("joinRace")
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.raceMaps.Speedway.finishPart.CFrame
                    task.wait(0.2)
                end
            elseif game.PlaceId == 3232996272 then
                while Interstellar.mainexe do
                    game:GetService("ReplicatedStorage").rEvents.raceEvent:FireServer("joinRace")
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.raceMaps.Starway.finishPart.CFrame
                    task.wait(0.2)
                end
            end
        end
    end
})

RaceTab:Toggle({
    Title = "自动收集光环",
    Default = false,
    Callback = function(state)
        Interstellar.hoop = state
        if game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
            while Interstellar.hoop do
                for i, hoops in ipairs(workspace.Hoops:GetChildren()) do
                    if hoops.Name == "Hoop" then
                        hoops.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        wait()
                    end
                end
            end
        end
    end
})

local EditTab = Window:Tab({Title = "数值修改", Icon = "edit"})

EditTab:Input({
    Title = "修改经验值",
    Placeholder = "输入经验值",
    Callback = function(Value)
        game:GetService("Players").LocalPlayer.exp.Value = tonumber(Value) or 0
    end
})

EditTab:Input({
    Title = "修改等级",
    Placeholder = "输入等级",
    Callback = function(Value)
        game:GetService("Players").LocalPlayer.level.Value = tonumber(Value) or 1
    end
})

EditTab:Input({
    Title = "修改比赛数",
    Placeholder = "输入比赛次数",
    Callback = function(Value)
        game:GetService("Players").LocalPlayer.leaderstats.Races.Value = tonumber(Value) or 0
    end
})

EditTab:Input({
    Title = "修改圈数",
    Placeholder = "输入圈数",
    Callback = function(Value)
        game:GetService("Players").LocalPlayer.leaderstats.Hoops.Value = tonumber(Value) or 0
    end
})

EditTab:Input({
    Title = "修改重生次数",
    Placeholder = "输入重生次数",
    Callback = function(Value)
        game:GetService("Players").LocalPlayer.leaderstats.Rebirths.Value = tonumber(Value) or 0
    end
})

EditTab:Input({
    Title = "修改步数",
    Placeholder = "输入步数",
    Callback = function(Value)
        game:GetService("Players").LocalPlayer.leaderstats.Steps.Value = tonumber(Value) or 0
    end
})

EditTab:Input({
    Title = "修改宝石数量",
    Placeholder = "输入宝石数量",
    Callback = function(Value)
        game:GetService("Players").LocalPlayer.Gems.Value = tonumber(Value) or 0
    end
})

local OrbTab = Window:Tab({Title = "能量球收集", Icon = "globe"})

OrbTab:Dropdown({
    Title = "选择地区",
    Values = {"City","Snow City","Magma City","Desert","Space", "Legends Highway"},
    Callback = function(Value)
        Interstellar.area = Value
    end
})

OrbTab:Toggle({
    Title = "自动收集红球",
    Default = false,
    Callback = function(state)
        Interstellar.getorb = state
        spawn(function()
            while Interstellar.getorb do wait()
                pcall(function()
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Red Orb", Interstellar.area)
                end)
            end
        end)
    end
})

OrbTab:Toggle({
    Title = "自动收集蓝球",
    Default = false,
    Callback = function(state)
        Interstellar.getorb = state
        spawn(function()
            while Interstellar.getorb do wait()
                pcall(function()
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Blue Orb", Interstellar.area)
                end)
            end
        end)
    end
})

OrbTab:Toggle({
    Title = "自动收集宝石球",
    Default = false,
    Callback = function(state)
        Interstellar.getorb = state
        spawn(function()
            while Interstellar.getorb do
                pcall(function()
                    game.ReplicatedStorage.rEvents.orbEvent:FireServer("collectOrb", "Gem", Interstellar.area)
                end)
            end
        end)
    end
})

local CrystalTab = Window:Tab({Title = "水晶功能", Icon = "gem"})

local crystalshow = {}
for i, crystal in pairs(game:GetService("Workspace").mapCrystalsFolder:GetChildren()) do
    crystalshow[i] = crystal.Name
end

local OpenCrystal = ""
CrystalTab:Dropdown({
    Title = "选择水晶",
    Values = crystalshow,
    Callback = function(Value)
        OpenCrystal = Value
    end
})

CrystalTab:Button({
    Title = "购买水晶",
    Callback = function()
        game:GetService('ReplicatedStorage').rEvents.openCrystalRemote:InvokeServer("openCrystal", OpenCrystal)
    end
})

CrystalTab:Toggle({
    Title = "自动购买水晶",
    Default = false,
    Callback = function(state)
        Interstellar.opencrystal = state
        if Interstellar.opencrystal then
            while Interstellar.opencrystal do
                game:GetService('ReplicatedStorage').rEvents.openCrystalRemote:InvokeServer("openCrystal", OpenCrystal)
                wait()
            end
        end
    end
})

local PetTab = Window:Tab({Title = "宠物功能", Icon = "paw"})

local petshow = {}
for i, pet in pairs(game:GetService("ReplicatedStorage").cPetShopFolder:GetChildren()) do
    petshow[i] = pet.Name
end

local BuyPetShop = ""
PetTab:Dropdown({
    Title = "选择宠物",
    Values = petshow,
    Callback = function(Value)
        BuyPetShop = Value
    end
})

PetTab:Button({
    Title = "购买宠物",
    Callback = function()
        game:GetService("ReplicatedStorage").cPetShopRemote:InvokeServer(game:GetService("ReplicatedStorage").cPetShopFolder:FindFirstChild(BuyPetShop))
    end
})

PetTab:Toggle({
    Title = "自动购买宠物",
    Default = false,
    Callback = function(state)
        Interstellar.petshop = state
        if Interstellar.petshop then
            while Interstellar.petshop do
                game:GetService("ReplicatedStorage").cPetShopRemote:InvokeServer(game:GetService("ReplicatedStorage").cPetShopFolder:FindFirstChild(BuyPetShop))
                wait()
            end
        end
    end
})

local EvolveTab = Window:Tab({Title = "宠物进化", Icon = "shield"})

local EvolvePet = ""
EvolveTab:Dropdown({
    Title = "选择宠物",
    Values = petshow,
    Callback = function(Value)
        EvolvePet = Value
    end
})

EvolveTab:Button({
    Title = "进化宠物",
    Callback = function()
        game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer("evolvePet", EvolvePet)
    end
})

EvolveTab:Toggle({
    Title = "自动进化宠物",
    Default = false,
    Callback = function(state)
        Interstellar.evolvepet = state
        if Interstellar.evolvepet then
            while Interstellar.evolvepet do
                game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer("evolvePet", EvolvePet)
                wait()
            end
        end
    end
})

local BirthTab = Window:Tab({Title = "重生设置", Icon = "refresh-cw"})

BirthTab:Input({
    Title = "设置重生目标",
    Placeholder = "输入重生次数",
    Callback = function(Value)
        Interstellar.birth = tonumber(Value) or 99999999999999999999999999999
    end
})

BirthTab:Toggle({
    Title = "自动重生到目标",
    Default = false,
    Callback = function(state)
        if game:GetService("Players").LocalPlayer.leaderstats.Rebirths.Value >= Interstellar.birth then
            game.Players.LocalPlayer:Kick("已自动重生到"..Interstellar.birth.."，已自动为你踢出")
        else
            Interstellar.autobirth = state
            if Interstellar.autobirth then
                while Interstellar.autobirth do
                    game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
                    wait()
                end
            end
        end
    end
})

local Info = Window:Tab({Title = "信息", Icon = "settings"})

Info:Paragraph({
    Title = "步数: " .. game:GetService("Players").LocalPlayer.leaderstats.Steps.Value,
    Callback = function(Value)
        return "步数: " .. game:GetService("Players").LocalPlayer.leaderstats.Steps.Value
    end
})

Info:Paragraph({
    Title = "经验: " .. game:GetService("Players").LocalPlayer.exp.Value,
    Callback = function(Value)
        return "经验: " .. game:GetService("Players").LocalPlayer.exp.Value
    end
})

Info:Paragraph({
    Title = "等级: " .. game:GetService("Players").LocalPlayer.level.Value,
    Callback = function(Value)
        return "等级: " .. game:GetService("Players").LocalPlayer.level.Value
    end
})

Info:Paragraph({
    Title = "比赛次数: " .. game:GetService("Players").LocalPlayer.leaderstats.Races.Value,
    Callback = function(Value)
        return "比赛次数: " .. game:GetService("Players").LocalPlayer.leaderstats.Races.Value
    end
})

Info:Paragraph({
    Title = "重生: " .. game:GetService("Players").LocalPlayer.leaderstats.Rebirths.Value,
    Callback = function(Value)
        return "重生: " .. game:GetService("Players").LocalPlayer.leaderstats.Rebirths.Value
    end
})

Info:Paragraph({
    Title = "环: " .. game:GetService("Players").LocalPlayer.leaderstats.Hoops.Value,
    Callback = function(Value)
        return "环: " .. game:GetService("Players").LocalPlayer.leaderstats.Hoops.Value
    end
})

Info:Paragraph({
    Title = "宝石: " .. game:GetService("Players").LocalPlayer.Gems.Value,
    Callback = function(Value)
        return "宝石: " .. game:GetService("Players").LocalPlayer.Gems.Value
    end
})

Window:OnClose(function()
end)

Window:OnDestroy(function()
end)
