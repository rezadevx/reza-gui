--[[
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ██████╗ ███████╗███████╗ █████╗ ██╗     ██╗██████╗                        ║
║   ██╔══██╗██╔════╝╚══███╔╝██╔══██╗██║     ██║██╔══██╗                       ║
║   ██████╔╝█████╗    ███╔╝ ███████║██║     ██║██████╔╝                       ║
║   ██╔══██╗██╔══╝   ███╔╝  ██╔══██║██║     ██║██╔══██╗                       ║
║   ██║  ██║███████╗███████╗██║  ██║███████╗██║██████╔╝                       ║
║   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝╚═════╝                        ║
║                                                                              ║
║   Version     : 1.0.0                                                        ║
║   Compatible  : Synapse X · KRNL · Fluxus · Electron · Celery · Solara     ║
║   Platform    : Roblox Executor                                              ║
║                                                                              ║
║   Entry Point :                                                              ║
║     local Library = loadstring(game:HttpGet("RAW_GITHUB_URL"))()            ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
]]

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │  SERVICES                                                                │
-- └──────────────────────────────────────────────────────────────────────────┘
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local Debris           = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │  THEME                                                                   │
-- └──────────────────────────────────────────────────────────────────────────┘
local Theme = {
    -- Core surfaces
    BG           = Color3.fromRGB( 11,  11,  19),
    Window       = Color3.fromRGB( 17,  17,  29),
    Surface      = Color3.fromRGB( 22,  22,  37),
    SurfaceHover = Color3.fromRGB( 28,  28,  46),
    SurfaceAlt   = Color3.fromRGB( 33,  33,  54),
    Sidebar      = Color3.fromRGB( 13,  13,  22),

    -- Accent
    Accent       = Color3.fromRGB(108, 132, 255),
    AccentDark   = Color3.fromRGB( 72,  92, 210),
    AccentLight  = Color3.fromRGB(148, 168, 255),

    -- Text
    TextPrimary  = Color3.fromRGB(235, 235, 252),
    TextSecond   = Color3.fromRGB(138, 138, 175),
    TextDim      = Color3.fromRGB( 80,  80, 115),
    TextAccent   = Color3.fromRGB(148, 168, 255),

    -- Borders
    Border       = Color3.fromRGB( 35,  35,  58),
    BorderHover  = Color3.fromRGB( 55,  55,  88),

    -- State
    Success      = Color3.fromRGB( 72, 199, 116),
    Warning      = Color3.fromRGB(255, 184,  50),
    Error        = Color3.fromRGB(255,  72,  72),
    Info         = Color3.fromRGB(108, 132, 255),

    -- Toggle
    ToggleOn     = Color3.fromRGB( 72, 199, 116),
    ToggleOff    = Color3.fromRGB( 44,  44,  70),
    ToggleKnob   = Color3.fromRGB(255, 255, 255),

    -- Slider
    SliderTrack  = Color3.fromRGB( 32,  32,  52),
    SliderFill   = Color3.fromRGB(108, 132, 255),

    -- Input
    InputBG      = Color3.fromRGB( 14,  14,  24),
    Placeholder  = Color3.fromRGB( 80,  80, 115),

    -- Scrollbar
    Scrollbar    = Color3.fromRGB( 50,  50,  80),
}

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │  UTILITY                                                                 │
-- └──────────────────────────────────────────────────────────────────────────┘
local U = {}

local function ti(d, s, dir)
    return TweenInfo.new(
        d   or 0.18,
        s   or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out
    )
end

function U.Tween(obj, props, dur, style, dir)
    local t = TweenService:Create(obj, ti(dur, style, dir), props)
    t:Play()
    return t
end

function U.New(class, props, children)
    local inst = Instance.new(class)
    for k, v in next, props or {} do
        if k ~= "Parent" then inst[k] = v end
    end
    for _, child in next, children or {} do
        child.Parent = inst
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

function U.Corner(parent, radius)
    return U.New("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent       = parent,
    })
end

function U.Stroke(parent, color, thickness)
    return U.New("UIStroke", {
        Color            = color     or Theme.Border,
        Thickness        = thickness or 1,
        ApplyStrokeMode  = Enum.ApplyStrokeMode.Border,
        Parent           = parent,
    })
end

function U.Padding(parent, top, right, bottom, left)
    return U.New("UIPadding", {
        PaddingTop    = UDim.new(0, top    or 8),
        PaddingRight  = UDim.new(0, right  or 8),
        PaddingBottom = UDim.new(0, bottom or 8),
        PaddingLeft   = UDim.new(0, left   or 8),
        Parent        = parent,
    })
end

function U.List(parent, spacing, direction, halign, valign)
    return U.New("UIListLayout", {
        Padding             = UDim.new(0, spacing or 4),
        FillDirection       = direction or Enum.FillDirection.Vertical,
        HorizontalAlignment = halign    or Enum.HorizontalAlignment.Left,
        VerticalAlignment   = valign    or Enum.VerticalAlignment.Top,
        SortOrder           = Enum.SortOrder.LayoutOrder,
        Parent              = parent,
    })
end

function U.Shadow(parent, spread, transparency)
    return U.New("ImageLabel", {
        Name                 = "_Shadow",
        AnchorPoint          = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position             = UDim2.new(0.5, 0, 0.5, 6),
        Size                 = UDim2.new(1, spread or 36, 1, spread or 36),
        ZIndex               = math.max(1, (parent.ZIndex or 1) - 1),
        Image                = "rbxassetid://6015897843",
        ImageColor3          = Color3.fromRGB(0, 0, 0),
        ImageTransparency    = transparency or 0.5,
        ScaleType            = Enum.ScaleType.Slice,
        SliceCenter          = Rect.new(49, 49, 450, 450),
        Parent               = parent.Parent,
    })
end

function U.Ripple(btn, mx, my)
    local ox = mx - btn.AbsolutePosition.X
    local oy = my - btn.AbsolutePosition.Y
    local sz = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.4
    local r  = U.New("Frame", {
        BackgroundColor3       = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.80,
        Position               = UDim2.new(0, ox - 4, 0, oy - 4),
        Size                   = UDim2.new(0, 8, 0, 8),
        ZIndex                 = (btn.ZIndex or 1) + 20,
        ClipsDescendants       = false,
        Parent                 = btn,
    })
    U.Corner(r, 999)
    U.Tween(r, {
        Size                   = UDim2.new(0, sz, 0, sz),
        Position               = UDim2.new(0.5, -sz / 2, 0.5, -sz / 2),
        BackgroundTransparency = 1,
    }, 0.55, Enum.EasingStyle.Quart)
    Debris:AddItem(r, 0.65)
end

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │  SCREEN GUI                                                              │
-- └──────────────────────────────────────────────────────────────────────────┘
local function makeGui()
    -- Clean up previous instances
    pcall(function()
        local cg = game:GetService("CoreGui"):FindFirstChild("RezaLib")
        if cg then cg:Destroy() end
    end)
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
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

    -- Executor-aware parent selection
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
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end

    return gui
end

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │  LIBRARY                                                                 │
-- └──────────────────────────────────────────────────────────────────────────┘
local Library = {}
Library.__index = Library

Library.Flags       = {}   -- all element values, keyed by Flag
Library.Connections = {}   -- cleanup list
Library.Windows     = {}
Library.Theme       = Theme
Library._gui        = nil
Library._notifHolder= nil

function Library:_connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(self.Connections, c)
    return c
end

