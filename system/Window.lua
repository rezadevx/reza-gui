return function(Library, Svc, Theme, U, elemAttachers)
    local UserInputService = Svc.UserInputService

    -- ─── Base Design Dimensions (Desktop) ────────────────────────────────────
    local BASE = {
        WIN_W    = 470,
        WIN_H    = 400,
        SIDEBAR  = 160,
        TOPBAR_H = 38,
        HDR_H    = 72,
        TAB_H    = 34,
        TAB_TS   = 13,
        TITLE_TS = 15,
        SUB_TS   = 11,
        PAD      = 14,
        BTN_SZ   = 14,
        BTN_GAP  = 20,
        SEC_HDR  = 38,
        CORNER   = 10,
        SEC_COR  = 8,
    }

    -- ─── Responsive Config Builder ────────────────────────────────────────────
    -- Deteksi mobile: touch enabled tanpa mouse (perangkat sentuh murni)
    -- Lalu scale semua dimensi proporsional terhadap ukuran layar aktual.
    local function buildConfig()
        local isMobile = UserInputService.TouchEnabled
                      and not UserInputService.MouseEnabled

        if not isMobile then
            -- Desktop: kembalikan nilai base persis
            local D = {}
            for k, v in pairs(BASE) do D[k] = v end
            D.isMobile = false
            return D
        end

        -- Hitung scale factor dari viewport vs. desain base
        local vp    = workspace.CurrentCamera.ViewportSize
        local scale = math.clamp(
            math.min(vp.X / BASE.WIN_W, vp.Y / BASE.WIN_H) * 0.90,
            0.62, -- minimum 62% agar elemen tetap terbaca
            1.00
        )

        local function sc(v) return math.round(v * scale) end

        return {
            WIN_W    = sc(BASE.WIN_W),
            WIN_H    = sc(BASE.WIN_H),
            SIDEBAR  = sc(BASE.SIDEBAR),
            TOPBAR_H = sc(BASE.TOPBAR_H),
            HDR_H    = sc(BASE.HDR_H),
            TAB_H    = sc(BASE.TAB_H),
            TAB_TS   = sc(BASE.TAB_TS),
            TITLE_TS = sc(BASE.TITLE_TS),
            SUB_TS   = sc(BASE.SUB_TS),
            PAD      = sc(BASE.PAD),
            BTN_SZ   = math.max(sc(BASE.BTN_SZ), 10), -- minimum tap target
            BTN_GAP  = sc(BASE.BTN_GAP),
            SEC_HDR  = sc(BASE.SEC_HDR),
            CORNER   = sc(BASE.CORNER),
            SEC_COR  = sc(BASE.SEC_COR),
            isMobile = true,
        }
    end

    -- ─── Internal Helpers ─────────────────────────────────────────────────────
    local function attachElements(Sec, items)
        for _, attach in ipairs(elemAttachers) do
            attach(Sec, items)
        end
    end

    -- ─── Window Constructor ───────────────────────────────────────────────────
    function Library:Window(cfg)
        cfg = cfg or {}
        local title     = cfg.Title    or "RezaLib"
        local subtitle  = cfg.SubTitle or ""
        local toggleKey = cfg.KeyBind  or Enum.KeyCode.RightShift

        local D   = buildConfig()
        local gui = self:_gui_root()

        -- ── Root Frame ────────────────────────────────────────────────────────
        local root = U.New("Frame", {
            Name             = "Window",
            AnchorPoint      = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Theme.Window,
            BorderSizePixel  = 0,
            Position         = UDim2.new(0.5, 0, 0.5, 0),
            Size             = UDim2.new(0, D.WIN_W, 0, D.WIN_H),
            ClipsDescendants = true,
            ZIndex           = 10,
            Parent           = gui,
        })
        U.Corner(root, D.CORNER)
        U.Stroke(root, Theme.Border, 1)
        U.Shadow(root, 44, 0.44)

        U.New("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 36)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 24)),
            }),
            Rotation = 125,
            Parent   = root,
        })

        -- ── Sidebar ───────────────────────────────────────────────────────────
        local sidebar = U.New("Frame", {
            Name             = "Sidebar",
            BackgroundColor3 = Theme.Sidebar,
            BorderSizePixel  = 0,
            Position         = UDim2.new(0, 0, 0, 0),
            Size             = UDim2.new(0, D.SIDEBAR, 1, 0),
            ZIndex           = 11,
            Parent           = root,
        })

        -- Garis pembatas kanan sidebar
        U.New("Frame", {
            BackgroundColor3 = Theme.Border,
            BorderSizePixel  = 0,
            Position         = UDim2.new(1, -1, 0, 0),
            Size             = UDim2.new(0, 1, 1, 0),
            ZIndex           = 12,
            Parent           = sidebar,
        })

        -- ── Sidebar Header (judul + subtitle + drag handle) ───────────────────
        local sideHeader = U.New("Frame", {
            Name                   = "Header",
            BackgroundTransparency = 1,
            Size                   = UDim2.new(1, 0, 0, D.HDR_H),
            ZIndex                 = 12,
            Parent                 = sidebar,
        })

        -- Aksen vertikal kiri judul
        U.New("Frame", {
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel  = 0,
            Position         = UDim2.new(0, 10, 0, 13),
            Size             = UDim2.new(0, 3, 0, D.TITLE_TS + 2),
            ZIndex           = 14,
            Parent           = sideHeader,
        })

        U.New("TextLabel", {
            BackgroundTransparency = 1,
            Position       = UDim2.new(0, 18, 0, 12),
            Size           = UDim2.new(1, -18, 0, D.TITLE_TS + 6),
            Text           = title,
            Font           = Enum.Font.GothamBold,
            TextSize       = D.TITLE_TS,
            TextColor3     = Theme.TextPrimary,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex         = 13,
            Parent         = sideHeader,
        })

        if subtitle ~= "" then
            U.New("TextLabel", {
                BackgroundTransparency = 1,
                Position       = UDim2.new(0, 18, 0, 12 + D.TITLE_TS + 8),
                Size           = UDim2.new(1, -18, 0, D.SUB_TS + 4),
                Text           = subtitle,
                Font           = Enum.Font.Gotham,
                TextSize       = D.SUB_TS,
                TextColor3     = Theme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex         = 13,
                Parent         = sideHeader,
            })
        end

        -- Garis bawah header
        U.New("Frame", {
            BackgroundColor3 = Theme.Border,
            BorderSizePixel  = 0,
            Position         = UDim2.new(0, 10, 1, -1),
            Size             = UDim2.new(1, -20, 0, 1),
            ZIndex           = 12,
            Parent           = sideHeader,
        })

        -- ── Tab List (scrollable) ─────────────────────────────────────────────
        local tabList = U.New("ScrollingFrame", {
            Name                   = "TabList",
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            Position               = UDim2.new(0, 0, 0, D.HDR_H),
            Size                   = UDim2.new(1, 0, 1, -(D.HDR_H + 8)),
            ScrollBarThickness     = 2,
            ScrollBarImageColor3   = Theme.Scrollbar,
            CanvasSize             = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize    = Enum.AutomaticSize.Y,
            ScrollingDirection     = Enum.ScrollingDirection.Y,
            ZIndex                 = 12,
            Parent                 = sidebar,
        })
        U.List(tabList, 2)
        U.Padding(tabList, 6, 8, 6, 8)

        -- ── Content Area (kanan sidebar) ──────────────────────────────────────
        local contentArea = U.New("Frame", {
            Name                   = "Content",
            BackgroundTransparency = 1,
            Position               = UDim2.new(0, D.SIDEBAR, 0, 0),
            Size                   = UDim2.new(1, -D.SIDEBAR, 1, 0),
            ZIndex                 = 11,
            Parent                 = root,
        })

        -- ── Top Bar (tombol kontrol) ───────────────────────────────────────────
        local topBar = U.New("Frame", {
            Name                   = "TopBar",
            BackgroundTransparency = 1,
            Size                   = UDim2.new(1, 0, 0, D.TOPBAR_H),
            ZIndex                 = 20,
            Parent                 = contentArea,
        })

        U.New("Frame", {
            BackgroundColor3 = Theme.Border,
            BorderSizePixel  = 0,
            Position         = UDim2.new(0, 0, 1, -1),
            Size             = UDim2.new(1, 0, 0, 1),
            ZIndex           = 21,
            Parent           = topBar,
        })

        -- Tombol close (merah)
        local btnClose = U.New("TextButton", {
            AnchorPoint            = Vector2.new(1, 0.5),
            BackgroundColor3       = Color3.fromRGB(255, 72, 72),
            BackgroundTransparency = 0.25,
            Position               = UDim2.new(1, -12, 0.5, 0),
            Size                   = UDim2.new(0, D.BTN_SZ, 0, D.BTN_SZ),
            Text                   = "",
            ZIndex                 = 22,
            Parent                 = topBar,
        })
        U.Corner(btnClose, 999)

        -- Tombol minimize (kuning)
        local btnMin = U.New("TextButton", {
            AnchorPoint            = Vector2.new(1, 0.5),
            BackgroundColor3       = Color3.fromRGB(255, 196, 0),
            BackgroundTransparency = 0.25,
            Position               = UDim2.new(1, -(12 + D.BTN_GAP), 0.5, 0),
            Size                   = UDim2.new(0, D.BTN_SZ, 0, D.BTN_SZ),
            Text                   = "",
            ZIndex                 = 22,
            Parent                 = topBar,
        })
        U.Corner(btnMin, 999)

        -- ── Pages Container (konten tab, di bawah topBar) ─────────────────────
        local pages = U.New("Frame", {
            Name                   = "Pages",
            BackgroundTransparency = 1,
            Position               = UDim2.new(0, 0, 0, D.TOPBAR_H),
            Size                   = UDim2.new(1, 0, 1, -D.TOPBAR_H),
            ClipsDescendants       = true,
            ZIndex                 = 12,
            Parent                 = contentArea,
        })

        -- ── Drag System (Mouse + Touch) ───────────────────────────────────────
        local dragging  = false
        local dragStart = nil
        local startPos  = nil

        local function onDragBegin(pos)
            dragging  = true
            dragStart = pos
            startPos  = root.Position
        end

        local function onDragMove(pos)
            if not dragging then return end
            local delta = pos - dragStart
            root.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end

        local function onDragEnd()
            dragging = false
        end

        self:_connect(sideHeader.InputBegan, function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                onDragBegin(inp.Position)
            end
        end)

        self:_connect(UserInputService.InputChanged, function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch then
                onDragMove(inp.Position)
            end
        end)

        self:_connect(UserInputService.InputEnded, function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                onDragEnd()
            end
        end)

        -- ── Toggle Visibility (keyboard) ──────────────────────────────────────
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
                }, 0.24)
            end
        end)

        -- ── Close Button ──────────────────────────────────────────────────────
        btnClose.MouseButton1Click:Connect(function()
            U.Tween(root, {
                Size                   = UDim2.new(0, D.WIN_W, 0, 0),
                BackgroundTransparency = 1,
            }, 0.2)
            task.wait(0.25)
            pcall(function() root:Destroy() end)
        end)

        -- ── Minimize Button ───────────────────────────────────────────────────
        local minimized = false
        btnMin.MouseButton1Click:Connect(function()
            minimized = not minimized
            U.Tween(root, {
                Size = minimized
                    and UDim2.new(0, D.WIN_W, 0, D.TOPBAR_H)
                    or  UDim2.new(0, D.WIN_W, 0, D.WIN_H),
            }, 0.22)
        end)

        -- Hover effect tombol kontrol
        for _, b in ipairs({ btnClose, btnMin }) do
            b.MouseEnter:Connect(function()
                U.Tween(b, { BackgroundTransparency = 0 }, 0.12)
            end)
            b.MouseLeave:Connect(function()
                U.Tween(b, { BackgroundTransparency = 0.25 }, 0.12)
            end)
        end

        -- ── Window Object ─────────────────────────────────────────────────────
        local Win = {}
        Win._tabs      = {}
        Win._activeTab = nil
        Win._root      = root

        function Win:Tab(tcfg)
            tcfg = tcfg or {}
            local name = tcfg.Name or ("Tab " .. #self._tabs + 1)

            -- Tombol tab di sidebar
            local btn = U.New("TextButton", {
                Name                   = name,
                BackgroundColor3       = Theme.Surface,
                BackgroundTransparency = 0,
                Size                   = UDim2.new(1, 0, 0, D.TAB_H),
                Text                   = "",
                ZIndex                 = 14,
                Parent                 = tabList,
            })
            U.Corner(btn, 7)

            local indicator = U.New("Frame", {
                BackgroundColor3       = Theme.Accent,
                BorderSizePixel        = 0,
                Position               = UDim2.new(0, 0, 0.15, 0),
                Size                   = UDim2.new(0, 3, 0.7, 0),
                BackgroundTransparency = 1,
                ZIndex                 = 15,
                Parent                 = btn,
            })
            U.Corner(indicator, 3)

            local btnLabel = U.New("TextLabel", {
                BackgroundTransparency = 1,
                Position       = UDim2.new(0, 14, 0, 0),
                Size           = UDim2.new(1, -14, 1, 0),
                Text           = name,
                Font           = Enum.Font.Gotham,
                TextSize       = D.TAB_TS,
                TextColor3     = Theme.TextSecond,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex         = 15,
                Parent         = btn,
            })

            -- Halaman konten tab (scrollable)
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
            U.Padding(page, D.PAD, D.PAD, D.PAD, D.PAD)

            local tabObj = {
                _btn       = btn,
                _page      = page,
                _indicator = indicator,
                _label     = btnLabel,
            }

            local function activate()
                for _, t in ipairs(Win._tabs) do
                    t._page.Visible = false
                    U.Tween(t._btn,       { BackgroundColor3 = Theme.Surface }, 0.15)
                    U.Tween(t._label,     { TextColor3 = Theme.TextSecond },    0.15)
                    U.Tween(t._indicator, { BackgroundTransparency = 1 },       0.15)
                    t._label.Font = Enum.Font.Gotham
                end
                page.Visible = true
                U.Tween(btn,       { BackgroundColor3 = Theme.SurfaceAlt }, 0.15)
                U.Tween(btnLabel,  { TextColor3 = Theme.TextPrimary },      0.15)
                U.Tween(indicator, { BackgroundTransparency = 0 },          0.15)
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

            -- ── Section Constructor ────────────────────────────────────────────
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
                U.Corner(container, D.SEC_COR)
                U.Stroke(container, Theme.Border, 1)

                local hasHeader = sname ~= ""

                if hasHeader then
                    local hdr = U.New("Frame", {
                        BackgroundTransparency = 1,
                        Size   = UDim2.new(1, 0, 0, D.SEC_HDR),
                        ZIndex = 15,
                        Parent = container,
                    })
                    -- Aksen vertikal kiri
                    U.New("Frame", {
                        BackgroundColor3 = Theme.Accent,
                        BorderSizePixel  = 0,
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
                    -- Garis bawah header section
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
                    Parent                 = container,
                })
                U.List(items, 1)
                U.Padding(items, 4, 12, 8, 12)

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
