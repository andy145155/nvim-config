function ColorMyPencils(color)
    color = color or "kanagawa"
    vim.cmd.colorscheme(color)

    -- Ensure transparency is applied
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    "rebelot/kanagawa.nvim",
    config = function()
        ColorMyPencils() -- Apply the theme and transparency
    end,
}
