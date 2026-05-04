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

local ConfigManager = {
    Flags = {},
    Elements = {},
    FileName = "Default.json"
}

function ConfigManager:Save()
    writefile(self.FileName, HttpService:JSONEncode(self.Flags))
end

function ConfigManager:Load()
    if isfile(self.FileName) then
        local s, c = pcall(readfile, self.FileName)
        if s then
            local data = HttpService:JSONDecode(c)
            for f, v in pairs(data) do
                self.Flags[f] = v
                if self.Elements[f] and type(self.Elements[f].Set) == "function" then
                    pcall(function() self.Elements[f]:Set(v) end)
                end
            end
        end
    end
end

function ConfigManager:Register(id, def, cb)
    self.Flags[id] = def
    return function(v)
        self.Flags[id] = v
        if cb then cb(v) end
    end
end

local Window = CallbackHub:CreateWindow({
    Title = "Callback Hub",
    ToggleKey = Enum.KeyCode.RightControl
})

local MainTab = Window:CreateTab("Settings")

ConfigManager.Elements["AutoFarm"] = MainTab:AddToggle("Auto Farm", false, 
    ConfigManager:Register("AutoFarm", false, function(v)
        print("AutoFarm:", v)
    end)
)

ConfigManager.Elements["Speed"] = MainTab:AddSlider("Walk Speed", 16, 100, 16, 
    ConfigManager:Register("Speed", 16, function(v)
        print("Speed:", v)
    end)
)

ConfigManager.Elements["Mode"] = MainTab:AddDropdown("Farm Mode", {"Normal", "Fast", "Extreme"}, "Normal", 
    ConfigManager:Register("Mode", "Normal", function(v)
        print("Mode:", v)
    end)
)

ConfigManager.Elements["Target"] = MainTab:AddTextBox("Target Player", "None", 
    ConfigManager:Register("Target", "None", function(v)
        print("Target:", v)
    end)
)

MainTab:AddButton("Save Config", function() 
    ConfigManager:Save() 
end)

MainTab:AddButton("Load Config", function() 
    ConfigManager:Load() 
end)

ConfigManager:Load()
