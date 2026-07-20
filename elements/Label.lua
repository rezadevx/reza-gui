return function(Library, Theme, U)
 return function(Sec, items)
 function Sec:Label(c)
 c = c or {}
 local lname = c.Name or ""
 local lval = c.Value or ""

 local row = U.New("Frame", {
 Name = "Label",
 BackgroundColor3 = Theme.Surface,
 BackgroundTransparency = 0.45,
 Size = UDim2.new(1, 0, 0, 34),
 ZIndex = 16,
 Parent = items,
 })
 U.Corner(row, 7)
 U.Padding(row, 0, 12, 0, 12)

 local nameL = U.New("TextLabel", {
 BackgroundTransparency = 1,
 Size = UDim2.new(0.5, 0, 1, 0),
 Text = lname,
 Font = Enum.Font.GothamSemibold,
 TextSize = 13,
 TextColor3 = Theme.TextSecond,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 17,
 Parent = row,
 })

 local valL = U.New("TextLabel", {
 BackgroundTransparency = 1,
 AnchorPoint = Vector2.new(1, 0.5),
 Position = UDim2.new(1, 0, 0.5, 0),
 Size = UDim2.new(0.5, 0, 1, 0),
 Text = lval,
 Font = Enum.Font.Gotham,
 TextSize = 13,
 TextColor3 = Theme.TextPrimary,
 TextXAlignment = Enum.TextXAlignment.Right,
 ZIndex = 17,
 Parent = row,
 })

 local El = {}
 function El:SetName(n) nameL.Text = n end
 function El:SetValue(v) valL.Text = tostring(v) end
 return El
 end
 end
end
