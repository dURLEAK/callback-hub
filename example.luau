local url = "https://raw.githubusercontent.com/dURLEAK/callback-hub/main/source.luau?nocache=" .. tostring(tick())
local CallbackHub = loadstring(game:HttpGet(url))()

local Window = CallbackHub:CreateWindow({
    Title = "My Epic Script",
    Font = Enum.Font.GothamMedium,
    ToggleKey = Enum.KeyCode.RightShift
})

local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
local MiscTab = Window:CreateTab("Misc")

CombatTab:AddSection("Aimbot Settings")

CombatTab:AddToggle("Enable Aimbot", false, function(state)
    print("Aimbot state: ", state)
end)

CombatTab:AddSlider("Aimbot Smoothness", 1, 10, 5, function(val)
    print("Smoothness: ", val)
end)

local HitboxDrop = CombatTab:AddDropdown("Hit Part", {"Head", "Torso", "HumanoidRootPart"}, "Head", function(part)
    print("Targeting: ", part)
end)

VisualsTab:AddSection("Player ESP")

VisualsTab:AddMultiDropdown("ESP Features", {"Tracer", "Box", "Skeleton", "Name"}, {"Box"}, function(selected)
    print("ESP Features Updated!")
end)

MiscTab:AddLabel("Press Right Shift to hide this menu.")

MiscTab:AddButton("Send Test Notification", function()
    Window:Notify("Hello!", "This is a custom notification.", 3)
end)

MiscTab:AddTextBox("WalkSpeed Override", "16", function(txt)
    print("Set walkspeed to: ", txt)
end)

MiscTab:AddKeybind("Panic Button (Kill Game)", Enum.KeyCode.End, function(key)
    game.Players.LocalPlayer:Kick("Panic button pressed.")
end)

Window:Notify("Loaded", "My Epic Script loaded successfully!", 4)
