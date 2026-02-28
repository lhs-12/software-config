--[[
    Yazi Plugin: wl-copy
    Description: Copy selected or hovered files to system clipboard using Wayland's wl-copy.
    Format: text/uri-list (standard for file managers)
    From plugin: grappas/wl-clipboard
]]

local get_paths = ya.sync(function()
    local tab, paths = cx.active, {}
    for _, u in pairs(tab.selected) do
        paths[#paths + 1] = tostring(u)
    end
    if #paths == 0 and tab.current.hovered then
        paths[1] = tostring(tab.current.hovered.url)
    end
    return paths
end)

local function url_encode(str)
    if str then
        str = str:gsub("\n", "\r\n")
        str = str:gsub("([^%w%-%._~:/])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
    end
    return str
end

return {
    entry = function()
        ya.emit("escape", { visual = true })

        local paths = get_paths()
        if #paths == 0 then
            return ya.notify({
                title = "Clipboard",
                content = "No files selected",
                level = "warn",
                timeout = 3
            })
        end

        local uri_list = {}
        for _, path in ipairs(paths) do
            table.insert(uri_list, "file://" .. url_encode(path))
        end
        local final_content = table.concat(uri_list, "\r\n") .. "\r\n"

        local child, err = Command("wl-copy")
            :arg("--type")
            :arg("text/uri-list")
            :arg(final_content)
            :spawn()

        if not child then
            return ya.notify({
                title = "Clipboard Error",
                content = "Failed to spawn wl-copy: " .. tostring(err),
                level = "error",
                timeout = 5
            })
        end

        local status = child:wait()
        if status and status.success then
            ya.notify({
                title = "Clipboard",
                content = string.format("Copied %d file(s)", #paths),
                level = "info",
                timeout = 3
            })
        else
            ya.notify({
                title = "Clipboard Error",
                content = "Exit code: " .. (status and status.code or "unknown"),
                level = "error",
                timeout = 5
            })
        end
    end,
}