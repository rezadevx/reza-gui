return function(Svc, Theme)
    local TweenService = Svc.TweenService
    local Debris       = Svc.Debris

    local U = {}

    local function ti(d, s, dir)
        return TweenInfo.new(
            d   or 0.18,
            s   or Enum.EasingStyle.Quart,
            dir or Enum.EasingDirection.Out
        )
    end

    function U.Tween(obj, props, dur, style, dir)
        local t = TweenService:Create(obj, ti(dur, style, dir), props)
        t:Play()
        return t
    end

    function U.New(class, props, children)
        local inst = Instance.new(class)
        for k, v in next, props or {} do
            if k ~= "Parent" then inst[k] = v end
        end
        for _, child in next, children or {} do
            child.Parent = inst
        end
        if props and props.Parent then
            inst.Parent = props.Parent
        end
        return inst
    end

    function U.Corner(parent, radius)
        return U.New("UICorner", {
            CornerRadius = UDim.new(0, radius or 6),
            Parent       = parent,
        })
    end

    function U.Stroke(parent, color, thickness)
        return U.New("UIStroke", {
            Color           = color     or Theme.Border,
            Thickness       = thickness or 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Parent          = parent,
        })
    end

    function U.Padding(parent, top, right, bottom, left)
        return U.New("UIPadding", {
            PaddingTop    = UDim.new(0, top    or 8),
            PaddingRight  = UDim.new(0, right  or 8),
            PaddingBottom = UDim.new(0, bottom or 8),
            PaddingLeft   = UDim.new(0, left   or 8),
            Parent        = parent,
        })
    end

    function U.List(parent, spacing, direction, halign, valign)
        return U.New("UIListLayout", {
            Padding             = UDim.new(0, spacing or 4),
            FillDirection       = direction or Enum.FillDirection.Vertical,
            HorizontalAlignment = halign    or Enum.HorizontalAlignment.Left,
            VerticalAlignment   = valign    or Enum.VerticalAlignment.Top,
            SortOrder           = Enum.SortOrder.LayoutOrder,
            Parent              = parent,
        })
    end

    function U.Shadow(parent, spread, transparency)
        return U.New("ImageLabel", {
            Name                   = "_Shadow",
            AnchorPoint            = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position               = UDim2.new(0.5, 0, 0.5, 6),
            Size                   = UDim2.new(1, spread or 36, 1, spread or 36),
            ZIndex                 = math.max(1, (parent.ZIndex or 1) - 1),
            Image                  = "rbxassetid://6015897843",
            ImageColor3            = Color3.fromRGB(0, 0, 0),
            ImageTransparency      = transparency or 0.5,
            ScaleType              = Enum.ScaleType.Slice,
            SliceCenter            = Rect.new(49, 49, 450, 450),
            Parent                 = parent.Parent,
        })
    end

    function U.Ripple(btn, mx, my)
        local ox = mx - btn.AbsolutePosition.X
        local oy = my - btn.AbsolutePosition.Y
        local sz = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.4
        local r  = U.New("Frame", {
            BackgroundColor3       = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.80,
            Position               = UDim2.new(0, ox - 4, 0, oy - 4),
            Size                   = UDim2.new(0, 8, 0, 8),
            ZIndex                 = (btn.ZIndex or 1) + 20,
            ClipsDescendants       = false,
            Parent                 = btn,
        })
        U.Corner(r, 999)
        U.Tween(r, {
            Size                   = UDim2.new(0, sz, 0, sz),
            Position               = UDim2.new(0.5, -sz / 2, 0.5, -sz / 2),
            BackgroundTransparency = 1,
        }, 0.55, Enum.EasingStyle.Quart)
        Debris:AddItem(r, 0.65)
    end

    return U
end