function Library:_gui_root()
    if self._gui and self._gui.Parent then return self._gui end

    self._gui = makeGui()

    -- Notification stack (bottom-right)
    self._notifHolder = U.New("Frame", {
        Name                 = "Notifications",
        AnchorPoint          = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Position             = UDim2.new(1, -16, 1, -16),
        Size                 = UDim2.new(0, 304, 1, -32),
        ZIndex               = 999,
        Parent               = self._gui,
    })
    local layout = U.List(self._notifHolder, 8)
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom

    return self._gui
end

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │  NOTIFICATIONS                                                           │
-- └──────────────────────────────────────────────────────────────────────────┘
local NOTIF_ICON  = { Success = "✓", Warning = "⚠", Error = "✕", Info = "ℹ" }
local NOTIF_COLOR = {
    Success = Theme.Success,
    Warning = Theme.Warning,
    Error   = Theme.Error,
    Info    = Theme.Accent,
}

function Library:Notification(cfg)
    cfg = cfg or {}
    local title    = cfg.Title    or "Notification"
    local content  = cfg.Content  or ""
    local duration = cfg.Duration or 3
    local ntype    = cfg.Type     or "Info"

    self:_gui_root()

    local accent = NOTIF_COLOR[ntype] or Theme.Accent
    local icon   = NOTIF_ICON[ntype]  or "ℹ"
    local holder = self._notifHolder

    -- Card
    local card = U.New("Frame", {
        Name                 = "Notif",
        BackgroundColor3     = Theme.Surface,
        BackgroundTransparency = 1,
        AutomaticSize        = Enum.AutomaticSize.Y,
        Size                 = UDim2.new(1, 0, 0, 0),
        ClipsDescendants     = true,
        ZIndex               = 999,
        Parent               = holder,
    })
    U.Corner(card, 8)
    U.Stroke(card, Theme.Border, 1)

    -- Accent left bar
    U.New("Frame", {
        BackgroundColor3 = accent,
        Size             = UDim2.new(0, 3, 1, 0),
        ZIndex           = 1000,
        Parent           = card,
    })

    -- Inner content
    local inner = U.New("Frame", {
        BackgroundTransparency = 1,
        Position              = UDim2.new(0, 14, 0, 0),
        Size                  = UDim2.new(1, -14, 0, 0),
        AutomaticSize         = Enum.AutomaticSize.Y,
        ZIndex                = 1000,
        Parent                = card,
    })
    U.List(inner, 3)
    U.Padding(inner, 10, 10, 10, 6)

    -- Header row
    local hdr = U.New("Frame", {
        BackgroundTransparency = 1,
        Size                  = UDim2.new(1, 0, 0, 18),
        ZIndex                = 1001,
        Parent                = inner,
    })
    U.New("TextLabel", {
        BackgroundTransparency = 1,
        Size           = UDim2.new(0, 18, 1, 0),
        Text           = icon,
        Font           = Enum.Font.GothamBold,
        TextSize       = 13,
        TextColor3     = accent,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex         = 1002,
        Parent         = hdr,
    })
    U.New("TextLabel", {
        BackgroundTransparency = 1,
        Position       = UDim2.new(0, 22, 0, 0),
        Size           = UDim2.new(1, -22, 1, 0),
        Text           = title,
        Font           = Enum.Font.GothamBold,
        TextSize       = 13,
        TextColor3     = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex         = 1002,
        Parent         = hdr,
    })

    if content ~= "" then
        U.New("TextLabel", {
            BackgroundTransparency = 1,
            Size           = UDim2.new(1, 0, 0, 0),
            AutomaticSize  = Enum.AutomaticSize.Y,
            Text           = content,
            Font           = Enum.Font.Gotham,
            TextSize       = 12,
            TextColor3     = Theme.TextSecond,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped    = true,
            ZIndex         = 1002,
            Parent         = inner,
        })
    end

    -- Timer progress bar
    local progBG = U.New("Frame", {
        BackgroundColor3 = Theme.SurfaceAlt,
        Size             = UDim2.new(1, 0, 0, 2),
        ZIndex           = 1002,
        Parent           = inner,
    })
    local prog = U.New("Frame", {
        BackgroundColor3 = accent,
        Size             = UDim2.new(1, 0, 1, 0),
        ZIndex           = 1003,
        Parent           = progBG,
    })

    U.Tween(card, { BackgroundTransparency = 0 }, 0.22)
    U.Tween(prog, { Size = UDim2.new(0, 0, 1, 0) }, duration, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        U.Tween(card, { BackgroundTransparency = 1 }, 0.22)
        task.wait(0.25)
        pcall(function() card:Destroy() end)
    end)

    return card
end

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │  WINDOW                                                                  │
-- └──────────────────────────────────────────────────────────────────────────┘
local WIN_W     = 564
local WIN_H     = 386
local SIDEBAR_W = 150

