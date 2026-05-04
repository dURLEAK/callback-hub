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
local HttpService = game:GetService("HttpService")

local ConfigManager = {
    Flags = {},       -- Where values are stored
    Elements = {},    -- Where UI references are stored
    FileName = "Survival.json"
}

function ConfigManager:Save()
    writefile(self.FileName, HttpService:JSONEncode(self.Flags))
    return true
end

function ConfigManager:Load()
    if isfile(self.FileName) then
        local success, content = pcall(readfile, self.FileName)
        if success then
            local data = HttpService:JSONDecode(content)
            for flag, value in pairs(data) do
                self.Flags[flag] = value
                -- Force sync the UI
                if self.Elements[flag] and type(self.Elements[flag].Set) == "function" then
                    pcall(function() self.Elements[flag]:Set(value) end)
                end
            end
            return true
        end
    end
    return false
end

-- Use this instead of manual variables. 
-- Call this function when you create an element.
function ConfigManager:Register(id, element, defaultValue, callback)
    self.Elements[id] = element
    self.Flags[id] = defaultValue
    
    -- Return a wrapped callback that updates flags automatically
    return function(val)
        self.Flags[id] = val
        if callback then callback(val) end
    end
end
