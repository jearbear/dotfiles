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

        return { start_line, end_line }
    else
        return nil
    end
end

M.git_root_path = function()
    return M.system({ "git", "rev-parse", "--show-toplevel" })
end

M.github_remote_url = function()
    local git_repo = M.system({ "git", "remote", "get-url", "origin" }):match("github%.com[:/](.+)%.git")
    if git_repo then
        return "https://github.com/" .. git_repo
    end
    return nil
end

M.git_relative_path = function()
    local git_root_path = M.git_root_path()
    if git_root_path then
        return vim.fn.expand("%:p"):sub(#git_root_path + 2)
    else
        return nil
    end
end

M.git_commit_hash = function()
    local commit_hash = M.system({ "git", "rev-parse", "HEAD" })
    if M.trim(M.system({ "git", "branch", "--remote", "--contains", commit_hash })) == "" then
        commit_hash = "main"
    end
    return commit_hash
end

M.github_pr_number = function()
    local line_number = M.line_number()
    local commit_description = M.system({
        "git",
        "log",
        "-s",
        "-1",
        "-L",
        string.format("%i,%i:%s", line_number, line_number, vim.fn.bufname()),
    })
    if commit_description then
        return commit_description:match("%(#(%d+)%)")
    else
        return nil
    end
end

M.get_github_url = function(opts)
    opts = opts or {}
    local mode = opts.mode or "blob"

    local remote_url = M.github_remote_url()
    local commit_hash = M.git_commit_hash()
    local relative_path = M.git_relative_path()

    if remote_url == nil or commit_hash == nil or relative_path == nil then
        return nil
    end

    local github_url = table.concat({ remote_url, mode, commit_hash, relative_path }, "/")

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

M.get_github_pr_url = function()
    local remote_url = M.github_remote_url()
    local pr_number = M.github_pr_number()

    if remote_url == nil or pr_number == nil then
        return nil
    end

    return table.concat({ remote_url, "pull", pr_number, "files" }, "/")
end

M.trim = function(s)
    return s:gsub("^%s*(.-)%s*$", "%1")
end

M.kitty_send_text = function(lines)
    if vim.uv.os_uname().sysname == "Linux" then
        M.system({ "niri", "msg", "action", "focus-column-right" })
        dest_window = vim.json.decode(M.system({ "niri", "msg", "--json", "focused-window" }), {})
        if dest_window.app_id == "kitty" then
            M.system({
                "kitten",
                "@",
                "send-text",
                "--match",
                "state:focused",
                "--bracketed-paste",
                "enable",
                M.trim(table.concat(lines, "\n")) .. "\n",
            })
            M.system({
                "kitten",
                "@",
                "send-text",
                "--match",
                "state:focused",
                "\n",
            })
        else
            print("Neighboring window is not a kitty terminal")
        end
        M.system({ "niri", "msg", "action", "focus-window-previous" })
    else
        M.system({
            "kitten",
            "@",
            "send-text",
            "--match",
            "neighbor:right",
            "--bracketed-paste",
            "enable",
            M.trim(table.concat(lines, "\n")) .. "\n",
        })
        M.system({
            "kitten",
            "@",
            "send-text",
            "--match",
            "neighbor:right",
            "\n",
        })
    end
end

M.open_url = function(url)
    if vim.uv.os_uname().sysname == "Linux" then
        M.system({ "xdg-open", url })
    else
        M.system({ "open", url })
    end
end

M.expand_snippet = function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local prefix = line:sub(1, col):match("%S+$")
    if not prefix then
        vim.notify("No snippet to expand", vim.log.levels.ERROR)
        return nil
    end

    local ok, snippets = pcall(require, "snippets." .. vim.bo.filetype)
    if not ok then
        vim.notify("No snippets defined for " .. vim.bo.filetype .. " filetype", vim.log.levels.ERROR)
        return nil
    end

    local snippet = vim.iter(snippets):find(function(x)
        return x.prefix == prefix
    end)
    if not snippet then
        global_snippets = require("snippets.global")
        snippet = vim.iter(global_snippets):find(function(x)
            return x.prefix == prefix
        end)
    end
    if not snippet then
        vim.notify("No snippets defined for " .. prefix .. " prefix", vim.log.levels.ERROR)
        return nil
    end

    local snippet_body = snippet.body
        :gsub("%$CURRENT_YEAR", os.date("%Y"))
        :gsub("%$CURRENT_MONTH", os.date("%m"))
        :gsub("%$CURRENT_DATE", os.date("%d"))

    vim.api.nvim_set_current_line(line:sub(1, col - #prefix) .. line:sub(col + 1))
    vim.api.nvim_win_set_cursor(0, { row, col - #prefix })
    vim.snippet.expand(snippet_body)
end

return M
