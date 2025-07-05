return {
    "tpope/vim-fugitive",
    config = function()
        -- Git keymaps are now in centralized keymaps.lua
        -- Additional fugitive-specific mappings
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>", { desc = "Get diff from left (ours)" })
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { desc = "Get diff from right (theirs)" })
    end
}
