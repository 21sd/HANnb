local oldNameCall
oldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and (method == "New" or method == "Create") then
        local className = tostring(self)
        if className == "TextLabel" or className == "TextButton" or className == "TextBox" then
            local textObj = args[1]
            if textObj and textObj.Text then
                local text = textObj.Text
                local dict = {
                    ["ObsessionHub"] = "痴迷中心",
                    ["Made By @Jiro"] = "作者: @Jiro",
                    ["Search..."] = "搜索...",
                    ["Home"] = "主页",
                    ["Parry"] = "格挡",
                    ["Auto Parry"] = "自动格挡",
                    ["Parry Chance"] = "格挡概率",
                    ["Parry Notifications"] = "格挡提示",
                    ["Stats"] = "统计",
                    ["Parried:"] = "已格挡:",
                    ["Missed:"] = "未命中:",
                    ["Reset Counter"] = "重置计数",
                    ["Info"] = "信息",
                    ["Welcome"] = "欢迎",
                    ["Welcome back,"] = "欢迎回来，",
                    ["Status"] = "状态",
                    ["Players online:"] = "在线玩家:",
                    ["Local time:"] = "本地时间:",
                    ["Copy Server Link"] = "复制服务器链接",
                    ["Close"] = "关闭",
                    ["Hide"] = "隐藏",
                    ["Clear"] = "清空"
                }
                for eng, chn in pairs(dict) do
                    text = text:gsub(eng, chn)
                end
                textObj.Text = text
            end
        end
    end
    return oldNameCall(self, ...)
end)
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "决斗场",
    Icon = "gem",
    IconSize = 22,
    Author = "7",
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
    Title = "决斗场",
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

local MainSection = Window:Tab({
    Title = "主功能",
    Icon = "box",
}):Section({
    Title = "功能选项",
    Icon = "list",
})

MainSection:Button({
    Title = "加载脚本",
    Desc = "加载服务器脚本",
    Icon = "play",
    Callback = function()
        pcall(function()
            local url = "https://luamoon.xyz/liofkwbophsubyzuujrauwfhw/loader"
            local raw = game:HttpGet(url)
            
            local replacements = {
                ["Toggle"] = "开关",
                ["Enable"] = "开启",
                ["Disable"] = "关闭",
                ["Settings"] = "设置",
                ["Main"] = "主界面",
                ["Combat"] = "战斗",
                ["Visual"] = "视觉",
                ["Player"] = "玩家",
                ["Misc"] = "杂项",
                ["Auto"] = "自动",
                ["ESP"] = "透视",
                ["Hitbox"] = "碰撞箱",
                ["Speed"] = "速度",
                ["Jump"] = "跳跃",
                ["Infinite"] = "无限",
                ["Godmode"] = "无敌",
                ["Aimbot"] = "自瞄",
                ["Silent Aim"] = "静默自瞄",
                ["Load"] = "加载",
                ["Execute"] = "执行",
                ["Search"] = "搜索",
                ["Library"] = "库",
                ["Scripts"] = "脚本",
                ["Credits"] = "制作名单",
                ["Yes"] = "是",
                ["No"] = "否",
                ["Close"] = "关闭",
                ["Hide"] = "隐藏",
                ["Show"] = "显示",
                ["Clear"] = "清空",
                ["Reset"] = "重置",
                ["Apply"] = "应用",
                ["Save"] = "保存",
                ["Keybind"] = "按键绑定",
            }

            for eng, chn in pairs(replacements) do
                raw = string.gsub(raw, eng, chn)
            end
            
            local func, err = loadstring(raw)
            if func then
                func()
            else
                print("加载失败:", err)
            end
        end)
    end,
})

MainSection:Button({
    Title = "一定要点！！！",
    Desc = "先点加载脚本再返回点这个",
    Icon = "languages",
    Callback = function()
        local dict = {
            ["ObsessionHub"] = "痴迷中心",
            ["Made By @Jiro"] = "作者: @Jiro",
            ["Search..."] = "搜索...",
            ["Home"] = "主页",
            ["Parry"] = "格挡",
            ["Auto Parry"] = "自动格挡",
            ["Parry Chance"] = "格挡概率",
            ["Parry Notifications"] = "格挡提示",
            ["Stats"] = "统计",
            ["Parried:"] = "已格挡:",
            ["Missed:"] = "未命中:",
            ["Reset Counter"] = "重置计数",
            ["Info"] = "信息",
            ["Welcome"] = "欢迎",
            ["Welcome back,"] = "欢迎回来，",
            ["Status"] = "状态",
            ["Players online:"] = "在线玩家:",
            ["Local time:"] = "本地时间:",
            ["Copy Server Link"] = "复制服务器链接",
            ["Close"] = "关闭",
            ["Hide"] = "隐藏",
            ["Clear"] = "清空",
            ["100%"] = "100%",
            ["Auto Parry"] = "自动格挡",
            ["Parry Chance"] = "格挡概率",
            ["Parry Notifications"] = "格挡提示",
            ["Stats"] = "统计",
            ["Parried: 0 | Missed: 0"] = "已格挡: 0 | 未命中: 0"
        }

        local CoreGui = game:GetService("CoreGui")
        local function translate(obj)
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                local currentText = obj.Text
                if currentText and currentText ~= "" then
                    local replaced = false
                    for eng, chn in pairs(dict) do
                        if currentText:find(eng) then
                            currentText = currentText:gsub(eng, chn)
                            replaced = true
                        end
                    end
                    if replaced then
                        obj.Text = currentText
                    end
                end
            end
        end

        for _, gui in pairs(CoreGui:GetChildren()) do
            if gui:IsA("ScreenGui") or gui:IsA("Folder") or gui.Name == "RobloxGui" then
                for _, desc in pairs(gui:GetDescendants()) do
                    pcall(translate, desc)
                end
            end
        end
        
        local PlayerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
        if PlayerGui then
            for _, desc in pairs(PlayerGui:GetDescendants()) do
                pcall(translate, desc)
            end
        end
        
        print("汉化执行完毕")
    end,
})

print("UI 已加载")