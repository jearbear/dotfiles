local u = require("utils")

-- nvim-treesitter {{{
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "comment",
        -- "eex",
        -- "elixir", -- TODO: Uncomment once 0.7 fixes performance issues
        "go",
        "graphql",
        -- "heex",
        "javascript",
        "json",
        "lua",
        "make",
        "markdown",
        "python",
        "regex",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "yaml",
    },
    highlight = { enable = true },
    indent = { enable = true },
    endwise = { enable = true },
})
-- }}}

-- stabilize.nvim {{{
-- require("stabilize").setup({})
-- }}}

-- pretty-fold.nvim {{{
require("pretty-fold").setup({
    fill_char = "·",
})

require("pretty-fold.preview").setup({
    key = "l",
    border = "single",
})
-- }}}

-- gitlinker.nvim {{{
require("gitlinker").setup({
    opts = {
        remote = "origin",
        add_current_line_on_normal_mode = false,
        print_url = true,
    },
    mappings = "<Leader>gl",
})
-- }}}

-- gitsigns.nvim {{{
require("gitsigns").setup({
    on_attach = function(buf_number)
        u.buf_nnoremap_c(buf_number, "<Leader>gb", "lua require('gitsigns').blame_line()")
    end,
})
-- }}}

-- diffview.nvim {{{
require("diffview").setup({
    use_icons = false,
    enhanced_diff_hl = true,
})
-- }}}

-- Comment.nvim {{{
require("Comment").setup({})
-- }}}

-- nvim-autopairs {{{
require("nvim-autopairs").setup({
    disable_in_macro = true,
    disable_in_visualblock = true,
})
-- }}}

-- nvim-bqf {{{
require("bqf").setup({
    auto_resize_height = true,
    func_map = {
        ptogglemode = "Z",
        stogglebuf = "`",
        filter = "K",
        filterr = "D",
    },
})
-- }}}

-- marks.nvim {{{
require("marks").setup({
    default_mappings = false,
    mappings = {
        set_bookmark2 = "mm",
        next_bookmark2 = "<Tab>",
        prev_bookmark2 = "<S-Tab>",
        delete_bookmark = "dm",
        delete_bookmark2 = "dM",
    },
})
-- }}}

-- nvim-snippy {{{
require("snippy").setup({
    mappings = {
        is = {
            ["<C-l>"] = "expand_or_advance",
            ["<C-h>"] = "previous",
        },
    },
})
-- }}}

-- nvim-cmp + friends {{{
local cmp = require("cmp")
local snippy = require("snippy")

cmp.setup({
    preselect = cmp.PreselectMode.None,

    snippet = {
        expand = function(args)
            snippy.expand_snippet(args.body)
        end,
    },

    mapping = {
        ["<C-l>"] = cmp.mapping(function(fallback)
            if snippy.can_expand_or_advance() then
                snippy.expand_or_advance()
            elseif cmp.visible() then
                cmp.confirm()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function(fallback)
            if snippy.can_jump(-1) then
                snippy.previous()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-d>"] = cmp.config.disable,
        ["<C-f>"] = cmp.config.disable,
        ["<C-e>"] = cmp.config.disable,
        ["<C-Space>"] = cmp.config.disable,
    },

    sources = cmp.config.sources({
        { name = "nvim_lsp_signature_help" },
    }, {
        { name = "nvim_lsp" },
        { name = "snippy" },
    }),

    experimental = {
        ghost_text = true,
    },
})

-- properly insert braces after completing functions
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})
-- }}}

-- vim-grepper {{{
vim.g.grepper = {
    prompt_text = "$t> ",
    tools = { "rg" },
    stop = 1000,
    prompt_quote = 2, -- populate prompt with single quotes
    searchreg = 1, -- load query into search register (allows hitting `n` to navigate results in quickfix list)
}

u.nnoremap_c("<Bslash>", "Grepper")
u.nmap("gs", "<Plug>(GrepperOperator)")
u.xmap("gs", "<Plug>(GrepperOperator)")
-- }}}

-- targets.vim {{{
vim.g.targets_seekRanges = "cc cr cb cB lc ac Ac" -- ranges on the cursor
    .. " lr" -- range around the cursor, fully contained on the same line
    .. " rr" -- range ahead of the cursor, fully contained on the same line
    .. " lb ar ab lB Ar aB Ab AB" -- ranges around the cursor, multiline
    .. " ll" -- ranges behind the cursor, fully contained on the same line
-- }}}

-- vim-rsi {{{
vim.g.rsi_no_meta = true
-- }}}

