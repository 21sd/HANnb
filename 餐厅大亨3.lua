local HttpService = cloneref(game:GetService("HttpService"))

local isfunctionhooked = clonefunction(isfunctionhooked)
if isfunctionhooked(game.HttpGet) or isfunctionhooked(getnamecallmethod) or isfunctionhooked(request) then 
    return 
end

local function verifyKey(k)
    local ok, res = pcall(function()
        return request({
            Url = "https://ouo.lat/api/verify.php",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({key = k, time = os.time()})
        })
    end)
    
    if not ok then return false end
    
    if res.Body ~= "True" then
        return false
    end
    
    local ok2, res2 = pcall(function()
        return game:HttpGet("https://www.wtb.lat/keysystem/check-key?key="..k.."&user="..game.Players.LocalPlayer.Name)
    end)
    
    return ok2 and res2 == "success"
end

local key = ""
pcall(function() key = readfile("DyzhKey.json") end)
if key ~= "" then
    if verifyKey(key) then
        print('验证完成')
    else
        return
    end
end

local HttpService = cloneref(game:GetService("HttpService"))

local isfunctionhooked = clonefunction(isfunctionhooked)

if isfunctionhooked(game.HttpGet) or isfunctionhooked(getnamecallmethod) or isfunctionhooked(request) then
    return
end

local Data = {
    ["自动收集钱"] = false,
    ["自动收集餐具"] = false,
    ["自动烹饪"] = false,
    ["自动给食物"] = false,
    ["自动拿订单"] = false,
    ["自动接订单"] = false,
    ["自动选桌子"] = false,
    ["自动拿零钱"] = false,
    ["自动领奖励"] = false,
}

local Players = cloneref(game:GetService("Players"))
local LocalPlayer = cloneref(Players.LocalPlayer)
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local cn = string.find(LocalPlayer.LocaleId, "zh") ~= nil
local T = {
    Title = cn and "餐厅大亨3" or "Restaurant Tycoon 3",
    MainSection = cn and "主要功能" or "Main",
    MainSection = cn and "我的大亨" or "My Tycoon",
    FriendSection = cn and "好友大亨" or "Friend Tycoon",
    AutoCollectBill = cn and "自动收集账单" or "Auto Collect Bill",
    AutoCollectDishes = cn and "自动收集餐具" or "Auto Collect Dishes",
    AutoCook = cn and "自动烹饪" or "Auto Cook",
    AutoGiveFood = cn and "自动送餐" or "Auto Give Food",
    AutoDoOrder = cn and "自动处理订单" or "Auto Do Order",
    AutoTakeOrder = cn and "自动接单" or "Auto Take Order",
    AutoSendTable = cn and "自动安排座位" or "Auto Send Table",
    AutoTips = cn and "自动收取小费" or "Auto Tips",
    Author = cn and "SL团队" or "Author | Nova"
}

pcall(function()
    hookfunction(require(ReplicatedStorage:FindFirstChild("Source"):FindFirstChild("Utility"):FindFirstChild("NPC"):FindFirstChild("PathUtility")).GetMovementTime, function(...)
        return 0.1
    end)
end)

function GetFriend()
    for _, v in next, Players:GetPlayers() do
        if LocalPlayer:IsFriendsWith(v.UserId) then
            return v
        end
    end
    return nil
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/SUNXIAOCHUAN-DEV/uiui/refs/heads/main/德与中山"))()

local Window =
    WindUI:CreateWindow(
    {
        Title = T.Title,
        Icon = "crown",
        IconThemed = true,
        Author = T.Author,
        Folder = "寒付费",
        Size = UDim2.fromOffset(300, 270),
        Transparent = true,
        Theme = "Dark",
        User = {
            Enabled = true,
            Callback = function()
                print("clicked")
            end,
            Anonymous = false
        },
        SideBarWidth = 200,
        HideSearchBar = true,
        ScrollBarEnabled = true,
    }
)

Window:EditOpenButton(
    {
        Title = T.OpenUI,
        Icon = "image-upscale",
        CornerRadius = UDim.new(0, 10),
        StrokeThickness = 3,
        Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29"))
    }
)

MainSection =
    Window:Section(
    {
        Title = T.MainSection,
        Opened = true
    }
)

Main = MainSection:Tab({Title = T.MainSection, Icon = "Sword"})
Friend = MainSection:Tab({Title = T.FriendSection, Icon = "Sword"})

