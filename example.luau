local url = "https://raw.githubusercontent.com/dURLEAK/callback-hub/main/source.luau?nocache=" .. tostring(tick())
local CallbackHub = loadstring(game:HttpGet(url))()
local HttpService = game:GetService("HttpService")

local Config = {
    Flags = {},
    Elements = {},
    Name = "config"
}

local function Save()
    writefile(Config.Name .. ".json", HttpService:JSONEncode(Config.Flags))
end

local function Load()
    local path = Config.Name .. ".json"
    if isfile(path) then
        local data = HttpService:JSONDecode(readfile(path))
        for i, v in pairs(data) do
            Config.Flags[i] = v
            if Config.Elements[i] then
                pcall(function() Config.Elements[i]:Set(v) end)
            end
        end
    end
end

local function Reg(id, def, cb)
    Config.Flags[id] = def
    return function(v)
        Config.Flags[id] = v
        if cb then cb(v) end
    end
end

local Window = CallbackHub:CreateWindow({
    Title = "Callback Hub",
    Font = Enum.Font.GothamMedium,
    ToggleKey = Enum.KeyCode.RightShift
})

local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
local MiscTab = Window:CreateTab("Misc")
local ConfigTab = Window:CreateTab("Config")

CombatTab:AddSection("Aimbot Settings")

Config.Elements["Aimbot"] = CombatTab:AddToggle("Enable Aimbot", false, Reg("Aimbot", false, function(state)
    print("Aimbot state: ", state)
end))

Config.Elements["Smoothness"] = CombatTab:AddSlider("Aimbot Smoothness", 1, 10, 5, Reg("Smoothness", 5, function(val)
    print("Smoothness: ", val)
end))

Config.Elements["HitPart"] = CombatTab:AddDropdown("Hit Part", {"Head", "Torso", "HumanoidRootPart"}, "Head", Reg("HitPart", "Head", function(part)
    print("Targeting: ", part)
end))

VisualsTab:AddSection("Player ESP")

Config.Elements["ESP"] = VisualsTab:AddMultiDropdown("ESP Features", {"Tracer", "Box", "Skeleton", "Name"}, {"Box"}, Reg("ESP", {"Box"}, function(selected)
    print("ESP Features Updated!")
end))

MiscTab:AddLabel("Press Right Shift to hide this menu.")

MiscTab:AddButton("Send Test Notification", function()
    Window:Notify("Hello!", "This is a custom notification.", 3)
end)

Config.Elements["WS"] = MiscTab:AddTextBox("WalkSpeed Override", "16", Reg("WS", "16", function(txt)
    print("Set walkspeed to: ", txt)
end))

Config.Elements["Panic"] = MiscTab:AddKeybind("Panic Button (Kill Game)", Enum.KeyCode.End, function(key)
    game.Players.LocalPlayer:Kick("Panic button pressed.")
end)

ConfigTab:AddSection("Configuration Manager")

ConfigTab:AddTextBox("File Name", "config", function(t)
    Config.Name = t
end)

ConfigTab:AddButton("Save Configuration", Save)
ConfigTab:AddButton("Load Configuration", Load)

Load()
