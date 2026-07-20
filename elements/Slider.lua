return function(Library, Theme, U)
 return function(Sec, items)
 function Sec:Slider(c)
 c = c or {}
 local sname = c.Name or "Slider"
 local sdesc = c.Description or ""
 local smin = c.Minimum or 0
 local smax = c.Maximum or 100
 local sdef = math.clamp(c.Default or smin, smin, smax)
 local sinc = c.Increment or 1
 local suffix = c.Suffix or ""
 local flag = c.Flag or sname
 local scb = c.Callback or function() end
 local value = sdef

 Library.Flags[flag] = value

 local function snap(v)
 return math.clamp(
 math.round((v - smin) / sinc) * sinc + smin,
 smin, smax
 )
 end

 local h = sdesc ~= "" and 60 or 50

 local row = U.New("Frame", {
 Name = sname,
 BackgroundColor3 = Theme.SurfaceAlt,
 Size = UDim2.new(1, 0, 0, h),
 ZIndex = 16,
 Parent = items,
 })
 U.Corner(row, 7)
 U.Padding(row, 10, 12, 10, 12)

 local topRow = U.New("Frame", {
 BackgroundTransparency = 1,
 Size = UDim2.new(1, 0, 0, 18),
 ZIndex = 17,
 Parent = row,
 })
 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Size = UDim2.new(0.65, 0, 1, 0),
 Text = sname,
 Font = Enum.Font.GothamSemibold,
 TextSize = 13,
 TextColor3 = Theme.TextPrimary,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 18,
 Parent = topRow,
 })
 local valLabel = U.New("TextLabel", {
 BackgroundTransparency = 1,
 AnchorPoint = Vector2.new(1, 0),
 Position = UDim2.new(1, 0, 0, 0),
 Size = UDim2.new(0.35, 0, 1, 0),
 Text = tostring(value) .. suffix,
 Font = Enum.Font.GothamBold,
 TextSize = 13,
 TextColor3 = Theme.TextAccent,
 TextXAlignment = Enum.TextXAlignment.Right,
 ZIndex = 18,
 Parent = topRow,
 })

 if sdesc ~= "" then
 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Position = UDim2.new(0, 0, 0, 20),
 Size = UDim2.new(1, 0, 0, 13),
 Text = sdesc,
 Font = Enum.Font.Gotham,
 TextSize = 11,
 TextColor3 = Theme.TextSecond,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 18,
 Parent = row,
 })
 end

 local trackY = sdesc ~= "" and 40 or 30
 local track = U.New("Frame", {
 BackgroundColor3 = Theme.SliderTrack,
 Position = UDim2.new(0, 0, 0, trackY),
 Size = UDim2.new(1, 0, 0, 6),
 ZIndex = 17,
 Parent = row,
 })
 U.Corner(track, 3)

 local pct0 = (value - smin) / (smax - smin)
 local fill = U.New("Frame", {
 BackgroundColor3 = Theme.SliderFill,
 Size = UDim2.new(pct0, 0, 1, 0),
 ZIndex = 18,
 Parent = track,
 })
 U.Corner(fill, 3)

 local knob = U.New("Frame", {
 AnchorPoint = Vector2.new(0.5, 0.5),
 BackgroundColor3 = Color3.fromRGB(255, 255, 255),
 Position = UDim2.new(pct0, 0, 0.5, 0),
 Size = UDim2.new(0, 14, 0, 14),
 ZIndex = 19,
 Parent = track,
 })
 U.Corner(knob, 999)
 U.New("UIStroke", { Color = Theme.SliderFill, Thickness = 2, Parent = knob })

 local function setValue(raw, fire)
 value = snap(raw)
 Library.Flags[flag] = value
 local p = (value - smin) / (smax - smin)
 fill.Size = UDim2.new(p, 0, 1, 0)
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
 Library:_connect(game:GetService("UserInputService").InputChanged, function(inp)
 if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
 local rel = math.clamp(
 (inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X,
 0, 1
 )
 setValue(smin + rel * (smax - smin), true)
 end
 end)
 Library:_connect(game:GetService("UserInputService").InputEnded, function(inp)
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
 end
end
