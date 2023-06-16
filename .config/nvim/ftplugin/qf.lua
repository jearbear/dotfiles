local u = require("utils")

-- move QF window to the bottom-most position of the screen
vim.cmd("wincmd J")

u.map("n", "dd", "`D", { buffer = 0, remap = true })

u.map("n", "<BS>", "<Nop>", { buffer = 0 })
u.map_c("q", "q", { buffer = 0 })
u.map_c("Q", "q", { buffer = 0 })

u.buf_command(0, "Reject", function(args)
    local all = vim.fn.getqflist()
    local new = {}
    for _, entry in pairs(all) do
        if not string.find(vim.fn.bufname(entry.bufnr), args.args) and not string.find(entry.text, args.args) then
            table.insert(new, entry)
        end
    end
    vim.fn.setqflist(new)
    vim.fn.setqflist({}, "a", { title = "Reject: `" .. args.args .. "`" })
end, { nargs = 1 })

u.buf_command(0, "Keep", function(args)
    local all = vim.fn.getqflist()
    local new = {}
    for _, entry in pairs(all) do
        if string.find(vim.fn.bufname(entry.bufnr), args.args) or string.find(entry.text, args.args) then
            table.insert(new, entry)
        end
    end
    vim.fn.setqflist(new)
    vim.fn.setqflist({}, "a", { title = "Keep: `" .. args.args .. "`" })
end, { nargs = 1 })
