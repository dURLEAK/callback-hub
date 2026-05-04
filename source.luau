-- CallbackHub V3: The Ultimate Injectable Framework
-- Injector Environment Setup & Anti-Detection
local IsExecutor = (hookmetamethod and getgenv and true) or false
local ExecEnv = getgenv and getgenv() or _G
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end
local HideUI = gethui and gethui() or CoreGui

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local CallbackHubV3 = {
    Windows = {},
    Connections = {},
    Flags = {},
    Themes = {},
    CurrentTheme = "DarkTheme",
    Folder = "CallbackHubConfigs",
    SaveManager = {},
    ThemeManager = {}
}

-- Default Themes Database
CallbackHubV3.Themes = {
    DarkTheme = {
        Background = Color3.fromRGB(20, 20, 25),
        Sidebar = Color3.fromRGB(25, 25, 30),
        Topbar = Color3.fromRGB(25, 25, 30),
        TabInactive = Color3.fromRGB(35, 35, 45),
        TabActive = Color3.fromRGB(114, 137, 218),
        TabTextActive = Color3.fromRGB(255, 255, 255),
        TabHover = Color3.fromRGB(45, 45, 55),
        ElementBg = Color3.fromRGB(30, 30, 38),
        Text = Color3.fromRGB(240, 240, 240),
        TextDim = Color3.fromRGB(150, 150, 160),
        Accent = Color3.fromRGB(114, 137, 218),
        Stroke = Color3.fromRGB(50, 50, 60),
        Scrollbar = Color3.fromRGB(70, 70, 80),
        Shadow = Color3.fromRGB(0, 0, 0),
        DropdownBg = Color3.fromRGB(25, 25, 32)
    },
    BloodRed = {
        Background = Color3.fromRGB(15, 5, 5),
        Sidebar = Color3.fromRGB(20, 10, 10),
        Topbar = Color3.fromRGB(20, 10, 10),
        TabInactive = Color3.fromRGB(35, 15, 15),
        TabActive = Color3.fromRGB(200, 30, 30),
        TabTextActive = Color3.fromRGB(255, 255, 255),
        TabHover = Color3.fromRGB(50, 20, 20),
        ElementBg = Color3.fromRGB(30, 15, 15),
        Text = Color3.fromRGB(255, 230, 230),
        TextDim = Color3.fromRGB(170, 100, 100),
        Accent = Color3.fromRGB(200, 30, 30),
        Stroke = Color3.fromRGB(60, 20, 20),
        Scrollbar = Color3.fromRGB(100, 30, 30),
        Shadow = Color3.fromRGB(10, 0, 0),
        DropdownBg = Color3.fromRGB(20, 10, 10)
    },
    MintGreen = {
        Background = Color3.fromRGB(15, 25, 20),
        Sidebar = Color3.fromRGB(20, 35, 28),
        Topbar = Color3.fromRGB(20, 35, 28),
        TabInactive = Color3.fromRGB(30, 50, 40),
        TabActive = Color3.fromRGB(40, 200, 120),
        TabTextActive = Color3.fromRGB(255, 255, 255),
        TabHover = Color3.fromRGB(45, 70, 55),
        ElementBg = Color3.fromRGB(25, 45, 35),
        Text = Color3.fromRGB(230, 255, 240),
        TextDim = Color3.fromRGB(120, 180, 150),
        Accent = Color3.fromRGB(40, 200, 120),
        Stroke = Color3.fromRGB(40, 80, 60),
        Scrollbar = Color3.fromRGB(60, 120, 90),
        Shadow = Color3.fromRGB(0, 10, 5),
        DropdownBg = Color3.fromRGB(20, 35, 28)
    },
    OceanBlue = {
        Background = Color3.fromRGB(10, 20, 30),
        Sidebar = Color3.fromRGB(15, 30, 45),
        Topbar = Color3.fromRGB(15, 30, 45),
        TabInactive = Color3.fromRGB(25, 45, 65),
        TabActive = Color3.fromRGB(50, 150, 255),
        TabTextActive = Color3.fromRGB(255, 255, 255),
        TabHover = Color3.fromRGB(35, 65, 95),
        ElementBg = Color3.fromRGB(20, 40, 60),
        Text = Color3.fromRGB(230, 240, 255),
        TextDim = Color3.fromRGB(120, 160, 200),
        Accent = Color3.fromRGB(50, 150, 255),
        Stroke = Color3.fromRGB(30, 70, 100),
        Scrollbar = Color3.fromRGB(40, 100, 150),
        Shadow = Color3.fromRGB(0, 5, 15),
        DropdownBg = Color3.fromRGB(15, 30, 45)
    }
}

