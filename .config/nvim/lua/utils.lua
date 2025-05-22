local M = {}

function M.augroup(name)
    vim.api.nvim_create_augroup(name, { clear = true })
end

function M.filter(arr, fn)
    if type(arr) ~= "table" then
        return arr
    end

    local filtered = {}
    for k, v in pairs(arr) do
        if fn(v, k, arr) then
            table.insert(filtered, v)
        end
    end

    return filtered
end

M.autocmd = vim.api.nvim_create_autocmd

M.command = vim.api.nvim_create_user_command

M.buf_command = vim.api.nvim_buf_create_user_command

M.unmap = vim.keymap.del
M.map = vim.keymap.set
M.map_c = function(lhs, rhs, opts)
    vim.keymap.set("n", lhs, function()
        local ok, result = pcall(vim.cmd, rhs)
        if not ok then
            vim.api.nvim_err_writeln(result)
        end
    end, opts)
end

M.table = {}

M.table.contains = function(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

M.set_indent_guide = function()
    local guide = string.rep(" ", vim.bo.shiftwidth - 1)
    vim.opt_local.list = true
    vim.opt_local.listchars = {
        -- repeat enough times to not have to rely on the built-in repeat which
        -- will look off by one
        leadmultispace = " " .. string.rep(guide .. "│", 100),
    }
end

M.line_number = function()
    return vim.fn.line(".")
end

M.col_number = function()
    local line_number = M.line_number()
    return vim.fn.strchars(vim.fn.getline(line_number))
end

M.set_cursor_pos = function(line_number, col_number)
    vim.fn.setcursorcharpos({ line_number, col_number })
end

M.close_completion_menu = function()
    if vim.fn.pumvisible() ~= 0 then
        M.feed_keys(" <BS>") -- for some reason <C-y> will nuke the rest of the line if you are in completion mode and you haven't selected anything, so doing this instead
    end
end

M.feed_keys = function(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "", false)
end

M.system = function(cmd)
    local resp = vim.system(cmd, { text = true }):wait()
    if resp.code == 0 then
        return resp.stdout:gsub("\n", "")
    else
        return nil
    end
end

M.get_visual_range = function()
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == "" then
        local start_pos = vim.fn.getpos("v")[2]
        local end_pos = vim.fn.getcurpos()[2]

        local start_line = math.min(start_pos, end_pos)
        local end_line = math.max(start_pos, end_pos)

        print(start_line)
        print(end_line)
        return { start_line, end_line }
    else
        return nil
    end
end

M.get_github_url = function(opts)
    opts = opts or {}
    local mode = opts.mode or "blob"

    local git_root = M.system({ "git", "rev-parse", "--show-toplevel" })
    if git_root == nil then
        return nil
    end

    local commit_hash = M.system({ "git", "rev-parse", "HEAD" })
    if M.trim(M.system({ "git", "branch", "--remote", "--contains", commit_hash })) == "" then
        commit_hash = "main"
    end

    local remote_url = M.system({ "git", "remote", "get-url", "origin" })
    if commit_hash == nil or remote_url == nil then
        return nil
    end

    local github_path = remote_url:match("github%.com[:/](.+)%.git")
    if not github_path then
        return nil
    end

    local rel_path = vim.fn.expand("%:p"):sub(#git_root + 2)
    local github_url = "https://github.com/" .. github_path .. "/" .. mode .. "/" .. commit_hash .. "/" .. rel_path

    local visual_range = M.get_visual_range()
    if visual_range then
        local start_line = visual_range[1]
        local end_line = visual_range[2]
        if start_line == end_line then
            github_url = github_url .. "#L" .. start_line
        else
            github_url = github_url .. "#L" .. start_line .. "-L" .. end_line
        end
    end

    return github_url
end

M.trim = function(s)
    return s:gsub("^%s*(.-)%s*$", "%1")
end

return M
