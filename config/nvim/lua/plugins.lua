local u = require("utils")

-- nvim-treesitter {{{
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "go",
        "javascript",
        "json",
        "lua",
        "make",
        "python",
        "regex",
        "rust",
        "typescript",
        "vim",
        "yaml",
    },
    highlight = { enable = true },
    indent = { enable = true },
    endwise = { enable = true },
})
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
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
local snippy = require("snippy")

cmp.setup({
    snippet = {
        expand = function(args)
            snippy.expand_snippet(args.body)
        end,
    },

    mapping = {
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false })),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-l>"] = cmp.mapping(function(fallback)
            if snippy.can_expand_or_advance() then
                snippy.expand_or_advance()
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
    },

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "snippy" },
    }),

    experimental = {
        ghost_text = true,
    },
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})
-- }}}

-- vim-qf {{{
u.nmap("<Leader>qq", "<Plug>(qf_qf_toggle)")
u.nmap("<Leader>ql", "<Plug>(qf_loc_toggle)")
u.nmap("[q", "<Plug>(qf_qf_previous)")
u.nmap("]q", "<Plug>(qf_qf_next)")
u.nmap("[l", "<Plug>(qf_loc_previous)")
u.nmap("]l", "<Plug>(qf_loc_next)")
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
vim.g.fzf_history_dir = "~/.fzf-history"
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
vim.g.startify_session_persistence = true
vim.g.startify_session_delete_buffers = true
vim.g.startify_change_to_dir = false
vim.g.startify_relative_path = true
vim.g.startify_commands = {}
vim.g.startify_bookmarks = {
    { vv = "~/.config/nvim/init.vim" },
    { vl = "~/.config/nvim/lua/lsp.lua" },
    { vp = "~/.config/nvim/lua/plugins.lua" },
    { vs = "~/.config/nvim/lua/statusline.lua" },
}
vim.g.startify_fortune_use_unicode = true
vim.g.startify_lists = {
    { type = "dir", header = { "   Latest Edits" } },
    { type = "bookmarks", header = { "   Bookmarks" } },
    { type = "sessions", header = { "   Sessions" } },
    { type = "commands", header = { "   Commands" } },
}

u.nnoremap("<Leader>ss", ":SSave!<Space>")
u.nnoremap("<Leader>sl", ":SLoad!<Space>")
u.nnoremap("<Leader>sd", ":SDelete!<Space>")
u.nnoremap_c("<Leader>S", "Startify")
u.nnoremap_c("<Leader>sc", "SClose")
-- }}}

-- vim-matchup {{{
vim.g.matchup_matchparen_offscreen = { method = "popup" }
-- }}}

-- diffview.nvim {{{
u.nnoremap_c("<leader>gd", "DiffviewFileHistory")
-- }}}
