return function(Library, Svc, Theme, U, elemAttachers)
    local UserInputService = Svc.UserInputService

    -- ─── Base Design Dimensions (Desktop 470 × 400) ────────────────────────────
    local BASE = {
        WIN_W    = 470,   -- window total width
        WIN_H    = 400,   -- window total height
        NAV_H    = 44,    -- top navbar height
        SIDEBAR  = 140,   -- left sidebar width
        TAB_H    = 32,    -- nav item height
        TAB_TS   = 12,    -- nav item text size
        ICON_TS  = 12,    -- nav icon text size
        TITLE_TS = 12,    -- brand name text size
        BADGE_TS = 8,     -- premium badge text size
        USER_TS  = 10,    -- username text size
        ROLE_TS  = 9,     -- user role text size
        BTN_SZ   = 10,    -- close / min dot size
        BTN_GAP  = 16,    -- gap between control dots
        LOGO_SZ  = 24,    -- logo circle size
        AVATAR_SZ= 22,    -- user avatar circle size
        STATUS_H = 60,    -- system-status area height (bottom of sidebar)
        PAD      = 10,    -- page content padding
        SEC_HDR  = 34,    -- section header height
        SEC_COR  = 7,     -- section corner radius
        NAV_COR  = 6,     -- nav item corner radius
    }

    -- ─── Responsive Config Builder ─────────────────────────────────────────────
    local function buildConfig()
        local isMobile = UserInputService.TouchEnabled
                      and not UserInputService.MouseEnabled
        if not isMobile then
            local D = {}
            for k, v in pairs(BASE) do D[k] = v end
            D.isMobile = false
            return D
        end
        local vp    = workspace.CurrentCamera.ViewportSize
        local scale = math.clamp(
            math.min(vp.X / BASE.WIN_W, vp.Y / BASE.WIN_H) * 0.90,
            0.62, 1.00
        )
        local function sc(v) return math.round(v * scale) end
        return {
            WIN_W     = sc(BASE.WIN_W),
            WIN_H     = sc(BASE.WIN_H),
            NAV_H     = sc(BASE.NAV_H),
            SIDEBAR   = sc(BASE.SIDEBAR),
            TAB_H     = sc(BASE.TAB_H),
            TAB_TS    = sc(BASE.TAB_TS),
            ICON_TS   = sc(BASE.ICON_TS),
            TITLE_TS  = sc(BASE.TITLE_TS),
            BADGE_TS  = sc(BASE.BADGE_TS),
            USER_TS   = sc(BASE.USER_TS),
            ROLE_TS   = sc(BASE.ROLE_TS),
            BTN_SZ    = math.max(sc(BASE.BTN_SZ), 8),
            BTN_GAP   = sc(BASE.BTN_GAP),
            LOGO_SZ   = sc(BASE.LOGO_SZ),
            AVATAR_SZ = sc(BASE.AVATAR_SZ),
            STATUS_H  = sc(BASE.STATUS_H),
            PAD       = sc(BASE.PAD),
            SEC_HDR   = sc(BASE.SEC_HDR),
            SEC_COR   = sc(BASE.SEC_COR),
            NAV_COR   = sc(BASE.NAV_COR),
            isMobile  = true,
        }
    end

    local function attachElements(Sec, items)
        for _, fn in ipairs(elemAttachers) do fn(Sec, items) end
    end

    -- ─── Window Constructor ────────────────────────────────────────────────────
    function Library:Window(cfg)
        cfg = cfg or {}
        local title     = cfg.Title     or "RezaLib"
        local badge     = cfg.Badge     or ""
        local logo      = cfg.Logo      or string.upper(string.sub(title, 1, 1))
        local userName  = cfg.User      or ""
        local userRole  = cfg.UserRole  or ""
        local toggleKey = cfg.KeyBind   or Enum.KeyCode.RightShift

        local D   = buildConfig()
        local gui = self:_gui_root()

        -- Derived layout
        local BODY_Y = D.NAV_H                    -- sidebar + content start Y
        local BODY_H = D.WIN_H - D.NAV_H          -- sidebar + content height
        local NAV_W  = D.WIN_W - D.SIDEBAR        -- content width

        -- ── Root Frame ─────────────────────────────────────────────────────────
        local root = U.New("Frame", {
            Name             = "Window",
            AnchorPoint      = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Theme.BG,
            BorderSizePixel  = 0,
            Position         = UDim2.new(0.5, 0, 0.5, 0),
            Size             = UDim2.new(0, D.WIN_W, 0, D.WIN_H),
            ClipsDescendants = true,
            ZIndex           = 10,
            Parent           = gui,
        })
        U.Corner(root, 10)
        U.Stroke(root, Theme.Border, 1)
        U.Shadow(root, 44, 0.44)

        -- ═══════════════════════════════════════════════════════════════════════
        -- TOP NAVBAR
        -- ═══════════════════════════════════════════════════════════════════════
        local navbar = U.New("Frame", {
            Name             = "NavBar",
            BackgroundColor3 = Theme.Window,
            BorderSizePixel  = 0,
            Size             = UDim2.new(1, 0, 0, D.NAV_H),
            ZIndex           = 20,
            Parent           = root,
        })

        -- Bottom divider of navbar
        U.New("Frame", {
            BackgroundColor3 = Theme.Border,
            BorderSizePixel  = 0,
            Position         = UDim2.new(0, 0, 1, -1),
            Size             = UDim2.new(1, 0, 0, 1),
            ZIndex           = 21,
            Parent           = navbar,
        })

        -- Logo circle (left side)
        local logoCircle = U.New("Frame", {
            AnchorPoint      = Vector2.new(0, 0.5),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel  = 0,
            Position         = UDim2.new(0, 12, 0.5, 0),
            Size             = UDim2.new(0, D.LOGO_SZ, 0, D.LOGO_SZ),
            ZIndex           = 22,
            Parent           = navbar,
        })
        U.Corner(logoCircle, 5)
        U.New("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 148, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(68, 88, 210)),
            }),
            Rotation = 135,
            Parent   = logoCircle,
        })
        U.New("TextLabel", {
            BackgroundTransparency = 1,
            Size           = UDim2.new(1, 0, 1, 0),
            Text           = logo,
            Font           = Enum.Font.GothamBold,
            TextSize       = math.round(D.LOGO_SZ * 0.55),
            TextColor3     = Color3.fromRGB(255, 255, 255),
            ZIndex         = 23,
            Parent         = logoCircle,
        })

        -- Brand name label
        local BRAND_X = 12 + D.LOGO_SZ + 7
        U.New("TextLabel", {
            AnchorPoint            = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Position       = UDim2.new(0, BRAND_X, 0.5, 0),
            Size           = UDim2.new(0, 76, 0, D.TITLE_TS + 4),
            Text           = string.upper(title),
            Font           = Enum.Font.GothamBold,
            TextSize       = D.TITLE_TS,
            TextColor3     = Theme.TextPrimary,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex         = 22,
            Parent         = navbar,
        })

        -- PREMIUM badge (next to brand name)
        if badge ~= "" then
            local BADGE_X = BRAND_X + 78
            local badgeLbl = U.New("TextLabel", {
                AnchorPoint            = Vector2.new(0, 0.5),
                BackgroundColor3       = Theme.Accent,
                BackgroundTransparency = 0.82,
                Position       = UDim2.new(0, BADGE_X, 0.5, 0),
                Size           = UDim2.new(0, 52, 0, 14),
                Text           = string.upper(badge),
                Font           = Enum.Font.GothamBold,
                TextSize       = D.BADGE_TS,
                TextColor3     = Theme.AccentLight,
                ZIndex         = 22,
                Parent         = navbar,
            })
            U.Corner(badgeLbl, 3)
            U.Stroke(badgeLbl, Theme.Accent, 1)
        end

        -- Window control dots (far right) — close & minimize
        local btnClose = U.New("TextButton", {
            AnchorPoint            = Vector2.new(1, 0.5),
            BackgroundColor3       = Color3.fromRGB(255, 72, 72),
            BackgroundTransparency = 0.2,
            Position               = UDim2.new(1, -10, 0.5, 0),
            Size                   = UDim2.new(0, D.BTN_SZ, 0, D.BTN_SZ),
            Text                   = "",
            ZIndex                 = 22,
            Parent                 = navbar,
        })
        U.Corner(btnClose, 999)

        local btnMin = U.New("TextButton", {
            AnchorPoint            = Vector2.new(1, 0.5),
            BackgroundColor3       = Color3.fromRGB(255, 196, 0),
            BackgroundTransparency = 0.2,
            Position               = UDim2.new(1, -(10 + D.BTN_GAP), 0.5, 0),
            Size                   = UDim2.new(0, D.BTN_SZ, 0, D.BTN_SZ),
            Text                   = "",
            ZIndex                 = 22,
            Parent                 = navbar,
        })
        U.Corner(btnMin, 999)

        -- User avatar + name (left of control dots)
        if userName ~= "" then
            local CTL_RIGHT  = 10 + D.BTN_SZ + D.BTN_GAP + D.BTN_SZ + 8
            local avatarX    = -(CTL_RIGHT + D.AVATAR_SZ + 46)

            local userAvatar = U.New("Frame", {
                AnchorPoint      = Vector2.new(1, 0.5),
                BackgroundColor3 = Theme.SurfaceAlt,
                BorderSizePixel  = 0,
                Position         = UDim2.new(1, avatarX, 0.5, 0),
                Size             = UDim2.new(0, D.AVATAR_SZ, 0, D.AVATAR_SZ),
                ZIndex           = 22,
                Parent           = navbar,
            })
            U.Corner(userAvatar, 999)
            U.Stroke(userAvatar, Theme.Border, 1)
            U.New("TextLabel", {
                BackgroundTransparency = 1,
                Size           = UDim2.new(1, 0, 1, 0),
                Text           = string.upper(string.sub(userName, 1, 1)),
                Font           = Enum.Font.GothamBold,
                TextSize       = math.round(D.AVATAR_SZ * 0.48),
                TextColor3     = Theme.TextPrimary,
                ZIndex         = 23,
                Parent         = userAvatar,
            })

            local nameFrame = U.New("Frame", {
                AnchorPoint            = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Position       = UDim2.new(1, avatarX - 4, 0.5, 0),
                Size           = UDim2.new(0, 44, 0, 26),
                ZIndex         = 22,
                Parent         = navbar,
            })
            U.New("TextLabel", {
                BackgroundTransparency = 1,
                Position       = UDim2.new(0, 0, 0, 1),
                Size           = UDim2.new(1, 0, 0, D.USER_TS + 2),
                Text           = userName,
                Font           = Enum.Font.GothamBold,
                TextSize       = D.USER_TS,
                TextColor3     = Theme.TextPrimary,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex         = 23,
                Parent         = nameFrame,
            })
            if userRole ~= "" then
                U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position       = UDim2.new(0, 0, 0, D.USER_TS + 4),
                    Size           = UDim2.new(1, 0, 0, D.ROLE_TS + 2),
                    Text           = userRole,
                    Font           = Enum.Font.Gotham,
                    TextSize       = D.ROLE_TS,
                    TextColor3     = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex         = 23,
                    Parent         = nameFrame,
                })
            end
        end

        -- ═══════════════════════════════════════════════════════════════════════
        -- LEFT SIDEBAR
        -- ═══════════════════════════════════════════════════════════════════════
        local sidebar = U.New("Frame", {
            Name             = "Sidebar",
            BackgroundColor3 = Theme.Sidebar,
            BorderSizePixel  = 0,
            Position         = UDim2.new(0, 0, 0, BODY_Y),
            Size             = UDim2.new(0, D.SIDEBAR, 0, BODY_H),
            ZIndex           = 11,
            Parent           = root,
        })

        -- Sidebar right border line
        U.New("Frame", {
            BackgroundColor3 = Theme.Border,
            BorderSizePixel  = 0,
            Position         = UDim2.new(1, -1, 0, 0),
            Size             = UDim2.new(0, 1, 1, 0),
            ZIndex           = 12,
            Parent           = sidebar,
        })

        -- Nav item list (scrollable, reserves bottom for status)
        local tabList = U.New("ScrollingFrame", {
            Name                   = "NavList",
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Position               = UDim2.new(0, 0, 0, 4),
            Size                   = UDim2.new(1, 0, 1, -(D.STATUS_H + 4)),
            ScrollBarThickness     = 0,
            CanvasSize             = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize    = Enum.AutomaticSize.Y,
            ScrollingDirection     = Enum.ScrollingDirection.Y,
            ZIndex                 = 12,
            Parent                 = sidebar,
        })
        U.List(tabList, 1)
        U.Padding(tabList, 4, 6, 4, 6)

        -- ── System Status (bottom of sidebar) ──────────────────────────────────
        local statusPanel = U.New("Frame", {
            Name                   = "StatusPanel",
            AnchorPoint            = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            Position               = UDim2.new(0, 0, 1, 0),
            Size                   = UDim2.new(1, 0, 0, D.STATUS_H),
            ZIndex                 = 12,
            Parent                 = sidebar,
        })

        -- Top border of status panel
        U.New("Frame", {
            BackgroundColor3 = Theme.Border,
            BorderSizePixel  = 0,
            Size             = UDim2.new(1, 0, 0, 1),
            ZIndex           = 13,
            Parent           = statusPanel,
        })

        U.New("TextLabel", {
            BackgroundTransparency = 1,
            Position       = UDim2.new(0, 10, 0, 6),
            Size           = UDim2.new(1, -10, 0, 11),
            Text           = "System Status",
            Font           = Enum.Font.GothamBold,
            TextSize       = 9,
            TextColor3     = Theme.TextSecond,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex         = 13,
            Parent         = statusPanel,
        })

        U.New("TextLabel", {
            BackgroundTransparency = 1,
            Position       = UDim2.new(0, 10, 0, 19),
            Size           = UDim2.new(1, -10, 0, 10),
            Text           = "All systems operational",
            Font           = Enum.Font.Gotham,
            TextSize       = 8,
            TextColor3     = Theme.Success,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex         = 13,
            Parent         = statusPanel,
        })

        -- Decorative mini sparkline chart
        local sparkFrame = U.New("Frame", {
            BackgroundColor3       = Theme.SurfaceAlt,
            BackgroundTransparency = 0.5,
            Position               = UDim2.new(0, 8, 0, 33),
            Size                   = UDim2.new(1, -16, 0, 20),
            ZIndex                 = 13,
            Parent                 = statusPanel,
        })
        U.Corner(sparkFrame, 4)
        U.New("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,   Color3.fromRGB(72,  199, 116)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(108, 132, 255)),
                ColorSequenceKeypoint.new(0.7, Color3.fromRGB(72,  199, 116)),
                ColorSequenceKeypoint.new(1,   Color3.fromRGB(108, 132, 255)),
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0,   0.5),
                NumberSequenceKeypoint.new(0.5, 0.2),
                NumberSequenceKeypoint.new(1,   0.5),
            }),
            Rotation = 0,
            Parent   = sparkFrame,
        })

        -- ═══════════════════════════════════════════════════════════════════════
        -- CONTENT AREA (right of sidebar)
        -- ═══════════════════════════════════════════════════════════════════════
        local contentArea = U.New("Frame", {
            Name                   = "Content",
            BackgroundColor3       = Theme.BG,
            BackgroundTransparency = 0.5,
            BorderSizePixel        = 0,
            Position               = UDim2.new(0, D.SIDEBAR, 0, BODY_Y),
            Size                   = UDim2.new(1, -D.SIDEBAR, 0, BODY_H),
            ZIndex                 = 11,
            Parent                 = root,
        })

        -- Pages container (each tab renders its page here)
        local pages = U.New("Frame", {
            Name                   = "Pages",
            BackgroundTransparency = 1,
            Position               = UDim2.new(0, 0, 0, 0),
            Size                   = UDim2.new(1, 0, 1, 0),
            ClipsDescendants       = true,
            ZIndex                 = 12,
            Parent                 = contentArea,
        })

        -- ═══════════════════════════════════════════════════════════════════════
        -- DRAG  (navbar as handle — mouse & touch)
        -- ═══════════════════════════════════════════════════════════════════════
        local dragging, dragStart, startPos = false, nil, nil

        local function beginDrag(pos)
            dragging  = true
            dragStart = pos
            startPos  = root.Position
        end
        local function moveDrag(pos)
            if not dragging then return end
            local d = pos - dragStart
            root.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
        local function endDrag() dragging = false end

        self:_connect(navbar.InputBegan, function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                beginDrag(inp.Position)
            end
        end)
        self:_connect(UserInputService.InputChanged, function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch then
                moveDrag(inp.Position)
            end
        end)
        self:_connect(UserInputService.InputEnded, function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                endDrag()
            end
        end)

        -- ═══════════════════════════════════════════════════════════════════════
        -- KEYBIND TOGGLE
        -- ═══════════════════════════════════════════════════════════════════════
        local uiVisible = true
        self:_connect(UserInputService.InputBegan, function(inp, processed)
            if processed then return end
            if inp.KeyCode == toggleKey then
                uiVisible = not uiVisible
                U.Tween(root, {
                    Size = uiVisible
                        and UDim2.new(0, D.WIN_W, 0, D.WIN_H)
                        or  UDim2.new(0, D.WIN_W, 0, 0),
                    BackgroundTransparency = uiVisible and 0 or 1,
                }, 0.22)
            end
        end)

        -- ═══════════════════════════════════════════════════════════════════════
        -- CLOSE & MINIMIZE
        -- ═══════════════════════════════════════════════════════════════════════
        btnClose.MouseButton1Click:Connect(function()
            U.Tween(root, {
                Size                   = UDim2.new(0, D.WIN_W, 0, 0),
                BackgroundTransparency = 1,
            }, 0.18)
            task.wait(0.22)
            pcall(function() root:Destroy() end)
        end)

        local minimized = false
        btnMin.MouseButton1Click:Connect(function()
            minimized = not minimized
            U.Tween(root, {
                Size = minimized
                    and UDim2.new(0, D.WIN_W, 0, D.NAV_H)
                    or  UDim2.new(0, D.WIN_W, 0, D.WIN_H),
            }, 0.20)
        end)

        for _, b in ipairs({ btnClose, btnMin }) do
            b.MouseEnter:Connect(function()
                U.Tween(b, { BackgroundTransparency = 0 }, 0.10)
            end)
            b.MouseLeave:Connect(function()
                U.Tween(b, { BackgroundTransparency = 0.2 }, 0.10)
            end)
        end

        -- ═══════════════════════════════════════════════════════════════════════
        -- WINDOW OBJECT
        -- ═══════════════════════════════════════════════════════════════════════
        local Win = {}
        Win._tabs      = {}
        Win._activeTab = nil
        Win._root      = root

        -- ── Tab ─────────────────────────────────────────────────────────────────
        function Win:Tab(tcfg)
            tcfg = tcfg or {}
            local name = tcfg.Name or ("Tab " .. (#self._tabs + 1))
            local icon = tcfg.Icon or "•"

            -- Nav button (sidebar)
            local btn = U.New("TextButton", {
                Name                   = "Nav_" .. name,
                BackgroundColor3       = Theme.SurfaceAlt,
                BackgroundTransparency = 1,
                Size                   = UDim2.new(1, 0, 0, D.TAB_H),
                Text                   = "",
                ZIndex                 = 14,
                Parent                 = tabList,
            })
            U.Corner(btn, D.NAV_COR)

            -- Active left-edge indicator bar
            local indicator = U.New("Frame", {
                BackgroundColor3       = Theme.Accent,
                BorderSizePixel        = 0,
                Position               = UDim2.new(0, 0, 0.18, 0),
                Size                   = UDim2.new(0, 3, 0.64, 0),
                BackgroundTransparency = 1,
                ZIndex                 = 15,
                Parent                 = btn,
            })
            U.Corner(indicator, 2)

            -- Icon label
            local iconLbl = U.New("TextLabel", {
                BackgroundTransparency = 1,
                Position       = UDim2.new(0, 10, 0, 0),
                Size           = UDim2.new(0, 18, 1, 0),
                Text           = icon,
                Font           = Enum.Font.GothamBold,
                TextSize       = D.ICON_TS,
                TextColor3     = Theme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex         = 15,
                Parent         = btn,
            })

            -- Tab name label
            local nameLbl = U.New("TextLabel", {
                BackgroundTransparency = 1,
                Position       = UDim2.new(0, 32, 0, 0),
                Size           = UDim2.new(1, -36, 1, 0),
                Text           = name,
                Font           = Enum.Font.Gotham,
                TextSize       = D.TAB_TS,
                TextColor3     = Theme.TextSecond,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex         = 15,
                Parent         = btn,
            })

            -- Tab page (scrollable content)
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
            U.List(page, 5)
            U.Padding(page, D.PAD, D.PAD, D.PAD, D.PAD)

            local tabObj = {
                _btn       = btn,
                _page      = page,
                _indicator = indicator,
                _label     = nameLbl,
                _icon      = iconLbl,
            }

            -- Activate tab (switch page + visual states)
            local function activate()
                for _, t in ipairs(Win._tabs) do
                    t._page.Visible = false
                    U.Tween(t._btn,       { BackgroundTransparency = 1 },      0.14)
                    U.Tween(t._label,     { TextColor3 = Theme.TextSecond },   0.14)
                    U.Tween(t._icon,      { TextColor3 = Theme.TextDim },      0.14)
                    U.Tween(t._indicator, { BackgroundTransparency = 1 },      0.14)
                    t._label.Font = Enum.Font.Gotham
                end
                page.Visible  = true
                U.Tween(btn,       { BackgroundTransparency = 0.88 },      0.14)
                U.Tween(nameLbl,   { TextColor3 = Theme.TextPrimary },     0.14)
                U.Tween(iconLbl,   { TextColor3 = Theme.Accent },          0.14)
                U.Tween(indicator, { BackgroundTransparency = 0 },         0.14)
                nameLbl.Font   = Enum.Font.GothamBold
                Win._activeTab = tabObj
            end

            btn.MouseButton1Click:Connect(activate)
            btn.MouseEnter:Connect(function()
                if Win._activeTab ~= tabObj then
                    U.Tween(btn, { BackgroundTransparency = 0.93 }, 0.10)
                end
            end)
            btn.MouseLeave:Connect(function()
                if Win._activeTab ~= tabObj then
                    U.Tween(btn, { BackgroundTransparency = 1 }, 0.10)
                end
            end)

            table.insert(Win._tabs, tabObj)
            if #Win._tabs == 1 then activate() end

            -- ── Section ───────────────────────────────────────────────────────
            function tabObj:Section(scfg)
                scfg = scfg or {}
                local sname = scfg.Name or ""

                local card = U.New("Frame", {
                    Name             = "Section_" .. sname,
                    BackgroundColor3 = Theme.Surface,
                    BorderSizePixel  = 0,
                    Size             = UDim2.new(1, 0, 0, 0),
                    AutomaticSize    = Enum.AutomaticSize.Y,
                    ZIndex           = 14,
                    Parent           = page,
                })
                U.Corner(card, D.SEC_COR)
                U.Stroke(card, Theme.Border, 1)

                local hasHeader = sname ~= ""

                if hasHeader then
                    local hdr = U.New("Frame", {
                        BackgroundTransparency = 1,
                        Size   = UDim2.new(1, 0, 0, D.SEC_HDR),
                        ZIndex = 15,
                        Parent = card,
                    })
                    -- Accent vertical bar
                    U.New("Frame", {
                        BackgroundColor3 = Theme.Accent,
                        BorderSizePixel  = 0,
                        Position         = UDim2.new(0, 12, 0.5, -5),
                        Size             = UDim2.new(0, 3, 0, 10),
                        ZIndex           = 16,
                        Parent           = hdr,
                    })
                    U.New("TextLabel", {
                        BackgroundTransparency = 1,
                        Position       = UDim2.new(0, 21, 0, 0),
                        Size           = UDim2.new(1, -21, 1, 0),
                        Text           = sname,
                        Font           = Enum.Font.GothamBold,
                        TextSize       = 11,
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
                    Name                   = "Items",
                    BackgroundTransparency = 1,
                    Position               = UDim2.new(0, 0, 0, hasHeader and D.SEC_HDR or 0),
                    Size                   = UDim2.new(1, 0, 0, 0),
                    AutomaticSize          = Enum.AutomaticSize.Y,
                    ZIndex                 = 15,
                    Parent                 = card,
                })
                U.List(items, 1)
                U.Padding(items, 4, 10, 8, 10)

                local Sec = {}
                attachElements(Sec, items)
                return Sec
            end

            return tabObj
        end

        table.insert(self.Windows, Win)
        return Win
    end
end
