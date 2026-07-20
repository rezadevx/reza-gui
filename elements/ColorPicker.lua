return function(Library, Theme, U)
    return function(Sec, items)
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
                Library:_connect(game:GetService("UserInputService").InputChanged, function(inp)
                    if sl and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = math.clamp(
                            (inp.Position.X - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1
                        )
                        fl.Size = UDim2.new(rel, 0, 1, 0)
                        setter(rel); updateColor()
                    end
                end)
                Library:_connect(game:GetService("UserInputService").InputEnded, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then sl = false end
                end)
            end

            preview.MouseButton1Click:Connect(function()
                pickerOpen = not pickerOpen
                if pickerOpen then
                    picker:ClearAllChildren()
                    U.Padding(picker, 8, 8, 8, 8)
                    makeHsvSlider(picker, "H",  0, h, function(val) h = val end)
                    makeHsvSlider(picker, "S", 26, s, function(val) s = val end)
                    makeHsvSlider(picker, "V", 52, v, function(val) v = val end)
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
    end
end
