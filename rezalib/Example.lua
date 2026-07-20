--[[
    RezaLib — Usage Example
    ─────────────────────────────────────────────────────────────────────────
    Paste this into your executor script window to test the library.
    Replace the URL below with your actual raw GitHub URL.
]]

-- ── Load Library ──────────────────────────────────────────────────────────────
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rezadevx/rezadevx-premium/main/rezalib/Library.lua"
))()

-- ── Create Window ─────────────────────────────────────────────────────────────
local Window = Library:Window({
    Title    = "MyScript",
    SubTitle = "by rezadevx",
    KeyBind  = Enum.KeyCode.RightShift,   -- toggle UI visibility
})

-- ═══════════════════════════════════════════════════════════════════════════════
--  TAB 1 — Main
-- ═══════════════════════════════════════════════════════════════════════════════
local MainTab = Window:Tab({ Name = "Main" })

-- Section: Combat
local CombatSection = MainTab:Section({ Name = "Combat" })

local speedSlider = CombatSection:Slider({
    Name      = "Walk Speed",
    Description = "Adjust your character's walk speed",
    Minimum   = 16,
    Maximum   = 500,
    Default   = 16,
    Increment = 1,
    Suffix    = " WS",
    Flag      = "WalkSpeed",
    Callback  = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end,
})

local jumpSlider = CombatSection:Slider({
    Name      = "Jump Power",
    Minimum   = 0,
    Maximum   = 200,
    Default   = 50,
    Increment = 5,
    Suffix    = " JP",
    Flag      = "JumpPower",
    Callback  = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
        end
    end,
})

local godToggle = CombatSection:Toggle({
    Name        = "God Mode",
    Description = "Makes your character invincible",
    Default     = false,
    Flag        = "GodMode",
    Callback    = function(enabled)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.MaxHealth = enabled and math.huge or 100
            char.Humanoid.Health    = enabled and math.huge or 100
        end
    end,
})

CombatSection:Divider()

CombatSection:Button({
    Name        = "Reset Character",
    Description = "Respawn your character",
    Callback    = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
        Library:Notification({
            Title    = "Reset",
            Content  = "Character has been reset.",
            Type     = "Info",
            Duration = 3,
        })
    end,
})

-- Section: Info labels
local InfoSection = MainTab:Section({ Name = "Info" })

local pingLabel = InfoSection:Label({ Name = "Ping", Value = "..." })
local fpsLabel  = InfoSection:Label({ Name = "FPS",  Value = "..." })

-- Live update
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            pingLabel:SetValue(tostring(math.round(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())) .. " ms")
        end)
        pcall(function()
            fpsLabel:SetValue(tostring(math.round(1 / game:GetService("RunService").Heartbeat:Wait())) .. " fps")
        end)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
--  TAB 2 — Visual
-- ═══════════════════════════════════════════════════════════════════════════════
local VisualTab = Window:Tab({ Name = "Visual" })

local VisualSection = VisualTab:Section({ Name = "ESP & Visuals" })

local espToggle = VisualSection:Toggle({
    Name     = "Player ESP",
    Default  = false,
    Flag     = "PlayerESP",
    Callback = function(enabled)
        Library:Notification({
            Title    = "Player ESP",
            Content  = enabled and "ESP enabled." or "ESP disabled.",
            Type     = enabled and "Success" or "Info",
            Duration = 2,
        })
    end,
})

local colorPicker = VisualSection:ColorPicker({
    Name     = "ESP Color",
    Default  = Color3.fromRGB(255, 100, 100),
    Flag     = "ESPColor",
    Callback = function(color)
        -- apply color to your ESP boxes here
    end,
})

VisualSection:Dropdown({
    Name     = "ESP Style",
    Options  = { "Box", "Outline", "Chams", "Tracer" },
    Default  = "Box",
    Flag     = "ESPStyle",
    Callback = function(value)
        Library:Notification({
            Title   = "ESP Style",
            Content = "Set to: " .. value,
            Type    = "Info",
            Duration = 2,
        })
    end,
})

-- ═══════════════════════════════════════════════════════════════════════════════
--  TAB 3 — Misc
-- ═══════════════════════════════════════════════════════════════════════════════
local MiscTab = Window:Tab({ Name = "Misc" })

local MiscSection = MiscTab:Section({ Name = "Utilities" })

MiscSection:TextBox({
    Name        = "Custom Message",
    Description = "Send a chat message",
    Placeholder = "Type message...",
    Flag        = "ChatMsg",
    Callback    = function(text)
        game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            and game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All")
    end,
})

MiscSection:Keybind({
    Name     = "Noclip Toggle",
    Default  = Enum.KeyCode.N,
    Flag     = "NoclipKey",
    Callback = function()
        Library:Notification({
            Title   = "Noclip",
            Content = "Noclip toggled!",
            Type    = "Warning",
            Duration = 2,
        })
    end,
})

local ConfigSection = MiscTab:Section({ Name = "Config" })

ConfigSection:Button({
    Name     = "Save Config",
    Callback = function()
        Library:SaveConfig("myconfig")
    end,
})

ConfigSection:Button({
    Name     = "Load Config",
    Callback = function()
        Library:LoadConfig("myconfig")
    end,
})

ConfigSection:Paragraph({
    Name    = "About",
    Content = "RezaLib v1.0.0 — A professional Roblox GUI library.\nSupports: Synapse X, KRNL, Fluxus, Electron, Celery, Solara and more.\n\nGitHub: github.com/rezadevx/rezadevx-premium",
})

-- ── Startup notification ───────────────────────────────────────────────────────
Library:Notification({
    Title    = "RezaLib Loaded",
    Content  = "Script loaded successfully. Press RightShift to toggle UI.",
    Type     = "Success",
    Duration = 4,
})