Main:Toggle({
    Title = T.AutoCollectBill,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动收集钱"] = state
        spawn(function()
            while Data["自动收集钱"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v.Player.Value == game.Players.LocalPlayer then
                            for _, a in pairs(v.Items.Surface:GetChildren()) do
                                if a:FindFirstChild("Bill") then
                                    ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                        ["Tycoon"] = v,
                                        ["Name"] = "CollectBill",
                                        ["FurnitureModel"] = a
                                    })
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

Main:Toggle({
    Title = T.AutoCollectDishes,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动收集餐具"] = state
        spawn(function()
            while Data["自动收集餐具"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v.Player.Value == game.Players.LocalPlayer then
                            for _, a in pairs(v.Items.Surface:GetChildren()) do
                                if a.Name:find("T") and a:FindFirstChild("Trash") then
                                    ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                        ["Tycoon"] = v,
                                        ["Name"] = "CollectDishes",
                                        ["FurnitureModel"] = a
                                    })
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

Main:Toggle({
    Title = T.AutoCook,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动烹饪"] = state
        spawn(function()
            while Data["自动烹饪"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v:FindFirstChild("Player") and v.Player.Value == game.Players.LocalPlayer then
                            for _, a in pairs(v.Items.Surface:GetDescendants()) do
                                if a.Name:find("Oven") then
                                    ReplicatedStorage.Events.Cook.CookInputRequested:FireServer(
                                        "Interact",
                                        a.Parent,
                                        "Oven"
                                    )
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

Main:Toggle({
    Title = T.AutoGiveFood,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动给食物"] = state
        spawn(function()
            while Data["自动给食物"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v:FindFirstChild("Player") and v.Player.Value == game.Players.LocalPlayer then
                            if #v.Objects.Food:GetChildren() > 0 then
                                for _, a in pairs(v.Objects.Food:GetChildren()) do
                                    if not a:GetAttribute("Taken") then
                                        ReplicatedStorage.Events.Restaurant.GrabFood:InvokeServer(a)
                                        for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
                                            if gui:IsA("ImageLabel") and gui.Parent and 
                                               gui.Parent.Parent.Parent.Name == "CustomerSpeechUI" and
                                               gui.Parent.Parent.Size == UDim2.new(1, 0, 1, 0) then
                                               ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                                    Name = "Serve",
                                                    GroupId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name),
                                                    Tycoon = v,
                                                    FoodModel = a,
                                                    CustomerId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Name)
                                                })
                                                task.wait(0.1)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

Main:Toggle({
    Title = T.AutoDoOrder,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动拿订单"] = state
        spawn(function()
            while Data["自动拿订单"] do
                pcall(function()
                    for _,v in next,workspace.Temp:GetChildren() do
                        if v.Name == "Part" and v:FindFirstChildOfClass("ProximityPrompt") then
                            fireproximityprompt(v:FindFirstChildOfClass("ProximityPrompt"))
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

Main:Toggle({
    Title = T.AutoTakeOrder,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动接订单"] = state
        spawn(function()
            while Data["自动接订单"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v:FindFirstChild("Player") and v.Player.Value == game.Players.LocalPlayer then
                            for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
                                if
                                    gui:IsA("ImageLabel") and gui.Parent and gui.Parent.Parent.Parent.Name == "CustomerSpeechUI" and
                                        gui.Parent.Parent.Size == UDim2.new(1, 0, 1, 0)
                                 then
                                    ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer(
                                        {
                                            Name = "TakeOrder",
                                            GroupId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name),
                                            Tycoon = v,
                                            CustomerId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Name)
                                        }
                                    )
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

Main:Toggle({
    Title = T.AutoSendTable,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动选桌子"] = state
        spawn(function()
            while Data["自动选桌子"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v.Player.Value == game.Players.LocalPlayer then
                            for _, a in pairs(v.Items.Surface:GetChildren()) do
                                if a.Name:find("T") and not a:GetAttribute("InUse") then
                                    for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
                                        if gui:IsA("ImageLabel") and gui.Parent and gui.Parent.Parent.Parent.Name == "CustomerSpeechUI" and gui.Parent.Parent.Size == UDim2.new(1, 0, 1, 0) then
                                            ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                                ["FurnitureModel"] = a,
                                                ["Tycoon"] = v,
                                                ["Name"] = "SendToTable",
                                                ["GroupId"] = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name)
                                            })
                                            task.wait(0.1)
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                end)
                task.wait()
            end
        end)
    end
})

Main:Toggle({
    Title = T.AutoTips,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动拿零钱"] = state
        spawn(function()
            while Data["自动拿零钱"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v:FindFirstChild("Player") and v.Player.Value == game.Players.LocalPlayer then
                            ReplicatedStorage.Events.Restaurant.TipsCollected:FireServer(v)
                        end
                    end
                end)
                task.wait()
            end
        end)
    end
})

Friend:Toggle({
    Title = T.AutoCollectBill,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动收集钱"] = state
        spawn(function()
            while Data["自动收集钱"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v.Player.Value == GetFriend() then
                            for _, a in pairs(v.Items.Surface:GetChildren()) do
                                if a:FindFirstChild("Bill") then
                                    ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                        ["Tycoon"] = v,
                                        ["Name"] = "CollectBill",
                                        ["FurnitureModel"] = a
                                    })
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

Friend:Toggle({
    Title = T.AutoCollectDishes,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动收集餐具"] = state
        spawn(function()
            while Data["自动收集餐具"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v.Player.Value == GetFriend() then
                            for _, a in pairs(v.Items.Surface:GetChildren()) do
                                if a.Name:find("T") and a:FindFirstChild("Trash") then
                                    ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                        ["Tycoon"] = v,
                                        ["Name"] = "CollectDishes",
                                        ["FurnitureModel"] = a
                                    })
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

Friend:Toggle({
    Title = T.AutoCook,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动烹饪"] = state
        spawn(function()
            while Data["自动烹饪"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v:FindFirstChild("Player") and v.Player.Value == GetFriend() then
                            for _, a in pairs(v.Items.Surface:GetDescendants()) do
                                if a.Name:find("Oven") then
                                    ReplicatedStorage.Events.Cook.CookInputRequested:FireServer(
                                        "Interact",
                                        a.Parent,
                                        "Oven"
                                    )
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

Friend:Toggle({
    Title = T.AutoGiveFood,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动给食物"] = state
        spawn(function()
            while Data["自动给食物"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v:FindFirstChild("Player") and v.Player.Value == GetFriend() then
                            if #v.Objects.Food:GetChildren() > 0 then
                                for _, a in pairs(v.Objects.Food:GetChildren()) do
                                    if not a:GetAttribute("Taken") then
                                        ReplicatedStorage.Events.Restaurant.GrabFood:InvokeServer(a)
                                        for _, gui in pairs(GetFriend().PlayerGui:GetDescendants()) do
                                            if gui:IsA("ImageLabel") and gui.Parent and 
                                               gui.Parent.Parent.Parent.Name == "CustomerSpeechUI" and
                                               gui.Parent.Parent.Size == UDim2.new(1, 0, 1, 0) then
                                               ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                                    Name = "Serve",
                                                    GroupId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name),
                                                    Tycoon = v,
                                                    FoodModel = a,
                                                    CustomerId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Name)
                                                })
                                                task.wait(0.1)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

Friend:Toggle({
    Title = T.AutoDoOrder,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动拿订单"] = state
        spawn(function()
            while Data["自动拿订单"] do
                pcall(function()
                    for _,v in next,workspace.Temp:GetChildren() do
                        if v.Name == "Part" and v:FindFirstChildOfClass("ProximityPrompt") then
                            fireproximityprompt(v:FindFirstChildOfClass("ProximityPrompt"))
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

Friend:Toggle({
    Title = T.AutoTakeOrder,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动接订单"] = state
        spawn(function()
            while Data["自动接订单"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v:FindFirstChild("Player") and v.Player.Value == GetFriend() then
                            for _, gui in pairs(GetFriend().PlayerGui:GetDescendants()) do
                                if
                                    gui:IsA("ImageLabel") and gui.Parent and gui.Parent.Parent.Parent.Name == "CustomerSpeechUI" and
                                        gui.Parent.Parent.Size == UDim2.new(1, 0, 1, 0)
                                 then
                                    ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer(
                                        {
                                            Name = "TakeOrder",
                                            GroupId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name),
                                            Tycoon = v,
                                            CustomerId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Name)
                                        }
                                    )
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

Friend:Toggle({
    Title = T.AutoSendTable,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动选桌子"] = state
        spawn(function()
            while Data["自动选桌子"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v.Player.Value == GetFriend() then
                            for _, a in pairs(v.Items.Surface:GetChildren()) do
                                if a.Name:find("T") and not a:GetAttribute("InUse") then
                                    for _, gui in pairs(GetFriend().PlayerGui:GetDescendants()) do
                                        if gui:IsA("ImageLabel") and gui.Parent and gui.Parent.Parent.Parent.Name == "CustomerSpeechUI" and gui.Parent.Parent.Size == UDim2.new(1, 0, 1, 0) then
                                            ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                                ["FurnitureModel"] = a,
                                                ["Tycoon"] = v,
                                                ["Name"] = "SendToTable",
                                                ["GroupId"] = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name)
                                            })
                                            task.wait(0.1)
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                end)
                task.wait()
            end
        end)
    end
})

Friend:Toggle({
    Title = T.AutoTips,
    Image = "swords",
    Value = false,
    Callback = function(state)
        Data["自动拿零钱"] = state
        spawn(function()
            while Data["自动拿零钱"] do
                pcall(function()
                    for _, v in pairs(workspace.Tycoons:GetChildren()) do
                        if v:FindFirstChild("Player") and v.Player.Value == GetFriend() then
                            ReplicatedStorage.Events.Restaurant.TipsCollected:FireServer(v)
                        end
                    end
                end)
                task.wait()
            end
        end)
    end
})