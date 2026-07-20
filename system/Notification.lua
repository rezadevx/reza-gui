return function(Library, Theme, U)
 local NOTIF_ICON = {
 Success = "",
 Warning = "⚠",
 Error = "✕",
 Info = "ℹ",
 }
 local NOTIF_COLOR = {
 Success = Theme.Success,
 Warning = Theme.Warning,
 Error = Theme.Error,
 Info = Theme.Accent,
 }

 function Library:Notification(cfg)
 cfg = cfg or {}
 local title = cfg.Title or "Notification"
 local content = cfg.Content or ""
 local duration = cfg.Duration or 3
 local ntype = cfg.Type or "Info"

 self:_gui_root()

 local accent = NOTIF_COLOR[ntype] or Theme.Accent
 local icon = NOTIF_ICON[ntype] or "ℹ"
 local holder = self._notifHolder

 local card = U.New("Frame", {
 Name = "Notif",
 BackgroundColor3 = Theme.Surface,
 BackgroundTransparency = 1,
 AutomaticSize = Enum.AutomaticSize.Y,
 Size = UDim2.new(1, 0, 0, 0),
 ClipsDescendants = true,
 ZIndex = 999,
 Parent = holder,
 })
 U.Corner(card, 8)
 U.Stroke(card, Theme.Border, 1)

 U.New("Frame", {
 BackgroundColor3 = accent,
 Size = UDim2.new(0, 3, 1, 0),
 ZIndex = 1000,
 Parent = card,
 })

 local inner = U.New("Frame", {
 BackgroundTransparency = 1,
 Position = UDim2.new(0, 14, 0, 0),
 Size = UDim2.new(1, -14, 0, 0),
 AutomaticSize = Enum.AutomaticSize.Y,
 ZIndex = 1000,
 Parent = card,
 })
 U.List(inner, 3)
 U.Padding(inner, 10, 10, 10, 6)

 local hdr = U.New("Frame", {
 BackgroundTransparency = 1,
 Size = UDim2.new(1, 0, 0, 18),
 ZIndex = 1001,
 Parent = inner,
 })
 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Size = UDim2.new(0, 18, 1, 0),
 Text = icon,
 Font = Enum.Font.GothamBold,
 TextSize = 13,
 TextColor3 = accent,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 1002,
 Parent = hdr,
 })
 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Position = UDim2.new(0, 22, 0, 0),
 Size = UDim2.new(1, -22, 1, 0),
 Text = title,
 Font = Enum.Font.GothamBold,
 TextSize = 13,
 TextColor3 = Theme.TextPrimary,
 TextXAlignment = Enum.TextXAlignment.Left,
 ZIndex = 1002,
 Parent = hdr,
 })

 if content ~= "" then
 U.New("TextLabel", {
 BackgroundTransparency = 1,
 Size = UDim2.new(1, 0, 0, 0),
 AutomaticSize = Enum.AutomaticSize.Y,
 Text = content,
 Font = Enum.Font.Gotham,
 TextSize = 12,
 TextColor3 = Theme.TextSecond,
 TextXAlignment = Enum.TextXAlignment.Left,
 TextWrapped = true,
 ZIndex = 1002,
 Parent = inner,
 })
 end

 local progBG = U.New("Frame", {
 BackgroundColor3 = Theme.SurfaceAlt,
 Size = UDim2.new(1, 0, 0, 2),
 ZIndex = 1002,
 Parent = inner,
 })
 local prog = U.New("Frame", {
 BackgroundColor3 = accent,
 Size = UDim2.new(1, 0, 1, 0),
 ZIndex = 1003,
 Parent = progBG,
 })

 U.Tween(card, { BackgroundTransparency = 0 }, 0.22)
 U.Tween(prog, { Size = UDim2.new(0, 0, 1, 0) }, duration, Enum.EasingStyle.Linear)

 task.delay(duration, function()
 U.Tween(card, { BackgroundTransparency = 1 }, 0.22)
 task.wait(0.25)
 pcall(function() card:Destroy() end)
 end)

 return card
 end
end