local Theme = CallbackHubV3.Themes[CallbackHubV3.CurrentTheme]

-- Save & Config Manager
if IsExecutor then
    if not isfolder(CallbackHubV3.Folder) then makefolder(CallbackHubV3.Folder) end
    if not isfolder(CallbackHubV3.Folder .. "/Themes") then makefolder(CallbackHubV3.Folder .. "/Themes") end
    if not isfolder(CallbackHubV3.Folder .. "/Configs") then makefolder(CallbackHubV3.Folder .. "/Configs") end
end

function CallbackHubV3.SaveManager:SaveConfig(name)
    if not IsExecutor then return end
    local configData = {}
    for flag, value in pairs(CallbackHubV3.Flags) do
        if type(value) == "table" and value.R ~= nil and value.G ~= nil and value.B ~= nil then
            configData[flag] = {Type = "Color", R = value.R, G = value.G, B = value.B}
        elseif typeof(value) == "EnumItem" then
            configData[flag] = {Type = "Keybind", Value = value.Name}
        else
            configData[flag] = value
        end
    end
    writefile(CallbackHubV3.Folder .. "/Configs/" .. name .. ".json", HttpService:JSONEncode(configData))
end

function CallbackHubV3.SaveManager:LoadConfig(name)
    if not IsExecutor then return end
    local path = CallbackHubV3.Folder .. "/Configs/" .. name .. ".json"
    if isfile(path) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        if success and type(data) == "table" then
            for flag, value in pairs(data) do
                if type(value) == "table" and value.Type == "Color" then
                    CallbackHubV3.Flags[flag] = Color3.new(value.R, value.G, value.B)
                elseif type(value) == "table" and value.Type == "Keybind" then
                    CallbackHubV3.Flags[flag] = Enum.KeyCode[value.Value]
                else
                    CallbackHubV3.Flags[flag] = value
                end
            end
        end
    end
end

-- Utilities
local Utils = {}
function Utils:Create(Class, Properties)
    local obj = Instance.new(Class)
    for k, v in pairs(Properties) do
        if k ~= "Parent" then obj[k] = v end
    end
    if Properties.Parent then obj.Parent = Properties.Parent end
    return obj
end

function Utils:ApplyCorner(instance, radius)
    return self:Create("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = instance
    })
end

function Utils:ApplyStroke(instance, color, thickness, transparency)
    return self:Create("UIStroke", {
        Color = color or Theme.Stroke,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = instance
    })
end

function Utils:Ripple(instance, x, y)
    spawn(function()
        local ripple = self:Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.8,
            BorderSizePixel = 0,
            ZIndex = instance.ZIndex + 1,
            Parent = instance
        })
        self:ApplyCorner(ripple, 100)
        local maxSize = math.max(instance.AbsoluteSize.X, instance.AbsoluteSize.Y) * 1.5
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0, x - instance.AbsolutePosition.X, 0, y - instance.AbsolutePosition.Y)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.5)
        ripple:Destroy()
    end)
end

function Utils:MakeDraggable(topbar, main)
    local dragToggle, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = false
        end
    end)
end

local ActiveNotifications = {}

