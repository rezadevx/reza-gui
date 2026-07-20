return function(Library, Theme, U)
 return function(Sec, items)
 function Sec:Divider()
 U.New("Frame", {
 BackgroundColor3 = Theme.Border,
 BorderSizePixel = 0,
 Size = UDim2.new(1, 0, 0, 1),
 BackgroundTransparency = 0.35,
 ZIndex = 16,
 Parent = items,
 })
 end
 end
end
