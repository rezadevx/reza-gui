return function(Library, Theme, U)
    return function(Sec, items)
        function Sec:Paragraph(c)
            c = c or {}
            local pname = c.Name    or ""
            local ptext = c.Content or ""

            local row = U.New("Frame", {
                Name                   = "Paragraph",
                BackgroundColor3       = Theme.Surface,
                BackgroundTransparency = 0.45,
                Size                   = UDim2.new(1, 0, 0, 0),
                AutomaticSize          = Enum.AutomaticSize.Y,
                ZIndex                 = 16,
                Parent                 = items,
            })
            U.Corner(row, 7)
            U.Padding(row, 10, 12, 10, 12)
            U.List(row, 4)

            if pname ~= "" then
                U.New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size           = UDim2.new(1, 0, 0, 18),
                    Text           = pname,
                    Font           = Enum.Font.GothamBold,
                    TextSize       = 13,
                    TextColor3     = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex         = 17,
                    Parent         = row,
                })
            end

            local bodyL = U.New("TextLabel", {
                BackgroundTransparency = 1,
                Size           = UDim2.new(1, 0, 0, 0),
                AutomaticSize  = Enum.AutomaticSize.Y,
                Text           = ptext,
                Font           = Enum.Font.Gotham,
                TextSize       = 12,
                TextColor3     = Theme.TextSecond,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped    = true,
                ZIndex         = 17,
                Parent         = row,
            })

            local El = {}
            function El:SetContent(t) bodyL.Text = t end
            function El:SetTitle(t) pname = t end
            return El
        end
    end
end