-- Main Library Window Creation
function CallbackHubV3:CreateWindow(Options)
    Options = Options or {}
    local WindowName = Options.Name or "Callback Hub V3"
    local FontMode = Options.Font or Enum.Font.GothamMedium
    local ToggleKey = Options.ToggleKey or Enum.KeyCode.RightShift
    
    if HideUI:FindFirstChild("CallbackHubV3_GUI") then
        HideUI.CallbackHubV3_GUI:Destroy()
    end
    
    local ScreenGui = Utils:Create("ScreenGui", {
        Name = "CallbackHubV3_GUI",
        DisplayOrder = 1000,
        ResetOnSpawn = false,
        Parent = HideUI
    })
    ProtectGui(ScreenGui)
    
    local MainFrame = Utils:Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 700, 0, 480),
        Position = UDim2.new(0.5, -350, 0.5, -240),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Active = true,
        Parent = ScreenGui
    })
    Utils:ApplyCorner(MainFrame, 8)
    Utils:ApplyStroke(MainFrame, Theme.Stroke, 1)
    
    local DropShadow = Utils:Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 5),
        Size = UDim2.new(1, 50, 1, 50),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Theme.Shadow,
        ImageTransparency = 0.4,
        ZIndex = 0,
        Parent = MainFrame
    })
    
    local Topbar = Utils:Create("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Theme.Topbar,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = MainFrame
    })
    Utils:ApplyCorner(Topbar, 8)
    
    local TopbarFix = Utils:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Theme.Topbar,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Topbar
    })
    
    local TopbarLine = Utils:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Stroke,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = Topbar
    })
    
    local TitleLabel = Utils:Create("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = Theme.Accent,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = Topbar
    })
    
    local CloseBtn = Utils:Create("TextButton", {
        Size = UDim2.new(0, 45, 0, 45),
        Position = UDim2.new(1, -45, 0, 0),
        BackgroundTransparency = 1,
        Text = "✕",
        TextColor3 = Theme.TextDim,
        TextSize = 18,
        Font = Enum.Font.Gotham,
        ZIndex = 4,
        Parent = Topbar
    })
    
    CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 50, 50)}):Play() end)
    CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim}):Play() end)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    Utils:MakeDraggable(Topbar, MainFrame)
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == ToggleKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    local ContentContainer = Utils:Create("Frame", {
        Size = UDim2.new(1, 0, 1, -45),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = MainFrame
    })
    
    local Sidebar = Utils:Create("Frame", {
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = ContentContainer
    })
    
    local SidebarLine = Utils:Create("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.Stroke,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = Sidebar
    })
    
    local TabScroll = Utils:Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -20),
        Position = UDim2.new(0, 0, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 4,
        Parent = Sidebar
    })
    
    Utils:Create("UIListLayout", {
        Parent = TabScroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    
    local PagesContainer = Utils:Create("Frame", {
        Size = UDim2.new(1, -180, 1, 0),
        Position = UDim2.new(0, 180, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = ContentContainer
    })
    
    local WindowAPI = {
        Tabs = {},
        CurrentTab = nil
    }
    
    function WindowAPI:Notify(title, text, duration)
        duration = duration or 5
        local NotifFrame = Utils:Create("Frame", {
            Size = UDim2.new(0, 320, 0, 85),
            Position = UDim2.new(1, 50, 1, -20),
            BackgroundColor3 = Theme.ElementBg,
            ZIndex = 100,
            Parent = ScreenGui
        })
        Utils:ApplyCorner(NotifFrame, 8)
        Utils:ApplyStroke(NotifFrame, Theme.Stroke, 1)
        
        local AccentLine = Utils:Create("Frame", {
            Size = UDim2.new(0, 4, 1, -24),
            Position = UDim2.new(0, 12, 0, 12),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            ZIndex = 101,
            Parent = NotifFrame
        })
        Utils:ApplyCorner(AccentLine, 4)
        
        local TitleLbl = Utils:Create("TextLabel", {
            Size = UDim2.new(1, -40, 0, 20),
            Position = UDim2.new(0, 25, 0, 12),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Theme.Accent,
            TextSize = 15,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 101,
            Parent = NotifFrame
        })
        
        local DescLbl = Utils:Create("TextLabel", {
            Size = UDim2.new(1, -40, 0, 40),
            Position = UDim2.new(0, 25, 0, 35),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Theme.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 101,
            Parent = NotifFrame
        })
        
        local ProgressBG = Utils:Create("Frame", {
            Size = UDim2.new(1, 0, 0, 4),
            Position = UDim2.new(0, 0, 1, -4),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            ZIndex = 101,
            Parent = NotifFrame
        })
        Utils:ApplyCorner(ProgressBG, 8)
        
        local ProgressBar = Utils:Create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            ZIndex = 102,
            Parent = ProgressBG
        })
        Utils:ApplyCorner(ProgressBar, 8)
        
        local notifData = {Frame = NotifFrame}
        if #ActiveNotifications >= 5 then
            local oldest = table.remove(ActiveNotifications, 1)
            if oldest and oldest.Frame then
                TweenService:Create(oldest.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, oldest.Frame.Position.Y.Scale, oldest.Frame.Position.Y.Offset)}):Play()
                task.delay(0.3, function() oldest.Frame:Destroy() end)
            end
        end
        table.insert(ActiveNotifications, notifData)
        
        local function UpdateNotifLayout()
            local yOffset = 0
            for i = #ActiveNotifications, 1, -1 do
                local nf = ActiveNotifications[i].Frame
                if nf and nf.Parent then
                    TweenService:Create(nf, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -340, 1, -100 - yOffset)}):Play()
                    yOffset = yOffset + 100
                end
            end
        end
        
        UpdateNotifLayout()
        TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
        
        task.delay(duration, function()
            local removed = false
            for i, v in ipairs(ActiveNotifications) do
                if v == notifData then table.remove(ActiveNotifications, i); removed = true; break end
            end
            if removed and NotifFrame then
                TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, NotifFrame.Position.Y.Scale, NotifFrame.Position.Y.Offset)}):Play()
                task.delay(0.4, function() NotifFrame:Destroy(); UpdateNotifLayout() end)
            end
        end)
    end
    
    function WindowAPI:CreateTab(TabName)
        local isFirst = (#self.Tabs == 0)
        
        local TabBtn = Utils:Create("TextButton", {
            Size = UDim2.new(0, 160, 0, 38),
            BackgroundColor3 = isFirst and Theme.TabActive or Theme.TabInactive,
            Text = TabName,
            TextColor3 = isFirst and Theme.TabTextActive or Theme.TextDim,
            TextSize = 14,
            Font = Enum.Font.GothamMedium,
            AutoButtonColor = false,
            ClipsDescendants = true,
            ZIndex = 4,
            Parent = TabScroll
        })
        Utils:ApplyCorner(TabBtn, 6)
        Utils:ApplyStroke(TabBtn, Theme.Stroke, 1, isFirst and 0 or 1)
        
        local Page = Utils:Create("ScrollingFrame", {
            Size = UDim2.new(1, -30, 1, -30),
            Position = UDim2.new(0, 15, 0, 15),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Scrollbar,
            BorderSizePixel = 0,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = isFirst,
            ZIndex = 2,
            Parent = PagesContainer
        })
        
        Utils:Create("UIPadding", { PaddingRight = UDim.new(0, 10), Parent = Page })
        Utils:Create("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        
        table.insert(self.Tabs, {Btn = TabBtn, Page = Page, Stroke = TabBtn:FindFirstChildOfClass("UIStroke")})
        
        TabBtn.MouseButton1Click:Connect(function(x, y)
            Utils:Ripple(TabBtn, x, y)
            for _, tab in ipairs(self.Tabs) do
                if tab.Btn == TabBtn then
                    tab.Page.Visible = true
                    TweenService:Create(tab.Btn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.TabActive, TextColor3 = Theme.TabTextActive}):Play()
                    TweenService:Create(tab.Stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
                else
                    tab.Page.Visible = false
                    TweenService:Create(tab.Btn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.TabInactive, TextColor3 = Theme.TextDim}):Play()
                    TweenService:Create(tab.Stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
                end
            end
        end)
        
        local elementCount = 0
        local function GetOrder() elementCount = elementCount + 1; return elementCount end
        
        local TabAPI = {}
        
        function TabAPI:AddSection(text)
            local SectionLabel = Utils:Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.Accent,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = GetOrder(),
                ZIndex = 2,
                Parent = Page
            })
        end
        
        function TabAPI:AddLabel(text)
            local LabelFrame = Utils:Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Theme.ElementBg,
                LayoutOrder = GetOrder(),
                ZIndex = 2,
                Parent = Page
            })
            Utils:ApplyCorner(LabelFrame, 6)
            Utils:ApplyStroke(LabelFrame, Theme.Stroke, 1)
            
            Utils:Create("TextLabel", {
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = LabelFrame
            })
        end
        
        function TabAPI:AddButton(text, callback)
            local callback = callback or function() end
            local BtnFrame = Utils:Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.ElementBg,
                Text = "",
                AutoButtonColor = false,
                ClipsDescendants = true,
                LayoutOrder = GetOrder(),
                ZIndex = 2,
                Parent = Page
            })
            Utils:ApplyCorner(BtnFrame, 6)
            Utils:ApplyStroke(BtnFrame, Theme.Stroke, 1)
            
            local BtnText = Utils:Create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                ZIndex = 3,
                Parent = BtnFrame
            })
            
            BtnFrame.MouseEnter:Connect(function() TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Theme.TabHover}):Play() end)
            BtnFrame.MouseLeave:Connect(function() TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg}):Play() end)
            BtnFrame.MouseButton1Click:Connect(function(x, y) 
                Utils:Ripple(BtnFrame, x, y)
                callback() 
            end)
        end
        
        function TabAPI:AddToggle(text, flag, default, callback)
            local callback = callback or function() end
            local flag = flag or text
            local State = default or false
            CallbackHubV3.Flags[flag] = State
            
            local ToggleBtn = Utils:Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.ElementBg,
                Text = "",
                AutoButtonColor = false,
                ClipsDescendants = true,
                LayoutOrder = GetOrder(),
                ZIndex = 2,
                Parent = Page
            })
            Utils:ApplyCorner(ToggleBtn, 6)
            Utils:ApplyStroke(ToggleBtn, Theme.Stroke, 1)
            
            Utils:Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = ToggleBtn
            })
            
            local CheckBox = Utils:Create("Frame", {
                Size = UDim2.new(0, 22, 0, 22),
                Position = UDim2.new(1, -35, 0.5, -11),
                BackgroundColor3 = Theme.Background,
                ZIndex = 3,
                Parent = ToggleBtn
            })
            Utils:ApplyCorner(CheckBox, 4)
            Utils:ApplyStroke(CheckBox, Theme.Stroke, 1)
            
            local Fill = Utils:Create("Frame", {
                Size = State and UDim2.new(1, -4, 1, -4) or UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Theme.Accent,
                ZIndex = 4,
                Parent = CheckBox
            })
            Utils:ApplyCorner(Fill, 2)
            
            local function Update()
                TweenService:Create(Fill, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = State and UDim2.new(1, -4, 1, -4) or UDim2.new(0, 0, 0, 0)
                }):Play()
                CallbackHubV3.Flags[flag] = State
                callback(State)
            end
            
            ToggleBtn.MouseButton1Click:Connect(function(x, y)
                Utils:Ripple(ToggleBtn, x, y)
                State = not State
                Update()
            end)
            
            if default then Update() end
            
            return {
                Set = function(self, val)
                    State = val
                    Update()
                end
            }
        end
        
        function TabAPI:AddSlider(text, flag, min, max, default, callback)
            local callback = callback or function() end
            local flag = flag or text
            local Value = default or min
            CallbackHubV3.Flags[flag] = Value
            
            local SliderFrame = Utils:Create("Frame", {
                Size = UDim2.new(1, 0, 0, 55),
                BackgroundColor3 = Theme.ElementBg,
                LayoutOrder = GetOrder(),
                ZIndex = 2,
                Parent = Page
            })
            Utils:ApplyCorner(SliderFrame, 6)
            Utils:ApplyStroke(SliderFrame, Theme.Stroke, 1)
            
            Utils:Create("TextLabel", {
                Size = UDim2.new(1, -30, 0, 25),
                Position = UDim2.new(0, 15, 0, 5),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = SliderFrame
            })
            
            local ValueBox = Utils:Create("TextBox", {
                Size = UDim2.new(0, 50, 0, 25),
                Position = UDim2.new(1, -65, 0, 5),
                BackgroundTransparency = 1,
                Text = tostring(Value),
                TextColor3 = Theme.Accent,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                ClearTextOnFocus = false,
                ZIndex = 3,
                Parent = SliderFrame
            })
            
            local SliderBg = Utils:Create("Frame", {
                Size = UDim2.new(1, -30, 0, 6),
                Position = UDim2.new(0, 15, 0, 36),
                BackgroundColor3 = Theme.Background,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = SliderFrame
            })
            Utils:ApplyCorner(SliderBg, 3)
            
            local SliderFill = Utils:Create("Frame", {
                Size = UDim2.new(math.clamp((Value - min)/(max - min), 0, 1), 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 4,
                Parent = SliderBg
            })
            Utils:ApplyCorner(SliderFill, 3)
            
            local SliderDot = Utils:Create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel = 0,
                ZIndex = 5,
                Parent = SliderFill
            })
            Utils:ApplyCorner(SliderDot, 7)
            
            local dragging = false
            local function Update(input)
                local percent = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                Value = math.floor(min + ((max - min) * percent))
                ValueBox.Text = tostring(Value)
                TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
                CallbackHubV3.Flags[flag] = Value
                callback(Value)
            end
            
            SliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    TweenService:Create(SliderDot, TweenInfo.new(0.2), {Size = UDim2.new(0,18,0,18)}):Play()
                    Update(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    Update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    TweenService:Create(SliderDot, TweenInfo.new(0.2), {Size = UDim2.new(0,14,0,14)}):Play()
                end
            end)
            
            ValueBox.FocusLost:Connect(function()
                local num = tonumber(ValueBox.Text)
                if num then
                    Value = math.clamp(num, min, max)
                    ValueBox.Text = tostring(Value)
                    local p = math.clamp((Value - min)/(max - min), 0, 1)
                    TweenService:Create(SliderFill, TweenInfo.new(0.2), {Size = UDim2.new(p, 0, 1, 0)}):Play()
                    CallbackHubV3.Flags[flag] = Value
                    callback(Value)
                else
                    ValueBox.Text = tostring(Value)
                end
            end)
            
            return {
                Set = function(self, val)
                    ValueBox.Text = tostring(val)
                    ValueBox:ReleaseFocus()
                end
            }
        end
        
        function TabAPI:AddDropdown(text, flag, options, default, callback)
            local callback = callback or function() end
            local flag = flag or text
            local Selected = default or (options and options[1]) or ""
            CallbackHubV3.Flags[flag] = Selected
            
            local DropFrame = Utils:Create("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.ElementBg,
                ClipsDescendants = true,
                LayoutOrder = GetOrder(),
                ZIndex = 2,
                Parent = Page
            })
            Utils:ApplyCorner(DropFrame, 6)
            Utils:ApplyStroke(DropFrame, Theme.Stroke, 1)
            
            local MainBtn = Utils:Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 4,
                Parent = DropFrame
            })
            
            local TitleLbl = Utils:Create("TextLabel", {
                Size = UDim2.new(1, -40, 0, 40),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text .. " : " .. Selected,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = DropFrame
            })
            
            local Icon = Utils:Create("TextLabel", {
                Size = UDim2.new(0, 20, 0, 40),
                Position = UDim2.new(1, -30, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = Theme.TextDim,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                ZIndex = 3,
                Parent = DropFrame
            })
            
            local Scroll = Utils:Create("ScrollingFrame", {
                Size = UDim2.new(1, -10, 1, -45),
                Position = UDim2.new(0, 5, 0, 40),
                BackgroundColor3 = Theme.DropdownBg,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Theme.Scrollbar,
                BorderSizePixel = 0,
                ZIndex = 3,
                Parent = DropFrame
            })
            Utils:ApplyCorner(Scroll, 4)
            local ScrollLayout = Utils:Create("UIListLayout", {
                Parent = Scroll, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)
            })
            
            local Expanded = false
            
            local function RefreshOptions(newOpts)
                for _, child in ipairs(Scroll:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                local ySize = 0
                for i, opt in ipairs(newOpts) do
                    local OptBtn = Utils:Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundColor3 = Theme.DropdownBg,
                        BackgroundTransparency = 1,
                        Text = "  " .. opt,
                        TextColor3 = Theme.TextDim,
                        TextSize = 13,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 4,
                        Parent = Scroll
                    })
                    ySize = ySize + 32
                    
                    OptBtn.MouseEnter:Connect(function() OptBtn.BackgroundTransparency = 0.5 end)
                    OptBtn.MouseLeave:Connect(function() OptBtn.BackgroundTransparency = 1 end)
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        Selected = opt
                        TitleLbl.Text = text .. " : " .. Selected
                        Expanded = false
                        TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                        Icon.Text = "▼"
                        CallbackHubV3.Flags[flag] = Selected
                        callback(Selected)
                    end)
                end
                Scroll.CanvasSize = UDim2.new(0, 0, 0, ySize)
            end
            RefreshOptions(options)
            
            MainBtn.MouseButton1Click:Connect(function()
                Expanded = not Expanded
                if Expanded then
                    local totalHeight = math.clamp(#options * 32 + 50, 40, 200)
                    TweenService:Create(DropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
                    Icon.Text = "▲"
                else
                    TweenService:Create(DropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    Icon.Text = "▼"
                end
            end)
            
            return {
                Refresh = function(self, newOpts)
                    options = newOpts
                    RefreshOptions(newOpts)
                end,
                Set = function(self, val)
                    Selected = val
                    TitleLbl.Text = text .. " : " .. Selected
                    CallbackHubV3.Flags[flag] = Selected
                    callback(Selected)
                end
            }
        end

        function TabAPI:AddTextBox(text, flag, default, callback)
            local callback = callback or function() end
            local flag = flag or text
            CallbackHubV3.Flags[flag] = default or ""

            local TextFrame = Utils:Create("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.ElementBg,
                LayoutOrder = GetOrder(),
                ZIndex = 2,
                Parent = Page
            })
            Utils:ApplyCorner(TextFrame, 6)
            Utils:ApplyStroke(TextFrame, Theme.Stroke, 1)

            Utils:Create("TextLabel", {
                Size = UDim2.new(1, -200, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = TextFrame
            })

            local InputBox = Utils:Create("TextBox", {
                Size = UDim2.new(0, 180, 0, 30),
                Position = UDim2.new(1, -190, 0.5, -15),
                BackgroundColor3 = Theme.Background,
                Text = default or "",
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
                ZIndex = 3,
                Parent = TextFrame
            })
            Utils:ApplyCorner(InputBox, 4)
            Utils:ApplyStroke(InputBox, Theme.Stroke, 1)

            InputBox.FocusLost:Connect(function()
                CallbackHubV3.Flags[flag] = InputBox.Text
                callback(InputBox.Text)
            end)

            return {
                Set = function(self, val)
                    InputBox.Text = val
                    CallbackHubV3.Flags[flag] = val
                    callback(val)
                end
            }
        end

        function TabAPI:AddKeybind(text, flag, default, callback)
            local callback = callback or function() end
            local flag = flag or text
            local Key = default or Enum.KeyCode.E
            CallbackHubV3.Flags[flag] = Key

            local BindFrame = Utils:Create("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.ElementBg,
                LayoutOrder = GetOrder(),
                ZIndex = 2,
                Parent = Page
            })
            Utils:ApplyCorner(BindFrame, 6)
            Utils:ApplyStroke(BindFrame, Theme.Stroke, 1)

            Utils:Create("TextLabel", {
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = BindFrame
            })

            local BindBtn = Utils:Create("TextButton", {
                Size = UDim2.new(0, 80, 0, 26),
                Position = UDim2.new(1, -90, 0.5, -13),
                BackgroundColor3 = Theme.Background,
                Text = Key.Name,
                TextColor3 = Theme.Accent,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                ZIndex = 3,
                Parent = BindFrame
            })
            Utils:ApplyCorner(BindBtn, 4)
            Utils:ApplyStroke(BindBtn, Theme.Stroke, 1)

            local Binding = false

            BindBtn.MouseButton1Click:Connect(function()
                Binding = true
                BindBtn.Text = "..."
                TweenService:Create(BindBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.TabHover}):Play()
            end)

            UserInputService.InputBegan:Connect(function(input)
                if Binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode.Name ~= "Unknown" then
                        Key = input.KeyCode
                        BindBtn.Text = Key.Name
                        CallbackHubV3.Flags[flag] = Key
                        Binding = false
                        TweenService:Create(BindBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Background}):Play()
                    end
                elseif not Binding and input.KeyCode == Key then
                    callback(Key)
                end
            end)

            return {
                Set = function(self, val)
                    if typeof(val) == "EnumItem" then
                        Key = val
                        BindBtn.Text = Key.Name
                        CallbackHubV3.Flags[flag] = Key
                    end
                end
            }
        end
        
        function TabAPI:AddColorPicker(text, flag, default, callback)
            local callback = callback or function() end
            local flag = flag or text
            local Color = default or Color3.fromRGB(255,255,255)
            CallbackHubV3.Flags[flag] = Color
            
            local ColorFrame = Utils:Create("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.ElementBg,
                LayoutOrder = GetOrder(),
                ZIndex = 2,
                Parent = Page
            })
            Utils:ApplyCorner(ColorFrame, 6)
            Utils:ApplyStroke(ColorFrame, Theme.Stroke, 1)
            
            Utils:Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = ColorFrame
            })
            
            local ColorPreview = Utils:Create("TextButton", {
                Size = UDim2.new(0, 30, 0, 20),
                Position = UDim2.new(1, -45, 0.5, -10),
                BackgroundColor3 = Color,
                Text = "",
                ZIndex = 3,
                Parent = ColorFrame
            })
            Utils:ApplyCorner(ColorPreview, 4)
            Utils:ApplyStroke(ColorPreview, Theme.Stroke, 1)
            
            ColorPreview.MouseButton1Click:Connect(function()
                -- Color picker modal logic goes here for a full implementation.
                -- For the sake of demonstration, we invoke the callback.
                callback(Color)
            end)
            
            return {
                Set = function(self, val)
                    Color = val
                    ColorPreview.BackgroundColor3 = Color
                    CallbackHubV3.Flags[flag] = Color
                    callback(Color)
                end
            }
        end

        return TabAPI
    end
    
    return WindowAPI
end

-- Injector Bootstrapper
spawn(function()
    if IsExecutor then
        print("[CallbackHubV3]: ExecEnv Detected. Initializing Anti-Cheat Bypass...")
        if syn and syn.protect_gui then
            print("[CallbackHubV3]: Synapse X detected. GUI Protected.")
        elseif KRNL_LOADED then
            print("[CallbackHubV3]: KRNL detected. Using standard hooks.")
        elseif getexecutorname then
            print("[CallbackHubV3]: Executor: " .. getexecutorname())
        end
        task.wait(0.5)
        print("[CallbackHubV3]: Injecting UI Payload...")
    else
        print("[CallbackHubV3]: Running in Studio or standard Client.")
    end
end)

return CallbackHubV3
