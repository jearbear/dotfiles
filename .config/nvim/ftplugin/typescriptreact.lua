vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2

-- Workaround for extra periods getting inserted for completions:
-- https://github.com/echasnovski/mini.nvim/issues/306#issuecomment-1517954136
vim.b.minicompletion_config = {
    lsp_completion = {
        process_items = function(items, base)
            for _, item in ipairs(items) do
                local new_text = (item.textEdit or {}).newText
                if type(new_text) == "string" then
                    item.textEdit.newText = new_text:gsub("^%.+", "")
                end
            end

            return MiniCompletion.default_process_items(items, base)
        end,
    },
}
