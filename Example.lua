-- ─── Load Library ─────────────────────────────────────────────────────────────
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rezadevx/reza-gui/main/Library.lua"
))()

-- ─── Create Window ────────────────────────────────────────────────────────────
-- New fields: Logo, Badge, User, UserRole
local Window = Library:Window({
    Title    = "RezaDevX",      -- brand name shown in top navbar
    Logo     = "R",             -- single char inside logo circle
    Badge    = "Premium",       -- badge shown next to title
    User     = "RezaDevX",      -- username in top-right
    UserRole = "Premium User",  -- role label under username
    KeyBind  = Enum.KeyCode.RightShift,
})

-- ─── TAB: Dashboard ───────────────────────────────────────────────────────────
-- New field: Icon  (single char shown in sidebar nav item)
local DashTab = Window:Tab({ Name = "Dashboard", Icon = "⊟" })

local WelcomeSection = DashTab:Section({ Name = "" })
WelcomeSection:Label({ Name = "Welcome back,", Value = "RezaDevX" })
WelcomeSection:Paragraph({
    Name    = "Info",
    Content = "Manage your scripts, executors, and system tools in one place.",
})
WelcomeSection:Button({
    Name     = "Quick Actions",
    Callback = function()
        Library:Notification({
            Title    = "Quick Actions",
            Content  = "Launching quick actions panel...",
            Type     = "Info",
            Duration = 2,
        })
    end,
})

local StatsSection = DashTab:Section({ Name = "System Info" })
local pingLabel = StatsSection:Label({ Name = "Ping",  Value = "..." })
local fpsLabel  = StatsSection:Label({ Name = "FPS",   Value = "..." })
local memLabel  = StatsSection:Label({ Name = "Memory",Value = "..." })

-- Live stats update loop
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ping = math.round(
                game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            )
            pingLabel:SetValue(tostring(ping) .. " ms")
        end)
        pcall(function()
            local fps = math.round(1 / game:GetService("RunService").Heartbeat:Wait())
            fpsLabel:SetValue(tostring(fps) .. " fps")
        end)
        pcall(function()
            local mem = math.round(collectgarbage("count") / 1024 * 10) / 10
            memLabel:SetValue(tostring(mem) .. " MB")
        end)
    end
end)

-- ─── TAB: Scripts ─────────────────────────────────────────────────────────────
local ScriptsTab = Window:Tab({ Name = "Scripts", Icon = "{}" })

local ScriptSection = ScriptsTab:Section({ Name = "Combat" })

ScriptSection:Slider({
    Name        = "Walk Speed",
    Description = "Adjust your walk speed",
    Minimum     = 16,
    Maximum     = 500,
    Default     = 16,
    Increment   = 1,
    Suffix      = " WS",
    Flag        = "WalkSpeed",
    Callback    = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end,
})

