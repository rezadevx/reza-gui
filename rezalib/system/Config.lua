return function(Library)
    function Library:SaveConfig(name)
        local data = {}
        for k, v in pairs(self.Flags) do
            local t = type(v)
            if t == "number" or t == "boolean" or t == "string" then
                data[k] = v
            end
        end
        local ok = pcall(function()
            local json = game:GetService("HttpService"):JSONEncode(data)
            writefile("RezaLib_" .. (name or "config") .. ".json", json)
        end)
        self:Notification({
            Title    = "Config",
            Content  = ok and "Saved successfully." or "Save failed (writefile unavailable).",
            Type     = ok and "Success" or "Error",
            Duration = 2,
        })
    end

    function Library:LoadConfig(name)
        local ok, raw = pcall(readfile, "RezaLib_" .. (name or "config") .. ".json")
        if not ok or not raw then
            self:Notification({
                Title    = "Config",
                Content  = "No config file found.",
                Type     = "Warning",
                Duration = 2,
            })
            return
        end
        local ok2, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(raw)
        end)
        if not ok2 then return end
        for k, v in pairs(data) do
            Library.Flags[k] = v
        end
        self:Notification({
            Title    = "Config",
            Content  = "Loaded successfully.",
            Type     = "Success",
            Duration = 2,
        })
    end

    function Library:Destroy()
        for _, c in ipairs(self.Connections) do
            pcall(function() c:Disconnect() end)
        end
        self.Connections = {}
        if self._gui then
            pcall(function() self._gui:Destroy() end)
            self._gui = nil
        end
        self.Windows = {}
        self.Flags   = {}
    end
end
