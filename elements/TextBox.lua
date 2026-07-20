return function(Library, Theme, U)
 return function(Sec, items)
 function Sec:TextBox(c)
 c = c or {}
 local tbname = c.Name or "TextBox"
 local tbdesc = c.Description or ""
 local tbdef = c.Default or ""
 local tbph = c.Placeholder or "Enter value..."
 local flag = c.Flag or tbname
 local tbcb = c.Callback or function() end

 Library.Flags[flag] = tbdef

 local h = tbdesc ~= "" and 60 or 46

 local row = U.New("Frame", {
 Name = tbname,
 BackgroundColor3 = Theme.SurfaceAlt,
 Size = UDim2.new(1, 0, 0, h),
 ZIndex = 16,
 Parent = items,
 })
 U.Corner(row, 7)
 U.Padding(row, 8, 12, 8, 12)

 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Size = UDim2.new(1, 0, 0, 18),
 Text = tbname,
 Font = Enum.Font.GothamSemibold,
 TextSize = 13,
 TextColor3 = Theme.TextPrimary,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 17,
 Parent = row,
 })

 if tbdesc ~= "" then
 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Position = UDim2.new(0, 0, 0, 20),
 Size = UDim2.new(1, 0, 0, 13),
 Text = tbdesc,
 Font = Enum.Font.Gotham,
 TextSize = 11,
 TextColor3 = Theme.TextSecond,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 17,
 Parent = row,
 })
 end

 local inputY = tbdesc ~= "" and 36 or 24
 local inputFrame = U.New("Frame", {
 BackgroundColor3 = Theme.InputBG,
 Position = UDim2.new(0, 0, 0, inputY),
 Size = UDim2.new(1, 0, 0, 28),
 ZIndex = 17,
 Parent = row,
 })
 U.Corner(inputFrame, 6)
 local stroke = U.Stroke(inputFrame, Theme.Border)

 local input = U.New("TextBox", {
 BackgroundTransparency = 1,
 ClearTextOnFocus = false,
 Font = Enum.Font.Gotham,
 PlaceholderColor3 = Theme.Placeholder,
 PlaceholderText = tbph,
 Text = tbdef,
 TextColor3 = Theme.TextPrimary,
 TextSize = 12,
 TextXAlignment = Enum.TextXAlignment.Left,
 Size = UDim2.new(1, 0, 1, 0),
 ZIndex = 18,
 Parent = inputFrame,
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
 end
end
