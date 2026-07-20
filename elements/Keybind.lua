return function(Library, Theme, U)
 return function(Sec, items)
 function Sec:Keybind(c)
 c = c or {}
 local kname = c.Name or "Keybind"
 local kdef = c.Default or Enum.KeyCode.Unknown
 local flag = c.Flag or kname
 local kcb = c.Callback or function() end
 local bound = kdef
 local binding = false

 Library.Flags[flag] = bound

 local row = U.New("Frame", {
 Name = kname,
 BackgroundColor3 = Theme.SurfaceAlt,
 Size = UDim2.new(1, 0, 0, 36),
 ZIndex = 16,
 Parent = items,
 })
 U.Corner(row, 7)
 U.Padding(row, 0, 12, 0, 12)

 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Size = UDim2.new(0.58, 0, 1, 0),
 Text = kname,
 Font = Enum.Font.GothamSemibold,
 TextSize = 13,
 TextColor3 = Theme.TextPrimary,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 17,
 Parent = row,
 })

 local keyBtn = U.New("TextButton", {
 AnchorPoint = Vector2.new(1, 0.5),
 BackgroundColor3 = Theme.InputBG,
 Position = UDim2.new(1, 0, 0.5, 0),
 Size = UDim2.new(0, 76, 0, 22),
 Text = bound.Name,
 Font = Enum.Font.GothamBold,
 TextSize = 11,
 TextColor3 = Theme.TextAccent,
 ZIndex = 17,
 Parent = row,
 })
 U.Corner(keyBtn, 5)
 U.Stroke(keyBtn, Theme.Border)

 keyBtn.MouseButton1Click:Connect(function()
 binding = true
 keyBtn.Text = "..."
 keyBtn.TextColor3 = Theme.Warning
 end)

 Library:_connect(game:GetService("UserInputService").InputBegan, function(inp, proc)
 if binding then
 if inp.UserInputType == Enum.UserInputType.Keyboard then
 binding = false
 if inp.KeyCode == Enum.KeyCode.Escape then
 keyBtn.Text = bound.Name
 keyBtn.TextColor3 = Theme.TextAccent
 else
 bound = inp.KeyCode
 Library.Flags[flag] = bound
 keyBtn.Text = bound.Name
 keyBtn.TextColor3 = Theme.TextAccent
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
 end
end