-- fzf.vim {{{
vim.g.fzf_layout = { window = { width = 0.95, height = 0.95, border = "sharp" } }
vim.g.fzf_action = {
    ["ctrl-t"] = "tab split",
    ["ctrl-s"] = "split",
    ["ctrl-v"] = "vsplit",
}
vim.g.fzf_preview_window = { "up:80%,border-sharp", "ctrl-/" }

u.nnoremap_c("<Leader>f", "Files")
u.nnoremap_c("<Leader>F", "GFiles?")
u.nnoremap_c("<Leader>l", "Buffers")
u.nnoremap_c("<Leader>;", "BLines")
u.nnoremap_c("<Leader>:", "History:")
u.nnoremap_c("<Leader>k", "BTags")
u.nnoremap_c("<Leader>h", "Help")
u.nnoremap_c("<Leader>m", "Marks")
u.nnoremap_c("<Bar>", "Rg")

-- TODO: Convert this to Lua
vim.cmd([[
function! DeleteBuffers()
    function! s:delete_buffers(lines)
        execute 'bwipeout' join(map(a:lines, {_, line -> matchstr(line, '\[\zs[0-9]*\ze\]')}))
    endfunction

    let sorted = fzf#vim#_buflisted_sorted()
    let header_lines = '--header-lines=' . (bufnr('') == get(sorted, 0, 0) ? 1 : 0)
    let tabstop = len(max(sorted)) >= 4 ? 9 : 8
    return fzf#run(fzf#wrap(fzf#vim#with_preview({
                \ 'source':  map(sorted, 'fzf#vim#_format_buffer(v:val)'),
                \ 'sink*':   { lines -> s:delete_buffers(lines) },
                \ 'options': ['+m', '-x', '--tiebreak=index', header_lines, '--ansi', '-d', '\t', '--with-nth', '3..', '-n', '2,1..2', '--prompt', 'BufDel> ', '--preview-window', '+{2}-/2', '--tabstop', tabstop, '--multi']
                \})))
endfunction
]])

u.nnoremap_c("<Leader>L", "call DeleteBuffers()")
-- }}}

-- vim-yoink {{{
vim.g.yoinkAutoFormatPaste = true
vim.g.yoinkIncludeDeleteOperations = true

u.nmap("<C-n>", "<Plug>(YoinkPostPasteSwapForward)")
u.nmap("<C-p>", "<Plug>(YoinkPostPasteSwapBack)")

u.nmap("P", "<Plug>(YoinkPaste_P)")
u.nmap("p", "<Plug>(YoinkPaste_p)")

u.nmap("[y", "<Plug>(YoinkRotateBack)")
u.nmap("]y", "<Plug>(YoinkRotateForward)")

u.nmap("y", "<Plug>(YoinkYankPreserveCursorPosition)")
u.xmap("y", "<Plug>(YoinkYankPreserveCursorPosition)")

u.nmap("<C-[>", "<Plug>(YoinkPostPasteToggleFormat)")
-- }}}

-- vim-subversive {{{
u.nmap("S", "<Plug>(SubversiveSubstituteToEndOfLine)")
u.nmap("s", "<Plug>(SubversiveSubstitute)")
u.nmap("ss", "<Plug>(SubversiveSubstituteLine)")
u.xmap("P", "<Plug>(SubversiveSubstitute)")
u.xmap("p", "<Plug>(SubversiveSubstitute)")
u.xmap("s", "<Plug>(SubversiveSubstitute)")
-- }}}

-- Comment.nvim {{{
u.nmap("<Leader>/", "gcc")
u.vmap("<Leader>/", "gc")
-- }}}

-- vim-bbye {{{
u.nnoremap_c("Q", "Bwipeout")
-- }}}

-- vim-startify {{{
vim.g.startify_change_to_dir = false
vim.g.startify_relative_path = true
vim.g.startify_session_delete_buffers = true
vim.g.startify_session_persistence = true
vim.g.startify_update_oldfiles = true

vim.g.startify_custom_header = {}

vim.g.startify_commands = {}
vim.g.startify_bookmarks = {
    { df = "~/.dotfiles" },
    { dp = "~/.dotfiles.pipe" },
    { sn = "~/snippets.md" },
}
vim.g.startify_lists = {
    { type = "dir", header = { "   Latest Edits" } },
    { type = "bookmarks", header = { "   Bookmarks" } },
    { type = "sessions", header = { "   Sessions" } },
    { type = "commands", header = { "   Commands" } },
}

u.nnoremap_c("<Leader>S", "Startify")
u.nnoremap_c("<Leader>sc", "SClose")

local git_session_name = function()
    if vim.g.gitsigns_head == nil or vim.g.gitsigns_head == "" then
        return ""
    end

    return vim.g.gitsigns_head:gsub("^jerry%-", "")
end

SaveGitBranchSession = function()
    local name = git_session_name()
    if name == "" then
        return
    end
    vim.api.nvim_command("SSave! " .. name)
end
u.nnoremap_c("<Leader>ss", "lua SaveGitBranchSession()")

LoadGitBranchSession = function()
    local name = git_session_name()
    if name == "" then
        return
    end
    vim.api.nvim_command("SLoad! " .. name)
end
u.nnoremap_c("<Leader>sl", "lua LoadGitBranchSession()")

DeleteGitBranchSession = function()
    local name = git_session_name()
    if name == "" then
        return
    end
    vim.api.nvim_command("SDelete! " .. name)
end
u.nnoremap_c("<Leader>sd", "lua DeleteGitBranchSession()")
-- }}}

-- vim-matchup {{{
vim.g.matchup_matchparen_offscreen = { method = "popup" }
-- }}}

-- diffview.nvim {{{
u.nnoremap_c("<Leader>gd", "DiffviewFileHistory")
-- }}}

-- vim-test {{{
vim.cmd([[
function! CopyStrategy(cmd) range
    let @+ = a:cmd
    echo a:cmd
endfunction

let g:test#custom_strategies = {'copy': function('CopyStrategy')}
let g:test#strategy = 'copy'
]])

u.nnoremap_c("<Leader>tf", "TestFile")
u.nnoremap_c("<Leader>tl", "TestNearest")
u.nnoremap_c("<Leader>tt", "TestNearest -strategy=basic")
-- }}}
