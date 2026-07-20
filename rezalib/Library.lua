local BASE = "https://raw.githubusercontent.com/rezadevx/reza-gui/main/rezalib/"

local function fetch(path)
    return loadstring(game:HttpGet(BASE .. path))()
end

local Svc   = fetch("core/Services.lua")()
local Theme = fetch("core/Theme.lua")()
local U     = fetch("core/Utility.lua")(Svc, Theme)

local Library = {}
Library.__index      = Library
Library.Flags        = {}
Library.Connections  = {}
Library.Windows      = {}
Library.Theme        = Theme
Library._gui         = nil
Library._notifHolder = nil

function Library:_connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(self.Connections, c)
    return c
end

local function makeGui()
    pcall(function()
        local cg = game:GetService("CoreGui"):FindFirstChild("RezaLib")
        if cg then cg:Destroy() end
    end)
    pcall(function()
        local pg = Svc.LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            local old = pg:FindFirstChild("RezaLib")
            if old then old:Destroy() end
        end
    end)

    local gui = U.New("ScreenGui", {
        Name           = "RezaLib",
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 999,
        IgnoreGuiInset = true,
    })

    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
    elseif gethui then
        gui.Parent = gethui()
    else
        local ok = pcall(function()
            gui.Parent = game:GetService("CoreGui")
        end)
        if not ok then
            gui.Parent = Svc.LocalPlayer:WaitForChild("PlayerGui")
        end
    end

    return gui
end

function Library:_gui_root()
    if self._gui and self._gui.Parent then return self._gui end

    self._gui = makeGui()

    self._notifHolder = U.New("Frame", {
        Name                   = "Notifications",
        AnchorPoint            = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Position               = UDim2.new(1, -16, 1, -16),
        Size                   = UDim2.new(0, 304, 1, -32),
        ZIndex                 = 999,
        Parent                 = self._gui,
    })
    local layout = U.List(self._notifHolder, 8)
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom

    return self._gui
end

fetch("system/Notification.lua")(Library, Theme, U)
fetch("system/Config.lua")(Library)

local elemNames = {
    "Button", "Toggle", "Slider", "Dropdown",
    "TextBox", "ColorPicker", "Keybind",
    "Label", "Paragraph", "Divider",
}

local elemAttachers = {}
for _, name in ipairs(elemNames) do
    elemAttachers[#elemAttachers + 1] = fetch("elements/" .. name .. ".lua")(Library, Theme, U)
end

fetch("system/Window.lua")(Library, Svc, Theme, U, elemAttachers)

return Library