function Library:Window(cfg)
    cfg = cfg or {}
    local title     = cfg.Title    or "RezaLib"
    local subtitle  = cfg.SubTitle or ""
    local toggleKey = cfg.KeyBind  or Enum.KeyCode.RightShift

    local gui = self:_gui_root()

    -- ── Root ────────────────────────────────────────────────────────────────
    local root = U.New("Frame", {
        Name             = "Window",
        AnchorPoint      = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Window,
        BorderSizePixel  = 0,
        Position         = UDim2.new(0.5, 0, 0.5, 0),
        Size             = UDim2.new(0, WIN_W, 0, WIN_H),
        ClipsDescendants = true,
        ZIndex           = 10,
        Parent           = gui,
    })
    U.Corner(root, 10)
    U.Stroke(root, Theme.Border, 1)
    U.Shadow(root, 44, 0.44)

    U.New("UIGradient", {
        Color    = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 36)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 24)),
        }),
        Rotation = 125,
        Parent   = root,
    })

    -- ── Sidebar ─────────────────────────────────────────────────────────────
    local sidebar = U.New("Frame", {
        Name             = "Sidebar",
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, SIDEBAR_W, 1, 0),
        ZIndex           = 11,
        Parent           = root,
    })

    -- Right border line
    U.New("Frame", {
        BackgroundColor3 = Theme.Border,
        BorderSizePixel  = 0,
        Position         = UDim2.new(1, -1, 0, 0),
        Size             = UDim2.new(0, 1, 1, 0),
        ZIndex           = 12,
        Parent           = sidebar,
    })

    -- Sidebar header (also drag handle)
    local sideHeader = U.New("Frame", {
        Name             = "Header",
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, 0, 0, 68),
        ZIndex           = 12,
        Parent           = sidebar,
    })

    U.New("TextLabel", {
        BackgroundTransparency = 1,
        Position       = UDim2.new(0, 14, 0, 14),
        Size           = UDim2.new(1, -14, 0, 22),
        Text           = title,
        Font           = Enum.Font.GothamBold,
        TextSize       = 15,
        TextColor3     = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex         = 13,
        Parent         = sideHeader,
    })

    if subtitle ~= "" then
        U.New("TextLabel", {
            BackgroundTransparency = 1,
            Position       = UDim2.new(0, 14, 0, 37),
            Size           = UDim2.new(1, -14, 0, 14),
            Text           = subtitle,
            Font           = Enum.Font.Gotham,
            TextSize       = 11,
            TextColor3     = Theme.TextDim,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex         = 13,
            Parent         = sideHeader,
        })
    end

    -- Header divider
    U.New("Frame", {
        BackgroundColor3 = Theme.Border,
        BorderSizePixel  = 0,
        Position         = UDim2.new(0, 12, 0, 67),
        Size             = UDim2.new(1, -24, 0, 1),
        ZIndex           = 12,
        Parent           = sidebar,
    })

    -- Tab button list
    local tabList = U.New("ScrollingFrame", {
        Name                     = "TabList",
        BackgroundTransparency   = 1,
        BorderSizePixel          = 0,
        Position                 = UDim2.new(0, 0, 0, 76),
        Size                     = UDim2.new(1, 0, 1, -92),
        ScrollBarThickness       = 2,
        ScrollBarImageColor3     = Theme.Scrollbar,
        CanvasSize               = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize      = Enum.AutomaticSize.Y,
        ScrollingDirection       = Enum.ScrollingDirection.Y,
        ZIndex                   = 12,
        Parent                   = sidebar,
    })
    U.List(tabList, 2)
    U.Padding(tabList, 4, 8, 4, 8)

    -- ── Content area ────────────────────────────────────────────────────────
    local contentArea = U.New("Frame", {
        Name                 = "Content",
        BackgroundTransparency = 1,
        Position             = UDim2.new(0, SIDEBAR_W, 0, 0),
        Size                 = UDim2.new(1, -SIDEBAR_W, 1, 0),
        ZIndex               = 11,
        Parent               = root,
    })

    -- Close button (top-right)
    local btnClose = U.New("TextButton", {
        AnchorPoint          = Vector2.new(1, 0),
        BackgroundColor3     = Color3.fromRGB(255, 72, 72),
        BackgroundTransparency = 0.25,
        Position             = UDim2.new(1, -10, 0, 10),
        Size                 = UDim2.new(0, 14, 0, 14),
        Text                 = "",
        ZIndex               = 20,
        Parent               = contentArea,
    })
    U.Corner(btnClose, 999)

    -- Minimize button
    local btnMin = U.New("TextButton", {
        AnchorPoint          = Vector2.new(1, 0),
        BackgroundColor3     = Color3.fromRGB(255, 196, 0),
        BackgroundTransparency = 0.25,
        Position             = UDim2.new(1, -30, 0, 10),
        Size                 = UDim2.new(0, 14, 0, 14),
        Text                 = "",
        ZIndex               = 20,
        Parent               = contentArea,
    })
    U.Corner(btnMin, 999)

    -- Pages container (clips for tab switching)
    local pages = U.New("Frame", {
        Name                 = "Pages",
        BackgroundTransparency = 1,
        Size                 = UDim2.new(1, 0, 1, 0),
        ClipsDescendants     = true,
        ZIndex               = 12,
        Parent               = contentArea,
    })

    -- ── Dragging ─────────────────────────────────────────────────────────────
    local dragging, dragStart, startPos = false, nil, nil

    self:_connect(sideHeader.InputBegan, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = inp.Position
            startPos  = root.Position
        end
    end)
    self:_connect(UserInputService.InputChanged, function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = inp.Position - dragStart
            root.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
    self:_connect(UserInputService.InputEnded, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- ── Toggle key ───────────────────────────────────────────────────────────
    local uiVisible = true
    self:_connect(UserInputService.InputBegan, function(inp, processed)
        if processed then return end
        if inp.KeyCode == toggleKey then
            uiVisible = not uiVisible
            U.Tween(root, {
                Size = uiVisible
                    and UDim2.new(0, WIN_W, 0, WIN_H)
                    or  UDim2.new(0, WIN_W, 0, 0),
                BackgroundTransparency = uiVisible and 0 or 1,
            }, 0.24)
        end
    end)

    -- ── Close / Minimize ─────────────────────────────────────────────────────
    btnClose.MouseButton1Click:Connect(function()
        U.Tween(root, { Size = UDim2.new(0, WIN_W, 0, 0), BackgroundTransparency = 1 }, 0.2)
        task.wait(0.25)
        pcall(function() root:Destroy() end)
    end)

    local minimized = false
    btnMin.MouseButton1Click:Connect(function()
        minimized = not minimized
        U.Tween(root, {
            Size = minimized
                and UDim2.new(0, WIN_W, 0, 38)
                or  UDim2.new(0, WIN_W, 0, WIN_H),
        }, 0.22)
    end)

    -- Button hover glow
    for _, b in ipairs({ btnClose, btnMin }) do
        b.MouseEnter:Connect(function()
            U.Tween(b, { BackgroundTransparency = 0 }, 0.12)
        end)
        b.MouseLeave:Connect(function()
            U.Tween(b, { BackgroundTransparency = 0.25 }, 0.12)
        end)
    end

    -- ── Window object ────────────────────────────────────────────────────────
    local Win      = {}
    Win._tabs      = {}
    Win._activeTab = nil
    Win._root      = root

    -- ┌──────────────────────────────────────────────────────────────────────┐
    -- │  TAB                                                                 │
    -- └──────────────────────────────────────────────────────────────────────┘
    function Win:Tab(tcfg)
        tcfg = tcfg or {}
        local name = tcfg.Name or ("Tab " .. #self._tabs + 1)

        -- Sidebar button
        local btn = U.New("TextButton", {
            Name                 = name,
            BackgroundColor3     = Theme.Surface,
            BackgroundTransparency = 0,
            Size                 = UDim2.new(1, 0, 0, 34),
            Text                 = "",
            ZIndex               = 14,
            Parent               = tabList,
        })
        U.Corner(btn, 7)

        -- Active left indicator
        local indicator = U.New("Frame", {
            BackgroundColor3     = Theme.Accent,
            BorderSizePixel      = 0,
            Position             = UDim2.new(0, 0, 0.15, 0),
            Size                 = UDim2.new(0, 3, 0.7, 0),
            BackgroundTransparency = 1,
            ZIndex               = 15,
            Parent               = btn,
        })
        U.Corner(indicator, 3)

        local btnLabel = U.New("TextLabel", {
            BackgroundTransparency = 1,
            Position       = UDim2.new(0, 14, 0, 0),
            Size           = UDim2.new(1, -14, 1, 0),
            Text           = name,
            Font           = Enum.Font.Gotham,
            TextSize       = 13,
            TextColor3     = Theme.TextSecond,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex         = 15,
            Parent         = btn,
        })

        -- Page (scrollable)
        local page = U.New("ScrollingFrame", {
            Name                   = name .. "_Page",
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Position               = UDim2.new(0, 0, 0, 0),
            Size                   = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness     = 2,
            ScrollBarImageColor3   = Theme.Scrollbar,
            CanvasSize             = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize    = Enum.AutomaticSize.Y,
            ScrollingDirection     = Enum.ScrollingDirection.Y,
            Visible                = false,
            ZIndex                 = 13,
            Parent                 = pages,
        })
        U.List(page, 6)
        U.Padding(page, 14, 14, 14, 14)

        local tabObj = {
            _btn       = btn,
            _page      = page,
            _indicator = indicator,
            _label     = btnLabel,
        }

        local function activate()
            for _, t in ipairs(Win._tabs) do
                t._page.Visible = false
                U.Tween(t._btn,       { BackgroundColor3 = Theme.Surface },      0.15)
                U.Tween(t._label,     { TextColor3       = Theme.TextSecond },   0.15)
                U.Tween(t._indicator, { BackgroundTransparency = 1 },            0.15)
                t._label.Font = Enum.Font.Gotham
            end
            page.Visible = true
            U.Tween(btn,       { BackgroundColor3 = Theme.SurfaceAlt  }, 0.15)
            U.Tween(btnLabel,  { TextColor3       = Theme.TextPrimary }, 0.15)
            U.Tween(indicator, { BackgroundTransparency = 0 },           0.15)
            btnLabel.Font  = Enum.Font.GothamBold
            Win._activeTab = tabObj
        end

        btn.MouseButton1Click:Connect(activate)

        btn.MouseEnter:Connect(function()
            if Win._activeTab ~= tabObj then
                U.Tween(btn, { BackgroundColor3 = Theme.SurfaceHover }, 0.1)
            end
        end)
        btn.MouseLeave:Connect(function()
            if Win._activeTab ~= tabObj then
                U.Tween(btn, { BackgroundColor3 = Theme.Surface }, 0.1)
            end
        end)

        table.insert(Win._tabs, tabObj)
        if #Win._tabs == 1 then activate() end

        -- ┌────────────────────────────────────────────────────────────────────┐
        -- │  SECTION                                                           │
        -- └────────────────────────────────────────────────────────────────────┘
        function tabObj:Section(scfg)
            scfg = scfg or {}
            local sname = scfg.Name or ""

            local container = U.New("Frame", {
                Name             = "Section_" .. sname,
                BackgroundColor3 = Theme.Surface,
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                ZIndex           = 14,
                Parent           = page,
            })
            U.Corner(container, 8)
            U.Stroke(container, Theme.Border, 1)

            local hasHeader = sname ~= ""

            if hasHeader then
                local hdr = U.New("Frame", {
                    BackgroundTransparency = 1,
                    Size   = UDim2.new(1, 0, 0, 38),
                    ZIndex = 15,
                    Parent = container,
                })
                -- Accent dot
                U.New("Frame", {
                    BackgroundColor3 = Theme.Accent,
                    Position         = UDim2.new(0, 14, 0.5, -4),
                    Size             = UDim2.new(0, 4, 0, 8),
                    ZIndex           = 16,
                    Parent           = hdr,
                })
                U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position       = UDim2.new(0, 24, 0, 0),
                    Size           = UDim2.new(1, -24, 1, 0),
                    Text           = sname,
                    Font           = Enum.Font.GothamBold,
                    TextSize       = 12,
                    TextColor3     = Theme.TextSecond,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex         = 16,
                    Parent         = hdr,
                })
                U.New("Frame", {
                    BackgroundColor3 = Theme.Border,
                    BorderSizePixel  = 0,
                    Position         = UDim2.new(0, 0, 1, -1),
                    Size             = UDim2.new(1, 0, 0, 1),
                    ZIndex           = 15,
                    Parent           = hdr,
                })
            end

            local items = U.New("Frame", {
                Name             = "Items",
                BackgroundTransparency = 1,
                Position         = UDim2.new(0, 0, 0, hasHeader and 38 or 0),
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                ZIndex           = 15,
                Parent           = container,
            })
            U.List(items, 1)
            U.Padding(items, 4, 12, 8, 12)

            local Sec = {}

            -- ── BUTTON ─────────────────────────────────────────────────────
            function Sec:Button(c)
                c = c or {}
                local bname  = c.Name        or "Button"
                local bdesc  = c.Description or ""
                local bcb    = c.Callback    or function() end

                local h = bdesc ~= "" and 50 or 36

                local row = U.New("TextButton", {
                    Name                 = bname,
                    BackgroundColor3     = Theme.SurfaceAlt,
                    Size                 = UDim2.new(1, 0, 0, h),
                    Text                 = "",
                    ZIndex               = 16,
                    ClipsDescendants     = true,
                    Parent               = items,
                })
                U.Corner(row, 7)

                U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position       = UDim2.new(0, 12, 0, bdesc ~= "" and 8 or 0),
                    Size           = UDim2.new(1, -52, 0, 18),
                    Text           = bname,
                    Font           = Enum.Font.GothamSemibold,
                    TextSize       = 13,
                    TextColor3     = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex         = 17,
                    Parent         = row,
                })

                if bdesc ~= "" then
                    U.New("TextLabel", {
                        BackgroundTransparency = 1,
                        Position       = UDim2.new(0, 12, 0, 28),
                        Size           = UDim2.new(1, -52, 0, 14),
                        Text           = bdesc,
                        Font           = Enum.Font.Gotham,
                        TextSize       = 11,
                        TextColor3     = Theme.TextSecond,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex         = 17,
                        Parent         = row,
                    })
                end

                U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint    = Vector2.new(1, 0.5),
                    Position       = UDim2.new(1, -12, 0.5, 0),
                    Size           = UDim2.new(0, 16, 0, 16),
                    Text           = "›",
                    Font           = Enum.Font.GothamBold,
                    TextSize       = 20,
                    TextColor3     = Theme.TextDim,
                    ZIndex         = 17,
                    Parent         = row,
                })

                row.MouseEnter:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceHover }, 0.1)
                end)
                row.MouseLeave:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceAlt }, 0.1)
                end)
                row.MouseButton1Down:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.Border }, 0.07)
                end)
                row.MouseButton1Up:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceHover }, 0.07)
                end)
                row.MouseButton1Click:Connect(function()
                    local pos = UserInputService:GetMouseLocation()
                    U.Ripple(row, pos.X, pos.Y)
                    pcall(bcb)
                end)

                local El = {}
                function El:SetName(n)
                    row:FindFirstChildWhichIsA("TextLabel").Text = n
                end
                return El
            end

            -- ── TOGGLE ─────────────────────────────────────────────────────
            function Sec:Toggle(c)
                c = c or {}
                local tname  = c.Name        or "Toggle"
                local tdesc  = c.Description or ""
                local tdef   = c.Default     or false
                local flag   = c.Flag        or tname
                local tcb    = c.Callback    or function() end
                local state  = tdef

                Library.Flags[flag] = state

                local h = tdesc ~= "" and 50 or 36

                local row = U.New("Frame", {
                    Name             = tname,
                    BackgroundColor3 = Theme.SurfaceAlt,
                    Size             = UDim2.new(1, 0, 0, h),
                    ZIndex           = 16,
                    Parent           = items,
                })
                U.Corner(row, 7)

                U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position       = UDim2.new(0, 12, 0, tdesc ~= "" and 8 or 0),
                    Size           = UDim2.new(1, -64, 0, 18),
                    Text           = tname,
                    Font           = Enum.Font.GothamSemibold,
                    TextSize       = 13,
                    TextColor3     = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex         = 17,
                    Parent         = row,
                })

                if tdesc ~= "" then
                    U.New("TextLabel", {
                        BackgroundTransparency = 1,
                        Position       = UDim2.new(0, 12, 0, 28),
                        Size           = UDim2.new(1, -64, 0, 14),
                        Text           = tdesc,
                        Font           = Enum.Font.Gotham,
                        TextSize       = 11,
                        TextColor3     = Theme.TextSecond,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex         = 17,
                        Parent         = row,
                    })
                end

                -- Switch
                local switchBG = U.New("Frame", {
                    AnchorPoint      = Vector2.new(1, 0.5),
                    BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
                    Position         = UDim2.new(1, -12, 0.5, 0),
                    Size             = UDim2.new(0, 38, 0, 20),
                    ZIndex           = 17,
                    Parent           = row,
                })
                U.Corner(switchBG, 999)

                local knob = U.New("Frame", {
                    AnchorPoint      = Vector2.new(0, 0.5),
                    BackgroundColor3 = Theme.ToggleKnob,
                    Position         = state
                        and UDim2.new(0, 20, 0.5, 0)
                        or  UDim2.new(0, 2,  0.5, 0),
                    Size             = UDim2.new(0, 16, 0, 16),
                    ZIndex           = 18,
                    Parent           = switchBG,
                })
                U.Corner(knob, 999)

                local function setToggle(val, anim)
                    state = val
                    Library.Flags[flag] = val
                    local dur = anim and 0.18 or 0
                    U.Tween(switchBG, { BackgroundColor3 = val and Theme.ToggleOn or Theme.ToggleOff }, dur)
                    U.Tween(knob, {
                        Position = val and UDim2.new(0, 20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                    }, dur)
                end

                local hit = U.New("TextButton", {
                    BackgroundTransparency = 1,
                    Size   = UDim2.new(1, 0, 1, 0),
                    Text   = "",
                    ZIndex = 19,
                    Parent = row,
                })
                hit.MouseButton1Click:Connect(function()
                    setToggle(not state, true)
                    pcall(tcb, state)
                end)

                row.MouseEnter:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceHover }, 0.1)
                end)
                row.MouseLeave:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceAlt }, 0.1)
                end)

                local El = {}
                function El:Set(v) setToggle(v, true); pcall(tcb, v) end
                function El:Get() return state end
                return El
            end

            -- ── SLIDER ─────────────────────────────────────────────────────
            function Sec:Slider(c)
                c = c or {}
                local sname  = c.Name        or "Slider"
                local sdesc  = c.Description or ""
                local smin   = c.Minimum     or 0
                local smax   = c.Maximum     or 100
                local sdef   = math.clamp(c.Default or smin, smin, smax)
                local sinc   = c.Increment   or 1
                local suffix = c.Suffix      or ""
                local flag   = c.Flag        or sname
                local scb    = c.Callback    or function() end
                local value  = sdef

                Library.Flags[flag] = value

                local function snap(v)
                    return math.clamp(
                        math.round((v - smin) / sinc) * sinc + smin,
                        smin, smax
                    )
                end

                local h = sdesc ~= "" and 60 or 50

                local row = U.New("Frame", {
                    Name             = sname,
                    BackgroundColor3 = Theme.SurfaceAlt,
                    Size             = UDim2.new(1, 0, 0, h),
                    ZIndex           = 16,
                    Parent           = items,
                })
                U.Corner(row, 7)
                U.Padding(row, 10, 12, 10, 12)

                -- Top row: name | value
                local topRow = U.New("Frame", {
                    BackgroundTransparency = 1,
                    Size   = UDim2.new(1, 0, 0, 18),
                    ZIndex = 17,
                    Parent = row,
                })
                U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size           = UDim2.new(0.65, 0, 1, 0),
                    Text           = sname,
                    Font           = Enum.Font.GothamSemibold,
                    TextSize       = 13,
                    TextColor3     = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex         = 18,
                    Parent         = topRow,
                })
                local valLabel = U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint    = Vector2.new(1, 0),
                    Position       = UDim2.new(1, 0, 0, 0),
                    Size           = UDim2.new(0.35, 0, 1, 0),
                    Text           = tostring(value) .. suffix,
                    Font           = Enum.Font.GothamBold,
                    TextSize       = 13,
                    TextColor3     = Theme.TextAccent,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex         = 18,
                    Parent         = topRow,
                })

                if sdesc ~= "" then
                    U.New("TextLabel", {
                        BackgroundTransparency = 1,
                        Position       = UDim2.new(0, 0, 0, 20),
                        Size           = UDim2.new(1, 0, 0, 13),
                        Text           = sdesc,
                        Font           = Enum.Font.Gotham,
                        TextSize       = 11,
                        TextColor3     = Theme.TextSecond,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex         = 18,
                        Parent         = row,
                    })
                end

                local trackY = sdesc ~= "" and 40 or 30
                local track = U.New("Frame", {
                    BackgroundColor3 = Theme.SliderTrack,
                    Position         = UDim2.new(0, 0, 0, trackY),
                    Size             = UDim2.new(1, 0, 0, 6),
                    ZIndex           = 17,
                    Parent           = row,
                })
                U.Corner(track, 3)

                local pct0 = (value - smin) / (smax - smin)
                local fill = U.New("Frame", {
                    BackgroundColor3 = Theme.SliderFill,
                    Size             = UDim2.new(pct0, 0, 1, 0),
                    ZIndex           = 18,
                    Parent           = track,
                })
                U.Corner(fill, 3)

                local knob = U.New("Frame", {
                    AnchorPoint      = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Position         = UDim2.new(pct0, 0, 0.5, 0),
                    Size             = UDim2.new(0, 14, 0, 14),
                    ZIndex           = 19,
                    Parent           = track,
                })
                U.Corner(knob, 999)
                U.New("UIStroke", { Color = Theme.SliderFill, Thickness = 2, Parent = knob })

                local function setValue(raw, fire)
                    value = snap(raw)
                    Library.Flags[flag] = value
                    local p = (value - smin) / (smax - smin)
                    fill.Size     = UDim2.new(p, 0, 1, 0)
                    knob.Position = UDim2.new(p, 0, 0.5, 0)
                    valLabel.Text = tostring(value) .. suffix
                    if fire then pcall(scb, value) end
                end

                local sliding = false

                track.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        local rel = math.clamp(
                            (inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X,
                            0, 1
                        )
                        setValue(smin + rel * (smax - smin), true)
                    end
                end)
                Library:_connect(UserInputService.InputChanged, function(inp)
                    if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = math.clamp(
                            (inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X,
                            0, 1
                        )
                        setValue(smin + rel * (smax - smin), true)
                    end
                end)
                Library:_connect(UserInputService.InputEnded, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)

                row.MouseEnter:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceHover }, 0.1)
                end)
                row.MouseLeave:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceAlt }, 0.1)
                end)

                local El = {}
                function El:Set(v) setValue(v, true) end
                function El:Get() return value end
                return El
            end

            -- ── DROPDOWN ───────────────────────────────────────────────────
            function Sec:Dropdown(c)
                c = c or {}
                local dname    = c.Name        or "Dropdown"
                local ddesc    = c.Description or ""
                local dopts    = c.Options     or {}
                local ddef     = c.Default     or (dopts[1] or "")
                local flag     = c.Flag        or dname
                local dcb      = c.Callback    or function() end
                local selected = ddef
                local open     = false

                Library.Flags[flag] = selected

                local baseH = ddesc ~= "" and 60 or 46

                local row = U.New("Frame", {
                    Name             = dname,
                    BackgroundColor3 = Theme.SurfaceAlt,
                    Size             = UDim2.new(1, 0, 0, baseH),
                    ZIndex           = 16,
                    ClipsDescendants = false,
                    Parent           = items,
                })
                U.Corner(row, 7)
                U.Padding(row, 8, 12, 8, 12)

                U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size           = UDim2.new(1, 0, 0, 18),
                    Text           = dname,
                    Font           = Enum.Font.GothamSemibold,
                    TextSize       = 13,
                    TextColor3     = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex         = 17,
                    Parent         = row,
                })

                if ddesc ~= "" then
                    U.New("TextLabel", {
                        BackgroundTransparency = 1,
                        Position       = UDim2.new(0, 0, 0, 20),
                        Size           = UDim2.new(1, 0, 0, 13),
                        Text           = ddesc,
                        Font           = Enum.Font.Gotham,
                        TextSize       = 11,
                        TextColor3     = Theme.TextSecond,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex         = 17,
                        Parent         = row,
                    })
                end

                local btnY = ddesc ~= "" and 36 or 24
                local selBtn = U.New("TextButton", {
                    BackgroundColor3 = Theme.InputBG,
                    Position         = UDim2.new(0, 0, 0, btnY),
                    Size             = UDim2.new(1, 0, 0, 28),
                    Text             = "",
                    ZIndex           = 17,
                    Parent           = row,
                })
                U.Corner(selBtn, 6)
                U.Stroke(selBtn, Theme.Border)

                local selLabel = U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position       = UDim2.new(0, 9, 0, 0),
                    Size           = UDim2.new(1, -30, 1, 0),
                    Text           = selected,
                    Font           = Enum.Font.Gotham,
                    TextSize       = 12,
                    TextColor3     = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex         = 18,
                    Parent         = selBtn,
                })

                local arrow = U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint    = Vector2.new(1, 0.5),
                    Position       = UDim2.new(1, -8, 0.5, 0),
                    Size           = UDim2.new(0, 14, 0, 14),
                    Text           = "▾",
                    Font           = Enum.Font.GothamBold,
                    TextSize       = 12,
                    TextColor3     = Theme.TextDim,
                    ZIndex         = 18,
                    Parent         = selBtn,
                })

                -- Dropdown list
                local listFrame = U.New("Frame", {
                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel  = 0,
                    Position         = UDim2.new(0, 0, 1, 4),
                    Size             = UDim2.new(1, 0, 0, 0),
                    ZIndex           = 55,
                    ClipsDescendants = true,
                    Visible          = false,
                    Parent           = selBtn,
                })
                U.Corner(listFrame, 7)
                U.Stroke(listFrame, Theme.Border)

                local listInner = U.New("ScrollingFrame", {
                    BackgroundTransparency = 1,
                    BorderSizePixel        = 0,
                    Size                   = UDim2.new(1, 0, 1, 0),
                    ScrollBarThickness     = 2,
                    ScrollBarImageColor3   = Theme.Scrollbar,
                    CanvasSize             = UDim2.new(0, 0, 0, 0),
                    AutomaticCanvasSize    = Enum.AutomaticSize.Y,
                    ZIndex                 = 56,
                    Parent                 = listFrame,
                })
                U.List(listInner, 0)
                U.Padding(listInner, 4, 4, 4, 4)

                local function populate()
                    for _, ch in ipairs(listInner:GetChildren()) do
                        if not ch:IsA("UIListLayout") and not ch:IsA("UIPadding") then
                            ch:Destroy()
                        end
                    end
                    for _, opt in ipairs(dopts) do
                        local isActive = opt == selected
                        local optBtn = U.New("TextButton", {
                            BackgroundColor3       = isActive and Theme.SurfaceAlt or Color3.fromRGB(0,0,0),
                            BackgroundTransparency = isActive and 0 or 1,
                            Size                   = UDim2.new(1, 0, 0, 28),
                            Text                   = "",
                            ZIndex                 = 57,
                            Parent                 = listInner,
                        })
                        U.Corner(optBtn, 5)
                        U.New("TextLabel", {
                            BackgroundTransparency = 1,
                            Position       = UDim2.new(0, 9, 0, 0),
                            Size           = UDim2.new(1, -9, 1, 0),
                            Text           = opt,
                            Font           = isActive and Enum.Font.GothamBold or Enum.Font.Gotham,
                            TextSize       = 12,
                            TextColor3     = isActive and Theme.TextAccent or Theme.TextPrimary,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex         = 58,
                            Parent         = optBtn,
                        })
                        optBtn.MouseEnter:Connect(function()
                            if not isActive then
                                U.Tween(optBtn, {
                                    BackgroundTransparency = 0,
                                    BackgroundColor3 = Theme.SurfaceHover
                                }, 0.1)
                            end
                        end)
                        optBtn.MouseLeave:Connect(function()
                            if not isActive then
                                U.Tween(optBtn, { BackgroundTransparency = 1 }, 0.1)
                            end
                        end)
                        optBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            Library.Flags[flag] = opt
                            selLabel.Text = opt
                            open = false
                            U.Tween(listFrame, { Size = UDim2.new(1, 0, 0, 0) }, 0.16)
                            task.delay(0.18, function()
                                if not open then listFrame.Visible = false end
                            end)
                            populate()
                            pcall(dcb, opt)
                        end)
                    end
                    local count = math.min(#dopts, 6)
                    listFrame.Size = UDim2.new(1, 0, 0, math.max(count * 28 + 8, 0))
                end

                selBtn.MouseButton1Click:Connect(function()
                    open = not open
                    U.Tween(arrow, { Rotation = open and 180 or 0 }, 0.18)
                    if open then
                        populate()
                        listFrame.Visible = true
                        listFrame.Size    = UDim2.new(1, 0, 0, 0)
                        local count = math.min(#dopts, 6)
                        U.Tween(listFrame, { Size = UDim2.new(1, 0, 0, count * 28 + 8) }, 0.18)
                    else
                        U.Tween(listFrame, { Size = UDim2.new(1, 0, 0, 0) }, 0.16)
                        task.delay(0.18, function()
                            if not open then listFrame.Visible = false end
                        end)
                    end
                end)

                row.MouseEnter:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceHover }, 0.1)
                end)
                row.MouseLeave:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceAlt }, 0.1)
                end)

                local El = {}
                function El:Set(v)
                    selected = v
                    Library.Flags[flag] = v
                    selLabel.Text = v
                    populate()
                    pcall(dcb, v)
                end
                function El:SetOptions(opts)
                    dopts = opts
                    if not table.find(opts, selected) then
                        selected = opts[1] or ""
                        selLabel.Text = selected
                        Library.Flags[flag] = selected
                    end
                end
                function El:Get() return selected end
                return El
            end

            -- ── TEXTBOX ────────────────────────────────────────────────────
            function Sec:TextBox(c)
                c = c or {}
                local tbname = c.Name        or "TextBox"
                local tbdesc = c.Description or ""
                local tbdef  = c.Default     or ""
                local tbph   = c.Placeholder or "Enter value..."
                local flag   = c.Flag        or tbname
                local tbcb   = c.Callback    or function() end

                Library.Flags[flag] = tbdef

                local h = tbdesc ~= "" and 60 or 46

                local row = U.New("Frame", {
                    Name             = tbname,
                    BackgroundColor3 = Theme.SurfaceAlt,
                    Size             = UDim2.new(1, 0, 0, h),
                    ZIndex           = 16,
                    Parent           = items,
                })
                U.Corner(row, 7)
                U.Padding(row, 8, 12, 8, 12)

                U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size           = UDim2.new(1, 0, 0, 18),
                    Text           = tbname,
                    Font           = Enum.Font.GothamSemibold,
                    TextSize       = 13,
                    TextColor3     = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex         = 17,
                    Parent         = row,
                })

                if tbdesc ~= "" then
                    U.New("TextLabel", {
                        BackgroundTransparency = 1,
                        Position       = UDim2.new(0, 0, 0, 20),
                        Size           = UDim2.new(1, 0, 0, 13),
                        Text           = tbdesc,
                        Font           = Enum.Font.Gotham,
                        TextSize       = 11,
                        TextColor3     = Theme.TextSecond,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex         = 17,
                        Parent         = row,
                    })
                end

                local inputY = tbdesc ~= "" and 36 or 24
                local inputFrame = U.New("Frame", {
                    BackgroundColor3 = Theme.InputBG,
                    Position         = UDim2.new(0, 0, 0, inputY),
                    Size             = UDim2.new(1, 0, 0, 28),
                    ZIndex           = 17,
                    Parent           = row,
                })
                U.Corner(inputFrame, 6)
                local stroke = U.Stroke(inputFrame, Theme.Border)

                local input = U.New("TextBox", {
                    BackgroundTransparency = 1,
                    ClearTextOnFocus       = false,
                    Font                   = Enum.Font.Gotham,
                    PlaceholderColor3      = Theme.Placeholder,
                    PlaceholderText        = tbph,
                    Text                   = tbdef,
                    TextColor3             = Theme.TextPrimary,
                    TextSize               = 12,
                    TextXAlignment         = Enum.TextXAlignment.Left,
                    Size                   = UDim2.new(1, 0, 1, 0),
                    ZIndex                 = 18,
                    Parent                 = inputFrame,
                })
                U.Padding(input, 0, 8, 0, 8)

                input.Focused:Connect(function()
                    U.Tween(stroke, { Color = Theme.Accent }, 0.14)
                end)
                input.FocusLost:Connect(function(enter)
                    U.Tween(stroke, { Color = Theme.Border }, 0.14)
                    if enter then
                        Library.Flags[flag] = input.Text
                        pcall(tbcb, input.Text)
                    end
                end)

                row.MouseEnter:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceHover }, 0.1)
                end)
                row.MouseLeave:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceAlt }, 0.1)
                end)

                local El = {}
                function El:Set(v) input.Text = v; Library.Flags[flag] = v end
                function El:Get() return input.Text end
                return El
            end

            -- ── LABEL ──────────────────────────────────────────────────────
            function Sec:Label(c)
                c = c or {}
                local lname = c.Name  or ""
                local lval  = c.Value or ""

                local row = U.New("Frame", {
                    Name                   = "Label",
                    BackgroundColor3       = Theme.Surface,
                    BackgroundTransparency = 0.45,
                    Size                   = UDim2.new(1, 0, 0, 34),
                    ZIndex                 = 16,
                    Parent                 = items,
                })
                U.Corner(row, 7)
                U.Padding(row, 0, 12, 0, 12)

                local nameL = U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size           = UDim2.new(0.5, 0, 1, 0),
                    Text           = lname,
                    Font           = Enum.Font.GothamSemibold,
                    TextSize       = 13,
                    TextColor3     = Theme.TextSecond,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex         = 17,
                    Parent         = row,
                })

                local valL = U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint    = Vector2.new(1, 0.5),
                    Position       = UDim2.new(1, 0, 0.5, 0),
                    Size           = UDim2.new(0.5, 0, 1, 0),
                    Text           = lval,
                    Font           = Enum.Font.Gotham,
                    TextSize       = 13,
                    TextColor3     = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex         = 17,
                    Parent         = row,
                })

                local El = {}
                function El:SetName(n) nameL.Text = n end
                function El:SetValue(v) valL.Text = tostring(v) end
                return El
            end

            -- ── PARAGRAPH ──────────────────────────────────────────────────
            function Sec:Paragraph(c)
                c = c or {}
                local pname = c.Name    or ""
                local ptext = c.Content or ""

                local row = U.New("Frame", {
                    Name                   = "Paragraph",
                    BackgroundColor3       = Theme.Surface,
                    BackgroundTransparency = 0.45,
                    Size                   = UDim2.new(1, 0, 0, 0),
                    AutomaticSize          = Enum.AutomaticSize.Y,
                    ZIndex                 = 16,
                    Parent                 = items,
                })
                U.Corner(row, 7)
                U.Padding(row, 10, 12, 10, 12)
                U.List(row, 4)

                if pname ~= "" then
                    U.New("TextLabel", {
                        BackgroundTransparency = 1,
                        Size           = UDim2.new(1, 0, 0, 18),
                        Text           = pname,
                        Font           = Enum.Font.GothamBold,
                        TextSize       = 13,
                        TextColor3     = Theme.TextPrimary,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex         = 17,
                        Parent         = row,
                    })
                end

                local bodyL = U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size           = UDim2.new(1, 0, 0, 0),
                    AutomaticSize  = Enum.AutomaticSize.Y,
                    Text           = ptext,
                    Font           = Enum.Font.Gotham,
                    TextSize       = 12,
                    TextColor3     = Theme.TextSecond,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped    = true,
                    ZIndex         = 17,
                    Parent         = row,
                })

                local El = {}
                function El:SetContent(t) bodyL.Text = t end
                function El:SetTitle(t) pname = t end
                return El
            end

            -- ── KEYBIND ────────────────────────────────────────────────────
            function Sec:Keybind(c)
                c = c or {}
                local kname   = c.Name     or "Keybind"
                local kdef    = c.Default  or Enum.KeyCode.Unknown
                local flag    = c.Flag     or kname
                local kcb     = c.Callback or function() end
                local bound   = kdef
                local binding = false

                Library.Flags[flag] = bound

                local row = U.New("Frame", {
                    Name             = kname,
                    BackgroundColor3 = Theme.SurfaceAlt,
                    Size             = UDim2.new(1, 0, 0, 36),
                    ZIndex           = 16,
                    Parent           = items,
                })
                U.Corner(row, 7)
                U.Padding(row, 0, 12, 0, 12)

                U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size           = UDim2.new(0.58, 0, 1, 0),
                    Text           = kname,
                    Font           = Enum.Font.GothamSemibold,
                    TextSize       = 13,
                    TextColor3     = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex         = 17,
                    Parent         = row,
                })

                local keyBtn = U.New("TextButton", {
                    AnchorPoint      = Vector2.new(1, 0.5),
                    BackgroundColor3 = Theme.InputBG,
                    Position         = UDim2.new(1, 0, 0.5, 0),
                    Size             = UDim2.new(0, 76, 0, 22),
                    Text             = bound.Name,
                    Font             = Enum.Font.GothamBold,
                    TextSize         = 11,
                    TextColor3       = Theme.TextAccent,
                    ZIndex           = 17,
                    Parent           = row,
                })
                U.Corner(keyBtn, 5)
                U.Stroke(keyBtn, Theme.Border)

                keyBtn.MouseButton1Click:Connect(function()
                    binding          = true
                    keyBtn.Text      = "..."
                    keyBtn.TextColor3= Theme.Warning
                end)

                Library:_connect(UserInputService.InputBegan, function(inp, proc)
                    if binding then
                        if inp.UserInputType == Enum.UserInputType.Keyboard then
                            binding = false
                            if inp.KeyCode == Enum.KeyCode.Escape then
                                keyBtn.Text       = bound.Name
                                keyBtn.TextColor3 = Theme.TextAccent
                            else
                                bound                = inp.KeyCode
                                Library.Flags[flag]  = bound
                                keyBtn.Text          = bound.Name
                                keyBtn.TextColor3    = Theme.TextAccent
                            end
                        end
                    else
                        if not proc and inp.KeyCode == bound then
                            pcall(kcb, bound)
                        end
                    end
                end)

                row.MouseEnter:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceHover }, 0.1)
                end)
                row.MouseLeave:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceAlt }, 0.1)
                end)

                local El = {}
                function El:Set(k) bound = k; Library.Flags[flag] = k; keyBtn.Text = k.Name end
                function El:Get() return bound end
                return El
            end

            -- ── COLOR PICKER ───────────────────────────────────────────────
            function Sec:ColorPicker(c)
                c = c or {}
                local cpname = c.Name     or "Color"
                local cpdef  = c.Default  or Color3.fromRGB(255, 100, 100)
                local flag   = c.Flag     or cpname
                local cpcb   = c.Callback or function() end
                local color  = cpdef
                local h, s, v = Color3.toHSV(color)
                local pickerOpen = false

                Library.Flags[flag] = color

                local row = U.New("Frame", {
                    Name             = cpname,
                    BackgroundColor3 = Theme.SurfaceAlt,
                    Size             = UDim2.new(1, 0, 0, 36),
                    ZIndex           = 16,
                    ClipsDescendants = false,
                    Parent           = items,
                })
                U.Corner(row, 7)
                U.Padding(row, 0, 12, 0, 12)

                U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size           = UDim2.new(0.65, 0, 1, 0),
                    Text           = cpname,
                    Font           = Enum.Font.GothamSemibold,
                    TextSize       = 13,
                    TextColor3     = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex         = 17,
                    Parent         = row,
                })

                local preview = U.New("TextButton", {
                    AnchorPoint      = Vector2.new(1, 0.5),
                    BackgroundColor3 = color,
                    Position         = UDim2.new(1, 0, 0.5, 0),
                    Size             = UDim2.new(0, 40, 0, 20),
                    Text             = "",
                    ZIndex           = 17,
                    Parent           = row,
                })
                U.Corner(preview, 5)
                U.Stroke(preview, Theme.Border)

                local picker = U.New("Frame", {
                    BackgroundColor3 = Theme.Surface,
                    Position         = UDim2.new(0, 0, 1, 4),
                    Size             = UDim2.new(1, 0, 0, 0),
                    ZIndex           = 55,
                    ClipsDescendants = true,
                    Visible          = false,
                    Parent           = row,
                })
                U.Corner(picker, 7)
                U.Stroke(picker, Theme.Border)

                local function updateColor()
                    color = Color3.fromHSV(h, s, v)
                    preview.BackgroundColor3 = color
                    Library.Flags[flag] = color
                    pcall(cpcb, color)
                end

                local function makeHsvSlider(parent, label, yp, initial, setter)
                    U.New("TextLabel", {
                        BackgroundTransparency = 1,
                        Position       = UDim2.new(0, 8, 0, yp + 1),
                        Size           = UDim2.new(0, 14, 0, 14),
                        Text           = label,
                        Font           = Enum.Font.GothamBold,
                        TextSize       = 10,
                        TextColor3     = Theme.TextDim,
                        ZIndex         = 57,
                        Parent         = parent,
                    })
                    local tr = U.New("Frame", {
                        BackgroundColor3 = Theme.SliderTrack,
                        Position         = UDim2.new(0, 26, 0, yp + 3),
                        Size             = UDim2.new(1, -44, 0, 8),
                        ZIndex           = 57,
                        Parent           = parent,
                    })
                    U.Corner(tr, 4)
                    local fl = U.New("Frame", {
                        BackgroundColor3 = Theme.Accent,
                        Size             = UDim2.new(initial, 0, 1, 0),
                        ZIndex           = 58,
                        Parent           = tr,
                    })
                    U.Corner(fl, 4)

                    local sl = false
                    tr.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            sl = true
                            local rel = math.clamp(
                                (inp.Position.X - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1
                            )
                            fl.Size = UDim2.new(rel, 0, 1, 0)
                            setter(rel); updateColor()
                        end
                    end)
                    Library:_connect(UserInputService.InputChanged, function(inp)
                        if sl and inp.UserInputType == Enum.UserInputType.MouseMovement then
                            local rel = math.clamp(
                                (inp.Position.X - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1
                            )
                            fl.Size = UDim2.new(rel, 0, 1, 0)
                            setter(rel); updateColor()
                        end
                    end)
                    Library:_connect(UserInputService.InputEnded, function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then sl = false end
                    end)
                end

                preview.MouseButton1Click:Connect(function()
                    pickerOpen = not pickerOpen
                    if pickerOpen then
                        picker:ClearAllChildren()
                        U.Padding(picker, 8, 8, 8, 8)
                        makeHsvSlider(picker, "H",  0,  h, function(val) h = val end)
                        makeHsvSlider(picker, "S", 26,  s, function(val) s = val end)
                        makeHsvSlider(picker, "V", 52,  v, function(val) v = val end)
                        picker.Visible = true
                        picker.Size    = UDim2.new(1, 0, 0, 0)
                        U.Tween(picker, { Size = UDim2.new(1, 0, 0, 88) }, 0.2)
                        U.Tween(row,    { Size = UDim2.new(1, 0, 0, 132) }, 0.2)
                    else
                        U.Tween(picker, { Size = UDim2.new(1, 0, 0, 0) }, 0.16)
                        U.Tween(row,    { Size = UDim2.new(1, 0, 0, 36) }, 0.16)
                        task.delay(0.18, function()
                            if not pickerOpen then picker.Visible = false end
                        end)
                    end
                end)

                row.MouseEnter:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceHover }, 0.1)
                end)
                row.MouseLeave:Connect(function()
                    U.Tween(row, { BackgroundColor3 = Theme.SurfaceAlt }, 0.1)
                end)

                local El = {}
                function El:Set(col)
                    color = col
                    preview.BackgroundColor3 = col
                    h, s, v = Color3.toHSV(col)
                    Library.Flags[flag] = col
                end
                function El:Get() return color end
                return El
            end

            -- ── DIVIDER ────────────────────────────────────────────────────
            function Sec:Divider()
                U.New("Frame", {
                    BackgroundColor3     = Theme.Border,
                    BorderSizePixel      = 0,
                    Size                 = UDim2.new(1, 0, 0, 1),
                    BackgroundTransparency = 0.35,
                    ZIndex               = 16,
                    Parent               = items,
                })
            end

            return Sec
        end

        return tabObj
    end

    table.insert(self.Windows, Win)
    return Win
