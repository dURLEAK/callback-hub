local CallbackHub = {}

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    Background = Color3.fromRGB(10, 10, 10),
    Sidebar = Color3.fromRGB(15, 15, 15),
    Topbar = Color3.fromRGB(12, 12, 12),
    TabInactive = Color3.fromRGB(15, 15, 15),
    TabActive = Color3.fromRGB(245, 245, 245),
    TabTextActive = Color3.fromRGB(10, 10, 10),
    TabHover = Color3.fromRGB(30, 30, 30),
    ElementBg = Color3.fromRGB(25, 25, 25),
    Text = Color3.fromRGB(230, 230, 230),
    TextDim = Color3.fromRGB(150, 150, 150),
    Accent = Color3.fromRGB(255, 255, 255),
    Stroke = Color3.fromRGB(50, 50, 50),
    Scrollbar = Color3.fromRGB(255, 255, 255),
    ElementTransparency = 0.4
}

local ActiveNotifications = {}

function CallbackHub:CreateWindow(options)
    local WindowOptions = options or {}
    local TitleText = WindowOptions.Title or "Callback Hub"
    local MainFont = WindowOptions.Font or Enum.Font.SourceSans
    local ToggleKey = WindowOptions.ToggleKey or Enum.KeyCode.Insert
    local AutoSize = WindowOptions.AutoSize == nil and true or WindowOptions.AutoSize

    if CoreGui:FindFirstChild("CallbackHub") then
        CoreGui.CallbackHub:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CallbackHub"
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = CoreGui

    local MobileToggle = Instance.new("TextButton")
    MobileToggle.Name = "MobileToggle"
    MobileToggle.Size = UDim2.new(0, 45, 0, 45)
    MobileToggle.Position = UDim2.new(0, 15, 0, 15)
    MobileToggle.BackgroundColor3 = Theme.Topbar
    MobileToggle.BackgroundTransparency = 0.2
    MobileToggle.Text = "UI"
    MobileToggle.TextColor3 = Theme.Text
    MobileToggle.TextSize = 16
    MobileToggle.Font = Enum.Font.Code
    MobileToggle.ZIndex = 999
    MobileToggle.Parent = ScreenGui

    Instance.new("UICorner", MobileToggle).CornerRadius = UDim.new(1, 0)
    local MTStroke = Instance.new("UIStroke", MobileToggle)
    MTStroke.Color = Theme.Stroke
    MTStroke.Thickness = 1
    
    local ToggleScale = Instance.new("UIScale", MobileToggle)

    local dragToggle = false
    local dragStartToggle, startPosToggle

    MobileToggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStartToggle = input.Position
            startPosToggle = MobileToggle.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartToggle
            local currentScale = ToggleScale.Scale
            MobileToggle.Position = UDim2.new(
                startPosToggle.X.Scale, 
                startPosToggle.X.Offset + (delta.X / currentScale), 
                startPosToggle.Y.Scale, 
                startPosToggle.Y.Offset + (delta.Y / currentScale)
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = false
        end
    end)

    local Main = Instance.new("Frame")
    Main.BackgroundColor3 = Theme.Background
    Main.BackgroundTransparency = 0.35
    Main.AnchorPoint = Vector2.new(0.5, 0) 
    Main.Position = UDim2.new(0.5, 0, 0.5, -200) 
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Active = true
    Main.Parent = ScreenGui
    Main.ClipsDescendants = true
    
    local MainScale = Instance.new("UIScale", Main)

    if AutoSize then
        local function UpdateScale()
            local ViewportSize = workspace.CurrentCamera.ViewportSize
            if ViewportSize.X < 850 then
                local scaleFactor = math.clamp(ViewportSize.X / 850, 0.55, 0.9)
                MainScale.Scale = scaleFactor
                ToggleScale.Scale = scaleFactor
            else
                MainScale.Scale = 1
                ToggleScale.Scale = 1
            end
        end
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)
        UpdateScale()
    end

    MobileToggle.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Theme.Stroke
    MainStroke.Thickness = 1

    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = Theme.Topbar
    Topbar.BackgroundTransparency = 0.2
    Topbar.BorderSizePixel = 0
    Topbar.ZIndex = 2
    Topbar.Parent = Main

    local TopbarLine = Instance.new("Frame")
    TopbarLine.Size = UDim2.new(1, 0, 0, 1)
    TopbarLine.Position = UDim2.new(0, 0, 1, 0)
    TopbarLine.BackgroundColor3 = Theme.Stroke
    TopbarLine.BorderSizePixel = 0
    TopbarLine.ZIndex = 2
    TopbarLine.Parent = Topbar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Text = TitleText
    Title.TextColor3 = Theme.Text
    Title.TextSize = 15
    Title.Font = MainFont
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 2
    Title.Parent = Topbar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.TextDim
    CloseBtn.TextSize = 15
    CloseBtn.Font = MainFont
    CloseBtn.ZIndex = 2
    CloseBtn.Parent = Topbar

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 40, 0, 40)
    MinBtn.Position = UDim2.new(1, -80, 0, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Theme.TextDim
    MinBtn.TextSize = 18
    MinBtn.Font = MainFont
    MinBtn.ZIndex = 2
    MinBtn.Parent = Topbar

    CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Text}):Play() end)
    CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim}):Play() end)
    MinBtn.MouseEnter:Connect(function() TweenService:Create(MinBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Text}):Play() end)
    MinBtn.MouseLeave:Connect(function() TweenService:Create(MinBtn, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim}):Play() end)

    local ContentWrap = Instance.new("Frame")
    ContentWrap.Size = UDim2.new(1, 0, 1, -41)
    ContentWrap.Position = UDim2.new(0, 0, 0, 41)
    ContentWrap.BackgroundTransparency = 1
    ContentWrap.ZIndex = 2
    ContentWrap.Parent = Main

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BackgroundTransparency = 0.2
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 2
    Sidebar.Parent = ContentWrap

    local SidebarLine = Instance.new("Frame")
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, 0, 0, 0)
    SidebarLine.BackgroundColor3 = Theme.Stroke
    SidebarLine.BorderSizePixel = 0
    SidebarLine.ZIndex = 2
    SidebarLine.Parent = Sidebar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -20)
    TabContainer.Position = UDim2.new(0, 0, 0, 10)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.ZIndex = 2
    TabContainer.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local PageContainer = Instance.new("Frame")
    PageContainer.Size = UDim2.new(1, -151, 1, 0)
    PageContainer.Position = UDim2.new(0, 151, 0, 0)
    PageContainer.BackgroundTransparency = 1
    PageContainer.ZIndex = 2
    PageContainer.Parent = ContentWrap

    local Minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 600, 0, 40)}):Play()
            ContentWrap.Visible = false
        else
            ContentWrap.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 600, 0, 400)}):Play()
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == ToggleKey then
            Main.Visible = not Main.Visible
        end
    end)

    local dragStart, startPos, draggingUI
    Topbar.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            draggingUI = true; dragStart = i.Position; startPos = Main.Position 
        end 
    end)
    UserInputService.InputChanged:Connect(function(i) 
        if draggingUI and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
            local d = i.Position - dragStart 
            local currentScale = MainScale.Scale
            Main.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + (d.X / currentScale), 
                startPos.Y.Scale, 
                startPos.Y.Offset + (d.Y / currentScale)
            ) 
        end 
    end)
    UserInputService.InputEnded:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then draggingUI = false end 
    end)

    local function ApplyCornerAndStroke(frame, radius)
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, radius)
        local Stroke = Instance.new("UIStroke", frame)
        Stroke.Color = Theme.Stroke
        Stroke.Transparency = 0.6
        return Stroke
    end

    local WindowObj = {
        ScreenGui = ScreenGui,
        Main = Main,
        Tabs = {},
        CurrentFont = MainFont
    }

    function WindowObj:SetToggleKey(newKey)
        ToggleKey = newKey
    end

    function WindowObj:SetGlobalFont(newFont)
        WindowObj.CurrentFont = newFont
        for _, v in pairs(ScreenGui:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                v.Font = newFont
            end
        end
    end

    function WindowObj:Notify(title, text, duration)
        duration = duration or 4.5
        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(0, 300, 0, 75)
        NotifFrame.Position = UDim2.new(1, 20, 1, -20)
        NotifFrame.BackgroundColor3 = Theme.ElementBg
        NotifFrame.BackgroundTransparency = 0.1
        NotifFrame.ZIndex = 100
        NotifFrame.Parent = ScreenGui
        
        Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)
        local NStr = Instance.new("UIStroke", NotifFrame)
        NStr.Color = Theme.Stroke
        NStr.Transparency = 0.4
        
        local AccentLine = Instance.new("Frame")
        AccentLine.Size = UDim2.new(0, 3, 1, -24)
        AccentLine.Position = UDim2.new(0, 12, 0, 12)
        AccentLine.BackgroundColor3 = Theme.Accent
        AccentLine.BorderSizePixel = 0
        AccentLine.ZIndex = 101
        AccentLine.Parent = NotifFrame
        Instance.new("UICorner", AccentLine).CornerRadius = UDim.new(1, 0)
        
        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Size = UDim2.new(1, -30, 0, 20)
        TitleLbl.Position = UDim2.new(0, 25, 0, 12)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = title
        TitleLbl.TextColor3 = Theme.Accent
        TitleLbl.TextSize = 14
        TitleLbl.Font = WindowObj.CurrentFont
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.ZIndex = 101
        TitleLbl.Parent = NotifFrame
        
        local DescLbl = Instance.new("TextLabel")
        DescLbl.Size = UDim2.new(1, -40, 0, 30)
        DescLbl.Position = UDim2.new(0, 25, 0, 32)
        DescLbl.BackgroundTransparency = 1
        DescLbl.Text = text
        DescLbl.TextColor3 = Theme.Text
        DescLbl.TextSize = 14
        DescLbl.Font = WindowObj.CurrentFont
        DescLbl.TextWrapped = true
        DescLbl.TextXAlignment = Enum.TextXAlignment.Left
        DescLbl.TextYAlignment = Enum.TextYAlignment.Top
        DescLbl.ZIndex = 101
        DescLbl.Parent = NotifFrame
        
        local ProgressBG = Instance.new("Frame")
        ProgressBG.Size = UDim2.new(1, 0, 0, 3)
        ProgressBG.Position = UDim2.new(0, 0, 1, -3)
        ProgressBG.BackgroundColor3 = Theme.Background
        ProgressBG.BorderSizePixel = 0
        ProgressBG.ZIndex = 101
        ProgressBG.Parent = NotifFrame
        Instance.new("UICorner", ProgressBG).CornerRadius = UDim.new(0, 8)

        local ProgressBar = Instance.new("Frame")
        ProgressBar.Size = UDim2.new(1, 0, 1, 0)
        ProgressBar.BackgroundColor3 = Theme.Accent
        ProgressBar.BorderSizePixel = 0
        ProgressBar.ZIndex = 102
        ProgressBar.Parent = ProgressBG
        Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(0, 8)
        
        local notifData = {Frame = NotifFrame}

        if #ActiveNotifications >= 3 then
            local oldest = table.remove(ActiveNotifications, 1)
            if oldest and oldest.Frame and oldest.Frame.Parent then
                TweenService:Create(oldest.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(1, 20, oldest.Frame.Position.Y.Scale, oldest.Frame.Position.Y.Offset)}):Play()
                task.delay(0.3, function()
                    if oldest.Frame then oldest.Frame:Destroy() end
                end)
            end
        end

        table.insert(ActiveNotifications, notifData)
        
        local function UpdateLayout()
            local yOffset = 0
            for i = #ActiveNotifications, 1, -1 do
                local nf = ActiveNotifications[i].Frame
                if nf and nf.Parent then
                    TweenService:Create(nf, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -320, 1, -95 - yOffset)}):Play()
                    yOffset = yOffset + 85
                end
            end
        end
        
        UpdateLayout()
        TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
        
        task.delay(duration, function()
            local removedByTimer = false
            for i, v in ipairs(ActiveNotifications) do
                if v == notifData then
                    table.remove(ActiveNotifications, i)
                    removedByTimer = true
                    break
                end
            end
            
            if removedByTimer and NotifFrame and NotifFrame.Parent then
                TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(1, 20, NotifFrame.Position.Y.Scale, NotifFrame.Position.Y.Offset)}):Play()
                task.delay(0.4, function() 
                    if NotifFrame then NotifFrame:Destroy() end
                    UpdateLayout() 
                end)
            end
        end)
    end

    function WindowObj:CreateTab(name)
        local isFirst = (#self.Tabs == 0)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 130, 0, 34)
        TabBtn.BackgroundColor3 = isFirst and Theme.TabActive or Theme.TabInactive
        TabBtn.BackgroundTransparency = isFirst and 0.1 or 1
        TabBtn.Text = name
        TabBtn.TextColor3 = isFirst and Theme.TabTextActive or Theme.Text
        TabBtn.TextSize = 14
        TabBtn.Font = self.CurrentFont
        TabBtn.AutoButtonColor = false
        TabBtn.ZIndex = 2
        TabBtn.Parent = TabContainer
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -35, 1, -30) 
        Page.Position = UDim2.new(0, 15, 0, 15)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Theme.Scrollbar
        Page.BorderSizePixel = 0
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Visible = isFirst
        Page.ZIndex = 2
        Page.Parent = PageContainer
        
        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingRight = UDim.new(0, 15) 
        PagePadding.Parent = Page

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        
        table.insert(self.Tabs, {Btn = TabBtn, Page = Page})

        TabBtn.MouseButton1Click:Connect(function()
            for _, tab in ipairs(self.Tabs) do
                if tab.Btn == TabBtn then
                    tab.Page.Visible = true
                    TweenService:Create(tab.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1, BackgroundColor3 = Theme.TabActive, TextColor3 = Theme.TabTextActive}):Play()
                else
                    tab.Page.Visible = false
                    TweenService:Create(tab.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1, BackgroundColor3 = Theme.TabInactive, TextColor3 = Theme.Text}):Play()
                end
            end
        end)

        local elementCounter = 0
        local function GetOrder()
            elementCounter = elementCounter + 1
            return elementCounter
        end

        local TabObj = {}
        
        function TabObj:AddSection(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.TextDim
            Label.TextSize = 13
            Label.Font = WindowObj.CurrentFont
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.LayoutOrder = GetOrder()
            Label.ZIndex = 2
            Label.Parent = Page
        end

        function TabObj:AddLabel(text)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.BackgroundColor3 = Theme.ElementBg
            Frame.BackgroundTransparency = Theme.ElementTransparency
            Frame.LayoutOrder = GetOrder()
            Frame.ZIndex = 2
            Frame.Parent = Page
            ApplyCornerAndStroke(Frame, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -30, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Text = text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 14
            Label.Font = WindowObj.CurrentFont
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 2
            Label.Parent = Frame
        end

        function TabObj:AddButton(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.BackgroundColor3 = Theme.ElementBg
            Btn.BackgroundTransparency = Theme.ElementTransparency
            Btn.Text = text
            Btn.TextColor3 = Theme.Text
            Btn.TextSize = 14
            Btn.Font = WindowObj.CurrentFont
            Btn.AutoButtonColor = false
            Btn.LayoutOrder = GetOrder()
            Btn.ZIndex = 2
            Btn.Parent = Page
            ApplyCornerAndStroke(Btn, 6)
            
            Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.TabHover}):Play() end)
            Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ElementBg}):Play() end)
            Btn.MouseButton1Click:Connect(callback)
            return Btn
        end

        function TabObj:AddToggle(text, default, callback)
            local State = default or false
            local Frame = Instance.new("TextButton")
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.BackgroundColor3 = Theme.ElementBg
            Frame.BackgroundTransparency = Theme.ElementTransparency
            Frame.Text = ""
            Frame.AutoButtonColor = false
            Frame.LayoutOrder = GetOrder()
            Frame.ZIndex = 2
            Frame.Parent = Page
            ApplyCornerAndStroke(Frame, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Text = text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 14
            Label.Font = WindowObj.CurrentFont
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 2
            Label.Parent = Frame

            local Checkmark = Instance.new("Frame")
            Checkmark.Size = UDim2.new(0, 20, 0, 20)
            Checkmark.Position = UDim2.new(1, -35, 0.5, -10)
            Checkmark.BackgroundColor3 = State and Theme.Accent or Theme.Background
            Checkmark.BorderSizePixel = 0
            Checkmark.ZIndex = 2
            Checkmark.Parent = Frame
            ApplyCornerAndStroke(Checkmark, 4)

            local function UpdateToggle()
                TweenService:Create(Checkmark, TweenInfo.new(0.2), {BackgroundColor3 = State and Theme.Accent or Theme.Background}):Play()
                callback(State)
            end

            Frame.MouseButton1Click:Connect(function()
                State = not State
                UpdateToggle()
            end)
            
            if default then callback(default) end
        end

        function TabObj:AddSlider(text, min, max, default, callback)
            local Value = default or min
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 50)
            Frame.BackgroundColor3 = Theme.ElementBg
            Frame.BackgroundTransparency = Theme.ElementTransparency
            Frame.LayoutOrder = GetOrder()
            Frame.ZIndex = 2
            Frame.Parent = Page
            ApplyCornerAndStroke(Frame, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -30, 0, 25)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Text = text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 14
            Label.Font = WindowObj.CurrentFont
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 2
            Label.Parent = Frame

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Size = UDim2.new(0, 50, 0, 25)
            ValLabel.Position = UDim2.new(1, -65, 0, 0)
            ValLabel.Text = tostring(Value)
            ValLabel.TextColor3 = Theme.TextDim
            ValLabel.TextSize = 14
            ValLabel.Font = WindowObj.CurrentFont
            ValLabel.BackgroundTransparency = 1
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.ZIndex = 2
            ValLabel.Parent = Frame

            local SliderBg = Instance.new("Frame")
            SliderBg.Size = UDim2.new(1, -30, 0, 6)
            SliderBg.Position = UDim2.new(0, 15, 0, 32)
            SliderBg.BackgroundColor3 = Theme.Background
            SliderBg.BorderSizePixel = 0
            SliderBg.ZIndex = 2
            SliderBg.Parent = Frame
            ApplyCornerAndStroke(SliderBg, 3)

            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new(math.clamp((Value - min) / (max - min), 0, 1), 0, 1, 0)
            SliderFill.BackgroundColor3 = Theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.ZIndex = 3
            SliderFill.Parent = SliderBg
            Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 3)
            
            local SliderDot = Instance.new("Frame")
            SliderDot.Size = UDim2.new(0, 12, 0, 12)
            SliderDot.AnchorPoint = Vector2.new(0.5, 0.5)
            SliderDot.Position = UDim2.new(1, 0, 0.5, 0)
            SliderDot.BackgroundColor3 = Theme.Accent
            SliderDot.BorderSizePixel = 0
            SliderDot.ZIndex = 4
            SliderDot.Parent = SliderFill
            Instance.new("UICorner", SliderDot).CornerRadius = UDim.new(1, 0)
            
            local DotStroke = Instance.new("UIStroke", SliderDot)
            DotStroke.Color = Theme.Stroke
            DotStroke.Thickness = 1
            DotStroke.Transparency = 0.5

            local Dragging = false
            local function Update(input)
                local scale = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                Value = math.floor(min + ((max - min) * scale))
                ValLabel.Text = tostring(Value)
                TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(scale, 0, 1, 0)}):Play()
                callback(Value)
            end

            SliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    Update(input)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
                    Update(input) 
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                    Dragging = false 
                end
            end)
        end

        function TabObj:AddTextBox(text, default, callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.BackgroundColor3 = Theme.ElementBg
            Frame.BackgroundTransparency = Theme.ElementTransparency
            Frame.LayoutOrder = GetOrder()
            Frame.ZIndex = 2
            Frame.Parent = Page
            ApplyCornerAndStroke(Frame, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -160, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Text = text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 14
            Label.Font = WindowObj.CurrentFont
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 2
            Label.Parent = Frame

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(0, 140, 0, 26)
            TextBox.Position = UDim2.new(1, -150, 0.5, -13)
            TextBox.BackgroundColor3 = Theme.Background
            TextBox.BackgroundTransparency = 0.2
            TextBox.Text = default or ""
            TextBox.TextColor3 = Theme.Text
            TextBox.TextSize = 14
            TextBox.Font = WindowObj.CurrentFont
            TextBox.ClearTextOnFocus = false
            TextBox.ZIndex = 2
            TextBox.Parent = Frame
            ApplyCornerAndStroke(TextBox, 4)

            TextBox.FocusLost:Connect(function()
                callback(TextBox.Text)
            end)
        end

        function TabObj:AddDropdown(text, options, default, callback)
            local Expanded = false
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.BackgroundColor3 = Theme.ElementBg
            Frame.BackgroundTransparency = Theme.ElementTransparency
            Frame.ClipsDescendants = true
            Frame.LayoutOrder = GetOrder()
            Frame.ZIndex = 2
            Frame.Parent = Page
            ApplyCornerAndStroke(Frame, 6)

            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(1, 0, 0, 36)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = ""
            DropBtn.ZIndex = 3
            DropBtn.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 0, 36)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Text = text .. " : " .. (default or "None")
            Label.TextColor3 = Theme.Text
            Label.TextSize = 14
            Label.Font = WindowObj.CurrentFont
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 2
            Label.Parent = Frame

            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 30, 0, 36)
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.Text = "▼"
            Arrow.TextColor3 = Theme.TextDim
            Arrow.TextSize = 12
            Arrow.Font = WindowObj.CurrentFont
            Arrow.BackgroundTransparency = 1
            Arrow.ZIndex = 2
            Arrow.Parent = Frame

            local ItemsContainer = Instance.new("Frame")
            ItemsContainer.BackgroundTransparency = 1
            ItemsContainer.Size = UDim2.new(1, 0, 1, -36)
            ItemsContainer.Position = UDim2.new(0, 0, 0, 36)
            ItemsContainer.Parent = Frame

            local ItemLayout = Instance.new("UIListLayout")
            ItemLayout.Parent = ItemsContainer
            ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local DropObj = {}
            function DropObj:Refresh(newOptions)
                for _, child in ipairs(ItemsContainer:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                
                for i, opt in ipairs(newOptions) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 30)
                    OptBtn.BackgroundColor3 = Theme.Background
                    OptBtn.BackgroundTransparency = 0.5
                    OptBtn.Text = opt
                    OptBtn.TextColor3 = Theme.TextDim
                    OptBtn.TextSize = 14
                    OptBtn.Font = WindowObj.CurrentFont
                    OptBtn.LayoutOrder = i
                    OptBtn.ZIndex = 3
                    OptBtn.Parent = ItemsContainer

                    OptBtn.MouseButton1Click:Connect(function()
                        Expanded = false
                        Arrow.Text = "▼"
                        Label.Text = text .. " : " .. opt
                        TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                        callback(opt)
                    end)
                end
                if Expanded then
                    Arrow.Text = "▲"
                    local totalHeight = 36 + (#ItemsContainer:GetChildren() - 1) * 30
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
                else
                    Arrow.Text = "▼"
                end
            end

            DropObj:Refresh(options)

            DropBtn.MouseButton1Click:Connect(function()
                Expanded = not Expanded
                Arrow.Text = Expanded and "▲" or "▼"
                local totalHeight = Expanded and (36 + (#ItemsContainer:GetChildren() - 1) * 30) or 36
                TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
            end)
            
            return DropObj
        end

        function TabObj:AddMultiDropdown(text, options, defaults, callback)
            local Expanded = false
            local Selected = {}
            if defaults then for _, v in ipairs(defaults) do Selected[v] = true end end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 36)
            Frame.BackgroundColor3 = Theme.ElementBg
            Frame.BackgroundTransparency = Theme.ElementTransparency
            Frame.ClipsDescendants = true
            Frame.LayoutOrder = GetOrder()
            Frame.ZIndex = 2
            Frame.Parent = Page
            ApplyCornerAndStroke(Frame, 6)

            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(1, 0, 0, 36)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = ""
            DropBtn.ZIndex = 3
            DropBtn.Parent = Frame

            local function GetSelectedStr()
                local str = ""
                for k, v in pairs(Selected) do if v then str = str .. k .. ", " end end
                if str == "" then return "None" end
                return string.sub(str, 1, -3)
            end

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 0, 36)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Text = text .. " : " .. GetSelectedStr()
            Label.TextColor3 = Theme.Text
            Label.TextSize = 14
            Label.Font = WindowObj.CurrentFont
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 2
            Label.Parent = Frame
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 30, 0, 36)
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.Text = "▼"
            Arrow.TextColor3 = Theme.TextDim
            Arrow.TextSize = 12
            Arrow.Font = WindowObj.CurrentFont
            Arrow.BackgroundTransparency = 1
            Arrow.ZIndex = 2
            Arrow.Parent = Frame

            local ItemsContainer = Instance.new("Frame")
            ItemsContainer.BackgroundTransparency = 1
            ItemsContainer.Size = UDim2.new(1, 0, 1, -36)
            ItemsContainer.Position = UDim2.new(0, 0, 0, 36)
            ItemsContainer.Parent = Frame

            local ItemLayout = Instance.new("UIListLayout")
            ItemLayout.Parent = ItemsContainer
            ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder

            for i, opt in ipairs(options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundColor3 = Theme.Background
                OptBtn.BackgroundTransparency = 0.5
                OptBtn.Text = opt
                OptBtn.TextColor3 = Selected[opt] and Theme.Accent or Theme.TextDim
                OptBtn.TextSize = 14
                OptBtn.Font = WindowObj.CurrentFont
                OptBtn.LayoutOrder = i
                OptBtn.ZIndex = 3
                OptBtn.Parent = ItemsContainer

                OptBtn.MouseButton1Click:Connect(function()
                    Selected[opt] = not Selected[opt]
                    OptBtn.TextColor3 = Selected[opt] and Theme.Accent or Theme.TextDim
                    Label.Text = text .. " : " .. GetSelectedStr()
                    
                    local ret = {}
                    for k, v in pairs(Selected) do if v then table.insert(ret, k) end end
                    callback(ret)
                end)
            end

            DropBtn.MouseButton1Click:Connect(function()
                Expanded = not Expanded
                Arrow.Text = Expanded and "▲" or "▼"
                local totalHeight = Expanded and (36 + (#ItemsContainer:GetChildren() - 1) * 30) or 36
                TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
            end)
        end

        function TabObj:AddKeybind(text, defaultKey, callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 40)
            Frame.BackgroundColor3 = Theme.ElementBg
            Frame.BackgroundTransparency = Theme.ElementTransparency
            Frame.LayoutOrder = GetOrder()
            Frame.ZIndex = 2
            Frame.Parent = Page
            ApplyCornerAndStroke(Frame, 6)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -120, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.Text = text
            Label.TextColor3 = Theme.Text
            Label.TextSize = 14
            Label.Font = WindowObj.CurrentFont
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 2
            Label.Parent = Frame

            local BindBtn = Instance.new("TextButton")
            BindBtn.Size = UDim2.new(0, 100, 0, 28)
            BindBtn.Position = UDim2.new(1, -110, 0.5, -14)
            BindBtn.BackgroundColor3 = Theme.Background
            BindBtn.BackgroundTransparency = 0.2
            BindBtn.Text = defaultKey.Name
            BindBtn.TextColor3 = Theme.Text
            BindBtn.TextSize = 14
            BindBtn.Font = WindowObj.CurrentFont
            BindBtn.AutoButtonColor = false
            BindBtn.ZIndex = 2
            BindBtn.Parent = Frame
            ApplyCornerAndStroke(BindBtn, 4)
            
            local binding = false
            BindBtn.MouseButton1Click:Connect(function()
                binding = true
                BindBtn.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    binding = false
                    BindBtn.Text = input.KeyCode.Name
                    callback(input.KeyCode)
                end
            end)

            local KbObj = {}
            function KbObj:UpdateKey(newKeyName)
                BindBtn.Text = newKeyName
            end
            return KbObj
        end

        return TabObj
    end

    return WindowObj
end

return CallbackHub
