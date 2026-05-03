Loadstring:
```lua
local CallbackHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/dURLEAK/callback-hub/refs/heads/main/source.lua"))()
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
MainTab:AddSection("Farm Settings")

-- Adds a standard text box with a background
MainTab:AddLabel("Make sure to equip a weapon first!")
```
AddTab:
```lua
local MainTab = Window:CreateTab("Main Settings")
```
AddButton:
```lua
MainTab:AddButton("Print Hello", function()
    print("Hello from Callback Hub!")
end)
```
AddToggle:
```lua
-- MainTab:AddToggle(Text, DefaultState, Callback)
MainTab:AddToggle("Auto Farm", false, function(state)
    if state then
        print("Auto Farm Enabled")
    else
        print("Auto Farm Disabled")
    end
end)
```
AddTextBox:
```lua
-- MainTab:AddTextBox(Text, DefaultText, Callback)
MainTab:AddTextBox("Target Player", "", function(text)
    print("User typed: " .. text)
end)
```
AddSlider:
```lua
-- MainTab:AddSlider(Text, Min, Max, Default, Callback)
PlayerTab:AddSlider("WalkSpeed", 16, 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```
AddDropdown:
```lua
-- MainTab:AddDropdown(Text, OptionsTable, DefaultSelected, Callback)
local FruitDropdown = MainTab:AddDropdown("Select Fruit", {"Apple", "Banana", "Orange"}, "Apple", function(selected)
    print("You selected: " .. selected)
end)

-- You can refresh/update the dropdown items later in your script:
FruitDropdown:Refresh({"Grapes", "Mango", "Pineapple"})
```
AddMultiDropdown:
```lua
-- MainTab:AddMultiDropdown(Text, OptionsTable, DefaultSelectedTable, Callback)
EspTab:AddMultiDropdown("ESP Options", {"Boxes", "Names", "Health", "Distance"}, {"Names", "Boxes"}, function(selectedList)
    print("Currently enabled ESP features:")
    for _, feature in ipairs(selectedList) do
        print("- " .. feature)
    end
end)
```
AddKeybinds:
```lua
-- MainTab:AddKeybind(Text, DefaultKey, Callback)
local DashBind = PlayerTab:AddKeybind("Dash Skill", Enum.KeyCode.Q, function(key)
    print("Dash key pressed! Key: " .. key.Name)
end)

-- If you want to force-update the text label of the bind via script:
DashBind:UpdateKey("F")
```