end

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │  CONFIG  (requires executor writefile / readfile)                        │
-- └──────────────────────────────────────────────────────────────────────────┘
function Library:SaveConfig(name)
    local data = {}
    for k, v in pairs(self.Flags) do
        local t = type(v)
        if t == "number" or t == "boolean" or t == "string" then
            data[k] = v
        end
    end
    local ok = pcall(function()
        local json = game:GetService("HttpService"):JSONEncode(data)
        writefile("RezaLib_" .. (name or "config") .. ".json", json)
    end)
    self:Notification({
        Title    = "Config",
        Content  = ok and "Saved successfully." or "Save failed (writefile unavailable).",
        Type     = ok and "Success" or "Error",
        Duration = 2,
    })
end

function Library:LoadConfig(name)
    local ok, raw = pcall(readfile, "RezaLib_" .. (name or "config") .. ".json")
    if not ok or not raw then
        self:Notification({ Title = "Config", Content = "No config file found.", Type = "Warning", Duration = 2 })
        return
    end
    local ok2, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(raw)
    end)
    if not ok2 then return end
    for k, v in pairs(data) do
        Library.Flags[k] = v
    end
    self:Notification({ Title = "Config", Content = "Loaded successfully.", Type = "Success", Duration = 2 })
end

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │  CLEANUP                                                                 │
-- └──────────────────────────────────────────────────────────────────────────┘
function Library:Destroy()
    for _, c in ipairs(self.Connections) do
        pcall(function() c:Disconnect() end)
    end
    self.Connections = {}
    if self._gui then
        pcall(function() self._gui:Destroy() end)
        self._gui = nil
    end
    self.Windows = {}
    self.Flags   = {}
end

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │  RETURN                                                                  │
-- └──────────────────────────────────────────────────────────────────────────┘
return Library
