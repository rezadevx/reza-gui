# RezaLib — Professional Roblox Executor GUI Library

> Elegant · Modern · Compatible · Zero Dependencies

---

## Features

- **Universal executor support** — Synapse X, KRNL, Fluxus, Electron, Celery, Solara, and more
- **Complete element set** — Button, Toggle, Slider, Dropdown, TextBox, ColorPicker, Label, Paragraph, Keybind, Divider
- **Smooth animations** — TweenService-powered transitions on every interaction
- **Ripple effect** — Material-style click feedback on buttons
- **Notification system** — Stackable toast notifications with progress timer (Success / Warning / Error / Info)
- **Config persistence** — Save & load flags to JSON via executor `writefile`/`readfile`
- **Toggle key** — Show/hide the UI with a configurable keybind (default: `RightShift`)
- **Draggable window** — Drag by the sidebar header
- **Minimize / Close** — macOS-style window controls
- **Auto-layout** — Sections use `AutomaticSize`; no manual height management needed
- **Scrollable pages & tab lists** — Handles large scripts cleanly

---

## Quick Start

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rezadevx/reza-gui/main/Library.lua"
))()

local Window = Library:Window({
    Title    = "My Script",
    SubTitle = "by Author",
    KeyBind  = Enum.KeyCode.RightShift,
})

local Tab     = Window:Tab({ Name = "Main" })
local Section = Tab:Section({ Name = "Combat" })

Section:Toggle({
    Name     = "God Mode",
    Default  = false,
    Flag     = "GodMode",
    Callback = function(enabled)
        print("God Mode:", enabled)
    end,
})
```

---

## API Reference

### `Library:Window(cfg)` → `Window`

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `Title` | string | `"RezaLib"` | Window title |
| `SubTitle` | string | `""` | Subtitle shown below title |
| `KeyBind` | `Enum.KeyCode` | `RightShift` | Toggle UI visibility |

---

### `Window:Tab(cfg)` → `Tab`

| Key | Type | Description |
|-----|------|-------------|
| `Name` | string | Tab label in sidebar |

---

### `Tab:Section(cfg)` → `Section`

| Key | Type | Description |
|-----|------|-------------|
| `Name` | string | Section header (leave `""` for no header) |

---

### Elements

All elements live on a `Section` object.

#### `Section:Button(cfg)` → `Element`

```lua
Section:Button({
    Name        = "Click Me",
    Description = "Optional subtitle",   -- optional
    Callback    = function() end,
})
```

`Element` methods: `:SetName(string)`

---

#### `Section:Toggle(cfg)` → `Element`

```lua
local toggle = Section:Toggle({
    Name        = "Feature",
    Description = "Optional subtitle",
    Default     = false,
    Flag        = "FeatureEnabled",      -- Library.Flags key
    Callback    = function(value) end,
})

toggle:Set(true)    -- set programmatically
toggle:Get()        -- returns current boolean
```

---

#### `Section:Slider(cfg)` → `Element`

```lua
local slider = Section:Slider({
    Name        = "Walk Speed",
    Description = "Optional subtitle",
    Minimum     = 0,
    Maximum     = 500,
    Default     = 16,
    Increment   = 1,
    Suffix      = " WS",
    Flag        = "WalkSpeed",
    Callback    = function(value) end,
})

slider:Set(100)
slider:Get()        -- returns current number
```

---

#### `Section:Dropdown(cfg)` → `Element`

```lua
local dd = Section:Dropdown({
    Name        = "Mode",
    Description = "Optional subtitle",
    Options     = { "Option A", "Option B", "Option C" },
    Default     = "Option A",
    Flag        = "SelectedMode",
    Callback    = function(value) end,
})

dd:Set("Option B")
dd:SetOptions({ "X", "Y" })   -- replace option list at runtime
dd:Get()                       -- returns selected string
```

---

#### `Section:TextBox(cfg)` → `Element`

```lua
local tb = Section:TextBox({
    Name        = "Target",
    Description = "Optional subtitle",
    Default     = "",
    Placeholder = "Enter name...",
    Flag        = "TargetName",
    Callback    = function(text) end,   -- fires on Enter
})

tb:Set("Player1")
tb:Get()
```

---

#### `Section:ColorPicker(cfg)` → `Element`

```lua
local cp = Section:ColorPicker({
    Name     = "ESP Color",
    Default  = Color3.fromRGB(255, 100, 100),
    Flag     = "ESPColor",
    Callback = function(color) end,
})

cp:Set(Color3.fromRGB(0, 255, 0))
cp:Get()    -- returns Color3
```

---

#### `Section:Keybind(cfg)` → `Element`

```lua
local kb = Section:Keybind({
    Name     = "Noclip",
    Default  = Enum.KeyCode.N,
    Flag     = "NoclipKey",
    Callback = function(key) end,    -- fires when key pressed
})

kb:Set(Enum.KeyCode.G)
kb:Get()    -- returns Enum.KeyCode
```

*Click the key button then press any key to rebind. Press `Escape` to cancel.*

---

#### `Section:Label(cfg)` → `Element`

```lua
local lbl = Section:Label({ Name = "Ping", Value = "..." })
lbl:SetName("Ping")
lbl:SetValue("42 ms")
```

---

#### `Section:Paragraph(cfg)` → `Element`

```lua
local para = Section:Paragraph({
    Name    = "About",
    Content = "Multi-line\ndescription text here.",
})
para:SetContent("Updated content.")
```

---

#### `Section:Divider()`

Inserts a thin horizontal separator line.

---

### Notifications

```lua
Library:Notification({
    Title    = "Success",
    Content  = "Operation completed.",
    Type     = "Success",    -- "Success" | "Warning" | "Error" | "Info"
    Duration = 3,            -- seconds
})
```

---

### Config

Requires executor `writefile` / `readfile` support.

```lua
Library:SaveConfig("myscript")    -- saves to RezaLib_myscript.json
Library:LoadConfig("myscript")    -- loads and applies all flags
```

`Library.Flags` is a flat table keyed by each element's `Flag` string, always up to date.

---

### Cleanup

```lua
Library:Destroy()   -- disconnects all events, destroys GUI
```

---

## Compatibility Matrix

| Executor | GUI Parent | writefile | Tested |
|----------|-----------|-----------|--------|
| Synapse X | `syn.protect_gui` → CoreGui | ✓ | ✓ |
| KRNL | CoreGui | ✓ | ✓ |
| Fluxus | CoreGui | ✓ | ✓ |
| Electron | CoreGui | ✓ | ✓ |
| Celery | CoreGui | ✓ | ✓ |
| Solara | `gethui()` | ✓ | ✓ |
| Others | PlayerGui fallback | varies | ✓ |

---

## License

MIT — free to use, modify, and redistribute.
