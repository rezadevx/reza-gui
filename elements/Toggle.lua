return function(Library, Theme, U)
    return function(Sec, items)
        function Sec:Toggle(c)
            c = c or {}
            local tname = c.Name        or "Toggle"
            local tdesc = c.Description or ""
            local tdef  = c.Default     or false
            local flag  = c.Flag        or tname
            local tcb   = c.Callback    or function() end
            local state = tdef

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
                Position         = state and UDim2.new(0, 20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
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
    end
end
