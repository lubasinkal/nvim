local M = {}

function M.setup()
    -- Global state for mini.icons (lazy init)
    local mini_icons_setup = false
    local icons = nil -- will require only when needed

    -- Create tabline with buffer information
    local function generate_tabline()
        local tabline_elements = {}
        local current_buf = vim.api.nvim_get_current_buf()

        -- Use vim.fn.getbufinfo() for faster buffer listing with filters
        -- It returns a list of dicts with buf info, including 'listed'
        local buf_infos = vim.fn.getbufinfo({ buflisted = 1 })
        local listed_buffers = {}
        for _, info in ipairs(buf_infos) do
            table.insert(listed_buffers, info.bufnr)
        end

        -- Early return if <=1 buffer (tabline hidden anyway)
        if #listed_buffers <= 1 then
            return ""
        end

        -- Lazy init mini.icons only when actually needed (first time >1 buffers)
        local has_mini_icons = false
        if not mini_icons_setup then
            has_mini_icons, icons = pcall(require, "mini.icons")
            if has_mini_icons then
                icons.setup() -- init once
                mini_icons_setup = true
            end
        else
            has_mini_icons = true -- already setup
        end

        -- Left truncation marker
        table.insert(tabline_elements, "%<")

        for i, buf in ipairs(listed_buffers) do
            -- Get buffer name (use buf_info for speed where possible)
            local buf_info = buf_infos[i] -- aligned by index
            local buf_name = buf_info.name ~= "" and vim.fn.fnamemodify(buf_info.name, ":t") or "[No Name]"

            -- Truncate long names
            if #buf_name > 20 then
                buf_name = buf_name:sub(1, 17) .. "..."
            end

            local icon = " " -- fallback

            if has_mini_icons and icons then
                -- Try by full filename first
                local ok, icon_str = pcall(icons.get, "file", buf_name)
                if ok and icon_str and icon_str ~= "" then
                    icon = icon_str .. " "
                else
                    -- Fallback to extension
                    local ext = vim.fn.fnamemodify(buf_name, ":e")
                    if ext and ext ~= "" then
                        local ext_ok, ext_icon = pcall(icons.get, "extension", ext)
                        if ext_ok and ext_icon and ext_icon ~= "" then
                            icon = ext_icon .. " "
                        end
                    end
                end
            end -- Modified indicator (from buf_info)
            local modified = buf_info.changed == 1 and " ●" or ""

            -- Diagnostics (only compute if vim.diagnostic exists)
            local diagnostics = ""
            if vim.diagnostic then
                pcall(function()
                    local error_count = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR })
                    local warn_count = #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.WARN })
                    if error_count > 0 then
                        diagnostics = diagnostics .. "  " .. error_count
                    end
                    if warn_count > 0 then
                        diagnostics = diagnostics .. "  " .. warn_count
                    end
                end)
            end

            -- Highlight based on current buffer
            local hl = (buf == current_buf) and "%#TabLineSel#" or "%#TabLine#"

            -- Build the tab item
            local tab_item = string.format("%s %s%s%s%s ", hl, icon, buf_name, modified, diagnostics)

            -- Add click handler
            tab_item = string.format("%%%d@v:lua.BufSelect@%s%%T", i, tab_item)

            -- Add separator
            if i < #listed_buffers then
                tab_item = tab_item .. "%#TabLineFill#│"
            end

            table.insert(tabline_elements, tab_item)
        end

        -- Right side (filler)
        table.insert(tabline_elements, "%=%#TabLineFill#%#TabLine#")

        return table.concat(tabline_elements)
    end

    -- Click handler function
    _G.BufSelect = function(buf_idx, _, _, _)
        -- Optimized buffer list
        local bufs = {}
        for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
            table.insert(bufs, info.bufnr)
        end
        local idx = tonumber(buf_idx)
        if idx and idx <= #bufs then
            vim.cmd("buffer " .. bufs[idx])
        end
        return ""
    end

    -- Global tabline function
    _G.tabline = generate_tabline

    -- Dynamic refresh: set showtabline + update tabline content
    local function refresh_tabline()
        -- Fast count of listed buffers
        local listed_count = #vim.fn.getbufinfo({ buflisted = 1 })

        if listed_count <= 1 then
            vim.o.showtabline = 0
        else
            vim.o.showtabline = 2
            vim.o.tabline = "%!v:lua.tabline()"
        end
    end

    -- Initial setup
    refresh_tabline() -- apply correct showtabline right away

    -- Auto-refresh on relevant events
    local augroup = vim.api.nvim_create_augroup("NativeTabs", { clear = true })

    vim.api.nvim_create_autocmd(
        { "BufEnter", "BufLeave", "BufDelete", "BufNew", "BufNewFile", "BufReadPost" },
        { group = augroup, callback = refresh_tabline }
    )

    vim.api.nvim_create_autocmd("OptionSet", {
        group = augroup,
        pattern = { "modified" },
        callback = refresh_tabline,
    })

    vim.api.nvim_create_autocmd("DiagnosticChanged", {
        group = augroup,
        callback = refresh_tabline,
    })

    -- Key mappings (unchanged, but local to setup)
    local map = vim.keymap.set

    -- Buffer navigation (optimized buffer list)
    map("n", "<Tab>", function()
        local bufs = {}
        for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
            table.insert(bufs, info.bufnr)
        end
        local current = vim.api.nvim_get_current_buf()
        for i, buf in ipairs(bufs) do
            if buf == current then
                local next_buf = bufs[i + 1] or bufs[1]
                vim.cmd("buffer " .. next_buf)
                break
            end
        end
    end, { desc = "Next buffer" })

    map("n", "<S-Tab>", function()
        local bufs = {}
        for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
            table.insert(bufs, info.bufnr)
        end
        local current = vim.api.nvim_get_current_buf()
        for i, buf in ipairs(bufs) do
            if buf == current then
                local prev_buf = bufs[i - 1] or bufs[#bufs]
                vim.cmd("buffer " .. prev_buf)
                break
            end
        end
    end, { desc = "Previous buffer" })

    -- Buffer management
    map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "[B]uffer [D]elete" })
    map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "[B]uffer [N]ew" })
end

-- Run setup automatically
M.setup()

return M