ScriptSection:Slider({
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

ScriptSection:Toggle({
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

ScriptSection:Divider()

ScriptSection:Button({
    Name        = "Reset Character",
    Description = "Respawn your character",
    Callback    = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
        Library:Notification({ Title = "Reset", Content = "Character reset.", Type = "Info", Duration = 2 })
    end,
})

-- ─── TAB: Executors ───────────────────────────────────────────────────────────
local ExecTab = Window:Tab({ Name = "Executors", Icon = "▶" })

local ExecSection = ExecTab:Section({ Name = "Executor Settings" })
ExecSection:Toggle({
    Name    = "Auto Execute",
    Default = false,
    Flag    = "AutoExec",
    Callback = function(v)
        Library:Notification({
            Title    = "Auto Execute",
            Content  = v and "Enabled." or "Disabled.",
            Type     = v and "Success" or "Info",
            Duration = 2,
        })
    end,
})
ExecSection:Dropdown({
    Name    = "Executor",
    Options = { "Synapse X", "KRNL", "Fluxus", "Celery", "Solara" },
    Default = "Synapse X",
    Flag    = "ExecutorChoice",
    Callback = function(val)
        Library:Notification({ Title = "Executor", Content = "Selected: " .. val, Type = "Info", Duration = 2 })
    end,
})

-- ─── TAB: Cloud ───────────────────────────────────────────────────────────────
local CloudTab = Window:Tab({ Name = "Cloud", Icon = "◉" })

local CloudSection = CloudTab:Section({ Name = "Cloud Sync" })
CloudSection:Toggle({
    Name    = "Auto Backup",
    Default = false,
    Flag    = "AutoBackup",
    Callback = function(v)
        Library:Notification({
            Title   = "Cloud Backup",
            Content = v and "Backup enabled." or "Backup disabled.",
            Type    = "Info", Duration = 2,
        })
    end,
})
CloudSection:Button({
    Name     = "Sync Now",
    Callback = function()
        Library:Notification({ Title = "Cloud", Content = "Syncing...", Type = "Success", Duration = 2 })
    end,
})

-- ─── TAB: Settings ────────────────────────────────────────────────────────────
local SettingsTab = Window:Tab({ Name = "Settings", Icon = "⚙" })

local ConfigSection = SettingsTab:Section({ Name = "Config" })
ConfigSection:Button({
    Name     = "Save Config",
    Callback = function() Library:SaveConfig("rezadevx") end,
})
ConfigSection:Button({
    Name     = "Load Config",
    Callback = function() Library:LoadConfig("rezadevx") end,
})

local UISection = SettingsTab:Section({ Name = "UI Library" })
UISection:Paragraph({
    Name    = "About RezaLib",
    Content = "RezaLib v2.0.0\nA professional Roblox GUI library.\nSupports: Synapse X, KRNL, Fluxus, Electron, Celery, Solara.\n\nGitHub: github.com/rezadevx/reza-gui",
})
UISection:Keybind({
    Name    = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Flag    = "ToggleKey",
    Callback = function()
        Library:Notification({ Title = "Keybind", Content = "UI toggled!", Type = "Info", Duration = 1 })
    end,
})

-- ─── TAB: Visual ──────────────────────────────────────────────────────────────
local VisualTab = Window:Tab({ Name = "Visual", Icon = "▣" })

local ESPSection = VisualTab:Section({ Name = "ESP & Visuals" })
ESPSection:Toggle({
    Name    = "Player ESP",
    Default = false,
    Flag    = "PlayerESP",
    Callback = function(enabled)
        Library:Notification({
            Title   = "Player ESP",
            Content = enabled and "ESP enabled." or "ESP disabled.",
            Type    = enabled and "Success" or "Info",
            Duration = 2,
        })
    end,
})
ESPSection:ColorPicker({
    Name     = "ESP Color",
    Default  = Color3.fromRGB(108, 132, 255),
    Flag     = "ESPColor",
    Callback = function(_color) end,
})
ESPSection:Dropdown({
    Name     = "ESP Style",
    Options  = { "Box", "Outline", "Chams", "Tracer" },
    Default  = "Box",
    Flag     = "ESPStyle",
    Callback = function(val)
        Library:Notification({ Title = "ESP Style", Content = "Set to: " .. val, Type = "Info", Duration = 2 })
    end,
})

-- ─── TAB: Misc ────────────────────────────────────────────────────────────────
local MiscTab = Window:Tab({ Name = "Misc", Icon = "≡" })

local MiscSection = MiscTab:Section({ Name = "Utilities" })
MiscSection:TextBox({
    Name        = "Custom Message",
    Description = "Send a chat message",
    Placeholder = "Type message...",
    Flag        = "ChatMsg",
    Callback    = function(text)
        local rs = game:GetService("ReplicatedStorage")
        local ev = rs:FindFirstChild("DefaultChatSystemChatEvents")
        if ev then
            pcall(function()
                ev.SayMessageRequest:FireServer(text, "All")
            end)
        end
    end,
})
MiscSection:Keybind({
    Name     = "Noclip Toggle",
    Default  = Enum.KeyCode.N,
    Flag     = "NoclipKey",
    Callback = function()
        Library:Notification({ Title = "Noclip", Content = "Noclip toggled!", Type = "Warning", Duration = 2 })
    end,
})

-- ─── Startup Notification ─────────────────────────────────────────────────────
Library:Notification({
    Title    = "RezaDevX Loaded",
    Content  = "Script loaded successfully. Press RightShift to toggle UI.",
    Type     = "Success",
    Duration = 4,
})
