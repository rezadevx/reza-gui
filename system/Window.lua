return function(Library, Svc, Theme, U, elemAttachers)
 local UserInputService = Svc.UserInputService

 local WIN_W = 564
 local WIN_H = 386
 local SIDEBAR_W = 150

 local function attachElements(Sec, items)
 for _, attach in ipairs(elemAttachers) do
 attach(Sec, items)
 end
 end

 function Library:Window(cfg)
 cfg = cfg or {}
 local title = cfg.Title or "RezaLib"
 local subtitle = cfg.SubTitle or ""
 local toggleKey = cfg.KeyBind or Enum.KeyCode.RightShift

 local gui = self:_gui_root()

 local root = U.New("Frame", {
 Name = "Window",
 AnchorPoint = Vector2.new(0.5, 0.5),
 BackgroundColor3 = Theme.Window,
 BorderSizePixel = 0,
 Position = UDim2.new(0.5, 0, 0.5, 0),
 Size = UDim2.new(0, WIN_W, 0, WIN_H),
 ClipsDescendants = true,
 ZIndex = 10,
 Parent = gui,
 })
 U.Corner(root, 10)
 U.Stroke(root, Theme.Border, 1)
 U.Shadow(root, 44, 0.44)

 U.New("UIGradient", {
 Color = ColorSequence.new({
 ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 36)),
 ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 24)),
 }),
 Rotation = 125,
 Parent = root,
 })

 local sidebar = U.New("Frame", {
 Name = "Sidebar",
 BackgroundColor3 = Theme.Sidebar,
 BorderSizePixel = 0,
 Size = UDim2.new(0, SIDEBAR_W, 1, 0),
 ZIndex = 11,
 Parent = root,
 })

 U.New("Frame", {
 BackgroundColor3 = Theme.Border,
 BorderSizePixel = 0,
 Position = UDim2.new(1, -1, 0, 0),
 Size = UDim2.new(0, 1, 1, 0),
 ZIndex = 12,
 Parent = sidebar,
 })

 local sideHeader = U.New("Frame", {
 Name = "Header",
 BackgroundTransparency = 1,
 Size = UDim2.new(1, 0, 0, 68),
 ZIndex = 12,
 Parent = sidebar,
 })

 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Position = UDim2.new(0, 14, 0, 14),
 Size = UDim2.new(1, -14, 0, 22),
 Text = title,
 Font = Enum.Font.GothamBold,
 TextSize = 15,
 TextColor3 = Theme.TextPrimary,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 13,
 Parent = sideHeader,
 })

 if subtitle ~= "" then
 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Position = UDim2.new(0, 14, 0, 37),
 Size = UDim2.new(1, -14, 0, 14),
 Text = subtitle,
 Font = Enum.Font.Gotham,
 TextSize = 11,
 TextColor3 = Theme.TextDim,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 13,
 Parent = sideHeader,
 })
 end

 U.New("Frame", {
 BackgroundColor3 = Theme.Border,
 BorderSizePixel = 0,
 Position = UDim2.new(0, 12, 0, 67),
 Size = UDim2.new(1, -24, 0, 1),
 ZIndex = 12,
 Parent = sidebar,
 })

 local tabList = U.New("ScrollingFrame", {
 Name = "TabList",
 BackgroundTransparency = 1,
 BorderSizePixel = 0,
 Position = UDim2.new(0, 0, 0, 76),
 Size = UDim2.new(1, 0, 1, -92),
 ScrollBarThickness = 2,
 ScrollBarImageColor3 = Theme.Scrollbar,
 CanvasSize = UDim2.new(0, 0, 0, 0),
 AutomaticCanvasSize = Enum.AutomaticSize.Y,
 ScrollingDirection = Enum.ScrollingDirection.Y,
 ZIndex = 12,
 Parent = sidebar,
 })
 U.List(tabList, 2)
 U.Padding(tabList, 4, 8, 4, 8)

 local contentArea = U.New("Frame", {
 Name = "Content",
 BackgroundTransparency = 1,
 Position = UDim2.new(0, SIDEBAR_W, 0, 0),
 Size = UDim2.new(1, -SIDEBAR_W, 1, 0),
 ZIndex = 11,
 Parent = root,
 })

 local btnClose = U.New("TextButton", {
 AnchorPoint = Vector2.new(1, 0),
 BackgroundColor3 = Color3.fromRGB(255, 72, 72),
 BackgroundTransparency = 0.25,
 Position = UDim2.new(1, -10, 0, 10),
 Size = UDim2.new(0, 14, 0, 14),
 Text = "",
 ZIndex = 20,
 Parent = contentArea,
 })
 U.Corner(btnClose, 999)

 local btnMin = U.New("TextButton", {
 AnchorPoint = Vector2.new(1, 0),
 BackgroundColor3 = Color3.fromRGB(255, 196, 0),
 BackgroundTransparency = 0.25,
 Position = UDim2.new(1, -30, 0, 10),
 Size = UDim2.new(0, 14, 0, 14),
 Text = "",
 ZIndex = 20,
 Parent = contentArea,
 })
 U.Corner(btnMin, 999)

 local pages = U.New("Frame", {
 Name = "Pages",
 BackgroundTransparency = 1,
 Size = UDim2.new(1, 0, 1, 0),
 ClipsDescendants = true,
 ZIndex = 12,
 Parent = contentArea,
 })

 local dragging, dragStart, startPos = false, nil, nil

 self:_connect(sideHeader.InputBegan, function(inp)
 if inp.UserInputType == Enum.UserInputType.MouseButton1 then
 dragging = true
 dragStart = inp.Position
 startPos = root.Position
 end
 end)
 self:_connect(UserInputService.InputChanged, function(inp)
 if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
 local d = inp.Position - dragStart
 root.Position = UDim2.new(
 startPos.X.Scale, startPos.X.Offset + d.X,
 startPos.Y.Scale, startPos.Y.Offset + d.Y
 )
 end
 end)
 self:_connect(UserInputService.InputEnded, function(inp)
 if inp.UserInputType == Enum.UserInputType.MouseButton1 then
 dragging = false
 end
 end)

 local uiVisible = true
 self:_connect(UserInputService.InputBegan, function(inp, processed)
 if processed then return end
 if inp.KeyCode == toggleKey then
 uiVisible = not uiVisible
 U.Tween(root, {
 Size = uiVisible
 and UDim2.new(0, WIN_W, 0, WIN_H)
 or UDim2.new(0, WIN_W, 0, 0),
 BackgroundTransparency = uiVisible and 0 or 1,
 }, 0.24)
 end
 end)

 btnClose.MouseButton1Click:Connect(function()
 U.Tween(root, { Size = UDim2.new(0, WIN_W, 0, 0), BackgroundTransparency = 1 }, 0.2)
 task.wait(0.25)
 pcall(function() root:Destroy() end)
 end)

 local minimized = false
 btnMin.MouseButton1Click:Connect(function()
 minimized = not minimized
 U.Tween(root, {
 Size = minimized
 and UDim2.new(0, WIN_W, 0, 38)
 or UDim2.new(0, WIN_W, 0, WIN_H),
 }, 0.22)
 end)

 for _, b in ipairs({ btnClose, btnMin }) do
 b.MouseEnter:Connect(function()
 U.Tween(b, { BackgroundTransparency = 0 }, 0.12)
 end)
 b.MouseLeave:Connect(function()
 U.Tween(b, { BackgroundTransparency = 0.25 }, 0.12)
 end)
 end

 local Win = {}
 Win._tabs = {}
 Win._activeTab = nil
 Win._root = root

 function Win:Tab(tcfg)
 tcfg = tcfg or {}
 local name = tcfg.Name or ("Tab " .. self._tabs + 1)

 local btn = U.New("TextButton", {
 Name = name,
 BackgroundColor3 = Theme.Surface,
 BackgroundTransparency = 0,
 Size = UDim2.new(1, 0, 0, 34),
 Text = "",
 ZIndex = 14,
 Parent = tabList,
 })
 U.Corner(btn, 7)

 local indicator = U.New("Frame", {
 BackgroundColor3 = Theme.Accent,
 BorderSizePixel = 0,
 Position = UDim2.new(0, 0, 0.15, 0),
 Size = UDim2.new(0, 3, 0.7, 0),
 BackgroundTransparency = 1,
 ZIndex = 15,
 Parent = btn,
 })
 U.Corner(indicator, 3)

 local btnLabel = U.New("TextLabel", {
 BackgroundTransparency = 1,
 Position = UDim2.new(0, 14, 0, 0),
 Size = UDim2.new(1, -14, 1, 0),
 Text = name,
 Font = Enum.Font.Gotham,
 TextSize = 13,
 TextColor3 = Theme.TextSecond,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 15,
 Parent = btn,
 })

 local page = U.New("ScrollingFrame", {
 Name = name .. "_Page",
 BackgroundTransparency = 1,
 BorderSizePixel = 0,
 Position = UDim2.new(0, 0, 0, 0),
 Size = UDim2.new(1, 0, 1, 0),
 ScrollBarThickness = 2,
 ScrollBarImageColor3 = Theme.Scrollbar,
 CanvasSize = UDim2.new(0, 0, 0, 0),
 AutomaticCanvasSize = Enum.AutomaticSize.Y,
 ScrollingDirection = Enum.ScrollingDirection.Y,
 Visible = false,
 ZIndex = 13,
 Parent = pages,
 })
 U.List(page, 6)
 U.Padding(page, 14, 14, 14, 14)

 local tabObj = {
 _btn = btn,
 _page = page,
 _indicator = indicator,
 _label = btnLabel,
 }

 local function activate()
 for _, t in ipairs(Win._tabs) do
 t._page.Visible = false
 U.Tween(t._btn, { BackgroundColor3 = Theme.Surface }, 0.15)
 U.Tween(t._label, { TextColor3 = Theme.TextSecond }, 0.15)
 U.Tween(t._indicator, { BackgroundTransparency = 1 }, 0.15)
 t._label.Font = Enum.Font.Gotham
 end
 page.Visible = true
 U.Tween(btn, { BackgroundColor3 = Theme.SurfaceAlt }, 0.15)
 U.Tween(btnLabel, { TextColor3 = Theme.TextPrimary }, 0.15)
 U.Tween(indicator, { BackgroundTransparency = 0 }, 0.15)
 btnLabel.Font = Enum.Font.GothamBold
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
 if Win._tabs == 1 then activate() end

 function tabObj:Section(scfg)
 scfg = scfg or {}
 local sname = scfg.Name or ""

 local container = U.New("Frame", {
 Name = "Section_" .. sname,
 BackgroundColor3 = Theme.Surface,
 Size = UDim2.new(1, 0, 0, 0),
 AutomaticSize = Enum.AutomaticSize.Y,
 ZIndex = 14,
 Parent = page,
 })
 U.Corner(container, 8)
 U.Stroke(container, Theme.Border, 1)

 local hasHeader = sname ~= ""

 if hasHeader then
 local hdr = U.New("Frame", {
 BackgroundTransparency = 1,
 Size = UDim2.new(1, 0, 0, 38),
 ZIndex = 15,
 Parent = container,
 })
 U.New("Frame", {
 BackgroundColor3 = Theme.Accent,
 Position = UDim2.new(0, 14, 0.5, -4),
 Size = UDim2.new(0, 4, 0, 8),
 ZIndex = 16,
 Parent = hdr,
 })
 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Position = UDim2.new(0, 24, 0, 0),
 Size = UDim2.new(1, -24, 1, 0),
 Text = sname,
 Font = Enum.Font.GothamBold,
 TextSize = 12,
 TextColor3 = Theme.TextSecond,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 16,
 Parent = hdr,
 })
 U.New("Frame", {
 BackgroundColor3 = Theme.Border,
 BorderSizePixel = 0,
 Position = UDim2.new(0, 0, 1, -1),
 Size = UDim2.new(1, 0, 0, 1),
 ZIndex = 15,
 Parent = hdr,
 })
 end

 local items = U.New("Frame", {
 Name = "Items",
 BackgroundTransparency = 1,
 Position = UDim2.new(0, 0, 0, hasHeader and 38 or 0),
 Size = UDim2.new(1, 0, 0, 0),
 AutomaticSize = Enum.AutomaticSize.Y,
 ZIndex = 15,
 Parent = container,
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
