Loadstring:
```lua
local CallbackHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/dURLEAK/callback-hub/refs/heads/main/source.luau"))()
```
Create Window:
```lua
local Window = CallbackHub:CreateWindow({
    Title = "Callback Hub",             -- The text displayed at the top of the UI
    Font = Enum.Font.SourceSans,        -- The font used globally
    ToggleKey = Enum.KeyCode.Insert     -- The key used to hide/show the menu
})
```
Notify:
```lua
Window:Notify("System Message", "The script has loaded successfully!", 5)
```
AddLabel:
```lua
-- Adds small, dimmed text (good for categorizing elements below it)
Tab:AddSection("Farm Settings")

-- Adds a standard text box with a background
Tab:AddLabel("Make sure to equip a weapon first!")
```
AddTab:
```lua
local Tab = Window:CreateTab("Main Settings")
```
AddButton:
```lua
Tab:AddButton("Print Hello", function()
    print("Hello from Callback Hub!")
end)
```
AddToggle:
```lua
Tab:AddToggle("Auto Farm", false, function(state)
    if state then
        print("Auto Farm Enabled")
    else
        print("Auto Farm Disabled")
    end
end)
```
AddTextBox:
```lua
Tab:AddTextBox("Target Player", "", function(text)
    print("User typed: " .. text)
end)
```
AddSlider:
```lua
Tab:AddSlider("WalkSpeed", 16, 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```
AddDropdown:
```lua
local FruitDropdown = Tab:AddDropdown("Select Fruit", {"Apple", "Banana", "Orange"}, "Apple", function(selected)
    print("You selected: " .. selected)
end)

-- You can refresh/update the dropdown items later in your script:
FruitDropdown:Refresh({"Grapes", "Mango", "Pineapple"})
```
AddMultiDropdown:
```lua
Tab:AddMultiDropdown("ESP Options", {"Boxes", "Names", "Health", "Distance"}, {"Names", "Boxes"}, function(selectedList)
    print("Currently enabled ESP features:")
    for _, feature in ipairs(selectedList) do
        print("- " .. feature)
    end
end)
```
AddKeybinds:
```lua
local DashBind = Tab:AddKeybind("Dash Skill", Enum.KeyCode.Q, function(key)
    print("Dash key pressed! Key: " .. key.Name)
end)

-- If you want to force-update the text label of the bind via script:
DashBind:UpdateKey("F")
```
AddConfig:
```lua
local CallbackHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/dURLEAK/callback-hub/refs/heads/main/source.luau"))()
local HttpService = game:GetService("HttpService")

local Config = {
    Flags = {},     -- Stores the actual settings values
    Elements = {},  -- Stores references to UI objects for syncing
    FileName = "SurvivalConfig.json"
}

local function SaveConfig()
    writefile(Config.FileName, HttpService:JSONEncode(Config.Flags))
    print("Config saved successfully.")
end

local function LoadConfig()
    if isfile(Config.FileName) then
        local success, content = pcall(readfile, Config.FileName)
        if success then
            local data = HttpService:JSONDecode(content)
            for flag, val in pairs(data) do
                Config.Flags[flag] = val
                -- Update UI visual state
                if Config.Elements[flag] and type(Config.Elements[flag].Set) == "function" then
                    pcall(function() Config.Elements[flag]:Set(val) end)
                end
            end
        end
    end
end

local Window = CallbackHub:CreateWindow({Title = "Survival Hub", ToggleKey = Enum.KeyCode.RightControl})
local MainTab = Window:CreateTab("Settings")

Config.Elements["Aimbot"] = MainTab:AddToggle("Aimbot Enabled", false, function(v)
    Config.Flags["Aimbot"] = v
end)

Config.Elements["FOV"] = MainTab:AddSlider("FOV Size", 10, 120, 50, function(v)
    Config.Flags["FOV"] = v
end)

Config.Elements["Mode"] = MainTab:AddDropdown("Farm Mode", {"Normal", "Fast"}, "Normal", function(v)
    Config.Flags["Mode"] = v
end)

MainTab:AddButton("Save Settings", SaveConfig)
MainTab:AddButton("Load Settings", LoadConfig)

LoadConfig()
