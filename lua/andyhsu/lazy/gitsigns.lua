return {
    "lewis6991/gitsigns.nvim",
    config = function ()
        require("gitsigns").setup()

        vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
        vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle blame" })
        vim.keymap.set("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
        vim.keymap.set("n", "<leader>gR", ":Gitsigns reset_buffer<CR>", { desc = "Reset entire buffer" })
        vim.keymap.set("n", "<leader>gS", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
        vim.keymap.set("n", "<leader>gU", ":Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk" })
        vim.keymap.set("n", "]c", ":Gitsigns next_hunk<CR>", { desc = "Next hunk" })
        vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })
    end
}
