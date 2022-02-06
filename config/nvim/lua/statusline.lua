local heirline = require("heirline")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local colors = {
    active = utils.get_highlight("StatusLine"),
    inactive = utils.get_highlight("StatusLineNC"),
}

local padding = {
    provider = function(self)
        return "  "
    end,
}

local filename = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,

    provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":.")

        if filename == "" then
            return "[No Name]"
        end

        if vim.bo.buftype == "help" then
            return vim.fn.fnamemodify(filename, ":t")
        end

        if not conditions.width_percent_below(#filename, 0.75) then
            filename = vim.fn.fnamemodify(filename, ":t")
        end

        return filename
    end,
}

local filename_flag = {
    {
        provider = function()
            if vim.bo.modified then
                return " [+]"
            end
        end,
    },
    {
        provider = function()
            if not vim.bo.modifiable then
                return " [-]"
            end
        end,
    },
}

local divider = {
    provider = "%=",
}

local ruler = {
    provider = "%l:%L",
}

local inactive_statusline = {
    condition = function()
        return not conditions.is_active()
    end,

    padding,
    filename,
    filename_flag,
    divider,
    padding,
}

local active_statusline = { padding, filename, filename_flag, divider, ruler, padding }

heirline.setup({
    hl = function()
        if conditions.is_active() then
            return {
                fg = utils.get_highlight("StatusLine").fg,
                bg = utils.get_highlight("StatusLine").bg,
                style = "bold",
            }
        else
            return {
                fg = utils.get_highlight("StatusLineNC").fg,
                bg = utils.get_highlight("StatusLineNC").bg,
            }
        end
    end,

    stop_at_first = true,

    inactive_statusline,
    active_statusline,
})
