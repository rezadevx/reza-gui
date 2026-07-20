return function(Library, Theme, U)
 local UIS = game:GetService("UserInputService")
 return function(Sec, items)
 function Sec:Button(c)
 c = c or {}
 local bname = c.Name or "Button"
 local bdesc = c.Description or ""
 local bcb = c.Callback or function() end

 local h = bdesc ~= "" and 50 or 36

 local row = U.New("TextButton", {
 Name = bname,
 BackgroundColor3 = Theme.SurfaceAlt,
 Size = UDim2.new(1, 0, 0, h),
 Text = "",
 ZIndex = 16,
 ClipsDescendants = true,
 Parent = items,
 })
 U.Corner(row, 7)

 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Position = UDim2.new(0, 12, 0, bdesc ~= "" and 8 or 0),
 Size = UDim2.new(1, -52, 0, 18),
 Text = bname,
 Font = Enum.Font.GothamSemibold,
 TextSize = 13,
 TextColor3 = Theme.TextPrimary,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 17,
 Parent = row,
 })

 if bdesc ~= "" then
 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Position = UDim2.new(0, 12, 0, 28),
 Size = UDim2.new(1, -52, 0, 14),
 Text = bdesc,
 Font = Enum.Font.Gotham,
 TextSize = 11,
 TextColor3 = Theme.TextSecond,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 17,
 Parent = row,
 })
 end

 U.New("TextLabel", {
 BackgroundTransparency = 1,
 AnchorPoint = Vector2.new(1, 0.5),
 Position = UDim2.new(1, -12, 0.5, 0),
 Size = UDim2.new(0, 16, 0, 16),
 Text = "›",
 Font = Enum.Font.GothamBold,
 TextSize = 20,
 TextColor3 = Theme.TextDim,
 ZIndex = 17,
 Parent = row,
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
 local pos = UIS:GetMouseLocation()
 U.Ripple(row, pos.X, pos.Y)
 pcall(bcb)
 end)

 local El = {}
 function El:SetName(n)
 row:FindFirstChildWhichIsA("TextLabel").Text = n
 end
 return El
 end
 end
end
