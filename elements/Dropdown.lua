return function(Library, Theme, U)
    return function(Sec, items)
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
                        BackgroundColor3       = isActive and Theme.SurfaceAlt or Color3.fromRGB(0, 0, 0),
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
                        if opt ~= selected then
                            U.Tween(optBtn, { BackgroundTransparency = 0, BackgroundColor3 = Theme.SurfaceHover }, 0.1)
                        end
                    end)
                    optBtn.MouseLeave:Connect(function()
                        if opt ~= selected then
                            U.Tween(optBtn, { BackgroundTransparency = 1 }, 0.1)
                        end
                    end)
                    optBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        selLabel.Text = opt
                        Library.Flags[flag] = opt
                        open = false
                        U.Tween(arrow, { Rotation = 0 }, 0.18)
                        U.Tween(listFrame, { Size = UDim2.new(1, 0, 0, 0) }, 0.16)
                        task.delay(0.18, function()
                            if not open then listFrame.Visible = false end
                        end)
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
    end
end
